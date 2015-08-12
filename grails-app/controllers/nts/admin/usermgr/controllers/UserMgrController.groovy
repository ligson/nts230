package nts.admin.usermgr.controllers

import au.com.bytecode.opencsv.CSVWriter
import com.boful.nts.utils.SystemConfig
import grails.converters.JSON
import nts.program.category.domain.ProgramCategory
import nts.program.domain.Program
import nts.studycircle.domain.Participant
import nts.system.domain.Directory
import nts.user.domain.ByteEnum
import nts.user.domain.College
import nts.user.domain.Consumer
import nts.user.domain.Role
import nts.user.domain.SecurityResource
import nts.user.domain.UserGroup
import nts.user.services.ActionNameAnnotation
import nts.user.services.ControllerNameAnnotation
import nts.user.services.PatternNameAnnotation
import nts.utils.CTools
import org.apache.poi.hssf.usermodel.HSSFCell
import org.apache.poi.hssf.usermodel.HSSFRow
import org.apache.poi.hssf.usermodel.HSSFSheet
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.springframework.dao.DataIntegrityViolationException

import java.text.DateFormat
import java.text.SimpleDateFormat

/**
 * 核心管理
 */
@ControllerNameAnnotation(name = "用户管理")
class UserMgrController {
    def userMgrService;
    def userService;
    def programService;

    @ActionNameAnnotation(name = "主页")
    def index() {
        redirect(action: 'userList', params: params)
    }

    @PatternNameAnnotation(name = "用户列表")
    @ActionNameAnnotation(name = "用户列表")
    def userList() {
        if (!params.userRole) params.userRole = 'user';
        session.setAttribute("userRole", params.userRole);
        /*
        def total                                        //声明列表结果行数
        def consumerList                                //声明结果集
        def role                                        //判断用户是哪种角色

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        if (!params.userRole) params.userRole = 'user'
        if (!params.roleList) params.roleList = '2,3'

        session.userRole = params.userRole;
        consumerList = userMgrService.search(params)
        total = consumerList.totalCount
        return render(view: 'index', model: [consumerList: consumerList, total: total, userRole: params.userRole, collegeList: College.list()])
        */
        return render(view: 'index', model: [editPage: params.editPage, searchName: params.searchName, searchNickName: params.searchNickName, searchTrueName: params.searchTrueName, searchCollege: params.searchCollege, userRole: params.userRole])
    }
    /*def search = {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        java.util.Date begin_date = null;
        java.util.Date end_date = null;

        def row = params.row                            //每行页显示的行数
        def name = params.searchName                    //用户帐号
        def searchType = params.searchType                //searchType是查询类型，1-为全字匹配，2-模糊查询
        def college = params.searchCollege                //学生所属院系
        def dateBegin = params.dateBegin                    //创建开始时间
        def dateEnd = params.dateEnd                    //创建结束时间
        def role = params.roleList                        //用户角色
        def roleList = null                                //页面获得角色列表
        def roleid = []

        def selectState = params.selectState                //用户是否选择用户状态查询
        def state = params.searchState                    //用户是否锁定或启用标记
        def selectUpload = params.selectUpload                //用户是否选择上传状态查询
        def upload = params.searchUpload
        def selectDownload = params.selectDownload        //用户是否选择下载状态查询
        def download = params.searchDownload
        def selectExamine = params.selectExamine            //用户是否选择审核状态查询
        def examine = params.searchExamine
        def searchNickName = params.searchNickName        //用户昵称
        def searchTrueName = params.searchTrueName        //用户真实姓名
        def offset = 0
        def sort = "id"

        if (role)                                            //用来判断用户角色
        {
            roleList = role.split(',')
            if (roleList instanceof String) roleList = [params.roleList]
            roleList?.each { id ->

                roleid << id.toInteger()                        //转换成数字型
            }
        }

        if (dateBegin && !dateEnd)                            //用户判断用使用的是哪一种时间段查询方式
        {
            dateBegin = params.dateBegin + ' 00:00:01'
            dateEnd = params.dateBegin + ' 23:59:59'

            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        } else if (dateBegin && dateEnd) {
            dateBegin = params.dateBegin + ' 00:00:01'
            dateEnd = params.dateEnd + ' 23:59:59'
            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        }
        //设置反回行数最大值
        if (!params.max) params.max = row
        if (!params.offset) {
            params.offset = '0'
        } else {
            offset = params.offset
        }
        if (!params.sort) {
            params.sort = 'id'
        } else {
            sort = params.sort
        }
        if (!params.order) params.order = 'asc'
        def searchList = Consumer.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            //帐号为真，添加用户帐户条件
            if (name) {
                name = name.trim()
                //判断查询条件是为全字匹配还是模糊查询，进行不同的查询
                if (searchType == "1") {
                    eq('name', name)
                } else {
                    like('name', "%${name}%")
                }
            }
            //用户昵称为真，进行昵称条件查询
            if (searchNickName) {
                searchNickName = searchNickName.trim()
                like('nickname', "%${searchNickName}%")
            }
            //用户真实姓名为真，进行姓名查询
            if (searchTrueName) {
                searchTrueName = searchTrueName.trim()
                like('trueName', "%${searchTrueName}%")
            }
            //用户所属院系为真，进行院系条件查询
            if (college) {
                eq('college', College.get(college))
            }
            //查询时间为真，进行时间段查询，如果只选择开始时间，那么就是某单独一天
            if (dateBegin) {
                between("dateCreated", begin_date, end_date)
            }
            //用户角色为真，根据用户角色进行查询
            if (role) {
                'in'("role", roleid)
            }
            //用户选择锁定查询为真，进行锁定条件查询
            if (selectState) {
                if (state == '1') {
                    eq("userState", true)
                } else {
                    eq("userState", false)
                }

            }
            //用户选择上传查询为真，进行锁定条件查询
            if (selectUpload) {
                eq("uploadState", upload.toInteger())
            }
            if (selectDownload) {
                if (download == '1') {
                    eq("canDownload", true)
                } else {
                    eq("canDownload", false)
                }

            }
            if (selectExamine) {
                if (examine == '1') {
                    eq("notExamine", true)
                } else {
                    eq("notExamine", false)
                }

            }
            ne("role", 0)
        }
        return searchList
    }*/

