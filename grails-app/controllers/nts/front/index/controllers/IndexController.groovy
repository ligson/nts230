package nts.front.index.controllers

import com.boful.common.date.utils.TimeLengthUtils
import com.boful.nts.utils.SystemConfig
import grails.converters.JSON
import nts.activity.domain.UserActivity
import nts.broadcast.domain.Channel
import nts.broadcast.domain.CourseBcast
import nts.broadcast.domain.DvbforeNotice
import nts.commity.domain.StudyCommunity
import nts.note.domain.NoteRecommend
import nts.note.domain.ProgramNote
import nts.program.category.domain.CategoryFacted
import nts.program.category.domain.FactedValue
import nts.program.domain.CourseAnswer
import nts.program.domain.CourseQuestion
import nts.program.domain.Program
import nts.program.category.domain.ProgramCategory
import nts.program.domain.ProgramTag
import nts.program.domain.ProgramTopic
import nts.program.domain.Remark
import nts.program.domain.RemarkReply

import nts.program.domain.Serial
import nts.system.domain.Directory
import nts.system.domain.FriendLink
import nts.system.domain.News
import nts.system.domain.Tools
import nts.user.domain.College
import nts.user.domain.Consumer
import nts.user.services.ActionNameAnnotation
import nts.user.services.ControllerNameAnnotation
import nts.utils.CTools

import javax.servlet.http.Cookie
import java.text.SimpleDateFormat

@ControllerNameAnnotation(name = "首页")
class IndexController {
    static allowedMethods = [delete: 'POST', save: 'POST', update: 'POST']
    def programService;
    def userService;
    def programCategoryService;
    def courseAppService;

    //---index   显示主页信息
    def index = {
//        long start = System.currentTimeMillis();
//        //首页海报大图显示推荐资源
//        def remenList = programService.search([state: Program.PUBLIC_STATE, canPublic: true, max: 8, order: "desc", orderBy: "recommendNum"], false);
//        //文档排行
//        def wendangList = programService.search([otherOption: Program.ONLY_TXT_OPTION, state: Program.PUBLIC_STATE, canPublic: true, max: 6, offset: 0, order: "desc", orderBy: "recommendNum"], false);
//        //新闻资讯
//        List<News> newsList = News.list([max: 4, order: "desc", sort: "submitTime"]);
//        // 二级分类目录获取
//        List<ProgramCategory> categoryList = programCategoryService.querySubCategory(programCategoryService.querySuperCategory());
//
//        //需要二级分类-三级分类-四级分类
//        def programList = [];
//        categoryList?.each{ProgramCategory category ->
//            def tmpMap = [:];
//            if (category.isDisplay == 0 && category.name != "默认资源库" && category.mediaType != 0) { //资源分类为显示状态
//                List<ProgramCategory> categoryList2 = programCategoryService.querySubCategory(category);
//                List<ProgramCategory> secondCategoryList = [];
//                categoryList2?.each { ProgramCategory secondCategory ->
//                    def count = Program.createCriteria().list {
//                        programCategories {
//                            eq("id", secondCategory.id)
//                        }
//                    }.size();
//                    if (count && count > 0) {
//                        secondCategoryList.add(secondCategory);
//                    }
//                }
//                tmpMap.mediaType = category.mediaType;
//                tmpMap.categoryId = category.id;
//                tmpMap.categoryName = category.name;
//                tmpMap.secondCategoryMap = secondCategoryList;
//                programList.add(tmpMap);
//            }
//        }
//        return render(view: "index", model: [newsList: newsList, remenList: remenList, wendangList: wendangList, programList: programList]);
        return redirect(url: '/')

    }

    // --- login 用户登陆验证方法   0 - 密码错误 1 - 用户不存在  2 - 用户已过期
    def login = {
        //记录页面来源
        String url = request.getHeader("Referer");
        //登陆失败后重新赋值
        if (params.url) {
            url = params.url;
        }
        return render(view: 'login', model: [url: url]);
    }

