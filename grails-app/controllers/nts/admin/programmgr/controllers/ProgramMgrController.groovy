package nts.admin.programmgr.controllers

import grails.converters.JSON
import nts.meta.domain.MetaContent
import nts.meta.domain.MetaDefine
import nts.meta.domain.MetaEnum
import nts.program.category.domain.CategoryFacted
import nts.program.category.domain.FactedValue
import nts.program.domain.CollectedProgram
import nts.program.domain.DistributePolicy
import nts.program.domain.DownloadedProgram
import nts.program.domain.PlayedProgram
import nts.program.domain.Program
import nts.program.category.domain.ProgramCategory
import nts.program.domain.RecommendedProgram
import nts.program.domain.Remark
import nts.program.domain.Serial
import nts.program.domain.Subtitle
import nts.program.domain.TimePlan
import nts.program.domain.ViewedProgram
import nts.system.domain.Directory
import nts.system.domain.ServerNode
import nts.system.domain.SysConfig
import nts.user.domain.Consumer
import nts.user.domain.UserGroup
import nts.user.services.ActionNameAnnotation
import nts.user.services.ControllerNameAnnotation
import nts.user.services.PatternNameAnnotation
import nts.utils.CTools
import org.codehaus.groovy.grails.web.util.WebUtils
import org.quartz.CronExpression
import org.quartz.JobDetail
import org.quartz.JobKey
import org.quartz.Scheduler
import org.quartz.impl.matchers.GroupMatcher

import javax.servlet.http.Cookie
import java.text.DecimalFormat

/**
 * 后台资源管理
 */
@ControllerNameAnnotation(name = "资源管理")
class ProgramMgrController {
    def programService
    def distributeService
    def useApplyService
    def systemConfigService
    def metaDefineService
    def programMgrService
    def timePlanJobService
    def programCategoryService;
    def programExportService;
    def searchService;
    def utilService;
    def coreMgrService;

    @PatternNameAnnotation(name = "资源列表")
    @ActionNameAnnotation(name = "资源列表")
    def index() {
        return redirect(action: 'programList')
    }

    @PatternNameAnnotation(name = "浏览元数据资源列表")
    @ActionNameAnnotation(name = "浏览元数据资源列表")
    def metaProgramsBrowse() {
        return render(view: 'metaProgramsBrowse');
    }

    //根据元数据medadefine的id，查询对应的资源列表
    def metaProgramList = {
        def result = programService.listMetaDefinePrograms(params)
        return render(result as JSON);
    }

    //元数据树形结构
    def listMetaDefine = {
        def metaDefines = [];
        if (params.pid) {
            metaDefines = MetaDefine.findAllByParentId(params.pid, [order: "asc"]);
        } else {
            metaDefines = MetaDefine.findAllByParentId(0, [order: "asc"]);
        }

        def result = [];
        metaDefines.each { MetaDefine metaDefine ->
            def tmp = [:];
            tmp.id = metaDefine.id;
            tmp.name = metaDefine.cnName;
            tmp.isParent = MetaDefine.countByParentId(metaDefine.id) > 0;
            if (metaDefine.parentId != 0) {
                tmp.pid = metaDefine.parentId;
            }
            result.add(tmp);
        }
        return render(result as JSON);
    }