    @ActionNameAnnotation(name = "更改状态")
    def changeState() {
        userMgrService.setPro(params);
        userRedirect();
    }
    def userRedirect = {

        redirect(action: "userList", params: [offset: params.offset, sort: params.sort, order: params.order, max: params.max, userRole: params.userRole, roleList: params.roleList, searchName: params.searchName, searchNickName: params.searchNickName, searchTrueName: params.searchTrueName, searchCollege: params.searchCollege])
    }

    /*def setPro = {
        def changeId = params.changeId
        def changeTag = params.changeTag
        def changeOpt = params.changeOpt
        def consumer = Consumer.get(changeId)
        //---判断是否是修改上传属性，如果是按数字类型修改，如果不是按布尔类型修改
        if (changeOpt == 'upload') {
            if (changeTag == '1') {
                changeTag = 0
            } else {
                changeTag = 1
            }
        } else {
            if (changeTag == 'true') {
                changeTag = false
            } else {
                changeTag = true
            }
        }

        if (consumer) {
            if (changeOpt == 'state') {
                consumer.userState = changeTag
            }
            if (changeOpt == 'download') {
                consumer.canDownload = changeTag
            }
            if (changeOpt == 'upload') {
                consumer.uploadState = changeTag
            }
            if (changeOpt == 'comment') {
                consumer.canComment = changeTag
            }
            if (changeOpt == 'examine') {
                consumer.notExamine = changeTag
            }
            if (changeOpt == 'isRegister') {
                consumer.isRegister = changeTag
            }
        }
    }*/

    @PatternNameAnnotation(name = "用户列表")
    @ActionNameAnnotation(name = "修改")
    def userEdit() {
        def consumer = Consumer.get(params.id)
        if (!consumer) {
            flash.message = "nts.user.domain.Consumer not found with id ${params.id}"
            redirect(action: 'userList')
        } else {
            // 计算已经使用的空间
            int useSpaceSize = consumer.useSpaceSize.intValue();
            Integer spaceSizeUnit = consumer.spaceSizeUnit;
            def showUseSpace="";
            BigDecimal useSpace = new BigDecimal(consumer.useSpaceSize);
            BigDecimal standard = new BigDecimal(1024);
            BigDecimal divisor = standard;
            int i=1;
            if(spaceSizeUnit > 1) {
                while(true){
                    useSpace = new BigDecimal(consumer.useSpaceSize).divide(divisor, 4, BigDecimal.ROUND_HALF_UP);
                    if(useSpace.compareTo(standard) < 0 || i == spaceSizeUnit){
                        break;
                    }
                    divisor = divisor.multiply(standard);
                    i++;
                }
            }
            showUseSpace=useSpace+ByteEnum.cnType[i];
            List<College> collegeList = new ArrayList<College>();
            collegeList.add(new College());
            collegeList.addAll(College.list());
            def superCategory = ProgramCategory.findByParentCategoryIsNull();
            List<ProgramCategory> categories = new ArrayList<ProgramCategory>();
            if(superCategory) {
                categories = ProgramCategory.findAllByParentCategory(superCategory, ['order':'asc', 'sort':'id']);
            }
            return render(view: 'showUser', model: [consumer: consumer, categories: categories, collegeList: collegeList, editPage: params.editPage, searchName: params.searchName, searchNickName: params.searchNickName, searchTrueName: params.searchTrueName, searchCollege: params.searchCollege, userRole: params.userRole,showUseSpace:showUseSpace])
        }
    }

    @PatternNameAnnotation(name = "用户列表")
    @ActionNameAnnotation(name = "用户保存")
    def userSave() {
        def result = [:];
        params.consumer=session.consumer;
        params.request=request;
        result = userMgrService.userSave(params);
        if (result.success) {
            flash.message = result.message;
            redirect(action: "userList", params: [max: params.max, userRole: params.userRole, roleList: params.roleList])
        } else {
            render(view: 'userCreate', model: [consumer: result.consumer])
        }
    }

    @PatternNameAnnotation(name = "用户列表")
    @ActionNameAnnotation(name = "用户删除")
    def consumerDelete() {
        //delConsumerList()
        //userRedirect()
        params.request=request;
        params.consumer=session.consumer
        def result = userService.deleteConsumer(params);
        return render(result as JSON)
    }

    //---2009-6-8 新增 uploadConsumer 闭包，用来对用户上传权限进行设置
    @ActionNameAnnotation(name = "用户更新")
    def uploadConsumer() {
        userMgrService.setUpload(params);
        userRedirect()
    }

    //---2009-6-4 新增 setUpload	闭包，对用户上传权限进行设置
    /* def setUpload = {
         def updateIdList = params.idList
         def page = params.page
         def updateid = 0
         if (updateIdList instanceof String) updateIdList = [params.idList]
         updateIdList?.each { id ->
             updateid = updateid + "," + id
         }
         if (page == "") {
             page = "0"
         }
         Consumer.executeUpdate("update nts.user.domain.Consumer c set uploadState=${params.uploadTag}  where c.id in(${updateid}) ")

     }*/

    //---2009-6-4 新增 setLock 闭包，对用户锁定权限进行设置
    /* def setLock = {
         def lockIdList = params.idList
         def lockid = 0

         if (lockIdList instanceof String) lockIdList = [params.idList]
         lockIdList?.each { id ->
             lockid = lockid + "," + id
         }
         //注意params.lockTag参数，是从前端页面传来的标记，决定着是锁定还是解锁
         Consumer.executeUpdate("update nts.user.domain.Consumer c set userState=${params.lockTag}  where c.id in(${lockid}) ")
     }*/

    //---2009-4-27新增 setDownload	闭包，对用户下载权限进行设置
    /*  def setDownload = {
          def updateIdList = params.idList
          def page = params.page
          def updateid = 0

          if (updateIdList instanceof String) updateIdList = [params.idList]
          updateIdList?.each { id ->

              updateid = updateid + "," + id
          }
          Consumer.executeUpdate("update nts.user.domain.Consumer c set canDownload=${params.downloadTag}  where c.id in(${updateid}) ")
      }*/

