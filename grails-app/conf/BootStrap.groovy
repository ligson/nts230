import com.boful.bmc.app.IFileQuery
import com.boful.common.file.utils.FileUtils
import com.boful.nts.SVNUtils
import com.boful.nts.SqlFileExecutor
import com.boful.nts.utils.SystemConfig
import grails.converters.JSON
import groovy.sql.GroovyRowResult
import nts.meta.domain.MetaDefine
import nts.program.domain.Program
import nts.program.domain.Serial
import nts.system.domain.Lang
import nts.system.domain.LogsPublic
import nts.system.domain.ServerNode
import nts.system.domain.SysConfig
import nts.user.domain.Consumer
import nts.utils.BfConfig
import nts.utils.CTools
import org.apache.commons.codec.binary.Hex
import org.apache.http.NameValuePair
import org.apache.http.client.HttpClient
import org.apache.http.client.entity.UrlEncodedFormEntity
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpPost
import org.apache.http.impl.client.HttpClients
import org.apache.http.message.BasicNameValuePair
import org.codehaus.groovy.grails.web.json.JSONElement

import groovy.sql.Sql

//import org.codehaus.groovy.grails.commons.ApplicationHolder
import org.springframework.context.ApplicationContext

import javax.servlet.ServletContext
import java.sql.SQLException
import java.text.DecimalFormat

class BootStrap {
    def distributeService
    def metaDefineService
    def grailsApplication
    def userService
    def programService
    def utilService
    def commonService
    def licenseManagerService
    def appService
    def timePlanJobService
    def searchService;
    def programCategoryService;
    def fileQuery
    def courseAppService
    def init = { ServletContext servletContext ->
        //svn 版本号
        //int lastVersion = SVNUtils.getLastVersion();
        //print(lastVersion)

        long startTime = System.currentTimeMillis();
        log.info("准备启动项目:")
        SystemConfig.initWebRootDir(servletContext);
        log.info("初始化配置文件成功！")

        log.info("初始化系统常量")
        //初始化应用
        initApp(servletContext);

        //初始化master用户
//        initMaster();
        log.info("检查master账户")
        userService.initMaster();
        log.info("检查匿名账户")
        //初始化匿名用户
        initAnonymityUser(servletContext);

        log.info("修正文件hash");
        updateSerialFileHash();

        log.info("配置用户语言");
        //初始化语言
        initLang();

        log.info("配置系统资源分类");
        //初始化分类
        programCategoryService.initCategory();
        programCategoryService.syncProgramCategory();

        log.info("修正时长");
        //fixTimeLength(servletContext)

        log.info("初始化系统权限");
        //权限初始化
        commonService.init();

        //读取license文件
        log.info("检查license");
        licenseManagerService.checkLicense();

        log.info("初始化系统服务接口");
        initAppService();

        log.info("修正数据库！")
        initConsumerCanPlay();
        initForumBoardState();
        rmsversionUpdate(servletContext);
        initProgramScore();
        initProgramRemarkNum();

        log.info("开始系统计划任务")
        timePlanJobService.startTimePlanJob();

        if (servletContext.searchEnable) {
            log.info("搜索服务已开启！");
            searchService.init(servletContext);
        } else {
            log.info("搜索服务未开启！")
        }
        courseAppService.initRMIFactory();
        log.info("rms v3.0 启动成功");
        long endTime = System.currentTimeMillis();
        long useTime = endTime - startTime;
        log.info("耗时：" + (useTime / 1000) + "秒");
    }

    private void initAppService() {
        String localWebPort = SysConfig.findByConfigName('LocalWebPort')?.configValue;    //省中心web服务器端口
        String localWebIp = SysConfig.findByConfigName('LocalWebIp')?.configValue;//本地web服务器端口
        String videoServ = SysConfig.findByConfigName('VideoSevr')?.configValue;
        String videoPort = SysConfig.findByConfigName("videoPort")?.configValue;
        String serverNodePort = SysConfig.findByConfigName("serverNodePort")?.configValue;
        if ((videoServ != null) && (videoPort != null) && (serverNodePort != null) && (localWebIp != null) && (localWebPort != null)) {
            appService.initAppService();
        }
    }

