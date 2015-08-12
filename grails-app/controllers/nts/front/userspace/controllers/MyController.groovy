package nts.front.userspace.controllers

import com.boful.common.file.utils.FileType
import com.boful.common.file.utils.FileUtils
import grails.converters.JSON
import nts.activity.domain.UserActivity
import nts.commity.domain.ForumBoard
import nts.commity.domain.ForumMember
import nts.commity.domain.StudyCommunity
import nts.meta.domain.MetaDefine
import nts.note.domain.NoteRecommend
import nts.note.domain.ProgramNote
import nts.program.category.domain.CategoryFacted
import nts.program.category.domain.FactedValue
import nts.program.domain.CollectedProgram
import nts.program.domain.CourseQuestion
import nts.program.domain.DownloadedProgram
import nts.program.domain.PlayedProgram
import nts.program.domain.Program
import nts.program.category.domain.ProgramCategory
import nts.program.domain.ProgramTag
import nts.program.domain.RecommendedProgram
import nts.program.domain.Serial
import nts.program.domain.ViewedProgram
import nts.system.domain.Directory
import nts.system.domain.Message
import nts.system.domain.RMSCategory
import nts.user.domain.College
import nts.user.domain.Consumer
import nts.user.domain.UserGroup
import nts.user.file.domain.UserCategory
import nts.user.file.domain.UserFile
import nts.user.services.ActionNameAnnotation
import nts.user.special.domain.SpecialFile
import nts.user.special.domain.UserSpecial
import nts.utils.CTools
import org.codehaus.groovy.grails.web.util.WebUtils
import org.springframework.web.multipart.commons.CommonsMultipartFile

import javax.servlet.http.Cookie
import java.text.SimpleDateFormat

class MyController {

    //static layout = "index"

//定义一个Spring自动注入的一个数据连接对像
    def dataSource
    def programService
    def communityService
    def userService;
    def systemConfigService
    def userActivityService
    def programMgrService
    def index = {
        //获得我的用户组
        Consumer consumer = Consumer.get(session.consumer.id);
        if (consumer) {
            def userGroup = consumer.userGroups;
            //找到该用户的所有PlayedProgram，对program分组，找到所有program
            List programIdList = PlayedProgram.executeQuery("select program.id from PlayedProgram where consumer.id=:consumerId group by program.id order by playDate desc", [consumerId: consumer.id]);
            List<PlayedProgram> videoPrograms = [];
            List<PlayedProgram> docPrograms = [];
            for (def programId : programIdList) {
                try {
                    if (programId) {
                        //在PlayedProgram，找到所有某个program的所有播放记录，按照播放时间，降序排序
                        List playedProgramList = PlayedProgram.executeQuery("from PlayedProgram where program.id=:programId order by playDate desc", [programId: programId]);
                        PlayedProgram playedProgram = null;
                        if (playedProgramList && playedProgramList.size() > 0) {
                            //因为是播放时间降序排序，所以第一个就是最后一次播放
                            playedProgram = playedProgramList[0];
                        }
                        //播放记录材质，且播放的program是公开的，  避免后期，后台更改资源状态后，前台还会显示
                        if (playedProgram && playedProgram.program && playedProgram.serial && playedProgram.program.state == Program.PUBLIC_STATE) {
                            //资源分类，文档还是视频
                            if (playedProgram.serial.urlType == Serial.URL_TYPE_VIDEO) {
                                videoPrograms.add(playedProgram);
                            } else if (playedProgram.serial.urlType == Serial.URL_TYPE_DOCUMENT) {
                                docPrograms.add(playedProgram);
                            }
                        }
                    }
                } catch (Exception e) {
                    continue;
                }
            }
            Set<StudyCommunity> communities = consumer.memberCommunitys;
            return render(view: 'index', model: [userGroup: userGroup, videoPrograms: videoPrograms, docPrograms: docPrograms, communitites: communities])
        }
    }

    def my = {
        myInfo()
        redirect(action: myInfo)
    }

    def myIndex = {}

    //--根据Session 中的用户ID，获得用户相关信息
    def getUser = {
        def consumer = Consumer.get(session.consumer.id)
        return consumer
    }
    //---新增  myGroupSelectPage
    def groupSelectPage = {
        [collegeList: College.list()]
    }

    //---2009-8-26调用getUser方法取得用户信息，及相关统计信息
    def myInfo = {
        //获得用户个人信息
        def consumer = getUser()
        //获得用户浏览资源次数
        def viewCount = ViewedProgram.createCriteria().count() {
            eq('consumer', session.consumer)
            //---去掉重复记录 查询方式由count 改为 get
            /*
            projections {
              countDistinct "program"
            }
            */
        }
        //获得用户点播节目次数
        def playCount = PlayedProgram.createCriteria().count() {
            eq('consumer', session.consumer)
        }
        //获得用户下载节目次数
        def downloadCount = DownloadedProgram.createCriteria().count() {
            eq('consumer', session.consumer)
        }
        //获得用户收藏节目数量
        def collectCount = CollectedProgram.createCriteria().count() {
            eq('consumer', session.consumer)
        }

        //获得用户订阅节目数量
        def idList
        def subCount = 0
        //将该用户所订阅的标签附值给tagList
        def tagList = consumer.programTags.id
        if (tagList.size > 0) {
            //查询出用户所订阅的节目ID，并删除重复记录
            idList = Program.createCriteria().list() {
                //利用投影查询删除重复记录
                projections {
                    distinct('id')
                }
                //根据用户所订阅的标签进行关系查询
                programTags {
                    'in'('id', tagList)
                }
                //发布状态为审核的节目
                eq('state', Program.PUBLIC_STATE)
            }
            //通过节目ID查询出节日信息

            if (idList.size > 0) {
                subCount = Program.createCriteria().count() {
                    'in'('id', idList)
                }
            }
        }
        request.singleFlag = 1 //个人空间左侧菜单标记 1-个人资料
        return [consumer: consumer, viewCount: viewCount, playCount: playCount, downloadCount: downloadCount, collectCount: collectCount, subCount: subCount]
    }

    def myPassword = {
        def consumer = getUser()
        request.singleFlag = 1 //个人空间左侧菜单标记 1-个人资料
        return render(view: 'myPassword', model: [consumer: consumer]);
    }

    ////////////////////////浏览点播开始
    //我制作的
    def myProgram = {
        if (!params.max) params.max = 5
        params.sort = 'id'
        params.order = 'desc'
        def state = CTools.nullToOne(params.state)            //0未审批 1已审批

        def programList = Program.createCriteria().list(max: params.max, offset: params.offset) {
            (state == 1) ? ge("state", Program.PUBLIC_STATE) : lt("state", Program.PUBLIC_STATE)
        }

        return [programList: programList, total: programList?.totalCount]
    }

    def myHistory = {
        def typeNameList = ["收藏", "点播", "浏览"]
        def domainList = [CollectedProgram, PlayedProgram, ViewedProgram, Program]
        if (!params.type) params.type = '0'        //默认是收藏过的
        def type = params.type.toInteger()
        if (!params.max) params.max = 5
        params.sort = "id"
        params.order = "desc"

        //现分页查2次 能否有更好方法
        def programList = domainList[type].findAllByConsumer(session.consumer, params)
        def total = domainList[type].countByConsumer(session.consumer, params)

        if (type != 3) programList = programList.program    //节目表没有program属性

        if (programList.size() < 1) flash.message = "尚未${typeNameList[type] + Program.cnTableName}"

        return [programList: programList, total: total]
    }

//---2009-5-5 新增
    def myEdit = {
        def consumer = Consumer.get(params.id)
        if (!consumer) {
            flash.message = "找不到用户信息"
            redirect(action: 'myInfo')
        } else {
            return [consumer: consumer]
        }
    }

//---2009-5-5新增  
    def myUpdate = {
        def result = [:];
        params.request=request
        params.modifyFrom = "user";
        def emailExp = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
        if (!params.email || !params.email.matches(emailExp)) {
            flash.message = "邮箱格式不正确！！！";
            redirect(action: 'myInfo');
        } else {
            result = userService.modify(params);
            if (result.noFindConsumer) {
                flash.message = "找不到用户信息";
                redirect(action: 'myInfo');
            } else {
                if (result.success == true) {
                    flash.message = "用户 ${result.consumer.name} 修改完成！";
                    redirect(action: 'myInfo');
                } else {
                    flash.message = "用户 ${result.consumer.name} 修改失败！";
                    redirect(action: 'myInfo');
                }
            }
        }
    }

    //修改密码
    def updatePassword = {
        def result = [:];
        result = userService.modifyUserPassword(params);
        if (result.success == true) {
            flash.message = "用户 ${result.consumer.name} 修改完成！"
        } else {
            flash.message = "用户 ${result.consumer.name} 修改失败！"
        }
        redirect(action: 'myInfo')
    }
    /**
     * 修改密码时验证原密码
     */
    def verifyPassword = {
        def result = [:];
        result.success = false;
        def oldPassWord = params.oldPassWord;
        if (oldPassWord) {
            Consumer consumer = session.consumer;
            if (consumer.password.equals(oldPassWord.encodeAsPassword())) {
                result.success = true;
            }
        }
        return render(result as JSON);
    }

//---2009-5-5 新增 myGroup 闭包 用来查看有上传权限的用户所创建的用户组

    def myGroupList = {
        //def consumer = nts.user.domain.Consumer.get(session.consumer.id)
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        //  [ userGroupList: nts.user.domain.UserGroup.list( params )]

        def _max = params.max.toInteger()
        def _offset = params.offset.toInteger()

        def total = UserGroup.countByConsumer(session.consumer.id)

        int pageCount = Math.round(Math.ceil(total / _max))
        int pageNow = (_offset / _max) + 1

        [userGroupList: UserGroup.findAllByConsumer(session.consumer.id, params), total: total, pageCount: pageCount, pageNow: pageNow]


    }
//---2009-5-5 新增 myGroupCreate 

    def myGroupCreate = {
        def userGroup = new UserGroup()
        userGroup.properties = params
        return ['userGroup': userGroup]
    }

//---2009-5-20 新增或修改错误时，返回页面调用 
    def errorBack(userGroup) {
        def consumer = Consumer.get(session.consumer.id)
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        def _max = params.max.toInteger()
        def _offset = params.offset.toInteger()

        def total = UserGroup.countByCreator(session.consumer)
        int pageCount = Math.round(Math.ceil(total / _max))
        int pageNow = (_offset / _max) + 1

        def userGroupList = UserGroup.findAllByCreator(session.consumer, params)
        render(view: 'myGroupList', model: [userGroup: userGroup, userGroupList: userGroupList, total: total, pageCount: pageCount, pageNow: pageNow])
    }

//---2009-5-6 新增 myGroupSave  闭包，保存组信息   