    //---2009-4-27新增setExamine 闭包，对用户审核发布资源进行设置
    /* def setExamine = {
         def updateIdList = params.idList
         def page = params.page
         def updateid = 0

         if (updateIdList instanceof String) updateIdList = [params.idList]
         updateIdList?.each { id ->

             updateid = updateid + "," + id
         }
         Consumer.executeUpdate("update nts.user.domain.Consumer c set notExamine=${params.examineTag}  where c.id in(${updateid}) ")
     }*/

    /*def setRegister = {
        def updateIdList = params.idList
        def page = params.page
        def updateid = 0

        if (updateIdList instanceof String) updateIdList = [params.idList]
        updateIdList?.each { id ->

            updateid = updateid + "," + id
        }
        Consumer.executeUpdate("update nts.user.domain.Consumer c set isRegister=${params.registerTag}  where c.id in(${updateid}) ")
    }*/
    //---2009-4-27 新增 setComment
    /*def setComment = {
        def updateIdList = params.idList
        def page = params.page
        def updateid = 0

        if (updateIdList instanceof String) updateIdList = [params.idList]
        updateIdList?.each { id ->

            updateid = updateid + "," + id
        }
        Consumer.executeUpdate("update nts.user.domain.Consumer c set canComment=${params.commentTag}  where c.id in(${updateid}) ")
    }*/

    //---2009-6-26折分 delConsumerList 用户删除列表用户信息
    /*def delConsumerList = {
        def delIdList = params.idList
        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            //获得用户对像
            def consumer = Consumer.get(id)
            //删除与用户相关的参与者
            def participantList = Participant.findAllByConsumer(consumer)
            if (participantList && participantList.size() > 0) {
                participantList?.each { participant ->
                    if (participant) {
                        participant.delete();
                    }
                }
            }
            //根据用户ID，获得该用户所创建的组列表
            def groupList = UserGroup.findAllByConsumer(consumer.id)
            //循环该组中的对像
            groupList.toList().each { group ->
                //循环该用户所创建的组中有多少个用户
                group.consumers.toList().each {
                    //删除与userGroup对像的关系
                    it.removeFromUserGroups(group)
                    //删除consumer对像实列
                    group.delete()
                }
            }
            //删除用户对像
            consumer.delete()
        }
    }*/

    //---2009-6-5 新增 userComment 闭包，用来对用户评权限进行设置
    @ActionNameAnnotation(name = "用户评论权限")
    def userComment() {
        userMgrService.setComment(params);
        userRedirect()
    }

    //---2009-6-5 新增 userDownload 闭包，用来对用户下载权限进行设置
    @ActionNameAnnotation(name = "用户下载权限")
    def userDownload() {
        userMgrService.setDownload(params);
        userRedirect()
    }

    //---2009-6-5 userExamine 闭包，用来对用户的审核权限进行设置
    @ActionNameAnnotation(name = "用户审核权限")
    def userExamine() {
        userMgrService.setExamine(params);
        userRedirect()
    }

    @ActionNameAnnotation(name = "用户审核权限")
    def userRegister() {
        userMgrService.setRegister(params);
        userRedirect()
    }

    //---2009-04-01 新增 lockConsumer 闭包，用来对用户进行锁定或解锁
    @ActionNameAnnotation(name = "用户审核权限")
    def lockConsumer() {
        userMgrService.setLock(params);
        userRedirect()
    }

    @PatternNameAnnotation(name = "用户列表")
    @ActionNameAnnotation(name = "用户更新")
    def userUpdate() {
        def result = [:];
        params.modifyFrom = "admin";
        params.request=request;
        params.consumer=session.consumer;
        result = userService.modify(params);
        if (result.noFindConsumer) {
            flash.message = "nts.user.domain.Consumer not found with id ${result.id}"
            redirect(action: 'userEdit', id: result.id, params: [max: result.max, offset: result.offset, sort: result.sort, order: result.order, userRole: result.userRole, editPage: params.editPage, searchName: params.searchName, searchNickName: params.searchNickName, searchTrueName: params.searchTrueName, searchCollege: params.searchCollege, userRole: params.userRole2])
        } else {
            if (result.success) {
                flash.message = "用户 ${result.consumer.name} 修改完成！"

                //redirect(action: 'userEdit', id: result.consumer.id, params: [offset: result.offset, sort: result.sort, order: result.order, max: result.max, userRole: result.userRole, roleList: result.roleList, searchName: result.searchName, searchNickName: result.searchNickName, searchTrueName: result.searchTrueName, searchCollege: result.searchCollege])
                redirect(action: 'userList', params: [editPage: params.editPage, searchName: params.searchName, searchNickName: params.searchNickName, searchTrueName: params.searchTrueName, searchCollege: params.searchCollege, userRole: params.userRole2])
            } else {
                flash.message = result.msg;
                return render(view: 'showUser', model: [consumer: result.consumer, dirlist: Directory.list(), collegeList: College.list(), editPage: params.editPage, searchName: params.searchName, searchNickName: params.searchNickName, searchTrueName: params.searchTrueName, searchCollege: params.searchCollege, userRole: params.userRole])
//                return redirect(action: 'userEdit', params: [msg:result.msg, editPage: params.editPage, searchName: params.searchName, searchNickName: params.searchNickName, searchTrueName: params.searchTrueName, searchCollege: params.searchCollege, userRole: params.userRole2])
            }
        }
    }

