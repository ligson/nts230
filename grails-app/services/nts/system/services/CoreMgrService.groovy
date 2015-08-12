package nts.system.services

import com.boful.nts.service.model.RMSNode
import grails.converters.JSON
import grails.transaction.Transactional
import groovy.sql.Sql
import nts.program.domain.Program
import nts.program.domain.Serial
import nts.system.domain.ConsumerLog
import nts.system.domain.Directory
import nts.system.domain.News
import nts.system.domain.OnlineUser
import nts.system.domain.SysConfig
import nts.system.domain.Tools
import nts.user.domain.Consumer
import nts.utils.BfConfig
import nts.utils.CTools
import org.apache.http.NameValuePair
import org.apache.http.client.HttpClient
import org.apache.http.client.entity.UrlEncodedFormEntity
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpPost
import org.apache.http.impl.client.HttpClients
import org.apache.http.message.BasicNameValuePair
import org.codehaus.groovy.grails.web.json.JSONArray
import org.codehaus.groovy.grails.web.json.JSONElement
import org.springframework.dao.DataIntegrityViolationException

import java.text.SimpleDateFormat

@Transactional
class CoreMgrService {
    def utilService;
    def dataSource;
    def appService;
    def searchService;
    /**
     * 核心设置
     * @param params
     * @return
     */
    public Map systemSet(Map params) {
        def result = [:];
        def servletContext = utilService.getServletContext();
        def UploadRootPath = SysConfig.findByConfigName('UploadRootPath');        //上传路径设置
        def VideoSevr = SysConfig.findByConfigName('VideoSevr');                //视频服务器IP地址
        def videoPort = SysConfig.findByConfigName("videoPort");    //视频服务端口
        def uploadPort = SysConfig.findByConfigName("uploadPort"); //上传服务端口
        def AbbrImgSize = SysConfig.findByConfigName('AbbrImgSize');                //缩略图大小
        def AbbrImgRowPerNum = SysConfig.findByConfigName('AbbrImgRowPerNum');                //每行缩略图数目
        def vodCoreVer = SysConfig.findByConfigName('VodCoreVer');    //流媒体核心版本
        def centerGrade = SysConfig.findByConfigName('CenterGrade');                //中心级别
        def provinceIp = SysConfig.findByConfigName('ProvinceIp');    //省中心IP
        def provinceWebPort = SysConfig.findByConfigName('ProvinceWebPort');    //省中心web服务器端口
        def localWebPort = SysConfig.findByConfigName('LocalWebPort');    //本地web服务器端口
        def outPlayFrequency = SysConfig.findByConfigName('OutPlayFrequency');    //远程点播阀值

        def transcodingIp = SysConfig.findByConfigName('TranscodingIp');        //转码服务器IP地址
        def transcodingPort = SysConfig.findByConfigName('TranscodingPort');        //转码服务器端口
        def transcodingPath = SysConfig.findByConfigName('TranscodingPath');        //转码保存路径
        def transcodeFormat = SysConfig.findByConfigName('TranscodeFormat');        //转码文件格式支持
        def showModOpt = SysConfig.findByConfigName('ShowModOpt');                //转码文件格式支持
        def distributeModState = SysConfig.findByConfigName('DistributeModState');    //分发模块状态
        def defaultPlayFormat = SysConfig.findByConfigName('DefaultPlayFormat');        //缺省播放格式

        def emailRootDir = SysConfig.findByConfigName('EmailRootDir');        //email保存路径
        def email = SysConfig.findByConfigName('Email');                //email地址
        def emailPop3 = SysConfig.findByConfigName('EmailPop3');        //Email Pop3地址
        def emailSmtp = SysConfig.findByConfigName('EmailSmtp');        //Email smtp地址
        def emailUserName = SysConfig.findByConfigName('EmailUserName');        //Email用户名
        def emailPassword = SysConfig.findByConfigName('EmailPassword');        //Email用户名密码

        def thumbnailSize = SysConfig.findByConfigName('ThumbnailSize');    //海报尺寸
        def thumbnailPos = SysConfig.findByConfigName('ThumbnailPos');        //缺省播放格式

        def remarkAuthOpt = SysConfig.findByConfigName('RemarkAuthOpt');        //缺省播放格式
        def playLogOpt = SysConfig.findByConfigName('PlayLogOpt');        //点播日志选项
        def viewLogOpt = SysConfig.findByConfigName('ViewLogOpt');        //浏览日志选项
        def autoPlayTime = SysConfig.findByConfigName('AutoPlayTime');        //自动播放计数时间

        def fileDelOpt = SysConfig.findByConfigName('FileDelOpt');        //删除媒体文件选项设置  0不删除 1删除，默认不删除
        def lineList = SysConfig.findByConfigName('LineList');        //线路列表  地址与名称之间用逗号，线路之间用分号隔开;

        // ------------------------------- 修改项目名称和页脚 -------------------------------
        def filePath
        Properties properties = new Properties()
        try {
            filePath = servletContext.getRealPath("/") + "WEB-INF/grails-app/i18n/messages_zh_CN.properties"
            InputStream is = new FileInputStream(filePath)

            properties.load(is)
            is.close()
        } catch (FileNotFoundException e) {
            filePath = servletContext.getRealPath("/") + "../grails-app/i18n/messages_zh_CN.properties"
            InputStream is = new FileInputStream(filePath)

            properties.load(is)
            is.close()
        }
        try {
            if (params.applicationName) params.applicationName = params.applicationName.trim()
            if (params.applicationBottom) params.applicationBottom = params.applicationBottom.trim()

            def an = properties.getProperty("application.name")
            def ab = properties.getProperty("application.bottom")

            //if(ab.contains("<p>") || ab.contains("</p>")){
            // ab = ab.replaceAll("<p>", "")
            //ab = ab.replaceAll("</p>", "")
            //}

            if ((params.applicationName && params.applicationName != an) || (params.applicationBottom && params.applicationBottom != ab)) {

                if (params.applicationName && params.applicationName != an) {
                    properties.setProperty("application.name", params.applicationName)
                }
                if (params.applicationBottom && params.applicationBottom != ab) {
                    properties.setProperty("application.bottom", params.applicationBottom)
                }

                File file = new File(filePath)

                OutputStream fos = new FileOutputStream(file.absolutePath);
                properties.store(fos, "")
                fos.close()
            }
        } catch (Exception e) {
            e.printStackTrace()
        }

        // ------------------------------- 修改项目名称和页脚 结束 -------------------------------

        if (!UploadRootPath) {
            new SysConfig(configName: 'UploadRootPath', configValue: params.UploadRootPath, configDesc: '资源存放根路径', configScope: 0, configMod: 0).save()
        } else {
            UploadRootPath.configValue = params.UploadRootPath
        }

        if (!VideoSevr) {
            new SysConfig(configName: 'VideoSevr', configValue: params.VideoSevr, configDesc: '视频服务器IP地址', configScope: 0, configMod: 0).save()
        } else {
            VideoSevr.configValue = params.VideoSevr
        }
        if (!videoPort) {
            new SysConfig(configName: 'videoPort', configValue: params.videoPort, configDesc: '视频服务端口', configScope: 0, configMod: 0).save()
        } else {
            videoPort.configValue = params.videoPort;
        }
        if (!uploadPort) {
            new SysConfig(configName: 'uploadPort', configValue: params.uploadPort, configDesc: '上传服务端口', configScope: 0, configMod: 0).save()
        } else {
            uploadPort.configValue = params.uploadPort;
        }

        if (!AbbrImgSize) {
            new SysConfig(configName: 'AbbrImgSize', configValue: params.AbbrImgSize, configDesc: '缩略图大小', configScope: 0, configMod: 0).save()
        } else {
            AbbrImgSize.configValue = params.AbbrImgSize
        }

        if (!AbbrImgRowPerNum) {
            new SysConfig(configName: 'AbbrImgRowPerNum', configValue: params.AbbrImgRowPerNum, configDesc: '每行缩略图数目', configScope: 0, configMod: 0).save()
        } else {
            AbbrImgRowPerNum.configValue = params.AbbrImgRowPerNum
        }

        if (!vodCoreVer) {
            new SysConfig(configName: 'VodCoreVer', configValue: params.VodCoreVer, configDesc: '流媒体核心版本', configScope: 0, configMod: 0).save()
        } else {
            vodCoreVer.configValue = params.VodCoreVer
        }

        if (!centerGrade) {
            new SysConfig(configName: 'CenterGrade', configValue: params.CenterGrade, configDesc: '中心级别', configScope: 0, configMod: 0).save()
        } else {
            centerGrade.configValue = params.CenterGrade
        }

        if (!provinceIp) {
            new SysConfig(configName: 'ProvinceIp', configValue: params.ProvinceIp, configDesc: '省中心IP', configScope: 0, configMod: 0).save()
        } else {
            provinceIp.configValue = params.ProvinceIp
        }

        if (!provinceWebPort) {
            new SysConfig(configName: 'ProvinceWebPort', configValue: params.ProvinceWebPort, configDesc: '省中心web服务器端口', configScope: 0, configMod: 0).save()
        } else {
            provinceWebPort.configValue = params.ProvinceWebPort
        }

        if (!localWebPort) {
            new SysConfig(configName: 'LocalWebPort', configValue: params.LocalWebPort, configDesc: '本地web服务器端口', configScope: 0, configMod: 0).save()
        } else {
            localWebPort.configValue = params.LocalWebPort
        }

        if (!outPlayFrequency) {
            new SysConfig(configName: 'OutPlayFrequency', configValue: params.OutPlayFrequency, configDesc: '远程点播阀值', configScope: 0, configMod: 0).save()
        } else {
            outPlayFrequency.configValue = params.OutPlayFrequency
        }

        //-----------2012-5-16视频转码设置----------------
        if (!transcodingIp) {
            new SysConfig(configName: 'TranscodingIp', configValue: params.transcodingIp, configDesc: '转码服务器IP地址', configScope: 0, configMod: 0).save()
        } else {
            transcodingIp.configValue = params.transcodingIp
        }

        if (!transcodingPort) {
            new SysConfig(configName: 'TranscodingPort', configValue: params.transcodingPort, configDesc: '转码服务器端口', configScope: 0, configMod: 0).save()
        } else {
            transcodingPort.configValue = params.transcodingPort
        }

        if (!transcodingPath) {
            new SysConfig(configName: 'TranscodingPath', configValue: params.transcodingPath, configDesc: '转码保存路径', configScope: 0, configMod: 0).save()
        } else {
            transcodingPath.configValue = params.transcodingPath
        }

        //-----------文件格式设置2012/7/24----------------
        def transcodeFormatList = params.transcodeFormat
        if (transcodeFormatList instanceof String) transcodeFormatList = [transcodeFormatList]

        int totalTranscode = 0
        transcodeFormatList?.each {
            totalTranscode += it.toInteger()
        }

        if (!transcodeFormat) {
            new SysConfig(configName: 'TranscodeFormat', configValue: "" + totalTranscode, configDesc: '转码文件格式支持', configScope: 0, configMod: 0).save()
        } else {
            transcodeFormat.configValue = "" + totalTranscode
        }

        if (!defaultPlayFormat) {
            new SysConfig(configName: 'DefaultPlayFormat', configValue: params.defaultPlayFormat, configDesc: '缺省播放格式', configScope: 0, configMod: 0).save()
        } else {
            defaultPlayFormat.configValue = params.defaultPlayFormat
        }

        def showModOptList = params.showModOpt
        if (showModOptList instanceof String) showModOptList = [showModOptList]

        int totalModOpt = 0
        showModOptList?.each {
            totalModOpt += it.toInteger()
        }

        if (!showModOpt) {
            new SysConfig(configName: 'ShowModOpt', configValue: "" + totalModOpt, configDesc: '系统模块显示设置', configScope: 0, configMod: 0).save()
        } else {
            showModOpt.configValue = "" + totalModOpt
        }

        def distributeModStateList = params.distributeModState
        if (distributeModStateList instanceof String) distributeModStateList = [distributeModStateList]

        int totalDistributeMod = 0
        distributeModStateList?.each {
            totalDistributeMod += it.toInteger()
        }

        if (!distributeModState) {
            new SysConfig(configName: 'DistributeModState', configValue: "" + totalDistributeMod, configDesc: '系统模块显示设置', configScope: 0, configMod: 0).save()
        } else {
            distributeModState.configValue = "" + totalDistributeMod
        }

        //-----------关键帧设置2012/8/20-----------
        if (!params.thumbnailSize1 && params.thumbnailSize1 == "") params.thumbnailSize1 = "310"
        if (!params.thumbnailSize2 && params.thumbnailSize2 == "") params.thumbnailSize2 = "415"
        def thumbnailSizeVal = params.thumbnailSize1 + "x" + params.thumbnailSize2
        if (!thumbnailSize) {
            new SysConfig(configName: 'ThumbnailSize', configValue: thumbnailSizeVal, configDesc: '海报尺寸', configScope: 0, configMod: 0).save()
        } else {
            thumbnailSize.configValue = thumbnailSizeVal
        }

        if (!thumbnailPos) {
            new SysConfig(configName: 'ThumbnailPos', configValue: params.thumbnailPos, configDesc: '截取时间点', configScope: 0, configMod: 0).save()
        } else {
            thumbnailPos.configValue = params.thumbnailPos == "" ? "300" : params.thumbnailPos
        }

        //活动Email设置  孙长贵	 2012/10/12
        if (!emailRootDir) {
            new SysConfig(configName: 'EmailRootDir', configValue: params.emailRootDir, configDesc: 'email保存路径', configScope: 0, configMod: 0).save()
        } else {
            emailRootDir.configValue = params.emailRootDir
        }

        if (!email) {
            new SysConfig(configName: 'Email', configValue: params.email, configDesc: 'email地址', configScope: 0, configMod: 0).save()
        } else {
            email.configValue = params.email
        }

        if (!emailPop3) {
            new SysConfig(configName: 'EmailPop3', configValue: params.emailPop3, configDesc: 'Email Pop3地址', configScope: 0, configMod: 0).save()
        } else {
            emailPop3.configValue = params.emailPop3
        }

        if (!emailSmtp) {
            new SysConfig(configName: 'EmailSmtp', configValue: params.emailSmtp, configDesc: 'Email smtp地址', configScope: 0, configMod: 0).save()
        } else {
            emailSmtp.configValue = params.emailSmtp
        }

        if (!emailUserName) {
            new SysConfig(configName: 'EmailUserName', configValue: params.emailUserName, configDesc: 'Email用户名', configScope: 0, configMod: 0).save()
        } else {
            emailUserName.configValue = params.emailUserName
        }

        if (!emailPassword) {
            new SysConfig(configName: 'EmailPassword', configValue: params.emailPassword, configDesc: 'Email用户名密码', configScope: 0, configMod: 0).save()
        } else {
            emailPassword.configValue = params.emailPassword
        }

        if (!remarkAuthOpt) {
            new SysConfig(configName: 'RemarkAuthOpt', configValue: params.remarkAuthOpt, configDesc: '评论是否审核', configScope: 0, configMod: 0).save()
        } else {
            remarkAuthOpt.configValue = params.remarkAuthOpt
        }

        if (!playLogOpt) {
            new SysConfig(configName: 'PlayLogOpt', configValue: params.playLogOpt, configDesc: '点播日志是否记录', configScope: 0, configMod: 0).save()
        } else {
            playLogOpt.configValue = params.playLogOpt
        }

        if (!viewLogOpt) {
            new SysConfig(configName: 'ViewLogOpt', configValue: params.viewLogOpt, configDesc: '浏览日志是否记录', configScope: 0, configMod: 0).save()
        } else {
            viewLogOpt.configValue = params.viewLogOpt
        }

        if (!autoPlayTime) {
            new SysConfig(configName: 'AutoPlayTime', configValue: params.autoPlayTime, configDesc: '自动播放计数时间', configScope: 0, configMod: 0).save()
        } else {
            autoPlayTime.configValue = params.autoPlayTime
        }

        if (!fileDelOpt) {
            new SysConfig(configName: 'FileDelOpt', configValue: params.fileDelOpt, configDesc: '删除媒体文件选项设置', configScope: 0, configMod: 0).save()
        } else {
            fileDelOpt.configValue = params.fileDelOpt
        }

        if (!lineList) {
            new SysConfig(configName: 'LineList', configValue: params.lineList, configDesc: '线路列表', configScope: 0, configMod: 0).save()
        } else {
            params.lineList = params.lineList.replaceAll("，", ",")
            params.lineList = params.lineList.replaceAll("；", ";")
            lineList.configValue = params.lineList
        }

        //更新全局变量
        servletContext.uploadRootPath = params.UploadRootPath                        //上传路径
        servletContext.videoSevr = CTools.nullToBlank(params.VideoSevr)                //视频服务器IP地址
        servletContext.videoPort = params.videoPort ? params.videoPort : 1680;
        servletContext.uploadPort = params.uploadPort ? params.uploadPort : 1670;
        servletContext.AbbrImgSize = CTools.nullToBlank(params.AbbrImgSize)            //缩略图大小
        servletContext.AbbrImgRowPerNum = CTools.nullToBlank(params.AbbrImgRowPerNum)    //每行缩略图数目
        servletContext.centerGrade = CTools.nullToZero(params.CenterGrade)                //中心级别
        servletContext.provinceIp = CTools.nullToBlank(params.ProvinceIp)                //省中心IP
        servletContext.provinceWebPort = CTools.nullToBlank(params.ProvinceWebPort)        //省中心web服务器端口
        servletContext.localWebPort = CTools.nullToBlank(params.LocalWebPort)            //本地web服务器端口
        servletContext.outPlayFrequency = CTools.nullToBlank(params.OutPlayFrequency)    //本地web服务器端口

        servletContext.transcodingIp = CTools.nullToBlank(params.transcodingIp)        //转码服务器IP地址
        servletContext.transcodingPort = CTools.nullToBlank(params.transcodingPort)    //转码服务器端口
        servletContext.transcodingPath = CTools.nullToBlank(params.transcodingPath)    //转码保存路径
        servletContext.remarkAuthOpt = CTools.nullToZero(params.remarkAuthOpt)        //评论是否审核
        servletContext.playLogOpt = CTools.nullToZero(params.playLogOpt)        //点播日志选项
        servletContext.viewLogOpt = CTools.nullToZero(params.viewLogOpt)        //浏览日志选项
        servletContext.autoPlayTime = CTools.nullToZero(params.autoPlayTime)        //自动播放计数时间
        servletContext.fileDelOpt = CTools.nullToZero(params.fileDelOpt)        //删除媒体文件选项设置
        servletContext.lineList = CTools.nullToBlank(params.lineList)        //线路列表
        servletContext.transcodeFormat = totalTranscode            //转码文件格式支持
        servletContext.showModOpt = totalModOpt                    //系统模块显示设置
        servletContext.distributeModState = totalDistributeMod    //资源分发模块显示设置

        ////更新配置类
        BfConfig.setPlayProtocol(params.VodCoreVer)
        BfConfig.setLocalWebPort(params.LocalWebPort)
        BfConfig.setVideoSevr(params.VideoSevr)

        result.message = "设置完成，如修改了应用程序名或页脚，需要重启WEB服务！";
        def saveFileRequest = [:];
        saveFileRequest = saveFile();
        if (!saveFileRequest.success) {
            result.message = saveFileRequest.message;
        }
        return result;
    }
    /**
     * 核心设置显示
     * @param params
     * @return
     */
    public Map systemConfig(Map params) {
        def result = [:];
        def servletContext = utilService.getServletContext();
        //下面对象以前开发人员以大写字母打头，是不规范的，以后添加的用小写开头 add by jlf
        def UploadRootPath = SysConfig.findByConfigName('UploadRootPath');        //上传路径设置
        def VideoSevr = SysConfig.findByConfigName('VideoSevr');                //视频服务器IP地址
        def videoPort = SysConfig.findByConfigName("videoPort");    //视频服务端口
        def uploadPort = SysConfig.findByConfigName("uploadPort"); //上传服务端口
        def AbbrImgSize = SysConfig.findByConfigName('AbbrImgSize');                //缩略图大小
        def AbbrImgRowPerNum = SysConfig.findByConfigName('AbbrImgRowPerNum');                //每行缩略图数目
        def vodCoreVer = SysConfig.findByConfigName('VodCoreVer');                //流媒体核心版本
        def centerGrade = SysConfig.findByConfigName('CenterGrade');                //中心级别
        def provinceIp = SysConfig.findByConfigName('ProvinceIp');                //省中心IP
        def provinceWebPort = SysConfig.findByConfigName('ProvinceWebPort');                //省中心web服务器端口
        def localWebPort = SysConfig.findByConfigName('LocalWebPort');
        def outPlayFrequency = SysConfig.findByConfigName('OutPlayFrequency');//本地web服务器端口

        def transcodingIp = SysConfig.findByConfigName('TranscodingIp');        //转码服务器IP地址
        def transcodingPort = SysConfig.findByConfigName('TranscodingPort');        //转码服务器端口
        def transcodingPath = SysConfig.findByConfigName('TranscodingPath');        //转码保存路径
        def transcodeFormat = SysConfig.findByConfigName('TranscodeFormat');        //转码文件格式支持
        def showModOpt = SysConfig.findByConfigName('ShowModOpt');                //系统模块显示设置
        def distributeModState = SysConfig.findByConfigName('DistributeModState');    //分发模块状态
        def defaultPlayFormat = SysConfig.findByConfigName('DefaultPlayFormat');        //缺省播放格式

        def emailRootDir = SysConfig.findByConfigName('EmailRootDir');        //email保存路径
        def email = SysConfig.findByConfigName('Email');                //email地址
        def emailPop3 = SysConfig.findByConfigName('EmailPop3');        //Email Pop3地址
        def emailSmtp = SysConfig.findByConfigName('EmailSmtp');        //Email smtp地址
        def emailUserName = SysConfig.findByConfigName('EmailUserName');        //Email用户名
        def emailPassword = SysConfig.findByConfigName('EmailPassword');        //Email用户名密码

        def remarkAuthOpt = SysConfig.findByConfigName('RemarkAuthOpt');        //评论是否审核
        def playLogOpt = SysConfig.findByConfigName('PlayLogOpt');        //点播日志选项
        def viewLogOpt = SysConfig.findByConfigName('ViewLogOpt');        //浏览日志选项
        def autoPlayTime = SysConfig.findByConfigName('AutoPlayTime');        //自动播放计数时间

        def fileDelOpt = SysConfig.findByConfigName('FileDelOpt');        //删除媒体文件选项设置  0不删除 1删除，默认不删除
        def lineList = SysConfig.findByConfigName('LineList');        //线路列表  地址与名称之间用逗号，线路之间用分号隔开;

        def thumbnailSize = SysConfig.findByConfigName('ThumbnailSize');    //海报尺寸
        def thumbnailSize1 = ""
        def thumbnailSize2 = ""
        if (thumbnailSize && thumbnailSize.configValue && thumbnailSize.configValue != "") {
            int xIndex = thumbnailSize.configValue.indexOf("x")
            thumbnailSize1 = thumbnailSize.configValue.substring(0, xIndex)
            thumbnailSize2 = thumbnailSize.configValue.substring(xIndex + 1)
        }
        def thumbnailPos = SysConfig.findByConfigName('ThumbnailPos');        //缺省播放格式

        //----------------------------- 读取属性文件，显示项目名称和页脚 -----------------
        def applicationName = ""
        def applicationBottom = ""

        def classPath
        def beautiful
        Properties properties = new Properties()
        try {
            def filePath = servletContext.getRealPath("/") + "WEB-INF/grails-app/i18n/messages_zh_CN.properties"
            InputStream is = new FileInputStream(filePath)

            properties.load(is)
            is.close()
        } catch (java.io.FileNotFoundException e) {
            def filePath = servletContext.getRealPath("/") + "../grails-app/i18n/messages_zh_CN.properties"
            InputStream is = new FileInputStream(filePath)

            properties.load(is)
            is.close()
        }

        applicationName = properties.getProperty("application.name")
        applicationBottom = properties.getProperty("application.bottom")

        if (true) {
            applicationBottom = applicationBottom.replaceAll("<p>", "")
            applicationBottom = applicationBottom.replaceAll("</p>", "")
        }
        result.videoPort = videoPort;
        result.uploadPort = uploadPort;
        result.UploadRootPath = UploadRootPath;
        result.VideoSevr = VideoSevr;
        result.AbbrImgSize = AbbrImgSize;
        result.AbbrImgRowPerNum = AbbrImgRowPerNum;
        result.vodCoreVer = vodCoreVer;
        result.provinceIp = provinceIp;
        result.provinceWebPort = provinceWebPort;
        result.localWebPort = localWebPort;
        result.centerGrade = centerGrade;
        result.applicationName = applicationName;
        result.applicationBottom = applicationBottom;
        result.outPlayFrequency = outPlayFrequency;
        result.transcodingIp = transcodingIp;
        result.transcodingPort = transcodingPort;
        result.transcodingPath = transcodingPath;
        result.transcodeFormat = transcodeFormat;
        result.showModOpt = showModOpt;
        result.distributeModState = distributeModState;
        result.defaultPlayFormat = defaultPlayFormat;
        result.thumbnailSize1 = thumbnailSize1;
        result.thumbnailSize2 = thumbnailSize2;
        result.thumbnailPos = thumbnailPos;
        result.emailRootDir = emailRootDir;
        result.email = email;
        result.emailPop3 = emailPop3;
        result.emailSmtp = emailSmtp;
        result.emailUserName = emailUserName;
        result.emailPassword = emailPassword;
        result.remarkAuthOpt = remarkAuthOpt;
        result.playLogOpt = playLogOpt;
        result.viewLogOpt = viewLogOpt;
        result.autoPlayTime = autoPlayTime;
        result.fileDelOpt = fileDelOpt;
        result.lineList = lineList;
        //----------------------------- 读取属性文件 结束 -----------------
        return result;
    }
    /**
     * 目录删除
     * @param params
     * @return
     * result:
     *          success：没有权限和删除成功都是返回true。找不到是返回false；
     */
    public Map directoryDelete(Map params) {
        def result = [:];
        result.success = true;
        def session = utilService.getSession();
        if (session.consumer.role == 0) {
            def directory = Directory.get(params.id)
            if (directory) {
                directory.consumers.toList().each {            //手动删除类库与用户的关系
                    it.removeFromDirectorys(directory)
                }
                directory.delete()                                //再进行删除类库
                result.message = "元数据标准 ${directory.name} 删除完成"
            } else {
                result.message = "nts.system.domain.Directory not found with id ${params.id}";
                result.success = false;
            }
        } else {
            result.message = "只在超级管理员才可删除 "
        }
        return result;
    }
    /**
     * 目录保存
     * @param params
     * @return
     */
    public Map directorySave(Map params) {
        def result = [:];
        result.success = true;
        def directory = new Directory(
                name: params.name,                            //目录名称
                showOrder: params.showOrder,                    //显示顺序
                canUpload: true,                                //上传标记
                description: params.description,                    //目录描术
                parentId: 0,                                    //因不用树目录，故没有用Directory类型		--暂为0
                classId: 0,                                        //类库ID 用来标识所属类库
                childNumber: 0,                                //子目录数目，建树目录时提高效率用		--暂为0
                allGroup: true                                    //所属组
        )
        def uploadImgResult = [:];
        uploadImgResult = uploadImg("save", params.updateId);
        directory.img = uploadImgResult.imgPath;
        result.message = uploadImgResult.message;
        if (directory.description == null) {
            directory.description = "";
        }
        if (!directory.hasErrors() && directory.save()) {
            result.message = "元数据标准 ${directory.name} 创建成功！"
        } else {
            result.directory = directory;
            result.success = false;
        }
        return result;
    }
    /**
     * 目录更新
     * @param params
     * @return result
     *      result.notFind,true,表示找不到，仅仅只有找不到的时候返回页面和返回值不一样
     */
    public Map directoryUpdate(Map params) {
        def result = [:];
        result.notFind = false;
        def session = utilService.getSession();
        if (session.consumer.role == 0) {
            def directory = Directory.get(params.updateId)
            if (directory) {
                directory.name = params.updateName
                directory.showOrder = params.updateShowOrder.toInteger()
                directory.description = params.updateDescription
                def updateImg = uploadImg("update")
                if (updateImg != null && updateImg != "") {
                    directory.img = updateImg
                }
                if (!directory.hasErrors() && directory.save()) {
                    result.message = "元数据标准 ${directory.name} 修改完成"
                } else {
                    result.message = "元数据标准 ${directory.name} 修改失败"
                }
            } else {
                result.notFind = true;
                result.message = "nts.system.domain.Directory not found with id ${params.id}"
            }
        } else {
            result.message = "只有超级管理员才可修改"
        }
        return result;
    }
    /**
     * 删除多个公告
     * @param params
     * @return
     */
    public void newsDeleteList(Map params) {
        def result = [:];
        def delIdList = params.idList
        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            def news = News.get(id as int)
            news.delete()
        }
    }
    /**
     * 删除单个公告
     * @param params
     * @return
     */
    public Map newDelete(Map params) {
        def result = [:];
        result.success = true;
        def session = utilService.getSession();
        def news = News.get(params.id as int)
        if (news && session.consumer.role == 0) {
            news.delete()
            result.message = "公告 ${news.title} 删除 "
        } else {
            result.message = "公告 删除失败 "
        }
        return result;
    }
    /**
     * 公告更新
     * @param params
     * @return result
     *      result.success，是否修改成功
     result.notFind，是否找到，没有权限修改也是返回newEdit
     */
    public Map newsUpdate(Map params) {
        def result = [:];
        result.success = true;
        result.notFind = false;
        def session = utilService.getSession();
        def news = News.get(params.newsId)
        if (session.consumer.role < Consumer.TEACHER_ROLE) {
            def content = params.content;
            if (news) {
                news.title = params.title
                news.content = content
                news.publisher = session.consumer
                if (!news.hasErrors() && news.save()) {
                    result.message = "公告  ${news.title} 修改完成,如果页面设置了缓存,则需要过了缓存时间,才能在页面显示."
                    result.news = news;
                } else {
                    //  flash.message = "公告修改失败"
                    result.success = false;
                }
            } else {
                result.success = false;
                result.notFind = true;
                result.message = "找不到该公告"
            }
        } else {
            result.success = false;
            result.notFind = true;
            result.message = "只在管理员才可修改 "
        }
        return result;
    }
    /**
     * 保存公告,不管创建是否成功都返回newsList，附带message
     * @param params
     * @return
     */
    public Map newsSave(Map params) {
        def result = [:];
        def session = utilService.getSession();
        def content = params.content//CTools.htmlToBlank(params.content);
        def news = new News(
                title: params.title,                                        //用户名
                content: content,                                    //密码
                publisher: session.consumer,                                //发布者
                submitTime: new Date(),                                    //真实姓名
        )
        if (session.consumer.role == 0) {
            if ((!news.hasErrors()) && (news.save(flush: true))) {
                result.message = "公告 ${news.title} 创建成功,如果页面设置了缓存,则需要过了缓存时间,才能在页面显示."
            } else {
                result.message = "公告创建失败"
            }
        } else {
            result.message = "您权限不够！只有超级管理员才可以创建!"
        }
        return result;
    }
    /**
     * 保存工具
     * @param params
     * @return
     */
    public Map toolsSave(Map params) {
        def result = [:];
        result.success = true;
        def session = utilService.getSession();
        def tools = new Tools
                (
                        name: params.name,
                        consumer: session.consumer.name
                )
        if (tools.save(flush: true)) {
            tools = fileUpload(tools)
            result.message = "上传成功"
        } else {
            result.success = false;
            result.tools = tools;
        }
        return result;
    }
    /**
     * 删除工具
     * @param params
     * @return
     */
    public Map toolsDelete(Map params) {
        def result = [:];
        def tools = Tools.get(params.delId)
        if (tools) {
            try {
                tools.delete(flush: true)
                result.message = "删除完成"
            }
            catch (DataIntegrityViolationException e) {
                result.message = "删除失败"
            }
        } else {
            result.message = "没有找不到该工具"
        }
        return result;
    }
    //上传工具
    private Tools fileUpload(def tools) {
        def request = utilService.getRequest();
        def servletContext = utilService.getServletContext();
        def file = request.getFile("filePath")
        def imgSize
        if (file && !file.isEmpty()) {
            imgSize = file.size / 1024            //获得文件大小
            String originalFilename = file.getOriginalFilename()
            def extension = originalFilename
            //上传到目录
            def path = servletContext.getRealPath("/");
            file.transferTo(new File("${path}/downdir/${extension}"))
            tools.dirName = extension
        }
        return tools;
        ////web-app/donwdir/
    }
    //上传图片(opt：值为save表示添加图片，值为update表示修改图片)
    private Map uploadImg(def opt, def updateId) {
        def result = [:];
        def request = utilService.getRequest();
        def servletContext = utilService.getServletContext();
        def imgFile = request.getFile(opt + "Img")
        def imgType = imgFile.getContentType()

        def path = servletContext.getRealPath("/upload");

        def imgPath = ""

        if (imgFile && !imgFile.isEmpty()) {
            if (imgType == "image/pjpeg" || imgType == "image/jpeg" || imgType == "image/png" || imgType == "image/x-png" || imgType == "image/gif") {
                if (opt == "save") {
                    def pt = Directory.createCriteria()
                    def id = pt.get {
                        projections {
                            max "id"
                        }
                    }
                    id = id == null ? 1 : id + 1
                    imgPath = "i_" + id + ".jpg"
                } else if (opt == "update") {
                    def directory = Directory.get(updateId)
                    def id = directory.id
                    imgPath = "i_" + id + ".jpg"
                }

                File directoryImg = new File("${path}/directoryImg/");
                if (!directoryImg.exists()) {
                    directoryImg.mkdirs();
                }
                imgFile.transferTo(new java.io.File(directoryImg.getAbsolutePath(), imgPath))
            } else {
                result.message = "上传图片格式不对..."
            }
        }
        result.imgPath = imgPath;
        return result;
    }

    /**
     * 文件保存
     * @return
     */
    public Map saveFile() {
        def result = [:];
        result.message = "";
        result.success = true;
        def request = utilService.getRequest();
        def servletContext = utilService.getServletContext();
        def fileLOGO = request.getFile("fileLOGO");               //上传位置Logo

        def file1 = request.getFile("filePath1")
        def file2 = request.getFile("filePath2")

        def path = servletContext.getRealPath("/");
        if (file1 && !file1.isEmpty()) {
            def filetype1 = file1.getContentType()
            if (filetype1 == "image/pjpeg" || filetype1 == "image/jpeg" || filetype1 == "image/png" || filetype1 == "image/x-png" || filetype1 == "image/gif") {
                file1.transferTo(new java.io.File("${path}/images/skin/topBg.jpg"))
            } else {
                result.message = "上传图片格式不对..."
                result.success = false;
            }
        }
        if (file2 && !file2.isEmpty()) {
            def filetype2 = file2.getContentType()
            if (filetype2 == "image/pjpeg" || filetype2 == "image/jpeg" || filetype2 == "image/png" || filetype2 == "image/x-png" || filetype2 == "image/gif") {
                file2.transferTo(new java.io.File("${path}/images/skin/x_bottom.jpg"))
            } else {
                result.message = "上传图片格式不对..."
                result.success = false;
            }
        }
        if (fileLOGO && !fileLOGO.isEmpty()) {
            def fileLOGOtype = fileLOGO.getContentType();

            if (fileLOGOtype == "image/pjpeg" || fileLOGOtype == "image/jpeg" || fileLOGOtype == "image/png" || fileLOGOtype == "image/x-png" || fileLOGOtype == "image/gif") {
                String fileName = fileLOGO.getOriginalFilename();
                int splitIndex = fileName.lastIndexOf(".");
                fileLOGOtype = fileName.substring(splitIndex + 1);
                //保存数据
                SysConfig webLogo = SysConfig.findByConfigName("webLogo");
                if (!webLogo) {
                    webLogo = new SysConfig();
                }
                webLogo.configName = "webLogo";
                webLogo.configValue = "webLogo." + fileLOGOtype;
                if (webLogo.save()) {
                    result.message = "上传图片失败..."
                    result.success = false;
                }
                //上传文件
                File webLogoPath = new File("${path}/upload/Logo/");
                if (!webLogoPath.exists()) {
                    webLogoPath.mkdirs();
                }
                fileLOGO.transferTo(new java.io.File(webLogoPath.getAbsolutePath(), "webLogo." + fileLOGOtype));
            } else {
                result.message = "上传图片格式不对..."
                result.success = false;
            }
        }
        return result;
    }
    /**
     * 访问统计
     * @param params
     * @return json
     */
    public Map resultAccess(def params) {
        int max = (params.rows as int);//每页显示个数
        int currPage = (params.page as int);//当前页数
        if (!params.sidx) {
            params.sidx = 'id'
        }
        def startDate = params.startDate
        def endDate = params.endDate
        if (!params.searchDateType) params.searchDateType = '0'
        def searchDateType = params.searchDateType
        def startTime = ''
        def endTime = ''
        //日期格式化
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
        if (startDate && startDate != '起始日期' && endDate && endDate != '结束日期') {
            startTime = startDate + ' 00:00:00'
            endTime = endDate + ' 23:59:59'
        } else {
            //当天
            if (searchDateType == '0') {
                startTime = sdf.format(new Date()) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
            //昨天
            else if (searchDateType == '1') {
                def yestoday = new Date() - 1
                startTime = sdf.format(yestoday) + ' 00:00:00'
                endTime = sdf.format(yestoday) + ' 23:59:59'
            }
            //近7天
            else if (searchDateType == '2') {
                def sevenDaysAgo = new Date() - 6
                startTime = sdf.format(sevenDaysAgo) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
            //最近30天
            else if (searchDateType == '3') {
                def daysAgo = new Date() - 29
                startTime = sdf.format(daysAgo) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
        }
        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        List<ConsumerLog> list = ConsumerLog.createCriteria().list(max: max, offset: max * (currPage - 1), order: params.sord, sort: params.sidx) {
            gt('dateCreated', sdf.parse(startTime))
            lt("dateCreated", sdf.parse(endTime))
            //between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }

        int sum = list.totalCount;//总记录数
        int total = sum % max == 0 ? sum / max : ((sum / max) as int) + 1//总页数
        def result = [:];
        result.page = params.page;
        //总页数
        result.total = total;
        result.rows = [];
        list.each {
            def tmp = [:];
            tmp.requestReferer = it.requestReferer
            tmp.requestUrl = it.requestUrl
            tmp.requestContentType = it.requestContentType
            tmp.responseContentType = it.responseContentType
            tmp.responseTime = it.responseTime
            tmp.ajaxRequest = it.ajaxRequest
            tmp.browser = isBrowser(it.userAgent)
            tmp.OS = isOS(it.userAgent)
            result.rows.add(tmp);
        }
        return result;
    }
    /**
     * 用户统计
     * @param params
     * @return json
     */
    public Map resultUser(def params) {
        int max = (params.rows as int);//每页显示个数
        int currPage = (params.page as int);//当前页数
        if (!params.sidx) {
            params.sidx = 'id'
        }
        if (params.sidx == 'ipStr') params.sidx = 'ip'
        def startDate = params.startDate
        def endDate = params.endDate
        if (!params.searchDateType) params.searchDateType = '0'
        def searchDateType = params.searchDateType
        def startTime = ''
        def endTime = ''
        //日期格式化
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
        if (startDate && startDate != '起始日期' && endDate && endDate != '结束日期') {
            startTime = startDate + ' 00:00:00'
            endTime = endDate + ' 23:59:59'
        } else {
            //当天
            if (searchDateType == '0') {
                startTime = sdf.format(new Date()) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
            //昨天
            else if (searchDateType == '1') {
                def yestoday = new Date() - 1
                startTime = sdf.format(yestoday) + ' 00:00:00'
                endTime = sdf.format(yestoday) + ' 23:59:59'
            }
            //近7天
            else if (searchDateType == '2') {
                def sevenDaysAgo = new Date() - 6
                startTime = sdf.format(sevenDaysAgo) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
            //最近30天
            else if (searchDateType == '3') {
                def daysAgo = new Date() - 29
                startTime = sdf.format(daysAgo) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
        }
        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        List<ConsumerLog> list = ConsumerLog.createCriteria().list(max: max, offset: max * (currPage - 1), order: params.sord, sort: params.sidx) {
            gt('dateCreated', sdf.parse(startTime))
            lt("dateCreated", sdf.parse(endTime))
            //between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }
        int sum = list.totalCount;//总记录数
        int total = sum % max == 0 ? sum / max : ((sum / max) as int) + 1//总页数
        def result = [:];
        result.page = params.page;
        //总页数
        result.total = total;
        result.rows = [];
        list.each {
            def tmp = [:];
            tmp.consumerName = it.consumerName
            tmp.ipStr = it.ip
            tmp.controllerName = it.controllerName
            tmp.actionName = it.actionName
            tmp.statusCode = it.statusCode
            tmp.dateCreated = new SimpleDateFormat('yyyy-MM-dd HH:mm:ss').format(it.dateCreated);
            tmp.requestMethod = it.requestMethod
            result.rows.add(tmp);
        }
        return result;
    }
    /**
     * 通用统计
     * @param params
     * @return
     */
    public String resultGeneral(def params) {
        int max = (params.rows as int);//每页显示个数
        int currPage = (params.page as int);//当前页数
        if (!params.sidx) {
            params.sidx = 'id'
        }
        def startDate = params.startDate
        def endDate = params.endDate
        if (!params.searchDateType) params.searchDateType = '0'
        def searchDateType = params.searchDateType

        def startTime = ''
        def endTime = ''

        //日期格式化
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
        if (startDate && startDate != '起始日期' && endDate && endDate != '结束日期') {
            startTime = startDate + ' 00:00:00'
            endTime = endDate + ' 23:59:59'
        } else {
            //当天
            if (searchDateType == '0') {
                startTime = sdf.format(new Date()) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
            //昨天
            else if (searchDateType == '1') {
                def yestoday = new Date() - 1
                startTime = sdf.format(yestoday) + ' 00:00:00'
                endTime = sdf.format(yestoday) + ' 23:59:59'
            }
            //近7天
            else if (searchDateType == '2') {
                def sevenDaysAgo = new Date() - 6
                startTime = sdf.format(sevenDaysAgo) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
            //最近30天
            else if (searchDateType == '3') {
                def daysAgo = new Date() - 29
                startTime = sdf.format(daysAgo) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
        }
        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")

        List<String> list = ConsumerLog.createCriteria().list(max: max, offset: max * (currPage - 1), order: params.sord, sort: params.sidx) {
            projections {
                distinct(params?.flags)
            }
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }

        List<String> listA = ConsumerLog.createCriteria().list() {
            projections {
                distinct(params?.flags)

            }
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }
        int sum = listA.size();//总记录数

        int total = sum % max == 0 ? sum / max : ((sum / max) as int) + 1//总页数
        String jStr = '';
        jStr += '{'
        jStr += '"total":' + total + ','
        jStr += '"page":' + params.page + ","
        jStr += '"rows":['

        list.each { str ->
            jStr += '{'
            if (params?.flags == 'userAgent') {
                jStr += '"' + params.flags + '":"' + isBrowser(str) + '",'
            } else {
                jStr += '"' + params.flags + '":"' + str + '",'
            }
            jStr += '"count":"'
            if (params?.flags == 'ip') {
                jStr += ConsumerLog.countByIp(str) + '"'
            }
            if (params?.flags == 'userAgent') {
                jStr += ConsumerLog.countByUserAgent(str) + '"'
            }
            if (params?.flags == 'consumerName') {
                jStr += ConsumerLog.countByConsumerName(str) + '"'
            }
            jStr += '},'
        }
        jStr = jStr.substring(0, jStr.length() - 1)
        jStr += ']'
        jStr += '}'
        return jStr;
    }
    /**
     * 判断浏览器
     * @param userAgent
     * @return
     */
    String isBrowser(def userAgent) {
        def browse = '其它'
        if (CTools.regex("IE", userAgent)) {
            browse = 'IE'
        } else if (CTools.regex("Chrome", userAgent)) {
            browse = 'Chrome'
        } else if (CTools.regex("Firefox", userAgent)) {
            browse = 'Firefox'
        }
        return browse;
    }

    String isOS(def userAgent) {
        def browse = '其它'
        if (CTools.regex("Windows NT 5.1", userAgent)) {
            browse = 'Windows XP'
        } else if (CTools.regex("Windows NT 5.2", userAgent)) {
            browse = 'Windows Server 2003'
        } else if (CTools.regex("Windows NT 6.1", userAgent)) {
            browse = 'Windows 7'
        } else if (CTools.regex("Mac OS X", userAgent)) {
            browse = '苹果'
        } else if (CTools.regex("Linux", userAgent)) {
            browse = 'linux'
        }
        return browse;
    }

    /**
     * 取得指定日的在线人数
     * @param result
     * @param startCalendar
     */
    void acquireOneDayOnlineUserCount(Map result, Calendar appointCalendar) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String date = sdf.format(appointCalendar.getTime());
        def criteria = OnlineUser.createCriteria();
        List<OnlineUser> list = criteria.list {
            eq("statisticsDate", date)
            order("id", "asc");
        };

        result.xAxis = [];
        result.series = [];
        def data = [];
        if (list.size() != 48) {
            48.times {
                def time;
                def minute;
                if (it % 2 == 0) {
                    minute = "00";
                } else {
                    minute = "30";
                }
                def hour = it / 2 as int;
                if (hour < 10) {
                    time = "0${hour}:${minute}";
                } else {
                    time = "${hour}:${minute}";
                }

                result.xAxis.add(time);
                def findResult = list.find {
                    it.statisticsTime == time;
                }
                if (findResult) {
                    data.add(findResult.onlineUserCount);
                } else {
                    data.add(0);
                }
            }
        } else {
            list.each {
                data.add(it.onlineUserCount);
                result.xAxis.add(it.statisticsTime);
            }
        }

        def serMap = [:];
        serMap.name = "在线人数";
        serMap.data = data;
        result.series.add(serMap);
        result.success = true;
    }

    /**
     * 取得指定日期最近n日的在线人数
     * @param result
     * @param startCalendar
     * @param beforeDay
     */
    void acquireBeforeDayOnlineUserCount(Map result, Calendar appointCalendar, int beforeDay) {

        Calendar ca = Calendar.getInstance();
        ca.setTimeInMillis(appointCalendar.getTimeInMillis());
        ca.add(Calendar.DAY_OF_MONTH, -(beforeDay - 1));

        Sql sql = new Sql(dataSource);

        String executeSql = "SELECT MAX(online_user_count) AS mCount, AVG(online_user_count) AS aCount, statistics_date AS dateAxis FROM online_user WHERE statistics_date BETWEEN ? AND ? GROUP BY dateAxis ORDER BY dateAxis";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String startDate = sdf.format(ca.getTime());
        String endDate = sdf.format(appointCalendar.getTime());
        def dataList = sql.rows(executeSql, [startDate, endDate]);

        result.xAxis = [];
        result.series = [];
        def maxData = [];
        def averageData = [];

        beforeDay.times {
            def date = sdf.format(ca.getTime());
            result.xAxis.add(date);

            def data = dataList.find {
                it.dateAxis == date;
            }

            if (data) {
                maxData.add(data.mCount);
                averageData.add(data.aCount as int);
            } else {
                maxData.add(0);
                averageData.add(0);
            }
            ca.add(Calendar.DAY_OF_MONTH, 1);
        }

        def serMap = [:];
        serMap.name = "最大在线人数";
        serMap.data = maxData;
        result.series.add(serMap);
        serMap = [:];
        serMap.name = "平均在线数";
        serMap.data = averageData;
        result.series.add(serMap);
        result.success = true;
    }

    /**
     * 取得指定日期范围内的在线人数
     * @param result
     * @param startCalendar
     * @param endCalendar
     */
    void acquireBetweenDaysOnlineUserCount(Map result, Calendar startCalendar, Calendar endCalendar) {

        int startYear = startCalendar.get(Calendar.YEAR)
        int startMonth = startCalendar.get(Calendar.MONTH)
        int endYear = endCalendar.get(Calendar.YEAR)
        int endMonth = endCalendar.get(Calendar.MONTH)

        // 判断起始时间和结束时间是否为同一天
        if (startYear == endYear
                && startMonth == endMonth
                && startCalendar.get(Calendar.DAY_OF_MONTH) == endCalendar.get(Calendar.DAY_OF_MONTH)) {
            acquireOneDayOnlineUserCount(result, startCalendar);
            return;
        }

        // 计算起始时间和结束时间的日数差
        long startMillis = startCalendar.getTimeInMillis();
        long endMillis = endCalendar.getTimeInMillis();
        long differMillis = endMillis - startMillis;
        long differDays = differMillis / (1000L * 3600 * 24) + 1;
        // 相差天数在31日内
        if (differDays < 32) {
            acquireBeforeDayOnlineUserCount(result, endCalendar, differDays as int);
            return;
        }

        // 计算起始时间和结束时间的月数差
        int differYear = endYear - startYear;
        int differMonth = differYear * 12 + endMonth - startMonth + 1;

        String executeSql;

        // 横向时间轴
        def xAixs = [];
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String[] sqlParams = [sdf.format(startCalendar.getTime()), sdf.format(endCalendar.getTime())];

        // 相差月数在24个月内
        if (differMonth < 25) {
            executeSql = "SELECT MAX(online_user_count) AS mCount, AVG(online_user_count) AS aCount, dateAxis FROM (SELECT online_user_count , DATE_FORMAT(statistics_date, '%Y-%m') AS dateAxis FROM online_user WHERE statistics_date BETWEEN ? AND ? ) T GROUP BY dateAxis ORDER BY dateAxis";

            // 设置横向时间轴
            SimpleDateFormat ymSdf = new SimpleDateFormat("yyyy-MM");
            differMonth.times {
                xAixs.add(ymSdf.format(startCalendar.getTime()));
                startCalendar.add(Calendar.MONTH, 1);
            }

        } else {
            executeSql = "SELECT MAX(online_user_count) AS mCount, AVG(online_user_count) AS aCount, dateAxis FROM (SELECT online_user_count , DATE_FORMAT(statistics_date, '%Y') AS dateAxis FROM online_user WHERE statistics_date BETWEEN ? AND ? ) T GROUP BY dateAxis ORDER BY dateAxis";
            // 设置横向时间轴
            for (i in startYear..endYear) {
                xAixs.add("${i}");
            }
        }

        Sql sql = new Sql(dataSource);
        def dataList = sql.rows(executeSql, sqlParams);

        result.xAxis = [];
        result.series = [];
        def maxData = [];
        def averageData = [];

        xAixs.each { aixs ->
            result.xAxis.add(aixs);
            def data = dataList.find {
                it.dateAxis == aixs;
            }

            if (data) {
                maxData.add(data.mCount);
                averageData.add(data.aCount as int);
            } else {
                maxData.add(0);
                averageData.add(0);
            }
        }

        def serMap = [:];
        serMap.name = "最大在线人数";
        serMap.data = maxData;
        result.series.add(serMap);
        serMap = [:];
        serMap.name = "平均在线数";
        serMap.data = averageData;
        result.series.add(serMap);
        result.success = true;
    }

    /**
     * 在线人数统计Job
     */
    void onlineUserCountStatisticsJob() {
        OnlineUser onlineUser = new OnlineUser();

        def servletContext = utilService.getServletContext();
        def num = servletContext.getAttribute("onlineNum");
        if (num) {
            onlineUser.onlineUserCount = num as int;
        } else {
            onlineUser.onlineUserCount = 0;
        }

        Calendar calendcar = Calendar.getInstance();
        SimpleDateFormat dSdf = new SimpleDateFormat("yyyy-MM-dd");
        onlineUser.statisticsDate = dSdf.format(calendcar.getTime());
        SimpleDateFormat tSdf = new SimpleDateFormat("HH:mm");
        onlineUser.statisticsTime = tSdf.format(calendcar.getTime());

        onlineUser.save();
    }


    private static int syncOffset = 0;

    public void syncTranscodeStateJob() {
        if (appService) {
            RMSNode rmsNode = appService.queryNodeInfo();

            try {
                String url = "http://${rmsNode.getBmcIPAddress()}:${rmsNode.bmcWebPort}/bmc2/api/queryFileInfo";
                HttpPost httpPost = new HttpPost(url);
                ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
                List batch = new ArrayList();
                def programList = Program.createCriteria().list(offset: syncOffset, max: 1000) {
                    notEqual('transcodeState', Program.STATE_SUCCESS)
                    order('id', 'desc')
                }
                syncOffset += 1000;
                if (syncOffset > programList.totalCount) {
                    syncOffset = 0;
                }
                for (Program program : programList) {
                    List<Serial> serialList = program?.serials.toList();
                    if (serialList && serialList.size() > 0) {
                        serialList.sort { serial1, serial2 ->
                            serial1.serialNo <=> serial2.serialNo
                        }
                        int transcodeCount = 0;
                        int transCodeFailCount = 0;
                        int transCodeNone = 0;
                        def fileHashes = [];

                        batch = new ArrayList();

                        httpPost = new HttpPost(url);
                        params = new ArrayList<NameValuePair>();
                        for (Serial serial1 : serialList) {
                            fileHashes.add(serial1.fileHash);

                            params.add(new BasicNameValuePair("hashes", serial1.fileHash));
                        }

                        if (fileHashes.size() > 0) {
                            httpPost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
                            HttpClient httpClient = HttpClients.createDefault();
                            log.debug("访问URL:${url},hashes:${fileHashes}")
                            try {
                                CloseableHttpResponse httpResponse = httpClient.execute(httpPost);
                                String text = httpResponse.getEntity().getContent().getText("UTF-8");
                                JSONElement result = JSON.parse(text);
                                if (result.success) {
                                    JSONArray bofulFiles = result.bofulFiles;
                                    if (bofulFiles) {
                                        def idList = [];
                                        for (int i = 0; i < bofulFiles.length(); i++) {
                                            def bofulFile = bofulFiles[i];
                                            def fileHash = bofulFile.fileHash;
                                            def state = bofulFile.transcodeState;
                                            def logicLength = bofulFile.logicLength;
                                            serialList.each { Serial serial2 ->
                                                if (!idList.contains(serial2.id)) {
                                                    if (serial2.fileHash.toUpperCase() == fileHash.toUpperCase()) {
                                                        if (state == Program.STATE_SUCCESS) {
                                                            transcodeCount++;
                                                            serial2.state = Serial.CODED_STATE;
                                                            serial2.timeLength = logicLength;
                                                        } else if (state == Program.STATE_FAIL) {
                                                            transCodeFailCount++;
                                                            serial2.state = Serial.CODED_FAILED_STATE;
                                                            serial2.timeLength = logicLength;
                                                        } else if (state == Program.STATE_NONE) {
                                                            transcodeCount++;
                                                            serial2.state = Serial.NO_NEED_STATE;
                                                            serial2.timeLength = logicLength;
                                                        }
                                                        batch.add(serial2);
                                                        idList.add(serial2.id);
                                                    }
                                                }
                                            }
                                        }

                                        if (batch.size() > 0) {
                                            for (Serial serial3 : batch) {
                                                def serial4 = Serial.lock(serial3.id);
                                                serial4.state = serial3.state;
                                                serial4.timeLength = serial3.timeLength;
                                                serial4.save(flush: true);
                                            }
                                            batch.clear();
                                        }
                                    }
                                } else {
                                    log.error("查询失败");
                                }
                            } catch (Exception e) {
                                log.error(e.message, e);
                            }

                            Program.withTransaction {
                                if (transcodeCount == serialList.size()) {
//                                    syncPosterImg(program);
                                    program.transcodeState = Program.STATE_SUCCESS;
                                    program.save();
                                    def SeniorSearchOpt = SysConfig.findByConfigName('SeniorSearchOpt');
                                    if (SeniorSearchOpt && Boolean.parseBoolean(SeniorSearchOpt.configValue)) {
                                        //同步索引
                                        if (searchService.searchByGuid(program, program.guid) == null) {
                                            searchService.addProgramIndex(program);
                                        } else {
                                            searchService.updateProgramIndex(program);
                                        }
                                    }

                                } else {
                                    if (transcodeCount > 0) {
                                        program.transcodeState = Program.STATE_SUCCESS_PART;
                                        program.save();
                                    }
                                    if (transCodeFailCount > 0) {
                                        program.transcodeState = Program.STATE_FAIL;
                                        program.save();
                                    }
                                }
                            }
                        }
                    }
                }
            } catch (Exception e) {
                log.error(e.message, e);
            }
        }
    }
}