    def myGroupSave = {

        def haveGroup = UserGroup.findByNameAndConsumer(params.name, session.consumer.id)
        if (haveGroup) {
            flash.message = "该组名称已经使用过，请重新输入组名 "
            redirect(action: myGroupList, params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
        } else {
            def userGroup = new UserGroup(params)
            userGroup.active = 1
            userGroup.dateCreated = new Date()
            userGroup.dateModified = new Date()
            userGroup.creator = session.consumer.nickname
            userGroup.consumer = session.consumer.id

            if (!userGroup.hasErrors() && userGroup.save()) {
                flash.message = "${params.name}创建成功"
                redirect(action: myGroupList, params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
            } else {
                errorBack(userGroup)                // 调用errorBack方法，做错 误返回
            }
        }
    }
//---2009-5-6 新增 myGroupEdit 闭包 
    def myGroupEdit = {
        def userGroup = UserGroup.get(params.id)
        if (!userGroup) {
            flash.message = "找不到该组信息"
            redirect(action: myGroupList)
        } else {
            return [userGroup: userGroup]
        }
    }
//---2009-5-6 新增 myGroupUpdate 闭包，修改个人空间中组信息 

    def myGroupUpdate = {
        def userGroup = UserGroup.get(params.updateId)

        if (userGroup) {
            userGroup.name = params.updateName
            userGroup.description = params.updateDescription

            if (!userGroup.hasErrors() && userGroup.save()) {
                flash.message = "${userGroup.name} 修改完成"
                redirect(action: myGroupList, params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
            } else {
                flash.message = " ${userGroup.name} 修改失败，该组名已被使用！"
                redirect(action: myGroupList, params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
            }
        } else {
            flash.message = "无法找到 ${userGroup.name} "
            redirect(action: myGroupList, params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])
        }
    }

//---2009-5-6 新增 myGroupDelete 闭包，删除组信息 

    def myGroupDelete = {
        def userGroup = UserGroup.get(params.id)
        if (userGroup) {

            //删除用户组与用户间所建立的关系
            userGroup.consumers.toList().each {
                it.removeFromUserGroups(userGroup)
            }

            //删除用户组与节目播放权限间的关系
            userGroup.playPrograms.toList().each {
                it.removeFromPlayGroups(userGroup)
            }

            //删除用户组与节目下载权限间的关系
            userGroup.downloadPrograms.toList().each {
                it.removeFromDownloadGroups(userGroup)
            }

            userGroup.delete(flush: true)

            flash.message = " ${userGroup.name} 删除！"
        } else {
            flash.message = " 不找到 ${userGroup.name}"
        }
        redirect(action: myGroupList, params: [offset: params.offset, max: params.max, sort: params.sort, order: params.order])

    }

//---2009-5-6 新增myGroupDeleteList 闭包，删除列表中选中组信息
    def myGroupDeleteList = {

        def delIdList = params.idList

        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            def group = UserGroup.get(id)
            if (group) {
                group.creator = null
                group.delete(flush: true)
            }
        }

        redirect(action: myGroupList, params: [offset: params.offset, sort: params.sort, order: params.order])
    }
//---2009-5-6 新增 myGroupConsumerList 闭包，查看组员信息
    def myGroupConsumerList = {

        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def _max = params.max.toInteger()
        def _offset = params.offset.toInteger()

        def userGroup = UserGroup.get(params.groupId)
        def userGroupName
        def userGroupConsumerList = Consumer.createCriteria().list(max: params.max, offset: params.offset) {
            userGroups {
                if (params.groupId) {
                    userGroupName = userGroup.name
                    eq('id', params.groupId.toLong())
                } else {
                    userGroupName = "--选择组--";
                    eq('id', 0.toLong())
                }
            }
        }

        def total = userGroupConsumerList.totalCount
        int pageCount = Math.round(Math.ceil(total / _max))
        int pageNow = (_offset / _max) + 1
        def userGroupList = UserGroup.findAllByConsumer(session.consumer.id)
        [userGroupConsumerList: userGroupConsumerList, userGroupList: userGroupList, total: total, groupId: params.groupId, groupName: userGroupName, pageCount: pageCount, pageNow: pageNow]
    }

//---2009-5-7 新增 myGroupDeleteConsumer 闭包，删除列表中的组员
    def myGroupDeleteConsumer = {

        def delIdList = params.idList
        def page = params.page
        def group = UserGroup.get(params.id)

        if (delIdList instanceof String) delIdList = [params.idList]

        delIdList?.each { id ->
            def consumer = Consumer.get(id)
            group.removeFromConsumers(consumer)                        //删除与userGroup对像的关系
        }

        redirect(action: myGroupConsumerList, params: [offset: page, id: params.id])

    }
//--- 2009-05-21 新增 myGroupDeleteConsumerOne  闭包 ，删除单个组员与组的关系

    def myGroupDeleteConsumerOne = {
        def group = UserGroup.get(params.groupId)
        def consumer = Consumer.get(params.id)
        consumer.removeFromUserGroups(group)
        redirect(action: myGroupConsumerList, params: [offset: params.offset, max: params.max, groupId: params.groupId])
    }

//---2009-5-7 新增myGroupAddConsumer 闭包，向组中添加成员
    def myGroupAddConsumer = {

        def delIdList = params.idList
        def page = params.page
        //	println '--------------------------------------'+params.offset

        def group = UserGroup.get(params.groupId)
        if (delIdList instanceof String) delIdList = [params.idList]

        delIdList?.each { id ->
            def consumer = Consumer.get(id)
            group.addToConsumers(consumer)                        //删除与userGroup对像的关系
        }
        if (page == "") {        //判断书页是否是第一页，如果是第一页无法传page值
            page = "0"
        }
        redirect(action: myGroupConsumerList, params: [offset: page, groupId: params.groupId])
    }

//---2009-5-21 新增 myGroupAddConsumerOne 闭包，向所选择的组中添加新单个用户
    def myGroupAddConsumerOne = {

        def group = UserGroup.get(params.groupId)
        def consumer = Consumer.findByName(params.consumerId)

        if (consumer) {
            group.addToConsumers(consumer)
        } else {
            flash.message = " 没有该用户"
        }
        redirect(action: myGroupConsumerList, params: [offset: params.offset, max: params.max, groupId: params.groupId])
    }

//---2009-5-7 新增 myGroupSelectPage   查询用户选择页面
    def myGroupSelectPage = {
        [collegeList: College.list()]
    }

    //---2009-6-15 新增applyTable方法 获得用户信息
    def applyTable = {
        def consumer = getUser()
        return [consumer: consumer, collegeList: College.list()]
    }
    //---2009-6-15 用户提交上传请求
    def apply = {
        def consumer = Consumer.get(session.consumer.id)
        if (consumer) {
            consumer.properties = params
            consumer.uploadState = 2
            consumer.college = College.get(params.applyCollege)
            if (params.nickname) {
                UserGroup.executeUpdate("update nts.user.domain.UserGroup c set creator='${params.nickname}'  where c.consumer=${consumer.id}  ")
            }

            if (!consumer.hasErrors() && consumer.save()) {
                flash.message = "申请成功，请等待管理员审核！"
                redirect(action: applyTable)
            } else {
                render(view: 'applyTable', model: [consumer: consumer])
            }
        } else {
            flash.message = "没有该用户"
            redirect(action: applyTable)
        }
    }

    //-------------------------------------------2009-06-17-------------------------------------//
    //--------------------------------------以下是标签操作----------------------------------//
    //-----------------------------------------------------------------------------------------------//
    //---2009-6-17 新增 myProTagList 查询用户所订阅的标签及相关内容
    def myProgramList = {
        //---2009-6-18 调用myTagProgramList  获得用户所订阅的节目
        def programList = myTagProgramList()
        def total
        def hotTagList = getHotTag()
        if (!programList) {
            total = 0
        } else {
            total = programList.totalCount
        }
        request.singleFlag = 3 //个人空间左侧菜单标记 3-资源管理
        [programList: programList, hotTagList: hotTagList, total: total]
    }

    //---2009-6-18新增 myTagList  获得该用户订阅的标签
    def myTagList = {
        def consumer = Consumer.get(session.consumer.id)            //通过session 获得用户对像
        def myTagList = consumer.programTags
        def hotTagList = getHotTag()
        request.singleFlag = 3 //个人空间左侧菜单标记 3-资源管理
        return [myTagList: myTagList, hotTagList: hotTagList]
    }

    //---2009-6-17 新增 myTagAdd 添加标签
    def myTagAdd(tagName) {
        def programTag = new ProgramTag()
        programTag.name = tagName
        programTag.frequency = 0
        programTag.dateCreated = new Date()
        programTag.dateModified = new Date()
        if (!programTag.hasErrors() && programTag.save()) {
            flash.message = "nts.program.domain.ProgramTag ${programTag.name} created"
            //  redirect(action:myProTagList)
        } else {
            //  render(view:'myProTagList',model:[programTag:programTag])
        }
        return programTag
    }

    //---2009-6-17 新增 subScriptionTag  用户手写输入订阅标签
    def subScriptionTag = {
        def nameList = params.nameList
        def programTag                                        //记录标签是否在标签表中存在
        def consumer = Consumer.get(session.consumer.id)            //通过session 获得用户对像

        if (nameList instanceof String) nameList = [params.nameList]

        nameList?.each { name ->
            if (name) {
                programTag = ProgramTag.findByName(name)
                if (!programTag) {
                    //如果验证该标签在数据库中不存在，调用myTagAdd 方法创建对像，并返回所创建的对像
                    programTag = myTagAdd(name)
                    //创建用户与标签的关系
                    consumer.addToProgramTags(programTag)
                } else {
                    //如果数据库中存在该标签对像，则直接创建用户与标签的关系
                    consumer.addToProgramTags(programTag)
                }
            }
        }
        //显示列表
        redirect(action: myTagList)
    }

    ///---2009-6-18新增 myTagProgramList 获得用户订阅的节目
    def myTagProgramList = {
        def consumer = Consumer.get(session.consumer.id)            //通过session 获得用户对像
        def idList
        def ProgramList
        //将该用户所订阅的标签附值给tagList
        def tagList = consumer.programTags.id
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (tagList.size > 0) {
            //查询出用户所订阅的节目ID，并删除重复记录
            idList = Program.createCriteria().list() {
                //利用投影查询删除重复记录
                projections {
                    distinct('id')
                }
                //根据用户所订阅的标签进行关系查询
                programTags {
                    'in'('id', tagList)
                }
                //发布状态为审核的节目
                eq('state', Program.PUBLIC_STATE)
            }
            //通过节目ID查询出节日信息

            if (idList.size > 0) {
                ProgramList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                    'in'('id', idList)
                }
            }

        }

        return ProgramList
    }
    //---2009-6-19 新增 getHotTag  用来获得热门标签

    def getHotTag = {

        def hotTagList = ProgramTag.listOrderByFrequency(max: 20, order: "desc")
        return hotTagList

    }

    //---2009-6-19 新增 addHotTag 用户添加热闹标签
    def addHotTag = {
        def consumer = Consumer.get(session.consumer.id)            //通过session 获得用户对像
        def programTag = ProgramTag.get(params.id)
        programTag.frequency = programTag.frequency + 1
        consumer.addToProgramTags(programTag)
        redirect(action: myTagList)

    }
    //---2009-6-19 新增  deleteTagList 用户删除用户订阅的标签列表
    def deleteTagList = {
        def delIdList = params.idList;
        def program
        def programTag
        def consumer = Consumer.get(session.consumer.id)

        if (delIdList instanceof String) delIdList = [params.idList]

        delIdList?.each { id ->

            programTag = ProgramTag.get(id as int)
            program = programTag.programs
            program?.each { pro ->
                programTag.removeFromPrograms(pro)
                pro.removeFromProgramTags(programTag)
            }
            //删除与consumer与programTag对像的关系
            consumer.removeFromProgramTags(programTag)

        }
        redirect(action: "myTagList")
    }
    //---2009-6-19 新增 deleteTag 删除用户订阅的标签
    def deleteTag = {
        def consumer = Consumer.get(session.consumer.id)
        def programTag = ProgramTag.get(params.id)
        if (programTag) {
            consumer.removeFromProgramTags(programTag)
        }
        redirect(action: myTagList)
    }

    //---2009-8-21 新增 myRecommendProgramList  个人空间，我的推荐列表
    @ActionNameAnnotation(name="我的推荐")
    def myRecommendProgramList() {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        def begin_date = null;
        def end_date = null;



        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        def programList
        def total

        def searchName = params.searchName
        //def searchActor = params.searchActor
        def searchConsumer = params.searchConsumer
        def searchDate = params.searchDate

        def dateBegin = params.dateBegin                    //创建开始时间
        def dateEnd = params.dateEnd                    //创建结束时间

        if (searchDate)                            //用户判断用使用的是哪一种时间段查询方式
        {
            dateBegin = params.searchDate + ' 00:00:01'
            dateEnd = params.searchDate + ' 23:59:59'

            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        }

        programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {

            if (searchName) {
                like('name', "%${searchName}%")
            }
            //if (searchActor) {
            //    like('actor', "%${searchActor}%")
            //}
            if (searchConsumer) {
                //关联类查询，查询条件为用户表中的帐号
                consumer
                        {
                            like('name', "%${searchConsumer}%")
                        }

            }
            if (searchDate) {
                between("datePassed", begin_date, end_date)
            }

            recommendedPrograms
                    {
                        eq('consumer', session.consumer)
                    }

        }
        total = programList.totalCount
        request.singleFlag = 3 //个人空间左侧菜单标记 3-资源管理
        [programList: programList, total: total]
    }
    //---2009-10-15 新增 delRecommend包闭，用来删除推荐节目
    def delRecommend = {
        def result = [:];
        def idList = params.idList;
        List<Long> ids = new ArrayList<Long>();
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(Long.parseLong(it));
                }
            } else {
                ids.add(Long.parseLong(idList))
            }
        }
        ids?.each {
            def recommend = RecommendedProgram.get(it)
            if (recommend) {
                if (recommend.consumer.id == session.consumer.id) {
                    def program = Program.get(recommend.program.id)
                    program.recommendNum -= 1
                    program.save(flush: true)

                    recommend.delete()
                }

                flash.message = "取消节目${recommend.program.name}推荐 "
            }
        }

        redirect(action: 'myRecommendProgramList', params: params)
    }

    //---2009-8-21 myHistoryProgramList 个人空间 ，我的历史记录
    @ActionNameAnnotation(name="我的课程")
    def myHistoryProgramList(){

        if (!params.max) params.max = 15
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.listType) params.listType = 'play'
        def listType = params.listType
        List<PlayedProgram> historyProgramList = [];
        List<CollectedProgram> historyCollected = [];
        List<CollectedProgram> historyCollected2 = [];//收藏课程
        List<PlayedProgram> unFinishedProgramList = [];//未完成课程
        List<PlayedProgram> finishedProgramList = [];//已完成课程
        List<PlayedProgram> unFinishedProgramList2 = [];//未完成课程
        List<PlayedProgram> finishedProgramList2 = [];//已完成课程
        def idList;
        def total
        def timeTitle

        if (!params.flag) params.flag = 1
        def flag = params.flag as int

        List<Program> programList = Program.findAllByOtherOptionAndState(Program.ONLY_LESSION_OPTION, Program.PUBLIC_STATE);
        if (listType == 'view') {
            timeTitle = '浏览时间'
            historyProgramList = ViewedProgram.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                eq('consumer', session.consumer)
                //	firstResult(params.offset.toInteger())
                //	maxResults(params.max)
            }
        }
        if (listType == 'play') {

            timeTitle = '点播时间'
            idList = PlayedProgram.withCriteria {
                eq('consumer', session.consumer)
                if (programList.size() > 0) {
                    inList("program", programList)
                }
                projections {
                    distinct("program")
                }
                order("playDate", "desc")
            }
            idList.each {Program program ->
                //找到该program下的所有PlayedProgram,依据playDate排序，选择第一个
                List playedProgramList = PlayedProgram.executeQuery("from PlayedProgram where program.id=:programId order by playDate desc", [programId: program.id]);
                if (playedProgramList.size()>0) {
                    historyProgramList.add(playedProgramList[0]);
                }
            }
            historyProgramList.each {
                def serials = it?.program?.serials;
                if(serials) {
                    def list = serials.findAll{serial ->
                        return serial.urlType == Serial.URL_TYPE_VIDEO;
                    }
                    if(list) {
                        it?.program?.serials = list;
                    }
                } else {
                    it?.program?.serials = null;
                }
            }
            historyProgramList.each {PlayedProgram play ->
                if (PlayedProgram.findAllByProgramAndConsumer(play?.program, session?.consumer)?.size() < Serial.findAllByProgram(play?.program)?.size()) {
                    unFinishedProgramList.add(play)
                } else if (PlayedProgram.findAllByProgramAndConsumer(play?.program, session?.consumer)?.size() == Serial.findAllByProgram(play?.program)?.size()) {
                    finishedProgramList.add(play)
                }
            }

            idList = CollectedProgram.withCriteria {
                eq('consumer', session.consumer)
                if (programList.size() > 0) {
                    inList("program", programList)
                }
                projections {
                    distinct("program")
                }
            }
            idList.each { Program program ->
                historyCollected.add(CollectedProgram.findByProgram(program));
            }

            if (flag == 1) {
                total = unFinishedProgramList.size()
//                int start = (params.offset as int) * (params.max as int);
                int start = (params.offset as int);
                int end = (start + (params.max as int)) > total ? total : (start + (params.max as int))
                for (start; start < end; start++) {
                    unFinishedProgramList2.add(unFinishedProgramList.get(start))
                }
            } else if (flag == 2) {
                total = finishedProgramList.size()
                int start = (params.offset as int);
                int end = (start + (params.max as int)) > total ? total : (start + (params.max as int))
                for (start; start < end; start++) {
                    finishedProgramList2.add(finishedProgramList.get(start))
                }
            } else if (flag == 3) {
                total = historyCollected.size()
                int start = (params.offset as int);
                int end = (start + (params.max as int)) > total ? total : (start + (params.max as int))
                for (start; start < end; start++) {
                    historyCollected2.add(historyCollected.get(start))
                }
            }


        }
        if (listType == 'down') {
            timeTitle = '下载时间'

           /* historyProgramList = DownloadedProgram.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                eq('consumer', session.consumer)

            }*/
        }

        return render(view: 'myHistoryProgramList', model: [flag: flag, historyCollected: historyCollected2, historyProgramList: historyProgramList, unfinishedProgramList: unFinishedProgramList2, finishedProgramList: finishedProgramList2, timeTitle: timeTitle, total: total]);

    }
    //删除历史资源记录   注：该方法不可用，会直接删除program
    /* def deleteHistoryProgram() {
         if (params.id) {
             Program program = Program.get(params.id as Long);
             def playedProgram = PlayedProgram.findByProgramAndConsumer(program, session.consumer);
             if (playedProgram) {
                 program.removeFromPlayedPrograms(playedProgram);
                 playedProgram.deleteAll(program);
             }
         }
         return redirect(action: 'myHistoryProgramList');
     }*/
    //活动管理
    @ActionNameAnnotation(name = "我的活动")
    def myUserActivityManager() {
        params.id = session.consumer.id;
        def userActivityList = userActivityService.searchMyUserActivity(params, params.id as long);
        def total = userActivityList.totalCount

        return render(view: 'myUserActivityManager', model: [userActivityList: userActivityList, total: total, params: params])
    }

    def myUserWorkList() {
        def userWorkList = userActivityService.searchMyUserWork(params);
        def total = userWorkList.totalCount

        return render(view: 'myUserWorkList', model: [userWorkList: userWorkList, total: total, params: params])
    }
    def editUserActivity = {
        def userActivity = UserActivity.get(params.id)
        if (!userActivity) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity'), params.id])}"
            redirect(action: "myUserActivityManager")
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
    //修改活动
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
            def photo = uploadImg('update')
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
    //批量删除活动
    def deleteUserActivityList = {
        def delIdList = params.idList

        List<Long> ids = new ArrayList<Long>();
        if (delIdList instanceof String) {
            if (delIdList.contains(',')) {
                String[] str = delIdList.split(',');
                str.each {
                    ids.add(Long.parseLong(it));
                }
            } else {
                ids.add(Long.parseLong(delIdList))
            }
        }

        ids?.each { id ->
            def userActivity = UserActivity.get(id)
            if (userActivity) {
                try {
                    userActivity.delete(flush: true)
                    flash.message = "删除完成"
                }
                catch (org.springframework.dao.DataIntegrityViolationException e) {
                    flash.message = "删除失败"
                }
            }
        }
        redirect(action: "myUserActivityManager", params: params)
    }
    def deleteUserActivity = {
        def userActivity = UserActivity.get(params.id)
        if (userActivity) {
            try {
                userActivity.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity'), params.id])}"
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity'), params.id])}"
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity'), params.id])}"
        }
        if (params.toPage) redirect(action: params.toPage)

    }

    def communityList = {
        //取得最大显示页面，并转换为整型
        //取得页面偏移量，并转换为整型
        def communityList = searchCommunity()
        def nameList = []
        communityList?.each { community ->
            def consumer = Consumer.get(community.create_comsumer_id)
            nameList.add(consumer.name)
        }

        def total = communityList.totalCount;

        def _max = params.max.toInteger()
        def _offset = params.offset.toInteger()
        int pageCount = Math.round(Math.ceil(total / _max))
        int pageNow = (_offset / _max) + 1

        //加入的社区
        def communitys;
        List<StudyCommunity> joinCommunity = StudyCommunity.createCriteria().list() {
            if (session.consumer) {
                notEqual("create_comsumer_id", session.consumer.id as int)
                members {
                    eq("id", session.consumer.id)
                }
            }
        }

        return render(view: 'communityList', model: [joinCommunity: joinCommunity, communityList: communityList, nameList: nameList, total: total, pageCount: pageCount, pageNow: pageNow])

    }

    def removeConsumer() {
        def result = [:];
        if (params.id) {
            StudyCommunity studyCommunity = StudyCommunity.get(params.id as Long);
            if (studyCommunity) {
                Consumer consumer = Consumer.get(session.consumer.id as Long);
                if (consumer) {
                    def formMembers = ForumMember.findAllByConsumerAndStudyCommunity(consumer, studyCommunity)
                    formMembers?.each {
                        it.delete()
                    }
                    result.success = true;
                    result.msg = "退出社区" + studyCommunity?.name + "成功!";
                } else {
                    result.success = false;
                    result.msg = "退出社区" + studyCommunity?.name + "失败!";
                }
            }
        }
        return render(result as JSON)
    }
    /**
     * 退出小组
     */
    def leaveForum() {
        def result = [:];
        result.success = false;
        def forumMember = params.forumMemberId ? ForumMember.get(params.forumMemberId as long) : null;
        if (forumMember) {
            forumMember.state = ForumMember.STATE_QUIT;
            if (!forumMember.hasErrors() && forumMember.save()) {
                result.success = true;
            }
        }
        return render(result as JSON);
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

        redirect(action: 'myCreatedCommunity', params: params)
    }
    //删除学习社区
    def deleteCommunity1 = {

        def communityInstance = StudyCommunity.get(params.delId)

        if (communityInstance) {
            try {
                def forumBoards = communityInstance.forumBoards
                forumBoards?.each { forumBoard ->
                    deleteForumBoard(forumBoard.id)
                }
                communityInstance.delete(flush: true)
                flash.message = "学习社区删除完成";

            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "nts.commity.domain.StudyCommunity ${params.delId} could not be deleted"
                redirect(action: 'communityList', params: params)
            }
        } else {
            flash.message = "找不到该主题"
        }
        redirect(action: 'myCreatedCommunity', params: params)
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
        //redirect(action: "communityList", params: params)
        redirect(action: "myCreatedCommunity", params: params)
    }
    //---2009-8-24 myCollectProgramList 个人空间，我的收藏列表
    @ActionNameAnnotation(name="我的收藏")
    def myCollectProgramList(){

        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'

        def tag = params.tag
        def collectProgramList
        def total = 0
        //要查询说总数用于分页
        def totalList = null;
        if (tag) {
            //字符集为UTF8时，进行中文字符集转码
            //tag = new String(tag.getBytes("iso-8859-1"), "UTF-8");
            collectProgramList = CollectedProgram.executeQuery("from CollectedProgram where consumer.id = :consumerId and tag=:tag and program.state=:state and program.otherOption !=:otherOption order by ${params.sort} ${params.order}", [consumerId: session.consumer.id, tag: tag, state: Program.PUBLIC_STATE, otherOption: Program.ONLY_LESSION_OPTION], [max: params.max, offset: params.offset]);
            totalList = CollectedProgram.executeQuery("select count(id) from CollectedProgram where consumer.id = :consumerId and tag=:tag and program.state=:state and program.otherOption !=:otherOption");
        } else {
            collectProgramList = CollectedProgram.executeQuery("from CollectedProgram where consumer.id = :consumerId and program.state=:state and program.otherOption !=:otherOption order by ${params.sort} ${params.order}", [consumerId: session.consumer.id, state: Program.PUBLIC_STATE, otherOption: Program.ONLY_LESSION_OPTION], [max: params.max, offset: params.offset]);
            totalList = CollectedProgram.executeQuery("select count(id) from CollectedProgram where consumer.id = :consumerId and program.state=:state and program.otherOption !=:otherOption", [consumerId: session.consumer.id, state: Program.PUBLIC_STATE, otherOption: Program.ONLY_LESSION_OPTION]);
        }
        if (totalList && totalList.size() > 0) {
            total = totalList[0]
        }
        /*collectProgramList = CollectedProgram.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            eq('consumer', session.consumer)
            if (tag) {
                //字符集为UTF8时，进行中文字符集转码
                //tag = new String(tag.getBytes("iso-8859-1"), "UTF-8");
                eq('tag', tag)
            }
            notEqual("program",Program.findByOtherOption(Program.ONLY_LESSION_OPTION))
        }*/
//        total = collectProgramList.totalCount
        request.singleFlag = 3 //个人空间左侧菜单标记 3-资源管理
        [collectProgramList: collectProgramList, total: total, tag: tag]
    }
    //---2009-8-24 deleteCollectProgram 删除收藏的节日
    //这里以后需要用ajax异步实现
    def deleteCollectProgram = {
        def delIdList = params.idList
        def tag = params.tag
        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            //获得用户对像
            def collect = CollectedProgram.get(id)
            //判断 用户只可以删除自己所创建的收藏
            if (collect && collect.consumer.id == session.consumer.id) {
                collect.delete()
            } else {
                flash.message = "删除失败！！"
            }
        }
        if ("myHistoryProgramList".equals(params.fromUri)) {
            return redirect(action: 'myHistoryProgramList');
        } else {
            redirect(action: 'myCollectProgramList', params: params);
        }
    }

    //-------------------------------------------2009-06-17-------------------------------------//
    //--------------------------------------以上是标签操作-----------------------------------//
    //------------------------------------------------------------------------------------------------//

    /** ********************************************************************************************************/
    /********************************************以下是jlf添加主页闭包**************************************/
    /** ***********************************************************************************************************/

    //显示组，供浏览权限，点播权限的设置
    def showMyGroup = {
        def program = null
        def groupList = null
        def canAll = true
        def programId = CTools.nullToZero(params?.programId)
        def priType = CTools.nullToBlank(params?.priType)    //play是浏览权限 download是下载权限

        if (programId > 0) {
            program = Program.get(programId)
            //UserGroup中Consumer属性是一个Consumer整形id 不是Consumer对象
            groupList = UserGroup.findAllByConsumer(session.consumer.id)
            canAll = (priType == 'play' && program.canAllPlay) || (priType == 'download' && program.canAllDownload)
        } else
            flash.message = "programId < 0"

        render(template: 'groupList', model: [program: program, groupList: groupList, priType: priType, canAll: canAll])
    }

    //显示节目 供申请入库显示
    def showProg = {
        def program = null
        def programId = CTools.nullToZero(params?.programId)

        if (programId > 0) {
            program = Program.get(programId)
        } else {
            flash.message = "programId < 0"
        }

        render(template: 'applyToLib', model: [program: program])

    }

    //申请入库
    def applyToLib = {
        def program = null
        def programId = CTools.nullToZero(params?.programId)
        boolean canDownload = CTools.nullToOne(params?.canDownload) == 1    //1允许所有用户组 0允许指定用户组

        program = Program.get(programId)
        if (program) {
            //设置 允许是否允许下载	审批状态
            program.canDownload = canDownload
            program.state = Program.APPLY_STATE
        }
        render 'ok'//不能注释，须返回值
    }

    //即时编辑收藏标签
    def inPlaceEditorCollect = {
        def collectedProgram = CollectedProgram.get(params.id)
        if (collectedProgram) collectedProgram.tag = params.value

        render params.value
    }


    def bbsList = {
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'dateLastReply'
        if (!params.max) params.max = 10 //add by jlf
        params.order = 'desc'

        def total = 0
        def bbsTopicList = null

        total = BbsTopic.countByIsLocked(false)
        if (total > 0) bbsTopicList = BbsTopic.findAllByIsLocked(false, params)

        [bbsTopicList: bbsTopicList, total: total]
    }

    def createBbsTopic = {

    }

    def saveBbsTopic = {

    }

    //---------------社区管理-----------------------
    //我创建的社区
    def myCommunity = {
        def studyCommunityList = searchCommunity()
        def total = studyCommunityList.totalCount

        [studyCommunityList: studyCommunityList, total: total, params: params]
    }
    //我加入的社区
    def myJoinCommunity = {
        def studyCommunityList = searchCommunity()
        def total = studyCommunityList.totalCount

        [studyCommunityList: studyCommunityList, total: total, params: params]
    }
    //搜索社区
    def searchCommunity = {
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.wyName) {
            params.wyName = CTools.nullToBlank(params?.wyName) //搜索的学习圈名称
        }
        if (!params.communityType) params.communityType = 'my'

        def communityType = params.communityType
        def state = params.state
        def wyName = params.wyName
        def consumer = params.consumer
        def operType = ""

        def studyCommunityList = StudyCommunity.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (communityType == 'my') {
                eq('create_comsumer_id', session.consumer.id.toInteger())
            } else if (communityType == 'join') {
                members {
                    eq("id", CTools.nullToZero(session.consumer.id).longValue())
                }
            }
            if (wyName) {
                wyName = wyName.trim()
                like('name', "%${wyName}%")
            }
            if (state) {
                eq("state", state.toInteger())
            }
        }
        return studyCommunityList
    }
    //解散社区
    def dismissCommunity = {
        def studyCommunity = StudyCommunity.get(params.id)

        studyCommunity?.members?.each { member ->
            studyCommunity.removeFromMembers(member)
        }

        redirect(action: 'myCommunity', params: params)
    }
    //批量解散社区
    def dismissCommunityList = {
        def delIdList = params.idList
        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            def studyCommunity = StudyCommunity.get(id)
            if (studyCommunity?.members != null && studyCommunity.members != []) {
                studyCommunity.members?.each { member ->
                    studyCommunity.removeFromMembers(member)
                }
            }
        }
        redirect(action: 'myCommunity', params: params)
    }

    def createJoin = {
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
                    eq('id', CTools.nullToZero(session.consumer.id).longValue())
                }
            }
        }*/
        if (userActivityList == null) userActivityList = []
        //userActivityList.js.unique()

        def countList = UserActivity.executeQuery("select count(distinct a) from nts.activity.domain.UserActivity a join a.userWorks b where a.name like ? and b.consumer.id=? order by a.id desc", ["%" + name + "%", CTools.nullToZero(session.consumer.id).longValue()], [max: params.max, offset: params.offset]);
        total = countList[0]
        [userActivityList: userActivityList, total: total, params: params]
    }

    //编辑社区
    def editCommunity = {
        def studyCommunityInstance = StudyCommunity.get(params.id)
        def rmsCategoryList1 = RMSCategory.findAllByParentid(0, [sort: "id", order: "desc"])                //一级类别
        def rmsCategoryList2 = RMSCategory.findAllByParentid(studyCommunityInstance.communityCategory.parentid, [sort: "id", order: "desc"])

        if (params.editType != null & params.editType != "") {
            render(view: params.editType, model: ['studyCommunityInstance': studyCommunityInstance, 'rmsCategoryList1': rmsCategoryList1, 'rmsCategoryList2': rmsCategoryList2, 'editType': params.editType])
            return
        }
        ['studyCommunityInstance': studyCommunityInstance, 'rmsCategoryList1': rmsCategoryList1, 'rmsCategoryList2': rmsCategoryList2]
    }
    def update = {
        def studyCommunity = StudyCommunity.get(params.id)
        if (studyCommunity) {
            def rmsCategory = RMSCategory.get(params.categoryId)
            def photo = uploadImg('update')
            if (photo != "") {
                studyCommunity.photo = photo
            }
            studyCommunity.name = params.name
            studyCommunity.communityCategory = rmsCategory
            studyCommunity.description = params.description

            if (!studyCommunity.hasErrors() && studyCommunity.save()) {
                flash.message = "学习社区修改成功"
                redirect(action: 'myCommunity', params: params)
            } else {
                render(view: 'editJoin', model: [subject: subject])
            }
        } else {
            flash.message = "找不到该学习社区"
            redirect(action: edit, params: params)
        }
    }
    //删除社区
    def deleteCommunity = {
        def community = StudyCommunity.get(params.id)
        if (community) {
            def forumBoards = community.forumBoards
            forumBoards?.each { forumBoard ->
                deleteForumBoard(forumBoard.id)
            }
            community.delete(flush: true)
        }
        redirect(action: 'myCommunity', params: params)
    }
    //批量删除社区
    def deleteCommuntiyList = {
        def delIdList = params.idList
        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            def community = StudyCommunity.get(id)
            if (community) {
                def forumBoards = community.forumBoards
                forumBoards?.each { forumBoard ->
                    deleteForumBoard(forumBoard.id)
                }
                community.delete(flush: true)
            }
        }

        redirect(action: myCommunity, params: params)
    }

    def deleteForumBoard(id) {
        def forumBoard = ForumBoard.get(id)
        if (forumBoard) {
            forumBoard.delete()
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
                if (opt == "save") {
                    def sc = StudyCommunity.createCriteria()
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
                imgFile.transferTo(new java.io.File(userActivityImg.getAbsolutePath(), imgPath))
            } else {
                flash.message = "上传图片格式不对..."
            }
        }
        return imgPath
    }

    //-------------------------------2012-6-29 addBy 崔雅鑫 消息管理-------------------------------------------
    //我的消息管理页，显示收信箱、发信箱、垃圾箱的数量
    def myMessageList = {
        if (!params.tag) params.tag = '1'

        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0

        params.sort = "id"
        params.order = "desc"

        def tag = params.tag

        request.singleFlag = 6 //个人空间左侧菜单标记 6-消息管理

        //写信
        if (tag == '0') {
            def collegeList = College.list()

            [params: params, collegeList: collegeList]
        }
        //收件箱
        else if (tag == '1') {
            def receiveMessageList = Message.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                eq("receiveConsumerID", session.consumer.id.intValue())
                ne("state", 2)
            }
            [
                    receiveMessageList : receiveMessageList,
                    receiveMessageTotal: receiveMessageList?.totalCount,
                    params             : params
            ]
        }
        //发件箱
        else if (tag == '2') {
            def sendMessageList = Message.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                eq("sendConsumerID", session.consumer.id.intValue())
                ne("state", 2)
            }
            [
                    sendMessageList : sendMessageList,
                    sendMessageTotal: sendMessageList?.totalCount,
                    params          : params
            ]
        }
        //垃圾箱
        else if (tag == '3') {
            def dustbinMessageList = Message.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                eq("state", 2)
                eq("receiveConsumerID", session.consumer.id.intValue())
            }
            [
                    dustbinMessageList : dustbinMessageList,
                    dustbinMessageTotal: dustbinMessageList?.totalCount,
                    params             : params
            ]
        }
        //默认消息首页
        else if (tag == '4') {
            def inboxCount = Message.countByReceiveConsumerID(session.consumer.id) //收件数
            def inboxNoReadCount = Message.countByReceiveConsumerIDAndState(session.consumer.id, 0) //收件箱未读数
            def outboxCount = Message.countBySendConsumerID(session.consumer.id) //发件数
            def outboxNoReadCount = Message.countBySendConsumerIDAndState(session.consumer.id, 0) //发件未被读数
            def dustbinCount = Message.countByReceiveConsumerIDAndState(session.consumer.id, 2) //垃圾箱数
            [
                    inboxCount       : inboxCount,
                    inboxNoReadCount : inboxNoReadCount,
                    outboxCount      : outboxCount,
                    outboxNoReadCount: outboxNoReadCount,
                    dustbinCount     : dustbinCount,
                    params           : params
            ]
        }
    }

    //发送消息
    def sendMessage = {
        /*
        def message = new nts.system.domain.Message(
            name: params.title,
            description: params.content,
            sendConsumerID: session.consumer.id,
            receiveConsumerID: CTools.nullToZero(params.receiverId)
        )
        message.save()

        if(!message) {
            message.errors.each {
                println it
            }
        }
        */
        if (params.tag == '0') {
            def receiveNames = params.receiveName.replaceAll('；', ';').split(';') //前台传来的收信人name，多个以;分隔
            receiveNames?.each {
                def consumer = Consumer.findByNameAndUserState(it, true)
                if (consumer) {
                    def message = new Message(
                            name: params.title,
                            description: params.content,
                            sendConsumerID: session.consumer.id,
                            receiveConsumerID: consumer.id.intValue()
                    )
                    message.save()

                    if (!message) {
                        message.errors.each {
                            println it
                        }
                    }
                }
            }
        } else if (params.tag == '6') {
            def consumerList = Consumer.createCriteria().list() {
                eq('userState', true)
                ne('id', session.consumer.id)
            }

            consumerList?.each { consumer ->
                def message = new Message(
                        name: params.title,
                        description: params.content,
                        sendConsumerID: session.consumer.id,
                        receiveConsumerID: consumer.id.intValue()
                )
                message.save()

                if (!message) {
                    message.errors.each {
                        println it
                    }
                }
            }
        }

        redirect(action: 'myMessageList', params: [tag: '4'])
    }

    //根据院系搜索用户
    def consumerList = {
        if (!params.max) params.max = 12
        if (!params.offset) params.offset = 0

        params.sort = "id"
        params.order = "desc"

        def collegeId = CTools.nullToZero(params.collegeId).longValue()
        def consumerList = Consumer.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (collegeId != 0) {
                college {
                    eq("id", collegeId)
                }
            }
            ne("role", 0)
            eq("userState", true)
        }
        [consumerList: consumerList, consumerTotal: consumerList?.totalCount, params: params]
    }

    //修改消息的阅读状态
    def updateMessageState = {
        def tag = params.tag

        def msgIdList = ''
        if (tag == '1') {
            msgIdList = params.msgId1
        } else if (tag == '2') {
            msgIdList = params.msgId2
        }

        def state = CTools.nullToZero(params.state)
        def flag = CTools.nullToBlank(params.flag)

        if (msgIdList instanceof String) {
            def msgId = CTools.nullToZero(msgIdList).longValue()
            def message = Message.get(msgId)
            message.state = state
            message.save()

            //标记为已读的需要更新session里未读信息的数量
            if (state == 1 && session.messageNoReadCount && Integer.parseInt(session.messageNoReadCount.toString()) > 0) {
                session.messageNoReadCount -= 1
            }

            if (tag == '1' && flag == '') {
                render ''
            } else if (tag == '1' && flag == '1') {
                redirect(action: 'myMessageList', params: params)
            } else if (tag == '2') {
                redirect(action: 'myMessageList', params: params)
            }
        } else {

            msgIdList?.each { msgId ->
                def message = Message.get(CTools.nullToZero(msgId).longValue())
                message.state = state
                message.save()

                //标记为已读的需要更新session里未读信息的数量
                if (state == 1 && session.messageNoReadCount && Integer.parseInt(session.messageNoReadCount.toString()) > 0) {
                    session.messageNoReadCount -= 1
                }
            }
            redirect(action: 'myMessageList', params: params)
        }
    }

    //删除消息
    def deleteMessages = {
        def msgIdList = params.msgId3
        if (msgIdList instanceof String) {
            def msgId = CTools.nullToZero(msgIdList).longValue()
            def message = Message.get(CTools.nullToZero(msgId).longValue())
            message.delete()
        } else {

            msgIdList?.each { msgId ->
                def message = Message.get(CTools.nullToZero(msgId).longValue())
                message.delete()
            }
        }
        redirect(action: 'myMessageList', params: params)
    }

    //-------------------------------消息管理结束-----------------------------------------------------

    //-------------------------------2012-7-1 addBy 崔雅鑫 后台学习圈管理----------------------------------------------

    //获取登录用户的个人信息到修改头像页
    def myPhoto = {
        //获得用户个人信息
        def consumer = getUser()
        request.singleFlag = 1 //个人空间左侧菜单标记 1-个人资料
        return [consumer: consumer]
    }

    //修改用户头像
    def myPhotoUpdate = {
        def result = [:];
        CommonsMultipartFile multipartFile = (CommonsMultipartFile)request.getFile("myPhoto");
        result = userService.uploadUserPhoto(multipartFile);
        if (result.noFindConsumer) {
            flash.message = "找不到用户信息"
            /*redirect(action: myPhoto)*///之前是这样写的
            render(view: 'myInfo', model: [consumer: result.consumer])
        } else {
            if (result.success) {
                flash.message = "用户 ${result.consumer.name} 头像修改完成！"
                redirect(action: "myInfo")
            } else {
                render(view: 'myInfo', model: [consumer: result.consumer])
            }
        }
    }

    //资源管理列表
    def myManageProgram = {

        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        def state = CTools.nullToZero(params.schState)//状态为0 所有未入库资源
        def directoryId = CTools.nullToZero(params.directoryId)//类库
        def fromModel = CTools.nullToBlank(params.fromModel)
        def schType = CTools.nullToBlank(params.schType)//
        def schWord = CTools.nullToBlank(params.schWord)

        //左边树条件
        def category = CTools.nullToZero(params.category)    //只有2个值（0,1）0表示传来的目录，1表示传来的是元数据，库在左边树中显示时用到,对外经贸库在右上方故用不到
        def metaId = CTools.nullToZero(params.metaId)    //在category == 0是目录ID category ==1	是元数据ID
        def enumId = CTools.nullToZero(params.enumId)
        def isAll = CTools.nullToOne(params.isAll)    //全部资源

        boolean isFromMgr = (fromModel == 'programMgr' || fromModel == 'programMgrRecycler')    //来自管理端

        def programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            //如果来自个人空间
            if (!isFromMgr) eq("consumer", session.consumer)

            if (directoryId > 0) {
                eq("directory.id", directoryId.toLong())
            }

            //个人空间回收站，显示在未审批前删除的资源
            if (fromModel == 'myRecycler') {
                gt("state", -Program.CLOSE_STATE)
                lt("state", Program.NO_APPLY_STATE)
            }
            //管理端回收站，显示已审批后删除的资源
            else if (fromModel == 'programMgrRecycler') {
                le("state", -Program.CLOSE_STATE)
            } else {
                if (state == 0) {
                    ge("state", Program.NO_APPLY_STATE)
                } else {
                    eq("state", state)
                }
            }

            //左边树条件
            if (isAll == 0) {
                //目录
                if (category == 0) {
                    eq("directory", Directory.get(metaId))
                }
                //元数据类别
                else if (category == 1 && metaId > 0) {
                    def metaDefine = MetaDefine.get(metaId)
                    if (metaDefine) {
                        if (metaDefine.dataType == "enumeration") {
                            ge("state", Program.PUBLIC_STATE)
                            metaContents {
                                eq('metaDefine', metaDefine)
                                if (enumId > 0) eq('numContent', enumId)
                            }
                        }
                    }
                }
            }

            //检索 标签 呢称用完全匹配查询
            if (schWord != '') {
                if (schType == 'name') {
                    like("name", "%${schWord}%")
                } else if (schType == 'actor') {
                    like("actor", "%${schWord}%")
                } else if (isFromMgr && schType == 'consumer') {
                    eq("consumer", Consumer.findByNickname(schWord))
                } else if (schType == 'programTags') {
                    programTags {
                        eq('name', schWord)
                    }
                }
            }

        }

        def directoryList = Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])
        request.singleFlag = 3 //个人空间左侧菜单标记 3-资源管理
        return render(view: 'myManageProgram', model: [programList: programList, total: programList?.totalCount, directoryList: directoryList, params: params])
    }

    //-------------------------------2012-7-1 addBy 崔雅鑫 结束----------------------------------------------

    //根据id获取消息的内容，同时如果是第一次阅读则更改其状态为已读
    def getMessageInfo = {
        def tag = params.tag //1-第一次阅读
        def msgId = CTools.nullToZero(params.msgId).longValue()

        def message = Message.get(msgId)
        if (message) {
            def content = message.description
            if (tag == '1') {
                message.state = 1
                message.save()

                //标记为已读的需要更新session里未读信息的数量
                if (session.messageNoReadCount && Integer.parseInt(session.messageNoReadCount.toString()) > 0) {
                    session.messageNoReadCount -= 1
                }
            }
            render content
        } else {
            render ''
        }
    }

    def createProgram() {
        def classLibId = CTools.nullToOne(params.classLib?.id)//nullToZero

        def webUtils = WebUtils.retrieveGrailsWebRequest();
        def response = webUtils.getCurrentResponse();
        String uploadPath = servletContext.uploadRootPath + '/' + session.consumer.name + '/lib' + classLibId + '/';
        Cookie cookie = new Cookie("uploadPath2", uploadPath);
        response.addCookie(cookie);
        session.program = null
        def directoryList = null

        if (session.consumer.uploadState == Consumer.CAN_UPLOAD_STATE) {
            directoryList = Consumer.get(session.consumer.id).directorys

            //管理员，未具体设置库的（默认） 能上传到所有库
            if (session.consumer.role < Consumer.MANAGER_ROLE || directoryList == null || directoryList.size() < 1) {
                directoryList = Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])
            }
            return render(view: 'createProgram', model: [classLibId: classLibId, directoryList: directoryList])
        } else {
            flash.message = "对不起,目前你没有上传的权限,请申请!"
            return render(view: 'createProgramShow');
        }


    }

    //设置资源管理权限
    def setMyProgramState = {
        programService.setMyProgramState(params);
        redirect(action: "myManageProgram")
    }
    def replacSerialPoster = {
        def result = [:];
        def id = params.id;
        int serialId;
        if (id) {
            serialId = Integer.parseInt(id);
        }
        Serial serial = Serial.get(serialId);
        if (serial) {
            String photo = params.photo;
            serial.photo = photo.toUpperCase();

            if (serial.save()) {
                result.success = true;
                result.src = posterLinkNew(serial: serial, size: '200x200');
            } else {
                result.success = false;
            }
        }
        return render(result as JSON)
    }
    def replacPoster = {
        def result = [:];
        def programId = params.programId;
        int id;
        if (programId) {
            id = Integer.parseInt(programId)
        };
        Program program = Program.get(id);
        if (program) {
            program.posterPath = params.posterPath;
            program.posterHash = params.posterHash;
            program.posterType = FileUtils.getFileSufix(params.posterPath);
            if (program.save()) {
                result.success = true;
            } else {
                result.success = false;
            }
        }
        return render(result as JSON)
    }

    /**
     * 替换竖版海报
     */
    def replaceVerticalPoster = {
        def result = [:];
        def programId = params.programId;
        int id;
        if (programId) {
            id = Integer.parseInt(programId)
        };
        Program program = Program.get(id);
        if (program) {
            program.verticalPosterPath = params.posterPath;
            program.verticalPosterHash = params.posterHash;
            program.verticalPosterType = FileUtils.getFileSufix(params.posterPath);
            if (program.save()) {
                result.success = true;
            } else {
                result.success = false;
            }
        }
        return render(result as JSON)
    }


    def myeditProgram = {
        def webUtils = WebUtils.retrieveGrailsWebRequest();
        def response = webUtils.getCurrentResponse();
        def idList = params.idList;
        Program program = Program.get(idList);
        String uploadPath = servletContext.uploadRootPath + '/' + session.consumer.name + '/lib' + program.classLibId + '/';
        String posterPath = servletContext.uploadRootPath + '/' + session.consumer.name + '/Img' + program.classLibId + '/';
        Cookie cookie = new Cookie("uploadPath1", uploadPath);
        Cookie cookie1 = new Cookie("posterPath", posterPath);
        response.addCookie(cookie);
        response.addCookie(cookie1);
        return render(view: 'myeditProgram', model: [program: program])
    }

    def editProgramInfo = {
        def webUtils = WebUtils.retrieveGrailsWebRequest();
        def response = webUtils.getCurrentResponse();
        def idList = params.id;
        Program program = Program.get(idList);

        // 取得分类ID和名称
        def categoryId = "";
        def categoryName = "";
        List<ProgramCategory> categoryList = program?.programCategories?.toList();
        if (categoryList && categoryList.size() > 0) {
            categoryList.each {
                categoryId = categoryId + it.id + ",";
                categoryName = categoryName + it.name + ",";
            }
        }
        if (categoryId != "") {
            categoryId = categoryId.substring(0, categoryId.length() - 1);
        }
        if (categoryName != "") {
            categoryName = categoryName.substring(0, categoryName.length() - 1);
        }

        // 标签排序
        if(program?.programTags?.size()>0){
            program.programTags = program.programTags.sort{e1,e2->
                return e1.id-e2.id;
            }
        }

        // 取得分面
        def factedMap = [:];
        def factedList = [];
        List<FactedValue> factedValues = program?.factedValues?.toList();
//        ProgramCategory category = null;
//        if (factedValues && factedValues.size() > 0) {
//            category = factedValues.get(0)?.categoryFacted?.category;
//        } else { //如果没有设置分面值,选择第一个分类的分面
//            if(program?.firstCategoryId) {
//                category = ProgramCategory.get(program?.firstCategoryId);
//            }
//        }
        if (categoryList) {
            categoryList.each { category ->
                def categoryFacteds = category?.facteds.toList().sort();
                categoryFacteds?.each { CategoryFacted facted ->
                    if (facted?.values) {
                        factedMap = [:];
                        factedMap.facteId = facted.id;
                        factedMap.factedName = facted.name;
                        def values = [];
                        def valueMap = [:];
                        def fValues = facted?.values.toList().sort();
                        fValues?.each { FactedValue value ->
                            valueMap = [:];
                            valueMap.valId = value.id;
                            valueMap.valName = value.contentValue;
                            if (program?.factedValues.contains(value)) {
                                valueMap.checked = '1';
                            } else {
                                valueMap.checked = '0';
                            }
                            values.add(valueMap);
                        }
                        values.sort { val1, val2 ->
                            val1.valId <=> val2.valId
                        };
                        factedMap.values = values;
                        factedList.add(factedMap);
                    }
                }
            }
        }
        factedList.sort();

        String uploadPath = servletContext.uploadRootPath + '/' + session.consumer.name + '/lib' + program.classLibId + '/';
        String posterPath = servletContext.uploadRootPath + '/' + session.consumer.name + '/Img' + program.classLibId + '/';
        Cookie cookie = new Cookie("uploadPath1", uploadPath);
        Cookie cookie1 = new Cookie("posterPath", posterPath);
        response.addCookie(cookie);
        response.addCookie(cookie1);
        return render(view: 'editProgramInfo', model: [program: program, factedList: factedList, categoryId: categoryId, categoryName: categoryName])

    }

    def myEditMetaContent = {
        def program = Program.get(params.id)

        if (program && (program.consumer.id == session.consumer?.id)) {

            return render(view: 'myEditMetaContent', model: [program: program, operation: 'edit'])
        } else {
            flash.message = "program not found with id ${params.id}"
            redirect(action: "myManageProgram")
        }
    }

    def saveMetaContent() {
        def result = [:];
        result = programMgrService.dealMetaData(params);
        flash.message = result.message;
        redirect(action: "myEditMetaContent", id: params.id)
    }

    def editSerialList = {
        def idList = params.id;
        Program program = Program.get(idList);

        // 资源文件ID排序
        if(program?.serials?.size() > 1){
            program.serials = program.serials.sort{e1,e2->
                return e1.serialNo - e2.serialNo;
            }
        }

        String uploadPath = servletContext.uploadRootPath + '/' + session.consumer.name + '/lib' + program.classLibId + '/';
        String posterPath = servletContext.uploadRootPath + '/' + session.consumer.name + '/Img' + program.classLibId + '/';
        Cookie cookie = new Cookie("uploadPath1", uploadPath);
        Cookie cookie1 = new Cookie("posterPath", posterPath);
        response.addCookie(cookie);
        response.addCookie(cookie1);
        return render(view: 'editSerialList', model: [program: program])
    }

    def updateProgram = {
        params.request = request;
        params.consumer = session.consumer;
        def result = programService.modifyProgramInfo(params);
        flash.msg = result.msg;
        return redirect(action: 'editProgramInfo', params: [id: result.program.id]);
    }
    //
    def deleteSerial = {
        def id = params.id;
        def programId = params.programId;
        def program = Program.get(programId);
        Serial serial = Serial.get(id);
        if (serial) {
            serial.delete();
            return render(view: 'myeditProgram', model: [program: program])
        }
    }
    //放入回收站
    def toRecycler = {
        params.consumer = session.consumer;
        params.request = request;
        def result = programMgrService.toRecycler(params);
        return redirect(action: 'myManageProgram')
    }
    // 删除资源
    def myDelete = {
        params.consumer = session.consumer;
        def result = programMgrService.deleteProgram(params);
        return redirect(action: 'myDeleteProgram')
    }

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

    def saveProgram() {
        def result = programService.saveProgram(params);
        if (result.success) {
            flash.saveMes = "资源上传成功,可以继续上传！"
            return redirect(action: 'uploadSuccess');
        } else {
            flash.saveMes = "资源上传失败!"
            return redirect(action: 'createProgram')
        }
    }

    def saveSerial() {
        Serial serial = Serial.findById(params.id);
        def name = params.name;
        def desc = params.desc;
        def serialNum = CTools.nullToOne(params.serialNum);
        def photo = params.photo;
        serial.name = name;
        serial.description = desc;
        serial.serialNo = serialNum;
        if (serial.save(flush: true)) {
            return redirect(action: 'editSerialList', params: [id: serial.program.id]);
        } else {
            return redirect(action: 'editSerial', params: [id: serial.id])
        }
    }

    def test() {
        return render(view: 'test')
    }

    def uploadSuccess() {
        return render(view: 'uploadSuccess')
    }

    def editSerial() {
        Serial serial = Serial.get(params.id);
        String uploadPath = servletContext.uploadRootPath + '/' + session.consumer.name + '/lib' + serial.program.classLibId + '/';
        String posterPath = servletContext.uploadRootPath + '/' + session.consumer.name + '/Img' + serial.program.classLibId + '/';
        Cookie cookie = new Cookie("uploadPath1", uploadPath);
        Cookie cookie1 = new Cookie("posterPath", posterPath);
        response.addCookie(cookie);
        response.addCookie(cookie1);
        return render(view: 'editSerial', model: [serial: serial]);
    }

    def removeSerial() {
        def result = [:];
        Serial serial = Serial.findById(params.id);
        if (serial) {
            try {
                PlayedProgram playedProgram = PlayedProgram.findBySerial(serial);
                if(playedProgram){
                    playedProgram.delete(flush: true);
                }
                serial.delete(flush: true);
                Program program = Program.get(params.programId);
                program.serialNum = program.serialNum - 1;
                program.save(flush: true)
                result.success = true;
            } catch (Exception e) {
                result.success = false;
                result.msg = "删除失败！${e.message}"
            }


        } else {
            result.success = false;
            result.msg = "参数不全！"
        }

        return render(result as JSON);
    }

    def userSpace() {
        //获得我的用户组
        Consumer consumer = Consumer.get(params.id);
        if (consumer) {

            List<PlayedProgram> videoPrograms = [];
            List<PlayedProgram> docPrograms = [];
            List<Program> programList = Program.withCriteria {
                eq("consumer", consumer)
                eq("canPublic", true)
                eq("state", Program.PUBLIC_STATE)
            }
            return render(view: 'userspace', model: [programList: programList, consumer: consumer])

        }

    }


    def saveSerialList() {
        Map result = programService.modifySerialList(params);
        if (result.success) {
            redirect(action: "myManageProgram");
        } else {
            redirect(action: "editSerialList", params: [id: params.programId]);
        }

    }

    @ActionNameAnnotation(name="我的笔记")
    def myNotesProgramList() {

        def notesList = ProgramNote.withCriteria {
            eq("consumer", session.consumer)
            order("createDate", "desc")
            projections {
                groupProperty("program")
                count("id")
                property("createDate")
            }
        }

        return render(view: 'myNotesProgramList', model: [notesList: notesList]);
    }
    /**
     * 我的提问
     */
    @ActionNameAnnotation(name="我的提问")
    def myProblemListNews() {
        Consumer consumer = session.consumer;
        //我提出的问题
        def courseQuestionList = CourseQuestion.createCriteria().list(order: 'desc', sort: 'createDate') {
            eq('consumer', consumer)
        }
        //我回答过的问题
        def idList = CourseQuestion.createCriteria().list(order: 'desc', sort: 'createDate') {
            answer {
                eq("consumer", consumer)
            }
            distinct('id')
        }
        List courseAnswerQuestionList = new ArrayList();
        idList.each {
            courseAnswerQuestionList.add(CourseQuestion.get(it));
        }
        return render(view: 'myProblemListNews', model: [courseQuestionList: courseQuestionList, courseAnswerQuestionList: courseAnswerQuestionList]);
    }
    /**
     * 删除提问
     */
    def deleteMyCourseQuestion() {
        def courseQuestionId = params.courseQuestionId;
        Consumer consumer = session.consumer;
        CourseQuestion courseQuestion = CourseQuestion.get(courseQuestionId);
        if (courseQuestion && consumer && courseQuestion.consumer.id == consumer.id) {
            courseQuestion.delete();
        }
        return redirect(action: "myProblemListNews");

    }

    def myCreatCourseListNews() {

    }

    @ActionNameAnnotation(name="我的社区")
    def myCreatedCommunity() {
        //取得最大显示页面，并转换为整型
        //取得页面偏移量，并转换为整型
        def communityList = searchCommunity()
        def nameList = []
        communityList?.each { community ->
            def consumer = Consumer.get(community.create_comsumer_id)
            nameList.add(consumer.name)
        }

        def total = communityList.totalCount;

        def _max = params.max.toInteger()
        def _offset = params.offset.toInteger()
        int pageCount = Math.round(Math.ceil(total / _max))
        int pageNow = (_offset / _max) + 1

        List<StudyCommunity> joinCommunity = ForumMember.withCriteria {
            projections {
                distinct("studyCommunity")
            }
            eq("consumer", session.consumer)
            eq("state", 0)
        }


        //加入的小组
        def forumMemberList = ForumMember.createCriteria().list(order: 'desc', sort: 'id') {
            eq("consumer", session.consumer)
            eq("state", 0)
        }
        //查询每个小组中的成员
        def forumBoardMemberMap = [:];
        for (ForumMember forumMember : forumMemberList) {
            def forumMemberNum = ForumMember.findAllByForumBoard(forumMember.forumBoard);
            forumBoardMemberMap.put(forumMember.id, forumMemberNum ? forumMemberNum.size() : 0);
        }
        return render(view: 'myCreatedCommunity', model: [forumBoardMemberMap: forumBoardMemberMap, forumMemberList: forumMemberList,
                                                          joinCommunity: joinCommunity, communityList: communityList, nameList: nameList, total: total,
                                                          pageCount: pageCount, pageNow: pageNow,twyName:params.wyName,tstate: params.state])
    }

    /*def myJoinedCommunity = {
        //取得最大显示页面，并转换为整型
        //取得页面偏移量，并转换为整型

        def nameList = []

        //加入的社区
        def communitys;
        List<StudyCommunity> joinCommunity = StudyCommunity.createCriteria().list() {
            if (session.consumer) {
                notEqual("create_comsumer_id", session.consumer.id as int)
                members {
                    eq("id", session.consumer.id)
                }
            }
        }

        return render(view: 'myJoinedCommunity', model: [joinCommunity: joinCommunity, nameList: nameList])

    }*/

    def viewCourseNote = {
        Program program = Program.findById(params.programId);
        List<ProgramNote> noteList = ProgramNote.findAllByProgramAndConsumer(program, session.consumer);
        return render(view: 'viewCourseNote', model: [program: program, notesList: noteList]);
    }

    def myCourseQuestion() {
        List<CourseQuestion> questionList = CourseQuestion.findAllByConsumer(session.consumer)
        return render(view: 'myCourseQuestion', model: [questionList: questionList]);
    }

    def myModifyNote() {

        ProgramNote programNote = ProgramNote.findById(params.noteId);
        if ("true".equals(params.canPublic)) {
            programNote.canPublic = true;
        } else {
            programNote.canPublic = false;
        }
        if (params.content) {
            programNote.content = params.content;
        }
        programNote.save(flash: true);
        return redirect(action: 'viewCourseNote', params: [programId: programNote.program.id]);
    }
    /**
     * 我的笔记删除
     */
    def myNoteDelete() {
        ProgramNote programNote = ProgramNote.findById(params.noteId);
        if (programNote && programNote.consumer.id == session.consumer.id) {
            //删除下面的笔记推荐
            NoteRecommend.executeUpdate("delete from NoteRecommend where programNote.id = :programNoteId", [programNoteId: programNote.id])
            programNote.delete(flash: true);
            flash.message = "删除笔记成功";
            return redirect(action: 'viewCourseNote', params: [programId: programNote.program.id]);
        } else {
            flash.message = "删除笔记失败";
            return redirect(action: 'myNotesProgramList');
        }

    }

    @ActionNameAnnotation(name="我的文件")
    def mySharingList() {
        Cookie cookie1 = new Cookie("uploadServerAddress", systemConfigService.findUploadServerAddress());
        Cookie cookie2 = new Cookie("uploadServerPort", systemConfigService.findUploadPort().toString());
        Cookie cookie3 = new Cookie("fileSizeLimit", systemConfigService.findFileSizeLimit().toString());
        response.addCookie(cookie1);
        response.addCookie(cookie2);
        response.addCookie(cookie3);
        Consumer consumer = session.consumer;
        if (!params.max) params.max = 10;
        if (!params.offset) params.offset = 0;
        List<UserCategory> categoryList = UserCategory.createCriteria().list(order: 'desc', sort: 'createdDate') {
            eq("consumer", consumer);
            isNull("fatherCategory")
            eq("state", 0)
        }
        List<UserFile> fileList = UserFile.createCriteria().list(max: params.max, offset: params.offset, order: 'desc', sort: 'createdDate') {
            eq("consumer", consumer);
            isNull("userCategory")
            eq("state", 0)
        }
        def total = fileList.totalCount;
        // 取得最新的空间大小
        Consumer spaceConsumer = Consumer.get(consumer.id);
        consumer.maxSpaceSize = spaceConsumer.maxSpaceSize;
        consumer.useSpaceSize = spaceConsumer.useSpaceSize;
        return render(view: 'mySharingList', model: [fileList: fileList, categoryList: categoryList, total: total]);
    }
    /**
     * 文件自动加载
     * @return
     */
    def autoLoadingFile() {
        def appendDiv = ""
        UserCategory userCategory;
        def n = params.showCount as int;
        def page = params.page as int;
        def searchName = params.searchName;
        def fileCount;
        def max;
        if (params.fileCount) fileCount = params.fileCount as int;
        if (params.maxCount) {
            params.max = 10;
            max = params.maxCount as int;
            if (fileCount * page < max) {
                params.offset = fileCount * page;
            } else {
                params.offset = max - (max - ((page - 1) * fileCount));
            }
        }
        if (params.categoryId) userCategory = UserCategory.get(params.categoryId as Long);
        List<UserFile> fileList = [];

        if (fileCount < max) {
            fileList = UserFile.createCriteria().list(max: params.max, offset: params.offset, order: 'desc', sort: 'createdDate') {
                if (userCategory) {
                    eq('userCategory', userCategory)
                } else {
                    isNull("userCategory")
                }
                if (searchName) {
                    like("name", "%" + searchName + "%")
                }
                eq("consumer", session.consumer);
                if (params.isRecycle) {
                    eq("state", 1)
                } else {
                    eq("state", 0)
                }

            }

            fileList.each { UserFile userFile ->
                appendDiv += "<tr onmouseout='fileItemOut(${userFile?.id})' id='userFileDiv_${userFile?.id}' name=\"userFile\" onmousedown=\"userFilebtn(event,${userFile?.id},'${userFile?.name}','${userFile?.fileHash}','${userFile?.filePath}','file')\">";
                appendDiv += "<td width=\"40\">\n" +
                        "                            <input value=\"${userFile?.fileHash}\" id=\"hash\" type=\"hidden\"/>\n" +
                        "                            <input value=\"${userFile?.name}\" id=\"fname\" type=\"hidden\"/>\n" +
                        "                            <input value=\"${userFile?.id}\" id=\"fid\" type=\"hidden\"/>\n" +
                        "                            <div class=\"col-md-1 mysharinglist_cent\" style=\"width: 40px;\"><input  onclick=\"removeSelect('userFileDiv_${userFile?.id}')\" id=\"checkBox_${userFile?.id}\" name=\"checkFileList\" class=\"checklist\"  type=\"checkbox\" value=\"${userFile?.id}\" /></div>\n" +
                        "                        </td>";
                appendDiv += "<td width=\"370\"><div style=\"overflow: hidden;line-height: 28px;\">";
                if (FileType.isVideo(userFile?.filePath) || userFile?.filePath.endsWith("swf") || userFile?.filePath.endsWith("SWF")) {
                    appendDiv += "<span class=\"myshar_listico share_class_icon\" ></span>";
                } else if (FileType.isDocument(userFile?.filePath) || userFile?.filePath.endsWith("pdf") || userFile?.filePath.endsWith("PDF")) {
                    appendDiv += "<span class=\"myshar_listico share_class_icon2\" ></span>";
                } else if (FileType.isImage(userFile?.filePath)) {
                    appendDiv += "<span class=\"myshar_listico share_class_icon1\" ></span>";
                } else if (FileType.isAudio(userFile?.filePath)) {
                    appendDiv += "<span class=\"myshar_listico share_class_icon3\" ></span>";
                } else {
                    appendDiv += "<span class=\"myshar_listico share_class_icon4\" ></span>";
                }
                appendDiv += "<span id=\"spanFile\"><a title=\"${userFile?.name}\" onclick=\"playBtn('${userFile?.name}','${userFile?.fileType}','${userFile?.fileHash}')\">${CTools.cutString(userFile?.name, 30)}</a>\n" +
                        "                                </span><span id=\"spanFile1\" style=\"display: none\">\n" +
                        "                                    <input class='form-control f_controlsty' value=\"${userFile?.name}\" id=\"updateName\"/><a class='glyphicon glyphicon-ok btn-sm bt1_ie7 wy_sty3' onclick=\"updateFile(${userFile?.id})\"></a>\n" +
                        "                                    <button class='btn-lin" +
                        "" +
                        "" +
                        "" +
                        "k glyphicon glyphicon-remove btn-sm removeie7 wy_sty2' onclick=\"resetFile()\"></button>\n" +
                        "                                </span>\n" +
                        "                            </div>\n" +
                        "                        </td>";
                appendDiv += "<td width=\"120\"><div><div class=\"shar_tools\">\n" +
                        "                                    <a class=\"state_display\" title=\"下载\" name=\"download\"><span  class=\"glyphicon glyphicon-cloud-download btn-sm downloadie7\" style=\"padding: 0;margin: 0 5px;\"></span></a>\n" +
                        "                                    <a class=\"state_display\" title=\"公开\" name=\"sharingFile\"><span class=\"glyphicon glyphicon-share btn-sm shareie7\" style=\"padding: 0;margin: 0 8px;\"></span></a>\n" +
                        "                                    <a class=\"state_display\" title=\"删除\" name=\"deleteFile\"> <span  class=\"glyphicon glyphicon-remove btn-sm removeie7\" style=\"padding: 0;margin: 0 5px;\"></span></a>\n" +
                        "                                </div>\n" +
                        "                            </div>\n" +
                        "                        </td>";
                appendDiv += "<td width=\"100\"><div class=\"col-md-1 mysharinglist_cent\" style=\"width: 100px; text-align: left\"  name=\"fileSize\">${convertHumanUnit(fileSize: userFile?.fileSize)}\n" +
                        "                            </div>\n" +
                        "                        </td>";
                appendDiv += "<td><div class=\"col-md-2 mysharinglist_cent\">${new SimpleDateFormat('yyyy-MM-dd').format(userFile?.createdDate)}</div>\n" +
                        "                        </td>";
                appendDiv += "</tr>";
            }
        }
        return render(appendDiv)
    }

    @ActionNameAnnotation(name="我的专辑")
    def myAlbumResource() {
        Cookie cookie1 = new Cookie("uploadServerAddress", systemConfigService.findUploadServerAddress());
        Cookie cookie2 = new Cookie("uploadServerPort", systemConfigService.findUploadPort().toString());
        response.addCookie(cookie1);
        response.addCookie(cookie2);
        if(!params.max)params.max=5;
        if(!params.offset)params.offset=0;
        List<UserFile> userFileList = UserFile.createCriteria().list(order: 'desc',sort: 'createdDate'){
            isNull('userCategory')
            eq('consumer',session.consumer)
        }
        List<UserSpecial> userSpecialList = UserSpecial.createCriteria().list(order: 'desc',sort: 'createdDate',max:params.max,offset:params.offset){
            eq('consumer',session.consumer)
        };
        // 按照海报ID排序
        userSpecialList.each {
            if(it.posters?.size()>1) {
                it.posters = it.posters.sort{e1,e2 ->
                    return e1.id - e2.id;
                }
            }
        }
        def total = userSpecialList.totalCount;
        return render(view: 'myAlbumResource',model: [userFileList:userFileList,userSpecialList:userSpecialList,total:total])
    }

    def myAlbumResourceList() {
        def id = params.id;
        List<SpecialFile> specialFileList = [];
        UserSpecial userSpecial = null;
        if(id){
            userSpecial = UserSpecial.get(id as Long);
            specialFileList = SpecialFile.findAllByUserSpecial(userSpecial);
        }
        def list=[]//记录我的文件中回收站被删除的文件
        specialFileList.each {
            try {
                it.userFile
            }catch (Exception e){
                if(e.getClass().getSimpleName()=='ObjectNotFoundException'){
                    // specialFileList.remove(it)
                    list.add(it)
                }else{
                   log.debug(e)
                }

            }
        }
        list.each {
            specialFileList.remove(it)
        }
        List<UserFile> userFileList = UserFile.createCriteria().list(order: 'desc',sort: 'createdDate'){
            isNull('userCategory')
            eq('consumer',session.consumer)
            eq('state',0)
        }

        // 按照海报ID排序
        if(userSpecial.posters?.size()>1) {
            userSpecial.posters = userSpecial.posters.sort{e1,e2 ->
                return e1.id - e2.id;
            }
        }
        return render(view: 'myAlbumResourceList',model: [userFileList:userFileList,specialFileList:specialFileList,userSpecial:userSpecial])
    }

    def myAlbumResourceCreat() {
        def idList = params.idList;
        List<Long> ids = [];
        List<UserFile> userFileList = [];
        if(idList){
            if(idList.indexOf(',')){
                def strs=idList.split(',');
                strs.each {
                    ids.add(it as Long)
                }
            }else{
                ids.add(idList as Long)
            }
            if(ids.size()>0){
                ids.each {
                    userFileList.add(UserFile.get(it));
                }
            }
        }
        return render(view: 'myAlbumResourceCreat',model: [userFileList:userFileList,idList:idList])
    }
    def myAlbumResourceEdit(){
        def id = params.id;
        UserSpecial userSpecial = null;
        if(id){
            userSpecial = UserSpecial.get(id as Long);
        }
        List<UserFile> userFileList = UserFile.createCriteria().list(order: 'desc', sort: 'createdDate') {
            isNull('userCategory')
            eq('consumer', session.consumer)
        }
        return render(view: 'myAlbumResourceEdit', model: [userSpecial: userSpecial, userFileList: userFileList])
    }
    def myAlbumResourceShow(){
        def id = params.id;
        UserSpecial userSpecial = null;
        if(id){
            userSpecial = UserSpecial.get(id as Long);
        }
        List<UserFile> userFileList = UserFile.createCriteria().list(order: 'desc', sort: 'createdDate') {
            isNull('userCategory')
            eq('consumer', session.consumer)
        }
        return render(view: 'myAlbumResourceShow', model: [userSpecial: userSpecial, userFileList: userFileList])
    }

    // 验证专辑是否已经发布为资源
    def checkAlbumResourceRelease(){
        def result=[:];
        def program = Program.findBySpecialId(params.id as Long);
        if(program){
            result.success=false;
            result.msg="该专辑已经发布为资源了！";
        } else {
            result.success=true;
        }
        return render(result as JSON);
    }

    // 初始化专辑发布的数据
    def myAlbumResourceRelease(){
        def id = params.id;
        List<SpecialFile> specialFileList = [];
        UserSpecial userSpecial = null;
        if(id){
            userSpecial = UserSpecial.get(id as Long);
            specialFileList = SpecialFile.findAllByUserSpecial(userSpecial);
        }
        def list=[]//记录我的文件中回收站被删除的文件
        specialFileList.each {
            try {
                it.userFile
            }catch (Exception e){
                if(e.getClass().getSimpleName()=='ObjectNotFoundException'){
                    // specialFileList.remove(it)
                    list.add(it)
                }else{
                    log.debug(e)
                }

            }
        }
        list.each {
            specialFileList.remove(it)
        }
        List<UserFile> userFileList = UserFile.createCriteria().list(order: 'desc',sort: 'createdDate'){
            isNull('userCategory')
            eq('consumer',session.consumer)
            eq('state',0)
        }
        return render(view: 'myAlbumResourceRelease',model: [userFileList:userFileList,specialFileList:specialFileList,userSpecial:userSpecial])
    }

    // 判断所选分类是否属于同一分类库
    def checkProgramCategory() {
        def result = [:];
        result = programService.checkProgramCategory(params);
        return render(result as JSON);
    }

    // 查询元数据标准和上传路径
    def queryCategoryDirectoryAndUploadPath() {
        def result = [:];
        result = programService.queryCategoryDirectoryAndUploadPath(params);
        return render(result as JSON);
    }

    //分面查询
    def queryCategoryFacted() {
        def result = [:];
        result = programService.queryCategoryFacted(params);
        return render(result as JSON);
    }

    // 将专辑发布为资源
    def myAlbumResourceReleaseProgramSave(){
        params.request=request
        params.consumerId = session.consumer.id;
        params.remoteAddr = request.getRemoteAddr();
        def result = programService.albumResourceReleaseProgram(params);
        return render(view: 'myAlbumResourceReleaseSuccess', model: [programId: result.programId]);
    }

    // 发布成功
    def myAlbumResourceReleaseSuccess(){
        return render(view : 'myAlbumResourceReleaseSuccess');
    }

    // 我的资源回收站
    def myDeleteProgram(){
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        def programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            lt("state", 0)
            eq("consumer", session.consumer)
        }
        return render(view: 'myDeleteProgram', model: [programList: programList, total: programList?.totalCount])
    }

    // 还原我的回收站资源
    def myRestoreProgram(){
        params.operation="restore";
        params.consumer = session.consumer;
        params.request = request;
        programMgrService.programStateSet(params);
        return redirect(action: 'myDeleteProgram');
    }
}