    @PatternNameAnnotation(name = "用户列表")
    @ActionNameAnnotation(name = "创建更新")
    def userCreate() {
        def consumerInstance = new Consumer()
        consumerInstance.properties = params
        List<College> collegeList = new ArrayList<College>();
        collegeList.add(new College());
        collegeList.addAll(College.list());
        return render(view: 'userCreate', model: ['consumerInstance': consumerInstance, collegeList: collegeList]);
    }
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "用户组管理")
    def userGroupList() {
        /*
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        //取得最大显示页面，并转换为整型
        //取得页面偏移量，并转换为整型
        def _max = params.max.toInteger()
        def _offset = params.offset.toInteger()
        def total = UserGroup.count()
        int pageCount = Math.round(Math.ceil(total / _max))
        int pageNow = (_offset / _max) + 1
        [userGroupList: UserGroup.list(params), total: total, pageCount: pageCount, pageNow: pageNow]
        */
        [editPage: params.editPage]
    }

    //----2009-03-25新增 deleteUserGroup 闭包
    @ActionNameAnnotation(name = "用户组删除")
    def deleteUserGroup() {
        userMgrService.deleteUserGroup(params);
        def page = params.page

        if (page == "") {        //判断书页是否是第一页，如果是第一页无法传page值
            page = "0"
        }
        redirect(action: "userGroupList", params: [offset: page])

    }

    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "用户组保存")
    def userGroupSave() {
        def result = [:];
        result = userService.saveUserGroup(params);
        if (result.success) {
            flash.message = result.message;
            redirect(action: "userGroupList")
        } else {
            render(view: 'userGroupCreate', model: [userGroup: result.userGroup])
        }
    }

    @ActionNameAnnotation(name = "用户组创建")
    def userGroupCreate() {
        def userGroupInstance = new UserGroup()
        userGroupInstance.properties = params
        return render(view: 'userGroupCreate', model: ['userGroupInstance': userGroupInstance]);
    }

    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "用户组更新")
    def userGroupUpdate() {
        def result = [:];
        result = userService.updateUserGroup(params);
        if (result.success) {
            flash.message = result.message;
            redirect(action: "userGroupList", params: [offset: params.offset, sort: params.sort, order: params.order, editPage: params.editPage])
        } else {
            if (result.notFind) {
                flash.message = result.message;
            } else {
                render(view: 'userGroupList', model: [userGroup: result.userGroup], params: [id: params.id, offset: params.offset, sort: params.sort, order: params.order, editPage: params.editPage])
            }
        }
    }

    //---新增  myGroupSelectPage
    @ActionNameAnnotation(name = "条件选择页面")
    def groupSelectPage() {
        [collegeList: College.list()]
    }
    //---2009-5-7 新增 myGroupSelectList  查询列表
    @ActionNameAnnotation(name = "条件查询列表")
    def groupSelectList() {
        def result = [:];
        result = userService.groupSelectList(params);

        return [searchList: result.searchList, userGroupList: result.userGroupList, total: result.total]
    }

    //---2009-6-10 新增 myGroupConsumerList 闭包，查看组员信息
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "查看组员信息")
    def groupConsumerList() {

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
        def userGroupList = UserGroup.findAll()
        [userGroupConsumerList: userGroupConsumerList, userGroupList: userGroupList, total: total, groupId: params.groupId, groupName: userGroupName, pageCount: pageCount, pageNow: pageNow, editPage: params.editPage]
    }

    //---2009-6-10 新增GroupAddConsumer 闭包，向组中添加成员
    @ActionNameAnnotation(name = "组中添加成员")
    def groupAddConsumer() {
        userService.groupAddConsumer(params);
        def page = params.page

        if (page == "") {        //判断书页是否是第一页，如果是第一页无法传page值
            page = "0"
        }
        redirect(action: "groupConsumerList", params: [offset: page, groupId: params.groupId])
    }

    //---2009-6-10 新增 groupAddConsumerOne 闭包，向所选择的组中添加新单个用户
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "选择的组中添加新单个用户")
    def groupAddConsumerOne() {
        def result = [:];
        result = userService.groupAddConsumerOne(params);
        if (!result.success) {
            flash.message = result.message;
        }
        redirect(action: "groupConsumerList", params: [offset: params.offset, max: params.max, groupId: params.groupId])
    }

    //--- 2009-05-21 新增 groupDeleteConsumerOne  闭包 ，删除单个组员与组的关系
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "删除单个组员与组的关系")
    def groupDeleteConsumerOne() {
        userService.groupDeleteConsumerOne(params);
        redirect(action: "groupConsumerList", params: [offset: params.offset, max: params.max, groupId: params.groupId])
    }

    //--- 2009-04-14 新增闭包 showSearch
    @ActionNameAnnotation(name = "showSearch")
    def showSearch() {
        [collegeList: College.list()]
    }

    //---2009-04-14 新增闭包 searchConsumer 根据条件查用户
    @ActionNameAnnotation(name = "根据条件查用户")
    def searchConsumer() {
        //---调用search闭包  查询结果
        def searchList = userMgrService.search(params)
        //---获得返回结果总数
        def total = searchList.totalCount
        return [searchList: searchList, userGroupList: UserGroup.list(), total: total]
    }

    //---2009-04-17  新增 searchDelete 闭包，调用delConsumerList()闭包进行删除列中的用户
    @ActionNameAnnotation(name = "删除列中的用户")
    def searchDelete() {
        userMgrService.delConsumerList(params);
        redirect(action: 'searchConsumer', params: params)
    }

    //---2009-04-17 新增  searchUpload 闭包 ，查询结果中更改上传状态
    @ActionNameAnnotation(name = "查询结果中更改上传状态")
    def searchUpload() {
        //---调用setUpload 进行修改
        userMgrService.setUpload(params)
        redirect(action: 'searchConsumer', params: params)
    }

    //2009-04-17新增 searchLoadGroup 将用户批量导入到组
    @ActionNameAnnotation(name = "用户批量导入到组")
    def searchLoadGroup() {
        userMgrService.searchLoadGroup(params);
        redirect(action: 'searchConsumer', params: params)
    }

    //--2009-04-17 新增 searchLoadAllGroup 闭包 用来将用户导出组
    @ActionNameAnnotation(name = "将用户导出组")
    def searchLoadAllGroup() {
        userMgrService.searchLoadAllGroup(params);
        def consumerIdList = params.idList

        redirect(action: 'searchConsumer', params: params)
    }

    //2009-07-17新增 searchUnloadGroup 将用户批量导出组
    @ActionNameAnnotation(name = "将用户导出组")
    def searchUnloadGroup() {
        userMgrService.searchUnloadGroup(params);

        redirect(action: 'searchConsumer', params: params)
    }
