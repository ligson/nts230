package nts.front.activity.controllers

import grails.converters.JSON
import nts.activity.domain.UserActivity
import nts.activity.domain.UserWork
import nts.system.domain.SysConfig
import nts.user.services.ActionNameAnnotation
import nts.user.services.ControllerNameAnnotation
import nts.utils.CTools
import org.apache.commons.io.FileUtils
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.web.multipart.commons.CommonsMultipartFile
import nts.system.domain.RMSCategory
import nts.user.domain.Consumer

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

@ControllerNameAnnotation(name = "活动中心")
class UserActivityController {

    static allowedMethods = [save: "POST", update: "POST"]
    @ActionNameAnnotation(name =  "活动中心首页")
    def index() {
        if (!params.max) params.max = '8'
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = '0'
        params.isAll = 'yes'
        params.approval = "3"
        params.isOpen = true
        if (!params.state) params.state = "0"//表示所有活动

        /*
        //def newsUserActivityList = nts.activity.domain.UserActivity.findAll([max: 10, sort: "id", order: "desc"])			//最新活动
        def newsUserActivityList = UserActivity.createCriteria().list(max: 10, sort: 'id', order: 'desc') {
            if (params.categoryId) {
                eq("activityCategory", UserActivity.findById(Long.parseLong(params.categoryId)))
                eq("approval", UserActivity.PASS_APPROVAL)
                eq("isOpen", true)
                gt("endTime", new SimpleDateFormat("yyyy-MM-dd").format(new Date()))
            }
        }
        def hotUserActivityList = UserActivity.createCriteria().list(max: 10, sort: "workNum", order: "desc") {
            eq("approval", UserActivity.PASS_APPROVAL)
            eq("isOpen", true)
            gt("endTime", new SimpleDateFormat("yyyy-MM-dd").format(new Date()))
        }            //热门活动
        def rmsCategoryList1 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {            //一级类别
            'in'("type", [0, 3])
            eq("parentid", 0)
            eq("state", true)
        }
        def rmsCategoryList2 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {                //二级类别
            'in'("type", [0, 3])
            ne("parentid", 0)
            eq("state", true)
        }
        */
        //def userActivityType = params.userActivityType
        //def name = params.name
        //def consumer = params.consumer

        def userActivityList = search()
        def total = userActivityList.totalCount

        //[userActivityList: userActivityList, newsUserActivityList: newsUserActivityList, rmsCategoryList1: rmsCategoryList1, rmsCategoryList2: rmsCategoryList2, total: total, params: params, hotUserActivityList: hotUserActivityList]
        [userActivityList: userActivityList, total: total, params: params]
    }