    private static void updateSerialFileHash() {
        List<Serial> serialList = Serial.findAllByFileHashIsNullAndFilePathIsNotNull();
        serialList.each { Serial serial ->
            File dest = new File(serial.filePath);
            if (dest.exists() && dest.isFile()) {
                serial.fileHash = Hex.encodeHexString(FileUtils.getHash(dest)).toUpperCase();
                String[] types = dest.name.split("\\.");
                serial.fileType = types[types.length - 1];
                serial.save();
            }
        }
    }

    private static void initMaster() {
        int count = Consumer.count();
        if (count == 0) {
            Consumer master = new Consumer();
            master.name = "master";
            master.nickname = "超级管理员";
            master.password = "password".encodeAsPassword();
            master.isRegister = false;
            master.notExamine = true;
            master.role = 0;
            master.uploadState = Consumer.CAN_UPLOAD_STATE;
            if ((!master.save(flush: true)) || master.hasErrors()) {
                println("管理员初始化错误！");
            } else {
                println("管理员初始化成功！")
            }
        }
    }

    private static void initAnonymityUser(ServletContext servletContext) {
        String anonymityUserName = servletContext.anonymityUserName;
        String anonymityPassword = servletContext.anonymityPassword;
        if (anonymityUserName && anonymityPassword) {
            int count = Consumer.countByName(anonymityUserName);
            if (count == 0) {
                Consumer anonymity = new Consumer();
                anonymity.name = anonymityUserName;
                anonymity.nickname = "匿名用户";
                anonymity.password = anonymityPassword.encodeAsPassword();
                anonymity.isRegister = false;
                anonymity.notExamine = true;
                anonymity.role = 3;
                anonymity.uploadState = Consumer.NO_UPLOAD_STATE;
                if ((!anonymity.save(flush: true)) || anonymity.hasErrors()) {
                    println("匿名用户初始化错误！");
                } else {
                    println("匿名用户初始化成功！")
                }
            }
        }
    }


