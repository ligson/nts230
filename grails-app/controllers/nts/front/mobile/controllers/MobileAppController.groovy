package nts.front.mobile.controllers

import com.boful.common.date.utils.TimeLengthUtils
import com.boful.common.file.utils.FileType
import com.boful.common.file.utils.FileUtils
import com.sun.xml.internal.messaging.saaj.packaging.mime.internet.MimeUtility
import grails.converters.JSON
import nts.activity.domain.UserActivity
import nts.activity.domain.UserVote
import nts.activity.domain.UserWork
import nts.program.category.domain.CategoryFacted
import nts.program.category.domain.FactedValue
import nts.program.domain.CollectedProgram
import nts.program.domain.PlayedProgram
import nts.program.domain.Program
import nts.program.category.domain.ProgramCategory
import nts.program.domain.ProgramTag
import nts.program.domain.Remark
import nts.program.domain.RemarkReply
import nts.program.domain.Serial
import nts.program.domain.ViewedProgram
import nts.system.domain.Directory
import nts.system.domain.News
import nts.system.domain.OperationEnum
import nts.system.domain.OperationLog
import nts.system.domain.RMSCategory
import nts.user.domain.Consumer
import nts.utils.CTools
import org.apache.commons.lang.StringUtils
import org.apache.http.HttpEntity
import org.apache.http.HttpResponse
import org.apache.http.client.HttpClient
import org.apache.http.client.methods.HttpGet
import org.apache.http.impl.client.HttpClientBuilder
import org.springframework.web.multipart.commons.CommonsMultipartFile

import java.text.DateFormat;
import java.text.SimpleDateFormat

class MobileAppController {

    def programService;
    def userService;
    def searchService;
    def programCategoryService;

    // 登录验证
    def checkLogin() {
        // 返回结果
        def result = [:];

        // 登录验证
        result = userService.checkLogin(params);

        if (result.success) {
            // 根据登录帐号和密码获取客户信息
            def consumer = Consumer.findByName(params.loginName);

            if (consumer.name != 'anonymity') {
                consumer.loginNum = consumer.loginNum + 1
                consumer.dateLastLogin = new Date()
                //---将登陆信息写入日志 nts.system.domain.OperationLog
                new OperationLog(tableName: 'consumer', tableId: consumer.id, operator: consumer.name, modelName: '用户登陆', brief: '登陆操作', operatorId: consumer.id, operation: OperationEnum.LOGIN).save();
            }
            result.consumerId = consumer.id;
            result.consumerName = consumer.name;
        }

        return render(result as JSON)
    }

    def consumerPhoto() {
        // 返回结果
        def result = [:];

        def consumerId = params.consumerId;
        if (consumerId) {
            def consumer = Consumer.get(consumerId as int);
            if (consumer.photo) {
                result.src = "/upload/photo/${consumer.photo}";
            }
        }

        return render(result as JSON);
    }

    def mobileRegister() {
        def result = [:];

        if (params.name && params.password) {
            params.nickname = params.name;
            params.chkPassword = params.password
            params.request = request;
            // 有效时间，默认一年
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.YEAR, 1);
            params.dateValid = new java.text.SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());

            params.consumer = session.consumer;