    def search = {
        if (!params.max) params.max = '10'
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = '0'
        if (!params.year) params.year = '0'

        def state = params.state
        def name = params.name
        def nowDate = new Date().format("yyyy-MM-dd")
        List<RMSCategory> rms = [];
        if(params?.categoryId){
            RMSCategory rmsCategory = RMSCategory.get(params?.categoryId as Long)
            List<RMSCategory> categoryList = RMSCategory.findAllByParentid(params?.categoryId as Long);
            categoryList.each {
                rms.add(it)
            }
            rms.add(rmsCategory);
        }

        if(state == '0'){
            params.sort = 'startTime'
            params.order = 'desc'
        }
        def searchList = UserActivity.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (params.isAll != "yes") {
                consumer {
                    eq('id', CTools.nullToZero(session.consumer.id).longValue())
                }
            }
            if (state == "1")        //活动尚未开始
            {
                gt("startTime", nowDate)
            } else if (state == "2")    //活动正在进行
            {
                le("startTime", nowDate)
                ge("endTime", nowDate)
            } else if (state == "3")    //活动已结束
            {
                lt("endTime", nowDate)
            }
            if (Integer.parseInt(params.year) > 1000) {
                like('startTime', "%${params.year}%")
            } else if (Integer.parseInt(params.year) < 0) {
                le("startTime", -Integer.parseInt(params.year) + "")
            }
            if (name) {
                name = name.trim()
                like('name', "%${name}%")
            }
            if (CTools.nullToZero(params?.categoryId).longValue() != 0) {
                /*activityCategory {
                    eq('id', CTools.nullToZero(params?.categoryId).longValue())
                }*/
                if(rms.size()>0){
                    inList('activityCategory',rms)
                }
            }
            if (params.approval) {
                eq('approval', params.approval.toInteger())
            }
            if (params.isOpen) {
                eq('isOpen', params.isOpen)
            }
        }
        if (searchList == null) searchList = []
        return searchList
    }

    //所有活动
    def list = {
        def userActivityList = search()
        def total = userActivityList.totalCount
        //params.max = Math.min(params.max ? params.int('max') : 10, 100)
        def result = [userActivityList: userActivityList, total: total, params: params];
        if (params.returnType && params.returnType.equals("json")) {
            return render(result as JSON);
        } else {
            return render(view: 'list', model: result);
        }
    }

    //我发起的活动
    def myList = {
        def userActivityList = search()
        def total = userActivityList.totalCount

        [userActivityList: userActivityList, total: total, params: params]
    }

    //后台活动管理
    def listManager = {
        def userActivityList = search()
        def total = userActivityList.totalCount

        [userActivityList: userActivityList, total: total, params: params]
    }

    //我参与的活动
    def myJoinList = {
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        def name = params.name
        if (name == null) name = ""
        def total = 0

        def userActivityList = UserActivity.executeQuery("select distinct a from nts.activity.domain.UserActivity a join a.userWorks b where a.name like ? and b.consumer.id=? order by a.id desc", ["%" + name + "%", CTools.nullToZero(session.consumer.id).longValue()], [max: params.max, offset: params.offset]);
        /*def userActivityList.js = nts.activity.domain.UserActivity.createCriteria().list(max: params.max, offset: params.offset, sort:params.sort,order:params.order) {
            if (name)
            {
                name = name.trim()
                like('name',"%${name}%")
            }
            userWorks {
                consumer {
                    eq('id', nts.utils.CTools.nullToZero(session.consumer.id).longValue())
                }
            }
        }*/
        if (userActivityList == null) userActivityList = []
        //userActivityList.js.unique()

        def countList = UserActivity.executeQuery("select count(distinct a) from nts.activity.domain.UserActivity a join a.userWorks b where a.name like ? and b.consumer.id=? order by a.id desc", ["%" + name + "%", CTools.nullToZero(session.consumer.id).longValue()], [max: params.max, offset: params.offset]);
        total = countList[0]
        [userActivityList: userActivityList, total: total, params: params]
    }

    @ActionNameAnnotation(name = "创建活动")
    def create() {
        def rmsCategoryList1 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {            //一级类别
            'in'("type", [0, 3])
            eq("parentid", 0)
            eq("state", true)
        }
        def rmsCategoryList2 = null
        if (rmsCategoryList1 != null && rmsCategoryList1 != []) {
            rmsCategoryList2 = RMSCategory.createCriteria().list(sort: "id", order: "asc") {                //二级类别
                'in'("type", [0, 3])
                eq("parentid", rmsCategoryList1[0].id.toInteger())
                eq("state", true)
            }
        }

        def userActivity = new UserActivity()
        userActivity.properties = params
        return ['userActivity': userActivity, 'rmsCategoryList1': rmsCategoryList1, 'rmsCategoryList2': rmsCategoryList2]
    }

    //我发起活动
    def save() {
        def rmsCategory = RMSCategory.get(params.categoryId)
        if (params.description == null || params.description == "") params.description = "未填写"
        def image = uploadImg('save')
        if (image == null || image == "" || image == "null") {
            image = "default.jpg"
        }

        def approval = UserActivity.FOR_APPROVAL
        def isOpen = false
        if(session.consumer.role == Consumer.SUPER_ROLE){
            approval = UserActivity.PASS_APPROVAL
            isOpen = true
        }
        def description = CTools.htmlToBlank(params.description);
        UserActivity userActivity = new UserActivity(
                name: params.name,
                shortName: params.shortName,
                photo: image,
                description: description,
                startTime: params.startTime,
                endTime: params.endTime,
                activityCategory: rmsCategory,
                consumer: session.consumer,
                approval: approval,
                isOpen: isOpen
        )
        if (userActivity.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity'), userActivity.id])}"
            redirect(action: "index")
        } else {
            render(view: "create", model: [userActivity: userActivity])
        }
    }

    def show = {
        def userActivityInstance = UserActivity.get(params.id)
        if (!userActivityInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity'), params.id])}"
            redirect(action: "list")
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
            def newsUserActivityList = UserActivity.createCriteria().list(max: 10, sort: "id", order: "desc") {
                gt("endTime", new SimpleDateFormat("yyyy-MM-dd").format(new Date()))
            }            //最新活动
            def hotUserActivityList = UserActivity.createCriteria().list(max: 10, sort: "workNum", order: "desc") {
                gt("endTime", new SimpleDateFormat("yyyy-MM-dd").format(new Date()))
            }            //热门活动


            [userActivity: userActivityInstance, userWorkList: userWorkList, total: userWorkList.totalCount, newsUserActivityList: newsUserActivityList, hotUserActivityList: hotUserActivityList, offset: params.offset, max: params.max]
        }
    }

    def edit = {
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

            return ['userActivity': userActivity, 'rmsCategoryList1': rmsCategoryList1, 'rmsCategoryList2': rmsCategoryList2]
        }
    }

    def update = {
        def userActivity = UserActivity.get(params.id)
        if (userActivity) {
            if (params.version) {
                def version = params.version.toLong()
                if (userActivity.version > version) {
                    userActivity.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity')] as Object[], "Another user has updated this nts.activity.domain.UserActivity while you were editing")
                    render(view: "edit", model: [userActivity: userActivity])
                    return
                }
            }
            userActivity.properties = params
            def rmsCategory = RMSCategory.get(params.categoryId)
            userActivity.activityCategory = rmsCategory
            def photo = uploadImg('update')
            if (photo != "null" && photo != "") {
                userActivity.photo = photo
            }
            userActivity.dateModified = new Date();
            if (!userActivity.hasErrors() && userActivity.save(flush: true)) {
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

    def delete = {
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

    //批量删除活动
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
        redirect(action: "myList", params: params)
    }

    //批量开启和关闭活动
    def isOpenUserActivityList = {
        def idList = params.idList

        if (idList instanceof String) idList = [params.idList]
        def isOpens = params.isOpens == "true" ? true : false

        idList?.each { id ->
            def userActivity = UserActivity.get(id)
            if (userActivity) {
                try {
                    userActivity.isOpen = isOpens
                    userActivity.save(flush: true)
                    flash.message = "操作成功"
                }
                catch (DataIntegrityViolationException e) {
                    flash.message = "操作失败"
                }
            }
        }

        redirect(action: "myList", params: params)
    }

    def queryCategoryTwo = {
        def category1 = params.category1.toInteger()
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

    //上传图片(opt：值为save表示添加图片，值为update表示修改图片)
    def uploadImg(def opt) {
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

                File userActivityImg = new File("${path}/userActivityImg/");
                if(!userActivityImg.exists()){
                    userActivityImg.mkdirs();
                }

                imgFile.transferTo(new File(userActivityImg.getAbsolutePath(), imgPath))
            } else {
                flash.message = "上传图片格式不对..."
            }
        }
        return imgPath
    }


    def uploadWork = {
        def result = [:];
        //serialId,fileEntity
        try {
            int activityId = params.activityId as int;
            int userId = params.userId as int;
            CommonsMultipartFile fileEntity = params.fileEntity;

            def UploadRootPath = SysConfig.findByConfigName('UploadRootPath');        //上传路径设置
            def rootFile = new File(UploadRootPath.configValue, "userActivity${activityId}/${userId}");

            if (!rootFile.exists()) {
                rootFile.mkdirs();
            }

            File dest = new File(rootFile, fileEntity.originalFilename);
            if (dest.exists()) {
                dest.delete();
            }
            dest.createNewFile();
            FileUtils.copyInputStreamToFile(fileEntity.inputStream, dest);
            result.success = true;
            result.filePath = dest.getAbsolutePath();

        } catch (Exception e) {
            result.success = false;
            result.msg = e.message;
        }
        response.setContentType("text/json");
        return render(result as JSON);
    }
}
