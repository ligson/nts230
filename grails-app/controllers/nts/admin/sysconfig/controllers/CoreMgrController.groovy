package nts.admin.sysconfig.controllers

import grails.converters.JSON
import nts.meta.domain.MetaContent
import nts.meta.domain.MetaDefine
import nts.meta.domain.MetaEnum
import nts.program.category.domain.ProgramCategory
import nts.system.domain.ConsumerLog
import nts.system.domain.Directory
import nts.system.domain.News
import nts.system.domain.OperationLog
import nts.system.domain.SysConfig
import nts.system.domain.Tools
import nts.system.domain.OperationEnum
import nts.user.domain.Consumer
import nts.user.domain.UserGroup
import nts.user.services.ActionNameAnnotation
import nts.user.services.ControllerNameAnnotation
import nts.user.services.PatternNameAnnotation
import nts.utils.CTools

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

/**
 * 系统管理
 */
@ControllerNameAnnotation(name = "系统管理")
class CoreMgrController {

    def metaDefineService
    def programService
    def newsService
    def coreMgrService
    def appService

    @ActionNameAnnotation(name = "主页")
    def index() {
        return redirect(action: 'localWebServerConfig')
    }

    //---2009-8-20 新增  systemSet  设置属性
    @ActionNameAnnotation(name = "系统设置")
    def systemSet() {
        def result = [:];
        result = coreMgrService.systemSet(params);
        flash.message = result.message;
        redirect(action: "systemConfig")    //流媒体核心版本
    }