            def registerResult = userService.register(params);
            if (registerResult.isOK) {
                result.consumerId = registerResult.id;
                result.consumerName = registerResult.name
            } else {
                result.msg = '注册失败'
            }
        } else {
            result.msg = "参数不全";
        }

        return render(result as JSON)
    }

    def acquireRecordPlay() {
        def result = [:];

        //获得用户组
        def paramConsumerId = params.consumerId;
        def sessionConsumerId = session.consumer.id;

        if (paramConsumerId || sessionConsumerId) {
            Consumer consumer
            if (paramConsumerId) {
                consumer = Consumer.get(paramConsumerId as long);
            } else {
                consumer = Consumer.get(sessionConsumerId as long);
            }

            List playedPrograms = [];

            //找到该用户的所有PlayedProgram，对program分组，找到所有program
            List programIdList = PlayedProgram.executeQuery("select program.id from PlayedProgram where consumer.id=:consumerId group by program.id order by playDate desc", [consumerId: consumer.id]);
            programIdList.each {
                //在PlayedProgram，找到所有某个program的所有播放记录，按照播放时间，降序排序
                List playedProgramList = PlayedProgram.executeQuery("from PlayedProgram where program.id=:programId order by playDate desc", [programId: it]);

                PlayedProgram playedProgram = null;
                if (playedProgramList && playedProgramList.size() > 0) {
                    //因为是播放时间降序排序，所以第一个就是最后一次播放
                    playedProgram = playedProgramList[0];
                }

                //播放记录材质，且播放的program是公开的，  避免后期，后台更改资源状态后，前台还会显示
                if (playedProgram && playedProgram.program && playedProgram.serial && playedProgram.program.state == Program.PUBLIC_STATE) {
                    def program = [:];
                    program.id = playedProgram.program.id;
                    program.name = playedProgram.program.name;
                    program.frequency = playedProgram.program.frequency;
                    program.downloadNum = playedProgram.program.downloadNum;
                    program.programScore = playedProgram.program.programScore;
                    program.src = acquirePosterUrl(playedProgram.program, params.size, -1);
                    program.option = playedProgram.program.otherOption;
                    program.playDate = playedProgram.playDate.format("yyyy-MM-dd");
                    if (FileType.isVideo(playedProgram.serial.filePath)) {
                        program.timeLength = TimeLengthUtils.formatTime(TimeLengthUtils.NumberToString(playedProgram.timeLength));
                    } else {
                        program.timeLength = playedProgram.timeLength;
                    }
                    program.serialId = playedProgram.serial.id;
                    program.serialName = playedProgram.serial.name;
                    program.serialNo = playedProgram.serial.serialNo; //当前播放的第几集
                    def serial = playedProgram.serial;
                    def serialList = playedProgram.serial.program?.serials?.toList();
                    def serialList2 = [];
                    if (serialList && serialList.size() > 0) {
                        serialList2 = serialList.sort { serial1, serial2 ->
                            serial1.serialNo <=> serial1.serialNo;
                        }
                        def length = serialList2.size();
                        for (int i = 0; i < length; i++) {
                            if (serial.id == serialList2[i].id) {
                                if (serialList2[i + 1]?.id) {
                                    program.nextSerialId = serialList2[i + 1]?.id;
                                    program.nextSerialName = serialList2[i + 1]?.name;
                                    program.nextSerialNo = serialList2[i + 1]?.serialNo;
                                }
                                break;
                            }
                        }
                    }
                    playedPrograms.add(program);
                }
            }

            result.playedPrograms = playedPrograms;
            result.errorFlag = false;
        } else {
            result.errorFlag = true;
            result.msg = "";
        }
        return render(result as JSON)
    }

    def acquireCategory() {
        def result = [:];

        // 取得一级分类
        List<ProgramCategory> categoryList = programCategoryService.querySubCategory(programCategoryService.querySuperCategory());

        List frist = [];

        categoryList.each {
            def firstCategory = [:];
            firstCategory.categoryId = it.id;
            firstCategory.categoryName = it.name;
            if (it.img) {
                firstCategory.img = "http://192.168.1.186:8080/upload/programCategoryImg/${it.img}"; ;
            }

            // 取得二级分类
            List<ProgramCategory> secondList = programCategoryService.querySubCategory(it);
            List second = [];
            secondList.each { sc ->
                def secondCategory = [:];
                secondCategory.categoryId = sc.id;
                secondCategory.categoryName = sc.name;
                second.add(secondCategory);
            }
            firstCategory.secondCategoryList = second;
            frist.add(firstCategory);
        }
        result.firstCategoryList = frist;

        return render(result as JSON);
    }


    private String acquirePosterUrl(Program program, String size, int postion) {
        try {
            if (program.posterPath && program.posterType && program.posterHash) {
                def url = programService.generalFilePoster(program.posterHash, size, postion);
                if (url) {
                    return new URL(url).openConnection().getInputStream().getText("UTF-8");
                } else {
                    return "${resource(dir: '/skin/blue/pc/front/images', file: 'boful_default_img.png')}";
                }
            } else {
                if (program.otherOption == Program.ONLY_FLASH_OPTION) {
                    return "${resource(dir: 'images/flash', file: 'flash-imgs.png')}";
                } else {
                    def url = programService.generalProgramPoster(program, size, postion);
                    if (url) {
                        return new URL(url).openConnection().getInputStream().getText("UTF-8");
                    } else {
                        return "${resource(dir: '/skin/blue/pc/front/images', file: 'boful_default_img.png')}";
                    }
                }
            }
        } catch (Exception e) {
            if (program.otherOption == Program.ONLY_FLASH_OPTION) {
                return "${resource(dir: 'images/flash', file: 'flash-imgs.png')}";
            } else {
                return "${resource(dir: '/skin/blue/pc/front/images', file: 'boful_default_img.png')}";
            }
        }
    }


    def carousel() {
        def result = [:];

        List<Program> programList = programService.search(params, false);
        def list = [];
        programList?.each {
            if (it.otherOption == Program.ONLY_AUDIO_OPTION || it.otherOption == Program.ONLY_VIDEO_OPTION
                    || it.otherOption == Program.ONLY_TXT_OPTION || it.otherOption == Program.ONLY_IMG_OPTION) {
                def program = [:];
                program.id = it.id;
                program.name = it.name;
                program.src = acquirePosterUrl(it, params.size, -1);
                program.option = it.otherOption;
                list.add(program);
            }
        }
        result.list = list;
        return render(result as JSON);
    }

    def programSearchAll() {
        def result = [:];

        List<ProgramCategory> categoryList = programCategoryService.querySubCategory(programCategoryService.querySuperCategory());
        def max = params.max ? params.max as int : 3;
        def clist = [];
        categoryList?.each { ProgramCategory category ->
            if (category.mediaType == 1 || category.mediaType == 2 || category.mediaType == 3 || category.mediaType == 4) {
                def tmpMap = [:];
                tmpMap.mediaType = category.mediaType;
                tmpMap.categoryId = category.id;
                tmpMap.categoryName = category.name;
                def programList = programService.search([programCategoryId: category.id, order: "desc", orderBy: "id", max: max, offset: 0], false);
                def plist = [];
                programList.each {
                    def program = [:];
                    program.id = it.id;
                    program.name = it.name;
                    program.src = acquirePosterUrl(it, params.size, -1);
                    program.option = it.otherOption;
                    plist.add(program);
                }
                if(plist.size()>0) {
                    tmpMap.programList = plist;
                    clist.add(tmpMap);
                }
            }

        }

        result.categoryList = clist;
        return render(result as JSON);
    }

    def programSearchByCategoryId() {
        def result = [:];
        def programs = programService.search(params, false);
        def programList = [];
        programs.each {
            if (it.otherOption == Program.ONLY_AUDIO_OPTION || it.otherOption == Program.ONLY_VIDEO_OPTION
                    || it.otherOption == Program.ONLY_TXT_OPTION || it.otherOption == Program.ONLY_IMG_OPTION) {
                def program = [:];
                program.id = it.id;
                program.name = it.name;
                program.src = acquirePosterUrl(it, params.size, -1);
                program.option = it.otherOption;
                program.frequency = it.frequency;
                program.downloadNum = it.downloadNum;
                program.programScore = it.programScore;
                program.desc = it.description;
                program.dateCreated = it.dateCreated.format("yyyy-MM-dd");
                programList.add(program);
            }
        }

        result.programList = programList;
        return render(result as JSON);
    }

    def initializeCategory() {
        def result = [:];

        // 取得一级分类
        List<ProgramCategory> categoryList = programCategoryService.querySubCategory(programCategoryService.querySuperCategory());

        List frist = [];

        categoryList.each {
            if (it.mediaType == 1 || it.mediaType == 2 || it.mediaType == 3 || it.mediaType == 4) {
                def firstCategory = [:];
                firstCategory.firstcId = it.id;
                firstCategory.firstcName = it.name;

                // 取得二级分类
                List<ProgramCategory> secondList = programCategoryService.querySubCategory(it);
                List second = [];
                secondList.each { sc ->
                    if (it.mediaType == 1 || it.mediaType == 2 || it.mediaType == 3 || it.mediaType == 4) {
                        def secondCategory = [:];
                        secondCategory.secondcId = sc.id;
                        secondCategory.secondcName = sc.name;
                        second.add(secondCategory);
                    }
                }
                firstCategory.secondCategoryList = second;
                frist.add(firstCategory);
            }

        }
        result.firstCategoryList = frist;
        return render(result as JSON);
    }

    def initializeFacet() {
        def result = [:];
        def categoryFacetList = [];
        def facetList = CategoryFacted.list([order: 'asc', sort: 'orderIndex']);
        if (facetList && facetList.size() > 0) {
            def tmpMap = [:];
            facetList.each { CategoryFacted facted ->
                if (facted.category.mediaType == 1 || facted.category.mediaType == 2
                        || facted.category.mediaType == 3 || facted.category.mediaType == 4) {
                    tmpMap = [:];
                    tmpMap.cId = facted.category.id;
                    tmpMap.fId = facted.id;
                    tmpMap.fName = facted.name;
                    tmpMap.enName = facted.enName;
                    def values = facted.values.toList();
                    values.sort { FactedValue value1, value2 ->
                        value1.orderIndex <=> value2.orderIndex;
                    }
                    def valList = [];
                    def valMap = [:];
                    values?.each { FactedValue value ->
                        valMap = [:];
                        valMap.vId = value.id;
                        valMap.content = value.contentValue
                        valList.add(valMap)
                    }
                    tmpMap.values = valList;
                    categoryFacetList.add(tmpMap);
                }
            }
        }

        result.categoryFacetList = categoryFacetList;
        return render(result as JSON);
    }

    /**
     * 分面列表
     */
    def categoryQueryByCategoryId() {
        def result = [:];
        def categoryId = params.categoryId;
        def categoryList = [];
        def categoryFacetList = [];
        if (categoryId) {
            ProgramCategory category = ProgramCategory.get(categoryId as long);
            if (category) {
                List<ProgramCategory> categoryList2 = ProgramCategory.findAllByParentCategory(category);
                categoryList2?.each { ProgramCategory category2 ->
                    def tmp = [:];
                    tmp.cId = category2.id;
                    tmp.cName = category2.name;
                    categoryList.add(tmp);
                }
                def facetList = CategoryFacted.findAllByCategory(category, [order: 'asc', sort: 'orderIndex']);
                if (facetList && facetList.size() > 0) {
                    def tmpMap = [:];
                    facetList.each { CategoryFacted facted ->
                        tmpMap = [:];
                        tmpMap.fId = facted.id;
                        tmpMap.fName = facted.name;
                        tmpMap.enName = facted.enName;
                        def values = facted.values.toList();
                        values.sort { FactedValue value1, value2 ->
                            value1.orderIndex <=> value2.orderIndex;
                        }
                        def valList = [];
                        def valMap = [:];
                        values?.each { FactedValue value ->
                            valMap = [:];
                            valMap.vId = value.id;
                            valMap.content = value.contentValue
                            valList.add(valMap)
                        }
                        tmpMap.values = valList;
                        categoryFacetList.add(tmpMap);
                    }
                }
                result.categoryName = category.name;
                result.categoryList = categoryList;
                result.categoryFacetList = categoryFacetList;
            } else {
                result.msg = "没有对应的分类";
            }
        } else {
            result.msg = "参数不全";
        }
        return render(result as JSON)
    }

    def checkProgram = {
        def result = [:];

        Program program = null;

        if (params.programId) {
            program = Program.get(params.programId as Long);
            if (program?.serials?.size() == 0) {
                result.msg = program?.name + "下没有子资源";
                return render(result as JSON);
            }
            if (!program) {
                result.msg = "对不起,你所要查找的数据不存在!";
                return render(result as JSON);
            }
        } else {
            result.msg = "对不起,你所要查找的数据不存在!";
            return render(result as JSON);
        }

        if (!program) {
            result.msg = "点播的资源不存在!";
            return render(result as JSON);
        }

        def canPlay = programService.canPlay(session.consumer, Program.get(params.programId as Long));
        if (!canPlay) {
            if ((program.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                result.msg = "对不起，您没有权限学习该课程！"
                return render(result as JSON);
            } else {
                result.msg = "对不起，您没有权限点播该资源！"
                return render(result as JSON);
            }
        }
        return render(result as JSON);
    }

    def index = {
        if (!params.max) params.max = 6
        if (!params.sort) params.sort = 'submitTime'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0

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
        else
            redirect(action: categoryView)

        //[directoryList: directoryList]

    }

    // --- login 用户登陆验证方法   0 - 密码错误 1 - 用户不存在  2 - 用户已过期
    def login = {
        //
    }

    /*def checkLogin = {
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
                    *//*servletContext.programCount = nts.program.domain.Program.countByStateGreaterThan(nts.program.domain.Program.APPLY_STATE)

                    def programPlaySum = nts.program.domain.Program.createCriteria().get {
                        projections {
                            sum "frequency"
                        }
                    }

                    def programDownloadSum = nts.program.domain.Program.createCriteria().get {
                        projections {
                            sum "downloadNum"
                        }
                    }

                    //获取在线人数
                    servletContext.onlineNum = getOnlineNum()

                    //println programViewSum
                    //---获得节目点播次数 sum
                    servletContext.programPlaySum = programPlaySum
                    //---获得节目访问次数 sum
                    servletContext.programDownloadSum = programDownloadSum
                    *//*
                    if (consumer.name != 'anonymity') {
                        consumer.loginNum = consumer.loginNum + 1
                        consumer.dateLastLogin = new Date()
                        //---将登陆信息写入日志 nts.system.domain.OperationLog
                        new OperationLog(tableName: 'consumer', tableId: consumer.id, operator: consumer.name, modelName: '用户登陆', brief: '登陆操作', operatorId: consumer.id, operation: OperationEnum.LOGIN).save()


                    }

                    session.consumer = consumer

                    *//*if(params.from && params.from == "search") {
                        params.remove("name")
                        redirect(action: main, params: params)
                    }
                    else {
                        redirect(action: index)
                    }*//*
                } else {
                    redirect(action: loginError, params: [loginFlg: 1])
                }
            }
        } else {
            redirect(action: loginError, params: [loginFlg: 1])
        }
    }*/

    //资源详细页面
    def showProgram = {
        long t1 = System.currentTimeMillis()
        def program = Program.get(params.id)
        def programList = null
        def consumerList = null
        def otherProgramList = null
        def remarkList = null
        def bAuthOK = true    //是否认证通过
        def fromNodeName = ""
        def fromNode = null    //来源节点
        def isOutPlay = false    //是否来自外部播放，此专指用省图下级节点播放
        def arrOutPlay = null    //福建省图采集外部(子节点):0海报 1播放列表 2批量播放列表

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


        if (program) {
            //纯文库、视音频、图片时直接跳转
            if ((program.otherOption & Program.ONLY_IMG_OPTION) == Program.ONLY_IMG_OPTION) {
                return redirect(controller: 'program', action: 'photoShow', params: [programId: program.id])
            } else if ((program.otherOption & Program.ONLY_TXT_OPTION) == Program.ONLY_TXT_OPTION) {
                return redirect(controller: 'program', action: 'textLibrary', params: [programId: program.id])
            } else if ((program.otherOption & 0) == 0) {
            }

            if (program.serials.size() > 0) {
                Serial serial = programService.serialFirst(program);
                if (serial.urlType == Serial.URL_TYPE_LINK) {
                    return redirect(url: serial.filePath);
                }
            }

            if (bAuthOK) {

                //考虑到评论可能很多并可能要分页，故没用program.remarks
                //remarkList = nts.program.domain.Remark.findAllByProgramAndIsPass(program,1,[max:20,sort:'id',order:'desc'])

                //插入到浏览历史表并设置浏览次数if(session.consumer && session.consumer.name != 'anonymity')
                if (session.consumer && servletContext.viewLogOpt == 1) {
                    new ViewedProgram(consumer: session.consumer, program: program).save()
                    def consumerTemp = Consumer.get(session.consumer.id)
                    consumerTemp.viewNum++
                    consumerTemp.save(flush: true)
                }
                //program.viewNum++
                //program.save(flush: true)

                //手机暂不支持文档17
                def directoryList = Directory.findAll("from nts.system.domain.Directory as d where d.parentId=0 and d.showOrder>0 and d.id<>17 order by d.showOrder asc")

                //def topProgramList = nts.program.domain.Program.findAllByStateAndDirectory(nts.program.domain.Program.PUBLIC_STATE,program.directory,[max:10,sort:'frequency',order:'desc']);
                return [program: program, consumerList: consumerList, otherProgramList: otherProgramList, remarkList: remarkList, fromNode: fromNode, isOutPlay: isOutPlay, arrOutPlay: arrOutPlay, directoryList: directoryList]
            }
        } else {
            flash.message = "program not found with id ${params.id}"
            render "program not found with id ${params.id}"
        }
    }

    //资源浏览 右边资源列表
    def categoryView = {
        //long t1=System.currentTimeMillis()
        if (!params.max) params.max = 20
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        def total = 0
        def programList = null
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

        /*def offset = 0

        if(params.to == "pre")
            offset = nts.utils.CTools.nullToZero(params.offset) - nts.utils.CTools.nullToZero(params.max)
        else
            offset = nts.utils.CTools.nullToZero(params.offset) + nts.utils.CTools.nullToZero(params.max)*/

        //查询条件
        programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            //左边树条件

            if (directoryId > 0) {
                eq("directory.id", (long) directoryId)
            } else {
                ne("directory.id", 17L)
            }

            //关键词条件
            if (keyword) {
                //资源名称
                //if(type == 1) {
                ilike("name", "%${keyword}%")
                //}

            }

            //已入库并发布
            ge("state", Program.PUBLIC_STATE)


        }

        //用于页面上面目录
        //def directoryList = nts.system.domain.Directory.findAllByParentIdAndShowOrderGreaterThan ( 0,0,[ sort:"showOrder", order:"asc" ])
        //手机暂不支持文档17
        def directoryList = Directory.findAll("from nts.system.domain.Directory as d where d.parentId=0 and d.showOrder>0 and d.id<>17 order by d.showOrder asc")

        def directory = null

        if (directoryId > 0) directory = Directory.get(params.directoryId);




        def args = "directoryId=${params.directoryId}&keyword=${keyword}&max=${params.max}&sort=${params.sort}&order=${params.order}"

        return [programList: programList, total: programList?.totalCount, params: params, directoryList: directoryList, directory: directory, args: args]
    }

    //---新增getNowDate 用来获得“yyyy-MM-DD”格式的日期
    def getNowDate = {
        def date = new Date()
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd")
        def nowDate = dateFormat.format(date)
        return nowDate
    }

    //资源查询
    def programSearch() {
        def result = [:]

        List<Program> programList = programService.search(params, false)

        programList?.each {
            it.classLib = null
            it.collectedPrograms = null
            it.consumer = null
            it.directory = null
            it.distributePrograms = null
            it.downloadGroups = null
            it.downloadedPrograms = null
            it.metaContents = null
            it.playGroups = null
            it.playedPrograms = null
            it.programCategories = null
            it.programTags = null
            it.programTopics = null
            it.recommendedPrograms = null
            it.relationPrograms = null
            it.remarks = null
            it.serials = null
            it.studyCircles = null
            it.viewedPrograms = null
        }

        def total = programService.searchTotalCount(params) //true不分页，获得总数

        result.success = true;
        result.programList = programList;
        result.total = total;
        return render(result as JSON);
    }

    //资源海报截图地址
    def programPoster() {
        def result = [:]

        if (!params.width) params.width = -1
        if (!params.height) params.height = -1
        if (!params.position) params.position = -1

        if(params.id) {
            if(CTools.isNumber(params.id)) {
                def program = Program.get(params.id as long)
                def size = params.width + 'x' + params.height
                def url = ''

                if (program) {
                    if (program.posterPath && program.posterType && program.posterHash) {
                        url = programService.generalFilePoster(program.posterHash, size, params.position)
                    } else {
                        if (program.otherOption == Program.ONLY_FLASH_OPTION) {
                            url = "${resource(dir: 'images/flash', file: 'flash-imgs.png')}";
                        } else {
                            url = programService.generalProgramPoster(program, size, params.position);
                        }
                    }
                    if (!url) {
                        url = "${resource(dir: '/skin/blue/pc/front/images', file: 'boful_default_img.png')}";
                    }
                    result.success = true
                    result.url = url
                } else {
                    result.success = false
                    result.msg = "资源不存在"
                }
            } else {
                result.success = false
                result.msg = "参数类型不正确"
            }
        } else {
            result.success = false
            result.msg = "参数不全"
        }


        return render(result as JSON)
    }

    //资源播放地址
    def programPlayURL() {
        def result = [:]
        def url = ""
        def program = Program.get(params.programID)
        def serial = Serial.get(params.serialID)
        if (serial && program && serial.program == program) {
            def fileHash = serial.fileHash
            def fileType = serial.fileType
            def isPdf = false
            if (fileType.equals('pdf')) {
                isPdf = true
            }
            url = programService.generalFilePlayAddress(fileHash, isPdf).playList[0].url;

            result.success = true
            result.url = url
        } else {
            result.success = false
            result.msg = "参数不全或资源和子节目没关联"
        }
        return render(result as JSON)
    }

    //资源分类
    def programCategoryList() {
        def result = [:];
        def types = ["Video", "Course", "Audio", "Image", "Doc", "Flash"];
        def type = params.type;
        def parentCategoryId = params.parentCategoryId;
        def isAll = params.isAll;
        def programCategoryList = [];
        if (type && types.contains(type)) {
            programCategoryList = programCategoryService."query${type}Category"();
        } else if (parentCategoryId) {
            ProgramCategory category = ProgramCategory.findById(parentCategoryId as int);
            if (!category) {
                category = programCategoryService.querySuperCategory();
            }
            programCategoryList = programCategoryService.querySubCategory(category);
        } else if (isAll) {
//            programCategoryList = ProgramCategory.list();
            programCategoryList = programCategoryService.querySubAllCategory(programCategoryService.querySuperCategory());
        } else {
            result.success = false;
            result.msg = "参数不全";
        }



        programCategoryList?.each { ProgramCategory programCategory ->
            programCategory.programs = null;
            programCategory.facteds = null;
        }

        result.success = true;
        result.programCategoryList = programCategoryList;
        return render(result as JSON);
    }

    //资源信息
    def programInfo() {
        def result = [:]
        def programId = params.id
        Program program = null
        List<Serial> serialList = []

        if (programId) {
            program = Program.get(Long.parseLong(programId as String));
            if (program) {
                serialList = Serial.createCriteria().list {
                    eq("program", program)
                    order("serialNo", "asc")
                }

                serialList?.each {
                    it.program = null
                }

                //去掉关联数据，只要基本数据
                program.programTags = null;
                program.remarks = null;
                program.collectedPrograms = null;
                program.playedPrograms = null;
                program.downloadedPrograms = null;
                program.viewedPrograms = null;
                program.recommendedPrograms = null;
                program.relationPrograms = null;
                program.metaContents = null;
                program.playGroups = null;
                program.downloadGroups = null;
                program.programTopics = null;
                program.distributePrograms = null;
                program.studyCircles = null;
                program.factedValues = null;
                program.programCategories = null;
                program.classLib = null;
                program.directory = null;
                program.consumer = null;
                program.serials = null;

                result.success = true
                result.program = program
                result.serialList = serialList
            } else {
                result.success = false
                result.msg = '没有对应的资源'
            }
        } else {
            result.success = false
            result.msg = '参数不全'
        }

        return render(result as JSON)
    }

