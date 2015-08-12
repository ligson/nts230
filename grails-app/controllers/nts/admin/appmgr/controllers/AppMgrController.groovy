package nts.admin.appmgr.controllers

import grails.converters.JSON
import nts.activity.domain.UserActivity
import nts.activity.domain.UserVote
import nts.activity.domain.UserWork
import nts.broadcast.domain.Channel
import nts.broadcast.domain.CourseBcast
import nts.broadcast.domain.DvbforeNotice
import nts.commity.domain.BbsReply
import nts.commity.domain.BbsTopic
import nts.commity.domain.ForumBoard
import nts.commity.domain.StudyCommunity
import nts.program.domain.ProgramTopic
import nts.program.domain.Remark
import nts.program.domain.Serial
import nts.system.domain.Directory
import nts.system.domain.Errors
import nts.system.domain.FriendLink
import nts.system.domain.News
import nts.system.domain.OperationLog
import nts.system.domain.Qnaire
import nts.system.domain.QnaireOption
import nts.system.domain.QnaireQuestion
import nts.system.domain.Question
import nts.system.domain.ServerNode
import nts.system.domain.Survey
import nts.system.domain.Tools
import nts.user.domain.Consumer
import nts.utils.CTools
import org.apache.http.NameValuePair
import org.apache.http.client.entity.UrlEncodedFormEntity
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpPost
import org.apache.http.impl.client.CloseableHttpClient
import org.apache.http.impl.client.HttpClients
import org.apache.http.message.BasicNameValuePair
import org.apache.poi.hssf.usermodel.HSSFCell
import org.apache.poi.hssf.usermodel.HSSFCellStyle
import org.apache.poi.hssf.usermodel.HSSFFont
import org.apache.poi.hssf.usermodel.HSSFRichTextString
import org.apache.poi.hssf.usermodel.HSSFRow
import org.apache.poi.hssf.usermodel.HSSFSheet
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.codehaus.groovy.grails.web.json.JSONElement
import org.springframework.dao.DataIntegrityViolationException

import javax.servlet.http.HttpServletResponse
import java.text.SimpleDateFormat
import nts.program.domain.Program
import nts.system.domain.RMSCategory

/**
 * 应用管理
 */
class AppMgrController {

    def newsService
    def programService
    def RMSCategoryService
    def communityService
    def distributeService
    def useApplyService
    def programExportService;

    def index() {
        redirect(action: 'list', params: params)
    }
    def list = {
        def total                                        //声明列表结果行数
        def newsList                                    //声明结果集

        newsList = search();
        total = newsList.totalCount

        return render(view: 'index', model: [newsList: newsList, total: total])

    }
    def search = {
        return newsService.newsSearch(params);
    }

    def deleteNews = {
        def page = params.page

        deleteList()

        if (page == "") {        //判断书页是否是第一页，如果是第一页无法传page值
            page = "0"
        }
        redirect(action: 'list', params: [offset: page])
    }
    def deleteList = {
        def delIdList = params.idList
        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            def news = News.get(id as int)
            news.delete()
        }

