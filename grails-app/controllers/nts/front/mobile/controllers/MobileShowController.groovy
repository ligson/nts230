package nts.front.mobile.controllers

import grails.converters.JSON
import nts.activity.domain.UserActivity
import nts.activity.domain.UserVote
import nts.activity.domain.UserWork
import nts.program.domain.Program
import nts.program.category.domain.ProgramCategory
import nts.program.domain.ProgramTag
import nts.program.domain.Serial
import nts.system.domain.Directory
import nts.system.domain.OperationLog
import nts.user.domain.Consumer
import nts.utils.CTools
import nts.system.domain.RMSCategory
import java.text.DateFormat;
import java.text.SimpleDateFormat

class MobileShowController {
    def programService;
    def programCategoryService;
    def index = {
        //视频集合
        ProgramCategory videoCategory = programCategoryService.queryVideoCategory();
        def videoList = programService.search([orderBy: "dateCreated", order: "desc", programCategoryId: videoCategory.id, max: 5, offset: 0], false);

        //推荐文档
        ProgramCategory docCategory = programCategoryService.queryDocCategory();
        List<Program> recommendVideoList = [];
        recommendVideoList = programService.search([orderBy: "dateCreated", order: "desc", programCategoryId: docCategory.id, max: 5, offset: 0], false);

        //推荐图片
        ProgramCategory imageCategory = programCategoryService.queryImageCategory();
        def recommendImageList = [];
        recommendImageList = programService.search([orderBy: "dateCreated", order: "desc", programCategoryId: imageCategory.id, max: 5, offset: 0], false);

        //公开课程
        ProgramCategory courseCategory = programCategoryService.queryCourseCategory();
        List<Program> publicStudyList = [];
        publicStudyList = programService.search([orderBy: "dateCreated", order: "desc", programCategoryId: courseCategory.id, max: 5, offset: 0], false);

        //获取视频名称
        def videoName = programCategoryService.queryVideoCategoryName();
        // 获取文档名称
        def docName = programCategoryService.queryDocCategoryName();
        // 获取图片名称
        def photoName = programCategoryService.queryPhotoCategoryName();
        return render(view: 'index', model: [publicStudyList: publicStudyList, videoList: videoList, recommendVideoList: recommendVideoList, recommendImageList: recommendImageList, videoName: videoName, docName: docName, photoName: photoName])

    }