    private void initApp(ServletContext servletContext) {
        //获取系统公告
        def sysNotice = SysConfig.findByConfigName("SysNotice") ? SysConfig.findByConfigName("SysNotice").configValue : "";
        servletContext.sysNotice = sysNotice

        def videoPort = SysConfig.findByConfigName("videoPort") ? SysConfig.findByConfigName("videoPort").configValue : "1680";
        //视频服务器端口
        def uploadPort = SysConfig.findByConfigName("uploadPort") ? SysConfig.findByConfigName("uploadPort").configValue : "1670";

        //上传文件最大容量
        def fileSizeLimit = SysConfig.findByConfigName("fileSizeLimit") ? SysConfig.findByConfigName("fileSizeLimit").configValue : "0";

        //上载服务器端口
        servletContext.metaTitleId = MetaDefine.findByName('Title')?.id
        servletContext.metaCreatorId = MetaDefine.findByName('Contributor')?.id
        servletContext.metaDisciplineId = MetaDefine.findByName('CLC_Class_Name')?.id

        //servletContext.metaTitleId = nts.meta.domain.MetaDefine.findByName('title')?.id
        //servletContext.metaCreatorId = nts.meta.domain.MetaDefine.findByName('creator')?.id
        // servletContext.metaDisciplineId = nts.meta.domain.MetaDefine.findByName('discipline')?.id

        servletContext.uploadRootPath = SysConfig.findByConfigName('UploadRootPath')?.configValue
        servletContext.videoSevr = SysConfig.findByConfigName('VideoSevr')?.configValue //视频服务器IP
        servletContext.AbbrImgSize = SysConfig.findByConfigName('AbbrImgSize')?.configValue     //缩略图大小
        servletContext.AbbrImgRowPerNum = SysConfig.findByConfigName('AbbrImgRowPerNum')?.configValue   //每行缩略图数目
        servletContext.distributeModState = CTools.nullToZero(SysConfig.findByConfigName('DistributeModState')?.configValue)
        //分发模块状态
        servletContext.metaDefineAllowModifyOpt = CTools.nullToZero(SysConfig.findByConfigName('MetaDefineAllowModifyOpt')?.configValue)
        //元数据编辑时允许修改属性选项 0不允许修改名称类型等易出错的属性，1允许自由修改,用于没有资源数据初建元数据表时
        servletContext.clientName = grailsApplication.config.app.clientName     //客户名称
        servletContext.universityTag = grailsApplication.config.university.tag  //有无高校标志:true，false,字符串
        servletContext.transcodingPath = SysConfig.findByConfigName('TranscodingPath')?.configValue
        servletContext.transcodingIp = SysConfig.findByConfigName('TranscodingIp')?.configValue
        servletContext.transcodingPort = SysConfig.findByConfigName('TranscodingPort')?.configValue

        servletContext.thumbnailSize = SysConfig.findByConfigName('ThumbnailSize')?.configValue
        servletContext.thumbnailPos = SysConfig.findByConfigName('ThumbnailPos')?.configValue

        servletContext.videoPort = videoPort    //视频服务器端口
        servletContext.uploadPort = uploadPort  //上载服务器端口
        servletContext.localWebPort = SysConfig.findByConfigName('LocalWebPort')?.configValue   //本机web端口
        servletContext.fileSizeLimit = fileSizeLimit; //上传文件最大容量

        servletContext.authPrefix = CTools.nullToBlank(grailsApplication.config.auth.prefix)            //认证前缀
        servletContext.authPostfix = CTools.nullToBlank(grailsApplication.config.auth.postfix)  //认证后缀
        servletContext.authTimeout = CTools.nullToZero(grailsApplication.config.auth.timeout)   //认证超时
        servletContext.authUrl = CTools.nullToBlank(grailsApplication.config.auth.url)          //认证地址

        // 获取高级搜索设置
        servletContext.searchEnable = Boolean.parseBoolean(SysConfig.findByConfigName('SeniorSearchOpt')?.configValue);
        if (servletContext.searchEnable) {
            def solrProgramUrl = SysConfig.findByConfigName('SolrProgramUrl');
            def solrSerialUrl = SysConfig.findByConfigName("SolrSerialUrl");
            def cronExpression = SysConfig.findByConfigName("CronExpression");
            servletContext.solrProgramUrl = solrProgramUrl ? solrProgramUrl.configValue : "http://127.0.0.1:8080/mysolr/dev_program";
            servletContext.solrSerialUrl = solrSerialUrl ? solrSerialUrl.configValue : "http://127.0.0.1:8080/mysolr/dev_serial";
            servletContext.cronExpression = cronExpression ? cronExpression.configValue : "0 0 0 * * ?";
        }

        if (true || !(servletContext.authPrefix instanceof String) || servletContext.authPrefix == "") servletContext.authPrefix = "boful"
        //认证前缀
        if (true || !(servletContext.authPostfix instanceof String) || servletContext.authPostfix == "") servletContext.authPostfix = "truran"
        //认证后缀

        servletContext.anonymityUserName = "anonymity"  //匿名用户名
        servletContext.anonymityPassword = "pwd123"     //匿名用户密码

        servletContext.centerGrade = CTools.nullToZero(SysConfig.findByConfigName('CenterGrade')?.configValue)
        //本中心级别 2省 3市 4县 5乡镇
        servletContext.provinceIp = SysConfig.findByConfigName('ProvinceIp')?.configValue       //省中心IP
        servletContext.provinceWebPort = SysConfig.findByConfigName('ProvinceWebPort')?.configValue     //省中心web服务器端口
        servletContext.remarkAuthOpt = CTools.nullToZero(SysConfig.findByConfigName('RemarkAuthOpt')?.configValue)
        //资源评论审批选项 0不审核，1审核
        servletContext.playLogOpt = CTools.nullToZero(SysConfig.findByConfigName('PlayLogOpt')?.configValue)
        //点播日志选项 0 不记录 1记录
        servletContext.viewLogOpt = CTools.nullToZero(SysConfig.findByConfigName('ViewLogOpt')?.configValue)
        //浏览日志选项 0 不记录 1记录
        servletContext.autoPlayTime = CTools.nullToZero(SysConfig.findByConfigName('AutoPlayTime')?.configValue)
        //浏览日志选项 0 不记录 1记录

        servletContext.fileDelOpt = CTools.nullToZero(SysConfig.findByConfigName('FileDelOpt')?.configValue)
        //删除媒体文件选项设置  0不删除 1删除，默认不删除
        servletContext.lineList = CTools.nullToBlank(SysConfig.findByConfigName('LineList')?.configValue)
        //线路列表  地址与名称之间用逗号，线路之间用分号隔开;
        servletContext.showModOpt = CTools.nullToZero(SysConfig.findByConfigName('ShowModOpt')?.configValue)
        //对应系统模块ShowModOpt选项值  1学习圈 2学习社区 4活动 8资源云
        servletContext.topicShowNum = CTools.nullToZero(SysConfig.findByConfigName('TopicShowNum')?.configValue)
        //热点专题显示数目
        if (servletContext.topicShowNum == 0) servletContext.topicShowNum = 3

        BfConfig.setWebRootPath(servletContext.getRealPath("/")) //web根路径
        BfConfig.setVideoSevr(servletContext.videoSevr) //视频服务器端口
        BfConfig.setVideoPort(videoPort) //视频服务器端口
        BfConfig.setLocalWebPort(servletContext.localWebPort) //本机web端口
        BfConfig.setPlayProtocol(SysConfig.findByConfigName('VodCoreVer')?.configValue) //播放协议
        BfConfig.setFileSizeLimit(fileSizeLimit);

        servletContext.selfServerNode = ServerNode.findByGrade(ServerNode.GRADE_SELF)   //本节点 用于分发收割

        //启动分发任务,放在最后
        distributeService.restartDistributeJob()

        //生成meta js文件
        metaDefineService.creatMetaJs()

        //initTestUser();

    }