    //---2009-8-20 新增systemConfig ，跳转到系统设置页面
    @ActionNameAnnotation(name = "系统设置显示")
    def systemConfig() {
        def result = [:];
        result = coreMgrService.systemConfig(params);
        return render(view: 'index', model: [videoPort      : result.videoPort, uploadPort: result.uploadPort, UploadRootPath: result.UploadRootPath, VideoSevr: result.VideoSevr, AbbrImgSize: result.AbbrImgSize, AbbrImgRowPerNum: result.AbbrImgRowPerNum,
                                             vodCoreVer     : result.vodCoreVer, provinceIp: result.provinceIp, provinceWebPort: result.provinceWebPort, localWebPort: result.localWebPort, centerGrade: result.centerGrade,
                                             applicationName: result.applicationName, applicationBottom: result.applicationBottom, outPlayFrequency: result.outPlayFrequency,
                                             transcodingIp  : result.transcodingIp, transcodingPort: result.transcodingPort, transcodingPath: result.transcodingPath, transcodeFormat: result.transcodeFormat, showModOpt: result.showModOpt, distributeModState: result.distributeModState, defaultPlayFormat: result.defaultPlayFormat,
                                             thumbnailSize1 : result.thumbnailSize1, thumbnailSize2: result.thumbnailSize2, thumbnailPos: result.thumbnailPos,
                                             emailRootDir   : result.emailRootDir, email: result.email, emailPop3: result.emailPop3, emailSmtp: result.emailSmtp, emailUserName: result.emailUserName, emailPassword: result.emailPassword,
                                             remarkAuthOpt  : result.remarkAuthOpt, playLogOpt: result.playLogOpt, viewLogOpt: result.viewLogOpt, autoPlayTime: result.autoPlayTime, fileDelOpt: result.fileDelOpt, lineList: result.lineList]);
    }
    /**
     * 本地web服务器配置
     */
    @PatternNameAnnotation(name = "本地web服务器配置")
    @ActionNameAnnotation(name = "本地web服务器配置")
    def localWebServerConfig() {
        def model = programService.localWebServerConfig();
        return render(view: 'localWebServerConfig', model: model);
    }
    /**
     * 本地web服务器配置Set
     */
    @PatternNameAnnotation(name = "本地web服务器配置")
    @ActionNameAnnotation(name = "本地web服务器配置Set")
    def localWebServerConfigSet() {
        int LocalWebPort = 80;
        try {
            LocalWebPort = params.LocalWebPort as int;
            if (LocalWebPort >= 1 && LocalWebPort <= 65535) {
                params.LocalWebPort = LocalWebPort;
            }
        } catch (Exception e) {
            params.LocalWebPort = LocalWebPort;
        }
        programService.localWebServerConfigSet(params);
        flash.message = "设置完成，如修改了应用程序名或页脚，需要重启WEB服务！"
        redirect(action: "localWebServerConfig")    //流媒体核心版本
    }
    /**
     * 文件服务器配置
     */
    @PatternNameAnnotation(name = "文件服务器配置")
    @ActionNameAnnotation(name = "文件服务器配置")
    def fileServerConfig() {
        def model = programService.fileServerConfig();
        return render(view: 'fileServerConfig', model: model);
    }
    /**
     * 文件服务器配置Set
     */
    @PatternNameAnnotation(name = "文件服务器配置")
    @ActionNameAnnotation(name = "文件服务器配置Set")
    def fileServerConfigSet() {
        def VideoSevr = params.VideoSevr;
        def videoPort = params.videoPort;
        def uploadPort = params.uploadPort;
        def setSure = true;
        //ipv4
        def exp = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
        //ipv6
        def exp2 = /^([\da-fA-F]{1,4}:){7}[\da-fA-F]{1,4}$/;
        //域名验证
        def exp3 = /^(([0-9a-z_!~*'()-]+\.)*([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\.[a-z]{2,6})$/
        try {
            if (!VideoSevr.matches(exp) && !VideoSevr.matches(exp2) && !VideoSevr.matches(exp3)) {
                flash.message = "视频服务器IP地址设置错误";
                setSure = false;
            }
            videoPort = videoPort as int;
            uploadPort = uploadPort as int;
            if (videoPort < 0 && videoPort > 65535) {
                flash.message = "视频服务端口设置错误";
                setSure = false;
            }
            if (uploadPort < 0 && uploadPort > 65535) {
                flash.message = "上传服务端口设置错误";
                setSure = false;
            }
            if (setSure) {
                programService.fileServerConfigSet(params);
                appService.initAppService();
            }
        } catch (Exception e) {
            flash.message = "文件服务器配置设置错误！";
        }
        redirect(action: "fileServerConfig");
    }

    /**
     * 文件服务器配置
     */
    @PatternNameAnnotation(name = "上传文件最大容量配置")
    @ActionNameAnnotation(name = "上传文件最大容量配置")
    def fileSizeLimitConfig() {
        def model = programService.fileSizeLimitConfig();
        return render(view: 'fileSizeLimitConfig', model: model);
    }

    /**
     * 文件服务器配置Set
     */
    @ActionNameAnnotation(name = "上传文件最大容量配置Set")
    def fileSizeLimitConfigSet() {
        try {
            programService.fileSizeLimitConfigSet(params);
        } catch (Exception e) {
            flash.message = "上传文件最大容量配置错误！";
        }
        redirect(action: "fileSizeLimitConfig");
    }

    /**
     * logo显示
     * @return
     */
    @PatternNameAnnotation(name = "logo显示")
    @ActionNameAnnotation(name = "logo显示")
    def logoConfig() {
    }
    /**
     * logo修改
     * @return
     */
    @PatternNameAnnotation(name = "logo显示")
    @ActionNameAnnotation(name = "logo修改")
    def logoConfigSet() {
        def result = [:];
        result = coreMgrService.saveFile();
        if (!result.success) {
            flash.message = result.message;
        }
        redirect(action: 'logoConfig');
    }
    /**
     * 文件保存
     * @return
     */
    def saveFile() {
        def fileLOGO = request.getFile("fileLOGO");               //上传位置Logo

        def file1 = request.getFile("filePath1")
        def file2 = request.getFile("filePath2")

        def path = servletContext.getRealPath("/");
        if (file1 && !file1.isEmpty()) {
            def filetype1 = file1.getContentType()
            if (filetype1 == "image/pjpeg" || filetype1 == "image/jpeg" || filetype1 == "image/png" || filetype1 == "image/x-png" || filetype1 == "image/gif") {
                file1.transferTo(new java.io.File("${path}/images/skin/topBg.jpg"))
            } else {
                flash.message = "上传图片格式不对..."
            }
        }
        if (file2 && !file2.isEmpty()) {
            def filetype2 = file2.getContentType()
            if (filetype2 == "image/pjpeg" || filetype2 == "image/jpeg" || filetype2 == "image/png" || filetype2 == "image/x-png" || filetype2 == "image/gif") {
                file2.transferTo(new java.io.File("${path}/images/skin/x_bottom.jpg"))
            } else {
                flash.message = "上传图片格式不对..."
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
                    flash.message = "上传图片失败..."
                }
                //上传文件
                fileLOGO.transferTo(new java.io.File("${path}/upload/Logo/webLogo." + fileLOGOtype));
            } else {
                flash.message = "上传图片格式不对..."
            }
        }
    }

    def metaDefineList() {
//session.consumer = nts.user.domain.Consumer.get(1)//易于测试
        if (!params.max) params.max = 1000
        def metaDefineList = null
        def directoryList = null
        def directoryId = CTools.nullToZero(params.directoryId)

        if (directoryId > 0) {
            def criteria = MetaDefine.createCriteria()
            metaDefineList = criteria.list {
                or {
                    sizeEq("directorys", 0)
                    directorys {
                        eq('id', directoryId.toLong())
                    }
                }
                order("showOrder", "asc")
            }
        } else {
            metaDefineList = MetaDefine.listOrderByShowOrder()
        }

        directoryList = Directory.findAllByParentId(0, [sort: "showOrder", order: "asc"])

        if (flash.createJs) metaDefineService.creatMetaJs()//排序时重新生成js

        def model = [metaDefineList: metaDefineList, directoryList: directoryList, directoryId: directoryId]
        return render(view: 'metaDefineList', model: model);
    }


    def metaDefineCreate = {
        def directoryList = null
        directoryList = Directory.findAllByParentId(0, [sort: "showOrder", order: "asc"])
        [directoryId: params.directoryId, directoryList: directoryList]
    }

    def metaDefineEdit = {
        def directoryList = null
        def metaDefine = MetaDefine.get(params.id)
        if (metaDefine) {
            directoryList = Directory.findAllByParentId(0, [sort: "showOrder", order: "asc"])
            return [metaDefine: metaDefine, directoryList: directoryList, directoryId: params.directoryId]
        } else {
            flash.message = "program not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def metaDefineDelete = {
        MetaDefine metaDefine = MetaDefine.get(params.id)
        if (metaDefine && session.consumer.role == Consumer.SUPER_ROLE) {
            //删除元素下修饰词，手动维护完整性
            if (metaDefine.dataType == "decorate" || metaDefine.dataType == "decorate2") {
                MetaDefine.findAllByParentId(metaDefine.id as int).each {
                    it?.directorys?.toList()?.each { directory ->
                        directory.removeFromMetaDefines(it)
                    }

                    it.delete();
                }
            }

            metaDefine?.directorys?.toList()?.each {
                it.removeFromMetaDefines(metaDefine)
            }
            metaDefine.delete(flush: true)
            metaDefineService.creatMetaJs()
        } else {
            flash.message = "metaDefine not found with id ${id}"
        }

        redirect(action: "metaDefineList")
    }

    def metaDefineUpdate = {
        def metaDefine = MetaDefine.get(params.id);
        //metaDefine && session.consumer.role == Consumer.SUPER_ROLE
        if (metaDefine) {
            def oldPrentId = metaDefine.parentId    //修改前的父ID
            params.maxLength = CTools.nullToZero(params.maxLength)
            params.parentId = CTools.nullToZero(params.parentId)
            params.isNecessary = CTools.nullToZero(params.isNecessary)
            if (params.elementType == '1') params.dataType = "decorate"

            metaDefine.properties = params
            metaDefine.creatorName = session.consumer.name
            metaDefine.dateModified = new Date()

            //设置类库
            def allClass = CTools.nullToOne(params.allClass)
            if (allClass == 0) {
                //删除以前存在的 ,注意参数中不能有名为directorys的参数，否则metaDefine?.directorys不是数据库的对象列表了
                metaDefine?.directorys?.toList().each {
                    it.removeFromMetaDefines(metaDefine)
                }

                //设置类库
                def dirIdList = params.selDirectory
                if (dirIdList instanceof String) dirIdList = [params.selDirectory]
                dirIdList?.each {
                    metaDefine.addToDirectorys(Directory.get(it))
                }
            }

            //设置枚举
            if (metaDefine.dataType == "enumeration") {
                //删除以前存在的
                metaDefine?.metaEnums?.toList().each {
                    it.delete() //不加出现 not-null property
                    metaDefine.removeFromMetaEnums(it)
                }

                def maxEnumId = CTools.nullToZero(params.maxEnumId)
                def dateModified = new Date()
                for (int i = 1; i <= maxEnumId; i++) {
                    def enumId = CTools.strToInt(params."enumId${i}")
                    def enumName = params."enumName${i}"
                    if (enumId >= 0 && enumName) {
                        metaDefine.addToMetaEnums(new MetaEnum(enumId: enumId, name: enumName, dateModified: dateModified))
                    }
                }
            }

            //设置显示状态
            def showType = 0;
            params.showTypeList.each {
                showType += CTools.nullToZero(it)
            }
            metaDefine.showType = showType

            //设置搜索状态
            def searchType = 0;
            params.searchTypeList.each {
                searchType += CTools.nullToZero(it)
            }
            metaDefine.searchType = searchType
            if (metaDefine.save()) {
                metaDefineService.creatMetaJs()
                //如果修饰修饰词更改了父元素，MetaContent表中的parentId也同步修改
                if (oldPrentId != metaDefine.parentId) updateMetaContentParentId(metaDefine)
                redirect(action: "metaDefineList", params: [directoryId: params.directoryId])
            } else {
                render(view: 'metaDefineEdit', model: [metaDefine: metaDefine])
            }
        } else {
            flash.message = "metaDefine not found with id ${params.id}"
            redirect(action: "metaDefineEdit", id: params.id)
        }
    }
    //同步MetaContent表中的parentId
    def updateMetaContentParentId = { metaDefine ->
        MetaContent.executeUpdate("update nts.meta.domain.MetaContent  set parentId = :parentId  where metaDefine = :metaDefine", [parentId: metaDefine.parentId, metaDefine: metaDefine])
    }
    def metaDefineSave = {
        def result = metaDefineService.createMetaDefine(params);
        if (result.success) {
            return redirect(action: "metaDefineList", params: [directoryId: result.directoryId])
        } else {
            return render(view: 'metaDefineCreate', model: [metaDefine: result.metaDefine])
        }
    }

    //两个相邻的元数据交换showOrder值，没有直接到list页面，是防止刷新时进行排序
    def setShowOrder = {
        def metaDefine = MetaDefine.get(params.curId)
        def metaDefine2 = MetaDefine.get(params.otherId)
        if (metaDefine && metaDefine2) {
            def showOrder = metaDefine.showOrder
            metaDefine.showOrder = metaDefine2.showOrder
            metaDefine2.showOrder = showOrder
        }

        redirect(action: "metaDefineList", params: params)
        flash.createJs = true
    }

    def findParentMetaOption = {
        def result = metaDefineService.findParentMetaOption(params);
        return render(result as JSON);
    }

    //元数据导出到xml
    def metaToXml = {
        def metaDefineList = null
        def metaEnumList = null
        def writer = null
        def xml = null
        def filePath = ''
        def fileName = ''

        metaDefineList = MetaDefine.listOrderByShowOrder()
        metaEnumList = MetaEnum.listOrderByMetaDefine()

        fileName = "meta" + CTools.readNowDateTime('yyyyMMdd') + ".xml";
        filePath = servletContext.getRealPath("/") + "/xml/${fileName}"
        filePath = filePath.replace('\\', '/')//单个字符可全替换
        filePath = filePath.replace('//', '/')//单个字符可全替换
        writer = new FileWriter(new File(filePath))
        writer.write("<?xml version=\"1.0\" encoding=\"GBK\"?>\n");
        xml = new groovy.xml.MarkupBuilder(writer)


        xml.metaData() {
            xml.metaDefines() {
                metaDefineList.each {
                    metaDefine(id: it.id, parentId: it.parentId, libraries: it.directorys, name: it.name, cnName: it.cnName, dataType: it.dataType, defaultValue: it.defaultValue, isNecessary: it.isNecessary, showType: it.showType, searchType: it.searchType, maxLength: it.maxLength, showOrder: it.showOrder, metaEnums: it.metaEnums, dateCreated: it.dateCreated, dateModified: it.dateModified)
                }
            }

            xml.metaEnums() {
                metaEnumList.each {
                    metaEnum(id: it.id, enumId: it.enumId, metaDefineId: it.metaDefine.id, name: it.name)
                }
            }
        }

        render("成功备份到：${filePath}。")
    }

    //获得树目录中的枚举li标签列表
    /*def getMetaEnumsLiTag(metaDefine) {
        def sHtml = '<ul>'
        if (metaDefine.dataType == "enumeration") {
            metaDefine.metaEnums.each {
                sHtml += '<li class="Child"><img class=s src="../images/tree/sp.gif"><a href="#" onclick="toViewAction(this,1,' + metaDefine.id + ',' + it.enumId + ',0);return false;">' + it.name.encodeAsJavaScript() + '</a></li>'
            }
        }
        sHtml += '</ul>'
        return sHtml
    }*/

    //检测元数据名称是否已存在
    def checkMetaNameExist = {
        def result = [:];
        def exist = "not exist"
        def metaDefine = MetaDefine.findByName(params.value)

        if (metaDefine && metaDefine.id != params.id.toLong()) exist = "exist"

        result.success = exist.equals("exist")
        return render(result as JSON);
    }

    @ActionNameAnnotation(name = "目录管理")
    def directoryList() {

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'showOrder'
        if (!params.offset) params.offset = 0

        def total = Directory.count()
        return render(view: 'directoryList', model: [directoryList: Directory.list(params), total: total]);
    }

    @ActionNameAnnotation(name = "目录删除")
    def directoryDelete() {
        def result = [:];
        result = coreMgrService.directoryDelete(params);
        flash.message = result.message;
        if (result.success) {
            redirect(action: "directoryList", params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
        } else {
            redirect(action: "directoryList")
        }
    }

    //---2009-04-09修改 创建类库
    @ActionNameAnnotation(name = "目录保存")
    def directorySave() {
        def result = [:];
        result = coreMgrService.directorySave(params);
        if (result.success) {
            flash.message = result.message;
            redirect(action: "directoryList", params: [offset: params.offset])
        } else {
            render(view: "directoryList", model: [directory: result.directory], params: [offset: params.offset])
        }
    }

    //上传图片(opt：值为save表示添加图片，值为update表示修改图片)
    def uploadImg(def opt) {
        def imgFile = request.getFile(opt + "Img")
        def imgType = imgFile.getContentType()

        def path = servletContext.getRealPath("/upload");

        def imgPath = ""

        if (imgFile && !imgFile.isEmpty()) {
            if (imgType == "image/pjpeg" || imgType == "image/jpeg" || imgType == "image/png" || imgType == "image/x-png" || imgType == "image/gif") {

                File directoryImg = new File("${path}/directoryImg/");
                if(!directoryImg.exists()){
                    directoryImg.mkdirs();
                }

                if (opt == "save") {
                    def pt = Directory.createCriteria()
                    def id = pt.get {
                        projections {
                            max "id"
                        }
                    }
                    id = id == null ? 1 : id + 1
                    imgPath = "i_" + id + ".jpg"
                    imgFile.transferTo(new java.io.File(directoryImg.getAbsolutePath(), imgPath))
                } else if (opt == "update") {
                    def directory = Directory.get(params.updateId)
                    def id = directory.id
                    imgPath = "i_" + id + ".jpg"
                    imgFile.transferTo(new java.io.File(directoryImg.getAbsolutePath(), imgPath))
                }
            } else {
                flash.message = "上传图片格式不对..."
            }
        }
        return imgPath
    }

    @ActionNameAnnotation(name = "目录更新")
    def directoryUpdate() {
        def result = [:];
        result = coreMgrService.directoryUpdate(params);
        flash.message = result.message;
        if (result.notFind) {
            redirect(action: "directoryEdit", id: params.id)
        } else {
            redirect(action: "directoryList", params: [offset: params.offset, sort: params.sort, order: params.order, max: params.max])
        }
    }

    @ActionNameAnnotation(name = "目录修改")
    def directoryEdit() {
        def page = params.page
        if (page == "") {                //判断书页是否是第一页，如果是第一页无法传page值
            page = "0"
        }
        def directory = Directory.get(params.id)
        if (!directory) {
            flash.message = "nts.system.domain.Directory not found with id ${params.id}"
            redirect(action: "directoryList", params: [offset: page])
        } else {
            return [directory: directory, userGroupList: UserGroup.list(), directoryListAll: Directory.list(), 'page': page]
        }
    }

    //分类管理
    @ActionNameAnnotation(name = "资源分类管理")
    def programCategoryMgr() {

    }

    @ActionNameAnnotation(name = "分类管理")
    def categoryList() {

    }

    @ActionNameAnnotation(name = "资源分类管理")
    def listProgramCategory() {
        def categories = [];
        if (params.pid) {
            categories = ProgramCategory.findAllByParentCategory(ProgramCategory.get(params.pid), [sort: "orderIndex", order: "asc"]);
        } else {
            //categories = ProgramCategory.findAllByParentCategoryIsNull([order: "asc"]);
            categories = ProgramCategory.findAllByParentCategory(ProgramCategory.findByParentCategoryIsNull(), [sort: "orderIndex", order: "asc"]);
        }

        def result = [];
        categories.each { ProgramCategory category ->
            def tmp = [:];
            tmp.id = category.id;
            tmp.name = category.name;
            tmp.description = category.description;
            tmp.isParent = ProgramCategory.countByParentCategory(category) > 0;
            if (category.parentCategory) {
                tmp.pid = category.parentCategory.id;
            }
            result.add(tmp);
        }
        return render(result as JSON);
    }

    @ActionNameAnnotation(name = "资源分类创建")
    def createProgramCategory() {
        def result = programService.createProgramCategory(params)
        if (params.returnType && params.returnType.toString().equals("json")) {
            return render(result as JSON);
        }
        if (result.success) {
            return redirect(action: 'programCategoryMgr')
        } else {
            return render(view: 'programCategoryMgr', model: [errorMsg: result.msg]);
        }
    }

    @ActionNameAnnotation(name = "资源分类修改")
    def modifyProgramType() {
        def result = programService.modifyProgramCategory(params)
        return render(result as JSON);
    }

    @ActionNameAnnotation(name = "资源分类删除")
    def removeProgramType() {
        def result = [:];
        ProgramCategory programCategory = ProgramCategory.get(params.id as int);
        if (programCategory.allowDelete == true) {
            result = programService.removeProgramCategory(params)
        } else {
            result.msg = "固定分类不能删除!"
        }
        return render(result as JSON);
    }

    /***************************系统公告start*********************************/
    //系统公告列表
    @PatternNameAnnotation(name = "新闻资讯列表")
    @ActionNameAnnotation(name = "新闻资讯列表")
    def newsList() {
        def total                                        //声明列表结果行数
        def newsList                                    //声明结果集

        newsList = newsSearch();
        total = newsList.totalCount

        return render(view: 'newsList', model: [newsList: newsList, total: total])

    }
    //查询公告
    @ActionNameAnnotation(name = "查询公告")
    def newsSearch() {
        return newsService.newsSearch(params);
    }

    //删除公告
    @ActionNameAnnotation(name = "删除公告")
    def newsDelete() {
        def page = params.page

        coreMgrService.newsDeleteList();

        if (page == "") {        //判断书页是否是第一页，如果是第一页无法传page值
            page = "0"
        }
        redirect(action: 'newsList', params: [offset: page])
    }
    //删除多个公告
    @PatternNameAnnotation(name = "新闻资讯列表")
    @ActionNameAnnotation(name = "删除多个公告")
    def newsDeleteList() {
        coreMgrService.newsDeleteList(params);
        redirect(action: 'newsList', params: params)
    }

    //删除单个公告
    @PatternNameAnnotation(name = "新闻资讯列表")
    @ActionNameAnnotation(name = "删除单个公告")
    def newDelete() {
        def result = [:];
        result = coreMgrService.newDelete(params);
        flash.message = result.message;
        redirect(action: 'newsList', params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
        def news = News.get(params.id as int)
    }

    //添加公告
    @PatternNameAnnotation(name = "新闻资讯列表")
    @ActionNameAnnotation(name = "添加公告")
    def newsCreate() {
        def news = new News()
        news.properties = params
        return render(view: 'newsCreate', model: [news: news])
    }

    //修改公告
    @PatternNameAnnotation(name = "新闻资讯列表")
    @ActionNameAnnotation(name = "公告更新")
    def newsUpdate() {
        def result = [:];
        result = coreMgrService.newsUpdate(params);
        flash.message = result.message;
        if (result.success) {
            redirect(action: 'newsList', params: [newsId: result.news.id, max: params.max, sort: params.sort, order: params.order, offset: params.offset, searchTitle: params.searchTitle, searchContent: params.searchContent, searchPublisher: params.searchPublisher, searchDate: params.searchDate])
        } else {
            if (result.notFind) {
                redirect(action: 'newsEdit', params: [newsId: result.news.id, max: params.max, sort: params.sort, order: params.order, offset: params.offset, searchTitle: params.searchTitle, searchContent: params.searchContent, searchPublisher: params.searchPublisher, searchDate: params.searchDate])
            } else {
                render(view: 'newsList', model: [news: result.news]);
            }
        }
    }

    //判断公告是否存在
    @PatternNameAnnotation(name = "新闻资讯列表")
    @ActionNameAnnotation(name = "修改公告")
    def newsEdit() {
        def news = News.get(params.newsId as int)
        if (!news) {
            flash.message = "没有该公告"
            redirect(action: 'newsList')
        } else {
            return render(view: 'newsEdit', model: [news: news])
        }
    }

    //保存公告
    @PatternNameAnnotation(name = "新闻资讯列表")
    @ActionNameAnnotation(name = "保存公告")
    def newsSave() {
        def result = [:];
        result = coreMgrService.newsSave(params);
        flash.message = result.message;
        redirect(action: 'newsList', params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
    }
    /***************************系统公告end*********************************/

    /***************************系统日志start*******************************/
    @PatternNameAnnotation(name = "日志管理")
    @ActionNameAnnotation(name = "日志管理")
    def operationLogList() {
        def logList =newsService.logSearch(params);
        def total = logList.totalCount

        if (params._idList) params._idList = null
        if (params.idList) params.idList = null
        return render(view: 'operationLogList', model: [logList: logList, total: total])
    }

    @ActionNameAnnotation(name = "日志查询")
    def operationSearchLog() {
        return newsService.logSearch(params);
    }

    @ActionNameAnnotation(name = "日志删除")
    def deleteOperationLog() {
        newsService.deleteOperationLog(params);

        if (params._idList) params._idList = null
        if (params.idList) params.idList = null
        redirect(action: "operationLogList", params: params)
    }

    @ActionNameAnnotation(name = "所有日志删除")
    def deleteAllLog() {
        def delSql =' '
        def operation
        def searchConsumer = params.searchConsumer
        def searchOperation  = params.searchOperation
        def searchDate = params.searchDate


        if (searchConsumer)
        {
            delSql = delSql+ " and operator = '${searchConsumer}'" //+" ' ${searchConsumer} ' "
        }
        if (searchOperation)
        {
            delSql = delSql + " and operation =  "+OperationEnum."${searchOperation}".id
        }
        if (searchDate)
        {
            delSql = delSql + " and  dateCreated   between '${searchDate} 00:00:00' and '${searchDate} 23:59:59' "
        }

        if (delSql)
        {
            OperationLog.executeUpdate("delete OperationLog c where 1=1  ${delSql} ")
        }

        if(params._idList) params._idList = null
        if(params.idList) params.idList = null

        redirect(action:"operationLogList" , params:params)
    }
    /***************************系统日志end*********************************/

    /***************************系统工具start*******************************/
    //工具列表
    @PatternNameAnnotation(name = "工具列表")
    @ActionNameAnnotation(name = "工具列表")
    def toolsList() {
        if (!params.max) params.max = 200
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.offset) params.offset = 0

        def total = Tools.count()
        return render(view: 'toolsList', model: [toolsList: Tools.list(params), total: total])
    }

    //修改工具
    @ActionNameAnnotation(name = "修改工具")
    def toolsEdit() {
        def toolsInstance = Tools.get(params.id)
        if (!toolsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tools.label', default: 'nts.system.domain.Tools'), params.id])}"
            redirect(action: "toolsList")
        } else {
            return render(view: 'toolsEdit', model: [toolsInstance: toolsInstance])
        }
    }

    //添加工具
    @PatternNameAnnotation(name = "工具列表")
    @ActionNameAnnotation(name = "添加工具")
    def toolsCreate() {
        def toolsInstance = new Tools()
        toolsInstance.properties = params
        return render(view: 'toolsCreate', model: [toolsInstance: toolsInstance])
    }

    //保存工具
    @PatternNameAnnotation(name = "工具列表")
    @ActionNameAnnotation(name = "保存工具")
    def toolsSave() {
        def result = [:];
        result = coreMgrService.toolsSave(params);
        if (result.success) {
            flash.message = result.message;
            redirect(action: "toolsList")
        } else {
            render(view: "toolsCreate", model: [tools: result.tools])
        }
    }

    //删除工具
    @PatternNameAnnotation(name = "工具列表")
    @ActionNameAnnotation(name = "删除工具")
    def toolsDelete() {
        def result = [:];
        result = coreMgrService.toolsDelete(params);
        flash.message = result.message;
        redirect(action: "toolsList")
    }
    /***************************系统工具end*********************************/

    //导出日志
    def exportExecl = {
        SimpleDateFormat  sdf = new SimpleDateFormat( "yyyy-MM-dd HH:mm:ss" );		//声明时间格式化对像
        java.util.Date begin_date= null;
        java.util.Date end_date= null ;

        if(!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'

        def searchConsumer = params.searchConsumer
        def searchOperation  = params.searchOperation
        def beginDate            = params.beginDate
        def endDate               = params.endDate

        def dateBegin							//创建开始时间
        def dateEnd							//创建结束时间

        if (beginDate && !endDate)							//用户判断用使用的是哪一种时间段查询方式
        {
            dateBegin=params.beginDate+' 00:00:01'
            dateEnd=params.beginDate+' 23:59:59'

            begin_date = sdf.parse(dateBegin);
            end_date=sdf.parse(dateEnd);
        }
        else if (beginDate && endDate)
        {
            dateBegin=params.beginDate+' 00:00:01'
            dateEnd=params.endDate+' 23:59:59'
            begin_date = sdf.parse(dateBegin);
            end_date=sdf.parse(dateEnd);
        }


        def execlList = OperationLog.createCriteria().list(sort:params.sort,order:params.order) {
            //根据用户名称查询
            if (searchConsumer)
            {
                searchConsumer=searchConsumer.trim()
                like('operator',"%${searchConsumer}%");
                //eq('operator' , searchConsumer)
            }

            //根据操作类型查询
            if (searchOperation)
            {
                eq('operation' , OperationEnum."${searchOperation}")
            }

            //根据操作日期查询
            if (beginDate)
            {
                between("dateCreated",begin_date,end_date)
            }

        }
        render(view: "exportExecl", model: [execlList:execlList])
    }

    //系统公告
    @PatternNameAnnotation(name = "系统公告")
    @ActionNameAnnotation(name = "系统公告")
    def sysNotice(){
        def sysNotice = SysConfig.findByConfigName('SysNotice')
        render(view: "sysNotice", model: [sysNotice: sysNotice])
    }

    //设置系统公告
    @PatternNameAnnotation(name = "系统公告")
    @ActionNameAnnotation(name = "设置系统公告")
    def sysNoticeSet() {
        def result = [:];
        def notice = params.notice
        notice = CTools.htmlToBlank(notice);
        def sysNotice = SysConfig.findByConfigName('SysNotice')
        if(sysNotice){
            sysNotice.configValue = notice
            if(!sysNotice.hasErrors() && sysNotice.save(flush: true)){
                result.success = true;
                result.msg = '系统公告设置成功';
                servletContext.sysNotice = notice
            }
            else{
                result.success = false;
                result.msg = '系统公告设置失败'
            }
        }
        else{
            def sysConfig = new SysConfig(
                configDesc: '系统公告',
                configName: 'SysNotice',
                configValue: notice
            )
            if(!sysConfig.hasErrors() && sysConfig.save()){
                result.success = true;
                result.msg = '系统公告设置成功'
                servletContext.sysNotice = notice
            }
            else{
                result.success = false;
                result.msg = '系统公告设置失败'
            }
        }
        render(result as JSON)
    }
    @PatternNameAnnotation(name = "访问统计")
    @ActionNameAnnotation(name = "访问统计")
    def accessStatistics(){
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order){
            params.order = 'desc'
        }
        if (!params.offset) params.offset = 0

        def browseCount = 0 //浏览量
        def visitorCount = 0 //访客数
        def ieBrowserCount = 0 //ie浏览器访问量
        def fireFoxBrowserCount = 0 //火狐浏览器访问量
        def chromeBrowserCount = 0 //谷歌浏览器访问量
        def otherBrowserCount = 0 //其它浏览器访问量
        def iePercent = 0 //ie浏览器访问百分比
        def fireFoxPercent = 0 //火狐浏览器访问百分比
        def chromePercent = 0 //谷歌浏览器访问百分比
        def otherPercent = 0 //其它浏览器访问百分比
        def xpOSCount = 0 //WIN XP访问量
        def twoOSCount = 0 //WIN2003访问量
        def sevenOSCount = 0 //WIN7访问量
        def macOSCount = 0 //苹果访问量
        def xpPercent = 0 //WIN XP访问百分比
        def twoPercent = 0 //WIN2003访问百分比
        def sevenPercent = 0 //WIN7访问百分比
        def macPercent = 0 //苹果访问百分比
        def consumerLogList = [] //访问记录列表

        def startDate = params.startDate
        def endDate = params.endDate

        if(!params.searchDateType) params.searchDateType = '0'
        def searchDateType = params.searchDateType
        def startTime = ''
        def endTime = ''

        //日期格式化
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
        if(startDate && startDate != '起始日期' && endDate && endDate != '结束日期'){
            startTime = startDate + ' 00:00:00'
            endTime = endDate + ' 23:59:59'
        }
        else{
            //当天
            if(searchDateType == '0'){
                startTime = sdf.format(new Date()) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
            //昨天
            else if(searchDateType == '1'){
                def yestoday = new Date() - 1
                startTime = sdf.format(yestoday) + ' 00:00:00'
                endTime = sdf.format(yestoday) + ' 23:59:59'
            }
            //近7天
            else if(searchDateType == '2'){
                def sevenDaysAgo = new Date() - 6
                startTime = sdf.format(sevenDaysAgo) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
            //最近30天
            else if(searchDateType == '3'){
                def daysAgo = new Date() - 29
                startTime = sdf.format(daysAgo) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
        }

        //数字格式化
        DecimalFormat decimalFormat = new DecimalFormat("###.##");

        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        consumerLogList = ConsumerLog.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order){

            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }
        if(params.order == 'desc'){
            params.order = 'asc'
        }
        else if( params.order == 'asc'){
            params.order = 'desc'
        }
        browseCount = consumerLogList.totalCount

        visitorCount = ConsumerLog.withCriteria {
            projections {
                distinct("consumerName")
            }
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }.size()

        ieBrowserCount = ConsumerLog.withCriteria {
            like("userAgent", "%IE%")
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }.size()

        fireFoxBrowserCount = ConsumerLog.withCriteria {
            like("userAgent", "%Firefox%")
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }.size()

        chromeBrowserCount = ConsumerLog.withCriteria {
            like("userAgent", "%Chrome%")
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }.size()

        otherBrowserCount = browseCount - ieBrowserCount - fireFoxBrowserCount - chromeBrowserCount

        xpOSCount =  ConsumerLog.withCriteria {
            like("userAgent", "%Windows NT 5.1%")
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }.size()

        twoOSCount =  ConsumerLog.withCriteria {
            like("userAgent", "%Windows NT 5.2%")
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }.size()

        sevenOSCount =  ConsumerLog.withCriteria {
            like("userAgent", "%Windows NT 6.1%")
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }.size()

        macOSCount =  ConsumerLog.withCriteria {
            like("userAgent", "%Mac OS%")
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }.size()

        if (browseCount != 0) {
            iePercent = decimalFormat.format(ieBrowserCount * 100.0 / browseCount);
            fireFoxPercent = decimalFormat.format(fireFoxBrowserCount * 100.0 / browseCount);
            chromePercent = decimalFormat.format(chromeBrowserCount * 100.0 / browseCount);
            otherPercent = decimalFormat.format(otherBrowserCount * 100.0 / browseCount);
            xpPercent = decimalFormat.format(xpOSCount * 100.0 / browseCount);
            twoPercent = decimalFormat.format(twoOSCount * 100.0 / browseCount);
            sevenPercent = decimalFormat.format(sevenOSCount * 100.0 / browseCount);
            macPercent = decimalFormat.format(macOSCount * 100.0 / browseCount);
        }
//        println(consumerLogList as  JSON)
        render(view: "accessStatistics", model: [params:params,order: params.order,consumerLogList: consumerLogList, browseCount: browseCount, visitorCount: visitorCount, iePercent: iePercent, fireFoxPercent: fireFoxPercent, chromePercent: chromePercent, otherPercent: otherPercent, xpPercent: xpPercent, twoPercent: twoPercent, sevenPercent: sevenPercent, macPercent: macPercent])
    }
    @PatternNameAnnotation(name = "用户统计")
    @ActionNameAnnotation(name = "用户统计")
    def userStatistics(){
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        def userCount = 0 //用户数
        def newUserCount = 0 //新用户数
        def visitTimes = '' //用户访问时长
        def newUserPercent = 0 //ie浏览器访问百分比
        def outCount = 0 //跳出量 statusCode不是200的
        def outPercent = 0 //跳出率
        def consumerLogList = [] //访问记录列表

        def startDate = params.startDate
        def endDate = params.endDate

        if(!params.searchDateType) params.searchDateType = '0'
        def searchDateType = params.searchDateType
        def startTime = ''
        def endTime = ''

        //日期格式化
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
        if(startDate && startDate != '起始日期' && endDate && endDate != '结束日期'){
            startTime = startDate + ' 00:00:00'
            endTime = endDate + ' 23:59:59'
        }
        else{
            //当天
            if(searchDateType == '0'){
                startTime = sdf.format(new Date()) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
            //昨天
            else if(searchDateType == '1'){
                def yestoday = new Date() - 1
                startTime = sdf.format(yestoday) + ' 00:00:00'
                endTime = sdf.format(yestoday) + ' 23:59:59'
            }
            //近7天
            else if(searchDateType == '2'){
                def sevenDaysAgo = new Date() - 6
                startTime = sdf.format(sevenDaysAgo) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
            //最近30天
            else if(searchDateType == '3'){
                def daysAgo = new Date() - 29
                startTime = sdf.format(daysAgo) + ' 00:00:00'
                endTime = sdf.format(new Date()) + ' 23:59:59'
            }
        }

        userCount = Consumer.countByIsRegister(false)

        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
        newUserCount = Consumer.withCriteria {
            projections {
                count("id")
            }
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
            eq("isRegister", false)
        }[0]

        //数字格式化
        DecimalFormat decimalFormat = new DecimalFormat("###.##");

        if (userCount != 0) {
            newUserPercent = decimalFormat.format(newUserCount * 100.0 / userCount);
        }

        consumerLogList = ConsumerLog.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order){
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }

        def visitTimesLong = ConsumerLog.withCriteria {
            projections {
                sum("responseTime")
            }
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }[0]
        visitTimes = CTools.timeMillisToStr(visitTimesLong)
        visitTimes = visitTimes.substring(0, visitTimes.indexOf("."))

        outCount = ConsumerLog.withCriteria {
            projections {
                count("id")
            }

            notEqual("statusCode", 200)
            between("dateCreated", sdf.parse(startTime), sdf.parse(endTime))
        }[0]

        if(consumerLogList.totalCount > 0){
            outPercent = decimalFormat.format(outCount * 100.0 / consumerLogList.totalCount);
        }

        render(view: "userStatistics", model: [params:params, consumerLogList: consumerLogList,total:consumerLogList.totalCount, userCount: userCount, newUserPercent: newUserPercent, visitTimes: visitTimes, outPercent: outPercent])
    }
    /**
     * 通用统计
     * @return
     */
    @PatternNameAnnotation(name = "通用统计")
    @ActionNameAnnotation(name = "通用统计")
    def generalQuery() {
    }
    //通用统计数据
    @PatternNameAnnotation(name = "通用统计")
    @ActionNameAnnotation(name = "通用统计列表")
    def generalQueryValue(){


        def str=coreMgrService.resultGeneral(params);
       
        //return render(resultMap as JSON);
       // def str='{"total":20,"rows":[{"ip":"192.101.777","count":"555"},{"ip":"392","count":"65"}]}'
       // print(str)
        return render(str)
    }
    //访问统计
    @PatternNameAnnotation(name = "访问统计")
    @ActionNameAnnotation(name = "访问统计列表")
    def accessTo(){
        def str=coreMgrService.resultAccess(params);
       // print(str as JSON)
        return render(str as JSON)
    }
    //用户统计
    @PatternNameAnnotation(name = "用户统计")
    @ActionNameAnnotation(name = "用户统计列表")
    def userTo(){
        def str=coreMgrService.resultUser(params);
//        print(str as JSON)
        return render(str as JSON)
    }

    /**
     * 文件服务器配置
     */
    @PatternNameAnnotation(name = "高级搜索配置")
    @ActionNameAnnotation(name = "高级搜索配置")
    def seniorSearchConifg() {
        def model = programService.seniorSearchConifg();
        return render(view: 'seniorSearchConifg', model: model);
    }

    @PatternNameAnnotation(name = "高级搜索配置")
    @ActionNameAnnotation(name = "高级搜索配置Set")
    def seniorSearchConfigSet() {
        programService.seniorSearchConfigSet(params);
        redirect(action: "seniorSearchConifg");
    }

    /**
     * 在线用户统计
     */
    @PatternNameAnnotation(name = "在线用户统计")
    @ActionNameAnnotation(name = "在线用户统计")
    def onlineUserStatistics() {
    }

    @PatternNameAnnotation(name = "在线用户统计")
    @ActionNameAnnotation(name = "取得在线用户数据")
    def onlineUserStatisticsData(){
        def result = [:];
        def searchDateType = params.searchDateType;
        switch(searchDateType){
            case "0":
                // 取得当日的在线人数
                Calendar appointCalendar = Calendar.getInstance();
                coreMgrService.acquireOneDayOnlineUserCount(result,appointCalendar);
                break;
            case "1":
                // 取得昨日的在线人数
                Calendar appointCalendar = Calendar.getInstance();
                appointCalendar.add(Calendar.DAY_OF_MONTH, -1);
                coreMgrService.acquireOneDayOnlineUserCount(result,appointCalendar);
                break;
            case "2":
                // 取得最近7日的在线人数
                Calendar appointCalendar = Calendar.getInstance();
                coreMgrService.acquireBeforeDayOnlineUserCount(result, appointCalendar, 7);
                break;
            case "3":
                // 取得最近30日的在线人数
                Calendar appointCalendar = Calendar.getInstance();
                coreMgrService.acquireBeforeDayOnlineUserCount(result,appointCalendar, 30);
                break;
            case "4":
                // 取得指定日期范围内的在线人数
                String startDate = params.startDate;
                String endDate = params.endDate;
                if(startDate && endDate) {
                    try{
                        // 声明时间格式化对像
                        SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd" );
                        Calendar startCalendar = Calendar.getInstance();
                        Date sd = sdf.parse(startDate);
                        startCalendar.setTime(sd);
                        Calendar endCalendar = Calendar.getInstance();
                        Date ed = sdf.parse(endDate);
                        endCalendar.setTime(ed);
                        coreMgrService.acquireBetweenDaysOnlineUserCount(result, startCalendar, endCalendar);
                    }catch(Exception e) {
                        result.success = false;
                        result.msg = "参数错误！";
                    }
                } else {
                    result.success = false;
                    result.msg = "参数错误！";
                }
                break;
            default:
                result.success = false;
                result.msg = "参数错误！";
                break;
        }
        return render(result as JSON);
    }
}