    def mobileShow = {
        def id = params.id;
        Program program = Program.get(id);
        def serial = programService.serialFirst(program);
        if (serial) {
            if (serial.urlType == Serial.URL_TYPE_VIDEO) {
                return redirect(action: 'mobileVideoShow', params: [id: program.id])
            } else if (serial.urlType == Serial.URL_TYPE_IMAGE) {
                return redirect(action: 'mobileImagesPlay', params: [id: program.id])
            } else if (serial.urlType == Serial.URL_TYPE_DOCUMENT) {
                return redirect(action: 'mobileDocPlay', params: [id: program.id])
            }
        }

    }
    def mobileVideoIndex = {
        def parentCate = ProgramCategory.findByParentCategory(null);
        def programCategoryList = ProgramCategory.withCriteria {
            eq('mediaType', 1)
            notEqual('parentCategory', parentCate)
        }
        //最近视频
        def newVideo = Program.withCriteria {
            eq("state", Program.PUBLIC_STATE)
            order('dateCreated', 'desc')
            serials {
                eq('urlType', Serial.URL_TYPE_VIDEO)
            }
            maxResults(4)
        }
        //推荐文档
        def recommendVideoList = [];
        def idList = Program.withCriteria {
            eq("state", Program.PUBLIC_STATE)
            serials {
                eq('urlType', Serial.URL_TYPE_VIDEO)
            }
            order('recommendNum', 'desc')
            projections {
                distinct('id')
            }
            maxResults(6)
        }
        idList.each {
            recommendVideoList.add(Program.get(it));
        }
        //获取视频名称
        def videoName = programCategoryService.queryVideoCategoryName();
        return render(view: 'mobileVideoIndex', model: [programCategoryList: programCategoryList, newVideo: newVideo, recommendVideoList: recommendVideoList, videoName: videoName])
    }
    def mobileDocIndex = {
        def parentCate = ProgramCategory.findByParentCategory(null);
        def programCategoryList = ProgramCategory.withCriteria {
            eq('mediaType', 3)
            notEqual('parentCategory', parentCate)
        }
        //最近文档
        def newDoc = Program.withCriteria {
            eq("state", Program.PUBLIC_STATE)
            order('dateCreated', 'desc')
            serials {
                eq('urlType', Serial.URL_TYPE_DOCUMENT)
            }
            maxResults(4)
        }
        //推荐文档
        def recommendDocList = [];
        def idList = Program.withCriteria {
            eq("state", Program.PUBLIC_STATE)
            serials {
                eq('urlType', Serial.URL_TYPE_DOCUMENT)
                eq('state', Serial.CODED_STATE)
            }
            order('recommendNum', 'desc')
            projections {
                distinct('id')
            }
            maxResults(6)
        }
        idList.each {
            recommendDocList.add(Program.get(it));
        }
        //获取文档名称
        def docName = programCategoryService.queryDocCategoryName();
        return render(view: 'mobileDocIndex', model: [programCategoryList: programCategoryList, newDoc: newDoc, recommendDocList: recommendDocList, docName: docName])
    }
    //记录点播次数
    def frequencyNum = {
        def result = [:];
        def frequency = params.frequency;
        def programId = params.programId;
        if (programId) {
            def program = Program.get(programId);
            int Num = Integer.parseInt(frequency);
            Num++;
            program.frequency = Num;
            if (program.save()) {
                result.success = true;
            } else {
                result.success = false;
            }
        }
        return render(result as JSON)
    }
    def mobileSearchMeau = {
        //父类
        def parentCategory = ProgramCategory.findByParentCategory(null);
        def mediaType = params.mediaType;
        //一级分类
        def firstCategoryList = ProgramCategory.withCriteria {
            eq('parentCategory', parentCategory)
            if (mediaType) {
                eq('mediaType', Integer.parseInt(mediaType))
            }
        }
        //二级分类
        def secondCategoryList = [];
        firstCategoryList.each {
            def programCategory = ProgramCategory.findAllByMediaTypeAndParentCategory(Integer.parseInt(mediaType), it);
            secondCategoryList.addAll(programCategory);
        }


        return render(view: 'mobileSearchMeau', model: [secondCategoryList: secondCategoryList, firstCategoryList: firstCategoryList])
    }

    def mobileImagesIndex = {
        def parentCate = ProgramCategory.findByParentCategory(null);
        def programCategoryList = ProgramCategory.withCriteria {
            eq('mediaType', 4)
            notEqual('parentCategory', parentCate)
        }
        //最近图片
        def newImage = Program.withCriteria {
            eq("state", Program.PUBLIC_STATE)
            order('dateCreated', 'desc')
            serials {
                eq('urlType', Serial.URL_TYPE_IMAGE)
            }
            maxResults(4)
        }
        //推荐图片
        def recommendImageList = [];
        def idList = Program.withCriteria {
            eq("state", Program.PUBLIC_STATE)
            serials {
                eq('urlType', Serial.URL_TYPE_IMAGE)
            }
            order('recommendNum', 'desc')
            projections {
                distinct('id')
            }
            maxResults(6)
        }
        idList.each {
            recommendImageList.add(Program.get(it));
        }
        //获取图片名称
        def photoName = programCategoryService.queryPhotoCategoryName();
        return render(view: 'mobileImagesIndex', model: [programCategoryList: programCategoryList, newImage: newImage, recommendImageList: recommendImageList, photoName: photoName])
    }