    def destroy = {

    }


    private static void initTestUser() {
        for (int i = 0; i < 100; i++) {
            Consumer master = new Consumer();
            master.name = "测试用户${i}";
            master.nickname = "测试账号昵称${i}";
            master.password = "password".encodeAsPassword();
            master.isRegister = false;
            master.notExamine = true;
            master.role = 3;
            master.uploadState = Consumer.CAN_UPLOAD_STATE;
            if ((!master.save(flush: true)) || master.hasErrors()) {
                println("管理员初始化错误！");
            } else {
                println("管理员初始化成功！")
            }
        }
    }

    private static void initLang() {
        File lang = new File(SystemConfig.webRootDir, "data/lang.csv");
        if (lang && lang.exists()) {
            lang.eachLine { String line ->
                String[] splits = line.split(";");
                if (splits.length == 3) {
                    String enName = splits[0];
                    String shortName = splits[1];
                    String zhName = splits[2];
                    Lang lang1 = Lang.findByEnName(enName);
                    if (!lang1) {
                        lang1 = new Lang();
                        lang1.enName = enName;
                        lang1.shortName = shortName;
                        lang1.zhName = zhName;
                        lang1.save(flush: true);
                    }
                } else {
                    log.error("skip lang:" + line);
                }
            }
        }

    }

    private void fixTimeLength(ServletContext servletContext) {
        List<Serial> serialList = Serial.findAllByTimeLength(0);
        if (serialList.size() > 0) {
            String url = utilService.generalVideoServerUrl() + "play/queryFileLogicLength";
            HttpPost httpPost = new HttpPost(url);
            ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
            serialList.each {
                params.add(new BasicNameValuePair("hash", it.fileHash));
            }

            httpPost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
            HttpClient httpClient = HttpClients.createDefault();
            try {
                CloseableHttpResponse httpResponse = httpClient.execute(httpPost);
                String text = httpResponse.getEntity().getContent().getText("UTF-8");
                JSONElement result = JSON.parse(text);
                if (result.success) {
                    result.playList.each {
                        Serial.executeUpdate("update Serial set timeLength=? where fileHash=?", [it.timeLength, it.hash]);
                    }
                } else {
                    log.error(result.msg);
                }
            } catch (Exception e) {
                log.error(e.message, e);
            }
        }

    }