//---2009-4-20 新增 searchConsumerLoadGroup 用记单个用户导入导出组
    @ActionNameAnnotation(name = "用记单个用户导入导出组")
    def searchConsumerLoadGroup() {

        //调用loadGroupEdit 闭包，进行导入导出组
        userMgrService.loadGroupEdit(params);
        redirect(action: 'searchEdit', id: params.id)
    }

//---2009-4-17 新增 searchLockConsumer 查询结果 锁定用户
    @ActionNameAnnotation(name = "查询结果 锁定用户")
    def searchLockConsumer() {
        userMgrService.setLock(params)
        redirect(action: 'searchConsumer', params: params)
    }

//---2009-4-20 新增 searchShow 闭包 用来显示查询个人信息
    @ActionNameAnnotation(name = "显示查询个人信息")
    def searchShow() {
        def consumer = Consumer.get(params.id)
        if (!consumer) {
            flash.message = "找不到用户${params.name}信息"
            redirect(action: "searchConsumer", params: params)
        } else {
            return [consumer: consumer, params: params]
        }
    }
//---2009-4-20 新增 searchEdit 编辑查询用户信息
    @ActionNameAnnotation(name = "编辑查询用户信息")
    def searchEdit() {
        def consumer = Consumer.get(params.id)
        if (!consumer) {
            flash.message = "找不到用户${params.name}信息"
            redirect(action: "searchConsumer", params: params)
        } else {
            return [consumer: consumer, dirlist: Directory.list(), collegeList: College.list()]
        }
    }
//---2009-4-20 新增 searchUpdate  更新用户是信息
    @ActionNameAnnotation(name = "更新用户是信息")
    def searchUpdate() {
        def result = [:];
        result = userMgrService.searchUpdate(params);
        if (result.noFind) {
            flash.message = result.message;
            redirect(action: 'searchEdit', id: params.id, params: params)
        } else {
            if (result.success) {
                flash.message = result.message;
                redirect(action: 'searchEdit', params: [id: params.updateId, max: params.max, sort: params.sort, order: params.order, offset: params.offset, searchState: params.searchState, searchCollege: params.searchCollege, dateEnd: params.dateEnd, dateBegin: params.dateBegin, searchType: params.searchType, searchUpload: params.searchUpload, row: params.row, roleList: params.roleList, searchName: params.searchName, controller: params.controller, selectState: params.selectState, selectUpload: params.selectUpload, selectDownload: params.selectDownload, searchDownload: params.searchDownload, selectExamine: params.selectExamine, searchExamine: params.searchExamine, searchTrueName: params.searchTrueName])
            } else {
                render(view: 'searchEdit', model: [consumer: result.consumer], params: params)
            }
        }
    }