    def mobileImagesPlay = {
        String id = params.id;
        Program program = Program.get(id);
        return render(view: 'mobileImgesPlay', model: [program: program])
    }
    def connectionFails = {
        String id = params.id;
        Program program = Program.get(id);
        return render(view: 'connectionFails', model: [program: program])
    }
    def mobileDocPlay = {
        def id = params.id;
        Program program = Program.get(id);
        return render(view: 'mobileDocPlay', model: [program: program])
    }
    def mobileAjaxSearch = {
        def parentCategory = ProgramCategory.findByParentCategory(null);
        def firstCategory = ProgramCategory.findAllByParentCategory(parentCategory);
        def programTagList = ProgramTag.list(order: 'dateCreated', max: 5);
        def directoryList = Directory.withCriteria {
            maxResults(6)
            order("dateCreated", 'desc')
        }
        if (params.max == '6') params.max = 12;
        if (!params.max) params.max = 6;
        if (!params.offset) params.offset = 0;
        def programcategoryId = params.programcategoryId;
        def classLibId = params.classLibId;
        def mediaType = params.mediaType;
        def programTagId = params.programTagId;
        def name = params.name;
        def programList = Program.createCriteria().list(max: params.max, offset: params.offset) {
            if (name) {
                like('name', '%' + name + '%')
            }
            if (programcategoryId) {
                def programCategory = ProgramCategory.get(programcategoryId);
                // eq('programCategory', programCategory)
                programCategories {
                    eq('id', programCategory.id)
                }
            }
            if (classLibId) {
                def directory = Directory.get(classLibId)
                eq('classLib', directory)
            }
            if (mediaType) {
                if (mediaType == '1') {
                    serials {
                        eq('urlType', Serial.URL_TYPE_VIDEO)
                    }
                }
                if (mediaType == '3') {
                    serials {
                        eq('urlType', Serial.URL_TYPE_DOCUMENT)
                    }
                }
                if (mediaType == '4') {
                    serials {
                        eq('urlType', Serial.URL_TYPE_IMAGE)
                    }
                }
            }
            if (programTagId) {
                programTags {
                    eq('id', Long.parseLong(programTagId))
                }
            }

        }

        def total = programList.totalCount;
        def result = [:]
        result.programList = programList;
        result.total = total;
        result.max = params.max;
        def appendHtml = '';
        for (int i = 0; i < programList.size(); i++) {
            def program = programList[i];
            appendHtml += "<div id=\"div${i % 6}\" class=\"fluid boful_mobile_recommend_item\">\n" +
                    "        <a href=\"${createLink(action: 'mobileShow', params: [id: program?.id])}\" title=\"${program?.name}\">\n" +
                    "\n" +
                    "            <img src=\"${posterLinkNew(program: program, size: '289x289')}\"\n" +
                    "                 onerror=\"this.src ='${resource(dir: 'skin/blue/mobile/images', file: 'boful_mobile_recommend_item_img.jpg')}'\"/>\n" +
                    "            <p>${CTools.cutString(program?.name, 5)}</p>\n" +
                    "        </a>\n" +
                    "    </div>";
        }
        result.appendHtml = appendHtml
        return render(result as JSON)
    }
    def mobileSearch = {
        def parentCategory = ProgramCategory.findByParentCategory(null);
        def firstCategory = ProgramCategory.findAllByParentCategory(parentCategory);
        def programTagList = ProgramTag.list(order: 'dateCreated', max: 5);
        def directoryList = Directory.withCriteria {
            maxResults(6)
            order("dateCreated", 'desc')
        }
        if (!params.max) params.max = 6;
        if (!params.offset) params.offset = 0;
        def programcategoryId = params.programcategoryId;
        def classLibId = params.classLibId;
        def mediaType = params.mediaType;
        def programTagId = params.programTagId;
        def name = params.name;
        def programList = Program.createCriteria().list(max: params.max, offset: params.offset) {
            if (name) {
                like('name', '%' + name + '%')
            }
            if (programcategoryId) {
                def programCategory = ProgramCategory.get(programcategoryId);
//                eq('programCategory', programCategory)
                programCategories {
                    eq('id', programCategory.id)
                }
            }
            if (classLibId) {
                def directory = Directory.get(classLibId)
                eq('classLib', directory)
            }
            if (mediaType) {
                if (mediaType == '1') {
                    serials {
                        eq('urlType', Serial.URL_TYPE_VIDEO)
                    }
                }
                if (mediaType == '3') {
                    serials {
                        eq('urlType', Serial.URL_TYPE_DOCUMENT)
                    }
                }
                if (mediaType == '4') {
                    serials {
                        eq('urlType', Serial.URL_TYPE_IMAGE)
                    }
                }
            }
            if (programTagId) {
                programTags {
                    eq('id', Long.parseLong(programTagId))
                }
            }

        }

        def total = programList.totalCount;
        return render(view: 'mobileSearch', model: [programList: programList, total: total, name: name])
    }