    @ActionNameAnnotation(name = "资源JSON格式返回")
    def programList2() {

        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (params.rows) {
            params.max = params.rows as int;
        }
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "dateCreated";
        if (params.sidx && "directoryName".equals(params.sidx)) {
            sort = "directory"
        }
        ProgramCategory programCategory = null;
        List<ProgramCategory> categoryList = [];
        def categoryIds = [];
        if (params.categoryId) {
            programCategory = ProgramCategory.get(params.categoryId as long);
            if (programCategory.name.equals("默认资源库")) {
                categoryList.add(programCategory);
                categoryIds.add(programCategory.id);
            } else {
                categoryList = programCategoryService.querySubAllCategoryForAdmin(programCategory);
                if (null == categoryList) {
                    categoryList = [];
                } else {
                    categoryList?.each {
                        categoryIds.add(it.id);
                    }
                }
                categoryList.add(programCategory);
                categoryIds.add(programCategory.id);
            }
        }

        // 按分类查询出符合条件的program
        def programIds = [];
        if (categoryList.size() > 0) {
            programIds = Program.createCriteria().list() {
                projections{
                    distinct('id')
                }
                if (programCategory.name == "资源库") {

                }
                if ((categoryList.size() == 1) && (categoryList.get(0).name.equals("默认资源库"))) {
                    or {
                        isEmpty('programCategories')
                        programCategories {
                            eq('id', categoryList.get(0).id)
                        }
                    }
                } else {
                    if (programCategory.name == "资源库") {
                        or {
                            isEmpty('programCategories')
                            programCategories {
                                'in'('id', categoryIds.toArray())
                            }
                            //isNull('programCategory')
                            //inList("programCategory", categoryList)
                        }
                    } else {
                        programCategories {
                            'in'('id', categoryIds.toArray())
                        }
                        //inList("programCategory", categoryList)
                    }
                }
            }
        }
//        if (sort == "categoryName") {
//            sort = "programCategory";
//        }
        if (sort == "fromNode") {
            sort = "fromNodeId"
        }
        def programList = null;
        def result = [:];
        if(categoryList.size()>0 && programIds.size()==0) {
            programList = [];

            result.page = 0;
            //总记录数
            result.records = 0;
            //总页数
            result.total = 0;
            result.rows = [];
        } else {
            programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
                if (session.consumer) {
                    if (session.consumer.role != 0) {
                        eq("consumer", session.consumer)
                    }
                }
                if(programIds && programIds.size()>0) {
                    'in'('id', programIds.toArray())
                }
                if (params.name) {
                    like("name", "%" + params.name.toString().decodeURL() + "%")
                }
                if (params.state) {
                    //(params.state instanceof String?Integer.parseInt(params.state):params.state)>=0
                    eq("state", params.state as int)
                } else {
                    ge("state", 0)
                }
                if (params.otherOption) {
                    eq("otherOption", params.otherOption as int)
                }

                if (params.canDownload) {
                    boolean canDownload = false;    //是否允许下载
                    boolean canAllDownload = false;    //是否允许所有组或用户下载
                    if (params.canDownload == '0' || params.canDownload == '1') {
                        if (params.canDownload == '1') {
                            canDownload = true;
                        }
                        eq("canDownload", canDownload)
                    }
                    if (params.canDownload == '2' || params.canDownload == '3') {
                        if (params.canDownload == '3') {
                            canAllDownload = true;
                        }
                        eq("canAllDownload", canAllDownload)
                    }
                }
                if (params.canPlay) {
                    boolean canPlay = false;    //是否允许点播
                    boolean canAllPlay = false;    //是否允许所有组或用户点播
                    if (params.canPlay == '0' || params.canPlay == '1') {
                        if (params.canPlay == '1') {
                            canPlay = true;
                        }
                        eq("canPlay", canPlay)
                    }
                    if (params.canPlay == '2' || params.canPlay == '3') {
                        if (params.canPlay == '3') {
                            canAllPlay = true;
                        }
                        eq("canAllPlay", canAllPlay)
                    }
                }
                if (params.canPublic) {
                    boolean canPublic = false    //是否可公开
                    if (params.canPublic == '1') {
                        canPublic = true;
                    }
                    eq("canPublic", canPublic)
                }
                if (params.directoryId) {
                    eq("directory.id", params.directoryId as long)
                }

                if (params.transcodeState) {
                    eq("transcodeState", params.transcodeState as int)
                }
            }

            def total = programList.totalCount;
            //def page = params.offset/params.max+1;


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
                tmp.transcodeState = it.transcodeState;
                if (it?.directory) {
                    tmp.directoryName = it?.directory?.name;
                } else {
                    tmp.directoryName = "";
                }

                tmp.consumer = it.consumer.name;
                def categoryName = "";
                if (it.programCategories && it.programCategories?.size() > 0) {
                    def programCategoryList = it.programCategories.toList();
                    programCategoryList.each { ProgramCategory category ->
                        categoryName = categoryName + category.name + ","
                    }
                    if (categoryName != "") {
                        categoryName = categoryName.substring(0, categoryName.length() - 1);
                    }
                }
                tmp.categoryName = categoryName;
                tmp.otherOption = it.otherOption;
                tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
                tmp.recommendNum = it.recommendNum;
                tmp.collectNum = it.collectNum;
                tmp.canDownload = it.canDownload;
                tmp.canAllDownload = it.canAllDownload;
                tmp.frequency = it.frequency;
                tmp.state = Program.cnState.get(it.state);
                tmp.canPublic = it.canPublic;
                tmp.canPlay = it.canPlay;
                tmp.canAllPlay = it.canAllPlay;
                tmp.fromNode = ServerNode.findById(it.fromNodeId);
                result.rows.add(tmp);
            }
        }
        response.setContentType("text/json");
        return render(result as JSON);

    }

    @ActionNameAnnotation(name = "查询已删除资源列表")
    //资源
    def queryDeletedProgramList() {
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "id";

        List<ProgramCategory> categoryList = [];
        if (params.categoryId) {
            ProgramCategory programCategory = ProgramCategory.get(params.categoryId as long);
            categoryList = programCategoryService.querySubAllCategoryForAdmin(programCategory);
            categoryList.add(programCategory);
        }

        def programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            lt("state", 0)
        }

        def total = programList.totalCount;
        //def page = params.offset/params.max+1;

        def result = [:];
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
            tmp.consumer = it.consumer.name;
            tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
            tmp.dateDeleted = it.dateDeleted.format("yyyy-MM-dd");
            tmp.state = Program.cnState.get(it.state);
            result.rows.add(tmp);
        }

        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "资源回收站")
    @ActionNameAnnotation(name = "资源回收站")
    def deletedProgramList() {
        return render(view: 'deletedProgramList');
    }

    @ActionNameAnnotation(name = "资源浏览")
    def programList() {
    }

    //设置管理端资源状态：操作：审批(通过/退回) 发布(打开/关闭)
    @ActionNameAnnotation(name = "资源状态修改")
    def programStateSet() {
        def result = [:];
        params.consumer = session.consumer;
        params.request = request;
        result = programMgrService.programStateSet(params);
        def operation = CTools.nullToBlank(params.operation);
        if(result.success && operation == "restore") {
            //索引添加
            List<Long> ids = new ArrayList<Long>();
            def proIdList = params.idList
            if (proIdList instanceof String) {
                if (proIdList.contains(',')) {
                    String[] str = proIdList.split(',');
                    str.each {
                        ids.add(Long.parseLong(it));
                    }
                } else {
                    ids.add(Long.parseLong(proIdList));
                }
            }
            if(ids && ids.size()>0) {
                for(Long id: ids) {
                    Program program = Program.get(id);
                    if(program.transcodeState == Program.STATE_SUCCESS) {
                        searchService.addProgramIndex(program);
                    }
                }
            }
        }
        params.idList = ""
        return render(result as JSON)
        //return redirect(controller: "programMgr", action: "programList", params: params)
    }
    /**
     * 更改公开状态
     */
    @ActionNameAnnotation(name = "更改公开状态")
    def changePublicStata() {
        def result = [:];
        params.request = request;
        params.consumer = session.consumer;
        result = programMgrService.changePublicStata(params);
        return render(result as JSON)
    }
    //删除资源
    @ActionNameAnnotation(name = "资源删除")
    def programDelete() {
        def result = [:];
        params.consumer = session.consumer;
        result = programMgrService.deleteProgram(params);
        params.idList = ""
        return render(result as JSON)
        //redirect(controller: "programMgr", action: "programList", params: params)
    }
    //添加修改子目
    def operateSerial = {
        def result = [:];
        result = programMgrService.operateSerial(params);
        if (result.success) {
            flash.message = result.message
        }
        render(template: 'serialList', model: [program: result.program])
    }

    @ActionNameAnnotation(name = "资源更新")
    def programUpdate() {
        def result = [:];
        programMgrService.programUpdate(params);
        if (result.success) {
            flash.message = "资源修改成功。"
            redirect(action: "programEdit", id: params.id)
        } else {
            if (result.notFind) {
                flash.message = "nts.program.domain.Program not found with id ${params.id}"
                redirect(action: "programEdit", id: params.id)
            } else {
                render(view: 'edit', model: [program: result.program])
            }

        }
    }

    @ActionNameAnnotation(name = "修改元数据显示")
    def editMetaContent() {
        def program = Program.get(params.id)

        if (program && (program.consumer.id == session.consumer?.id || session.consumer?.role <= Consumer.MANAGER_ROLE)) {

            return render(view: 'editMetaContent', model: [program: program, operation: 'edit'])
        } else {
            flash.message = "program not found with id ${params.id}"
            redirect(action: "list")
        }
    }

    //def dealMetaData = { program, params ->
    @ActionNameAnnotation(name = "编辑资源元数据信息")
    def dealMetaData() {
        def result = [:];
        result = programMgrService.dealMetaData(params);
        flash.message = result.message;
        redirect(action: "editMetaContent", id: params.id)
    }

    def saveSerialList() {
        Map result = programService.modifySerialList(params);
        if (result.success) {
            redirect(action: "editSerialList", params: [id: params.programId]);
        } else {
            redirect(action: "editSerialList", params: [id: params.programId]);
        }

    }

    @ActionNameAnnotation(name = "资源编辑显示")
    def programEdit() {
        def result = [:];
        result = programMgrService.programEdit(params);
        if (result.success) {
            return render(view: 'programEdit', model: [program: result.program, groupList: result.groupList, directoryList: result.directoryList, operation: result.operation, classLibId: result.classLibId, isRichText: result.isRichText, params: params])
        } else {
            flash.message = result.message;
            redirect(action: "list")
        }
    }

    //为字幕表单提供数据,说明：因为中南财大要得急，字幕相关代码有很多拷贝于serial，故有很多冗余代码，后期有空时，检查并优化
    @ActionNameAnnotation(name = "字幕编辑")
    def editSubtitle() {
        def result = [:];
        result = programMgrService.editSubtitle(params);
        render(view: 'editSubtitle', model: [serial: result.serial, subtitle: result.subtitle, langList: result.langList])
    }

    //用于提取 从资源中提取programId是素材资源的id,其返回素材资源数据到素材编辑页面
    def editMaterial() {
        def program = null
        def programId = CTools.nullToZero(params?.program?.id)

        if (programId > 0)
            program = Program.get(programId)
        else
            flash.message = "Material programId < 0"

        render(template: 'editMaterial', model: [program: program])
    }

    //添加修改字幕
    @ActionNameAnnotation(name = "添加修改字幕")
    def operateSubtitle() {
        def result = [:];
        result = programMgrService.operateSubtitle(params);
        redirect(action: 'editSubtitleList', params: [id: result.serial?.id])
    }

    def deleteSubtitle() {
        def serial = null
        def subtitle = null

        def serialId = CTools.nullToZero(params.serialId)
        def subtitleId = CTools.nullToZero(params.subtitleId)

        if (serialId > 0) {
            serial = Serial.get(serialId)
        } else {
            //serial =  session.serial
        }

        subtitle = Subtitle.get(subtitleId)

        if (serial && subtitle && ((session.consumer.role <= Consumer.MANAGER_ROLE) || (serial.program.consumer.id == session.consumer.id))) {
            subtitle.delete()//not-null property
            serial.removeFromSubtitles(subtitle)//re-saved by cascade
        } else {
            flash.message = "subtitle not found with id ${subtitleId}"
        }

        redirect(action: 'editSubtitleList', params: [id: serial?.id])
    }
    //搜索资源，供相关资源设置用
    @ActionNameAnnotation(name = "查询关联资源")
    def searchRelationProgram() {
        params.isRelation = 1
        def result = programMgrService.search(params)

        render(template: 'searchRelationProgramList', model: [programList: result.programList, total: result.total, keyword: params.keyword])
    }

    //搜索资源，供从现有资源提取设置用 Material素材的意思
    @ActionNameAnnotation(name = "查询素材资源")
    def searchMaterialProgram() {
        def result = programMgrService.search(params)
        render(contentType: "text/html", encoding: "UTF-8", template: 'searchMaterialProgramList', model: [programList: result.programList, total: result.total, keyword: params.keyword])
    }

    //放入回收站,管理员对回收站处理问题：现在管理员只能对审批后的资源进行还原，真正删除
    @ActionNameAnnotation(name = "放入回收站")
    def toRecycler() {
        def result = [:];
        params.consumer = session.consumer;
        params.request = request;
        result = programMgrService.toRecycler(params);
        if(result.success) {
            //索引删除
            List<Long> ids = new ArrayList<Long>();
            def proIdList = params.idList
            if (proIdList instanceof String) {
                if (proIdList.contains(',')) {
                    String[] str = proIdList.split(',');
                    str.each {
                        ids.add(Long.parseLong(it));
                    }
                } else {
                    ids.add(Long.parseLong(proIdList));
                }
            }
            if(ids && ids.size()>0) {
                for(Long id: ids) {
                    Program program = Program.get(id);
                    if(searchService.searchByGuid(program, program.guid) != null) {
                        searchService.deleteIndex(program, program.guid);
                    }
                }
            }

        }
        params.idList = ""
        return render(result as JSON)
        //redirect(controller: "programMgr", action: "programList", params: params)
    }

    //用户组列表
    @ActionNameAnnotation(name = "用户组列表")
    def userGroupList() {
        def result = [:];
        result = programMgrService.userGroupList(params);
        if (result.success) {
            return render(view: "userGroupList", model: [userGroupList       : result.userGroupList, total: result.total, pageCount: result.pageCount,
                                                         pageNow             : result.pageNow, programIdList: result.programIdList, selectedUserGroups: result.selectedUserGroups,
                                                         selectedUserGroupIds: result.selectedUserGroupIds, flag: result.flag]);
        } else {
            flash.message = result.message;
            redirect(controller: "program", action: "programMgr", params: [fromModel: 'programMgr'])
        }

    }

    //设置访问组
    @ActionNameAnnotation(name = "设置访问组")
    def setProgramGroup() {
        def result = [:];
        def programIdList = session.programIdList
        def userGroupIdList = params.idList

        if (programIdList instanceof String) {
            programIdList = [session.programIdList]
        }

        if (userGroupIdList instanceof String) {
            userGroupIdList = [params.idList]
        }


        programIdList?.each { proId ->
            def program = Program.get(proId)
            userGroupIdList?.each { userGroupId ->
                def userGroup = UserGroup.get(userGroupId)
                def ups = program.playGroups
                def flag = true
                for (up in ups) {
                    if (up.id == userGroup.id) {
                        flag = false;
                        break;
                    }
                }
                if (flag) {
                    if (!program.addToPlayGroups(userGroup).save()) {
                        flash.message = "设置组出现问题"
                    }
                }
            }
        }

        session.removeAttribute("programIdList")
        return redirect(controller: "programMgr", action: "programList", params: [fromModel: 'programMgr'])
    }

    //取消组权限
    @ActionNameAnnotation(name = "取消组权限")
    def programGroupDel() {
        def result = [:];
        result = programMgrService.delProgramGroup(params);
        if (!result.success) {
            flash.message = result.message;
        }
        return redirect(controller: "programMgr", action: "programList", params: [fromModel: 'programMgr'])
    }

    //---2009-5-7 新增 myGroupSelectList  查询列表
    @ActionNameAnnotation(name = "查询用户组列表")
    def groupSelectList() {
        def result = [:];
        result = programMgrService.groupSelectList(params);
        return [searchList: result.searchList, userGroupList: result.userGroupList, total: result.total];
    }

    //---2009-6-10 新增 myGroupConsumerList 闭包，查看组员信息
    @ActionNameAnnotation(name = "查看组员信息")
    def groupConsumerList() {
        def result = [:];
        result = programMgrService.groupConsumerList(params);
        [userGroupConsumerList: result.userGroupConsumerList, userGroupList: result.userGroupList, total: result.total, groupId: result.groupId, groupName: result.groupName, pageCount: result.pageCount, pageNow: result.pageNow]
    }

    //--- 2009-05-21 新增 groupDeleteConsumerOne  闭包 ，删除单个组员与组的关系
    @ActionNameAnnotation(name = "删除单个组员与组的关系")
    def groupDeleteConsumerOne() {
        programMgrService.groupDeleteConsumerOne(params);
        return redirect(action: "groupConsumerList", params: [offset: params.offset, max: params.max, groupId: params.groupId])
    }

    //---2009-6-10 新增 groupAddConsumerOne 闭包，向所选择的组中添加新单个用户
    @ActionNameAnnotation(name = "组中添加新单个用户")
    def groupAddConsumerOne() {
        def result = [:];
        result = programMgrService.groupAddConsumerOne(params);
        if (!result.success) {
            flash.message = result.message;
        }
        return redirect(action: "groupConsumerList", params: [offset: params.offset, max: params.max, groupId: params.groupId])
    }

    // 2011-4-15 复制一个节目  by xieyb
    @ActionNameAnnotation(name = "复制节目")
    def copyProgram() {
        def result = [:];
        result = programMgrService.copyProgram(params);
        if (result.success) {
            flash.saveMessage = result.saveMessage;
            return redirect(action: "programEdit", params: [id: result.id, fromModel: result.fromModel])
        } else {
            if (result.noFind) {
                flash.message = result.message;
                redirect(action: "programEdit", id: params.id)
            } else {
                flash.saveMessage = message(code: "controller.save")
                render(view: 'programEdit', model: [program: result.program])
            }
        }
    }

    @ActionNameAnnotation(name = "创建节目显示")
    def programCreate() {
        def result = [:];
        result = programMgrService.programCreate();
        // 取得最新的空间大小
        Consumer spaceConsumer = Consumer.get(session.consumer.id);
        session.consumer.maxSpaceSize = spaceConsumer.maxSpaceSize;
        session.consumer.useSpaceSize = spaceConsumer.useSpaceSize;
        if (result.success) {
            return render(view: 'programCreate', model: [directoryList: result.directoryList])
        } else {
            flash.message = result.message;
            return render(view: 'programCreate');
        }
    }

    def queryDirectoryById() {
        def result = [:];
        def dirId = params.dirId;
        Directory directory;
        if (dirId) {
            directory = Directory.get(dirId as Long);
            result.direcotry = directory
        }
        return render(result as JSON)
    }

    @ActionNameAnnotation(name = "节目信息修改显示")
    def programInfoEdit() {
        def webUtils = WebUtils.retrieveGrailsWebRequest();
        def response = webUtils.getCurrentResponse();
        def idList = params.id;
        Program program = Program.get(idList);
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
        def categoryId = "";
        def categoryName = "";
        List<ProgramCategory> categoryList = program?.programCategories?.toList();
        if (categoryList && categoryList.size() > 0) {
            categoryList.each {
                categoryId = categoryId + it.id + ",";
                categoryName = categoryName + it.name + ",";
            }
        }

        if(categoryList) {
            def factedMap = [:];
            categoryList.each{category ->
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
        Cookie cookie1 = new Cookie("uploadServerAddress", systemConfigService.findUploadServerAddress());
        Cookie cookie2 = new Cookie("uploadServerPort", systemConfigService.findUploadPort().toString());
        response.addCookie(cookie1);
        response.addCookie(cookie2);
        if (categoryId != "") {
            categoryId = categoryId.substring(0, categoryId.length() - 1);
        }
        if (categoryName != "") {
            categoryName = categoryName.substring(0, categoryName.length() - 1);
        }
        return render(view: 'programInfoEdit', model: [program: program, factedList: factedList, categoryId: categoryId, categoryName: categoryName])

    }

    @ActionNameAnnotation(name = "二级资源列表修改显示")
    def editSerialList() {
        def idList = params.id;
        Program program = Program.get(idList);
        List<Serial> serialList = Serial.createCriteria().list(order: 'asc', sort: 'serialNo') {
            eq('program', program)
        }
        // 获取上传路径,mediaType
        def uploadPath = "";
        params.categoryId = program.firstCategoryId;
        def rs = programService.queryCategoryDirectoryAndUploadPath(params);
        if(rs){
            uploadPath = rs.uploadPath;
        }
        Cookie cookie1 = new Cookie("uploadServerAddress", systemConfigService.findUploadServerAddress());
        Cookie cookie2 = new Cookie("uploadServerPort", systemConfigService.findUploadPort().toString());
        response.addCookie(cookie1);
        response.addCookie(cookie2);
        // 取得最新的空间大小
        Consumer spaceConsumer = Consumer.get(session.consumer.id);
        session.consumer.maxSpaceSize = spaceConsumer.maxSpaceSize;
        session.consumer.useSpaceSize = spaceConsumer.useSpaceSize;
        return render(view: 'editSerialList', model: [uploadPath: uploadPath, program: program, serialList: serialList])
    }

    @ActionNameAnnotation(name = "删除Serial")
    def removeSerial() {
        def result = [:];
        Serial serial = Serial.findById(params.id);
        if (serial) {
            try {
                // 更新个人空间
                if(serial.fileSize) {
                    if(session.consumer.role != Consumer.SUPER_ROLE ) {
                        Consumer consumer = Consumer.get(session.consumer.id);
                        consumer.useSpaceSize = consumer.useSpaceSize.longValue() - serial.fileSize.longValue();
                        result.useSize = consumer.useSpaceSize;
                        consumer.save(flush:true);
                    }
                } else {
                    result.useSize = "";
                }

                //删除serial，要删除所有播放记录
                PlayedProgram.executeUpdate("delete PlayedProgram where serial.id = :serialId", [serialId: serial.id]);
                serial.delete(flush: true);
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

    @ActionNameAnnotation(name = "修改Serial显示")
    def editSerial() {
        Serial serial = Serial.get(params.id);
        Cookie cookie1 = new Cookie("uploadServerAddress", systemConfigService.findUploadServerAddress());
        Cookie cookie2 = new Cookie("uploadServerPort", systemConfigService.findUploadPort().toString());
        response.addCookie(cookie1);
        response.addCookie(cookie2);
        return render(view: 'editSerial', model: [serial: serial]);
    }

    @ActionNameAnnotation(name = "保存资源")
    def programSave() {
        params.request = request;
        def result = programService.saveProgram(params);
        if(result.success){
            result.msg = "资源上传成功,是否完善元数据？";
        } else{
            result.msg = "资源上传失败!";
        }
        return render(result as JSON);
//        if (result.success) {
//            flash.saveMes = "资源上传成功,可以继续上传！"
//
//            return redirect(action: 'uploadSuccess');
//        } else {
//            flash.saveMes = "资源上传失败!"
//            return redirect(action: 'programCreate')
//        }
    }

    @ActionNameAnnotation(name = "资源上传成功")
    def uploadSuccess() {
        return render(view: 'uploadSuccess')
    }

    @ActionNameAnnotation(name = "资源修改")
    def updateProgram() {
        params.request = request;
        params.consumer = session.consumer;
        def result = programService.modifyProgramInfo(params);
        flash.msg = result.msg;
        return redirect(action: 'programInfoEdit', params: [id: params.programId])

    }
    /**
     * 判断program是否在开放课程下
     * @return
     */
    def querySubCategory() {
        def result = [:];
        result.success = false;
        def programId = params.programId;
        if (programId) {
            Program program = Program.get(Long.parseLong(programId));
            ProgramCategory programCategory = ProgramCategory.findByName("开放课程资源库");
            if (program && programCategory && program.programCategories) {
                List<ProgramCategory> categoryList = programCategoryService.querySubAllCategoryForAdmin(programCategory);
                //判断修改的program为课程，分类是否为开放课程
                for (ProgramCategory category : categoryList) {
                    if (program.programCategories.id?.contains(category.id)) {
                        result.success = true;
                        break;
                    }
                }
            }
        }
        return render(result as JSON);
    }

    @ActionNameAnnotation(name = "Serial保存")
    def saveSerial() {
        def result = [:];
        result = programMgrService.saveSerial(params);
        if (result.succsess) {
            return redirect(action: 'editSerialList', params: [id: result.programId]);
        } else {
            return redirect(action: 'editSerial', params: [id: result.serialId])
        }
    }

    @ActionNameAnnotation(name = "更改资源分类")
    def changeProgramCategory() {
        def result = [:];
        result = programMgrService.changeProgramCategory(params);
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "节点管理")
    @ActionNameAnnotation(name = "节点管理")
    def serverNodeList() {

    }

    @PatternNameAnnotation(name = "本地资源节点")
    @ActionNameAnnotation(name = "本地资源节点")
    def localProgramServerNode() {
        def result = [:];
        result = distributeService.localProgramServerNode(params);
        return render(view: 'localProgramServerNode', model: [localNode: result.localNode]);
    }

    @PatternNameAnnotation(name = "资源节点")
    @ActionNameAnnotation(name = "资源节点")
    def programServerNode() {
        def res = [:];
        def serverNodeId = params.serverNodeId;
        if (serverNodeId) {
            res = distributeService.programServerNode(params);
            ServerNode serverNode = ServerNode.get(serverNodeId as Long);
            return render(view: 'programServerNode', model: [serverNodeId: serverNodeId, serverNode: serverNode, programList: res.programs, total: res.total, errors: res.errors]);
        } else {
            return render(view: 'programServerNode');
        }

    }

    @PatternNameAnnotation(name = "分发收割策略")
    @ActionNameAnnotation(name = "分发收割策略")
    def programDistributePolicy() {
        if (!params.max) params.max = 10;
        if (!params.offset) params.offset = 0;
        List<Directory> directoryList = Directory.list();
        List<DistributePolicy> distributePolicyList = DistributePolicy.list(max: params.max, offset: params.offset);
        def total = distributePolicyList.totalCount;
        return render(view: 'programDistributePolicy', model: [directoryList: directoryList, distributePolicyList: distributePolicyList, total: total])
    }

    @ActionNameAnnotation(name = "保存分发收割策略")
    def saveDistributePolicy() {
        def serverNodeId = params.serverNodeId;
        def dirId = params.directory;
        DistributePolicy distributePolicy = new DistributePolicy();
        distributePolicy.hot = params.hot as int;
        distributePolicy.latest = params.latest as int;
        distributePolicy.toGrade = params.toGrade as int;
        distributePolicy.isSendObject = params.isSendObject;
        Directory directory;
        if (dirId != '-1') {
            directory = Directory.get(dirId as Long);
            distributePolicy.directory = directory;
        }
        ServerNode serverNode;
        serverNode = ServerNode.get(serverNodeId as Long);
        distributePolicy.addToServerNodes(serverNode);
        distributePolicy.save(flush: true);
        redirect(action: 'programDistributePolicy')
    }

    @ActionNameAnnotation(name = "删除分发收割策略")
    def deleteDistributePolicy() {
        def id = params.id;
        DistributePolicy distributePolicy = DistributePolicy.get(id as Long);
        distributePolicy.serverNodes?.toList().each { ServerNode serverNode ->
            serverNode.removeFromDistributePolicys(distributePolicy)
            distributePolicy.removeFromServerNodes(serverNode);
        }
        distributePolicy.delete();
        redirect(action: 'programDistributePolicy')
    }

    @PatternNameAnnotation(name = "时间计划")
    @ActionNameAnnotation(name = "时间计划")
    def timePlanShow() {
        List<TimePlan> timePlanList = TimePlan.list();
        List<DistributePolicy> distributePolicyList = DistributePolicy.list();
        [timePlanList: timePlanList, distributePolicyList: distributePolicyList]
    }

    @ActionNameAnnotation(name = "添加时间计划")
    def saveTimePlan() {
        if (!CronExpression.isValidExpression(params.expression)) {
            flash.message = "cron表达式${params.expression}无效!"
            if (params.id) {
                return redirect(action: 'editTimePlan2', params: [id: params.id])
            } else {
                return redirect(action: 'timePlanShow')
            }
        }
        def id = params.id;
        DistributePolicy distributePolicy = null;
        TimePlan timePlan = null;
        if (id) {
            timePlan = TimePlan.get(id as Long);
        } else {
            timePlan = new TimePlan();
        }
        def plan = params.timePlan;
        if (params.disId != '-1') {
            if (params.disId instanceof String[]) {
                params.disId.each {
                    distributePolicy = DistributePolicy.get(it as Long);
                    distributePolicy.timePlan = timePlan;
                    distributePolicy.save();
                    timePlan.addToDistributePolicys(distributePolicy);
                }
            } else {
                distributePolicy = DistributePolicy.get(params.disId as Long);
                distributePolicy.timePlan = timePlan;
                distributePolicy.save();
                timePlan.addToDistributePolicys(distributePolicy);
            }

        }

        timePlan.expression = params.expression;
        if (params.isActive == '1') {
            timePlan.isActive = true;
        } else {
            timePlan.isActive = false;
        }
        timePlan.properties = params;
        timePlan.save();
        timePlanJobService.startTimePlanJob();
        redirect(action: 'timePlanShow')
    }

    @ActionNameAnnotation(name = "删除时间计划")
    def deleteTimePlan() {
        def id = params.id;
        TimePlan timePlan = TimePlan.get(id as Long);
        timePlan.distributePolicys?.toList().each { DistributePolicy distributePolicy ->
            timePlan.removeFromDistributePolicys(distributePolicy);
        }
        timePlan.delete();
        redirect(action: 'timePlanShow')
    }

    @ActionNameAnnotation(name = "设置时间计划")
    def editTimePlan2() {
        def id = params.id;
        TimePlan timePlan = TimePlan.get(id as Long);
        List<DistributePolicy> distributePolicyList = DistributePolicy.list();
        return render(view: 'editTimePlan', model: [distributePolicyList: distributePolicyList, timePlan: timePlan])
    }

    def editTimePlan() {
        def id = params.id;
        DistributePolicy distributePolicy = DistributePolicy.get(id as Long);
        TimePlan timePlan = distributePolicy.timePlan;
        List<DistributePolicy> distributePolicyList = DistributePolicy.list();
        [distributePolicyList: distributePolicyList, timePlan: timePlan]
    }

    @PatternNameAnnotation(name = "Job列表")
    @ActionNameAnnotation(name = "Job列表")
    def timePlanList() {
        Scheduler scheduler = timePlanJobService.getDefaultScheduler();
        List<JobDetail> jobDetails = [];
        def result = [];
        if (scheduler) {
            Set<JobKey> jobKeys = scheduler.getJobKeys(GroupMatcher.jobGroupContains("-"));

            jobKeys.each {
                try {
                    String[] keyArray = it.getGroup().split("-");
                    long policyId = keyArray[1] as long;
                    long sererNodeId = keyArray[2] as long;
                    String groupName = it.getGroup();
                    DistributePolicy distributePolicy = DistributePolicy.findById(policyId);
                    ServerNode serverNode = ServerNode.findById(sererNodeId);
                    def tmp = [:];
                    tmp.name = serverNode.name;
                    tmp.group = groupName;
                    tmp.id = it.getName();
                    result.add(tmp);
                } catch (Exception e) {

                }

                jobDetails.add(scheduler.getJobDetail(it));
            }
        }

        return render(view: 'timePlanList', model: [jobs: result])
    }

    def closeTimePlanJob() {
        def jobGroup = params.group;
        def jobName = params.name;
        timePlanJobService.stopTimePlanJob(jobGroup, jobName);
        redirect(action: 'timePlanList');
    }

    @ActionNameAnnotation(name = "资源排行")
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
    /**
     * 资源排行页面
     * @return
     */
    @PatternNameAnnotation(name = "资源排行")
    @ActionNameAnnotation(name = "资源排行")
    def programStatisticsIndex() {
        def startDate = params.startTime;
        def endDate = params.endTime;
        def result = programTotalAndPercentStatistics(startDate, endDate);
        return render(view: 'programStatisticsIndex', model: [programTotal: result.programTotal, totalList: result.totalList]);
    }
    /**
     * 用来显示柱状图
     * @return
     */
    @ActionNameAnnotation(name = "资源分类数据")
    def programStatisticsIndexData() {
        //要查询的资源类别
        def statisticsCategory = params.statisticsCategory;
        def sort = null;
        def max = 10;
        def order = "desc";
        def programList = null;
        def result = [:];
        result.categories = [];     //资源名称
        result.data = [];           //资源返回数据
        if ("frequency".equals(statisticsCategory)) {
            sort = statisticsCategory;
            programList = Program.createCriteria().list(max: max, sort: sort, order: order) {
                ge("state", 0)
            }
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Program program : programList) {
                if (program.frequency == 0) {
                    int programFrequency = PlayedProgram.countByProgram(program);
                    program.frequency = programFrequency;
                }
                result.categories.add(program.name);
                result.data.add(program.frequency);
            }
        } else if ("viewNum".equals(statisticsCategory)) {
            sort = statisticsCategory;
            programList = Program.createCriteria().list(max: max, sort: sort, order: order) {
                ge("state", 0)
            }
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Program program : programList) {
                if (program.viewNum == 0) {
                    int programViewNum = ViewedProgram.countByProgram(program);
                    program.viewNum = programViewNum;
                }
                result.categories.add(program.name);
                result.data.add(program.viewNum);
            }
        } else if ("downloadNum".equals(statisticsCategory)) {
            sort = statisticsCategory;
            programList = Program.createCriteria().list(max: max, sort: sort, order: order) {
                ge("state", 0)
            }
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Program program : programList) {
                if (program.downloadNum == 0) {
                    int programDownloadNum = DownloadedProgram.countByProgram(program);
                    program.downloadNum = programDownloadNum;
                }
                result.categories.add(program.name);
                result.data.add(program.downloadNum);
            }
        } else if ("recommendNum".equals(statisticsCategory)) {
            sort = statisticsCategory;
            programList = Program.createCriteria().list(max: max, sort: sort, order: order) {
                ge("state", 0)
            }
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Program program : programList) {
                if (program.recommendNum == 0) {
                    int programRecommendNum = RecommendedProgram.countByProgram(program);
                    program.recommendNum = programRecommendNum;
                }
                result.categories.add(program.name);
                result.data.add(program.recommendNum);
            }
        } else if ("collectNum".equals(statisticsCategory)) {
            sort = statisticsCategory;
            programList = Program.createCriteria().list(max: max, sort: sort, order: order) {
                ge("state", 0)
            }
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Program program : programList) {
                if (program.collectNum == 0) {
                    int programCollectNum = CollectedProgram.countByProgram(program);
                    program.collectNum = programCollectNum;
                }
                result.categories.add(program.name);
                result.data.add(program.collectNum);
            }
        }
        return render(result as JSON);
    }
    /**
     * 资源点播排行榜
     */
    @ActionNameAnnotation(name = "资源点播排行榜")
    def programFrequencyStatistics() {
        def sort = "frequency";
        if (params.sort) {
            sort = params.sort;
        }
        def max = 10;
        if (params.max) {
            max = params.max;
        }
        def order = "desc";
        if (params.order) {
            order = params.order;
        }
        def offset = 0;
        if (params.offset) {
            offset = params.offset;
        }
        def total = 0;
        def programList = Program.createCriteria().list(max: max, offset: offset, sort: sort, order: order) {
            ge("state", 0);
        }
        if (programList) {
            total = programList.totalCount;
        }
        return render(view: 'programFrequencyStatistics', model: [programList: programList, total: total])
    }
    /**
     * 资源点播统计报表
     */
    def programFrequencyStatisticsFrom() {
        def startTimeNum = params.startTime;
        def endTimeNum = params.endTime;
        def sort = "frequency";
        def max = 20;
        def order = "desc";
        def programList = null;
        def result = [:];
        result.categories = [];     //资源名称
        result.data = [];           //资源返回数据
        if (startTimeNum) {
            //查询起始时间，和结束时间，如果是查询本周，今天，本月，则默认结束时间为当前时间
            def endTime = new Date();
            def startTime = new Date(Long.parseLong(startTimeNum));
            if (endTimeNum) {
                endTime = new Date(Long.parseLong(endTimeNum));
            }
            //统计查询资源数量和资源名称
            List statisticsData = PlayedProgram.executeQuery("select count(program.id)as programCount, program.name from PlayedProgram where dateCreated between :startTime and :endTime group by program.id order by programCount desc", [startTime: startTime, endTime: endTime]);
            for (int i = 0; i < 20 && i < statisticsData.size(); i++) {
                result.data.add(statisticsData[i][0]);
                result.categories.add(statisticsData[i][1]);
            }
        } else {
            programList = Program.createCriteria().list(max: max, sort: sort, order: order) {
                ge("state", 0);
            }
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Program program : programList) {
                if (program.frequency == 0) {
                    int programFrequency = PlayedProgram.countByProgram(program);
                    program.frequency = programFrequency;
                }
                result.categories.add(program.name);
                result.data.add(program.frequency);
            }
        }
        return render(result as JSON);
    }
    /**
     * 资源浏览排行榜
     */
    @ActionNameAnnotation(name = "资源浏览排行榜")
    def programViewNumStatistics() {
        def sort = "viewNum";
        if (params.sort) {
            sort = params.sort;
        }
        def max = 10;
        if (params.max) {
            max = params.max;
        }
        def order = "desc";
        if (params.order) {
            order = params.order;
        }
        def offset = 0;
        if (params.offset) {
            offset = params.offset;
        }
        def total = 0;
        def programList = Program.createCriteria().list(max: max, offset: offset, sort: sort, order: order) {
            ge("state", 0);
        }
        if (programList) {
            total = programList.totalCount;
        }
        return render(view: 'programViewNumStatistics', model: [programList: programList, total: total])
    }
    /**
     * 资源浏览统计报表
     */
    def programViewNumStatisticsFrom() {
        def startTimeNum = params.startTime;
        def endTimeNum = params.endTime;
        def sort = "viewNum";
        def max = 20;
        def order = "desc";
        def programList = null;
        def result = [:];
        result.categories = [];     //资源名称
        result.data = [];           //资源返回数据
        if (startTimeNum) {
            //查询起始时间，和结束时间，如果是查询本周，今天，本月，则默认结束时间为当前时间
            def endTime = new Date();
            def startTime = new Date(Long.parseLong(startTimeNum));
            if (endTimeNum) {
                endTime = new Date(Long.parseLong(endTimeNum));
            }
            //统计查询资源数量和资源名称
            List statisticsData = ViewedProgram.executeQuery("select count(program.id)as programCount, program.name from ViewedProgram where dateCreated between :startTime and :endTime group by program.id order by programCount desc", [startTime: startTime, endTime: endTime]);
            for (int i = 0; i < 20 && i < statisticsData.size(); i++) {
                result.data.add(statisticsData[i][0]);
                result.categories.add(statisticsData[i][1]);
            }
        } else {
            programList = Program.createCriteria().list(max: max, sort: sort, order: order) {
                ge("state", 0);
            }
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Program program : programList) {
                if (program.viewNum == 0) {
                    int programViewNum = ViewedProgram.countByProgram(program);
                    program.viewNum = programViewNum;
                }
                result.categories.add(program.name);
                result.data.add(program.viewNum);
            }
        }
        return render(result as JSON);
    }
    /**
     * 资源下载排行榜
     */
    @ActionNameAnnotation(name = "资源下载排行榜")
    def programDownloadNumStatistics() {
        def sort = "downloadNum";
        if (params.sort) {
            sort = params.sort;
        }
        def max = 10;
        if (params.max) {
            max = params.max;
        }
        def order = "desc";
        if (params.order) {
            order = params.order;
        }
        def offset = 0;
        if (params.offset) {
            offset = params.offset;
        }
        def total = 0;
        def programList = Program.createCriteria().list(max: max, offset: offset, sort: sort, order: order) {
            ge("state", 0);
        }
        if (programList) {
            total = programList.totalCount;
        }
        return render(view: 'programDownloadNumStatistics', model: [programList: programList, total: total])
    }
    /**
     * 资源下载统计报表
     */
    def programDownloadNumStatisticsFrom() {
        def startTimeNum = params.startTime;
        def endTimeNum = params.endTime;
        def sort = "downloadNum";
        def max = 20;
        def order = "desc";
        def programList = null;
        def result = [:];
        result.categories = [];     //资源名称
        result.data = [];           //资源返回数据
        if (startTimeNum) {
            //查询起始时间，和结束时间，如果是查询本周，今天，本月，则默认结束时间为当前时间
            def endTime = new Date();
            def startTime = new Date(Long.parseLong(startTimeNum));
            if (endTimeNum) {
                endTime = new Date(Long.parseLong(endTimeNum));
            }
            //统计查询资源数量和资源名称
            List statisticsData = DownloadedProgram.executeQuery("select count(program.id)as programCount, program.name from DownloadedProgram where dateCreated between :startTime and :endTime group by program.id order by programCount desc", [startTime: startTime, endTime: endTime]);
            for (int i = 0; i < 20 && i < statisticsData.size(); i++) {
                result.data.add(statisticsData[i][0]);
                result.categories.add(statisticsData[i][1]);
            }
        } else {
            programList = Program.createCriteria().list(max: max, sort: sort, order: order) {
                ge("state", 0);
            }
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Program program : programList) {
                if (program.downloadNum == 0) {
                    int programDownloadNum = DownloadedProgram.countByProgram(program);
                    program.downloadNum = programDownloadNum;
                }
                result.categories.add(program.name);
                result.data.add(program.downloadNum);
            }
        }
        return render(result as JSON);
    }
    /**
     * 资源推荐排行榜
     */
    @ActionNameAnnotation(name = "资源推荐排行榜")
    def programRecommendNumStatistics() {
        def sort = "recommendNum";
        if (params.sort) {
            sort = params.sort;
        }
        def max = 10;
        if (params.max) {
            max = params.max;
        }
        def order = "desc";
        if (params.order) {
            order = params.order;
        }
        def offset = 0;
        if (params.offset) {
            offset = params.offset;
        }
        def total = 0;
        def programList = Program.createCriteria().list(max: max, offset: offset, sort: sort, order: order) {
            ge("state", 0);
        }
        if (programList) {
            total = programList.totalCount;
        }
        return render(view: 'programRecommendNumStatistics', model: [programList: programList, total: total])
    }
    /**
     * 资源推荐统计报表
     */
    def programRecommendNumStatisticsFrom() {
        def startTimeNum = params.startTime;
        def endTimeNum = params.endTime;
        def sort = "recommendNum";
        def max = 20;
        def order = "desc";
        def programList = null;
        def result = [:];
        result.categories = [];     //资源名称
        result.data = [];           //资源返回数据
        if (startTimeNum) {
            //查询起始时间，和结束时间，如果是查询本周，今天，本月，则默认结束时间为当前时间
            def endTime = new Date();
            def startTime = new Date(Long.parseLong(startTimeNum));
            if (endTimeNum) {
                endTime = new Date(Long.parseLong(endTimeNum));
            }
            //统计查询资源数量和资源名称
            List statisticsData = RecommendedProgram.executeQuery("select count(program.id)as programCount, program.name from RecommendedProgram where dateCreated between :startTime and :endTime group by program.id order by programCount desc", [startTime: startTime, endTime: endTime]);
            for (int i = 0; i < 20 && i < statisticsData.size(); i++) {
                result.data.add(statisticsData[i][0]);
                result.categories.add(statisticsData[i][1]);
            }
        } else {
            programList = Program.createCriteria().list(max: max, sort: sort, order: order) {
                ge("state", 0);
            }
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Program program : programList) {
                if (program.recommendNum == 0) {
                    int programRecommendNum = RecommendedProgram.countByProgram(program);
                    program.recommendNum = programRecommendNum;
                }
                result.categories.add(program.name);
                result.data.add(program.recommendNum);
            }
        }
        return render(result as JSON);
    }
    /**
     * 资源收藏排行榜
     */
    @ActionNameAnnotation(name = "资源收藏排行榜")
    def programCollectNumStatistics() {
        def sort = "collectNum";
        if (params.sort) {
            sort = params.sort;
        }
        def max = 10;
        if (params.max) {
            max = params.max;
        }
        def order = "desc";
        if (params.order) {
            order = params.order;
        }
        def offset = 0;
        if (params.offset) {
            offset = params.offset;
        }
        def total = 0;
        def programList = Program.createCriteria().list(max: max, offset: offset, sort: sort, order: order) {
            ge("state", 0);
        }
        if (programList) {
            total = programList.totalCount;
        }
        return render(view: 'programCollectNumStatistics', model: [programList: programList, total: total])
    }
    /**
     * 资源收藏统计报表
     */
    def programCollectNumStatisticsFrom() {
        def startTimeNum = params.startTime;
        def endTimeNum = params.endTime;
        def sort = "collectNum";
        def max = 20;
        def order = "desc";
        def programList = null;
        def result = [:];
        result.categories = [];     //资源名称
        result.data = [];           //资源返回数据
        if (startTimeNum) {
            //查询起始时间，和结束时间，如果是查询本周，今天，本月，则默认结束时间为当前时间
            def endTime = new Date();
            def startTime = new Date(Long.parseLong(startTimeNum));
            if (endTimeNum) {
                endTime = new Date(Long.parseLong(endTimeNum));
            }
            //统计查询资源数量和资源名称
            List statisticsData = CollectedProgram.executeQuery("select count(program.id)as programCount, program.name from CollectedProgram where dateCreated between :startTime and :endTime group by program.id order by programCount desc", [startTime: startTime, endTime: endTime]);
            for (int i = 0; i < 20 && i < statisticsData.size(); i++) {
                result.data.add(statisticsData[i][0]);
                result.categories.add(statisticsData[i][1]);
            }
        } else {
            programList = Program.createCriteria().list(max: max, sort: sort, order: order) {
                ge("state", 0);
            }
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Program program : programList) {
                if (program.collectNum == 0) {
                    int programCollectNum = CollectedProgram.countByProgram(program);
                    program.collectNum = programCollectNum;
                }
                result.categories.add(program.name);
                result.data.add(program.collectNum);
            }
        }
        return render(result as JSON);
    }
    /**
     * 资源统计页面
     * @return
     */
    @PatternNameAnnotation(name = '资源统计')
    @ActionNameAnnotation(name = "资源统计")
    def programStatistics() {
        def startDate = params.startTime;
        def endDate = params.endTime;
        def result = programTotalAndPercentStatistics(startDate, endDate);
        return render(view: 'programStatistics', model: [programTotal: result.programTotal, totalList: result.totalList]);
    }

    /**
     * 资源总数,各媒体类型总数和百分数统计
     * @return
     */
    private Map programTotalAndPercentStatistics(String startDate, String endDate) {
        def result = [:];
        //数字格式化
        DecimalFormat decimalFormat = new DecimalFormat("###.##");
        //资源总数
        def programTotal = programTotalQuery(99, 0, startDate, endDate);
        //视频总数,百分数,不包括删除资源
        def videoTotal = programTotalQuery(Program.ONLY_VIDEO_OPTION, 0, startDate, endDate);
        def videoPercent = 0;
        //文档总数,百分数
        def documentTotal = programTotalQuery(Program.ONLY_TXT_OPTION, 0, startDate, endDate);
        def documentPercent = 0;
        //图片总数,百分数
        def imageTotal = programTotalQuery(Program.ONLY_IMG_OPTION, 0, startDate, endDate);
        def imagePercent = 0;
        //音频总数,百分数
        def audioTotal = programTotalQuery(Program.ONLY_AUDIO_OPTION, 0, startDate, endDate);
        def audioPercent = 0;
        //课程总数,百分数
        def courseTotal = programTotalQuery(Program.ONLY_LESSION_OPTION, 0, startDate, endDate);
        def coursePercent = 0;
        if (programTotal != 0) {
            videoPercent = decimalFormat.format(videoTotal * 100.0 / programTotal);
            documentPercent = decimalFormat.format(documentTotal * 100.0 / programTotal);
            imagePercent = decimalFormat.format(imageTotal * 100.0 / programTotal);
            audioPercent = decimalFormat.format(audioTotal * 100.0 / programTotal);
            coursePercent = decimalFormat.format(courseTotal * 100.0 / programTotal);
        }
        def totalList = [];
        def tmpMap = [:];
        if (videoTotal != 0) {
            tmpMap = [:];
            tmpMap.total = videoTotal;
            tmpMap.percent = videoPercent;
            tmpMap.name = "视频总量";
            totalList.add(tmpMap);
        }

        if (audioTotal != 0) {
            tmpMap = [:];
            tmpMap.total = audioTotal;
            tmpMap.percent = audioPercent;
            tmpMap.name = "音频总量";
            totalList.add(tmpMap);
        }

        if (documentTotal != 0) {
            tmpMap = [:];
            tmpMap.total = documentTotal;
            tmpMap.percent = documentPercent;
            tmpMap.name = "文档总量";
            totalList.add(tmpMap);
        }
        if (imageTotal != 0) {
            tmpMap = [:];
            tmpMap.total = imageTotal;
            tmpMap.percent = imagePercent;
            tmpMap.name = "图片总量";
            totalList.add(tmpMap);
        }

        if (courseTotal != 0) {
            tmpMap = [:];
            tmpMap.total = courseTotal;
            tmpMap.percent = coursePercent;
            tmpMap.name = "课程总量";
            totalList.add(tmpMap);
        }
        result.programTotal = programTotal;
        result.totalList = totalList;
        return result;
    }

    /**
     * 获取资源总数
     * @param otherOption
     * @param state
     * @param startDate
     * @param endDate
     * @return
     */
    private long programTotalQuery(int otherOption, int state, String startDate, String endDate) {
        def programTotal = 0;
        def startTime = null;
        if (startDate) {
            startTime = new Date();
            startTime = new Date(Long.parseLong(startDate));
        }
        def endTime = null;
        if (endDate) {
            endTime = new Date();
            endTime = new Date(Long.parseLong(endDate));
        }
        def programList = Program.createCriteria().list {
            if (otherOption != 99) {
                eq('otherOption', otherOption as int)
            }
            gt('state', state)
            if (startTime) {
                gt('dateCreated', startTime)
            }
            if (endTime) {
                lt('dateCreated', endTime)
            }
        };
        if (programList) {
            programTotal = programList.size();
        }
        return programTotal;
    }

    /**
     * 资源统计
     * @return
     */
    @ActionNameAnnotation(name = "资源统计")
    def programStatisticsData() {
        def result = [];
        def tmp = [];
        def startDate = null;
        def endDate = null;
        if (params.startTime) {
            startDate = params.startTime;
        }
        if (params.endTime) {
            endDate = params.endTime;
        }

        //资源总数
        def programTotal = Program.countByStateGreaterThanEquals(0);
        //视频总数,不包括删除资源
        def videoTotal = programTotalQuery(Program.ONLY_VIDEO_OPTION, 0, startDate, endDate);
        tmp = [];
        tmp.add("视频");
        tmp.add(videoTotal);
        result.add(tmp);
        //文档总数
        def documentTotal = programTotalQuery(Program.ONLY_TXT_OPTION, 0, startDate, endDate);
        tmp = [];
        tmp.add("文档");
        tmp.add(documentTotal);
        result.add(tmp)
        //图片总数
        def imageTotal = programTotalQuery(Program.ONLY_IMG_OPTION, 0, startDate, endDate);
        tmp = [];
        tmp.add("图片");
        tmp.add(imageTotal);
        result.add(tmp)
        //音频总数
        def audioTotal = programTotalQuery(Program.ONLY_AUDIO_OPTION, 0, startDate, endDate);
        tmp = [];
        tmp.add("音频");
        tmp.add(audioTotal);
        result.add(tmp)
        //课程总数
        def courseTotal = programTotalQuery(Program.ONLY_LESSION_OPTION, 0, startDate, endDate);
        tmp = [];
        tmp.add("课程");
        tmp.add(courseTotal);
        result.add(tmp)
        return render(result as JSON);
    }
    /**
     * 每年数据统计
     * @return
     */
    @ActionNameAnnotation(name = "每年数据统计")
    def programYearStatisticsData() {
        def result = [:];
        result.year = [];     //资源名称
        result.series = [];
        def serMap = [:];
        def count = [];
        def startTime = null;
        def endTime = null;
        //资源总数
        Calendar ca = Calendar.getInstance();

        def programList = Program.createCriteria().list(max: 1, order: 'asc', sort: 'id') {
            ge("state", 0);
        }
        if (programList) {
            Program firstCreateProgram = programList[0];
            ca.setTime(firstCreateProgram.dateCreated);
            //获取数据库中最早上传时间和现在之差
            int yearDiffer = Calendar.getInstance().get(Calendar.YEAR) - ca.get(Calendar.YEAR);
            for (int i = 0; i <= yearDiffer; i++) {
                //设置日历为最开始上传那一年，第一天
                ca.set(ca.get(Calendar.YEAR), 0, 1, 0, 0, 0);
                startTime = ca.getTime();                   //开始时间

                result.year.add(ca.get(Calendar.YEAR));
                //设置日历为下一年第一天
                ca.set(ca.get(Calendar.YEAR) + 1, 0, 1, 0, 0, 0);
                endTime = ca.getTime();                     //结束时间
                //通过时间state和创建时间来查询program的总数
                int countProgram = Program.countByStateGreaterThanEqualsAndDateCreatedBetween(0, startTime, endTime);
                count.add(countProgram);
            }
            serMap = [:];
            serMap.name = "资源总量";
            serMap.data = count;
            result.series.add(serMap);
        }
        return render(result as JSON);
    }
    /**
     * 依据月份数据统计
     * @return
     */
    @ActionNameAnnotation(name = "依据月份数据统计")
    def programMonthStatisticsData() {
        def result = [:];
        result.month = [];     //资源名称
        result.series = [];

        //资源总数
        def programStartTime = new Date();
        Calendar ca = Calendar.getInstance();
        def programList = Program.createCriteria().list(max: 1, order: 'asc', sort: 'id') {
            ge("state", 0);
        }
        if (programList && programList.size() > 0) {
            Program firstCreateProgram = programList[0];
            ca.setTime(firstCreateProgram.dateCreated);
            //设置日历为最开始上传那一年，第一天
            ca.set(ca.get(Calendar.YEAR), 0, 1, 0, 0, 0);
            programStartTime = ca.getTime();                   //开始时间
        }

        //开始结束日历
        Calendar startCalendar = Calendar.getInstance();
        Calendar endCalendar = Calendar.getInstance();
        def startTime = new Date();
        if (params.startTime) {
            startTime = new Date(Long.parseLong(params.startTime));
            startCalendar.setTime(startTime);
            //设置为当月的第一天
            startCalendar.set(startCalendar.get(Calendar.YEAR), startCalendar.get(Calendar.MONTH), 1, 0, 0, 0);
        } else {
            //设置为当月的第一天
            startCalendar.set(startCalendar.get(Calendar.YEAR), 1, 1, 0, 0, 0);
        }
        def endTime = new Date();
        if (params.endTime) {
            endTime = new Date(Long.parseLong(params.endTime));
            endCalendar.setTime(endTime);
        }

        //查询两个月份之差
        int monthDiffer = (endCalendar.get(Calendar.YEAR) - startCalendar.get(Calendar.YEAR)) * 12 + (endCalendar.get(Calendar.MONTH) - startCalendar.get(Calendar.MONTH));

        def monthCount = [];
        def count = [];
        for (int i = 0; i <= monthDiffer; i++) {
            startTime = startCalendar.getTime();                    //查询第一天
            result.month.add(startCalendar.get(Calendar.YEAR) + " " + (startCalendar.get(Calendar.MONTH) + 1));
            //设置日历为下一个月第一天
            startCalendar.set(startCalendar.get(Calendar.YEAR), startCalendar.get(Calendar.MONTH) + 1, 1, 0, 0, 0);
            endTime = startCalendar.getTime();                      //结束日期
            //通过时间state和创建时间来查询program的总数
            int countProgram = Program.countByStateGreaterThanEqualsAndDateCreatedBetween(0, startTime, endTime);
            monthCount.add(countProgram);
            //资源总量
            int countProgramTotal = Program.countByStateGreaterThanEqualsAndDateCreatedBetween(0, programStartTime, endTime);
            count.add(countProgramTotal);
        }
        //增长率计算
        def increaseRateList = [];
        if (monthCount && monthCount.size() > 0 && monthCount.size() > 1) {
            int size = monthCount.size();
            increaseRateList = [0];
            int increaseRate = 0;
            for (int j = 1; j < size; j++) {
                if(monthCount[j]!=0&&monthCount[j-1]==0){
                    increaseRate = 100;
                } else if(monthCount[j]==0&&monthCount[j-1]==0){
                    increaseRate = 0;
                } else {
                    increaseRate = Math.floor((monthCount[j] - monthCount[j - 1]) / monthCount[j - 1]);
                }
                increaseRateList.add(increaseRate);
            }
        }
        def serMap = [:];
        serMap.name = "资源总量/个";
        serMap.data = count;
        result.series.add(serMap);
        serMap = [:];
        serMap.name = "资源数(每月)/个";
        serMap.data = monthCount;
        result.series.add(serMap);
        serMap = [:];
        serMap.name = "增长率/百分比";
        serMap.data = increaseRateList;
        result.series.add(serMap);
        return render(result as JSON);
    }
    /**
     * 用户统计首页
     */
    @PatternNameAnnotation(name = "用户统计")
    @ActionNameAnnotation(name = "用户统计")
    def userVisitStatisticsIndex() {
        return render(view: 'userVisitStatisticsIndex');
    }
    /**
     * 用户统计柱状图数据s
     */
    @ActionNameAnnotation(name = "用户统计柱状图数据")
    def userVisitStatisticsIndexData() {
        def statisticsCategory = params.statisticsCategory;
        def sort = null;
        def max = 10;
        def order = "desc";
        def consumerList = null;
        def result = [:];
        result.categories = [];     //资源名称
        result.data = [];           //资源返回数据
        if ("playNum".equals(statisticsCategory)) {
            sort = statisticsCategory;
            consumerList = Consumer.list(max: max, sort: sort, order: order);
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Consumer consumer : consumerList) {
                result.categories.add(consumerName(id: consumer.id));
                /*if (consumer.playNum == 0) {
                    int consumerPlayNum = PlayedProgram.countByConsumer(consumer);
                    consumer.playNum = consumerPlayNum;
                }*/
                int consumerPlayNum = PlayedProgram.countByConsumer(consumer);
                consumer.playNum = consumerPlayNum;
                result.data.add(consumer.playNum);
            }
        } else if ("uploadNum".equals(statisticsCategory)) {
            sort = statisticsCategory;
            consumerList = Consumer.list(max: max, sort: sort, order: order)
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Consumer consumer : consumerList) {
                result.categories.add(consumerName(id: consumer.id));
                if (consumer.uploadNum == 0) {
                    int consumerUploadNum = Program.countByConsumer(consumer);
                    consumer.uploadNum = consumerUploadNum;
                }
                result.data.add(consumer.uploadNum);
            }
        } else if ("downloadNum".equals(statisticsCategory)) {
            sort = statisticsCategory;
            consumerList = Consumer.list(max: max, sort: sort, order: order)
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Consumer consumer : consumerList) {
                result.categories.add(consumerName(id: consumer.id));
                if (consumer.downloadNum == 0) {
                    int consumerDownLoadNum = DownloadedProgram.countByConsumer(consumer);
                    consumer.downloadNum = consumerDownLoadNum;
                }
                result.data.add(consumer.downloadNum);
            }
        } else if ("collectNum".equals(statisticsCategory)) {
            sort = statisticsCategory;
            consumerList = Consumer.createCriteria().list(max: max, sort: sort, order: order) {}
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Consumer consumer : consumerList) {
                result.categories.add(consumerName(id: consumer.id));
                if (consumer.collectNum == 0) {
                    int consumerCollectNum = CollectedProgram.countByConsumer(consumer);
                    consumer.collectNum = consumerCollectNum;
                }
                result.data.add(consumer.collectNum);
            }
        }
        return render(result as JSON);
    }
    /**
     * 用户点播
     * @return
     */
    @ActionNameAnnotation(name = "用户点播排行")
    def userVisitPlayNumStatistics() {
        def sort = "playNum";
        if (params.sort) {
            sort = params.sort;
        }
        def max = 10;
        if (params.max) {
            max = params.max;
        }
        def order = "desc";
        if (params.order) {
            order = params.order;
        }
        def offset = 0;
        if (params.offset) {
            offset = params.offset;
        }
        def total = 0;
        def consumerList = Consumer.createCriteria().list(max: max, offset: offset, sort: sort, order: order) {}
        if (consumerList) {
            total = consumerList.totalCount;
        }
        return render(view: 'userVisitPlayNumStatistics', model: [consumerList: consumerList, total: total])
    }
    /**
     * 用户点播报表
     * @return
     */
    @ActionNameAnnotation(name = "用户点播报表")
    def userVisitPlayNumStatisticsForm() {
        def startTimeNum = params.startTime;
        def endTimeNum = params.endTime;
        def sort = "playNum";
        def max = 20;
        def order = "desc";
        def consumerList = null;
        def result = [:];
        result.categories = [];     //资源名称
        result.data = [];           //资源返回数据
        if (startTimeNum) {
            //查询起始时间，和结束时间，如果是查询本周，今天，本月，则默认结束时间为当前时间
            def endTime = new Date();
            def startTime = new Date(Long.parseLong(startTimeNum));
            if (endTimeNum) {
                endTime = new Date(Long.parseLong(endTimeNum));
            }
            //统计查询资源数量和资源名称
            List statisticsData = PlayedProgram.executeQuery("select count(consumer.id)as consumerCount, consumer.id from PlayedProgram where dateCreated between :startTime and :endTime group by consumer.id order by consumerCount desc", [startTime: startTime, endTime: endTime]);
            for (int i = 0; i < 20 && i < statisticsData.size(); i++) {
                result.data.add(statisticsData[i][0]);
                result.categories.add(consumerName(id: statisticsData[i][1]));
            }
        } else {
            consumerList = Consumer.createCriteria().list(max: max, sort: sort, order: order) {}
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Consumer consumer : consumerList) {
                if (consumer.playNum == 0) {
                    int consumerPlayNum = PlayedProgram.countByConsumer(consumer);
                    consumer.playNum = consumerPlayNum;
                }
                result.categories.add(consumerName(id: consumer.id));
                result.data.add(consumer.playNum);
            }
        }
        return render(result as JSON);
    }
    /**
     * 用户上传
     * @return
     */
    @ActionNameAnnotation(name = "用户上传排行")
    def userVisitUploadNumStatistics() {
        def sort = "uploadNum";
        if (params.sort) {
            sort = params.sort;
        }
        def max = 10;
        if (params.max) {
            max = params.max;
        }
        def order = "desc";
        if (params.order) {
            order = params.order;
        }
        def offset = 0;
        if (params.offset) {
            offset = params.offset;
        }
        def total = 0;
        def consumerList = Consumer.createCriteria().list(max: max, offset: offset, sort: sort, order: order) {}
        if (consumerList) {
            total = consumerList.totalCount;
        }
        return render(view: 'userVisitUploadNumStatistics', model: [consumerList: consumerList, total: total])
    }
    /**
     * 用户上传报表
     * @return
     */
    @ActionNameAnnotation(name = "用户上传报表")
    def userVisitUploadNumStatisticsForm() {
        def startTimeNum = params.startTime;
        def endTimeNum = params.endTime;
        def sort = "uploadNum";
        def max = 20;
        def order = "desc";
        def consumerList = null;
        def result = [:];
        result.categories = [];     //资源名称
        result.data = [];           //资源返回数据
        if (startTimeNum) {
            //查询起始时间，和结束时间，如果是查询本周，今天，本月，则默认结束时间为当前时间
            def endTime = new Date();
            def startTime = new Date(Long.parseLong(startTimeNum));
            if (endTimeNum) {
                endTime = new Date(Long.parseLong(endTimeNum));
            }
            //统计查询资源数量和资源名称
            List statisticsData = Program.executeQuery("select count(consumer.id)as consumerCount, consumer.id from Program where dateCreated between :startTime and :endTime group by consumer.id order by consumerCount desc", [startTime: startTime, endTime: endTime]);
            for (int i = 0; i < 20 && i < statisticsData.size(); i++) {
                result.data.add(statisticsData[i][0]);
                result.categories.add(consumerName(id: statisticsData[i][1]));
            }
        } else {
            consumerList = Consumer.createCriteria().list(max: max, sort: sort, order: order) {}
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Consumer consumer : consumerList) {
                result.categories.add(consumerName(id: consumer.id));
                if (consumer.uploadNum == 0) {
                    int consumerUploadNum = Program.countByConsumer(consumer);
                    consumer.uploadNum = consumerUploadNum;
                }
                result.data.add(consumer.uploadNum);
            }
        }
        return render(result as JSON);
    }
    /**
     * 用户下载排行
     * @return
     */
    @ActionNameAnnotation(name = "用户下载排行")
    def userVisitDownloadNumStatistics() {
        def sort = "downloadNum";
        if (params.sort) {
            sort = params.sort;
        }
        def max = 10;
        if (params.max) {
            max = params.max;
        }
        def order = "desc";
        if (params.order) {
            order = params.order;
        }
        def offset = 0;
        if (params.offset) {
            offset = params.offset;
        }
        def total = 0;
        def consumerList = Consumer.createCriteria().list(max: max, offset: offset, sort: sort, order: order) {}
        if (consumerList) {
            total = consumerList.totalCount;
        }
        return render(view: 'userVisitDownloadNumStatistics', model: [consumerList: consumerList, total: total])
    }
    /**
     * 用户下载报表
     * @return
     */
    @ActionNameAnnotation(name = "用户下载报表")
    def userVisitDownloadNumStatisticsForm() {
        def startTimeNum = params.startTime;
        def endTimeNum = params.endTime;
        def sort = "downloadNum";
        def max = 20;
        def order = "desc";
        def consumerList = null;
        def result = [:];
        result.categories = [];     //资源名称
        result.data = [];           //资源返回数据
        if (startTimeNum) {
            //查询起始时间，和结束时间，如果是查询本周，今天，本月，则默认结束时间为当前时间
            def endTime = new Date();
            def startTime = new Date(Long.parseLong(startTimeNum));
            if (endTimeNum) {
                endTime = new Date(Long.parseLong(endTimeNum));
            }
            //统计查询资源数量和资源名称
            List statisticsData = DownloadedProgram.executeQuery("select count(consumer.id)as consumerCount, consumer.id from DownloadedProgram where dateCreated between :startTime and :endTime group by consumer.id order by consumerCount desc", [startTime: startTime, endTime: endTime]);
            for (int i = 0; i < 20 && i < statisticsData.size(); i++) {
                result.data.add(statisticsData[i][0]);
                result.categories.add(consumerName(id: statisticsData[i][1]));
            }
        } else {
            consumerList = Consumer.createCriteria().list(max: max, sort: sort, order: order) {}
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Consumer consumer : consumerList) {
                if (consumer.downloadNum == 0) {
                    int consumerDownloadNum = DownloadedProgram.countByConsumer(consumer);
                    consumer.downloadNum = consumerDownloadNum;
                }
                result.categories.add(consumerName(id: consumer.id));
                result.data.add(consumer.downloadNum);
            }
        }
        return render(result as JSON);
    }
    /**
     * 用户收藏排行
     * @return
     */
    @ActionNameAnnotation(name = "用户收藏排行")
    def userVisitCollectNumStatistics() {
        def sort = "collectNum";
        if (params.sort) {
            sort = params.sort;
        }
        def max = 10;
        if (params.max) {
            max = params.max;
        }
        def order = "desc";
        if (params.order) {
            order = params.order;
        }
        def offset = 0;
        if (params.offset) {
            offset = params.offset;
        }
        def total = 0;
        def consumerList = Consumer.createCriteria().list(max: max, offset: offset, sort: sort, order: order) {}
        if (consumerList) {
            total = consumerList.totalCount;
        }
        return render(view: 'userVisitCollectNumStatistics', model: [consumerList: consumerList, total: total])
    }
    /**
     * 用户收藏报表
     * @return
     */
    @ActionNameAnnotation(name = "用户收藏报表")
    def userVisitCollectNumStatisticsForm() {
        def startTimeNum = params.startTime;
        def endTimeNum = params.endTime;
        def sort = "collectNum";
        def max = 20;
        def order = "desc";
        def consumerList = null;
        def result = [:];
        result.categories = [];     //资源名称
        result.data = [];           //资源返回数据
        if (startTimeNum) {
            //查询起始时间，和结束时间，如果是查询本周，今天，本月，则默认结束时间为当前时间
            def endTime = new Date();
            def startTime = new Date(Long.parseLong(startTimeNum));
            if (endTimeNum) {
                endTime = new Date(Long.parseLong(endTimeNum));
            }
            //统计查询资源数量和资源名称
            List statisticsData = CollectedProgram.executeQuery("select count(consumer.id)as consumerCount, consumer.id from CollectedProgram where dateCreated between :startTime and :endTime group by consumer.id order by consumerCount desc", [startTime: startTime, endTime: endTime]);
            for (int i = 0; i < 20 && i < statisticsData.size(); i++) {
                result.data.add(statisticsData[i][0]);
                result.categories.add(consumerName(id: statisticsData[i][1]));
            }
        } else {
            consumerList = Consumer.createCriteria().list(max: max, sort: sort, order: order) {}
            //可以不用循环，直接使用hql语句，查询部分数据，不阿伯整个对象s
            for (Consumer consumer : consumerList) {
                if (consumer.collectNum == 0) {
                    int consumerCollectNum = CollectedProgram.countByConsumer(consumer);
                    consumer.collectNum = consumerCollectNum;
                }
                result.categories.add(consumerName(id: consumer.id));
                result.data.add(consumer.collectNum);
            }
        }
        return render(result as JSON);
    }

    @ActionNameAnnotation(name = "用户访问排行")
    def statisticsUserVisit() {
        if (!params.offset) params.offset = 0
        //用户最后登陆时间排行
        List<Consumer> lastLoginCmrSta = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [max: 10, offset: params.offset, sort: "dateLastLogin", order: "desc"])
        //用户浏览排行
        List<Consumer> viewCmrSta = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [max: 10, offset: params.offset, sort: "viewNum", order: "desc"])
        def total = Consumer.count();
        return render(view: 'statisticsUserVisit', model: [total: total, lastLoginCmrSta: lastLoginCmrSta, viewCmrSta: viewCmrSta]);
    }

    @ActionNameAnnotation(name = "用户最后登录排行导出")
    def userLastloginRanking() {
        def name = "userLastloginRanking"
        def data = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [sort: "dateLastLogin", order: "desc"])
        def fieldName = ['用户账号', '姓名', '登录时间']
        def fieldValue = ['name', 'trueName', 'dateLastLogin']
        def sheetName = "用户最后登录排行"

        programExportService.exportExcel(name, data, fieldName, fieldValue, sheetName, response);
    }

    @ActionNameAnnotation(name = "用户访问排行导出")
    def userVisitRanking() {
        def name = "userVisitRanking"
        def data = Consumer.findAllByRoleGreaterThan(Consumer.MANAGER_ROLE, [sort: "loginNum", order: "desc"])
        def fieldName = ['用户账号', '姓名', '访问数']
        def fieldValue = ['name', 'trueName', 'loginNum']
        def sheetName = "用户访问排行"

        programExportService.exportExcel(name, data, fieldName, fieldValue, sheetName, response);
    }

    @ActionNameAnnotation(name = "资源下载排行导出")
    def programDownloadRanking() {
        def name = "programDownloadRanking"
        def data = Program.findAllByState(Program.PUBLIC_STATE, [sort: "downloadNum", order: "desc"])
        def fieldName = ['资源名称', '所属类库', '上传时间', '下载次数']
        def fieldValue = ['name', 'directory.name', 'dateCreated', 'downloadNum']
        def sheetName = "资源下载排行"

        useApplyService.exportExcel1(name, data, fieldName, fieldValue, sheetName, response);
    }

    @ActionNameAnnotation(name = "资源浏览排行导出")
    def programViewRanking() {
        def name = "programViewRanking"
        def data = Program.findAllByState(Program.PUBLIC_STATE, [sort: "frequency", order: "desc"])
        def fieldName = ['资源名称', '所属类库', '上传时间', '浏览次数']
        def fieldValue = ['name', 'directory.name', 'dateCreated', 'frequency']
        def sheetName = "资源浏览排行"

        useApplyService.exportExcel1(name, data, fieldName, fieldValue, sheetName, response);
    }

    @PatternNameAnnotation(name = "导出Excel或者XMl")
    @ActionNameAnnotation(name = "导出Excel或者XMl")
    def exportExcelorXml() {
        def directoryList = null
        directoryList = Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])
        return render(view: 'exportExcelorXml', model: [directoryList: directoryList, isDescription: '0'])
    }

    @PatternNameAnnotation(name = "导入Excel")
    @ActionNameAnnotation(name = "导入Excel")
    def importExcel() {
        def directoryList = null
        directoryList = Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])
        return render(view: 'importExcel', model: [directoryList: directoryList])
    }

    @ActionNameAnnotation(name = "Excel导入数据库")
    def excelToDatabase() {
        params.servletContext = servletContext;
        params.request = request;
        params.consumer = session.consumer;
        if (programExportService.excelToDataBase(params)) {
            flash.message = "导入成功";
        } else {
            flash.message = "导入失败";
        }

        redirect(action: 'importExcel')
    }

    @ActionNameAnnotation(name = "导出")
    def export() {
        try {
            Map result = programExportService.exportProgram(params, request, response, session);
            flash.message = result.message;
            render(view: "exportExcelorXml", model: result);

        } catch (Exception e) {
            flash.message = e.toString()
            render(view: "exportExcelorXml", model: [directoryList: Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])])
        }
    }
    //上传图片
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

    @PatternNameAnnotation(name = "添加元数据标准")
    @ActionNameAnnotation(name = "添加元数据标准")
    def createDirectory() {
        def id = params.id;
        Directory directory = null;
        if (id) {
            directory = Directory.get(id as Long);
        }
        return render(view: 'createDirectory', model: [directory: directory, editPage: params.editPage])
    }

    @ActionNameAnnotation(name = "目录保存")
    def directorySave() {
        def result = [:];
        result = programMgrService.directorySave(params);
        flash.message = result.message;
        println params.pages
        if (result.success) {
            redirect(action: "showDirectory")
        } else {
            render(view: "directoryList")
        }
    }

    @PatternNameAnnotation(name = "元数据标准列表")
    @ActionNameAnnotation(name = "元数据标准列表")
    def showDirectory() {
        return render(view: 'directoryList', model: [editPage: params.editPage])
    }

    @ActionNameAnnotation(name = "展示所有目录")
    def directoryList() {
    }

    def directoryList2 = {
        params.consumer = session.consumer;
        def result = programMgrService.directoryList(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @ActionNameAnnotation(name = "目录更新")
    def directoryUpdate() {
        def result = [:];
        result = programMgrService.directoryUpdate(params);
        flash.message = result.message;

        if (result.success) {
            redirect(action: "showDirectory", params: [editPage: params.editPage])
        } else {
            redirect(action: "createDirectory", params: [id: params.id, editPage: params.editPage])
        }
    }

    @ActionNameAnnotation(name = "目录删除")
    def directoryDelete() {
        params.consumer = session.consumer;
        def result = programMgrService.directoryDelete(params);
        return render(result as JSON)
    }

    @PatternNameAnnotation(name = "评论列表")
    @ActionNameAnnotation(name = "评论列表")
    def remarkManager() {

    }

    @ActionNameAnnotation(name = "评论管理")
    def remarkList() {
        def result = programMgrService.remarkList(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @ActionNameAnnotation(name = "评论删除")
    def deleteRemark() {
        def result = programMgrService.deleteRemark(params);
        return render(result as JSON)
    }

    @ActionNameAnnotation(name = "评论审批")
    def approveRemark(){
        def result = programMgrService.approveRemark(params);
        return render(result as JSON)
    }


    @PatternNameAnnotation(name = "评论统计")
    @ActionNameAnnotation(name = "评论统计")
    def remarkTotalManager() {

    }

    @ActionNameAnnotation(name = "资源评论排序")
    def remarkSortProgram() {
        def result = programMgrService.remarkSortProgram(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @ActionNameAnnotation(name = "用户评论排序")
    def remarkSortConsumer() {
        def result = programMgrService.remarkSortConsumer(params);
        response.setContentType("text/json");
        return render(result as JSON);
    }

    @PatternNameAnnotation(name = "资源分类管理")
    @ActionNameAnnotation(name = "资源分类管理")
    def programCategoryMgr() {
        Cookie cookie1 = new Cookie("uploadServerAddress", systemConfigService.findUploadServerAddress());
        Cookie cookie2 = new Cookie("uploadServerPort", systemConfigService.findUploadPort().toString());
        response.addCookie(cookie1);
        response.addCookie(cookie2);

        def directoryList = Directory.list([sort: "showOrder", order: "asc"]);
        [directoryList: directoryList]
    }

    def categoryList() {

    }

    @PatternNameAnnotation(name = "资源分类列表")
    @ActionNameAnnotation(name = "资源分类列表")
    def listProgramCategory() {
        def categories = [];
        if (params.pid) {
            categories = ProgramCategory.findAllByParentCategory(ProgramCategory.get(params.pid), [sort: "orderIndex", order: "asc"]);
        } else {
//            categories = ProgramCategory.findAllByParentCategoryIsNull([order: "asc"]);
            categories = ProgramCategory.findAllByParentCategory(ProgramCategory.findByParentCategoryIsNull(), [sort: "orderIndex", order: "asc"]);
        }

        //只加载允许用户管理的
        if(categories.size()>0&&categories[0].level==1){
            Consumer consumer = utilService.getCurrentUser();
            if(consumer.role!=Consumer.SUPER_ROLE){
                Set<ProgramCategory> categorySet = Consumer.findById(consumer.id).programCategorys
                List<ProgramCategory> categoryList2 = categorySet.toList();
                categories.retainAll(categoryList2);
            }
        }

        def result = [];
        categories.each { ProgramCategory category ->
            def tmp = [:];
            tmp.id = category.id;
            tmp.name = category.name;
            tmp.description = category.description;
            tmp.mediaType = category.mediaType;
            tmp.isParent = ProgramCategory.countByParentCategory(category) > 0;
            if (category.parentCategory) {
                tmp.pid = category.parentCategory.id;
            }
            tmp.img = category.img;
            tmp.uploadPath = category.uploadPath;
            tmp.isDisplay = category.isDisplay;
            tmp.orderIndex = category.orderIndex;
            tmp.directoryId = category.directoryId;
            tmp.posterFormatType = category.posterFormatType;
            tmp.defaultProgramPosterHash = category.defaultProgramPosterHash;
            tmp.defaultProgramPosterPath = category.defaultProgramPosterPath;
            result.add(tmp);
        }
        return render(result as JSON);
    }


    def listProgramCategory2() {
        def categories = [];
        if (params.pid) {
            categories = ProgramCategory.findAllByParentCategory(ProgramCategory.get(params.pid), [sort: "orderIndex", order: "asc"]);
        } else {
            categories = ProgramCategory.findAllByParentCategoryIsNull([order: "asc"]);
        }

        //只加载允许用户管理的
        if(categories.size()>0&&categories[0].level==1){
            Consumer consumer = utilService.getCurrentUser();
            if(consumer.role!=Consumer.SUPER_ROLE){
                Set<ProgramCategory> categorySet = Consumer.findById(consumer.id).programCategorys
                List<ProgramCategory> categoryList2 = categorySet.toList();
                categories.retainAll(categoryList2);
            }
        }

        def result = [];
        categories.each { ProgramCategory category ->
            def tmp = [:];
            tmp.id = category.id;
            tmp.name = category.name;
            tmp.description = category.description;
            tmp.mediaType = category.mediaType;
            tmp.isParent = ProgramCategory.countByParentCategory(category) > 0;
            if (category.parentCategory) {
                tmp.pid = category.parentCategory.id;
            }
            tmp.img = category.img;
            tmp.uploadPath = category.uploadPath;
            tmp.isDisplay = category.isDisplay;
            tmp.orderIndex = category.orderIndex;
            tmp.directoryId = category.directoryId;
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

    @ActionNameAnnotation(name = "资源库创建")
    def createProgramCategoryLibrary() {
        def result = programService.createProgramCategoryLibrary(params)
        if (params.returnType && params.returnType.toString().equals("json")) {
            return render(result as JSON);
        }
        if (result.success) {
            return redirect(action: 'programCategoryMgr')
        } else {
            return render(view: 'programCategoryMgr', model: [errorMsg: result.msg]);
        }
    }

    @ActionNameAnnotation(name = "修改资源类型")
    def modifyProgramType() {
        def result = programService.modifyProgramCategory(params)
        if (result.success) {
            return redirect(action: 'programCategoryMgr');
        } else {
            return render(view: 'programCategoryMgr', model: [errorMsg: result.msg]);
        }
    }

    //资源分类库排序修改
    def modifyProgramCategoryOrderIndex() {
        def result = programService.modifyProgramCategoryOrderIndex(params)
        return render(result as JSON);
    }

    //资源分类库显示状态设置
    def modifyProgramCategoryIsDisplay() {
        def result = programService.modifyProgramCategoryIsDisplay(params);
        return render(result as JSON);
    }

    @ActionNameAnnotation(name = "删除资源类型")
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

    @ActionNameAnnotation(name = "同步资源分类")
    def synchronizeProgramCategory() {
        def result = [:];
        try {
            utilService.getServletContext().removeAttribute("categoryTree");
            programCategoryService.syncProgramCategory();
            programCategoryService.syncSubProgramCategory(programCategoryService.querySuperCategory());
            result.success = true;
            result.msg = "分类同步成功!";
        } catch (Exception e) {
            result.success = false;
            result.msg = "分类同步失败!";
        }
        return render(result as JSON);
    }


    @PatternNameAnnotation(name = "元数据管理")
    @ActionNameAnnotation(name = "元数据管理")
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

        return render(view: 'metaDefineList', model: [metaDefineList: metaDefineList, directoryList: directoryList, directoryId: directoryId]);
    }

    @PatternNameAnnotation(name = "添加元数据")
    @ActionNameAnnotation(name = "添加元数据")
    def metaDefineCreate() {
        def directoryList = null
        directoryList = Directory.findAllByParentId(0, [sort: "showOrder", order: "asc"])
        [directoryId: params.directoryId, directoryList: directoryList]
    }

    @ActionNameAnnotation(name = "修改元数据")
    def metaDefineEdit() {
        def directoryList = null
        def metaDefine = MetaDefine.get(params.id)
        if (metaDefine) {
            directoryList = Directory.findAllByParentId(0, [sort: "showOrder", order: "asc"])
            return [metaDefine: metaDefine, directoryList: directoryList, directoryId: params.directoryId]
        } else {
            flash.message = "program not found with id ${params.id}"
            redirect(action: "metaDefineList", params: params)
        }
    }

    @ActionNameAnnotation(name = "删除元数据")
    def metaDefineDelete() {
        params.consumer = session.consumer;
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
            flash.message = "metaDefine not found with id ${params.id}"
        }

        redirect(action: "metaDefineList")
    }

    //修改元数据到数据库
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

                Set keySet = params.keySet();
                for (String key : keySet) {
                    if (key.startsWith("enumId")) {

                    }
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

    @ActionNameAnnotation(name = "同步元数据显示")
    def syncMeta() {
        metaDefineService.creatMetaJs();
        return redirect(action: 'metaDefineList')
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
        writer.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
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
    //检测元数据名称是否已存在
    def checkMetaNameExist = {
        def result = [:];
        def exist = "not exist"
        def metaDefine = MetaDefine.findByName(params.value)

        if (metaDefine && metaDefine.id != params.id.toLong()) exist = "exist"

        result.success = exist.equals("exist")
        return render(result as JSON);
    }

    /**
     * 检测元数据标准名称是否已存在
     */
    def checkDirectoryNameExist = {
        def result = [:];
        def directoryId = params.directoryId;
        def directoryName = params.directoryName;
        def directory = null;
        if (directoryId && directoryId != "") { //修改
            directory = Directory.findAllByNameAndIdNotEqual(directoryName, directoryId as long);
        } else { //创建
            directory = Directory.findAllByName(directoryName);
        }
        if (directory) {
            result.success = true; //已存在
        } else {
            result.success = false; //不存在
        }
        return render(result as JSON);
    }

    @ActionNameAnnotation(name = "资源JSON格式返回")
    def programList3() {

        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "dateCreated";
        if (params.sidx && "directoryName".equals(params.sidx)) {
            sort = "directory"
        }

        if (!params.categoryId) params.categoryId = 1
        ProgramCategory programCategory = null;
        List<ProgramCategory> categoryList = [];
        def categoryIds = [];
        if (params.categoryId) {
            programCategory = ProgramCategory.get(params.categoryId as long);
            if (programCategory.name.equals("默认资源库")) {
                categoryList.add(programCategory);
                categoryIds.add(programCategory.id);
            } else {
                categoryList = programCategoryService.querySubAllCategoryForAdmin(programCategory);
                if (null == categoryList) {
                    categoryList = [];
                } else {
                    categoryList?.each {
                        categoryIds.add(it.id);
                    }
                }
                categoryList.add(programCategory);
                categoryIds.add(programCategory.id);
            }
        }
        // 按分类查询出符合条件的program
        def programIds = [];
        if (categoryList.size() > 0) {
            programIds = Program.createCriteria().list() {
                projections{
                    distinct('id')
                }
                if (programCategory.name == "资源库") {

                }
                if ((categoryList.size() == 1) && (categoryList.get(0).name.equals("默认资源库"))) {
                    or {
                        isEmpty('programCategories')
                        programCategories {
                            eq('id', categoryList.get(0).id)
                        }
                    }
                } else {
                    if (programCategory.name == "资源库") {
                        or {
                            isEmpty('programCategories')
                            programCategories {
                                'in'('id', categoryIds.toArray())
                            }
                            //isNull('programCategory')
                            //inList("programCategory", categoryList)
                        }
                    } else {
                        programCategories {
                            'in'('id', categoryIds.toArray())
                        }
                        //inList("programCategory", categoryList)
                    }
                }
            }
        }

        def programList = null;
        def result = [:];
        if(categoryList.size()>0 && programIds.size()==0) {
            programList = [];

            result.page = 0;
            //总记录数
            result.records = 0;
            //总页数
            result.total = 0;
            result.rows = [];
        } else {
            programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
                if (params.name) {
                    like("name", "%" + params.name.toString().decodeURL() + "%")
                }
                eq("state", Program.PUBLIC_STATE)
                if(programIds && programIds.size()>0) {
                    'in'('id', programIds.toArray())
                }
            }

            def total = programList.totalCount;
            result.page = page;
            //总记录数
            result.records = total;
            //总页数
            result.total = Math.ceil(total * 1.00 / params.max);
            result.rows = [];
            programList.each {
                def tmp = [:];
                tmp.id = it?.id;
                tmp.name = it?.name;
                tmp.directoryName = it?.directory?.name;
                tmp.consumer = it?.consumer?.name;
                tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
                tmp.recommendNum = it?.recommendNum;
                tmp.collectNum = it?.collectNum;
                tmp.frequency = it?.frequency;
                tmp.state = Program.cnState.get(it?.state);
                tmp.canPublic = it?.canPublic;
                result.rows.add(tmp);
            }
        }
        response.setContentType("text/json");
        return render(result as JSON);

    }

    //设置管理端资源是否能点播、下载：操作：canPlay canAllPlay canDownload canAllDownload
    def programCanOperationSet = {
        def result = [:];
        result = programMgrService.programCanOperationSet(params);
        return render(result as JSON)
    }

    @ActionNameAnnotation(name = "字幕列表")
    def editSubtitleList() {
        def id = params.id;
        if (id) {
            Serial serial = Serial.get(id as Long);
            List<Subtitle> subtitleList = serial?.subtitles?.toList();
            subtitleList.sort { subtitle1, subtitle2 ->
                subtitle1.serialNo <=> subtitle2.serialNo
            }
            return render(view: 'editSubtitleList', model: [serial: serial, subtitleList: subtitleList])
        }
    }

    def showRemark() {
        def id = params.id;
        Remark remark
        if (id) {
            remark = Remark.get(id as Long);
            return render(view: 'showRemark', model: [remark: remark])
        }
    }

    @PatternNameAnnotation(name = "分面分类管理")
    @ActionNameAnnotation(name = "分面分类管理")
    def categoryFactedMgr() {

    }

    // 分面列表
    def categoryFactedList() {
        def categoryFacteds = [];
        def result = [:];
        if (params.programCategoryId) {
            def programCategoryId = params.programCategoryId as long;
            def programCategory = ProgramCategory.get(programCategoryId);
            if (programCategory) {
                categoryFacteds = CategoryFacted.findAllByCategory(programCategory, [sort: "orderIndex", order: "asc"]);
            }
            int index = 0;
            def rows = [];
            categoryFacteds.each { CategoryFacted facted ->
                def row = [:];
                row.id = index;
                row.factedId = facted.id;
                row.factedName = facted.name;
                row.level = 0;
                row.isLeaf = false;
                row.expanded = true;
                row.programCategoryId = programCategoryId;
                rows.add(row);
                def parent = index;
                def factedValues = FactedValue.findAllByCategoryFacted(facted);
                if (factedValues && factedValues.size() > 0) {
                    factedValues?.each { FactedValue value ->
                        index = index + 1;
                        row = [:];
                        row.id = index;
                        row.factedId = value.id;
                        row.factedName = value.contentValue;
                        row.level = 1;
                        row.parent = parent;
                        row.isLeaf = true;
                        row.expanded = true;
                        row.programCategoryId = programCategoryId;
                        rows.add(row);
                    }
                } else {
                    row.isLeaf = true;
                }
                index = index + 1;
            }
            result.rows = rows;
        }
        return render(result as JSON);
    }

    // 分面创建
    def createCategoryFacted() {
        def result = programService.createCategoryFacted(params)
        return render(result as JSON);
    }

    // 修改分面名称
    def modifyCategoryFacted() {
        def parent = params.parent;
        def opt = params.opt;
        def result = [:];
        if ("leaf".equals(parent)) {
            //分面值修改
            result = programService.modifyFactedValue(params)
        } else if ("parent".equals(parent)) {
            if ("modify".equals(opt)) {
                //分面修改
                result = programService.modifyCategoryFacted(params);
            } else if ("create".equals(opt)) {
                //分面值创建
                result = programService.createFactedValue(params);
            }
        }
        return render(result as JSON);
    }

    //删除分面或分面值
    def removeCategoryFacted() {
        def parent = params.parent;
        def result = [:];
        if ("leaf".equals(parent)) {
            //分面值修改
            result = programService.removeFactedValue(params)
        } else if ("parent".equals(parent)) {
            //分面修改
            result = programService.removeCategoryFacted(params);
        }
        return render(result as JSON);
    }

    //分面查询
    def queryCategoryFacted() {
        def result = [:];
        result = programService.queryCategoryFacted(params);
        return render(result as JSON);
    }

    // 查询元数据标准和上传路径
    def queryCategoryDirectoryAndUploadPath() {
        def result = [:];
        result = programService.queryCategoryDirectoryAndUploadPath(params);
        return render(result as JSON);
    }

    // 判断所选分类是否属于同一分类库
    def checkProgramCategory() {
        def result = [:];
        result = programService.checkProgramCategory(params);
        return render(result as JSON);
    }

    def sysncTransCode() {
        def result = [:];
        try {
            coreMgrService.syncTranscodeStateJob();
            result.success = true;
        } catch (Exception e) {
            result.success = false;
        }
        return render(result as JSON);
    }

    /**
     * 根据资源id同步资源索引
     * @return
     */
    def syncIndexProgram() {
        def result = [:];
        try {
            def SeniorSearchOpt = SysConfig.findByConfigName('SeniorSearchOpt');
            if(SeniorSearchOpt.configValue == "true") {
                List<Long> ids = new ArrayList<Long>();
                def proIdList = params.idList
                if (proIdList instanceof String) {
                    if (proIdList.contains(',')) {
                        String[] str = proIdList.split(',');
                        str.each {
                            ids.add(Long.parseLong(it));
                        }
                    } else {
                        ids.add(Long.parseLong(proIdList));
                    }
                }
                searchService.indexProgramJobByIds(ids);
                result.success = true;
            } else {
                result.msg = "高级搜索未开启";
                result.success = false;
            }


        } catch (Exception e) {
            println(e.printStackTrace());
            result.msg = "同步失败";
            result.success = false;
        }
        return render(result as JSON);
    }
}