//---2009-4-20 新增 searchEditDelete 删除查询结果中的用户
    @ActionNameAnnotation(name = "删除查询结果中的用户")
    def searchEditDelete() {
        def result = [:];
        result = userMgrService.searchEditDelete(params);
        if (result.success) {
            redirect(action: 'searchConsumer', params: params)
        } else {
            flash.message = result.success;
            redirect(action: 'searchConsumer', params: params)
        }
    }

    //---2009-4-27新增searchDownload 在查结果中，对用户下载权限进行更操作（调用setDownload）
    @ActionNameAnnotation(name = "查询结果中下载权限更改")
    def searchDownload() {
        userMgrService.setDownload(params);
        redirect(action: 'searchConsumer', params: params)
    }
    //---2009-4-27 新增 searchExamine 在查询结果中，对用户发货资源审核权限操作
    @ActionNameAnnotation(name = "查询结果中资源审核更改")
    def searchExamine() {
        userMgrService.setExamine(params);
        redirect(action: 'searchConsumer', params: params)
    }
    //---2009-4-27 新增 searchComment 在查询结果中，对用户的评论权限进行设置
    @ActionNameAnnotation(name = "查询结果中用户评论更改")
    def searchComment() {
        userMgrService.setComment(params)
        redirect(action: searchConsumer, params: params)
    }
    //---2009-4-27 新增 exportExecl 闭包 ，将查询结果导出Execl
    @ActionNameAnnotation(name = "查询结果中导出Execl")
    def exportExecl() {
        //---调用search 获得记录，倒出Execl
        def searchList = userMgrService.search(params);
        return [searchList: searchList, params: params]
    }

    //--2009-6-12 优化 loadGroupEdit  编辑用户时以，导入或导入出操作
    /*def loadGroupEdit = {

        def groupIdList = params.groupIdList
        def consumer = Consumer.get(params.id)
        def inout = params.inout
        if (groupIdList instanceof String) groupIdList = [params.groupIdList]
        groupIdList?.each { id ->                                            //循环组列表
            def group = UserGroup.get(id)
            if (inout == "load")                                            //判断页面传入的inout标记，load 加入组，unload 导出组
            {
                group.addToConsumers(consumer)
            }
            if (inout == "unload") {
                group.removeFromConsumers(consumer)
            }
        }
    }
*/
    @PatternNameAnnotation(name = "高校管理")
    @ActionNameAnnotation(name = "部门设置")
    def collegeList() {
        [editPage: params.editPage]
    }

    @PatternNameAnnotation(name = "高校管理")
    @ActionNameAnnotation(name = "部门列表检索")
    def collegeList2() {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "id";
        List<College> collegeList = College.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            if (params.name) {
                like("name", "%" + params.name + "%")
            }
        }
        def total = collegeList.totalCount;
        result.page = page;
        //总记录数
        result.records = total;
        //总页数
        result.total = Math.ceil(total * 1.00 / params.max);
        result.rows = [];
        collegeList.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.name;
            tmp.description = it.description;
            result.rows.add(tmp);
        }

        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "高校管理")
    @ActionNameAnnotation(name = "高校保存")
    def collegeSave() {
        def result = [:];
        result = userMgrService.saveCollege(params);
        if (result.success) {
            flash.message = result.message
            redirect(action: "collegeList")
        } else {
            render(view: 'collegeList', model: [college: result.college])
        }
    }

    @PatternNameAnnotation(name = "高校管理")
    @ActionNameAnnotation(name = "高校更新")
    def collegeUpdate() {
        def result = [:];
        result = userMgrService.updateCollege(params);
        if (result.noFind) {
            flash.message = result.message;
            redirect(action: "collegeList")
        } else {
            if (result.success) {
                redirect(action: "collegeList")
            } else {
                render(view: 'collegeList', model: [college: result.college])
            }
        }
    }

    /**
     * 部门名称重复校验
     */
    @PatternNameAnnotation(name = "高校管理")
    @ActionNameAnnotation(name = "部门名称重复校验")
    def checkCollegeName() {
        def result = [:];
        result = userMgrService.checkCollegeName(params);
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "高校管理")
    @ActionNameAnnotation(name = "高校删除")
    def collegeDelete() {
        def result = [:];
        result = userMgrService.deleteCollege(params);
        return render(result as JSON)
    }

    //---2009-11-5 新增 masterEdit  编辑超级管理员
    @PatternNameAnnotation(name = "Mater管理")
    @ActionNameAnnotation(name = "Mater管理")
    def masterEdit() {
        if (session.consumer?.role == Consumer.SUPER_ROLE) {
            def master = Consumer.findByName('master');
            return [master: master, collegeList: College.list()];
        } else {
            redirect(action: 'index');
        }
    }

    @ActionNameAnnotation(name = "更新超级管理员")
    def masterUpdate() {
        if (session.consumer?.role == Consumer.SUPER_ROLE) {
            def result = [:];
            result = userMgrService.masterUpdate(params);
            if (result.success) {
                flash.message = result.message
                redirect(action: "masterEdit");
            } else {
                render(view: 'masterEdit', model: [master: result.master])
            }
        } else {
            redirect(action: 'index');
        }

    }
    //角色管理
    @PatternNameAnnotation(name = "角色管理")
    @ActionNameAnnotation(name = "权限管理")
    def roleManager() {
        def result = [:];
        result = userMgrService.roleManagerOther(params);
        List<SecurityResource> resourceList = [];
        Role role = null;
        def total;
        if(params.roleId){
            role = Role.get(params.roleId as Long)
            resourceList=SecurityResource.createCriteria().list(max:params.max,offset:params.offset){
                roles {
                    eq('id',params.roleId as Long)
                }
            }
            total = resourceList.totalCount;
            return render(view: 'roleManager', model: [total: total, role:role,resourceList:resourceList,roles: result.roles, msg: params.msg, resources: result.resources])
        }else{
            return render(view: 'roleManager', model: [roles: result.roles, msg: params.msg, resources: result.resources])
        }


    }

    @PatternNameAnnotation(name = "角色管理")
    @ActionNameAnnotation(name = "附加action展示")
    def appendActionNameList() {
        def result = userMgrService.appendActionNameList(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "角色管理")
    @ActionNameAnnotation(name = "角色树")
    def listRoleTree() {
        def result = userMgrService.roleManager(params);
        List<Role> roleList = result.roleList;
        return render(roleList as JSON)
    }

    @PatternNameAnnotation(name = "用户组角色")
    @ActionNameAnnotation(name = "用户组角色用角色树")
    def listRoleTreeForUserGroup() {
        def result = userMgrService.roleManager(params);
        List<Role> roleList = result.roleList;
        return render(roleList as JSON)
    }

    @PatternNameAnnotation(name = "用户角色")
    @ActionNameAnnotation(name = "用户角色用角色树")
    def listRoleTreeForUser() {
        def result = userMgrService.roleManager(params);
        List<Role> roleList = result.roleList;
        return render(roleList as JSON)
    }

    @PatternNameAnnotation(name = "角色管理")
    @ActionNameAnnotation(name = "创建角色")
    def roleCreate() {
        def result = userMgrService.createRole(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "角色管理")
    @ActionNameAnnotation(name = "删除角色")
    def roleDelete() {
        def result = userMgrService.deleteRole(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "角色管理")
    @ActionNameAnnotation(name = "更新角色")
    def roleUpdate() {
        def result = userMgrService.updateRole(params);
        return render(result as JSON)
    }
    //角色增加权限
    @PatternNameAnnotation(name = "角色管理")
    @ActionNameAnnotation(name = "角色增加权限")
    def resourceCreate() {
        def result = userMgrService.createResource(params);
        return redirect(action: 'roleManager', params: [msg: result.msg])
    }

    @PatternNameAnnotation(name = "角色管理")
    @ActionNameAnnotation(name = "移除权限")
    def resourceRemove() {
        def result = userMgrService.removeResource(params);
        return render(result as JSON)
    }

//    @ActionNameAnnotation(name = "创建权限异步")
//    def createResourceAjax() {
//        params.max = 10;
//        params.offset = 0;
//        def result = userMgrService.createResourceAjax(params);
//        result.appendHtml+="${paginate(action: 'roleManager',controller: 'userMgr',params: [max:params.max,offset:params.offset,roleId:result.roleId],total: result.total)}"
//        return render(result as JSON)
//    }

    @PatternNameAnnotation(name = "角色管理")
    @ActionNameAnnotation(name = "用户角色权限列表")
    def resourceList(){
        params.max = 10;
        params.offset = 0;
        def result = userMgrService.resourceList(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "用户组角色")
    @ActionNameAnnotation(name = "用户组管理")
    def userGroupRole() {
        if (!params.max) params.max = 10;
        if (!params.offset) params.offset = 0;
        if (!params.msg) params.msg = ''
        List<UserGroup> userGroups = UserGroup.createCriteria().list(max: params.max, offset: params.offset) {
            if (params.roleId) {
                eq("role", Role.get(params.roleId as Long))
            }
        };
        def total = userGroups.totalCount;
        return render(view: 'userGroupRole', model: [userGroups: userGroups, total: total, msg: params.msg])
    }

    @PatternNameAnnotation(name = "用户组角色")
    @ActionNameAnnotation(name = "创建用户组角色")
    def userGroupRoleCreate() {
        def result = userMgrService.createUserGroupRole(params);
        if (result.success) {
            return redirect(action: 'userGroupRole')
        } else {
            return redirect(action: 'userGroupRole', params: [msg: result.msg])
        }
    }

    @PatternNameAnnotation(name = "用户组角色")
    @ActionNameAnnotation(name = "移动用户组")
    def userGroupMove() {
        def result = userMgrService.moveUserGroup(params);
        if (result.success) {
            return redirect(action: 'userGroupRole')
        } else {
            return redirect(action: 'userGroupRole', params: [msg: result.msg])
        }

    }

    @PatternNameAnnotation(name = "用户组角色")
    @ActionNameAnnotation(name = "用户组异步")
    def userGroupsAjax() {
        if (!params.max) params.max = 10;
        if (!params.offset) params.offset = 0;
        def result = userMgrService.userGroupList(params);
        def total = result.total;
        result.page = "${paginate(total: total, action: 'userGroupRole', controller: 'userMgr', params: [roleId: params.roleId])}";
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "用户组角色")
    @ActionNameAnnotation(name = "移除用户组")
    def userGroupRemove() {
        List<UserGroup> userGroups = UserGroup.list();
        def result = userMgrService.removeUserGroup(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "用户角色")
    @ActionNameAnnotation(name = "用户管理")
    def consumerRole() {
        if (!params.max) params.max = 10;
        if (!params.offset) params.offset = 0;
        if (!params.msg) params.msg = '';
        List<Consumer> consumers = Consumer.createCriteria().list(max: params.max, offset: params.offset) {
            if (params.roleId) {
                eq("userRole", Role.get(params.roleId as Long))
            }
            order('id', 'asc')
        };
        def total = consumers.totalCount;
        return render(view: 'consumerRole', model: [consumers: consumers, total: total, msg: params.msg])
    }

    @PatternNameAnnotation(name = "用户角色")
    @ActionNameAnnotation(name = "用户角色异步")
    def consumerRoleAjax() {
        if (!params.max) params.max = 10;
        if (!params.offset) params.offset = 0;
        def result = userMgrService.consumerRoleAjax(params);
        def total = result.total;
        result.page = "${paginate(total: total, action: 'consumerRole', controller: 'userMgr', params: [roleId: params.roleId])}";
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "用户角色")
    @ActionNameAnnotation(name = "创建用户角色")
    def consumerRoleCreate() {
        def result = userMgrService.createConsumerRole(params);
        if (result.success) {
            return redirect(action: 'consumerRole')
        } else {
            return redirect(action: 'consumerRole', params: [msg: result.msg])
        }

    }

    @PatternNameAnnotation(name = "用户角色")
    @ActionNameAnnotation(name = "移动用户组")
    def consumerRoleMove() {
        def result = userMgrService.moveConsumerRole(params);
        if (result.success) {
            return redirect(action: 'consumerRole')
        } else {
            return redirect(action: 'consumerRole', params: [msg: result.msg])
        }
    }

    @PatternNameAnnotation(name = "用户角色")
    @ActionNameAnnotation(name = "删除用户")
    def consumerRemove() {
        def result = userMgrService.removeConsumer(params);
        return render(result as JSON)
    }

    //2014-04-11 进入添加用户组页面
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "添加用户组")
    def userGroupAdd() {

    }

    //2014-04-11 进入修改用户组页面
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "修改用户组")
    def userGroupEdit() {
        if (!params.groupId) params.groupId = 0;
        def userGroupInstance = UserGroup.get(params.groupId);
        if (userGroupInstance) {
            return render(view: 'userGroupEdit', model: [userGroupInstance: userGroupInstance, groupId: params.groupId, editPage: params.editPage])
        } else {
            redirect(action: "userGroupList")
        }
    }

    //2014-04-11 进入添加部门页面
    @PatternNameAnnotation(name = "高校管理")
    @ActionNameAnnotation(name = "添加部门")
    def collegeAdd() {

    }

    //2014-04-11 进入修改部门页面
    @PatternNameAnnotation(name = "高校管理")
    @ActionNameAnnotation(name = "修改部门")
    def collegeEdit() {
        if (!params.updateId) params.updateId = 0;
        def collegeInstance = College.get(params.updateId);
        if (collegeInstance) {
            return render(view: 'collegeEdit', model: [collegeInstance: collegeInstance, collegeId: params.updateId, editPage: params.editPage])
        } else {
            redirect(action: "collegeList")
        }
    }

    //2014-04-11 修改用户状态
    @PatternNameAnnotation(name = "用户列表")
    @ActionNameAnnotation(name = "修改用户状态")
    def operaConsumer() {
        def result = userService.operaConsumer(params);
        return render(result as JSON)

    }
    //2014-04-11 用来根据查询条件查询用户
    @PatternNameAnnotation(name = "用户列表")
    @ActionNameAnnotation(name = "根据查询条件查询用户")
    def consumerList() {
        params.userRole = session.userRole;
        def result = userService.consumerList(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    //2014-04-14 重置密码
    @PatternNameAnnotation(name = "用户列表")
    @ActionNameAnnotation(name = "重置密码")
    def consumerPwdEdit() {
        def consumerInstance = Consumer.get(params.id);
        //判断，如果当前不是master且修改的不是master，那就过，或者当前用户是master在修改
        if (consumerInstance && (consumerInstance.role != Consumer.SUPER_ROLE && session.consumer.role != Consumer.SUPER_ROLE || session.consumer.role == Consumer.SUPER_ROLE)) {
            return render(view: 'consumerPwdEdit', model: [consumerInstance: consumerInstance, consumerId: params.id])
        } else {
            redirect(action: "userList")
        }
    }

    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "个人用户组列表")
    def userGroupListShow() {
        def result = userService.userGroupList(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @ActionNameAnnotation(name = "删除个人用户组")
    def userGroupDelete() {
        def result = userService.deleteUserGroup(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "用户列表")
    @ActionNameAnnotation(name = "重置密码")
    def consumerPwdUpdate() {
        def id = params.id;
        def oldPwd = params.oldPwd;
        def newPassword = params.newPassword;
        def conformPassword = params.conformPassword;
        if (id) {
            Consumer consumer = Consumer.get(params.id as Long);
            //判断，如果当前不是master且修改的不是master，那就过，或者当前用户是master在修改
            if (consumer && (consumer.role != Consumer.SUPER_ROLE && session.consumer.role != Consumer.SUPER_ROLE || session.consumer.role == Consumer.SUPER_ROLE)) {
                if (oldPwd == newPassword || oldPwd == conformPassword) {
                    flash.message = "新旧密码一样,请重新输入密码！";
                    return redirect(action: 'consumerPwdEdit', params: [id: params.id])
                } else if (newPassword != conformPassword) {
                    flash.message = "两次密码不一致,请重新输入！";
                    return redirect(action: 'consumerPwdEdit', params: [id: params.id])
                }
                consumer.password = newPassword.encodeAsPassword();
                if (consumer.save(flush: true) && (!consumer.hasErrors())) {
                    return render(view: 'index')
                } else {
                    return redirect(action: 'consumerPwdEdit', params: [id: params.id])
                }
            }
        }
        //如果不在判断之内，转跳userList主页
        return redirect(action: "userList")
    }

    @PatternNameAnnotation(name = "角色管理")
    @ActionNameAnnotation(name = "权限下载")
    def exportResource() {
        def result = [:];
        List<SecurityResource> resourceList = SecurityResource.list();
        List<String> str = new ArrayList<String>();
        List<SecurityResource> newResources = new ArrayList<SecurityResource>();
        resourceList.each { SecurityResource resource ->
            str.add(resource.controllerEnName + "-" + resource.actionEnName);
        }
        //过滤掉重复数据
        Set set = new HashSet();
        set.addAll(str);
        Iterator it = set.iterator();
        while (it.hasNext()) {
            String[] strings = it.next().toString().split("-");
            SecurityResource resource1 = SecurityResource.findByControllerEnNameAndActionEnName(strings[0], strings[1]);
            newResources.add(resource1);
        }

        StringBuffer buffer = new StringBuffer();
        def rowValue1 = ["id", "actionEnName", "actionName", "controllerName", "controllerEnName"] as String[];
        buffer.append("id,actionEnName,actionName,controllerName,controllerEnName;")
        for (int i = 0; i < newResources.size(); i++) {
            SecurityResource resource = newResources.get(i);
            String rowValue = resource.id.toString() + "," + resource.actionEnName + "," + resource.actionName + "," + resource.controllerName + "," + resource.controllerEnName
            if (i == newResources.size() - 1) {
                buffer.append(rowValue)
            } else {
                buffer.append(rowValue + ";")
            }
        }
        InputStream input = new ByteArrayInputStream(buffer.toString().getBytes());
        response.setContentType("application/octet-stream");
        response.setContentLength(input.available());
        response.setHeader("Content-disposition", "attachment;filename=security_resource.csv");
        response.outputStream << input
    }

    //设置用户组的用户能否点播资源
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "设置用户组的用户能否点播资源")
    def userGroupConsumersIsCanPlay() {
        def result = userService.userGroupConsumersIsCanPlay(params);
        return render(result as JSON)
    }

    //设置用户组的用户能否下载资源
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "设置用户组的用户能否下载资源")
    def userGroupConsumersIsCanDownload() {
        def result = userService.userGroupConsumersIsCanDownload(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "添加可点播资源")
    def addCanPlayProgram() {
        return render(view: 'addCanPlayProgram', model: [groupId: params.groupId, editPage: params.editPage])
    }

    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "添加可下载资源")
    def addCanDownloadProgram() {
        return render(view: 'addCanDownloadProgram', model: [groupId: params.groupId, editPage: params.editPage])
    }

    //设置用户组可点播资源
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "设置用户组可点播资源")
    def playProgramAdd() {
        def result = userService.addPlayPrograms(params)
        return render(result as JSON)
    }

    //设置用户组可下载资源
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "设置用户组可下载资源")
    def downloadProgramAdd() {
        def result = userService.addDownloadPrograms(params)
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "查看可点播资源")
    def canPlayProgramList() {
        return render(view: 'canPlayProgramList', model: [groupId: params.groupId, kind: 1, editPage: params.editPage])
    }

    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "查看可下载资源")
    def canDownloadProgramList() {
        return render(view: 'canDownloadProgramList', model: [groupId: params.groupId, kind: 2, editPage: params.editPage])
    }

    //根据kind 1-可点播 2-可下载 查询资源
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "查询资源")
    def canOptionProgramList() {
        def result = userService.canOptionProgramList(params)
        response.setContentType("text/json");
        return render(result as JSON)
    }

    //移除用户组可点播或可下载的资源
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "移除用户组可点播或可下载的资源")
    def userGroupProgramRemove() {
        def result = userService.removeCanOptionProgram(params)
        response.setContentType("text/json");
        return render(result as JSON)
    }

    //根据条件，查询不在用户组内的用户
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "查询不在用户组内的用户")
    def consumerList2() {
        def result = userService.consumerList2(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    //向用户组添加用户
    @PatternNameAnnotation(name = "用户组管理")
    @ActionNameAnnotation(name = "向用户组添加用户")
    def userGroupConsumerAdd() {
        def result = userService.userGroupConsumerAdd(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "用户列表")
    @ActionNameAnnotation(name = "上传库操作")
    def consumerInDirectory () {
        def  classIdList = params.classList
        def consumer=Consumer.get(params.consumerId as long);
        def inout=params.inout
        if(classIdList instanceof String) classIdList = [params.classList]
        classIdList?.each { id ->											//循环组列表
            def category=ProgramCategory.get(id)
            if(category) {
                if (inout=="in")											//判断页面传入的inout标记，load 加入组，unload 导出组
                {
                    consumer.addToProgramCategorys(category);
                }
                if (inout=="out")
                {
                    consumer.removeFromProgramCategorys(category);
                }
            }
        }
        consumer.save(flush: true)
        params.id = params.consmuerId;
        return redirect(action: "userEdit", params: params)
    }
}