    def mobileVideoShow = {
        def programId = params.id;
        int id;
        if (programId) {
            id = Integer.parseInt(programId);
        }
        Program program = Program.get(id);
        Serial serial
        if (program) {
            serial = programService.serialFirst(program);
        }
        return render(view: 'mobileVideoShow', model: [program: program, serial: serial])
    }
    // --- login 用户登陆验证方法   0 - 密码错误 1 - 用户不存在  2 - 用户已过期
    def login = {
        //
    }

    def checkLogin = {
        //println '-----------密码--------------------'+EncodePasswd.EncodePasswd(params.name)

        def consumer = Consumer.findByName(params.name)
        if (consumer) {
            def nowDate = getNowDate();
            def dateValid = consumer.dateValid.format("yyy-MM-dd")
            if (nowDate > dateValid) {                                // 判断用户是否已过有效期
                redirect(action: 'loginError', params: [loginFlg: 2])
            } else if (consumer.isRegister) {                                //判断用户是否是锁定状态
                redirect(action: 'loginError', params: [loginFlg: 7])
            } else if (!consumer.userState) {                                //判断用户是否是锁定状态
                redirect(action: 'loginError', params: [loginFlg: 4])
            } else {
                //匿名用户不用验证密码了，因为匿名用户用户名密码是硬编码的，如果管理员将匿名密码改了，则不能匿名登录了
                //println consumer.password +"=="+ params.password
                if (consumer.password == params.password || consumer.password == params.password.encodeAsPassword() || consumer.name == 'anonymity') {

                    if (consumer.name != 'anonymity') {
                        consumer.loginNum = consumer.loginNum + 1
                        consumer.dateLastLogin = new Date()
                        //---将登陆信息写入日志 nts.system.domain.OperationLog
                        new OperationLog(tableName: 'consumer', tableId: consumer.id, operator: consumer.name, modelName: '用户登陆', brief: '登陆操作', operatorId: consumer.id, operation: OperationEnum.LOGIN).save()


                    }

                    session.consumer = consumer

                } else {
                    redirect(action: loginError, params: [loginFlg: 1])
                }
            }
        } else {
            redirect(action: loginError, params: [loginFlg: 1])
        }
    }

