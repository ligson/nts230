package nts.user.services

import grails.converters.JSON
import nts.activity.domain.ActivitySharing
import nts.activity.domain.WorkVote
import nts.commity.domain.ForumBoard
import nts.commity.domain.ForumMember
import nts.commity.domain.ForumSharing
import nts.commity.domain.StudyCommunity
import nts.note.domain.NoteRecommend
import nts.note.domain.ProgramNote
import nts.program.domain.CourseAnswer
import nts.program.domain.CourseQuestion
import nts.program.domain.Program
import nts.program.domain.ProgramTag
import nts.program.domain.ProgramTopic
import nts.program.domain.Remark
import nts.program.domain.RemarkScore
import nts.studycircle.domain.Participant
import nts.studycircle.domain.StudyCircle
import nts.system.domain.Errors
import nts.system.domain.Message
import nts.system.domain.News
import nts.system.domain.OperationEnum
import nts.system.domain.OperationLog
import nts.user.domain.ByteEnum
import nts.user.domain.College
import nts.user.domain.Consumer
import nts.user.domain.ConsumerSubject
import nts.user.domain.Role
import nts.user.domain.SecurityResource
import nts.user.domain.Topic
import nts.user.domain.TopicContent
import nts.user.domain.UserGroup
import nts.user.file.domain.FilePoster
import nts.user.file.domain.FileRemark
import nts.user.file.domain.FileScore
import nts.user.file.domain.RemarkComment
import nts.user.file.domain.UserCategory
import nts.user.file.domain.UserFile
import nts.user.file.domain.UserFileTag
import nts.user.special.domain.SpecialComment
import nts.user.special.domain.SpecialFile
import nts.user.special.domain.SpecialFileRemark
import nts.user.special.domain.SpecialPoster
import nts.user.special.domain.SpecialScore
import nts.user.special.domain.SpecialTag
import nts.user.special.domain.UserSpecial
import nts.utils.CTools
import org.springframework.web.multipart.commons.CommonsMultipartFile

import javax.servlet.http.HttpSession
import java.text.DateFormat
import java.text.SimpleDateFormat

class UserService {