/*    //用户登录
    def userLogin() {
        def result = userService.checkLogin(params);
        return render(result as JSON)
    }*/

    //用户信息
    def userInfo() {
        def result = [:]

        def userID = params.id ? params.id : session.consumer.id
        def consumer = Consumer.get(userID as long)
        if (consumer) {
            consumer.directorys = null
            consumer.userGroups = null
            consumer.programs = null
            consumer.collectedPrograms = null
            consumer.playedPrograms = null
            consumer.viewedPrograms = null
            consumer.downloadedPrograms = null
            consumer.recommendedPrograms = null
            consumer.programTags = null
            consumer.userErrors = null
            consumer.userNews = null
            consumer.remarks = null
            consumer.consumerSubjects = null
            consumer.subject = null
            consumer.topics = null
            consumer.surveys = null
            consumer.qnaires = null
            consumer.programTopics = null
            consumer.bbsTopics = null
            consumer.studyCircles = null
            consumer.circleQuestion = null
            consumer.forumBoards = null
            consumer.forumMainArticles = null
            consumer.forumReplyArticles = null
            consumer.forumReplySubjectArticles = null
            consumer.memberCommunitys = null
            consumer.sharings = null
            consumer.activitys = null
            consumer.activitySubjects = null
            consumer.userActivitys = null
            consumer.userWorks = null
            consumer.userVotes = null
            consumer.answers = null
            consumer.userRole = null
            consumer.college = null

            result.success = true
            result.consumer = consumer
        } else {
            result.success = false
            result.msg = '参数不全或没有对应的用户'
        }
        return render(result as JSON)
    }

    //注册
    def register() {
        def result = [:];
        if (params.name && params.password) {
            result = userService.register(params);
            if (!result.isOK) {
                result.success = false
                result.msg = '注册失败'
            } else {
                result.success = true
            }
        } else {
            result.success = false
            result.msg = "参数不全";
        }

        return render(result as JSON)
    }

    //修改用户信息
    def userEdit() {
        params.request=request;
        def result = userService.modify(params)

        if (result.noFindConsumer || result.size() == 0) {
            result.success = false
            result.msg = '参数不全或没有对应的用户'
        } else if (!result.success) {
            result.msg = '修改用户失败'
        }

        return render(result as JSON);
    }

    //修改用户头像
    def userPhotoUpdate() {
        def result = [:];

        try{
            CommonsMultipartFile multipartFile = (CommonsMultipartFile)request.getFile("myPhoto");
            result = userService.uploadUserPhoto(multipartFile);
        }catch(Exception e){
        }


        if (result.noFindConsumer) {
            result.msg = "找不到用户信息"
            result.success = false;
        } else {
            if (result.success) {
                result.msg = "头像修改完成！"
            } else {
                result.msg = '头像修改失败'
            }
        }
        return render(result as JSON);
    }

    /**
     * 活动搜索
     */
    def userActivitySearch() {
        def result = [:];
        if (!params.max) params.max = '10'
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = '0'
        if (!params.year) params.year = '0'

        def state = params.state
        def name = params.name
        def nowDate = new Date().format("yyyy-MM-dd")
        List<RMSCategory> rms = [];
        if (params?.categoryId) {
            RMSCategory rmsCategory = RMSCategory.get(params?.categoryId as Long)
            List<RMSCategory> categoryList = RMSCategory.findAllByParentid(params?.categoryId as Long);
            categoryList.each {
                rms.add(it)
            }
            rms.add(rmsCategory);
        }

        if (state == '0') {
            params.sort = 'startTime'
            params.order = 'desc'
        }
        def userActivityList = UserActivity.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
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
                if (rms.size() > 0) {
                    inList('activityCategory', rms)
                }
            }
            if (params.approval) {
                eq('approval', params.approval.toInteger())
            }
            if (params.isOpen) {
                eq('isOpen', params.isOpen)
            }
        }
        def total = 0;
        if (userActivityList == null) {
            userActivityList = [];
            total = 0;
        } else {
            total = userActivityList.totalCount;
        }
        result.success = true;
        result.userActivityList = userActivityList;
        result.total = total;
        return render(result as JSON)
    }

    /**
     * 分面列表
     */
    def programCategoryFacetList() {
        def result = [:];
        def categoryId = params.categoryId;
        def categoryFacetList = [];
        if (categoryId) {
            ProgramCategory category = ProgramCategory.get(categoryId as long);
            if (category) {
                def facetList = CategoryFacted.findAllByCategory(category, [order: 'asc', sort: 'orderIndex']);
                if (facetList && facetList.size() > 0) {
                    def tmpMap = [:];
                    facetList.each { CategoryFacted facted ->
                        tmpMap.id = facted.id;
                        tmpMap.category = facted.category;
                        tmpMap.createDate = facted.createDate;
                        tmpMap.orderIndex = facted.orderIndex;
                        tmpMap.name = facted.name;
                        tmpMap.enName = facted.enName;
                        def values = facted.values.toList();
                        values.sort { FactedValue value1, value2 ->
                            value1.orderIndex <=> value2.orderIndex;
                        }
                        tmpMap.values = values;
                        categoryFacetList.add(tmpMap);
                    }
                    result.success = true;
                    result.categoryFacetList = categoryFacetList;
                } else {
                    result.success = true;
                    categoryFacetList = [];
                    result.categoryFacetList = categoryFacetList;
                }
            } else {
                result.success = false;
                result.msg = "没有对应的分类";
            }
        } else {
            result.success = false;
            result.msg = "参数不全";
        }
        return render(result as JSON)
    }

    /**
     * 资源上传
     * @param params
     * @return
     */
    def uploadProgram() {
        def result = [:];
        Consumer consumer = Consumer.get(session.consumer.id);
        if (consumer) {
            String name = params.name;
            String classId = params.classLibId;
            String description = CTools.htmlToBlank(params.description);
            String categoryId = params.categoryId;
            def canPublic = params.canPublic;
            def factedValIds = [];
            if (params.factedValue) {
                if (params.factedValue instanceof String) {
                    factedValIds.add(params.factedValue);
                } else if (params.factedValue instanceof String[]) {
                    String[] values = params.factedValue;
                    for (String value : values) {
                        factedValIds.add(value);
                    }
                }
            }
            Program program = new Program();
            program.name = name;
            if (classId && classId != "") { //元数据标准可为空
                program.directory = Directory.get(classId as long);
                program.classLib = program?.directory;
            }

            program.consumer = consumer;
            program.description = description;
            if ("true".equals(canPublic)) {
                program.canPublic = true;
            }
            program.state = Program.APPLY_STATE;
            //如果当前上传用户是master，或者是资源管理员且拥有免审权限，上传资源资源状态直接设置为发布
            if (consumer.role == Consumer.SUPER_ROLE || (consumer.role == Consumer.MANAGER_ROLE && consumer.notExamine)) {
                program.state = Program.PUBLIC_STATE;
            }
            //获取分面
            factedValIds?.each {
                FactedValue value = FactedValue.get(it as long);
                if (value) {
                    program.addToFactedValues(value);
                }
            }
            //获得标签
            String programTag = params.programTag;
            if (programTag && (!StringUtils.isEmpty(programTag))) {
                String[] tags = programTag.split(";");
                def countMap = [:];

                tags.each { String tag ->
                    countMap.put(tag, 1);
                }
                countMap.keySet().each { String tag ->
                    if (StringUtils.isNotBlank(tag)) {
                        ProgramTag programTag1 = ProgramTag.findByName(tag);
                        if (programTag1) {
                            programTag1.frequency++;
                            program.addToProgramTags(programTag1);
                        } else {
                            program.addToProgramTags(new ProgramTag(name: tag, frequency: 0));
                        }
                    }
                }
            }

            ProgramCategory programCategory = null;
            if (categoryId != '') {
                String[] categoryIds = categoryId.split(",");
                categoryIds?.each {
                    programCategory = ProgramCategory.get(it as long);
                    program.addToProgramCategories(programCategory);
                }
                if (categoryIds && categoryIds.size() > 0) {
                    program.firstCategoryId = categoryIds[0] as long;
                }
            } else {
                programCategory = ProgramCategory.findByName("默认资源库");
                program.addToProgramCategories(programCategory);
                program.firstCategoryId = programCategory.id;
            }



            String otherOption = params.get("otherOption");
            if (otherOption) {
                program.otherOption = Integer.parseInt(otherOption);
            }

            int fileCount = params.fileCount ? params.int("fileCount") : 0;
            int serialNum = 0;
            for (int i = 0; i < fileCount; i++) {
                if (params.get("fileName_" + i) && params.get("fileSavePath_" + i) && params.get("fileHash_" + i)) {
                    Serial serial = new Serial();
                    serial.name = params.get("fileName_" + i);
                    serial.filePath = params.get("fileSavePath_" + i);
                    serial.fileType = FileUtils.getFileSufix(serial.filePath);
                    serial.fileHash = params.get("fileHash_" + i);
                    serial.description = params.get("fileDesc_" + i);
                    serial.serialNo = (i + 1);
                    serial.dateCreated = new Date();
                    serial.dateModified = new Date();
                    serial.state = 1;
                    if (FileType.isVideo(serial.filePath)) {
                        serial.urlType = Serial.URL_TYPE_VIDEO;
                    } else if (FileType.isDocument(serial.filePath)) {
                        serial.urlType = Serial.URL_TYPE_DOCUMENT;
                    } else if (FileType.isImage(serial.filePath)) {
                        serial.urlType = Serial.URL_TYPE_IMAGE;
                    } else if (FileType.isAudio(serial.filePath)) {
                        serial.urlType = Serial.URL_TYPE_AUDIO;
                    } else {
                        serial.urlType = Serial.URL_TYPE_UNKNOWN;
                    }
                    program.addToSerials(serial);
                    serialNum++;
                }
            }

            program.serialNum = serialNum; //设置文件个数

            if (program.save() && !program.hasErrors()) {
                consumer.uploadNum++;
                consumer.save();
                result.success = true;
                result.msg = "资源上传成功,可以继续上传！"
                new OperationLog(tableName: 'program', tableId: program.id, operator: consumer.name, operatorIP: params.request.getRemoteAddr(),
                        modelName: '添加资源', brief: program.name, operatorId: consumer.id, operation: OperationEnum.ADD_PROGRAM).save()
            } else {
                result.success = false;
                result.msg = "资源上传失败"
            }
        } else {
            result.success = false;
            result.msg = "用户不存在"
        }
        render(result as JSON);
    }

    /**
     * 资源下载
     */
    def downloadProgram() {
        //consumer的downlaodnum增加1
        if (session.consumer) {
            def consumer = Consumer.get(session.consumer.id)
            consumer.downloadNum += 1
            consumer.save()
        }
        Serial serial = Serial.get(params.serialId as Long);

        if (serial) {
            def program = Program.get(serial.program.id)
            if (program) {
                program.downloadNum += 1
                program.save()
                new OperationLog(tableName: 'program', tableId: program.id, operator: session.consumer.name, operatorIP: request.getRemoteAddr(),
                        modelName: '下载资源', brief: program.name, operatorId: session.consumer.id, operation: OperationEnum.DOWNLOAD_PROGRAM).save(flush: true)
            }
        }

        String videoSevr = servletContext.getAttribute("videoSevr");
        String videoPort = servletContext.getAttribute("videoPort");    //视频服务器端口
        String url = "http://" + videoSevr + ":" + videoPort + "/bmc/upload/downloadFile?fileHash=" + serial.fileHash;

        def fileName = serial.name;
        def userAgent = request.getHeader("User-Agent");
        def newFileName = URLEncoder.encode(fileName, "UTF-8");
        def rtn = "filename=\"" + newFileName + "\"";
        if (userAgent != null) {
            userAgent = userAgent.toLowerCase();
            // IE浏览器，只能采用URLEncoder编码
            if (userAgent.indexOf("msie") != -1) {
                rtn = "filename=\"" + newFileName + "\"";
            } // Opera浏览器只能采用filename*
            else if (userAgent.indexOf("opera") != -1) {
                rtn = "filename*=UTF-8''" + newFileName;
            }
            // Safari浏览器，只能采用ISO编码的中文输出
            else if (userAgent.indexOf("safari") != -1) {
                rtn = "filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO8859-1") + "\"";
            }
            // Chrome浏览器，只能采用MimeUtility编码或ISO编码的中文输出
            else if (userAgent.indexOf("applewebkit") != -1) {
                newFileName = MimeUtility.encodeText(fileName, "UTF8", "B");
                rtn = "filename=\"" + newFileName + "\"";
            }
            // FireFox浏览器，可以使用MimeUtility或filename*或ISO编码的中文输出
            else if (userAgent.indexOf("mozilla") != -1) {
                rtn = "filename*=UTF-8''" + newFileName;
            }

        }

        HttpClient client = HttpClientBuilder.create().build();
        HttpGet getMethod = new HttpGet(url);
        getMethod.setHeader("Referer", "http://192.168.1.0")
        HttpResponse httpResponse = client.execute(getMethod);
        HttpEntity httpEntity = httpResponse.getEntity()
        InputStream inputStream = httpResponse.getEntity().getContent()
        response.setContentType("application/octet-stream")
        response.setHeader("Content-disposition", "attachment;" + rtn);

        //以指定的文件名作为附件返回到前台，供下载，
        //前台发起的请求形式为：window.location.href = "actionName" 或 <a href ="actionName"></a> 点击
        response.outputStream << inputStream
    }

    //新闻列表
    def newsList() {
        def result = [:];
        try {
            int offset = params.offset ? (params.offset as int) : 0;
            int max = params.max ? (params.max as int) : 10;
            String sort = params.sort ? params.sort : "submitTime";
            String order = params.order ? params.order : "desc";
            List<News> newsList = News.list([max: max, offset: offset, sort: sort, order: order]);
            result.success = true;
            result.newsList = newsList;
        } catch (Exception e) {
            result.success = false;
            result.msg = e.message;
        }
        return render(result as JSON);

    }

    /**
     * 系统公告
     * @return
     */
    def sysNotice() {
        def result = [:];
        result.notice = nts.utils.CTools.htmlToBlank(servletContext?.sysNotice);
        result.success = true;
        return render(result as JSON);
    }

    /**
     * 查询分类下的资源
     * @return
     */
    def programQuery() {
        def result = [:];
        def categoryId = null;
        try {
            categoryId = params.categoryId as long;
        } catch (Exception e) {
            // do nothing
        }
        if (categoryId) {
            ProgramCategory secondCategory = ProgramCategory.get(categoryId);
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

    def searchEnable() {
        def result = [:];
        result.searchEnable = servletContext?.searchEnable ? servletContext?.searchEnable : false;
        result.success = true;
        return render(result as JSON);
    }

    /**
     * 取logo图片
     */
    def webLogeUrl() {
        def result = [:];
        result.webLogeUrl = "${webLogeUrl(filePath: 'upload/Logo')}";
        result.success = true;
        return render(result as JSON);
    }

    /****************20150105start*********************/
    /**
     * 查询活动列表
     * @return
     */
    def queryActivityList() {
        def result = [:];
        List<RMSCategory> rms = [];
        if (params?.categoryId) {
            RMSCategory rmsCategory = RMSCategory.get(params?.categoryId as Long);
            List<RMSCategory> categoryList = RMSCategory.findAllByParentid(params?.categoryId as Long);
            categoryList.each {
                rms.add(it)
            }
            rms.add(rmsCategory);
        }

        def userActivityList = UserActivity.createCriteria().list() {
            if (CTools.nullToZero(params?.categoryId).longValue() != 0) {
                if (rms.size() > 0) {
                    inList('activityCategory', rms)
                }
            }
            if (params.approval) {
                eq('approval', 3)
            }
            if (params.isOpen) {
                eq('isOpen', true)
            }
            order('id', 'desc')
        }

        def activityList = [];
        userActivityList?.each { UserActivity activity ->
            def tmp = [:];
            tmp.id = activity.id;
            tmp.name = activity.name;
            tmp.consumerName = activity.consumer.name;
            tmp.startTime = activity.startTime;
            tmp.endTime = activity.endTime;
            tmp.description = activity.description;
            tmp.workNum = activity.workNum;
            tmp.categoryId = activity.activityCategory.id;
            tmp.categoryName = activity.activityCategory.name;
            tmp.imgsrc = "${resource(dir: 'upload/userActivityImg', file: activity.photo)}";
            activityList.add(tmp);
        }
        result.success = true;
        result.userActivityList = activityList;
        return render(result as JSON)
    }

    /**
     * 查询活动分类
     * @return
     */
    def queryRMSCategory() {
        def result = [:];
        //查询一级分类
        def rmsCategoryList = RMSCategory.createCriteria().list() {
            'in'("type", [3])
            eq("parentid", 0)
            order('id', 'asc')
        }
        def categoryList = [];
        rmsCategoryList?.each { RMSCategory category ->
            def tmp = [:];
            tmp.name = category.name;
            tmp.categoryId = category.id;
            categoryList.add(tmp);
        }
        result.success = true;
        result.rmsCategoryList = categoryList;
        return render(result as JSON)
    }

    /**
     * 作品列表查询
     * @return
     */
    def queryUserWork() {
        def result = [:];
        def newUserWorkList = [];
        def bestUserWorkList = [];
        List<UserWork> userWorks = null;
        def userActivityId = params.userActivityId;
        if (userActivityId) {
            //最新作品
            userWorks = UserWork.createCriteria().list() {
                eq('approval', 3)
                userActivity {
                    eq('id', userActivityId as long)
                }
                order('dateCreated', 'desc')
            }
            userWorks?.each { UserWork newWork ->
                def tmp = [:];
                tmp.id = newWork.id;
                tmp.name = newWork.name;
                tmp.fileHash = newWork.fileHash;
                tmp.fileType = newWork.fileType;
                tmp.filePath = newWork.filePath;
                tmp.imgSrc = "${posterLinkNew(fileHash: newWork.fileHash, size: '220x160')}";
                newUserWorkList.add(tmp);
            }
            // 最优作品
            userWorks = null;
            userWorks = UserWork.createCriteria().list() {
                eq('approval', 3)
                userActivity {
                    eq('id', userActivityId as long)
                }
                order('voteNum', 'desc')
            }
            userWorks?.each { UserWork bestWork ->
                def tmp = [:];
                tmp.id = bestWork.id;
                tmp.name = bestWork.name;
                tmp.fileHash = bestWork.fileHash;
                tmp.fileType = bestWork.fileType;
                tmp.filePath = bestWork.filePath;
                tmp.imgSrc = "${posterLinkNew(fileHash: bestWork.fileHash, size: '220x160')}";
                bestUserWorkList.add(tmp);
            }
        }
        result.success = true;
        result.newUserWorkList = newUserWorkList;
        result.bestUserWorkList = bestUserWorkList;
        return render(result as JSON);
    }

    /**
     * 作品展示
     * @return
     */
    def userWorkShow() {
        def result = [:];
        def userWorkId = params.id;
        def consumerId = session.consumer.id;
        def userWorkInstance = UserWork.get(params.id)
        if (!userWorkInstance) {
            result.success = false;
        } else {
            userWorkInstance.visitCount += 1
            userWorkInstance.save(flush: true)

            result.id = userWorkInstance.id;
            result.name = userWorkInstance.name;
            result.author = userWorkInstance.consumer.name;
            result.description = userWorkInstance.description;
            result.uploadTime = userWorkInstance.dateCreated;
            result.voteNum = userWorkInstance.voteNum;
            result.visitCount = userWorkInstance.visitCount;
            if (userWorkInstance.urlType == Serial.URL_TYPE_VIDEO) {
                result.playUrl = "${playLinksNew(fileHash: userWorkInstance.fileHash)}";
            } else if (userWorkInstance.urlType == Serial.URL_TYPE_IMAGE) {
                result.playUrl = "${posterLinkNew(fileHash: userWorkInstance.fileHash, size: "500x500")}";
            }
            result.fileHash = userWorkInstance.fileHash;
            result.filePath = userWorkInstance.filePath;
            if (FileType.isImage(userWorkInstance.filePath)) {
                result.fileType = "image";
            } else if (FileType.isVideo(userWorkInstance.filePath)) {
                result.fileType = "video";
            }

            //判断是否已投票
            if (!userService.judeAnonymity()) {
                if (session?.consumer?.id == userWorkInstance.consumer.id) {
                    result.voteState = 1;
                } else {
                    def userVoteList = UserVote.createCriteria().list() {
                        userWork {
                            eq('id', userWorkId as long)
                        }
                        consumer {
                            eq('id', consumerId as long)
                        }
                    }
                    if (userVoteList != null && userVoteList != []) {
                        result.voteState = 2
                    } else {
                        result.voteState = 0
                    }

                }
            } else {
                result.voteState = -1;
            }

        }
        return render(result as JSON);
    }

    /**
     * 用户投票
     */
    def userWorkVote = {
        def result = [:];
        def userWorkId = params.id
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
            result.voteFlg = 2;
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
                result.voteNum = userWorkInstance.voteNum;
                result.voteFlg = 1;
                result.success = true;
            } else {
                result.voteFlg = 0;
                result.success = false;
            }
        }
        return render(result as JSON);
    }

    /**
     * 查询相关推荐
     * @return
     */
    private List queryRelationProgram(Program program) {
        def relations = []; //相关资源
        def idList = [];
        //相关资源取得
        if (servletContext.searchEnable) {
            int max = 5;
            int offset = 0;
            def rs = searchService.searchRelationProgram(offset, max, program?.name, "id", "desc");
            if (rs && rs.size() > 0) {
                def rsList = rs.modelList;
                rsList?.each {
                    if (!idList.contains(it.id)) {
                        idList.add(it.id);
                    }
                }
            }
        }

        List<Program> relationProgram = Program.createCriteria().list(max: 5, sort: 'id', order: 'desc') {
            notEqual('id', program.id)
            if (idList && idList.size() > 0) {
                'in'('id', idList.toArray())
            } else {
                or {
                    like('name', "%" + program.name + "%")
                    like('description', "%" + program.name + "%")
                }
                eq('canPublic', true);
                eq("state", Program.PUBLIC_STATE)
                eq('transcodeState', Program.STATE_SUCCESS)
            }

        };

        relationProgram?.each {
            def tmp = [:];
            tmp.id = it?.id;
            tmp.name = it?.name;
            tmp.description = it?.description;
            tmp.frequency = it?.frequency;
            tmp.remarkNum = it?.remarkNum;
            tmp.viewNum = it?.viewNum;
            tmp.collectNum = it?.collectNum;
            tmp.recommendNum = it?.recommendNum;
            tmp.downloadNum = it?.downloadNum;
            tmp.programScore = it?.programScore;
            tmp.posterUrl = "${posterLinkNew(program: it, size: '95x127', position: -1)}";
            tmp.otherOption = it?.otherOption;
            relations.add(tmp);
        }
        return relations;
    }

    /**
     * 查询评论
     * @param program
     * @return
     */
    private List queryRemarkList(Program program) {
        def remarks = [];
        List<Remark> remarkList = Remark.createCriteria().list(sort: 'dateCreated', order: 'desc') {
            eq('program', program)
            eq('isPass', true)
        }

        remarkList?.each { Remark remark ->
            def tmp = [:];
            tmp.id = remark.id;
            tmp.topic = remark.topic;
            tmp.content = remark.content;
            tmp.rConsumerId = remark.consumer.id;
            tmp.rConsumerName = remark.consumer.name;
            tmp.rConsumerPoster = "${generalUserPhotoUrl(consumer: remark?.consumer)}";
            tmp.dateCreated = remark.dateCreated.format("yyyy-MM-dd");
            //回复list查询
            def replyList = remark?.remarkReplys?.toList();
            def replys = [];
            replyList?.each { RemarkReply reply ->
                def replyTmp = [:];
                replyTmp.id = reply.id;
                replyTmp.content = reply.content;
                replyTmp.replyConsumerId = reply.consumer.id;
                replyTmp.replyConsumerName = reply.consumer.name;
                replyTmp.replyDate = reply.dateCreated;
                replys.add(replyTmp);
            }
            tmp.replyNum = replys.size();
            tmp.replyList = replys;
            remarks.add(tmp);
        }
        return remarks;
    }

    def loadRemark() {
        def result = [:];
        if(params.programId) {
            def programId = params.programId as long;
            def remarks = queryRemarkList(Program.get(programId));
            result.remarkList = remarks;
        } else {
            result.msg = "资源不存在！";
        }
        return render(result as JSON);
    }

    //保存评论
    def saveRemark() {
        def result = [:];
        int total = 0;
        if ((!session.consumer) || (session.consumer.name == "anonymity")) {
            result.success = false;
            result.msg = '未登录不能评论';
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
                    if (scoreList.size() == 0) {
                        remark.rank = rank as int;
                        remark.save(flash: true);

                        //资源评分保存
                        programService.saveProgramScore(serial.program.id);
                        result.isFlag = true;
                    } else {
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
            result.success = true;
            result.msg = "评论成功,请等待审核";
        }
        return render(result as JSON);
    }

    /**
     * 视频点播
     * @return
     */
    def playVideo() {
        Serial serial = null;
        Program program = null;
        def result = [:];
        try {
            if (params.id) {
                program = Program.get(params.id as Long);
                if (program?.serials?.size() == 0) {
                    result.message = program?.name + "下没有子资源";
                    return render(result as JSON);
                } else if (program.serials.size() > 0) {
                    serial = programService.serialFirst(program);
                }
            } else if (params.serialId) {
                serial = Serial.get(params.serialId as Long);
                if (serial) {
                    program = serial.program;
                }
            }

            if (!program) {
                def errorMsg = '点播的资源不存在！'
                result.message = errorMsg;
                return render(result as JSON);
                //return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
            }

            def playResult;
            if (params.id) {
                playResult = programService.canPlay(session.consumer, Program.get(params.id as Long))
            } else if (params.serialId) {
                if (program) {
                    playResult = programService.canPlay(session.consumer, program)
                }
            }

            if (!playResult) {
                def errorMsg = ''
                if ((program.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                    errorMsg = '对不起，您没有权限学习该课程！'
                } else {
                    errorMsg = '对不起，您没有权限点播该资源！'
                }
                result.message = errorMsg;
                return render(result as JSON);
                //return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
            }

            List<Serial> serialList2 = Serial.createCriteria().list(order: 'asc', sort: 'serialNo') {
                eq('program', program)
            }
            def lastTime = -1;
            PlayedProgram playedProgram = null;
            if (session.consumer && session.consumer.name != 'anonymity') {
                Consumer consumer = Consumer.findById(session.consumer.id);
                consumer.playNum++;
                consumer.save();
                playedProgram = PlayedProgram.findByProgramAndSerialAndConsumer(program, serial, consumer);
                if (playedProgram) {
                    lastTime = playedProgram.timeLength;
                }
            }

            def relations = queryRelationProgram(program); //相关资源获取

            def remarks = queryRemarkList(program); //评论获取

            //确认用户是否有下载权限
            boolean isCanDownload = programService.canDownload(session.consumer, program);

            // 分类
            def programCategory = '';
            program?.programCategories?.each {
                programCategory = programCategory + it.name + ",";
            }
            if (programCategory.length() > 0) {
                programCategory = programCategory.substring(0, programCategory.length() - 1);
            }

            //去掉关联数据，只要基本数据
            program.programTags = null;
            program.remarks = null;
            program.collectedPrograms = null;
            program.playedPrograms = null;
            program.downloadedPrograms = null;
            program.viewedPrograms = null;
            program.recommendedPrograms = null;
            program.relationPrograms = null;
            program.metaContents = null;
            program.playGroups = null;
            program.downloadGroups = null;
            program.programTopics = null;
            program.distributePrograms = null;
            program.studyCircles = null;
            program.factedValues = null;
            program.programCategories = null;
            program.classLib = null;
            program.directory = null;
            program.consumer = null;
            program.serials = null;

            // 播放地址获取
            def playList = "${playLinksNew(serials: serialList2)}";
            def serials = [];
            serialList2?.each {
                def tmp = [:];
                tmp.id = it.id;
                tmp.name = it.name;
                tmp.fileHash = it.fileHash;
                tmp.filePath = it.filePath;
                tmp.fileSize = it.fileSize;
                tmp.fileType = it.fileType;
                tmp.timeLength = TimeLengthUtils.formatTime(TimeLengthUtils.NumberToString(serial.timeLength));
                tmp.serialNo = it.serialNo;
                tmp.description = it.description;
                serials.add(tmp);
            }

            result.isCanDownload = isCanDownload;
            result.serialList = serials;
            result.program = program;
            result.relationProgram = relations;
            result.remarkList = remarks;
            result.playList = playList;
            result.programCategory = programCategory;
            return render(result as JSON);
        } catch (Exception e) {
            log.error(e.message, e);
            //return redirect(uri: '/index/error')
        }
    }

    /**
     * 音频播放
     */
    def playAudio() {
        def result = [:];
        Program program = null;
        def specialProgramList = [];//专辑资源
        def evaluateList = [];
        def hotAudio4 = [];//前四热门资源
        Serial serial = null;
        boolean isCanDownload = false;
        try {
            def prom = Program.get(params.id as Long)
            def playResult = programService.canPlay(session.consumer, Program.get(params.id as Long))
            if (!playResult) {
                def errorMsg = ''
                if ((prom.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                    errorMsg = '对不起，您没有权限学习该课程！'
                } else {
                    errorMsg = '对不起，您没有权限点播该资源！'
                }
                result.message = errorMsg;
                //return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
            }
            isCanDownload = programService.canDownload(session.consumer, prom);
            if (params.id) {
                program = Program.get(params.id);
                if (program) {
                    //Program.get(params.programId).serials
                    specialProgramList = programService.programIn(params.id).toList();
                    specialProgramList.sort { serial1, serial2 ->
                        serial1?.serialNo <=> serial2?.serialNo
                    }
                    serial = specialProgramList[0];
                }
            }

            // 分类
            def programCategory = '';
            program?.programCategories?.each {
                programCategory = programCategory + it.name + ",";
            }
            if (programCategory.length() > 0) {
                programCategory = programCategory.substring(0, programCategory.length() - 1);
            }

            // 播放地址获取
            def playList = "${playLinksNew(serials: specialProgramList)}";
            def serials = [];
            specialProgramList?.each {
                def tmp = [:];
                tmp.id = it.id;
                tmp.name = it.name;
                tmp.fileHash = it.fileHash;
                tmp.filePath = it.filePath;
                tmp.fileSize = it.fileSize;
                tmp.fileType = it.fileType;
                tmp.timeLength = TimeLengthUtils.formatTime(TimeLengthUtils.NumberToString(serial.timeLength));
                tmp.serialNo = it.serialNo;
                tmp.description = it.description;
                serials.add(tmp);
            }
            def relations = queryRelationProgram(program); //相关资源获取
            def remarks = queryRemarkList(program); //评论获取

            //去掉关联数据，只要基本数据
            program.programTags = null;
            program.remarks = null;
            program.collectedPrograms = null;
            program.playedPrograms = null;
            program.downloadedPrograms = null;
            program.viewedPrograms = null;
            program.recommendedPrograms = null;
            program.relationPrograms = null;
            program.metaContents = null;
            program.playGroups = null;
            program.downloadGroups = null;
            program.programTopics = null;
            program.distributePrograms = null;
            program.studyCircles = null;
            program.factedValues = null;
            program.programCategories = null;
            program.classLib = null;
            program.directory = null;
            program.consumer = null;
            program.serials = null;

            result.program = program;
            result.serial = serial;
            result.isCanDownload = isCanDownload;
            result.serialList = serials;
            result.playList = playList;
            result.programCategory = programCategory;
            result.relationProgram = relations;
            result.remarkList = remarks;
        }
        catch (Exception e) {

        }

        return render(result as JSON);
    }

    /**
     * 图片点播
     * @return
     */
    def playPhoto() {
        def result = [:];
        def program = Program.get(params.id);

        def playResult = programService.canPlay(session.consumer, Program.get(params.id as Long))
        if (!playResult) {
            def errorMsg = ''
            if ((program.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                errorMsg = '对不起，您没有权限学习该课程！'
            } else {
                errorMsg = '对不起，您没有权限点播该资源！'
            }
            result.message = errorMsg;
            //return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
        }

        Serial serial = programService.serialFirst(program);
        if (!serial) {
            result.message = '文件列表为空！请联系管理员！';
            //return render(text: '文件列表为空！请联系管理员！');
        }
        if (session.consumer && session.consumer.name != 'anonymity') {
            Consumer consumer = Consumer.findById(session.consumer.id);
            PlayedProgram playedProgram = PlayedProgram.findByProgramAndSerialAndConsumer(program, serial, consumer);
            if (!playedProgram) {
                playedProgram = new PlayedProgram();
                playedProgram.consumer = consumer;
                playedProgram.serial = serial;
                playedProgram.program = program;
                playedProgram.timeLength = 0;
                consumer.playedPrograms.add(playedProgram);
                consumer.playNum++;
                consumer.save(flush: true);
            }
        }
        program.save(flush: true);

        def serials = [];
        List<Serial> serialList = serial.program.serials.toList();
        serialList.sort {
            serial1, serial2 ->
                serial1.serialNo <=> serial2.serialNo
        }
        serialList?.each {
            if (it.urlType == Serial.URL_TYPE_IMAGE) {
                it.program = null;
                // 播放地址
                def serialUrlSmall = "${posterLinkNew(fileHash: it.fileHash, size: '120x80')}";
                def serialUrlLarge = "${posterLinkNew(fileHash: it.fileHash, size: '300x300')}";
                def serialTemp = [:];
                serialTemp.smallUrl = serialUrlSmall;
                serialTemp.largeUrl = serialUrlLarge;
                serialTemp.serial = it;
                serials.add(serialTemp);
            }
        }
        def remarks = queryRemarkList(program); //评论获取

        // 分类
        def programCategory = '';
        program?.programCategories?.each {
            programCategory = programCategory + it.name + ",";
        }
        if (programCategory.length() > 0) {
            programCategory = programCategory.substring(0, programCategory.length() - 1);
        }

        def programInfo = [:];
        programInfo.id = program.id;
        programInfo.name = program.name;
        programInfo.createConsumer = program.consumer.name;
        programInfo.dateCreated = program.dateCreated;
        programInfo.programScore = program.programScore;
        programInfo.viewNum = program.viewNum;
        programInfo.description = program.description;

        result.program = programInfo;
        result.serial = serial;
        result.serialList = serials;
        result.remarkList = remarks;
        result.programCategory = programCategory;
        return render(result as JSON);
    }

    /**
     * 文档点播
     * @return
     */
    def playDocument() {
        def result = [:];
        PlayedProgram playedProgram = null;
        Program program = null;
        def playResult = null;
        def hotPrograms = null;
        Serial serial = null;

        if (params.id) {
            def prom = Program.get(params.id as Long);
            playResult = programService.canPlay(session.consumer, prom);
            if (!playResult) {
                def errorMsg = ''
                if ((prom.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                    errorMsg = '对不起，您没有权限学习该课程！'
                } else {
                    errorMsg = '对不起，您没有权限点播该资源！'
                }
                result.msg = errorMsg;
                //return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
                return render(result as JSON);
            }

            serial = programService.serialFirst(prom);

        } else if (params.serialId) {
            serial = Serial.findById(params.serialId);
            program = Program.get(serial.program.id);
            result = programService.canPlay(session.consumer, program);
            if (!result) {
                def errorMsg = ''
                if ((program.otherOption & Program.ONLY_LESSION_OPTION) == Program.ONLY_LESSION_OPTION) {
                    errorMsg = '对不起，您没有权限学习该课程！'
                } else {
                    errorMsg = '对不起，您没有权限点播该资源！'
                }
                result.msg = errorMsg;
                //return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
                return render(result as JSON);
            }
        }

        if (!serial) {
            result.msg = "文件列表为空！请联系管理员！";
            return render(result as JSON);
            //return render(text: '文件列表为空！请联系管理员！');
        }
        program = Program.get(serial.program.id);
        if (session.consumer && session.consumer.name != 'anonymity') {
            Consumer consumer = Consumer.findById(session.consumer.id);
            consumer.playNum++;
            consumer.save();
            playedProgram = PlayedProgram.findByProgramAndSerialAndConsumer(program, serial, consumer);
        }

        def remarks = queryRemarkList(program); //评论获取

        //热门文档
        hotPrograms = Program.createCriteria().list {
            if (userService.judeAnonymity()) {
                eq('canPublic', true);
            }
            serials {
                eq("urlType", Serial.URL_TYPE_DOCUMENT)
            }
            notEqual("otherOption", Program.ONLY_LESSION_OPTION)
            eq("state", Program.PUBLIC_STATE)
            eq('transcodeState', Program.STATE_SUCCESS)
            order("viewNum", "desc")
            setMaxResults(5)
        }
        def hots = [];
        hotPrograms?.each {
            def tmp = [:];
            tmp.id = it?.id;
            tmp.name = it?.name;
            tmp.description = it?.description;
            tmp.frequency = it?.frequency;
            tmp.remarkNum = it?.remarkNum;
            tmp.viewNum = it?.viewNum;
            tmp.collectNum = it?.collectNum;
            tmp.recommendNum = it?.recommendNum;
            tmp.downloadNum = it?.downloadNum;
            tmp.programScore = it?.programScore;
            tmp.posterUrl = "${posterLinkNew(program: it, size: '95x127', position: -1)}";
            tmp.otherOption = it?.otherOption;
            hots.add(tmp);
        }


        List<Serial> serialList = program.serials.toList();
        serialList.sort {
            serial1, serial2 ->
                serial1.serialNo <=> serial2.serialNo
        }
        def serials = [];
        serialList?.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.name;
            tmp.fileHash = it.fileHash;
            tmp.filePath = it.filePath;
            tmp.fileSize = it.fileSize;
            tmp.fileType = it.fileType;
            tmp.timeLength = serial.timeLength;
            tmp.playUrl = "${mobilePlayLink(fileHash: serial.fileHash, isPdf: true)}";
            tmp.serialNo = it.serialNo;
            tmp.description = it.description;
            serials.add(tmp);
        }

        //播放地址获取
        def swfFileUrl = "${mobilePlayLink(fileHash: serial.fileHash, isPdf: true)}";
        // def swfFileUrl = serial.filePath;

        // 分类
        def programCategory = '';
        program?.programCategories?.each {
            programCategory = programCategory + it.name + ",";
        }
        if (programCategory.length() > 0) {
            programCategory = programCategory.substring(0, programCategory.length() - 1);
        }

        def programInfo = [:];
        programInfo.id = program.id;
        programInfo.name = program.name;
        programInfo.createConsumer = program.consumer.name;
        programInfo.dateCreated = program.dateCreated;
        programInfo.programScore = program.programScore;
        programInfo.viewNum = program.viewNum;
        programInfo.description = program.description;

        result.program = programInfo;
        result.serial = serial;
        result.serialList = serials;
        result.playUrl = swfFileUrl;
        result.programCategory = programCategory;
        result.remarkList = remarks;
        result.hotList = hots;
        return render(result as JSON);

        //return render(view: 'playDocument', model: [serialList: serialList, playedProgram: playedProgram, serial: serial, program: serial.program, remarks: remarks, hotPrograms: hotPrograms]);
    }

    /**
     * 资源收藏
     * @return
     */
    def collectProgram() {
        def program = Program.get(params.id);
        def result = [:];
        result.success = false;
        result.collectFlg = 0;
        if ((!session.consumer) || (session.consumer.name == "anonymity")) {
            result.msg = '未登陆，请先登陆！';
        } else {
            if (program) {
                //收藏本人还没有收藏的
                def collectedProgram = CollectedProgram.findByConsumerAndProgram(session.consumer, program);
                if (!collectedProgram) {
                    if (!params.tag) {
                        params.tag = "标签";
                    }
                    collectedProgram = new CollectedProgram(consumer: session.consumer, program: program, tag: params.tag);
                    if (!collectedProgram.hasErrors() && collectedProgram.save(flush: true)) {
                        program.collectNum++;
                        Consumer.get(session.consumer.id).collectNum++;
                        result.msg = '收藏成功！';
                        result.collectFlg = 1;
                        result.success = true;
                    } else {
                        result.msg = '收藏失败！';
                    }
                } else {
                    result.msg = '该资源已收藏，不能重复收藏！';
                }
            }
        }
        return render(result as JSON);
    }

    /**
     * 用户收藏
     */
    def userCollectedPrograms() {
        def result = [:];
        //获得用户组
        def paramConsumerId = params.consumerId;
        def sessionConsumerId = session.consumer.id;

        if (paramConsumerId || sessionConsumerId) {
            Consumer consumer
            if (paramConsumerId) {
                consumer = Consumer.get(paramConsumerId as long);
            } else {
                consumer = Consumer.get(sessionConsumerId as long);
            }
            if (consumer) {
                if (!params.max) params.max = 10
                if (!params.offset) params.offset = 0
                if (!params.sort) params.sort = 'id'
                if (!params.order) params.order = 'desc'

                def tag = params.tag
                def collectProgramList
                def total = 0
                //要查询说总数用于分页
                def totalList = null;
                collectProgramList = CollectedProgram.executeQuery("from CollectedProgram where consumer.id = :consumerId and program.state=:state and program.otherOption !=:otherOption order by ${params.sort} ${params.order}", [consumerId: consumer.id, state: Program.PUBLIC_STATE, otherOption: Program.ONLY_LESSION_OPTION], [max: params.max, offset: params.offset]);
                totalList = CollectedProgram.executeQuery("select count(id) from CollectedProgram where consumer.id = :consumerId and program.state=:state and program.otherOption !=:otherOption", [consumerId: consumer.id, state: Program.PUBLIC_STATE, otherOption: Program.ONLY_LESSION_OPTION]);
                if (totalList && totalList.size() > 0) {
                    total = totalList[0]
                }

                def collectedPrograms = [];
                collectProgramList?.each {
                    if (it?.program?.otherOption == Program.ONLY_AUDIO_OPTION || it?.program?.otherOption == Program.ONLY_VIDEO_OPTION
                            || it?.program?.otherOption == Program.ONLY_TXT_OPTION || it?.program?.otherOption == Program.ONLY_IMG_OPTION) {
                        def tmp = [:];
                        tmp.id = it?.program?.id;
                        tmp.name = it?.program?.name;
                        tmp.description = it?.program?.description;
                        tmp.frequency = it?.program?.frequency;
                        tmp.remarkNum = it?.program?.remarkNum;
                        tmp.viewNum = it?.program?.viewNum;
                        tmp.collectNum = it?.program?.collectNum;
                        tmp.recommendNum = it?.program?.recommendNum;
                        tmp.downloadNum = it?.program?.downloadNum;
                        tmp.programScore = it?.program?.programScore;
                        tmp.posterUrl = "${posterLinkNew(program: it.program, size: '95x127', position: -1)}";
                        tmp.otherOption = it?.program?.otherOption;
                        collectedPrograms.add(tmp);
                    }

                }


                result.success = true;
                result.collectProgramList = collectedPrograms;
                result.total = total;
                result.tag = tag;
            } else {
                result.success = false
                result.msg = '没有对应的用户'
            }
        } else {
            result.success = false
            result.msg = '参数不全'
        }
        return render(result as JSON)
    }

    /**
     * 用户播放记录
     * @return
     */
    def userPlayedPrograms() {
        def result = [:]
        Consumer consumer = Consumer.get(params.consumerId);
        List playedProgramList = [];
        if (consumer) {
//            playedProgramList = PlayedProgram.findAllByConsumer(consumer)

            //找到该用户的所有PlayedProgram，对program分组，找到所有program
            List programIdList = PlayedProgram.executeQuery("select program.id from PlayedProgram where consumer.id=:consumerId group by program.id order by playDate desc", [consumerId: consumer.id]);
            for (def programId : programIdList) {
                try {
                    if (programId) {
                        //在PlayedProgram，找到所有某个program的所有播放记录，按照播放时间，降序排序
                        List playedProgramList2 = PlayedProgram.executeQuery("from PlayedProgram where program.id=:programId order by playDate desc", [programId: programId]);
                        PlayedProgram playedProgram = null;
                        if (playedProgramList2 && playedProgramList2.size() > 0) {
                            //因为是播放时间降序排序，所以第一个就是最后一次播放
                            playedProgram = playedProgramList2[0];
                        }
                        //播放记录材质，且播放的program是公开的，  避免后期，后台更改资源状态后，前台还会显示
                        if (playedProgram && playedProgram.program && playedProgram.serial && playedProgram.program.state == Program.PUBLIC_STATE) {
                            playedProgramList.add(playedProgram);
                        }
                    }
                } catch (Exception e) {
                    continue;
                }
            }
            result.success = true
            result.playedProgramList = playedProgramList
        } else {
            result.success = false
            result.msg = '参数不全或没有对应的用户'
        }

        return render(result as JSON)
    }

    /**
     * 根据分类id查询子分类
     * @return
     */
    def queryCategoryListById() {
        def result = [:];
        def categoryList = [];
        if (params.id) {
            def categoryId = params.id;
            ProgramCategory category = ProgramCategory.get(categoryId as long);
            if (category) {
                List<ProgramCategory> categoryList1 = programCategoryService.querySubCategory(category);
                categoryList1?.each {
                    def tmp = [:];
                    tmp.categoryId = it.id;
                    tmp.categoryName = it.name;
                    categoryList.add(tmp);
                }
            }

            result.categoryId = category.id;
            result.categoryName = category.name;
            result.categoryList = categoryList;
        } else {
            result.msg = "参数不全!";
        }
        return render(result as JSON);
    }

    /**
     * 根据资源分类id查询资源和
     */
    def queryProgramByCategoryId() {
        def result = [:];
        def categoryList = [];
        def programList = [];
        if (params.categoryId) {
            def categoryId = params.categoryId;
            ProgramCategory category = ProgramCategory.get(categoryId as long);
            if (category?.parentCategory) {
                List<ProgramCategory> categoryList1 = programCategoryService.querySubCategory(category?.parentCategory);
                categoryList1?.each {
                    def tmp = [:];
                    tmp.categoryId = it.id;
                    tmp.categoryName = it.name;
                    categoryList.add(tmp);
                }
            }

            //资源
            def programs = programService.search([programCategoryId: categoryId, order: "desc", orderBy: "id"], false);
            programs?.each {
                def program = [:];
                program.id = it.id;
                program.name = it.name;
                //program.posterUrl = "${posterLinkNew(program: it, size: '95x127', position: -1)}";
                program.otherOption = it.otherOption;
                program.frequency = it.frequency;
                program.downloadNum = it.downloadNum;
                program.programScore = it.programScore;
                program.description = it.description;
                programList.add(program);
            }

            result.programList = programList;
            result.parentCategoryId = category?.parentCategory.id;
            result.parentCategoryName = category?.parentCategory.name;
            result.categoryId = category.id;
            result.categoryName = category.name;
            result.categoryList = categoryList;
        } else {
            result.msg = "参数不全!";
        }
        return render(result as JSON);
    }
}