    //资源详细页面
    def show = {
        def userActivityInstance = UserActivity.get(params.id)
        def userWorkList = null

        ////////////////////////没有登录的作为匿名用户 开始
        if (!session.consumer) {
            def consumer = Consumer.findByName(servletContext.anonymityUserName)
            //判断用户是否是锁定状态
            if (consumer) {
                if (!consumer.userState) {
                    redirect(action: loginError, params: [loginFlg: 4])
                    return
                }
                session.consumer = consumer
            } else {
                redirect(action: loginError, params: [loginFlg: 1])
                return
            }
        }
        ////////////////////////没有登录的作为匿名用户 结束

        //用于页面上面目录
        def rmsCategoryList = RMSCategory.createCriteria().list(sort: "id", order: "asc") {                //二级类别
            'in'("type", [0, 3])
            ne("parentid", 0)
            eq("state", true)
        }


        if (!userActivityInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity'), params.id])}"
            redirect(action: "list")
        } else {
            if (!params.max) params.max = 8
            if (!params.sort) params.sort = 'voteNum'
            if (!params.order) params.order = 'desc'
            if (!params.offset) params.offset = 0

            userWorkList = UserWork.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                userActivity {
                    eq('id', userActivityInstance.id)
                }
                eq('approval', 3)
            }

            def args = "id=${params.id}&max=${params.max}&sort=${params.sort}&order=${params.order}"
            [userActivity: userActivityInstance, userWorkList: userWorkList, total: userWorkList.totalCount, rmsCategoryList: rmsCategoryList, args: args]
        }


    }

    def workShow = {

        ////////////////////////没有登录的作为匿名用户 开始
        if (!session.consumer) {
            def consumer = Consumer.findByName(servletContext.anonymityUserName)
            //判断用户是否是锁定状态
            if (consumer) {
                if (!consumer.userState) {
                    redirect(action: loginError, params: [loginFlg: 4])
                    return
                }
                session.consumer = consumer
            } else {
                redirect(action: loginError, params: [loginFlg: 1])
                return
            }
        }
        ////////////////////////没有登录的作为匿名用户 结束

        def userWorkInstance = UserWork.get(params.id)
        def userWorkList = null
        if (!userWorkInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'userWorkInstance.label', default: 'nts.activity.domain.UserWork'), params.id])}"
            redirect(action: "list")
        } else {
            def userVoteList = UserVote.createCriteria().list() {
                userWork {
                    eq('id', CTools.nullToZero(params.id).longValue())
                }
                consumer {
                    eq('id', CTools.nullToZero(session.consumer.id).longValue())
                }
            }
            if (userVoteList != null && userVoteList != []) {
                flash.voteState = 1
            } else {
                flash.voteState = 0
            }

            if (!params.max) params.max = 8
            if (!params.sort) params.sort = 'voteNum'
            if (!params.order) params.order = 'desc'
            if (!params.offset) params.offset = 0

            userWorkList = UserWork.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                userActivity {
                    eq('id', userWorkInstance.userActivity.id)
                }
                eq('approval', 3)
            }

        }

        //用于页面上面目录
        def rmsCategoryList = RMSCategory.createCriteria().list(sort: "id", order: "asc") {                //二级类别
            'in'("type", [0, 3])
            ne("parentid", 0)
            eq("state", true)
        }
        def rmsCategory = null

        //if(directoryId > 0) rmsCategory = nts.system.domain.RMSCategory.get(params.directoryId)
        [userWork: userWorkInstance, userWorkList: userWorkList, rmsCategoryList: rmsCategoryList]
    }

    //资源浏览 右边资源列表
    def categoryView = {
        //long t1=System.currentTimeMillis()
        if (!params.max) params.max = 8
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        def total = 0
        def userActivityList = null
        def directoryId = CTools.nullToZero(params.directoryId)
        def keyword = CTools.nullToBlank(params.keyword).trim()

        ////////////////////////没有登录的作为匿名用户 开始
        if (!session.consumer) {
            def consumer = Consumer.findByName(servletContext.anonymityUserName)
            //判断用户是否是锁定状态
            if (consumer) {
                if (!consumer.userState) {
                    redirect(action: loginError, params: [loginFlg: 4])
                    return
                }
                session.consumer = consumer
            } else {
                redirect(action: loginError, params: [loginFlg: 1])
                return
            }
        }
        ////////////////////////没有登录的作为匿名用户 结束

        //查询条件
        userActivityList = UserActivity.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            //左边树条件

            if (directoryId > 0) {
                eq("activityCategory.id", (long) directoryId)
            }

            //关键词条件
            if (keyword) {
                ilike("name", "%${keyword}%")
            }

        }

        //用于页面上面目录
        def rmsCategoryList = RMSCategory.createCriteria().list(sort: "id", order: "asc") {                //二级类别
            'in'("type", [0, 3])
            ne("parentid", 0)
            eq("state", true)
        }
        def rmsCategory = null

        if (directoryId > 0) rmsCategory = RMSCategory.get(params.directoryId);

        def args = "directoryId=${params.directoryId}&keyword=${keyword}&max=${params.max}&sort=${params.sort}&order=${params.order}"

        return [userActivityList: userActivityList, total: userActivityList?.totalCount, params: params, rmsCategoryList: rmsCategoryList, rmsCategory: rmsCategory, args: args]
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
        redirect(controller: "mobileShow", action: "show", id: userActivityInstance.id)
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

    //---新增getNowDate 用来获得“yyyy-MM-DD”格式的日期
    def getNowDate = {
        def date = new Date()
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd")
        def nowDate = dateFormat.format(date)
        return nowDate
    }

    def mobileCourse = {
        if (!params.max) params.max = 10
        List<ProgramCategory> programCategoryList = ProgramCategory.createCriteria().list() {
            eq('mediaType', 5)
            notEqual('name', "开放课程")
        }
        def publicIds = Program.withCriteria {
            eq("otherOption", Program.ONLY_LESSION_OPTION)
            projections {
                distinct('id')
            }
            if (params.max instanceof String)
                maxResults(Integer.parseInt(params.max))
            else
                maxResults(params.max)
        }
        List<Program> publicStudyList = [];
        publicIds.each {
            publicStudyList.add(Program.get(it))
        }

        return render(view: 'mobileCourse', model: [publicStudyList: publicStudyList, programCategoryList: programCategoryList])
    }

    def mobileAjaxCourse = {
        if (!params.max) params.max = 10
        List<ProgramCategory> programCategoryList = ProgramCategory.createCriteria().list() {
            eq('mediaType', 5)
            notEqual('name', "开放课程")
        }
        def publicIds = Program.withCriteria {
            eq("state", Program.PUBLIC_STATE)
            eq("otherOption", Program.ONLY_LESSION_OPTION)
            projections {
                distinct('id')
            }
            if (params.max instanceof String)
                maxResults(Integer.parseInt(params.max))
            else
                maxResults(params.max)
        }
        List<Program> publicStudyList = [];
        publicIds.each {
            publicStudyList.add(Program.get(it))
        }
        def result = [:];
        def appendDiv = "";
        for (int i = 0; i < publicStudyList.size(); i++) {
            Program program = publicStudyList.get(i);
            def hrefUrl = "${createLink(action: 'mobileCourse', params: [id: program?.id])}";
            def imgUrl = "${posterLinkNew(program: program, size: '95x95')}";
            def name = "${CTools.cutString(program?.name, 15)}";
            def studyTotal = "${studyCourse(playedPrograms: program?.playedPrograms)}";
            appendDiv += "<div class='boful_coures_item'><div class='boful_coures_item_img'>" +
                    "<a href='" + hrefUrl + "' title='" + program.name + "'>" +
                    "<img src='" + imgUrl + "' height='193'" +
                    "onerror='this.src ='${resource(dir: 'skin/blue/mobile/images', file: 'boful_mobile_recommend_item_img.jpg')}''/></a>" +
                    "</div><div class='boful_coures_item_infors'><h4>" + name + "</h4>" +
                    "<p class='boful_coures_item_author'><span>讲师：</span><span>" + program.actor + "</span></p>" +
                    "<p class='boful_coures_item_number'><span>" + studyTotal + "人在学习</span></p>" +
                    "</div><div class='boful_coures_item_play'>" +
                    "<a class='boful_coures_item_play_icon' href='" + hrefUrl + "' title='" + name + "'>去学习</a>" +
                    "</div></div>";
        }
        result.appendDiv = appendDiv;
        result.studyCount = publicStudyList.size();
        return render(result as JSON)
    }


    def mobileCourseList = {
        def programId = params.id;
        Program program;
        List<Serial> videoSerial = [];
        List<Serial> otherSerial = [];
        if (programId) {
            program = Program.get(programId);
            videoSerial = Serial.findAllByProgramAndUrlTypeAndState(program, Serial.URL_TYPE_VIDEO, Serial.CODED_STATE);
            otherSerial = Serial.findAllByProgramAndUrlTypeNotEqualAndState(program, Serial.URL_TYPE_VIDEO, Serial.CODED_STATE);
        }
        return render(view: 'mobileCourseList', model: [program: program, videoSerial: videoSerial, otherSerial: otherSerial])
    }


}