    private void initConsumerCanPlay() {
        String sqlString = "update consumer set can_play = 1 "
        //ApplicationContext ctx = (ApplicationContext) ApplicationHolder.getApplication().getMainContext();
        def dataSource = grailsApplication.mainContext.getBean('dataSource');
        def sql = new Sql(dataSource);
        sql.executeUpdate(sqlString)
    }

    private void initForumBoardState() {
        String sqlString = "update forum_board set state = 1 "
        ApplicationContext ctx = grailsApplication.mainContext;
        def dataSource = ctx.getBean('dataSource');
        def sql = new Sql(dataSource);
        sql.executeUpdate(sqlString);
    }

    private void initProgramScore() {
        def dataSource = grailsApplication.mainContext.getBean('dataSource');
        def sql = new Sql(dataSource);
        String sqlString = "select avg(r1.rank) score, r1.program_id from remark r1 group by r1.program_id"
        List<GroovyRowResult> rs = sql.rows(sqlString);
        if (rs && rs.size() > 0) {
            rs.each { GroovyRowResult result ->
                def score = Float.parseFloat(result.getProperty("score").toString());
                def programId = result.getProperty("program_id");
                sqlString = "update program set program_score = " + score + " where id = " + programId;
                sql.executeUpdate(sqlString);
            }
        }
    }

    private void initProgramRemarkNum() {
        List<Program> programList = Program.list();
        programList?.each { Program program ->
            if (program.remarks && program.remarks.size() > 0) {
                program.remarkNum = program.remarks.size();
                program.save(flush: true);
            }
        }
    }

    //系统启动，检查是否有需要执行的sql进行数据库更新
    private void rmsversionUpdate(ServletContext servletContext) {
        def sysConfig = SysConfig.findByConfigName("rmsversion")
        int version = 314
        if (sysConfig) {
            version = Integer.parseInt(sysConfig.configValue)
        }
        String fileRootPath = new File(SystemConfig.webRootDir, "upgrade").getAbsolutePath();
        String sqlFile = SqlFileExecutor.getNewSqlFile(version, "MYSQL", fileRootPath)

        if (sqlFile.equals("0")) {
            log.error("升级文件不存在,取消升级");
        } else if (sqlFile.equals("-1")) {
            log.error("在查找可更新的sql文件时出现异常,取消升级");
        } else if (!sqlFile.equals("")) {
            def sqlList = SqlFileExecutor.loadSql(sqlFile)
            if (sqlList == null) {
                log.error("读取sql文件" + sqlFile + "出现异常,取消升级");
            } else {
                def conn = null;
                def sql = null;
                try {
                    ApplicationContext ctx = grailsApplication.getMainContext();
                    def dataSource = ctx.getBean('dataSource');
                    conn = dataSource.getConnection();
                    conn.setAutoCommit(false);
                    sql = new Sql(conn);

                    def flag = true;
                    for (String sq : sqlList) {
                        try {
                            flag = sql.execute(sq);
                            if (flag) {
                                log.error("升级过程错误信息,没有执行成功的sql:" + sq);
                                sql.rollback();
                                sql.close();
                                conn.close();
                                break;
                            } else {
                                log.info("升级过程信息,sql执行成功：" + sql)
                            }
                        } catch (SQLException sex) {
                            flag = true;
                            log.error("升级过程错误信息,错误的sql：" + sq);
                            log.error("升级过程错误信息,错误提示：" + sex.getMessage());
                            sql.rollback();
                            break;
                        }
                    }

                    if (!flag) {
                        sql.commit();
                        sql.close();
                        conn.close();

                        if (sysConfig) {
                            sysConfig.configValue = version + 1
                            sysConfig.save()
                        } else {
                            sysConfig = new SysConfig(
                                    configDesc: "版本号",
                                    configName: "rmsversion",
                                    configValue: version + 1
                            )
                            sysConfig.save()
                        }
                        log.info("升级成功：更新数据库" + sqlFile + "成功！");
                    }
                } catch (Exception e) {
                    log.error("升级失败，执行" + sqlFile + "过成功出线异常：" + e.getMessage());
                    sql.close();
                    conn.close();
                }

            }
        }
    }
}