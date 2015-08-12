package nts.front.activity.controllers

import grails.converters.JSON
import nts.activity.domain.UserActivity
import nts.activity.domain.UserVote
import nts.activity.domain.UserWork
import nts.program.domain.Program
import nts.program.domain.Serial
import nts.user.domain.Consumer
import nts.user.services.ActionNameAnnotation
import nts.user.services.ControllerNameAnnotation
import nts.utils.CTools
import org.springframework.dao.DataIntegrityViolationException
@ControllerNameAnnotation(name="作品管理")
class UserWorkController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def searchUserWork = {
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        def name = params.name

        def searchList = UserWork.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (params.isMy == "yes") {
                consumer {
                    eq('id', CTools.nullToZero(session.consumer.id).longValue())
                }
            }
            if (name) {
                name = name.trim()
                like('name', "%${name}%")
            }
            if (params.approval) {
                eq('approval', params.approval.toInteger())
            }
        }
        if (searchList == null) searchList = []
        return searchList
    }

    //我提交的作品
    def myList = {
        params.isMy = "yes"
        def userWorkList = searchUserWork()
        def total = userWorkList.totalCount
        //params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [userWorkList: userWorkList, total: total, params: params]
    }
    @ActionNameAnnotation(name="上传作品")
    def create() {
        //def userWork = new nts.activity.domain.UserWork()
        return render(view: 'create', model: [id: params.id]);
    }

    def save = {
        def serialId = params.serialId.toInteger()
        UserActivity userActivity = UserActivity.get(params.avtivityId)
        Consumer consumer = session.consumer;
        if (!consumer) {
            consumer = Consumer.findById(params.key as long);
            if (!consumer) {
                return render([success: false, msg: '用户不存在'] as JSON);
            }
        }
        def description = CTools.htmlToBlank(params.description);
        UserWork userWork = new UserWork(
                name: params.name,
                description: description,
                consumer: consumer,
                serialId: params.serialId,
                svrAddress: params.svrAddress,
                userActivity: userActivity,
                filePath: params.url,
                urlType: params.urlType,
                fileHash: params.fileHash,
                fileType: params.fileType,
                state: 1,  //默认为待转码
                transcodeState: 1 // //默认为待转码
        )
        if (serialId > 0) {
            Serial serial = Serial.get(serialId)
            userWork.state = serial.state
            userWork.urlType = serial.urlType
            userWork.transcodeState = serial.transcodeState
            userWork.process = serial.process
            userWork.svrAddress = serial.svrAddress
            userWork.filePath = serial.filePath
        }
        if (userWork.save(flush: true)) {
            userActivity.workNum = userActivity.workNum + 1
            userActivity.save(flush: true)
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'userWork.label', default: 'nts.activity.domain.UserWork'), userActivity.id])}"
            if (params.returnType && params.returnType.equals("json")) {
                return render([success: true] as JSON);
            } else {
                redirect(controller: "userActivity", action: "show", id: userActivity.id)
            }
        } else {
            if (params.returnType && params.returnType.equals("json")) {
                return render([success: false, msg: userActivity] as JSON);
            } else {
                render(view: "create", model: [userActivity: userActivity])
            }

        }
    }

    def show = {
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
            def otherUserWorkList = UserWork.createCriteria().list {
                eq("userActivity", userWorkInstance.userActivity)
                notEqual("id", userWorkInstance.id)
                eq('approval', 3)
                setMaxResults(4)
                order("id", "desc")
            }

            userWorkInstance.visitCount += 1
            userWorkInstance.save(flush: true)

            [userWork: userWorkInstance, newsUserWorkList: newsUserWorkList, hotUserWorkList: hotUserWorkList, otherUserWorkList: otherUserWorkList]
        }
    }

    def edit = {
        def userWork = UserWork.get(params.id)
        if (!userWork) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'userWork.label', default: 'nts.activity.domain.UserWork'), params.id])}"
            redirect(action: "myList")
        } else {
            return [userWork: userWork]
        }
    }

    def update = {
        def serialId = params.serialId.toInteger()
        def userWork = UserWork.get(params.id)
        userWork.name = params.name
        userWork.description = params.description
        userWork.urlType = params.urlType.toInteger()
        userWork.serialId = serialId
        if (params.url) {
            userWork.filePath = params.url
            userWork.svrAddress = params.svrAddress
        }
        if (serialId > 0) {
            Serial serial = Serial.get(serialId)
            userWork.state = serial.state
            userWork.urlType = serial.urlType
            userWork.transcodeState = serial.transcodeState
            userWork.process = serial.process
            userWork.svrAddress = serial.svrAddress
            userWork.filePath = serial.filePath
        }
        if (userWork) {
            if (params.version) {
                def version = params.version.toLong()
                if (userWork.version > version) {
                    userWork.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'userWork.label', default: 'nts.activity.domain.UserWork')] as Object[], "Another user has updated this nts.activity.domain.UserWork while you were editing")
                    render(view: "edit", model: [userWork: userWork])

                }
            }
            if (!userWork.hasErrors() && userWork.save(flush: true)) {
                flash.message = "修改成功"
                if (params.toPage) redirect(action: "edit", params: [id: params.id, toPage: params.toPage])

            } else {
                flash.message = "修改失败"
                redirect(action: "edit", params: [id: params.id, toPage: params.toPage])
            }
        } else {
            flash.message = "修改对象不存在或已被删除"
            if (params.toPage) redirect(action: "edit", params: [id: params.id, toPage: params.toPage])

        }
    }
    def removeWork = {
        def result = [:];
        if (params.hash && params.activityId) {
            UserActivity userActivity = UserActivity.findById(params.activityId as int);
            if (userActivity) {
                UserWork userWork = UserWork.findByUserActivityAndFileHash(userActivity, params.hash);
                if (userWork) {
                    try {
                        userWork.delete();
                        result.success = true;
                    } catch (Exception e) {
                        result.success = false;
                        result.msg = e.message;
                    }
                } else {
                    result.success = false;
                    result.msg = "用户作品不存在！"
                }
            } else {
                result.success = false;
                result.msg = "参数不全！";
            }
        } else {
            result.success = false;
            result.msg = "参数不全！";
        }
        return render(result as JSON);

    }
    def delete = {
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

    //批量删除活动
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

    //后台作品管理
    def listManager = {
        def userWorkList = searchUserWork()
        def total = userWorkList.totalCount

        [userWorkList: userWorkList, total: total, params: params]
    }

    //批量通过和禁用作品
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

        redirect(action: "listManager", params: params)
    }

    //搜索资源，供从现有资源提取设置用 Material素材的意思
    def searchMaterialProgram = {
        def result = search(params)

        render(template: 'searchMaterialProgramList', model: [programList: result.programList, total: result.total, keyword: params.keyword])
    }

    //搜索名称供素材,相关资源
    def search(params) {
        def keyword = CTools.nullToBlank(params.keyword)
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0

        params.sort = "id"
        params.order = "desc"


        def programList = null
        def total = 0

        programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (keyword != '') ilike("name", "%${keyword}%")
            if (CTools.nullToZero(params.isRelation) == 1 && CTools.nullToZero(params.programId) > 0) ne('id', params.programId.toLong())
            or {
                ge("state", Program.PUBLIC_STATE)
                and {
                    eq('consumer', session.consumer)
                    ge("state", Program.NO_APPLY_STATE)
                }
            }
        }

        total = programList.totalCount

        [programList: programList, total: total]
    }

    //用于提取 从资源中提取programId是素材资源的id,其返回素材资源数据到素材编辑页面
    def editMaterial = {
        def program = null
        def programId = CTools.nullToZero(params?.program?.id)

        if (programId > 0)
            program = Program.get(programId)
        else
            flash.message = "Material programId < 0"

        render(template: 'editMaterial', model: [program: program])
    }

    //给作品投票
    def vote = {
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
            flash.voteState = 2
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

                flash.voteState = "1"
                flash.message = "${message(code: 'default.created.message', args: [message(code: 'userVote.label', default: 'nts.activity.domain.UserVote'), userVote.id])}"
            } else {
                flash.voteState = "0"
            }
        }
        redirect(controller: "userActivity", action: "show", id: userActivityInstance.id)
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

    /**
     * 功能：web service 接口 供手机调用,手机程序post方法提交作品数据,本web service保存数据到user_work表，返回xml数据
     。
     * 调用：http://localhost:8080/nts/userWork/saveWork?avtivityId=2&uid=1&name=textWork&description=testWorddddd&svrAddress=192.168.0.127&url=e:\pub\a.mp4&urlType=0&fileHash=aabd33333333&fileType=3gp
     * 说明：上面调用url为测试用，实际实用中应post方法提交，参数：avtivityId是作品所属活动id  uid是上传用户的id name是作品名称  description是作品描述 svrAddress是视频服务器地址 url是文件路径 urlType是作品类型（0视频 2图片）详细可参考UserWork domain 
     */
    def saveWork = {
        def msgXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"    //操作返回xml
        def msg = ""

        boolean bOK = false
        boolean bAuth = false    //认证是否成功

        UserActivity userActivity = null
        Consumer consumer = null

        bAuth = true    //认证现暂不实现
        try {
            if (bAuth) {
                userActivity = UserActivity.get(params.avtivityId)
                if (userActivity) {
                    consumer = Consumer.get(params.uid)
                    if (consumer) {
                        UserWork userWork = new UserWork(
                                name: params.name,
                                description: params.description,
                                consumer: consumer,
                                svrAddress: params.svrAddress,
                                userActivity: userActivity,
                                filePath: params.url,
                                urlType: params.urlType,
                                fileHash: params.fileHash,
                                fileType: params.fileType
                        )

                        if (userWork.save(flush: true)) {
                            userActivity.workNum = userActivity.workNum + 1
                            userActivity.save(flush: true)
                            bOK = true
                        } else {
                            userWork.errors.allErrors.each {
                                println it
                            }

                            msg = "Save failure."
                        }
                    } else {
                        msg = "consumer not exist for id ${params.uid}."
                    }
                } else {
                    msg = "userActivity not exist for id ${params.avtivityId}."
                }
            } else {
                msg = "Authentication failure."
            }
        }
        catch (Exception e) {
            msg = "Exception:" + e.toString();
        }

        msgXml += "<message>\n"
        msgXml += "<stauts>${bOK ? 'success' : ' failure'}</stauts>\n"
        msgXml += "<description>${msg}</description>\n"
        msgXml += "</message>\n"

        render(text: msgXml, contentType: "text/xml", encoding: "UTF-8")
    }

}