    def utilService
    def programMgrService
    //初始化master
    public void initMaster() {
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

    /**
     * 用户登陆
     * @param params
     *      name:用户名(必须)
     *      nowDate:当前时间（必须）
     *      password:密码（必须）
     * @return result
     *      result返回集合参数
     *      success:是否登陆成功
     *      msg:返回信息
     *      loginFlg:用户状态
     *      approvalAlert：管理审批提醒
     *      key：consumer ID
     */
    public Map checkLogin(Map params) {
        def result = [:];
        result.success = false;
        result.msg = null;
        def servletContext = utilService.getServletContext();
        def session = utilService.getSession();
        def consumer = Consumer.findByName(params.loginName)
        if (consumer) {
            def nowDate = params.nowDate;
            def dateValid = consumer.dateValid.toString()
            if (nowDate > dateValid) {                                // 判断用户是否已过有效期
                result = [success: false, msg: "用户已过有效期", loginFlg: 2];
            } else if (consumer.isRegister) {                                //判断用户是否是锁定状态
                result = [success: false, msg: "用户是锁定状态", loginFlg: 7];
            } else if (!consumer.userState) {                                //判断用户是否是锁定状态
                result = [success: false, msg: "用户是锁定状态", loginFlg: 4];
            } else {
                //匿名用户不用验证密码了，因为匿名用户用户名密码是硬编码的，如果管理员将匿名密码改了，则不能匿名登录了
                //println consumer.password +"=="+ params.password
                if (consumer.password == params.password || consumer.password == params.password.encodeAsPassword() || consumer.name == 'anonymity') {
                    servletContext.programCount = Program.countByStateGreaterThan(Program.APPLY_STATE)
                    def programPlaySum = Program.createCriteria().get {
                        projections {
                            sum "frequency"
                        }
                    }
                    def programDownloadSum = Program.createCriteria().get {
                        projections {
                            sum "downloadNum"
                        }
                    }

                    //println programViewSum
                    //---获得节目点播次数 sum
                    servletContext.programPlaySum = programPlaySum
                    //---获得节目访问次数 sum
                    servletContext.programDownloadSum = programDownloadSum
                    if (consumer.name != 'anonymity') {
                        Consumer.withTransaction {
                            consumer.loginNum = consumer.loginNum + 1
                            consumer.dateLastLogin = new Date()
                            consumer.save();
                        }
                        //---将登陆信息写入日志 nts.system.domain.OperationLog
                        new OperationLog(tableName: 'consumer', tableId: consumer.id, operator: consumer.name, modelName: '用户登陆', brief: '登陆操作', operatorId: consumer.id, operation: OperationEnum.LOGIN).save()

                        //管理员审批提醒
                        if (consumer.role <= Consumer.MANAGER_ROLE) {
                            def program = Program.find("from nts.program.domain.Program as a where a.state = ?", [Program.APPLY_STATE])
                            if (program) result.approvalAlert = true
                        }
                        //获取登录用户的未读消息数量
                        def messageNoReadCount = Message.countByStateAndReceiveConsumerID(0, consumer.id)
                        session.messageNoReadCount = messageNoReadCount
                    }
                    session.consumer = consumer
                    result = [success: true, key: consumer.id];
                } else {
                    result = [success: false, msg: "用户不存在或者密码错误！", loginFlg: 1];
                }
            }
        } else {
            result = [success: false, msg: "用户不存在或者密码错误！", loginFlg: 1];
        }
        return result;
    }

    /**
     * 用户注册
     * @param params
     *      chkPassword:确认密码(必须)
     *      name:用户名(必须)
     *      nickname：昵称（必须）
     *      password：用户密码（必须）
     *
     *      Jobs:(非必须)
     *      idCard：身份证号（非必须）
     *      trueName：真实姓名（非必须）
     *      profession:用户专业（非必须）
     *      jobName:用户职称（非必须）
     *      descriptions:用户描述信息（非必须）
     *      gender：用户性别（非必须，默认1男）
     *      userJob:用户工作&身份（非必须,默认16学生）
     *      telephone:联系电话（非必须）
     *      userEducation:用户学历（非必须，默认1本科)
     *      email:邮箱（非必须）
     *      role：用户角色（非必须，默认学生）
     *      college：所属院系（非必须）
     *      dateValid：有效时间（非必须，默认2080-11-11）
     *      dateEnterSchool：入学时间（非必须，默认当前时间）
     * @return result
     *      result返回集合参数
     *      msg：返回消息
     *      name：用户名
     *      isOK：是否成功
     *      consumer：保存失败后返回consumer对象，包含保存错误信息
     */
    public Map register(Map params) {
        def result = [:];
        result.success = false;
        result.msg = null;

        def isOK = false
        def uploadState = Consumer.NO_UPLOAD_STATE                    //是否上传 0-否 1-是 2-审请中  用户默认是0 管理员是1
        def canDownload = false            //是否下载 0-否 1-是 用户默认是0 管理员是1
        def userState = 1                    //用户状态  0-禁用 1-活动 禁用后不可点播节目
        def canComment = true
        //是否可以发表评论 0-否 1-是 默认是1							//用户角色 0-Master(超级管理员)  1-部门管理员（可对节目和用户操作）2-普通管理员（只对节目操作）3-用户
        def notExamine = false
        def isRegister = true

        //特殊的
        params.name = params.name.trim()
        params.nickname = params.nickname.trim()
        params.password = params.password.trim()
        params.chkPassword = params.chkPassword.trim()
        if (params.password.equals(params.chkPassword)) {
            params.password = params.password.encodeAsPassword()
            if (params.role < Consumer.TEACHER_ROLE) params.role = Consumer.STUDENT_ROLE
            def college = College.get(params.college);
            if(college) {
                params.college = college
            }
            params.dateValid = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(params.dateValid)
            if (params.dateEnterSchool && params.dateEnterSchool != "") params.dateEnterSchool = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(params.dateEnterSchool)
            def consumer = new Consumer()
            consumer.properties = params
            //默认的
            consumer.uploadState = uploadState
            consumer.canDownload = canDownload
            consumer.userState = userState
            consumer.canComment = canComment
            consumer.notExamine = notExamine
            consumer.dateModified = new Date()
            consumer.isRegister = isRegister

            // 设置个人空间
            consumer.spaceSize=2;
            consumer.spaceSizeUnit= ByteEnum.GIGA.id;
            Long unitSize = Math.pow(1024,consumer.spaceSizeUnit as int) as Long
            consumer.maxSpaceSize = (consumer.spaceSize as Long) * unitSize
            consumer.useSpaceSize=0;

            if (consumer.save()) {
                result.success = true
                result = [name: params.name,id: consumer.id, isOK: result.success];
                new OperationLog(tableName: 'consumer', tableId: consumer.id, operator: params.consumer.name, operatorIP: params.request.getRemoteAddr(),
                        modelName: '注册用户', brief: consumer.name, operatorId: params.consumer.id, operation: OperationEnum.ADD_USER).save(flush: true)
            } else {
                //consumer.errors.allErrors.each { println it }
                result = [consumer: consumer, isOK: result.success];
            }
        }
        return result;
    }
    /**
     * 用户修改
     * @param params
     *      modifyFrom:判断前后台修改，'user'前台修改，'admin'后台修改
     *      id：Consumer的Id（必须，前后台都需要）
     *      email：用户电子邮件(非必须，前后台都需要)
     *      gender：用户性别（非必须，前后台都需要，默认1男）
     *      nickname：昵称（必须，前后台都需要）
     *
     *      Jobs（非必须）
     *      inout（非必须）
     *      offset（非必须）
     *      roleList：（非必须）
     *      searchName（非必须）
     *      searchNickName（非必须）
     *      searchTrueName（非必须）
     *      searchCollege（非必须）
     *
     *      sort:排序方式（非必须）
     *      order：排序依據（非必须）
     *      max：最大顯示條數（非必须）
     *      userRole：用戶角色（非必须）
     *      canComment:是否可以发表评论(非必须，后台修改使用)
     *      zc:用户职称（非必须，后台修改使用）
     *      profession：用户专业（非必须，后台修改使用）
     *      jobName：用户职称（非必须，后台修改使用）
     *      descriptions:用户描述信息（非必须，后台修改使用）
     *      userState：用户状态（非必须，后台修改使用）
     *      chkPassword：核对密码（非必须，后台修改使用）
     *      notExamine：审核状态上传节目是否审核（非必须，后台修改使用）
     *      canDownload:是否下载（非必须，后台修改使用）
     *      modPassword:用户密码（非必须，后台修改使用）
     *      userRole2:用戶角色（非必须，后台修改使用）
     *      telephone:联系电话(非必须，后台修改使用）
     *      role:用户角色（非必须，后台修改使用）
     *      userJob:用户工作&身份（非必须，后台修改使用）
     *      userEducation:用户学历（非必须，后台修改使用）
     *      idCard:身份证号（非必须，后台修改使用）
     *      uploadState:是否上传（非必须，后台修改使用）
     *      trueName:真实姓名（非必须，后台修改使用）
     *      UdateValid：有效期（非必须，后台修改使用）
     *      modPassword：用户修改密码（非必须，后台修改使用）
     *      college.id：用户所属学院 Id（非必须，后台修改使用）
     * @return result
     *      前台result返回集合参数
     *      success:修改成功true，没成功false
     *      consumer：consumer对象
     *      noFindConsumer：未找到Consumer未true
     *
     *      后台result返回集合参数
     *      success:修改成功true，没成功false
     *      consumer：consumer对象
     *      offset：排序方式
     *      sort:排序方式
     *      order:排序依據
     *      max:最大顯示條數
     *      userRole:用戶角色
     *      roleList:
     *      searchName:
     *      searchNickName:
     *      searchTrueName:
     *      searchCollege:
     *      noFindConsumer:是否存在该Consumer，不存在为true
     *
     */
    public Map modify(Map params) {
        def result = [:];
        if (params.modifyFrom == "user") {
            result = this.modifyFromUser(params);
        }
        if (params.modifyFrom == "admin") {
            result = this.modifyFromAdmin(params);
        }

        return result;
    }
    //前台修改用户信息,用户修改自己信息
    private Map modifyFromUser(Map params) {
        def result = [:];
        def session = utilService.getSession();
        result.success = false;
        result.msg = null;
        def consumer = Consumer.get(params.id)
        if (consumer && consumer.id == session.consumer.id) {
            if (params.nickname)
                consumer.nickname = params.nickname
            if (params.email)
                consumer.email = params.email
            if (params.gender == "1") {
                consumer.gender = 1;
            }
            if (params.gender == "0") {
                consumer.gender = 0;
            }
            if (params.address) {
                consumer.address = params.address;
            }
            if (params.descriptions) {
                consumer.descriptions = params.descriptions;
            }
            if (!consumer.hasErrors() && consumer.save()) {
                session.consumer = consumer
                result.success = true;
                result.consumer = consumer;
                new OperationLog(tableName: 'consumer', tableId: consumer.id, operator: consumer.name, operatorIP: params.request.getRemoteAddr(),
                        modelName: '修改用户', brief: "本人修改" + consumer.name, operatorId: consumer.id, operation: OperationEnum.EDIT_USER).save(flush: true)
            } else {
                result = [success: false, consumer: consumer];
            }
        } else {
            result.noFindConsumer = true;
        }
        return result;
    }
    //后台用户信息修改,管理员修改用户
    private Map modifyFromAdmin(Map params) {
        def result = [:];
        def session = utilService.getSession();
        result.success = false;
        result.msg = null;
        def dateEnterSchool = params.UdateEnterSchool
        def dateValid = params.UdateValid
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        def consumer = Consumer.get(params.id)
        if (consumer) {
            consumer.properties = params
            consumer.userRole = null;
            //---判断用户是否修改密码，
            if (params.modPassword) {
                //--- 加密后修改密码
                consumer.password = params.modPassword.encodeAsPassword()
            }
            if (params.nickname) {
                UserGroup.executeUpdate("update nts.user.domain.UserGroup c set creator='${params.nickname}'  where c.consumer=${consumer.id}  ")
            }
            def id = params.college.id;
            //注册的时候，可能没有college，这里选择要判断下
            if (id != null && id != "") {
                consumer.college = College.findById(Long.parseLong(id))
            }
            if (dateEnterSchool) {
                java.util.Date date = sdf.parse(dateEnterSchool);
                consumer.dateEnterSchool = date
            }
            if (dateValid) {
                java.util.Date v_date = sdf.parse(dateValid);
                consumer.dateValid = v_date
            }

            // 设置用户空间大小
            if(params.spaceSize){
                Long unitSize = Math.pow(1024,params.spaceSizeUnit as int) as Long
                Long spaceSize = params.spaceSize as Long;
                Long maxSpaceSize = spaceSize * unitSize;
                if(maxSpaceSize < consumer.useSpaceSize){
                    result.success = false;
                    result.consumer = consumer;
                    result.msg = "设置的空间小于已经使用的空间，请重新设置！";
                    return result;
                }
                consumer.spaceSize = spaceSize;
                consumer.descriptions = params.descriptions;
                consumer.maxSpaceSize = maxSpaceSize;
            }

            if (!consumer.hasErrors() && consumer.save(flush: true)) {
                new OperationLog(tableName: 'consumer', tableId: consumer.id, operator: params.consumer.name, operatorIP: params.request.getRemoteAddr(),
                        modelName: '修改用户', brief: consumer.name, operatorId: params.consumer.id, operation: OperationEnum.EDIT_USER).save(flush: true)
                result.success = true;
                result = [success: true, consumer: consumer, offset: params.offset, sort: params.sort, order: params.order, max: params.max, userRole: params.userRole, roleList: params.roleList, searchName: params.searchName, searchNickName: params.searchNickName, searchTrueName: params.searchTrueName, searchCollege: params.searchCollege];

            } else {
                result = [success: false, consumer: consumer];
            }

        } else {
            result.noFindConsumer = true;
        }
        return result;
    }
    /**
     * 修改用户密码
     * @param params
     *      chkPassword：二次输入密码（必须）
     *      newPassword:新密码（必须）
     *      password:旧密码(必须)
     * @return
     * success：是否修改成功，true为修改成功，false反之
     *      consumer：修改返回consumer对象
     */
    public Map modifyUserPassword(Map params) {
        def result = [:];
        def session = utilService.getSession();
        result.success = false;
        result.msg = null;
        int id = session.consumer.id as int;
        Consumer consumer = Consumer.get(id);
        if (consumer) {
            //验证用户原密码是否正确
            if (params.password && consumer.password.equals(params.password.encodeAsPassword())) {
                def newPassword = params.newPassword.trim();
                def chkPassword = params.chkPassword.trim();
                if (newPassword.equals(chkPassword)) {
                    consumer.password = newPassword.encodeAsPassword()
                    if (!consumer.hasErrors() && consumer.save()) {
                        session.consumer = consumer
                        result.success = true;
                    }
                }
            }
            result.consumer = consumer;
        }
        return result;
    }
    /**
     * 上传用户图片
     * @return
     * success：是否修改成功，true为修改成功，false反之
     *      consumer：修改后返回consumer对象
     */
    public Map uploadUserPhoto(CommonsMultipartFile multipartFile) {
        println multipartFile.originalFilename
        def result = [:];
        result.success = false;
        result.msg = null;
        def request = utilService.getRequest();
        def session = utilService.getSession();
        def servletContext = utilService.getServletContext();
        def consumer = Consumer.findById(session.consumer.id);
        if (consumer) {
            //def uploadedFile = request.getFile('myPhoto') //上传图片
            def uploadedFile = multipartFile //上传图片
            def photo = '' //最终存在数据库的图片相对路径
            if (!uploadedFile.empty) {
                def imgExt = CTools.readExtensionName(uploadedFile.originalFilename) //获取扩展名
                photo = System.currentTimeMillis() + "_" + consumer.id + "." + imgExt
                def webRootDir = servletContext.getRealPath("/upload")
                def userDir = new File(webRootDir, "/photo")
                userDir.mkdirs()
                uploadedFile.transferTo(new File(userDir, photo))

                consumer.photo = photo;

                if (!consumer.hasErrors() && consumer.save()) {
                    session.consumer = consumer
                    result.success = true;
                }
            }
        } else {
            result.noFindConsumer = true;
        }
        result.consumer = consumer;
        return result;
    }

    /***
     * 检查用户访问权限
     * @param consumer
     * @param controllerName
     * @param actionName
     * @return true 可以
     *         false 不可以
     */
    public boolean checkResources(Consumer consumer, String controllerName, String actionName) {
        log.debug(consumer.getName() + ",operation:" + controllerName + "-" + actionName);
        HttpSession httpSession = utilService.getSession();
        if (httpSession) {
            Object resources = httpSession.getAttribute("resources");
            if (resources && controllerName && actionName) {
                Map<String, List<String>> controllerActionMap = (Map<String, List<String>>) resources;
                List<String> actionList = controllerActionMap.get(controllerName);
                if (actionList) {
                    if (actionList.contains(actionName)) {
                        return false;
                    }
                }
            }
        }
        return true;
    }
    /***
     * 用户登陆后加载权限到内存
     * @param consumer
     */
    public void syncUserResource(Consumer consumer) {
        HttpSession httpSession = utilService.getSession();
        if (httpSession) {
            Map<String, List<String>> controllerActionMap = new HashMap<String, List<String>>();
            Role role = consumer.userRole;
            if (role) {
                Set<SecurityResource> resources = role.resources;
                resources.each { SecurityResource securityResource ->
                    addResource(securityResource, controllerActionMap);
                }
            }
            consumer.userGroups.each { UserGroup group ->
                Role role1 = group.role;
                if (role1) {
                    Set<SecurityResource> resources = role.resources;
                    resources.each { SecurityResource securityResource ->
                        addResource(securityResource, controllerActionMap);
                    }
                }
            }
            httpSession.setAttribute("resources", controllerActionMap);
        }

    }

    /***
     * 加载权限到集合
     * @param securityResource
     * @param controllerActionMap
     */
    private static void addResource(SecurityResource securityResource, Map<String, List<String>> controllerActionMap) {
        List<String> actionList = controllerActionMap.get(securityResource.controllerEnName);
        if (actionList) {
            if (!actionList.contains(securityResource.actionEnName)) {
                actionList.add(securityResource.actionEnName);
                controllerActionMap.put(securityResource.controllerEnName, actionList);
            }
        } else {
            actionList = new ArrayList<String>();
            actionList.add(securityResource.actionEnName);
            controllerActionMap.put(securityResource.controllerEnName, actionList);
        }
    }

    /***
     * 判断是否是匿名用户
     * @return true 匿名 false 正常
     */
    public boolean judeAnonymity() {
        Consumer consumer1 = utilService.getCurrentUser();
        if (consumer1) {
            String name = utilService.getServletContext().getAttribute("anonymityUserName");
            return consumer1.name.equals(name)
        } else {
            return true;
        }
    }

    /**
     * 删除用户
     * @return msg 删除成功或不成功
     */
    public Map deleteConsumer(Map params) {
        def result = [:];
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }
        ids.each {
            Consumer consumer = Consumer.get(it as Long);
            if (consumer) {
                try {
                    //1.删除活动相关
                    //删除与用户相关的ActivitySharing
                    def activitySharings = ActivitySharing.findAllByConsumer(consumer)
                    activitySharings?.each {
                        it.delete()
                    }

                    //删除与用户相关的WorkVote
                    def workVotes = WorkVote.findAllByConsumer(consumer)
                    workVotes?.each {
                        it.delete()
                    }

                    //2.删除社区相关
                    //删除与用户相关的ForumMember
                    def forumMembers = ForumMember.findAllByConsumer(consumer)
                    forumMembers?.each {
                        it.delete()
                    }

                    //删除与用户相关的ForumSharing
                    def forumSharings = ForumSharing.findAllByConsumer(consumer)
                    forumSharings?.each {
                        it.delete()
                    }

                    //删除用户创建的社区
                    def communities = StudyCommunity.findAllByCreate_comsumer_id(consumer.id);
                    communities?.each { StudyCommunity community ->
                        // 删除社区下的板块

                        community?.forumBoards?.toList()?.each { ForumBoard board ->
                            community?.removeFromForumBoards(board);
                            def fmembers = ForumMember.findAllByForumBoard(board);
                            if (fmembers && fmembers.size() > 0) {
                                fmembers.each { ForumMember m ->
                                    m.delete();
                                }
                            }
                            def fSharings = ForumSharing.findAllByForumBoard(board);
                            if (fSharings && fSharings.size() > 0) {
                                fSharings.each { ForumSharing s ->
                                    s.delete();
                                }
                            }
                            board.delete();
                        }
                        //循环该用户所创建的社区有多少个用户
                        community?.members?.toList()?.each {
                            //删除与members对像的关系
                            it.removeFromMemberCommunitys(community);
                        }
                        //删除community对像实列
                        community.delete()
                    }

                    //3.删除笔记相关
                    // 删除用户笔记相关
                    def noteRecommends = NoteRecommend.findAllByConsumer(consumer);
                    noteRecommends?.each {
                        it.delete();
                    }

                    def programNotes = ProgramNote.findAllByConsumer(consumer);
                    programNotes?.each { ProgramNote note ->
                        note?.noteRecommends?.toList()?.each { NoteRecommend recommend ->
                            note?.noteRecommends?.remove(recommend);
                            recommend.delete();
                        }
                        note.delete();
                    }

                    //4.删除学习圈相关
                    //删除与用户相关的参与者
                    def participantList = Participant.findAllByConsumer(consumer)
                    if (participantList && participantList.size() > 0) {
                        participantList?.each { participant ->
                            if (participant) {
                                participant.delete();
                            }
                        }
                    }

                    //删除与用户相关的StudyCircle
                    def studyCircles = StudyCircle.findAllByCreateConsumer(consumer)
                    studyCircles?.each {
                        it.delete()
                    }

                    //5.删除资源相关
                    //删除与用户相关的RemarkScore
                    def remarkScores = RemarkScore.findAllByConsumer(consumer);
                    remarkScores?.each {
                        it.delete();
                    }

                    //删除与用户相关的ProgramTopic
                    def programTopics = ProgramTopic.findAllByConsumer(consumer)
                    programTopics?.each {
                        it.delete()
                    }

                    //5.删除用户专辑相关
                    //删除与用户相关的SpecialComment
                    def specialComments = SpecialComment.findAllByConsumer(consumer)
                    specialComments?.each {
                        it.delete();
                    }

                    def commentComments = SpecialComment.findAllByCommentUser(consumer);
                    commentComments?.each {
                        it.delete();
                    }

                    //删除与用户相关的SpecialFileRemark
                    def specialFileRemarks = SpecialFileRemark.findAllByConsumer(consumer)
                    specialFileRemarks?.each {
                        it?.comments?.toList()?.each { SpecialComment comment ->
                            it?.comments?.remove(comment);
                            comment.delete();
                        }
                        it.delete()
                    }

                    //删除与用户相关的SpecialScore
                    def specialScores = SpecialScore.findAllByConsumer(consumer)
                    specialScores?.each {
                        it.delete()
                    }

                    //删除与用户相关的UserSpecial
                    def userSpecials = UserSpecial.findAllByConsumer(consumer)
                    userSpecials?.each {
                        //删除与UserSpecial相关的SpecialTag
                        def specialTags = SpecialTag.findAllBySpecial(it);

                        specialTags?.each { SpecialTag tag ->
                            tag.delete();
                        }
                        //删除与UserSpecial相关的SpecialPoster
                        def specialPosters = SpecialPoster.findAllBySpecial(it);
                        specialPosters?.each { SpecialPoster poster ->
                            poster.delete();
                        }

                        //删除与用户相关的SpecialScore
                        def scores = SpecialScore.findAllByUserSpecial(it);
                        scores?.each { SpecialScore score ->
                            score.delete();
                        }

                        //删除与用户相关的SpecialScore
                        def specialFiles = SpecialFile.findAllByUserSpecial(it);
                        specialFiles?.each { SpecialFile file ->
                            file?.remarks?.each { SpecialFileRemark remark ->
                                file?.remarks?.remove(remark);
                                remark?.comments.each { SpecialComment comment ->
                                    remark?.comments?.remove(comment);
                                    comment.delete();
                                }
                                remark.delete();
                            }
                            file.delete();
                        }
                        it.delete();
                    }

                    //6.用户文件相关删除
                    //删除与用户相关的RemarkComment
                    def remarkComments = RemarkComment.findAllByConsumer(consumer)
                    remarkComments?.each {
                        it.delete()
                    }

                    //删除与用户相关的FileRemark
                    def fileRemarks = FileRemark.findAllByConsumer(consumer)
                    fileRemarks?.each {
                        //删除与FileRemark相关的RemarkComment
                        def comments = RemarkComment.findAllByRemark(it);
                        comments?.each { RemarkComment comment ->
                            comment.delete();
                        }
                        it.delete();
                    }

                    //删除与用户相关的FileScore
                    def fileScores = FileScore.findAllByConsumer(consumer)
                    fileScores?.each {
                        it.delete()
                    }

                    //删除与用户相关的UserFile
                    def userFiles = UserFile.findAllByConsumer(consumer)
                    userFiles.each {
                        // 删除与UserFile相关的UserFileTag
                        it?.tags?.each { UserFileTag tag ->
                            it?.tags?.remove(tag);
                            tag.delete();
                        }
                        // 删除与UserFile相关的UserFilePoster
                        it?.posters?.each { FilePoster poster ->
                            it?.posters?.remove(poster);
                            poster.delete();
                        }
                        it.delete();
                    }

                    //删除与用户相关的UserCategory
                    def userCategorys = UserCategory.findAllByConsumer(consumer)
                    userCategorys?.each {
                        deleteChildCategoryByCategory(it);
                        it?.userFiles?.each { UserFile file ->
                            it?.userFiles?.remove(file);
                            // 删除与UserFile相关的UserFileTag
                            file?.tags?.each { UserFileTag tag ->
                                file?.tags?.remove(tag);
                                tag.delete();
                            }
                            // 删除与UserFile相关的UserFilePoster
                            file?.posters?.each { FilePoster poster ->
                                file?.posters?.remove(poster);
                                poster.delete();
                            }
                            file.delete();
                        }
                        it.delete()
                    }

                    //7.系统相关删除
                    //删除与用户相关的Errors
                    def errors = Errors.findAllByPublisher(consumer)
                    errors?.each {
                        it.delete()
                    }

                    //删除与用户相关的News
                    def news = News.findAllByPublisher(consumer)
                    news?.each {
                        it.delete()
                    }

                    //8.用户相关删除
                    //根据用户ID，获得该用户所创建的组列表
                    def groupList = UserGroup.findAllByConsumer(consumer.id)
                    //循环该组中的对像
                    groupList.toList().each { group ->
                        //循环该用户所创建的组中有多少个用户
                        group?.consumers?.toList().each {
                            //删除与userGroup对像的关系
                            it.removeFromUserGroups(group)
                            //删除consumer对像实列
                            group.delete()
                        }
                    }

                    //删除与用户相关的ConsumerSubject
                    def consumerSubjects = ConsumerSubject.findAllByConsumer(consumer)
                    consumerSubjects.each {
                        it.delete()
                    }

                    //删除与用户相关的TopicContent
                    def topicContents = TopicContent.findAllByConsumer(consumer)
                    topicContents?.each {
                        it.delete()
                    }

                    //删除与用户相关的Topic
                    def topics = Topic.findAllByConsumer(consumer)
                    topics?.each {
                        it.delete()
                    }

                    //删除与用户相关的Program
                    def programs = consumer.programs;
                    if (programs.size() > 0) {
                        def programList = programs.toList();
                        programList.each { Program program ->
                            programMgrService.deleteFiles(program);
                            programMgrService.deleteProgram2(program)
                            program.delete();
                        }
                    }

                    //删除用户对像
                    consumer.delete();
                    result.success = true;
                    result.msg = "删除成功";
                    new OperationLog(tableName: 'consumer', tableId: consumer.id, operator: params.consumer.name, operatorIP: params.request.getRemoteAddr(),
                            modelName: '删除用户', brief: consumer.name, operatorId: params.consumer.id, operation: OperationEnum.DELETE_USER).save(flush: true)
                } catch (Exception e) {
                    log.debug(e.message);
                    result.success = false;
                    result.msg = "删除失败";
                }
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }
        return result
    }


    private void deleteChildCategoryByCategory(UserCategory category) {
        category?.childCategories?.each { UserCategory childCategory ->
            category?.childCategories?.remove(childCategory);
            deleteChildCategoryByCategory(childCategory);
        }
    }

    /**
     * 用户各种状态的修改
     * @return msg 成功或不成功
     */
    public Map operaConsumer(Map params) {
        def result = [:];
        def idList = params.idList;
        def stateName = params.stateName;
        def isFlag = params.isFlag;
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }

        ids.each {
            Consumer consumer = Consumer.get(it as Long);
            if (consumer) {
                if (stateName == "userState") {
                    if (isFlag == 'true') {
                        consumer.userState = false;
                    } else if (isFlag == 'false') {
                        consumer.userState = true;
                    }
                } else if (stateName == "uploadState") {
                    if (isFlag == (isFlag instanceof String ? "1" : 1)) {
                        consumer.uploadState = 0;
                    } else if (isFlag == (isFlag instanceof String ? "0" : 0)) {
                        consumer.uploadState = 1;
                    }
                } else if (stateName == "canDownload") {
                    if (isFlag == 'true') {
                        consumer.canDownload = false;
                    } else if (isFlag == 'false') {
                        consumer.canDownload = true;
                    }
                } else if (stateName == "canPlay") {
                    if (isFlag == 'true') {
                        consumer.canPlay = false;
                    } else if (isFlag == 'false') {
                        consumer.canPlay = true;
                    }
                } else if (stateName == "canComment") {
                    if (isFlag == 'true') {
                        consumer.canComment = false;
                    } else if (isFlag == 'false') {
                        consumer.canComment = true;
                    }
                } else if (stateName == "isRegister") {
                    if (isFlag == 'true') {
                        consumer.isRegister = false;
                    } else if (isFlag == 'false') {
                        consumer.isRegister = true;
                    }
                }
                if (consumer.save(flush: true) && (!consumer.hasErrors())) {
                    result.success = true;
                    result.msg = "设置成功";
                }
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }
        return result
    }

    /**
     * 用户列表
     * @param params
     * @return
     */
    public Map consumerList(Map params) {
        def result = [:];
        def session = utilService.session;
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "id";
        def name = params.searchName                    //用户帐号
        def college = params.searchCollege                //学生所属院系
        def searchNickName = params.searchNickName        //用户昵称
        def searchTrueName = params.searchTrueName        //用户真实姓名
        def userRole = params.userRole //普通用户 or 超级管理员
        List<Consumer> consumerList = Consumer.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            //帐号为真，添加用户帐户条件
            if (name) {
                name = name.trim()
                like('name', "%${name.toString().decodeURL()}%")
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
            if (college && college != '-1') {
                eq('college', College.get(college))
            }
            //只要当前用户不是超级管理员就，不查master
            if (session.consumer?.role != Consumer.SUPER_ROLE) {
                gt("role", Consumer.SUPER_ROLE)
            }
            //查询资源管理员角色
            if (userRole == 'mg') {
                eq("role", Consumer.MANAGER_ROLE)
            }
            /*if (userRole == 'user') {
                //除超级管理员角色意外的
            } else if (userRole == 'mg') {

            }*/
        }

        if (consumerList.size() > 0) {
            def total = consumerList.totalCount;
            result.page = page;
            //总记录数
            result.records = total;
            //总页数
            result.total = Math.ceil(total * 1.00 / params.max);
            result.rows = [];
            consumerList.each {
                def tmp = [:];
                tmp.id = it.id;
                tmp.name = it.name;
                tmp.nickname = it.nickname;
                tmp.trueName = it.trueName;
                tmp.userState = it.userState;
                tmp.uploadState = it.uploadState;
                tmp.canDownload = it.canDownload;
                tmp.canPlay = it.canPlay;
                tmp.canComment = it.canComment;
                tmp.isRegister = it.isRegister;
                tmp.userRole = it.role;
                result.rows.add(tmp);
            }


        }
        return result
    }

    /**
     * 个人用户组列表
     * @param params
     * @return
     */
    public Map userGroupList(Map params) {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "id";

        List<UserGroup> userGroupList = UserGroup.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
        }

        if (userGroupList.size() > 0) {
            def total = userGroupList.totalCount;
            result.page = page;
            //总记录数
            result.records = total;
            //总页数
            result.total = Math.ceil(total * 1.00 / params.max);
            result.rows = [];
            userGroupList.each {
                def tmp = [:];
                tmp.id = it.id;
                tmp.name = it.name;
                tmp.description = it.description;
                tmp.creator = it.creator;
                tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
                result.rows.add(tmp);
            }
        }
        return result
    }