        redirect(action: 'list', params: params)
    }

    def delete = {
        def news = News.get(params.id as int)
        if (news && session.consumer.role == 0) {
            news.delete()
            flash.message = "公告 ${news.title} 删除 "
            redirect(action: 'list', params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
        } else {
            flash.message = "公告 删除失败 "
            redirect(action: 'list', params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
        }
    }

    def create = {
        def news = new News()
        news.properties = params
        return render(view: 'create', model: [news: news])
    }

    def update = {
        def news = News.get(params.newsId)
        if (session.consumer.role < Consumer.TEACHER_ROLE) {
            if (news) {
                news.title = params.title
                news.content = params.content
                news.publisher = session.consumer
                if (!news.hasErrors() && news.save()) {
                    flash.message = "公告  ${news.title} 修改完成"
                    redirect(action: 'list', params: [newsId: news.id, max: params.max, sort: params.sort, order: params.order, offset: params.offset, searchTitle: params.searchTitle, searchContent: params.searchContent, searchPublisher: params.searchPublisher, searchDate: params.searchDate])
                } else {

                    //  flash.message = "公告修改失败"
                    render(view: 'list', model: [news: news])
                }
            } else {
                flash.message = "找不到该公告"
                redirect(action: 'edit', params: [newsId: news.id, max: params.max, sort: params.sort, order: params.order, offset: params.offset, searchTitle: params.searchTitle, searchContent: params.searchContent, searchPublisher: params.searchPublisher, searchDate: params.searchDate])
            }
        } else {
            flash.message = "只在管理员才可修改 "
            redirect(action: 'edit', params: [newsId: news.id, max: params.max, sort: params.sort, order: params.order, offset: params.offset, searchTitle: params.searchTitle, searchContent: params.searchContent, searchPublisher: params.searchPublisher, searchDate: params.searchDate])
        }
    }

    def edit = {
        def news = News.get(params.newsId as int)
        if (!news) {
            flash.message = "没有该公告"
            redirect(action: 'list')
        } else {
            return render(view: 'edit', model: [news: news])
        }
    }

    def save() {
        def content = params.content;
        content = CTools.htmlToBlank(content);
        def news = new News(
                title: params.title,                                        //用户名
                content: content,                                    //密码
                publisher: session.consumer,                                //发布者
                submitTime: new Date(),                                    //真实姓名
        )
        if (session.consumer.role == 0) {
            if ((!news.hasErrors()) && (news.save(flush: true))) {
                flash.message = "公告 ${news.title} 创建成功"
                redirect(action: 'list', params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
            } else {
                flash.message = "公告创建失败"
                redirect(action: 'list', params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
            }
        } else {
            flash.message = "您权限不够！只有超级管理员才可以创建!"
            redirect(action: 'list', params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
        }

    }

    def uploadImg(def opt) {
        def imgFile = request.getFile("img")
        def imgType = imgFile.getContentType()

        def path = servletContext.getRealPath("/upload");

        def imgPath = ""

        if (imgFile && !imgFile.isEmpty()) {
            if (imgType == "image/pjpeg" || imgType == "image/jpeg" || imgType == "image/png" || imgType == "image/x-png" || imgType == "image/gif") {

                File proTopicImg = new File("${path}/proTopicImg/");
                if(!proTopicImg.exists()){
                    proTopicImg.mkdirs();
                }

                if (opt == "save") {
                    def pt = ProgramTopic.createCriteria()
                    def id = pt.get {
                        projections {
                            max "id"
                        }
                    }
                    id = id == null ? 1 : id + 1
                    imgPath = "i_" + id + ".jpg"
                    imgFile.transferTo(new java.io.File(proTopicImg.getAbsolutePath(), imgPath))
                } else if (opt == "update") {
                    def programTopic = ProgramTopic.get(params.id)
                    def id = programTopic.id
                    imgPath = "i_" + id + ".jpg"
                    imgFile.transferTo(new java.io.File(proTopicImg.getAbsolutePath(), imgPath))
                }
            } else {
                flash.message = "上传图片格式不对..."
            }
        }
        return imgPath
    }
    def searchTopicProgram = {
        def result = [:];
        result = useApplyService.searchTopicProgram(params);
        def programList = result.programList;
        def total = programList?.totalCount;
        render(template: 'searchTopicProgramList', model: [programList: programList, total: total, schWord: params.schWord])
    }


    def errorList = {
        def total                                        //声明列表结果行数
        def errorsList                                    //声明结果集
        errorsList = searchErrors()
        total = errorsList.totalCount
        return render(view: 'errorList', model: [errorsList: errorsList, total: total])
    }
    def searchErrors = {
        return newsService.errorsSearch(params);
    }

    def errorMark = {
        setMark()
        redirect(action: 'errorList', params: params)
    }
    def setMark = {
        def updateIdList = params.idList
        def updateid = 0
        if (updateIdList instanceof String) updateIdList = [params.idList]
        updateIdList?.each { id ->
            updateid = updateid + "," + id
        }
        Errors.executeUpdate("update nts.system.domain.Errors c set errorState=${params.markTag}  where c.id in(${updateid}) ")
    }

    def deleteErrors = {
        deleteErrorList();
        redirect(action: 'errorList', params: params)
    }
    def deleteErrorList = {
        def delIdList = params.idList
        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            def errors = Errors.get(id)
            errors.delete()
        }
    }
    def showError = {
        def errors = Errors.get(params.id as int)
        def program = null


        if (!errors) {
            flash.message = "nts.system.domain.Errors not found with id ${params.id}"
            redirect(action: 'errorList', params: params)
        } else {
            if (errors.programId > 0) {
                program = Program.get(errors.programId)
            }
            return render(view: 'showError', model: [errors: errors, program: program, params: params])
        }
    }
    def operationLogList = {
        def logList = operationSearchLog();
        def total = logList.totalCount

        if (params._idList) params._idList = null
        if (params.idList) params.idList = null
        return render(view: 'operationLogList', model: [logList: logList, total: total])
    }
    def operationSearchLog = {
        return newsService.logSearch(params);
    }
    def deleteOperationLog = {
        def deleteIdList = params.idList
        def log
        if (deleteIdList instanceof String) deleteIdList = [params.idList]
        deleteIdList?.each { id ->
            log = OperationLog.get(id)
            if (log) log.delete()
        }
        if (params._idList) params._idList = null
        if (params.idList) params.idList = null
        redirect(action: "operationLogList", params: params)
    }
    def questionList = {
        def result = [:];
        def questionList;
        def total;
        result = useApplyService.questionSearchList(params);
        total = result.searchList.totalCount;
        questionList = result.searchList;
        if (params._idList) params._idList = null

        return render(view: 'questionList', model: [questionList: questionList, total: total])

    }

    def deleteQuestion = {

        def delIdList = params.idList

        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            def question = Question.get(id)
            if (question) question.delete()
        }


        if (params._idList) params._idList = null
        if (params.idList) params.idList = null

        redirect(action: 'questionList', params: params)

    }
    def editQuestion = {

        def question = Question.get(params.questionId)

        if (!question) {
            flash.message = "找不到该问题"
            redirect(action: 'questionList', params: params)
        } else {
            return render(view: 'editQuestion', model: [question: question])
        }
    }
    def importExcel = {
        def directoryList = null
        directoryList = Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])
        return render(view: 'importExcel', model: [directoryList: directoryList])
    }

    def excelToDatabase = {
        if (programExportService.excelToDataBase()) {
            flash.message = "导入成功";
        } else {
            flash.message = "导入失败";
        }

        redirect(action: 'importExcel')
    }

    def getArrCnName(String title) {
        //{化学,无机化学)
        List arr = ["", ""];
        int nPos = 0;

        //防止用用户输入全角括号
        title = title.replace("－", "-");
        title = title.replaceAll("＞", ">");

        nPos = title.lastIndexOf("->");
        if (nPos > 0) {
            arr[0] = title.substring(0, nPos);
            arr[1] = title.substring(nPos + 2);
        }
        //有的没有二级学科，如：化学
        else {
            arr[0] = title;
            arr[1] = "0";
        }

        return arr;
    }

    def getProgramFromList(programList, fromId) {
        if (programList == null) return null

        Program program = null

        for (int i = 0; i < programList.size(); i++) {
            if (programList[i].fromId == fromId) return programList[i]
        }

        return program
    }
    def exportExcelorXml = {
        def directoryList = null
        directoryList = Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])
        return render(view: 'exportExcelorXml', model: [directoryList: directoryList, isDescription: '0'])
    }

    def getExcelColNo(sId, arr) {
        def meta_id = "";
        for (int i = 0; i < arr.size(); i++) {
            meta_id = arr[i];
            if (meta_id.equals(sId))
                return i + 1;//第一列是节目ID，没放在数组里。
        }

        return -1;
    }

    def getEnumName(sMId, sEId, vEnum) {
        def MId = "0"
        def EId = "0"
        def name = "0"
        if (sEId == null || sEId == "")
            return ""
        vEnum.each {
            MId = it[2]
            EId = it[0]
            if (MId == sMId && EId == sEId) {
                name = it[1]
                return name
            }
        }
        return name;
    }
    def export = {
        try {
            Map result = programExportService.export(params, request, session);
            flash.message = result.message;
            render(view: "exportExcelorXml", model: result);

        } catch (Exception e) {
            flash.message = e.toString()
            render(view: "exportExcelorXml", model: [directoryList: Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])])
        }
    }

    def statistics =
            {
                def donwProSta = Program.findAllByState(Program.PUBLIC_STATE, [max: 10, sort: "downloadNum", order: "desc"])
                //节目下载排行
                def viewProSta = Program.findAllByState(Program.PUBLIC_STATE, [max: 10, sort: "frequency", order: "desc"])
                //节目浏览排行
                def loginCmrSta = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [max: 10, sort: "loginNum", order: "desc"])
                //用户登陆排行

                //---**************************************************************

                def lastLoginCmrSta = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [max: 10, sort: "dateLastLogin", order: "desc"])
                //用户最后登陆时间排行
                def viewCmrSta = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [max: 10, sort: "viewNum", order: "desc"])
                //用户浏览排行
                def donwCmrSta = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [max: 10, sort: "downloadNum", order: "desc"])
                //用户下载排行
                def uploadCmrSta = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [max: 10, sort: "uploadNum", order: "desc"])
                //用户上传排行
                def collectCmrSta = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [max: 10, sort: "collectNum", order: "desc"])
                //用户收藏排行


                return render(view: 'statistics', model: [donwProSta: donwProSta, viewProSta: viewProSta, loginCmrSta: loginCmrSta, viewCmrSta: viewCmrSta,
                                                          donwCmrSta: donwCmrSta, uploadCmrSta: uploadCmrSta, collectCmrSta: collectCmrSta, lastLoginCmrSta: lastLoginCmrSta])
            }
    def programDownloadRanking = {
        def name = "programDownloadRanking"
        def data = Program.findAllByState(Program.PUBLIC_STATE, [sort: "downloadNum", order: "desc"])
        def fieldName = ['资源名称', '所属类库', '上传时间', '下载次数']
        def fieldValue = ['name', 'directory.name', 'dateCreated', 'downloadNum']
        def sheetName = "资源下载排行"

        useApplyService.exportExcel1(name, data, fieldName, fieldValue, sheetName, response);
    }


    def programViewRanking = {
        def name = "programViewRanking"
        def data = Program.findAllByState(Program.PUBLIC_STATE, [sort: "frequency", order: "desc"])
        def fieldName = ['资源名称', '所属类库', '上传时间', '浏览次数']
        def fieldValue = ['name', 'directory.name', 'dateCreated', 'frequency']
        def sheetName = "资源浏览排行"

        useApplyService.exportExcel1(name, data, fieldName, fieldValue, sheetName, response);
    }
    def userVisitRanking = {
        def name = "userVisitRanking"
        def data = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [sort: "loginNum", order: "desc"])
        def fieldName = ['用户账号', '姓名', '访问数']
        def fieldValue = ['name', 'trueName', 'loginNum']
        def sheetName = "用户访问排行"

        programExportService.exportExcel(name, data, fieldName, fieldValue, sheetName, response);
    }

    def userViewRanking = {
        def name = "userViewRanking"
        def data = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [sort: "viewNum", order: "desc"])
        def fieldName = ['用户账号', '姓名', '浏览数']
        def fieldValue = ['name', 'trueName', 'viewNum']
        def sheetName = "用户浏览排行"

        programExportService.exportExcel(name, data, fieldName, fieldValue, sheetName, response);
    }
    def userDownloadRanking = {
        def name = "userDownloadRanking"
        def data = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [sort: "downloadNum", order: "desc"])
        def fieldName = ['用户账号', '姓名', '下载数']
        def fieldValue = ['name', 'trueName', 'downloadNum']
        def sheetName = "用户下载排行"

        programExportService.exportExcel(name, data, fieldName, fieldValue, sheetName, response);
    }
    def userUploadRanking = {
        def name = "userUploadRanking"
        def data = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [sort: "uploadNum", order: "desc"])
        def fieldName = ['用户账号', '姓名', '上传数']
        def fieldValue = ['name', 'trueName', 'uploadNum']
        def sheetName = "用户上传排行"

        programExportService.exportExcel(name, data, fieldName, fieldValue, sheetName, response);
    }
    def userCollectionRanking = {
        def name = "userCollectionRanking"
        def data = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [sort: "collectNum", order: "desc"])
        def fieldName = ['用户账号', '姓名', '收藏数']
        def fieldValue = ['name', 'trueName', 'collectNum']
        def sheetName = "用户收藏排行"

        programExportService.exportExcel(name, data, fieldName, fieldValue, sheetName, response);
    }
    def userLastloginRanking = {
        def name = "userLastloginRanking"
        def data = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [sort: "dateLastLogin", order: "desc"])
        def fieldName = ['用户账号', '姓名', '登录时间']
        def fieldValue = ['name', 'trueName', 'dateLastLogin']
        def sheetName = "用户最后登录排行"

        programExportService.exportExcel(name, data, fieldName, fieldValue, sheetName, response);
    }


    def toolsList = {
        if (!params.max) params.max = 200
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.offset) params.offset = 0

        def total = Tools.count()
        return render(view: 'toolsList', model: [toolsList: Tools.list(params), total: total])
    }
    def editTools = {
        def toolsInstance = Tools.get(params.id)
        if (!toolsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'tools.label', default: 'nts.system.domain.Tools'), params.id])}"
            redirect(action: "toolsList")
        } else {
            return render(view: 'editTools', model: [toolsInstance: toolsInstance])
        }
    }
    def createTools = {
        def toolsInstance = new Tools()
        toolsInstance.properties = params
        return render(view: 'createTools', model: [toolsInstance: toolsInstance])
    }
    def saveTools = {
        def tools = new Tools
                (
                        name: params.name,
                        consumer: session.consumer.name
                )
        if (tools.save(flush: true)) {
            fileUpload(tools)
            flash.message = "上传成功"
            redirect(action: "toolsList")
        } else {
            render(view: "createTools", model: [tools: tools])
        }
    }

    def fileUpload(tools) {
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
        ////web-app/donwdir/
    }
    def deleteTools = {
        def tools = Tools.get(params.delId)
        if (tools) {
            try {
                tools.delete(flush: true)
                flash.message = "删除完成"
                redirect(action: "toolsList")
            }
            catch (DataIntegrityViolationException e) {
                flash.message = "删除失败"
                redirect(action: "toolsList")
            }
        } else {
            flash.message = "没有找不到该工具"
            redirect(action: "toolsList")
        }
    }
    def remarkList = {
        def total                                        //声明列表结果行数
        def remarkList                                    //声明结果集
        def result = [:];
        result = useApplyService.searchRemark(params);
        remarkList = result.searchList;
        total = remarkList.totalCount

        return render(view: 'remarkList', model: [remarkList: remarkList, total: total])
    }

    def deleteRemark = {
        deleteRemarkList();
        redirect(action: 'remarkList', params: params)
    }
    def deleteRemarkList = {
        def delIdList = params.idList
        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            def remark = Remark.get(id)
            remark.delete()
        }
    }
    def showRemark = {
        def remark = Remark.get(params.id)

        if (!remark) {
            flash.message = "没有该评论"
            redirect(action: 'remarkList')
        } else {
            return render(view: 'showRemark', model: [remark: remark])
        }
    }
    def deleteRemark1 = {
        def remark = Remark.get(params.id)
        if (remark) {
            try {
                remark.delete(flush: true)
                flash.message = "评论 ${remark.topic.encodeAsHTML()} 删除完成！"
            }
            catch (DataIntegrityViolationException e) {
                flash.message = "异常：评论 ${remark.topic} 不能删除"
            }
        } else {
            flash.message = "找不到该评论"
        }
        redirect(action: 'remarkList', params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order, searchTitle: params.searchTitle, searchContent: params.searchContent, searchProgram: params.searchProgram, searchConsumer: params.searchConsumer])
    }
    def isPassRemarkList = {
        def delIdList = params.idList
        def sIsPass = params.sIsPass
        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            def remark = Remark.get(id)
            remark.isPass = sIsPass == "1" ? true : false
            remark.save(flush: true)
        }
        redirect(action: 'remarkList', params: params)
    }
    def isPassRemark = {
        def remark = Remark.get(params.id)
        if (remark) {
            remark.isPass = params.sIsPass == "1" ? true : false
            remark.save(flush: true)
        } else {
            flash.message = "找不到该评论"
        }
        render(view: 'showRemark', model: [remark: remark])
    }
    def monitorList = {
        def serverName = servletContext.serverName
        def serverPort = servletContext.serverPort

        if (!serverName) {
            serverName = servletContext.videoSevr
            if (!servletContext.videoSevr) {
                serverName = request.getServerName()
            }
        }
        if (!serverPort) serverPort = servletContext.videoPort

        servletContext.monitor = params.monitor
        def intervalTime = servletContext.intervalTime
        if (!intervalTime) servletContext.intervalTime = "1"
        if (!servletContext.isRunInfo) servletContext.isRunInfo = '1'
        if (!servletContext.isUserList) servletContext.isUserList = '1'
        def serverUrl = 'http://' + serverName + ':' + serverPort + '/bmsp-server-status'

        return render(view: 'monitorList', model: [params: params, serverUrl: serverUrl])
    }
    def addMonitor = {
        return render(view: 'addMonitor', model: [params: params])
    }
    def saveMonitor = {

        servletContext.serverName = params.serverName
        servletContext.serverPort = params.serverPort
        servletContext.intervalTime = params.intervalTime

        if (!params.isRunInfo) {
            servletContext.isRunInfo = '0'
        } else {
            servletContext.isRunInfo = params.isRunInfo
        }
        if (!params.isUserList) {
            servletContext.isUserList = '0'
        } else {
            servletContext.isUserList = params.isUserList
        }

        redirect(action: 'monitorList')
    }
    def friendLinkList = {
        params.max = Math.min(params.max ? params.int('max') : 10, 400)
        params.sort = 'showOrder'
        params.order = 'desc'

        return render(view: 'friendLinkList', model: [friendLinkList: FriendLink.list(params), friendLinkTotal: FriendLink.count()])
    }
    def createFriendLink = {
        def friendLink = new FriendLink()
        friendLink.properties = params
        return render(view: 'createFriendLink', model: [friendLink: friendLink])
    }
    def saveFriendLink = {
        def friendLink = new FriendLink(params)
        if (friendLink.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'friendLink.label', default: 'nts.system.domain.FriendLink'), friendLink.id])}"
            redirect(action: "friendLinkList")
        } else {
            redirect(action: "friendLinkList")
        }
    }
    def editFriendLink = {
        def friendLink = FriendLink.get(params.id)
        if (!friendLink) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'friendLink.label', default: 'nts.system.domain.FriendLink'), params.id])}"
            redirect(action: "friendLinkList")
        } else {
            return render(view: 'editFriendLink', model: [friendLink: friendLink])
        }
    }
    def updateFriendLink = {
        def friendLink = FriendLink.get(params.id)
        if (friendLink) {
            if (params.version) {
                def version = params.version.toLong()
                if (friendLink.version > version) {

                    friendLink.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'friendLink.label', default: 'nts.system.domain.FriendLink')] as Object[], "Another user has updated this nts.system.domain.FriendLink while you were editing")
                    render(view: "editFriendLink", model: [friendLink: friendLink])
                    return
                }
            }
            friendLink.properties = params
            if (!friendLink.hasErrors() && friendLink.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'friendLink.label', default: 'nts.system.domain.FriendLink'), friendLink.id])}"
                redirect(action: "friendLinkList")
            } else {
                redirect(action: "friendLinkList")
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'friendLink.label', default: 'nts.system.domain.FriendLink'), params.id])}"
            redirect(action: "friendLinkList")
        }
    }
    def deleteFriendLink = {
        def delIdList = params.idList
        if (delIdList instanceof String)
            delIdList = [params.idList.toLong()]
        else
            delIdList = params.idList.collect { elem -> elem.toLong() }

        delIdList?.each { id ->
            def friendLink = FriendLink.get(id)
            if (friendLink) {
                try {
                    friendLink.delete(flush: true)
                    //flash.message = "删除完成"
                }
                catch (DataIntegrityViolationException e) {
                    flash.message = "删除失败"
                }
            }
        }

        redirect(action: "friendLinkList")
    }
    def RMSCategoryList = {
        def result = [:];
        result = RMSCategoryService.RMSCategoryList(params);
        return render(view: 'RMSCategoryList', model: [categoryList: result.categoryList, total: result.categoryList?.totalCount, params: params])
    }
    def editRMSCategory = {
        def RMSCategoryInstance = RMSCategory.get(params.id)
        if (!RMSCategoryInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'RMSCategory.label', default: 'nts.system.domain.RMSCategory'), params.id])}"
            redirect(action: "RMSCategoryList")
        } else {
            def result = [:];
            result = RMSCategoryService.editRMSCategory(params, RMSCategoryInstance)
            return render(view: 'editRMSCategory', model: [RMSCategoryInstance: RMSCategoryInstance, categoryList: result.categoryList])
        }
    }
    def updateRMSCategory = {
        def RMSCategoryInstance = RMSCategory.get(params.id)
        if (RMSCategoryInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (RMSCategoryInstance.version > version) {

                    RMSCategoryInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'RMSCategory.label', default: 'nts.system.domain.RMSCategory')] as Object[], "Another user has updated this nts.system.domain.RMSCategory while you were editing")
                    render(view: "editRMSCategory", model: [RMSCategoryInstance: RMSCategoryInstance])
                    return
                }
            }
            //RMSCategoryInstance.properties = params
            def parent = params?.parent //前端获取的上级类别，值以id,name方式传输
            RMSCategoryInstance.name = CTools.nullToBlank(params?.name)
            RMSCategoryInstance.type = CTools.nullToZero(params?.type) //0-公共类别 1-学习圈类别 2-学习社区类别
            RMSCategoryInstance.parentid = CTools.nullToZero(parent.split(",")[0])
            RMSCategoryInstance.parentName = CTools.nullToBlank(parent.split(",")[1])

            if (!RMSCategoryInstance.hasErrors() && RMSCategoryInstance.save()) {
                redirect(action: "searchRMSCategory", params: [type: params?.type, level: parent.split(",")[0] == '0' ? 1 : 2])
            } else {
                render(view: "editRMSCategory", model: [RMSCategoryInstance: RMSCategoryInstance])
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'RMSCategory.label', default: 'nts.system.domain.RMSCategory'), params.id])}"
            redirect(action: "RMSCategoryList")
        }
    }
    def searchRMSCategory = {
        def result = [:];
        result = RMSCategoryService.searchRMSCategory(params);
        return render(view: 'searchRMSCategory', model: [categoryList: result.categoryList, total: result.categoryList?.totalCount, params: params])
    }
    def toRecycler = {
        def delIdList = params.idList
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (delIdList instanceof String) {
            delIdList = [params.idList]
        }
        delIdList?.each { id ->
            def RMSCategoryInstance = RMSCategory.get(id)
            if (RMSCategoryInstance) {
                RMSCategoryInstance.state = false
                RMSCategoryInstance.save()
            } else {
                flash.message = "nts.system.domain.RMSCategory not found with id ${id}"
            }
        }
        redirect(action: "searchRMSCategory", params: [type: params?.type, level: params?.operation])
    }
    def lowerList = {
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        def parentid = CTools.nullToZero(params?.parentid)
        def type = CTools.nullToZero(params?.type)

        def categoryList = RMSCategory.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            eq("state", true)
            eq("type", type)
            eq("parentid", parentid)
        }
        return render(view: 'lowerList', model: [categoryList: categoryList, total: categoryList?.totalCount, params: params])

    }
    def toAdd = {
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'

        def type = CTools.nullToZero(params?.operation) //类型 0-公共 1-学习圈 2-学习社区

        def categoryList = RMSCategory.createCriteria().list(sort: params.sort, order: params.order) {
            eq("state", true)
            eq("type", type)
            eq("parentid", 0)
        }
        return render(view: 'toAdd', model: [categoryList: categoryList, type: type])

    }

    def saveRMSCategory() {
        def parent = params?.parent
        def RMSCategoryInstance = new RMSCategory(name: CTools.nullToBlank(params?.name),
                type: CTools.nullToZero(params?.type), parentid: CTools.nullToZero(parent.split(",")[0]),
                parentName: CTools.nullToBlank(parent.split(",")[1]))
        RMSCategoryInstance.state = true;
        if (RMSCategoryInstance.save()) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'RMSCategory.label', default: 'nts.system.domain.RMSCategory'), RMSCategoryInstance.id])}"
            if (RMSCategoryInstance.parentid == 0) {
                redirect(action: "RMSCategoryList")
            } else {
                println RMSCategoryInstance.parentid + "," + RMSCategoryInstance.type + "------------------------------"
                redirect(action: "lowerList", params: [type: RMSCategoryInstance.type, parentid: RMSCategoryInstance.parentid])
            }
        } else {
            render(view: "createRMSCategory", model: [RMSCategoryInstance: RMSCategoryInstance])
        }
    }
    def communityList = {
        //取得最大显示页面，并转换为整型
        //取得页面偏移量，并转换为整型
        def communityList = communityService.searchCommunity(params);
        def nameList = []
        communityList?.each { community ->
            def consumer = Consumer.get(community.create_comsumer_id)
            if (consumer != null) {
                nameList.add(consumer.name)
            }
        }

        def total = communityList.totalCount

        def _max = params.max.toInteger()
        def _offset = params.offset.toInteger()
        int pageCount = Math.round(Math.ceil(total / _max))
        int pageNow = (_offset / _max) + 1
        return render(view: 'communityList', model: [communityList: communityList, nameList: nameList, total: total, pageCount: pageCount, pageNow: pageNow])

    }
    def deleteCommunity = {
        def delId = params.delId;
        StudyCommunity studyCommunity = StudyCommunity.get(delId);
        if (studyCommunity) {
            try {
                studyCommunity.delete();
            } catch (Exception e) {

            }
        }
        redirect(action: 'communityList', params: params)
    }
    def deleteCommunityList = {
        def delIdList = params.idList
        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            def community = StudyCommunity.get(id)
            def forumBoards = community.forumBoards
            forumBoards?.each { forumBoard ->
                deleteForumBoard(forumBoard.id)
            }
            community.delete()
        }

        redirect(action: 'communityList', params: params)
    }

    def deleteForumBoard(id) {
        def forumBoard = ForumBoard.get(id)
        if (forumBoard) {
            forumBoard.delete()
        }
    }
    def communityExamine = {
        def communityInstance = StudyCommunity.get(params.id)
        if (communityInstance != null) {
            communityInstance.state = params.communityState.toInteger()
            if (!communityInstance.hasErrors() && communityInstance.save(flush: true)) {
                flash.message = "学习社区审核成功"
            }
        } else {
            flash.message = "学习社区未找到"
        }
        redirect(action: "communityList", params: params)
    }
    def communityRecommend = {
        def communityInstance = StudyCommunity.get(params.id)
        if (communityInstance != null) {
            if (params.isRecommend == "true") {
                communityInstance.isRecommend = true
            } else {
                communityInstance.isRecommend = false
            }
            if (!communityInstance.hasErrors() && communityInstance.save(flush: true)) {
                flash.message = "学习社区推荐成功"
            }
        } else {
            flash.message = "学习社区未找到"
        }
        redirect(action: "communityList", params: params)
    }
    def userActivityList = {
        def consumerId = CTools.nullToZero(session.consumer.id).longValue();
        //后台显示所有活动
        params.isAll = true;
        def userActivityList = communityService.searchUserActivity(params, consumerId);
        def total = userActivityList.totalCount
        return render(view: 'userActivityList', model: [userActivityList: userActivityList, total: total, params: params])

    }

    def showUserActivity = {
        def userActivityInstance = UserActivity.get(params.id)
        if (!userActivityInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity'), params.id])}"
            redirect(action: "userActivityList")
        } else {
            if (!params.max) params.max = '8'
            if (!params.sort) params.sort = 'voteNum'
            if (!params.order) params.order = 'desc'
            if (!params.offset) params.offset = '0'
            def userWorkList = UserWork.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                userActivity {
                    eq('id', userActivityInstance.id)
                }
                eq('approval', 3)
            }
            def newsUserActivityList = UserActivity.list(max: 10, sort: "id", order: "desc");            //最新活动
            def hotUserActivityList = UserActivity.list(max: 10, sort: "workNum", order: "desc");            //热门活动

            return render(view: 'showUserActivity', model: [userActivity: userActivityInstance, userWorkList: userWorkList, total: userWorkList.totalCount, newsUserActivityList: newsUserActivityList, hotUserActivityList: hotUserActivityList, offset: params.offset, max: params.max])
        }
    }

    def editUserActivity = {
        def userActivity = UserActivity.get(params.id)
        if (!userActivity) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity'), params.id])}"
            redirect(action: "myList")
        } else {
            def rmsCategoryList1 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {            //一级类别
                'in'("type", [0, 3])
                eq("parentid", 0)
                eq("state", true)
            }
            def rmsCategoryList2 = null
            if (rmsCategoryList1 != null && rmsCategoryList1 != []) {
                rmsCategoryList2 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {            //二级类别
                    'in'("type", [0, 3])
                    eq("parentid", userActivity.activityCategory.parentid.toInteger())
                    eq("state", true)
                }
            }

            return render(view: 'editUserActivity', model: ['userActivity': userActivity, 'rmsCategoryList1': rmsCategoryList1, 'rmsCategoryList2': rmsCategoryList2])
        }
    }
    def queryCategoryTwo = {
        def category1 = params.category1
        def categoryList = RMSCategory.createCriteria().list() {
            eq("state", true)
            'in'("type", [0, 3])
            eq("parentid", category1)
        }
        def str = ""
        categoryList?.each { category ->
            str += "<option value='" + category?.id + "'>" + category?.name + "</option>"
        }
        render str
    }

    def uploadImg1(def opt) {
        def imgFile = request.getFile(opt + "Img")
        def imgType = imgFile.getContentType()

        def path = servletContext.getRealPath("/upload");

        def imgPath = ""

        if (imgFile && !imgFile.isEmpty()) {
            if (imgType == "image/pjpeg" || imgType == "image/jpeg" || imgType == "image/png" || imgType == "image/x-png" || imgType == "image/gif") {
                if (opt == "save") {
                    def sc = UserActivity.createCriteria()
                    def id = sc.get {
                        projections {
                            max "id"
                        }
                    }
                    id = id == null ? 1 : id + 1
                    imgPath = "i_" + id + ".jpg"
                } else if (opt == "update") {
                    def id = params.id
                    imgPath = "i_" + id + ".jpg"
                }
                imgFile.transferTo(new File("${path}/userActivityImg/" + imgPath))
            } else {
                flash.message = "上传图片格式不对..."
            }
        }
        return imgPath
    }
    def updateUserActivity = {
        def userActivity = UserActivity.get(params.id)
        if (userActivity) {
            if (params.version) {
                def version = params.version.toLong()
                if (userActivity.version > version) {
                    userActivity.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity')] as Object[], "Another user has updated this nts.activity.domain.UserActivity while you were editing")
                    render(view: "editUserActivity", model: [userActivity: userActivity])
                    return
                }
            }
            userActivity.properties = params
            def rmsCategory = RMSCategory.get(params.categoryId)
            userActivity.activityCategory = rmsCategory
            def photo = uploadImg1('update')
            if (photo != "null" && photo != "") {
                userActivity.photo = photo
            }
            userActivity.dateModified = new Date();
            if (!userActivity.hasErrors() && userActivity.save(flush: true)) {
                flash.message = "修改成功"
                if (params.toPage) redirect(action: "editUserActivity", params: [id: params.id, toPage: params.toPage])
            } else {
                flash.message = "修改失败"
                redirect(action: "editUserActivity", params: [id: params.id, toPage: params.toPage])
            }
        } else {
            flash.message = "修改对象不存在或已被删除"
            if (params.toPage) redirect(action: "editUserActivity", params: [id: params.id, toPage: params.toPage])
        }

    }
    def deleteUserActivity = {
        def userActivity = UserActivity.get(params.id)
        if (userActivity) {
            try {
                userActivity.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity'), params.id])}"
            }
            catch (DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity'), params.id])}"
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity'), params.id])}"
        }
        if (params.toPage) redirect(action: params.toPage)
    }
    def deleteUserActivityList = {
        def delIdList = params.idList

        if (delIdList instanceof String) delIdList = [params.idList]

        delIdList?.each { id ->
            def userActivity = UserActivity.get(id)
            if (userActivity) {
                try {
                    userActivity.delete(flush: true)
                    flash.message = "删除完成"
                }
                catch (DataIntegrityViolationException e) {
                    flash.message = "删除失败"
                }
            }
        }
        if (params.toPage) redirect(action: params.toPage)
        redirect(action: "myUserActivityList", params: params)
    }
    def myUserActivityList = {
        def userActivityList = search()
        def total = userActivityList.totalCount
        return render(view: 'myUserActivityList', model: [userActivityList: userActivityList, total: total, params: params])

    }
    def userWorkList = {
        def consumerId = CTools.nullToZero(session.consumer.id).longValue();
        def userWorkList = communityService.searchUserWork(params, consumerId);
        def total = userWorkList.totalCount
        return render(view: 'userWorkList', model: [userWorkList: userWorkList, total: total, params: params])

    }

    def showUserWork = {
        def userWorkInstance = UserWork.get(params.id)
        if (!userWorkInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'userWorkInstance.label', default: 'nts.activity.domain.UserWork'), params.id])}"
            redirect(action: "list")
        } else {
            def userVoteList = UserVote.createCriteria().list() {
                userWork {
                    eq('id', CTools.nullToZero(params.id).longValue())
                }
                consumer {
                    eq('id', CTools.nullToZero(session?.consumer?.id).longValue())
                }
            }
            if (userVoteList != null && userVoteList != []) {
                flash.voteState = 1
            } else {
                flash.voteState = 0
            }

            def newsUserWorkList = UserWork.list(max: 10, sort: "id", order: "desc")            //最新产品
            def hotUserWorkList = UserWork.list(max: 10, sort: "voteNum", order: "desc")            //热门产品
            [userWork: userWorkInstance, newsUserWorkList: newsUserWorkList, hotUserWorkList: hotUserWorkList]
        }
    }
    def voteAjax = {
        def userWorkId = params.userWorkId
        def consumerId = session.consumer.id
        def userWorkInstance = UserWork.get(userWorkId)
        def consumerInstance = Consumer.get(consumerId)
        def userVoteList = UserVote.createCriteria().list() {
            userWork {
                eq('id', CTools.nullToZero(userWorkId).longValue())
            }
            consumer {
                eq('id', CTools.nullToZero(consumerId).longValue())
            }
        }
        def userActivityInstance = UserActivity.get(userWorkInstance.userActivity.id)
        if (userVoteList != null && userVoteList != []) {
            //flash.voteState = 2
        } else {
            UserVote userVote = new UserVote(
                    userWork: userWorkInstance,
                    consumer: consumerInstance
            )
            if (userVote.save(flush: true)) {
                userWorkInstance.voteNum++
                userWorkInstance.save(flush: true)
                userActivityInstance.voteNum++
                userActivityInstance.save(flush: true)
            }
        }
        render "" + userWorkInstance.voteNum
    }


    def deleteUserWork = {
        def userWork = UserWork.get(params.id)
        if (userWork) {
            try {
                userWork.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'userWork.label', default: 'nts.activity.domain.UserWork'), params.id])}"
            }
            catch (DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'userWork.label', default: 'nts.activity.domain.UserWork'), params.id])}"
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'userWork.label', default: 'nts.activity.domain.UserWork'), params.id])}"
        }
        if (params.toPage) redirect(action: params.toPage)
    }
    def deleteUserWorkList = {
        def delIdList = params.idList

        if (delIdList instanceof String) delIdList = [params.idList]

        delIdList?.each { id ->
            def userWork = UserWork.get(id)
            if (userWork) {
                try {
                    userWork.delete(flush: true)
                    flash.message = "删除完成"
                }
                catch (DataIntegrityViolationException e) {
                    flash.message = "删除失败"
                }
            }
        }
        if (params.toPage) redirect(action: params.toPage)
    }
    def isApprovalUserWorkList = {
        def idList = params.idList
        if (idList instanceof String) idList = [params.idList]

        idList?.each { id ->
            def userWork = UserWork.get(id)
            if (userWork) {
                try {
                    userWork.approval = params.schApproval.toInteger()
                    userWork.save(flush: true)
                    flash.message = "操作成功"
                }
                catch (DataIntegrityViolationException e) {
                    flash.message = "操作失败"
                }
            }
        }

        redirect(action: "userWorkList", params: params)
    }
    def qnaireList = {
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        params.max = Math.min(params.max ? params.int('max') : 10, 200)
        return render(view: 'qnaireList', model: [qnaireList: Qnaire.list(params), qnaireInstanceTotal: Qnaire.count()])
    }
    def updateQnaire = {
        def qnaire = Qnaire.get(params.id);
        qnaire.delete()
        saveQnaire(params)
    }
    def qnairePage = {
        def typeTitles = ["", "单选题", "多选题"]
        def qnaire = Qnaire.get(params.id);
        if (!qnaire) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'qnaire.label', default: 'nts.system.domain.Qnaire'), params.id])}"
            redirect(action: "qnaireList")
        } else {
            return render(view: 'qnairePage', model: [qnaire: qnaire, typeTitles: typeTitles])
        }
    }
    def setState = {
        def qnaire = Qnaire.get(params.id as Long)
        if (qnaire) {
            def newsState = CTools.nullToZero(params.newState)
            qnaire.state = newsState

            if (newsState == Qnaire.PUBLIC_STATE)
                qnaire.datePublished = new Date()
            else if (newsState == Qnaire.CLOSE_STATE)
                qnaire.dateClosed = new Date()

            qnaire.save()
        }

        redirect(action: "qnaireList")
    }
    def editQnaire = {
        def qnaire = Qnaire.get(params.id)
        if (!qnaire) {
            flash.message = "not found nts.system.domain.Qnaire"
            redirect(action: "qnaireList")
        } else {
            return render(view: 'editQnaire', model: [qnaire: qnaire])
        }
    }
    def createQnaire = {

    }
    def saveQnaire = {
        def result = [:];
        Qnaire qnaire = new Qnaire()
        qnaire.name = params.name
        qnaire.consumer = session.consumer
        qnaire.description = params.description
        qnaire.state = Qnaire.NO_PUBLIC_STATE
        if (qnaire) {
            result = useApplyService.saveQnaire(params, qnaire);
            flash.message = result.message
            redirect(action: "qnaireList")
        } else {
            render(view: "createQnaire", model: [qnaire: qnaire])
        }
    }
    def deleteQnaire = {
        def delIdList = params.idList
        if (delIdList) {
            if (delIdList instanceof String) delIdList = [params.idList]
        } else {
            delIdList = [params.id]
        }
        delIdList?.each { id ->
            def qnaire = Qnaire.get(id)
            qnaire.delete()
        }

        redirect(action: 'qnaireList')
    }
    def surveylist = {
        def result = [:];
        result = useApplyService.surveylist(params);
        return render(view: 'surveylist', model: [surveyList: result.survey, surveyTotal: Survey.count()])
    }
    def surveyDelete = {
        def result = [:];
        result = useApplyService.surveyDelete(params);
        redirect(action: 'surveylist')
    }
    def statisticsList = {
        def result = [:];
        result = useApplyService.statisticsList(params);
        return render(view: 'statisticsList', model: [qnaireList: result.qnaireList, qnaireTotal: result.qnaireTotal])
    }
    def showStatistics = {
        def typeTitles = ["", "单选题", "多选题"]
        def total = 1;
        def qnaire = Qnaire.get(params.id);

        if (qnaire) {
            total = qnaire.surveyNum
            if (total == 0) total = 1
            [qnaire: qnaire, total: total, typeTitles: typeTitles]
        } else {
            flash.message = "qnaire not exist"
            redirect(action: "qnaireList")
        }
    }

    def serverNodeList = {

    }

    def localProgramServerNode = {
        def result = [:];
        result = distributeService.localProgramServerNode(params);
        return render(view: 'localProgramServerNode', model: [programList: result.programList, total: result.total]);
    }

    def programServerNode = {
        def res = [:];
        res = distributeService.programServerNode(params);
        return render(view: 'programServerNode', model: [programList: res.programs, total: res.total, errors: res.errors]);
    }

    def transcodeStatstic() {

    }

    def transcodeList() {

    }

    def transcodelistsubclass() {

    }

    def statisticsResource() {
        if (!params.offset) params.offset = 0;
        //节目下载排行
        List<Program> downProSta = Program.createCriteria().list(max: 8, offset: params.offset, sort: "downloadNum", order: "desc") {
            eq("state", Program.PUBLIC_STATE)
        }
        //节目浏览排行
        List<Program> viewProSta = Program.createCriteria().list(max: 8, offset: params.offset, sort: "frequency", order: "desc") {
            eq("state", Program.PUBLIC_STATE)
        }
        def viewTotal = viewProSta.totalCount;
        def downTotal = downProSta.totalCount;
        return render(view: 'statisticsResource', model: [downProSta: downProSta, viewProSta: viewProSta, viewTotal: viewTotal, downTotal: downTotal]);
    }

    def statisticsUserOperate() {
        return render(view: 'statisticsUserOperate');
    }

    def statisticsUserVisit() {
        if (!params.offset) params.offset = 0
        //用户最后登陆时间排行
        List<Consumer> lastLoginCmrSta = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [max: 10, offset: params.offset, sort: "dateLastLogin", order: "desc"])
        //用户浏览排行
        List<Consumer> viewCmrSta = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [max: 10, offset: params.offset, sort: "viewNum", order: "desc"])
        def total = Consumer.count();
        return render(view: 'statisticsUserVisit', model: [total: total, lastLoginCmrSta: lastLoginCmrSta, viewCmrSta: viewCmrSta]);
    }


}