    def checkLogin = {
        //println '-----------密码--------------------'+EncodePasswd.EncodePasswd(params.name)
        //获取之前访问的页面
        String url = params.url;


        def result = [:];
        def consumer = Consumer.findByName(params.loginName)
        params.nowDate = new Date().format("yyyy-MM-dd")
        result = userService.checkLogin(params);
        if (result.success == true) {
            if (result.approvalAlert != null && result.approvalAlert == true) {
                flash.approvalAlert = true
            }
            if (url != null && !url.contains("/saveRegister")) {
                return redirect(url: url);
            }
            if (params.from && params.from == "search") {
                params.remove("loginName")
                redirect(action: "main", params: params)
            } else {
                //判断是否ajax请求
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    result.key = consumer.id;
                    result.name = consumer.name;
                    result.photo=consumer.photo;
                    //cookie保存
                    if (params.remFlg) {
                        String remFlg = params.remFlg;
                        cookieLoginSave(remFlg, params.loginName, params.password);
                    }
                    return render(result as JSON)
                } else {
                    redirect(action: "index")
                }

            }
        } else {
            //判断是否ajax请求
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                return render(result as JSON)
            } else {
                redirect(action: 'login', params: [loginFlg: result.loginFlg, url: url]);
            }
        }
    }

    /**
     * 前台登录cookie保存
     * @param remFlg
     * @param consumer
     * @return
     */
    def cookieLoginSave(String remFlg, String name, String password) {
        Cookie[] cookies = request.getCookies();
        Cookie cookieLoginName = null;
        Cookie cookiePass = null;
        if (cookies && cookies.size() > 0) {
            for (Cookie cookie : cookies) {
                if (cookie.getName() == "loginName") {
                    cookieLoginName = cookie;
                    break;
                }
            }
        }
        if ("1".equals(remFlg)) { //记住用户名
            // 保存cookie
            if (cookieLoginName) {
                cookieLoginName.setValue(name);
                cookiePass = new Cookie("pwd", password);
                response.addCookie(cookieLoginName);
                response.addCookie(cookiePass);
            } else {
                Cookie newCookie = new Cookie("loginName", name);
                newCookie.setMaxAge(60 * 60 * 24 * 30); //保存30天
                cookiePass = new Cookie("pwd", password);
                cookiePass.setMaxAge(60 * 60 * 24 * 30); //保存30天
                response.addCookie(newCookie);
                response.addCookie(cookiePass);
            }
        } else {
            try {
                if (cookieLoginName) { //清除
                    cookieLoginName.setMaxAge(0);
                    cookiePass = new Cookie("pwd", password);
                    cookiePass.setMaxAge(0);
                    response.addCookie(cookieLoginName);
                    response.addCookie(cookiePass);
                }
            } catch (Exception e) {
            }
        }
    }

    def register = {
        def consumer = null
        List<College> collegeList = new ArrayList<College>();
        collegeList.add(new College());
        collegeList.addAll(College.list());
        [consumer: consumer, collegeList: College.list()]
    }

    def saveRegister = {
        def result = [:];
        params.request = request;
        params.consumer = session.consumer
        if (params.name && params.password) {
            // 有效日期默认为2030-12-31
            params.dateValid = "2030-12-31";
            // 参数验证
            // 如果为非法身份，设置为学生
            def jobs=["1","2","4","8","16","32"];
            if(!jobs.contains(params.userJob)){
                params.userJob = 16
            }
            // 如果为非法职称，设置为空
            def jobNames=["1","2","4","8","16","32","64"];
            if(!jobNames.contains(params.jobName)){
                params.jobName = 64;
            }

            result = userService.register(params);
            if (result.isOK) {
                return render(view: 'saveRegister', model: [name: params.name, isOK: result.isOK, isRegister1: '1'])
            } else {
                //consumer.errors.allErrors.each { println it }
                render(view: 'register', model: [consumer: result.consumer, collegeList: College.list()])
            }
        } else {
            flash.message = "参数不全";
            render(view: 'register', model: [collegeList: College.list()])
        }

        //[name: params.name, isOK: isOK]
    }
    //检测用户名是否存在
    def checkUserName = {

        def consumer = null
        def msg = "OK"
        params.name = params.name.trim()

        if (params.name != "") {
            consumer = Consumer.find("from nts.user.domain.Consumer as a where a.name = ?", [params.name])
            if (consumer != null) msg = "exist"
        }

        render(msg)
    }

    def ldapError = {}


    //---2009-6-16新增 logout
    def logout = {
//        session.consumer = null;
//        session.valid = null;
        session.invalidate();
        redirect(action: 'index')
    }


    //---2009-7-16 新增 newsMore 方法
    def newsMore = {
        def total                                        //声明列表结果行数
        def newsList                                    //声明结果集

        newsList = newsSearch()
        total = newsList.totalCount

        [newsList: newsList, total: total]
    }
    //---2009-7-16 新增 programMore
    def programMore = {
        def total                                        //声明列表结果行数
        def programList                                    //声明结果集

        programList = programSearch()
        total = programList.totalCount

        [programList: programList, total: total]
    }
    //---2009-9-17 新增  toolsMore 下载工具More
    def toolsMore = {
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        [toolsList: Tools.list(params), total: Tools.count()]
    }

    //---
    //---2009-7-3 新增search闭包 用来查询公告内容
    def newsSearch = {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        java.util.Date begin_date = null
        java.util.Date end_date = null
        def searchTitle = params.searchTitle
        def searchContent = params.searchContent
        def searchPublisher = params.searchPublisher
        def searchDate = params.searchDate
        def dateBegin                                    //创建开始时间
        def dateEnd                                    //创建结束时间

        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'submitTime'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        if (searchDate) {                        //用户判断用使用的是哪一种时间段查询方式
            dateBegin = params.searchDate + ' 00:00:01'
            dateEnd = params.searchDate + ' 23:59:59'

            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        }

        def searchList = News.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {

            if (searchTitle) {
                searchTitle = searchTitle.trim()
                like('title', "%${searchTitle}%")
            }
            if (searchContent) {
                searchContent = searchContent.trim()
                like('content', "%${searchContent}%")
            }
            if (searchPublisher) {
                publisher {
                    searchPublisher = searchPublisher.trim()
                    like('nickname', "%${searchPublisher}%");
                }
            }
            if (searchDate) {
                between("submitTime", begin_date, end_date)
            }

        }
        return searchList
    }
    //查询资源
    def programSearch = {
        def canPublic;
        def urlType;
        def otherOption;
        def photoList;
        def isCanPublic;
        if (params.condition.equals("canPublic")) {
            canPublic = params.val;
        } else if (params.condition.equals("urlType")) {
            urlType = params.val;
        } else if (params.condition.equals("otherOption")) {
            otherOption = params.val;
        } else if (params.condition.equals("photoList")) {
            photoList = params.val;
        } else if (params.isCanPublic == "true") {
            isCanPublic = params.isCanPublic;
        }
        if (!params.max) params.max = 18
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        def searchList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (canPublic) {
                canPublic = canPublic.trim();
                like("name", "%${canPublic}%")
            }
            if (urlType) {
                urlType = urlType.trim();
                like("name", "%${urlType}%")
            }
            if (otherOption) {
                otherOption = otherOption.trim();
                like("name", "%${otherOption}%")
            }
            if (photoList) {
                photoList = photoList.trim();
                like("name", "%${photoList}%")
            }
            if (isCanPublic) {
                eq("canPublic", true)
            }
        }
        render(view: 'programSearch', model: [searchList: searchList, total: searchList.totalCount, val: params.val, condition: params.condition])
    }
    //---2009-7-3 新增programSearch闭包 用来查询节目内容
    /*def programSearch = {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        java.util.Date begin_date = null;
        java.util.Date end_date = null;
        def searchTitle;
        def searchActor
        def searchDesc
        def searchDate
        def programTag
        if (params.condition.equals("searchTitle")) {
            searchTitle = params.key;
        } else if (params.condition.equals("searchActor")) {
            searchDesc = params.key;
        } else if (params.condition.equals("searchDesc")) {
            searchDesc = params.key;
        } else if (params.condition.equals("searchDate")) {
            searchDate = params.key;
        }
        def dateBegin                                    //创建开始时间
        def dateEnd                                    //创建结束时间

        if (!params.max) params.max = 18
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

        if (searchDate) {                    //用户判断用使用的是哪一种时间段查询方式
            dateBegin = params.searchDate + ' 00:00:01'
            dateEnd = params.searchDate + ' 23:59:59'

            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        }

        def searchList = nts.program.domain.Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {

            if (searchTitle) {
                searchTitle = searchTitle.trim()
                like('name', "%${searchTitle}%")
            }
            if (searchActor) {
                searchActor = searchActor.trim()
                like('actor', "%${searchActor}%")
            }
            if (searchDesc) {
                searchDesc = searchDesc.trim()
                like('description', "%${searchDesc}%");
            }
            if (searchDate) {
                between("dateCreated", begin_date, end_date)
            }
            eq('state', nts.program.domain.Program.PUBLIC_STATE)
        }
        if (params.condition.equals("programTag")) {
            programTag = params.key
            searchList = nts.program.domain.Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
                programTags {
                    like('name', "%${programTag}%")
                }
            }
        }
        render(view: 'programSearch', model: [searchList: searchList, total: searchList.totalCount, key: params.key, condition: params.condition])
    }*/
    //---2009-7-17 新增

    def showNews = {
        def news = News.get(params.id as long)
        if (!news) {
            flash.message = "该公告己失效"
            redirect(action: newsMore)
        } else {
            return [news: news]
        }
    }
    //---2009-8-10新增  loginError 登陆错误页面
    def loginError = {

    }

    //***********************************************************************************//
    //***************************2009-10-23新增，以下为Ldap操作*****************//
    //***********************************************************************************//
    def checkLdap() {
        /*String  account=params.name;
        String  password=params.password;
        String  root="dc=uibe,dc=edu,dc=cn";
        Hashtable  env  =  new  Hashtable();

        env.put(Context.INITIAL_CONTEXT_FACTORY,  "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL,  "ldap://202.204.175.55/"  +  root);
        env.put(Context.SECURITY_AUTHENTICATION,  "simple");
        env.put(Context.SECURITY_PRINCIPAL,  "uid="  +  account  +  ",ou=people,"  +  root);
        env.put(Context.SECURITY_CREDENTIALS,  password);

        DirContext  ctx  =  null;
        try
        {
                ctx  =  new  InitialDirContext(env);
              //  System.out.println("认证成功");
        }
        catch(javax.naming.AuthenticationException  e)
        {
            //    System.out.println("认证失败");
        return 3
             //   e.printStackTrace();
        }
        catch(Exception  e)
        {
             //   System.out.println("认证出错：");
        return 3
             //   e.printStackTrace();
        }
        if(ctx  !=  null)
        {
                try
                {
                        ctx.close();
            return 1
                }
                catch  (NamingException  e)
                {
                        //ignore
                }
        }  */

        return 3
    }


    def addConsumer(name, password, trueName, nickname, gender, role, dateEnterSchool, college) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date ldapDateEnterSchool = null;
        Date ldapDateValid = null;
        def ldapEnterYear
        def ldapEnterMD
        def ldapValidYear
        def ldapDate
        def collegeId

        //---处理入学时间及有效果时间
        if (dateEnterSchool) {
            ldapEnterYear = dateEnterSchool.substring(0, 4)                    //提取入学年份
            ldapEnterMD = dateEnterSchool.substring(4)                    //提取入学月和日
            ldapValidYear = ldapEnterYear.toInteger() + 4                        //将入学年份加4年，变为有效果时间年份
            ldapDate = ldapValidYear + ldapEnterMD                        //有效时间年份+入学月和日，就是有效时间
            ldapDateEnterSchool = sdf.parse(dateEnterSchool);
            ldapDateValid = sdf.parse(ldapDate);
            //println '--------------------------------ldapEnterYear   '+ldapEnterYear
            //println '--------------------------------ldapValidYear   '+ldapValidYear
            //println '--------------------------------ldapEnterMD   '+ldapEnterMD
            //println '--------------------------------ldapDateValid   '+ldapDateValid

        }
        //---判断用户姓别  性别代码(1-男；2-女)
        if (gender) {
            if (gender == '2') {        //对应本系统数据库 0 - 女 1-男
                gender = 0
            }
            if (gender.toInteger() > 2) {
                gender = 1
            }
        }
        //---判断用户角色 role  人员类别代码(1-学生；2-教师)
        if (role) {
            if (role == '1') {        //如果是学生，那么变为3
                role = 3
            }
        }
        //查找用户所在院系
        if (college) {
            collegeId = College.findByName(college)
        }
        def ldapConsumer = new Consumer(
                name: params.name,                                    //用户名
                password: params.password.encodeAsPassword(),        //密码
                nickname: params.name,                                //昵称
                trueName: trueName,                                    //真实姓名
                gender: gender,                                        //性别 0-女 1-男
                uploadState: 0,                                        //是否上传 0-否 1-是 2-审请中  用户默认是0 管理员是1
                canDownload: true,                                        //是否下载 0-否 1-是 用户默认是0 管理员是1
                userState: true,                                        //用户状态  0-禁用 1-活动 禁用后不可点播节目
                canComment: true,                                        //是否可以发表评论 0-否 1-是 默认是1
                role: role,                                                //用户角色 0-Master(超级管理员)  1-部门管理员（可对节目和用户操作）2-普通管理员（只对节目操作）3-用户
                notExamine: false,                                        //审核状态上传节目是否审核  1-免审 0-审核
                dateEnterSchool: ldapDateEnterSchool,                    //入学时间
                dateValid: ldapDateValid,                                //有效时间
                college: collegeId
        )

        if (!ldapConsumer.hasErrors() && ldapConsumer.save()) {
            return 1
        } else {
            ldapConsumer.errors.allErrors.each {
                println it
            }
            return 2
        }
        /*
        try {
            new nts.user.domain.Consumer(name: name, password: password, nickname: nickname, gender: gender, role: role, uploadState: 0, canDownload: true,canComment:true,notExamine: false, userState: true, dateEnterSchool: ldapDateEnterSchool, dateValid: ldapDateValid, college: collegeId).save()
        }
        catch (Exception e) {
            System.out.println(e);
        }*/
    }

    def updateConsumer(name, password) {
        def consumer = Consumer.findByName(name)
        consumer.password = password.encodeAsPassword()

        if (!consumer.hasErrors() && consumer.save()) {
            return 1
        } else {
            consumer.errors.allErrors.each {
                println it
            }
            return 2
        }
    }

    //***********************************************************************************//
    //***************************2009-10-23新增，以上为Ldap及操作*****************//
    //***********************************************************************************//

    //***********************************************************************************//
    //***************************2009-10-30 新增，以下为Oracle操作*****************//
    //***********************************************************************************//
    /*def getOracleUser(state) {

        /*//*************************数据库连接字符串***************************//*/
        def DB = 'jdbc:oracle:thin:@192.168.6.6:1521:neusoft1'
        def USER = 'sso'
        def PASSWORD = 'neudcp_sso'
        def DRIVER = 'oracle.jdbc.driver.OracleDriver'
        /*//*************************数据库连接字符串***************************//*/

        /*//************************用户表对应该属性****************************//*/

        //def = ACCOUNT							帐号
        //def = XM									姓名
        //def = XB_ID 								性别代码(1-男；2-女)
        //def = XB_NAME							性别名称
        //def = TYPE_ID							人员类别代码(1-学生；2-教师)
        //def = TYPE_NAME						人员类别名称
        //def = UNIT_ID							所在部门（院系）代码
        //def = UNIT_NAME							所在部门（院系）名称
        //def = RXSJ								入校时间

        def name = params.name
        def password = params.password.encodeAsPassword()
        def trueName = 'user'
        def nickname = params.name
        def gender = 1
        def role = 3
        def dateEnterSchool
        def college

        /*//************************用户表对应该属性***************************//*/
        def addFlg
        try {
            def sql = Sql.newInstance(DB, USER, PASSWORD, DRIVER)
            sql.eachRow('select ACCOUNT, XM, XB_ID, TYPE_ID, UNIT_NAME, RXSJ from  view_neudcp_userinfo where ACCOUNT = ?', [name])
                    { user ->
                        trueName = user.XM
                        gender = user.XB_ID
                        role = user.TYPE_ID
                        college = user.UNIT_NAME
                        dateEnterSchool = user.RXSJ
                    }
            addFlg = addConsumer(name, password, trueName, nickname, gender, role, dateEnterSchool, college)
            sql.close()
            if (addFlg == 1)        //如果返回是1，证明添加成功
            {
                return 1
            } else                    //如果失败，返回的是2
            {
                return 3
            }
        }
        catch (Exception e) {
            System.out.println(e);
            return 3
        }

    }*/

    //***********************************************************************************//
    //***************************2009-10-30 新增，以上为Oracle操作*****************//
    //***********************************************************************************//

    //专题资源列表
    def showProgramTopic = {
        def programTopic = ProgramTopic.get(params.id)
        if (!programTopic) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'programTopic.label', default: 'nts.program.domain.ProgramTopic'), params.id])}"
            redirect(action: "list")
        } else {
            params.max = Math.min(params.max ? params.int('max') : 50, 200)
            if (!params.offset) params.offset = 0
            if (!params.sort) params.sort = 'id'
            if (!params.order) params.order = 'desc'

            //如果要分页，则先用programTopic.programs的ID列表作为条件查询，再加排序用offset条件即可
            def programList = null
            def total = programTopic.programs.size();

            programList = Program.findAllByStateAndIdInList(Program.PUBLIC_STATE, programTopic.programs.id, params)

            return [programTopic: programTopic, programList: programList, total: total]
        }
    }

    def programTopicMore = {
        def name = CTools.nullToBlank(params.name)
        params.max = Math.min(params.max ? params.int('max') : 10, 200)
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        def programTopicList = null
        def total = 0

        programTopicList = ProgramTopic.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (name != '') ilike("name", "%${name}%")
            eq("state", ProgramTopic.PUBLIC_STATE)
        }

        total = programTopicList.totalCount

        //programTopicList = nts.program.domain.ProgramTopic.findAllByState(nts.program.domain.ProgramTopic.PUBLIC_STATE,params)
        //total = nts.program.domain.ProgramTopic.countByState(nts.program.domain.ProgramTopic.PUBLIC_STATE)

        [programTopicList: programTopicList, total: total]
    }

    //---2010-12-21 新增 channelMore 方法
    def channelMore = {
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        //print(params.max + "<-max")
        //println(params.offset + "<-offset")
        params.max = Math.min(params.max ? params.int('max') : 10, 200)
        def total = 0                                        //声明列表结果行数
        def channelList = null                                //声明结果集

        total = Channel.count()
        if (total > 0) channelList = Channel.list(params)

        [channelList: channelList, total: total]
    }

    //---2010-12-21 新增 courseBcastMore 方法
    def courseBcastMore = {
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'asc'
        params.max = Math.min(params.max ? params.int('max') : 10, 200)
        def total        //声明列表结果行数
        def channel = params.channel
        def title = params.title
        def author = params.author
        def courseBcastList = CourseBcast.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (channel) {
                channel = channel.trim()
                like('channel', "%${channel}%")
            }
            if (title) {
                title = title.trim()
                like('title', "%${title}%")
            }
            if (author) {
                author = author.trim()
                like('author', "%${author}%")
            }

        }

        total = courseBcastList.totalCount

        [courseBcastList: courseBcastList, total: total]
    }

    //---2010-12-21 新增
    def showChannel = {
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'asc'

        params.max = Math.min(params.max ? params.int('max') : 10, 200)

        def total = 0                                        //声明列表结果行数
        def dvbforeNoticeList = null

        def channel = Channel.get(params.id)

        if (!channel) {


            flash.message = "该频道己失效"
            redirect(action: channelMore)
        } else {

            dvbforeNoticeList = DvbforeNotice.findAllByChannel(channel, [max: params.max, sort: params.sort, order: params.order, offset: params.offset])
            total = DvbforeNotice.countByChannel(channel)

            [dvbforeNoticeList: dvbforeNoticeList, total: total, channel: channel]
        }
    }

    //---2010-12-21 新增
    def showCourseBcast = {
        def total
        def courseBcast = CourseBcast.get(params.id)
        if (!courseBcast) {
            flash.message = "该频道己失效"
            redirect(action: courseBcastMore)
        } else {

            total = CourseBcast.count()

            [courseBcast: courseBcast, total: total]
        }
    }

    def friendLinkMore = {
        def total = 0                                        //声明列表结果行数
        def friendLinkList = null                                    //声明结果集

        params.max = Math.min(params.max ? params.int('max') : 10, 400)
        params.sort = 'showOrder'
        params.order = 'desc'
        friendLinkList = FriendLink.list(params)

        [friendLinkList: friendLinkList, total: total]
    }

    //获取在线人数 add by jlf
    def sgetOnlineNum() {
        def outUrl = ""
        def videoHost = ""
        def sVideoPort = "1680"
        def svrAddress = request.getServerName()

        int nNum = -1;

        if (servletContext.videoPort != '') {
            //视频服务器端口
            sVideoPort = servletContext.videoPort;
        }
        if (servletContext.videoSevr != '') {
            svrAddress = servletContext.videoSevr;
        }
        videoHost = svrAddress + ":" + sVideoPort;

        outUrl = "http://${videoHost}/bmsp-server-status"

        def xml;
        if (!svrAddress) {
            log.error("video server not config...");
        } else {
            xml = CTools.getInputStreamContent(outUrl, "GET", "UTF-8", request.getHeader("User-Agent"));
        }


        if (xml) {
            try {
                def server = new XmlParser().parseText(xml)
                nNum = (server.global.current_stream_num.text()).toInteger()
            }
            catch (Exception e) {
                System.out.println(outUrl + " error:" + e.toString());
            }
        }

        return nNum
    }


    def videoIndex() {
        //资源分类
        ProgramCategory videoSuperCategory;
        if(params.categoryId){
            try{
                videoSuperCategory = ProgramCategory.get(params.categoryId as long);
            }catch (Exception e){
                videoSuperCategory = programCategoryService.queryVideoCategory();
            }
        } else {
            videoSuperCategory = programCategoryService.queryVideoCategory();
        }

        //推荐熟
        def tuijianList = programService.search([max: 6, offset: 0, otherOption: Program.ONLY_VIDEO_OPTION,programCategoryId:videoSuperCategory.id, orderBy: "recommendNum", order: "desc"], false);
        //最新资源
        def newProgramList = programService.search([max: 6, offset: 0, otherOption: Program.ONLY_VIDEO_OPTION,programCategoryId:videoSuperCategory.id, orderBy: "dateCreated", order: "desc"], false);

        //根据父类找到他的下级资源
//        def videoSuperCategory = programCategoryService.queryVideoCategory();
        def videoSecondCategoryList = programCategoryService.querySubCategory(videoSuperCategory);
        List<List<Program>> programList = [];
        videoSecondCategoryList.each { ProgramCategory category ->
            List<Program> programList2 = programService.search([max: 12, offset: 0, programCategoryId: category.id], false);
            programList.add(programList2);
        }
        //最新标签
        def programTagList = programService.queryHotProgramTag(Program.ONLY_VIDEO_OPTION, videoSuperCategory.id);
        // 获取视频分类名称
        def videoName = videoSuperCategory.name;
        return render(view: 'videoIndex', model: [programTagList: programTagList, tuijianList: tuijianList, newProgramList: newProgramList, programCategoryList: videoSecondCategoryList, programList: programList, videoName: videoName])
    }


    def flashIndex() {
        //资源分类
        ProgramCategory flashSuperCategory;
        if(params.categoryId){
            flashSuperCategory = ProgramCategory.get(params.categoryId as long);
        } else {
            flashSuperCategory = programCategoryService.queryFlashCategory();
        }

        //推荐熟
        def tuijianList = programService.search([max: 6, offset: 0, otherOption: Program.ONLY_FLASH_OPTION,programCategoryId:flashSuperCategory.id, orderBy: "recommendNum", order: "desc"], false);
        //最新资源
        def newProgramList = programService.search([max: 6, offset: 0, otherOption: Program.ONLY_FLASH_OPTION,programCategoryId:flashSuperCategory.id, orderBy: "id", order: "desc"], false);

        //根据父类找到他的下级资源
        def flashSecondCategoryList = programCategoryService.querySubCategory(flashSuperCategory);
        List<List<Program>> programList = [];
        List<ProgramCategory> categoryList = [];
        flashSecondCategoryList.each { ProgramCategory category ->
            List<Program> programList2 = programService.search([max: 8, offset: 0, programCategoryId: category.id], false);
            if(programList2 && programList2.size()>0) {
                categoryList.add(category);
                programList.add(programList2);
            }
        }
        //最新标签
        def programTagList = programService.queryHotProgramTag(Program.ONLY_FLASH_OPTION, flashSuperCategory.id);
        // 获取视频分类名称
        def flashName = flashSuperCategory.name;
        return render(view: 'flashIndex', model: [programTagList: programTagList, tuijianList: tuijianList, newProgramList: newProgramList, programCategoryList: categoryList, programList: programList, flashName: flashName])
    }


    def docIndex() {
        //根据父类找到他的下级资源
        ProgramCategory docSuperCategory;
        if(params.categoryId){
            try {
                docSuperCategory = ProgramCategory.get(params.categoryId as long);
            }catch(Exception e){
                docSuperCategory = programCategoryService.queryDocCategory();
            }
        } else {
            docSuperCategory = programCategoryService.queryDocCategory();
        }

        //文档排行
        def wendangList = programService.search([otherOption: Program.ONLY_TXT_OPTION, programCategoryId: docSuperCategory.id, max: 6, offset: 0, orderBy: "id", order: "desc"], false)

        //推荐资源
        List<Program> tuijianList = programService.search([otherOption: Program.ONLY_TXT_OPTION, programCategoryId:docSuperCategory.id, max: 6, offset: 0, orderBy: "recommendNum", order: "desc"], false)

//        def docSuperCategory = programCategoryService.queryDocCategory();
        def docSecondLevelCategoryList = programCategoryService.querySubCategory(docSuperCategory);
        List<List<Program>> programList = [];

        docSecondLevelCategoryList.each { ProgramCategory programCategory ->
            List<Program> programList2 = programService.search([max: 12, offset: 0, programCategoryId: programCategory.id], false)
            programList.add(programList2)
        }

        //最新标签
        def programTagList = programService.queryHotProgramTag(Program.ONLY_TXT_OPTION, docSuperCategory.id);
        // 获取文档分类名称
        def docName = programCategoryService.queryDocCategoryName();
        return render(view: 'docIndex', model: [programTagList: programTagList, tuijianList: tuijianList, wendangList: wendangList, programCategoryList: docSecondLevelCategoryList, programList: programList, docName: docName])
    }

    def imageIndex() {
        //根据父类找到他的下级资源
        ProgramCategory img;
        if(params.categoryId){
            img = ProgramCategory.get(params.categoryId as long);
        } else {
            img = programCategoryService.queryImageCategory();
        }

        //图片集合
        def photoList = programService.search([otherOption: Program.ONLY_IMG_OPTION, programCategoryId: img.id, max: 6, offset: 0, orderBy: "dateCreated", order: "desc"], false);

        //推荐资源
        List<Program> tuijianList = programService.search([otherOption: Program.ONLY_IMG_OPTION, programCategoryId: img.id, max: 6, offset: 0, orderBy: "recommendNum", order: "desc"], false);


//        def img = programCategoryService.queryImageCategory();
        def programCategoryList = programCategoryService.querySubCategory(img);
        List<List<Program>> programList = [];

        programCategoryList.each { ProgramCategory category ->
            List<Program> programList2 = programService.search([max: 12, offset: 0, programCategoryId: category.id], false)
            programList.add(programList2)

        }

        //最新标签
        def programTagList = programService.queryHotProgramTag(Program.ONLY_IMG_OPTION, img.id);
        // 获取图片分类名称
        def photoName = programCategoryService.queryPhotoCategoryName();
        return render(view: 'imageIndex', model: [programTagList: programTagList, tuijianList: tuijianList, photoList: photoList, programCategoryList: programCategoryList, programList: programList, photoName: photoName])
    }

    List<ProgramCategory> searchCategoryNavList = [];

    def search() {
        /*searchCategoryNavList.clear();*/

        def facetFieldParams = ""; //搜索分面参数
        def facetValueParams = ""; // 搜索分面值参数
        int urlType = -1;
        int otherOption = -1;
        def programList;
        if(params.urlType){
            urlType = params.urlType as int;
        }

        if(params.otherOption){
            try{
                otherOption = params.otherOption as int;
            }catch(Exception e){
                params.otherOption=null;
            }
        }

        if (!params.max){
            params.max = 20
        } else {
            try{
                Integer.parseInt(params.max);
            } catch(Exception e){
                params.max = 20
            }
        }
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        def programCategoryId;
        if (params.programCategoryId) {
            try{
                programCategoryId = Long.parseLong(params.programCategoryId);
            }catch(Exception e){
                programCategoryId=null;
            }
        }
        ProgramCategory programCategory;
        //查询出来顶级类别

        //查询出来顶级分类下边的一级分类
        if (params.programCategoryId) {
            programCategory = ProgramCategory.findById(programCategoryId as Long);
        } else {
            def parentCategory = ProgramCategory.findByParentCategory(null);
            programCategory = parentCategory;
        }

        Map searchParams = [:];
        if (params.name) {
            if ("输入搜索内容".equals(params.name)) {
                params.name = '';
            }
            searchParams.name = params.name.toString().decodeURL();
            params.name = searchParams.name;
        }

        //分面
        Set paramsSet = params.keySet();
        def facetValueList = [];
        def facetNameList = [];
        paramsSet.each { String param ->
            if (param.contains("_facet")) {
                facetValueList.add(params.get(param));
                facetNameList.add(param);
                facetFieldParams = facetFieldParams + param + ",";
                facetValueParams = facetValueParams + params.get(param) + ",";
            }
        }

        if (facetFieldParams.length() > 0) {
            facetFieldParams.substring(0, facetFieldParams.length() - 1);
            facetValueParams.substring(0, facetValueParams.length() - 1);
        }

        if (facetValueList.size() > 0) {
            searchParams.factedName = facetNameList;
            searchParams.factedValue = facetValueList;
        }
        searchParams.otherOption = otherOption;
        searchParams.directoryId = params.directoryId
        searchParams.programCategoryId = programCategoryId;
        searchParams.programTagId = params.programTagId;
        searchParams.urlType = params.urlType ? params.urlType : urlType;
        searchParams.offset = params.offset;
        searchParams.max = params.max;
        if (userService.judeAnonymity()) {
            searchParams.canPublic = "true";
        }
        //排序属性
        searchParams.orderBy = params.orderBy;
        //排序方向
        searchParams.order = params.order

        programList = programService.search(searchParams, false);

        def total = programService.searchTotalCount(searchParams);

        /*categoryList(programCategory)
        Collections.reverse(searchCategoryNavList);*/

        //分面获取
        def facetList = [];
        Set<CategoryFacted> facetSet = programCategory?.facteds;
        if (facetSet && facetSet.size() > 0) {
            List<CategoryFacted> factedList = facetSet.toList();
            factedList.sort { facet1, facet2 ->
                facet1.enName <=> facet2.enName
            }
            //分面值获取
            for (CategoryFacted facet : factedList) {
                def value = [:];
                List<String> valueList = FactedValue.createCriteria().list {
                    projections {
                        distinct('contentValue')
                    }
                    categoryFacted {
                        eq('id', facet.id)
                    }
                    order('orderIndex', 'asc')
                }
                if (valueList && valueList.size() > 0) {
                    value.put("enName", facet.enName);
                    value.put("values", valueList);
                    value.put("cnName", facet.name);
                    facetList.add(value);
                }
            }
            facetList.sort();
        }

        //标签名
        def programTagName = "";
        if (params.programTagId) {
            def programTag = ProgramTag.get(params.programTagId as long);
            if(programTag){
                programTagName = programTag.name;
            }
        }

        //searchCategoryNavList =  programService.querySubAllCategory(programCategory);
//        List<ProgramCategory> childCategoryList = ProgramCategory.findAllByParentCategory(programCategory);
        //List<Directory> directoryList = Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])
        List<ProgramTag> programTagList = programService.queryHotProgramTag(99, -1); //查询所有类型热门标签
        return render(view: 'search', model: [facetList: facetList, programTagName: programTagName, params: params, total: total, programTagList: programTagList, programList: programList, /*categoryNavList: searchCategoryNavList,*/
//                                              childCategoryList: childCategoryList,
currentCategory: programCategory, facetFieldParams: facetFieldParams, facetValueParams: facetValueParams])
    }

    private void categoryList(ProgramCategory currentCategory) {
        if (currentCategory) {
            searchCategoryNavList.add(currentCategory);
            if (currentCategory.parentCategory) {
                categoryList(currentCategory.parentCategory)
            }
        }
    }
    //根据类别查询
    def findByCategory = {
        def result = [:];
        ProgramCategory parentCategory = ProgramCategory.findByName(params.name);
        List<ProgramCategory> programCategoryList = ProgramCategory.findAllByParentCategory(parentCategory);
        int cateCount = programCategoryList.size();
        result.programCategoryList = programCategoryList;
        result.cateCount = cateCount;
        return render(result as JSON);
    }

    //课程首页
    @ActionNameAnnotation(name = "课程首页")
    def courseIndex() {
        ProgramCategory courseSuperCategory = new ProgramCategory();
        if(params.categoryId){
            courseSuperCategory = ProgramCategory.get(params.categoryId as long);
        } else {
            courseSuperCategory = programCategoryService.queryCourseCategory();
        }

        //推荐视频
        //List<Program> tuijianList = programService.search([otherOption: Program.ONLY_LESSION_OPTION, programCategoryId: courseSuperCategory.id, max: 5, offset: 0, orderBy: "recommendNum", order: "desc"], false)
        //开放课程
        List<List<Program>> publicLession = [];


        List<ProgramCategory> courseSecondLevelCategoryList = programCategoryService.querySubCategory(courseSuperCategory);
        for (int i = 0; i < courseSecondLevelCategoryList.size(); i++) {
            def subCategoryList = programCategoryService.querySubAllCategory(courseSecondLevelCategoryList[i]);
            if(subCategoryList){
                subCategoryList.add(courseSecondLevelCategoryList[i]);
            }else {
                subCategoryList = [];
                subCategoryList.add(courseSecondLevelCategoryList[i]);
            }

            def rsMap = programService.queryProgramByCategory(subCategoryList, courseSecondLevelCategoryList[i]);
            publicLession.add(rsMap.programList);
        }

        //找出所有的课程资源分类
        List<ProgramCategory> categoryList = programCategoryService.querySubAllCategory(courseSuperCategory);
        //最新课程
        List<Program> newProgram = programService.search([otherOption: Program.ONLY_LESSION_OPTION, max: 4, offset: 0, orderBy: "dateCreated", order: "desc", programCategoryId: courseSuperCategory.id], false);
        List<ProgramTag> programTagList = programService.queryHotProgramTag(Program.ONLY_LESSION_OPTION, courseSuperCategory.id);
        // 获取图片分类名称
        def courseName = programCategoryService.queryCourseCategoryName();
        return render(view: 'courseIndex', model: [courseName: courseName, publicLession: publicLession, programCategoryList: courseSecondLevelCategoryList, categoryList: categoryList, newProgram: newProgram, programTagList: programTagList])

    }

    def courseSearchList() {
    }
    //保存提问
    def saveCourseQuestion() {
        def result = [:];
        def appendHtml = "";
        def total = 0;
        if (params.courseTotal) {
            total = params.courseTotal as int;
        }
        if ((!session.consumer) || (session.consumer.name == "anonymity")) {
            return redirect(controller: 'index', action: 'login')
        } else {
            def programId = params.programId;
            def title = params.remarkTopic;
            if (programId && title) {
                Program program = Program.get(programId);
                CourseQuestion courseQuestion = new CourseQuestion();
                courseQuestion.consumer = session.consumer;
                courseQuestion.course = program;
                courseQuestion.title = title;
                courseQuestion.save(flush: true);

                appendHtml += "<div class=\"boful_course_play_class_item\">\n" +
                        "                    <div class=\"course_question_user_massage_bod\">\n" +
                        "                        <div class=\"course_play_user_massage_portrait\">\n" +
                        "                            <a title=\"${courseQuestion?.consumer?.name}\" href=\"${createLink(controller: 'my', action: 'userSpace', params: [id: courseQuestion?.consumer?.id])}\">\n" +
                        "                                <div class=\"course_video_item_user_img\">\n" +
                        "                                    <img src=\"${generalUserPhotoUrl(consumer: courseQuestion.consumer)}\" />\n" +
                        "                                </div></a></div>";
                appendHtml += "<div class=\"course_question_user_massage_cons\" id=\"course_question_user_massage_cons_Id${total}\"\n" +
                        "                             onclick=\"answerShowOrHidden(${total})\">\n" +
                        "                            <div class=\"course_question_user_massage_con\">\n" +
                        "                                <div class=\"course_play_user_massage_question\">${courseQuestion.title}</div>\n" +
                        "\n" +
                        "                                <div class=\"course_play_user_massage_question_infor\">\n" +
                        "                                    <span class=\"course_question_user_massage_name\">提问者:&nbsp;<a title=\"${courseQuestion?.consumer?.name}\"\n" +
                        "                                                                                                 href=\"${createLink(controller: 'my', action: 'userSpace', params: [id: courseQuestion.consumer.id])}\">${CTools.cutString(courseQuestion?.consumer?.name, 8)}</a>\n" +
                        "                                    </span>\n" +
                        "                                    <span class=\"course_question_user_massage_time\">提问时间:&nbsp;<a>" + courseQuestion.createDate.toLocaleString() + " </a>\n" +
                        "                                    </span>\n" +
                        "                                </div>\n" +
                        "\n" +
                        "                            </div>\n" +
                        "\n" +
                        "                            <div class=\"my_quesion\"><a id=\"answer_Question_Id${total}\"\n" +
                        "                                                       onclick=\"iAnswerQuestion(${total})\">我来回答</a></div>\n" +
                        "                        </div>\n" +
                        "\n" +
                        "                    </div>\n" +
                        "\n" +
                        "                </div>";
                appendHtml += "<div class=\"course_question_user_back\" id=\"course_question_user_back${total}\" style=\"display:none\">\n" +
                        "                    <h4 class=\"question_ye\">我的回答</h4>\n" +
                        "\n" +
                        "                    <div class=\"course_question_back_input\">\n" +
                        "                        <label>\n" +
                        "                            <textarea class=\"question_content\" id=\"question_content${total}\"></textarea>\n" +
                        "                        </label>\n" +
                        "                    </div>\n" +
                        "\n" +
                        "                    <div class=\"course_question_back_up\">\n" +
                        "                        <input type=\"button\" class=\"course_question_back_solution\" value=\"提交回答\"\n" +
                        "                               onclick=\"submitQusetionSolution(${total}, ${courseQuestion.id}, ${session?.consumer?.id})\"/>\n" +
                        "                    </div>"
                if (courseQuestion?.rightAnswer != null) {
                    appendHtml += " <h5 class=\"question_back_size\">最佳答案<span class=\"question_back_size_icon\"></span></h5>\n" +
                            "\n" +
                            "                        <div class=\"course_question_back_items\">\n" +
                            "\n" +
                            "                            <div class=\"cquestion_back_bg\">\n" +
                            "                                <div class=\"course_question_back_item_con\">${courseQuestion?.rightAnswer?.content}</div>\n" +
                            "\n" +
                            "                                <div class=\"course_question_back_item_infor\">\n" +
                            "                                    <span class=\"course_question_user_massage_name\">回答者：<a title=\"${courseQuestion?.rightAnswer?.consumer?.name}\" class=\"${courseQuestion?.rightAnswer?.consumer?.name}\"\n" +
                            "                                                                                           href=\"${createLink(controller: 'my', action: 'userSpace', params: [id: courseQuestion?.rightAnswer?.consumer.id])}\">${CTools.cutString(courseQuestion?.rightAnswer?.consumer?.name, 4)}</a>\n" +
                            "                                    </span>\n" +
                            "                                    <span class=\"course_question_user_massage_time\"><g:formatDate date=\"${courseQuestion?.rightAnswer?.createDate}\" format=\"yyyy-MM-dd HH:mm:ss\"></g:formatDate> </span>\n" +
                            "                                </div>\n" +
                            "\n" +
                            "                            </div>\n" +
                            "                        </div>";
                } else {
                    appendHtml += "<h5 class=\"question_back_size\">最佳答案<span class=\"question_back_size_icon\"></span></h5>\n" +
                            "\n" +
                            "                        <div class=\"course_question_back_items\">\n" +
                            "\n" +
                            "                            <div class=\"cquestion_back_bg\">\n" +
                            "                                <div class=\"course_question_back_item_con\">暂无</div>\n" +
                            "                            </div>\n" +
                            "                        </div>";
                }
                appendHtml += "<h5 class=\"course_question_back_all\" id=\"course_question_back_all${total}\">全部回答</h5>";
                result.appendHtml = appendHtml;
                result.courseTotal = total;




                return render(result as JSON);
            }
        }
    }
    //保存回答
    def saveCourseAnswer() {
        if ((!session.consumer) || (session.consumer.name == "anonymity")) {
            return redirect(controller: 'index', action: 'login')
        } else {
            def courseQuestionId = params.courseQuestionId;
            def courseAnswerContent = params.courseAnswerContent;
            CourseAnswer courseAnswer;
            if (courseQuestionId && courseAnswerContent) {
                CourseQuestion courseQuestion = CourseQuestion.get(courseQuestionId);
                if (courseQuestion) {
                    courseAnswer = new CourseAnswer();
                    courseAnswer.courseQuestion = courseQuestion;
                    courseAnswer.consumer = session.consumer;
                    courseAnswer.content = courseAnswerContent;
                    courseAnswer.save(flush: true)
                    return render(contentType: "text/json") {
                        model:
                        [
                                courseAnswerConsumer    : courseAnswer.consumer,
                                courseAnswer            : courseAnswer,
                                "courseAnswerCreateDate": new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(courseAnswer.createDate),//因为后天台js获取的数据时间不对
                                courseQuestion          : courseAnswer.courseQuestion
                        ]
                    }
                }
            } else {
                return render(contentType: "text/json") {
                    model:
                    [
                            "saveError": "保存失败"
                    ]
                }
            }
        }
    }
    //采纳答案
    def acceptionRightAnswer() {
        if ((!session.consumer) || (session.consumer.name == "anonymity")) {
            return redirect(controller: 'index', action: 'login')
        } else {
            def courseAnswerId = params.courseAnswerId;
            def courseQuestionId = params.courseQuestionId;
            if (courseAnswerId && courseQuestionId) {
                CourseAnswer courseAnswer = CourseAnswer.get(courseAnswerId);
                CourseQuestion courseQuestion = CourseQuestion.get(courseQuestionId);
                if (courseAnswer && courseQuestion) {
                    courseQuestion.removeFromAnswer(courseAnswer);
                    courseQuestion.rightAnswer = courseAnswer;

                    courseQuestion.save(flash: true);
                }
            }
            return chain(action: "courseView", params: params);
        }
    }
    //保存评论
    def saveRemark() {
        def result = [:];
        int total = 0;
        if ((!session.consumer) || (session.consumer.name == "anonymity")) {
            return redirect(controller: 'index', action: 'login')
        } else {
            def serialId = params.serialId;
            def rank = params.rank;
            def content = params.remarkContent;
            Serial serial = Serial.get(serialId);
            Remark remark;
            if (serial) {
                remark = new Remark();
                remark.content = content;
                remark.topic = serial.name;
                remark.dateModified = new Date()
                remark.consumer = session.consumer
                remark.program = serial.program;
                remark.dateCreated = new Date();
                remark.isPass = servletContext.remarkAuthOpt == 0 ? true : false;
                remark.save(flash: true);
                if(rank){
                   List<Remark> remarkList = Remark.findAllByConsumerAndProgram(session.consumer,serial.program);
                   List<Integer> scoreList = [];
                    remarkList?.each {
                        if(it.rank>0){
                            scoreList.add(it.rank);
                        }
                    }
                    if(scoreList.size()==0){
                        remark.rank = rank as int;
                        remark.save(flash: true);

                        //资源评分保存
                        programService.saveProgramScore(serial.program.id);
                        result.isFlag = true;
                    }else {
                        def program = Program.get(serial.program.id);
                        List<Remark> remarkList2 = Remark.findAllByProgram(program);
                        program.remarkNum = remarkList2.size();
                        program.save(flash: true);
                        result.isFlag = false;
                    }
                }
            }
            if (params.remarkTotal) {
                total = params.remarkTotal as int;
            }
            def appendHtml = "";
            appendHtml += "<div class=\"boful_course_play_class_item\">\n" +
                    "                    <div class=\"course_play_user_massage\">\n" +
                    "                        <a title=\"${remark?.consumer?.name}\" href=\"${createLink(controller: 'my', action: 'userSpace', params: [id: remark?.consumer?.id])}\">\n" +
                    "                            <div class=\"course_others_talkback_item_image\">\n" +
                    "                                <img src=\"${generalUserPhotoUrl(consumer: remark?.consumer)}\"\n" +
                    "                                     \"/>\n" +
                    "                            </div></a>\n" +
                    "                        <p>\n" +
                    "                            <span class=\"course_play_user_massage_name\"><a title=\"${remark?.consumer?.name}\"\n" +
                    "                                                                           href=\"${createLink(controller: 'my', action: 'userSpace', params: [id: remark.consumer.id])}\">${CTools.cutString(remark?.consumer?.name, 8)}</a></span>\n" +
                    "                            <span class=\"course_play_user_massage_time\">";
            def dd = new SimpleDateFormat("yyyy-MM-dd").format(remark?.dateCreated);
            appendHtml += dd;
            appendHtml += "</span></p></div>\n" +
                    "\n" +
                    "                    <h3 class=\"course_play_user_massage_title\"></h3>\n" +
                    "\n" +
                    "                    <div class=\"course_play_user_massage_talk\">${CTools.cutString(remark?.content, 50)}</div>\n" +
                    "\n" +
                    "                    <a><div class=\"course_play_user_massage_talk_back\" id=\"course_play_user_massage_talk_back_Id${total}\"\n" +
                    "                            onclick=\"showRemarkReplys(${total})\">回复数：${remark.replyNum}</div></a>\n" +
                    "\n" +
                    "                    <div class=\"course_others_talkback\" id=\"course_others_talkback_Id${total}\" style=\"display: none\">\n" +
                    "                        <div class=\"course_others_talkback_input\">\n" +
                    "                            <label>\n" +
                    "                                <textarea id=\"remarkReply${total}\"></textarea>\n" +
                    "                            </label>\n" +
                    "\n" +
                    "                            <div class=\"course_others_talkback_but\">\n" +
                    "                                <label>\n" +
                    "                                    <input type=\"button\" value=\"提交回复\" class=\"\"\n" +
                    "                                           onclick=\"submitRemarkReply(${total}, ${remark.id})\">\n" +
                    "                                </label>\n" +
                    "                            </div>\n" +
                    "                        </div>" +
                    "<div class=\"course_others_talkback_items\" id=\"course_others_talkback_items_Id${total}\">" +
                    "</div>";
            result.appendHtml = appendHtml;
            result.total = total;
            result.isPass = servletContext.remarkAuthOpt == 0 ? true : false;
            return render(result as JSON);
        }
    }
    //保存评论回复
    def saveRemarkReply() {
        if ((!session.consumer) || (session.consumer.name == "anonymity")) {
            return redirect(controller: 'index', action: 'login')
        } else {
            Remark remark = Remark.get(params.remarkId);
            def content = params.content;
            RemarkReply remarkReply;
            if (remark && content) {
                remarkReply = new RemarkReply();
                remarkReply.content = content;
                remarkReply.remark = remark;
                remarkReply.dateCreated = new Date();
                remarkReply.consumer = session.consumer;
                remark.replyNum += 1;
                remarkReply.save(flash: true);
                return render(contentType: "text/json") {
                    model:
                    [
                            consumer               : remarkReply.consumer,
                            remarkReply            : remarkReply,
                            "remarkReplyCreateDate": new SimpleDateFormat("yyyy-MM-dd").format(remarkReply.dateCreated),//因为后天台js获取的数据时间不对
                    ]
                }

            } else {
                return render {
                    params:
                    ["saveError": "添加失败"]
                }
            }
        }
    }

    def createNote() {
        def result = [:];
        def consumerId = params.consumerId;
        def serialId = params.serialId;
        def timeLength = params.timeLength;
        def note = params.note;
        def canPublic = false;
        if ("false".equals(params.canPublic)) {
            canPublic = false;
        } else if ("true".equals(params.canPublic)) {
            canPublic = true;
        }


        if (consumerId && serialId && timeLength && note) {
            Consumer consumer = Consumer.findById(consumerId as long);
            Serial serial = Serial.findById(serialId as long);
            ProgramNote programNote = new ProgramNote();
            programNote.serial = serial;
            programNote.canPublic = canPublic;
            programNote.consumer = consumer;
            programNote.logicLength = Double.parseDouble(timeLength).intValue();
            programNote.program = serial.program;
            programNote.content = note;
            programNote.save(flush: true);

            result.success = true;
            result.msg = "参数不全";
        } else {
            result.success = false;
            result.msg = "参数不全";
        }

        return render(result as JSON);
    }

    def listMyNote() {
        def result = [:];
        def serialId = params.serialId;
        def consumerId = params.consumerId;
        if (serialId && consumerId) {
            Serial serial = Serial.findById(serialId);
            Consumer consumer = Consumer.findById(consumerId);
            def notes = ProgramNote.findAllByConsumerAndSerial(consumer, serial, [sort: "createDate", order: "asc"]);
            result.success = true;
            result.notes = formatNotes(notes);
        } else {
            result.success = false;
        }
        return render(result as JSON);
    }

    def listNewNote() {
        def result = [:];
        def serialId = params.serialId;
        if (serialId) {
            Serial serial = Serial.findById(serialId);
            def notes = ProgramNote.withCriteria {
                eq("serial", serial)
                order("logicLength", "asc")
                order("createDate", "desc")
                eq("canPublic", true)
            }
            result.success = true;
            result.notes = formatNotes(notes);
        } else {
            result.success = false;
        }
        return render(result as JSON);
    }

    def listVoteNote() {
        def result = [:];
        def serialId = params.serialId;
        if (serialId) {
            Serial serial = Serial.findById(serialId);
            def notes = ProgramNote.withCriteria {
                eq("serial", serial)
                order("logicLength", "asc")
                order("recommend", "desc")
                eq("canPublic", true)
            }
            result.success = true;
            result.notes = formatNotes(notes);
        } else {
            result.success = false;
        }
        return render(result as JSON);
    }

    def voteNote() {
        def result = [:];
        def noteId = params.noteId;
        def consumerId = params.consumerId;
        if (noteId && consumerId) {
            ProgramNote programNote = ProgramNote.findById(noteId);
            Consumer consumer = Consumer.findById(consumerId);

            if (programNote && consumer) {
                int count = NoteRecommend.countByConsumerAndProgramNote(consumer, programNote);
                if (count == 0) {
                    programNote.recommend++;
                    NoteRecommend noteRecommend = new NoteRecommend();
                    noteRecommend.consumer = consumer;
                    noteRecommend.programNote = programNote;
                    programNote.noteRecommends.add(noteRecommend);
                    programNote.save(flush: true);
                    result.success = true;
                    result.voteNum = programNote.recommend;
                } else {
                    result.success = false;
                    result.msg = "你已经投过票";
                }
            } else {
                result.success = false;
                result.msg = "未登录！";
            }
        } else {
            result.success = false;
            result.msg = "参数不全！";
        }
        return render(result as JSON);
    }

    private static List formatNotes(List<ProgramNote> noteList) {
        def notes = [];
        noteList.each { ProgramNote programNote ->
            def tmp = [:];
            tmp.id = programNote.id;
            tmp.content = programNote.content;
            tmp.createDate = Date.parse("yyyyMMddHHmmss", programNote.createDate).format("MM月dd日");
            tmp.voteNum = programNote.noteRecommends.size();
            tmp.consumer = [name: programNote.consumer.name, id: programNote.consumer.id];
            tmp.timeLength = TimeLengthUtils.NumberToString(programNote.logicLength);
            notes.add(tmp);
        }
        return notes;
    }
    def playPhotoDomes = {
        List<Program> programList = Program.list(max: 100);
        return render(view: 'playPhotoDomes', model: [programList: programList]);
    }

    def error = {
        return render(view: 'error');
    }
    def audioIndex = {
        def newProgramList = []; //最新资源前十条
        def programMap = [:];//            分类
        def hotProgramList = []; //热门资源
        def recommendNumList = []; //推荐排行
        def audioTypeOne = []; //精选分类
        def programTagsHot = []; //热门标签
        def audioName = ''; // 音频分类名

        //资源分类
        ProgramCategory audioSuperCategory;
        if(params.categoryId){
             audioSuperCategory = ProgramCategory.get(params.categoryId as long);
        } else {
            audioSuperCategory = programCategoryService.queryAudioCategory();
        }

        //推荐熟
        recommendNumList = programService.search([max: 10, offset: 0, otherOption: Program.ONLY_AUDIO_OPTION,programCategoryId: audioSuperCategory.id, orderBy: "recommendNum", order: "desc"], false);
        //最新资源
        newProgramList = programService.search([max: 10, offset: 0, otherOption: Program.ONLY_AUDIO_OPTION,programCategoryId: audioSuperCategory.id, orderBy: "dateCreated", order: "desc"], false);
        hotProgramList = programService.search([max: 10, offset: 0, otherOption: Program.ONLY_AUDIO_OPTION,programCategoryId: audioSuperCategory.id, orderBy: "frequency", order: "desc"], false);


        try {
            audioTypeOne = programCategoryService.querySubCategory(audioSuperCategory);
            audioTypeOne?.each{
                def audioList = programService.search([otherOption: Program.ONLY_AUDIO_OPTION, programCategoryId: it.id, max: 8, offset: 0], false);
                if(audioList && audioList.size()>0) {
                    programMap.put(it.name, audioList);
                }
            }
            programTagsHot = programService.queryHotProgramTag(Program.ONLY_AUDIO_OPTION, audioSuperCategory.id);
            // 获取音频分类资源名
            audioName = audioSuperCategory.name;
        } catch (Exception e) {
//            flash.message=e.getMessage();
            log.error(e.getMessage())
        }
        return render(view: 'audioIndex', model: [newProgramList: newProgramList, programMap: programMap,
                                                  hotProgramList: hotProgramList, recommendNumList: recommendNumList, audioTypeOne: audioTypeOne,
                                                  programTagsHot: programTagsHot, audioName: audioName,programCategory:audioSuperCategory]);
    }

    def ouknowNewIndex = {
        return render(view: 'ouknowNewIndex');
    }
    def error500 = {
        return render(view: '/error500');
    }

    @ActionNameAnnotation(name="mooc首页")
    def moocIndex() {
        if(!params.categoryId)params.categoryId = null;
        if(!params.offset)params.offset=0;
        if(!params.max)params.max=10;
        if(!params.sort)params.sort="dataCreated";
        if(!params.order)params.order="desc";
        def courseMap = courseAppService.queryCourseList(params);
        def categoryMap = courseAppService.queryCategoryList();
        def mooc = SystemConfig.getMoocAddressAndPort();
        def categoryName = null;
        if(params.categoryId){
            def res =courseAppService.queryCategoryById(params.categoryId);
            categoryName = res.name;
        }
        return render(view: 'moocIndex', model: [categoryName: categoryName, categoryId: params.categoryId, mooc: mooc, courseList: courseMap?.courseList, total: courseMap?.total, categoryList: categoryMap?.categoryList]);
    }

    def validateLogin(){
        def result = [:];
        def consumer = session.consumer;
        if(consumer){
            if(consumer.name!="anonymity"){
                result.success=true;
                result.id = consumer.id;
                result.name = consumer.name;
                result.photo=consumer.photo;
            }
        }
        return render(result as JSON)
    }

    /**
     * 查询分类下的资源
     * @return
     */
    def programQuery() {
        def result = [:];
        def categoryId = params.categoryId;
        if (categoryId) {
            ProgramCategory secondCategory = ProgramCategory.get(categoryId as long);
            def mediaType = secondCategory?.parentCategory?.mediaType;
            List<Program> subProgramList;
            def programType = "video";
            if (secondCategory.mediaType == 3) {
                programType = "doc"
                subProgramList = programService.search([programCategoryId: secondCategory.id, order: "desc", orderBy: "id", max: 10, offset: 0], false);
            } else {
                subProgramList = programService.search([programCategoryId: secondCategory.id, order: "desc", orderBy: "id", max: 8, offset: 0], false);
            }
            result.success = true;
            result.className = programType;
            result.mType = mediaType;
            result.programList = subProgramList;
        } else {
            result.success = false;
            result.msg = "参数不全";
        }
        return render(result as JSON)
    }

    /**
     * 查询热门资源,推荐资源用(文档,视频)
     */
    def programQueryByOtherOption() {
        def result = [:];
        def type = params.type;
        def programList = [];
        if (type) {
            if (type == "remen") {
                //首页海报大图显示推荐资源
                programList = programService.search([state: Program.PUBLIC_STATE, canPublic: true, max: 8, order: "desc", orderBy: "recommendNum"], false);
            } else if (type == "videoTuijian") {
                //推荐资源
                programList = programService.search([otherOption: Program.ONLY_VIDEO_OPTION, state: Program.PUBLIC_STATE, canPublic: true, max: 12, order: "desc", orderBy: "recommendNum"], false);
            } else if (type == "docTuijian") {
                //文档排行
                programList = programService.search([otherOption: Program.ONLY_TXT_OPTION, state: Program.PUBLIC_STATE, canPublic: true, max: 6, offset: 0, order: "desc", orderBy: "recommendNum"], false);
            }
            result.success = true;
            result.programList = programList;
        } else {
            result.success = false;
            result.msg = "参数不全";
        }
        return render(result as JSON)
    }
}