    /**
     * 修改用户密码
     * @param params
     * @return
     */
    public Map consumerPwdUpdate(Map params) {
        def result = [:];
        result.success = true;
        def consumer = Consumer.get(params.id);
        consumer.password = params.newPassword.encodeAsPassword();

        if (!consumer.hasErrors() && consumer.save()) {
            result.message = "密码重置成功"
        } else {
            result.message = "密码重置失败"
            result.success = false;
            result.consumer = consumer;
        }
        return result;
    }

    /**
     * 个人用户组删除
     * @param params
     * @return
     */
    public Map deleteUserGroup(Map params) {
        def result = [:];
        def delIdList = params.idList
        def userGroup

        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (delIdList instanceof String) {
            if (delIdList.contains(',')) {
                String[] str = delIdList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(delIdList)
            }
        }

        ids?.each { id ->
            userGroup = UserGroup.get(id)
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

                //删除用户组与节目下载权限间的关系
                //def db = new groovy.sql.Sql(dataSource)
                //db.executeUpdate("delete program_play_groups where user_group_id=${id}")
                //db.executeUpdate("delete program_download_groups where user_group_id=${id}")

                userGroup.delete()
                result.success = true;
                result.msg = "删除成功";
            } else {
                result.success = false;
                result.msg = "参数不全";
            }
        }
        return result
    }

    /**
     * 用户组保存
     * @param params
     * @return
     */
    public Map saveUserGroup(Map params) {
        def result = [:];
        result.success = true;
        def session = utilService.getSession();
        def userGroup = new UserGroup(
                name: params.name,
                description: params.description,
                creator: session.consumer.nickname,
                consumer: session.consumer.id,
                dateCreated: new Date(),
                dateModified: new Date()
        )

        if (!userGroup.hasErrors() && userGroup.save()) {
            result.message = "用户组 ${userGroup.name} 创建成功"
        } else {
            result.success = false;
            result.userGroup = userGroup;
        }
        return result;
    }
    /**
     * 用户组更新
     * @param params
     * @return
     */
    public Map updateUserGroup(Map params) {
        def result = [:];
        result.success = true;
        result.notFind = false;
        def userGroup = UserGroup.get(params.updateId)
        if (userGroup) {
            userGroup.name = params.updateName
            userGroup.description = params.updateDescription
            if (!userGroup.hasErrors() && userGroup.save()) {
                result.message = "${userGroup.name} 修改 成功"
            } else {
                result.success = false;
                result.userGroup = userGroup;
            }
        } else {
            result.success = false;
            result.notFind = true;
            result.message = "无法找到 ${userGroup.name}"
        }
        return result;
    }
    /**
     * 向组中添加成员
     * @param params
     * @return
     */
    public void groupAddConsumer(Map params) {
        def result = [:];
        def delIdList = params.idList

        def group = UserGroup.get(params.groupId)
        if (delIdList instanceof String) delIdList = [params.idList]

        delIdList?.each { id ->
            def consumer = Consumer.get(id)
            group.addToConsumers(consumer)                        //删除与userGroup对像的关系
        }
    }
    /**
     * 向所选择的组中添加新单个用户
     * @param params
     * @return
     */
    public Map groupAddConsumerOne(Map params) {
        def result = [:];
        result.success = true;
        def group = UserGroup.get(params.groupId)
        def consumer = Consumer.get(params.consumerId)

        if (consumer) {
            group.addToConsumers(consumer)
        } else {
            result.success = false;
            result.message = " 没有该用户"
        }
        return result;
    }
    /**
     * 删除单个组员与组的关系
     * @param params
     * @return
     */
    public Map groupDeleteConsumerOne(Map params) {
        def result = [:];
        def group = UserGroup.get(params.groupId)
        def consumer = Consumer.get(params.id)
        group.removeFromConsumers(consumer)
        return result;
    }
    /**
     * 条件查询列表
     * @param params
     * @return
     */
    public Map groupSelectList(Map params) {
        def result = [:];
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        Date begin_date = null;
        Date end_date = null;

        def row = params.row                            //每行页显示的行数
        def name = params.searchName                    //用户帐号
        def nickname = params.searchNickname            //用户昵称
        def searchTrueName = params.searchTrueName        //用户姓名
        def searchNNType = params.searchNNType            //searchNNType是昵称查询类型，1-为全字匹配，2-模糊查询
        def searchType = params.searchType                //searchType是查询类型，1-为全字匹配，2-模糊查询

        def college = params.searchCollege                //学生所属院系
        def dateBegin = params.dateBegin                    //创建开始时间
        def dateEnd = params.dateEnd                    //创建结束时间
        def role = params.roleList                        //用户角色
        def numBegin = params.numBegin                //学号范围开始段
        def numEnd = params.numEnd                    //学号范围结束段

        def offset = 0
        def sort = "id"

        //用户判断用使用的是哪一种时间段查询方式
        if (dateBegin && !dateEnd) {
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

        if (!params.max) params.max = row                                //设置反回行数最大值
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
        def consumerList = Consumer.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {

            if (name)                                        //帐号为真，添加用户帐户条件
            {
                if (searchType == "1")                        //判断查询条件是为全字匹配还是模糊查询，进行不同的查询
                {
                    eq('name', name)
                } else {
                    like('name', "%${name}%")
                }
            }
            if (nickname) {

                if (searchNNType == "1") {
                    eq('nickname', nickname)
                } else {
                    like('nickname', "%${nickname}%")
                }
            }
            if (searchTrueName) {
                like('trueName', "%${searchTrueName}%")
            }
            if (college)                                    //用户所属院系为真，进行院系条件查询
            {
                eq('college', College.get(college))
            }
            if (dateBegin)                                    //查询时间为真，进行时间段查询，如果只选择开始时间，那么就是某单独一天
            {
                between("dateCreated", begin_date, end_date)
            }
            if (numBegin && numEnd) {
                between("name", numBegin, numEnd)
            }

            ne("role", 0)
        }
        def total = consumerList.totalCount;
        result.searchList = consumerList;
        result.userGroupList = UserGroup.list();
        result.total = total;
        return result;
    }

    /**
     * 设置用户组的用户能否点播资源
     * @param params
     * @return
     */
    public Map userGroupConsumersIsCanPlay(Map params) {
        def result = [:]
        def delIdList = params.idList
        def userState = params.userState as Integer
        def userGroup

        def msg = userState == 1 ? '允许点播' : '禁止点播'

        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (delIdList instanceof String) {
            if (delIdList.contains(',')) {
                String[] str = delIdList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(delIdList)
            }
        }

        ids?.each { id ->
            userGroup = UserGroup.get(id)
            if (userGroup) {
                def consumers = userGroup.consumers
                def num = 0
                consumers?.each {
                    it.canPlay = userState
                    if (!it.hasErrors() && it.save()) {
                        num++
                    }
                }

                if (consumers.size() == num) {
                    result.success = true;
                    result.msg = "设置" + msg + "成功！";
                } else {
                    result.success = false;
                    result.msg = "设置" + msg + "部分成功,请重新设置或进入用户管理进行设置。";
                }
            } else {
                result.success = false;
                result.msg = "参数不全！";
            }
        }
        return result
    }

    /**
     * 设置用户组的用户能否下载资源
     * @param params
     * @return
     */
    public Map userGroupConsumersIsCanDownload(Map params) {
        def result = [:]
        def delIdList = params.idList
        def canDownload = params.canDownload as Integer
        def userGroup

        def msg = canDownload == 1 ? '允许下载' : '禁止下载'

        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (delIdList instanceof String) {
            if (delIdList.contains(',')) {
                String[] str = delIdList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(delIdList)
            }
        }

        ids?.each { id ->
            userGroup = UserGroup.get(id)
            if (userGroup) {
                def consumers = userGroup.consumers
                def num = 0
                consumers?.each {
                    it.canDownload = canDownload
                    if (!it.hasErrors() && it.save()) {
                        num++
                    }
                }

                if (consumers.size() == num) {
                    result.success = true;
                    result.msg = "设置" + msg + "成功！";
                } else {
                    result.success = false;
                    result.msg = "设置" + msg + "部分成功,请重新设置或进入用户管理进行设置。";
                }
            } else {
                result.success = false;
                result.msg = "参数不全！";
            }
        }
        return result
    }

    /**
     * 为用户组添加能点播的资源
     * @param params
     * @return
     */
    public Map addPlayPrograms(Map params) {
        def result = [:]
        def idList = params.idList

        def userGroup = UserGroup.get(params.groupId as Long)

        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }

        if (userGroup) {
            ids?.each { id ->
                def program = Program.get(id)
                program.addToPlayGroups(userGroup).save()
            }
            result.success = true;
            result.msg = "为用户组" + userGroup.name + "添加可点播成功！";
        } else {
            result.success = false;
            result.msg = "请选择用户组后再添加可点播资源！";
        }

        return result
    }

    /**
     * 为用户组添加能下载的资源
     * @param params
     * @return
     */
    public Map addDownloadPrograms(Map params) {
        def result = [:]
        def idList = params.idList

        def userGroup = UserGroup.get(params.groupId as Long)

        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }

        if (userGroup) {
            ids?.each { id ->
                def program = Program.get(id)
                program.addToDownloadGroups(userGroup).save()
            }
            result.success = true;
            result.msg = "为用户组" + userGroup.name + "添加可下载成功！";
        } else {
            result.success = false;
            result.msg = "请选择用户组后再添加可下载资源！";
        }

        return result
    }

    /**
     * 查看用户组可下载的资源列表
     * @param params
     * @return
     */
    public Map canDownloadProgramList(Map params) {
        def result = [:]

        return result
    }

    /**
     * 查看用户组可下载的资源列表
     * @param params
     * @return
     */
    public Map canPlayProgramList(Map params) {
        def result = [:]

        return result
    }

    /**
     * 查看用户组可点播或下载的资源列表
     * @param params
     * @return
     */
    public Map canOptionProgramList(Map params) {
        def result = [:]

        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "id";

        def userGroup = UserGroup.get(params.groupId as Long)
        def userGroups = { userGroup }

        def kind = params.kind
        def List<Program> programList = []


        if (kind == '1') {
            programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
                if (params.name && params.name != '') {
                    like("name", "%" + params.name + "%")
                }
                playGroups {
                    eq("id", userGroup.id)
                }
            }
        } else {
            programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
                if (params.name && params.name != '') {
                    like("name", "%" + params.name + "%")
                }
                downloadGroups {
                    eq("id", userGroup.id)
                }
            }
        }

        if (programList.size() > 0) {
            def total = programList.totalCount;
            result.page = page;
            //总记录数
            result.records = total;
            //总页数
            result.total = Math.ceil(total * 1.00 / params.max);
            result.rows = [];
            programList.each {
                def tmp = [:];
                tmp.id = it.id;
                tmp.name = it.name;
                tmp.directoryName = it?.directory?.name;
                tmp.consumer = it.consumer.name;
                tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
                tmp.recommendNum = it.recommendNum;
                tmp.collectNum = it.collectNum;
                tmp.frequency = it.frequency;
                tmp.state = Program.cnState.get(it.state);
                tmp.canPublic = it.canPublic;
                result.rows.add(tmp);
            }
        }
        return result
    }

    /**
     * 为用户组添加能下载的资源
     * @param params
     * @return
     */
    public Map removeCanOptionProgram(Map params) {
        def result = [:]
        def idList = params.idList

        def userGroup = UserGroup.get(params.groupId as Long)

        def kind = params.kind

        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }

        if (userGroup) {
            ids?.each { id ->
                def program = Program.get(id)
                if (kind == '1') {
                    program.removeFromPlayGroups(userGroup)
                } else {
                    program.removeFromDownloadGroups(userGroup)
                }
            }
            result.success = true;
            result.msg = "移除成功！";
        } else {
            result.success = false;
            result.msg = "请选择用户组后再移除！";
        }

        return result
    }

    /**
     * 用户列表,根据用户组查询不在该组内的用户
     * @param params
     * @return
     */
    public Map consumerList2(Map params) {
        //println params.groupId+"----------------+"
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "id";
        def name = params.searchName                    //用户帐号
        def college = params.searchCollege                //学生所属院系

        def userGroup = UserGroup.get(params.groupId as Long)
        def consumerIds = []
        userGroup.consumers?.each {
            consumerIds.add(it.id)
        }

        List<Consumer> consumerList = Consumer.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            //帐号为真，添加用户帐户条件
            if (name) {
                name = name.trim()
                like('name', "%${name.toString().decodeURL()}%")
            }
            //用户所属院系为真，进行院系条件查询
            if (college) {
                eq('college', College.get(college))
            }
            gt("role", Consumer.SUPER_ROLE)

            if (consumerIds.size() > 0) {
                not { 'in'("id", consumerIds) }
            }

        }

        if (consumerList.size() > 0) {
            def total = consumerList.totalCount;
            result.page = page;
            //总记录数
            result.records = total;
            //总页数
            result.total = Math.ceil(total * 1.00 / params.max);
            result.rows = [];
            consumerList.each {
                def tmp = [:];
                tmp.id = it.id;
                tmp.name = it.name;
                tmp.nickname = it.nickname;
                tmp.trueName = it.trueName;
                tmp.userState = it.userState;
                tmp.uploadState = it.uploadState;
                tmp.canDownload = it.canDownload;
                tmp.canComment = it.canComment;
                tmp.isRegister = it.isRegister;
                result.rows.add(tmp);
            }


        }
        return result
    }

    /**
     * 向组中添加成员
     * @param params
     * @return
     */
    public Map userGroupConsumerAdd(Map params) {
        def result = [:];
        def idList = params.idList

        def group = UserGroup.get(params.groupId as Long)

        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        if (idList instanceof String) {
            if (idList.contains(',')) {
                String[] str = idList.split(',');
                str.each {
                    ids.add(it);
                }
            } else {
                ids.add(idList)
            }
        }

        if (group) {
            ids?.each { id ->
                //println id
                def consumer = Consumer.get(id as Long)
                group.addToConsumers(consumer)                        //删除与userGroup对像的关系
            }
            result.success = true;
            result.msg = "添加用户组成员成功！";
        } else {
            result.success = false;
            result.msg = "请先选择用户组再添加成员！";
        }
        return result
    }
}
