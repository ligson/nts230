package nts.program.services

import com.boful.common.file.utils.FileUtils
import nts.meta.domain.MetaContent
import nts.meta.domain.MetaDefine
import nts.note.domain.ProgramNote
import nts.program.category.domain.FactedValue
import nts.program.domain.CollectedProgram
import nts.program.domain.CourseAnswer
import nts.program.domain.CourseQuestion
import nts.program.domain.DistributeProgram
import nts.program.domain.DownloadedProgram
import nts.program.domain.PlayedProgram
import nts.program.domain.Program
import nts.program.category.domain.ProgramCategory
import nts.program.domain.ProgramTag
import nts.program.domain.ProgramTopic
import nts.program.domain.RecommendedProgram
import nts.program.domain.RelationProgram
import nts.program.domain.Remark
import nts.program.domain.RemarkReply
import nts.program.domain.Serial
import nts.program.domain.Subtitle
import nts.program.domain.ViewedProgram
import nts.system.domain.Directory
import nts.system.domain.Lang
import nts.system.domain.OperationEnum
import nts.system.domain.OperationLog
import nts.user.domain.College
import nts.user.domain.Consumer
import nts.user.domain.UserGroup
import nts.utils.CTools
import org.codehaus.groovy.grails.web.util.WebUtils

import javax.servlet.http.Cookie
import java.text.SimpleDateFormat

class ProgramMgrService {
    def utilService;
    def systemConfigService;
    def programCategoryService
    def metaDefineService;

    public Map directoryList(Map params) {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "dateCreated";
        List<Directory> directoryList = Directory.list(max: params.max, offset: params.offset, sort: sort, order: order);
        def total = Directory.count();
        result.page = page;
        //总记录数
        result.records = total;
        //总页数
        result.total = Math.ceil(total * 1.00 / params.max);
        result.rows = [];
        directoryList.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.name;
            tmp.showOrder = it.showOrder;
            tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
            tmp.description = it.description;
            result.rows.add(tmp);
        }
        return result
    }

    public Map directoryDelete(Map params) {
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
        if (params.consumer.role == 0) {
            ids.each {
                def directory = Directory.get(it as Long)
                if (directory) {
                    directory.consumers.toList().each {            //手动删除类库与用户的关系
                        it.removeFromDirectorys(directory);
                        directory.removeFromConsumers(it);
                    }

                    directory.programs.toList().each {
                        //删除物理文件
                        deleteFiles(it);
                        //删除资源
                        deleteProgram2(it);
                    }

                    directory.metaDefines.toList().each { MetaDefine metaDefine ->
                        if (metaDefine.dataType == "decorate" || metaDefine.dataType == "decorate2") {
                            MetaDefine.findAllByParentId(metaDefine.id as int).each {
                                it?.directorys?.toList()?.each { Directory directory1 ->
                                    directory1.removeFromMetaDefines(it)
                                }
                                it.delete();
                            }
                        }

                        metaDefine?.directorys?.toList()?.each {
                            it.removeFromMetaDefines(metaDefine)
                        }
                        metaDefine?.metaContents?.toList()?.each {
                            if (it.program) {
                                it.program.removeFromMetaContents(it);
                            }
                            it.delete();
                            metaDefine.removeFromMetaContents(it);
                        }

                        metaDefine.delete();
                    }
                    directory.delete(flush: true);                                //再进行删除类库
                    result.success = true;
                    result.msg = "元数据标准删除完成"

                } else {
                    result.success = false;
                    result.msg = "nts.system.domain.Directory not found with id ${it}"
                }
            }

        } else {
            result.success = false;
            result.msg = "只在超级管理员才可删除";
        }
        return result
    }

    public Map remarkList(Map params) {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "dateCreated";
        List<Remark> remarkList = Remark.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order){
            if(params.approveState == "true"){
                eq("isPass", true);
            } else if(params.approveState == "false"){
                eq("isPass", false);
            }
        };
        def total = Remark.count();
        result.page = page;
        //总记录数
        result.records = total;
        //总页数
        result.total = Math.ceil(total * 1.00 / params.max);
        result.rows = [];
        remarkList.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.topic;
            tmp.program = it.program.name;
            tmp.programId = it.program.id;
            tmp.consumer = it.consumer.name;
            tmp.rank = it.rank;
            tmp.replyNum = it.remarkReplys.size();
            tmp.isPass = it.isPass;
            tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
            result.rows.add(tmp);
        }
        return result
    }

    /**
     * 评论审批
     * @param params
     * @return
     */
    public Map approveRemark(Map params){
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
            Remark remark = Remark.get(it as Long);
            if (remark) {
                remark.isPass = true;
                if(remark.save(flush: true)){
                    result.success = true;
                    result.msg = "审批成功";
                } else {
                    result.success = false;
                    result.msg = "审批失败";
                }
            } else {
                result.success = false;
                result.msg = "审批失败";
            }
        }
        return result
    }

    public Map deleteRemark(Map params) {
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
        ids?.each {
            Remark remark = Remark.get(it as Long);
            if (remark) {
                Program program = Program.get(remark.program.id);
                program.removeFromRemarks(remark);
                program.remarkNum = program?.remarks.size();
                program.save();
                remark.program = null;
                remark.delete();
                result.success = true;
                result.msg = "删除成功";
            } else {
                result.success = false;
                result.msg = "删除失败";
            }
        }
        return result
    }

    public Map remarkSortProgram(Map params) {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "id";
        List<Remark> remarkList = Remark.list();
        List<Program> programList = [];
        List ids = Program.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            projections {
                distinct('id')
            }
            remarks {
                inList('id', remarkList.id)
            }
        }
        ids.each {
            programList.add(Program.get(it));
        }
        def total = Program.createCriteria().list() {
            projections {
                distinct('id')
            }
            remarks {
                inList('id', remarkList.id)
            }
        }.size();
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
            tmp.replyNum = it.remarks.size();
            result.rows.add(tmp);
        }
        return result
    }

    public Map remarkSortConsumer(Map params) {
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "id";
        def remarkList = Remark.list();
        List<Consumer> consumerList = [];
        List ids = Consumer.createCriteria().list(max: params.max, offset: params.offset, sort: sort, order: order) {
            projections {
                distinct('id')
            }
            remarks {
                inList('id', remarkList.id)
            }
        }
        ids.each {
            consumerList.add(Consumer.get(it));
        }
        def total = Consumer.createCriteria().list() {
            projections {
                distinct('id')
            }
            remarks {
                inList('id', remarkList.id)
            }
        }.size();
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
            tmp.replyNum = it.remarks.size();
            result.rows.add(tmp);
        }
        return result
    }

    public Map metaDefineList(Map params) {
        def result = [:];
        if (!params.max) params.max = 15
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "id";
        List<MetaDefine> metaDefineList = MetaDefine.list(max: params.max, offset: params.offset, sort: sort, order: order);
        def total = MetaDefine.count();
        result.page = page;
        //总记录数
        result.records = total;
        //总页数
        result.total = Math.ceil(total * 1.00 / params.max);
        result.rows = [];
        metaDefineList.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.name;
            tmp.showOrder = it.showOrder;
            tmp.cnName = it.cnName;
            tmp.dataType = MetaDefine.dataTypeMap.get(it.dataType);
            tmp.directory = it.directorys;
            result.rows.add(tmp);
        }
        return result
    }
    /**
     * 资源状态修改
     * @param params
     * @return
     */
    public Map programStateSet(Map params) {
        def result = [:];
        def bAuthOK = true    //是否认证通过
        def idList = params.idList
        def applyState = CTools.nullToOne(params.applyState)
        def operation = CTools.nullToBlank(params.operation)
        def session = utilService.getSession();
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        List<String> stateName = new ArrayList<String>();
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

        ids?.each { String id ->
            def program = Program.get(id as long)
            //权限待调整,管理员才能审批发布
            if (program) {
                bAuthOK = (applyState <= Program.APPLY_STATE && program.consumer.id == session.consumer.id) || (session.consumer.role <= Consumer.MANAGER_ROLE)
                if (bAuthOK) {
                    //生成操作日志
                    if (program.state == Program.APPLY_STATE && applyState == Program.PUBLIC_STATE) new OperationLog(operation: OperationEnum.APPROVAL_PROGRAM, tableName: 'program', tableId: program.id, brief: program.name, operator: session.consumer.name, operatorId: session.consumer.id).save()

                    //还原
                    if (operation == "restore") {
                        //program.state = Math.abs(program?.state)
                        program.state = Program.NO_APPLY_STATE
                    }
                    //审批通过
                    else if (operation == "pass") {
                        //只通过待审批状态的资源,还有未审批未通过的资源
                        if (program.state == Program.APPLY_STATE || program.state == Program.NO_PASS_STATE) program.state = Program.PUBLIC_STATE;
                    }
                    //审批不通过(退回)
                    else if (operation == "noPass") {
                        //只退回待审批状态的资源
                        if (program.state == Program.APPLY_STATE) program.state = Program.NO_PASS_STATE
                    }
                    //发布
                    else if (operation == "public") {
                        //只发布关闭状态(不发布)的资源
                        if (program.state == Program.CLOSE_STATE) program.state = Program.PUBLIC_STATE
                    }
                    //取消发布
                    else if (operation == "close") {
                        //只取消已发布的资源
                        if (program.state == Program.PUBLIC_STATE) program.state = Program.CLOSE_STATE
                    }
                    //申请入库
                    else if (operation == "apply") {
                        //只申请尚未申请的资源
                        if (program.state < Program.APPLY_STATE) program.state = Program.APPLY_STATE
                    }
                    //没有操作参数，直接设置状态
                    else {
                        program.state = applyState
                    }
                    stateName.add(Program.cnState.get(program.state))
                    result.message = "操作成功";
                    result.success = true;
                    new OperationLog(tableName: 'program', tableId: program.id, operator: params.consumer.name, operatorIP: params.request.getRemoteAddr(),
                            modelName: '审批资源', brief: program.name, operatorId: params.consumer.id, operation: OperationEnum.APPROVAL_PROGRAM).save(flush: true)
                } else {
                    result.message = "Operation is forbidden"
                    result.success = false;
                }
            } else {
                result.message = "program not found with id ${id}";
                result.success = false;
            }
        }
        result.stateName = stateName;
        return result;
    }
    /**
     * 更改公开状态
     * @param params
     * @return
     */
    public Map changePublicStata(Map params) {
        def result = [:];
        def bAuthOK = true    //是否认证通过
        def idList = params.idList
        def operation = CTools.nullToBlank(params.operation)
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
        if (operation == "changePublic") {
            ids?.each { String id ->
                def program = Program.get(id as long)
                if (program) {
                    if (bAuthOK) {
                        program.canPublic = true;
                        program.save(flash: true);
                        result.message = "操作成功";
                        result.success = true;
                        new OperationLog(tableName: 'program', tableId: program.id, operator: params.consumer.name, operatorIP: params.request.getRemoteAddr(),
                                modelName: '审批资源', brief: program.name, operatorId: params.consumer.id, operation: OperationEnum.APPROVAL_PROGRAM).save(flush: true)
                    } else {
                        result.message = "Operation is forbidden"
                        result.success = false;
                    }
                } else {
                    result.message = "program not found with id ${id}";
                    result.success = false;
                }
            }
            result.publicstatic = "是";
        }
        if (operation == "changeNotPublic") {
            ids?.each { String id ->
                def program = Program.get(id as long)
                if (program) {
                    if (bAuthOK) {
                        program.canPublic = false;
                        program.save(flash: true);
                        result.message = "操作成功";
                        result.success = true;
                        new OperationLog(tableName: 'program', tableId: program.id, operator: params.consumer.name, operatorIP: params.request.getRemoteAddr(),
                                modelName: '审批资源', brief: program.name, operatorId: params.consumer.id, operation: OperationEnum.APPROVAL_PROGRAM).save(flush: true)
                    } else {
                        result.message = "Operation is forbidden"
                        result.success = false;
                    }
                } else {
                    result.message = "program not found with id ${id}";
                    result.success = false;
                }
            }
            result.publicstatic = "否";
        }
        return result;
    }
    /**
     * 资源删除
     * @param params
     * @return
     */
    public Map deleteProgram(Map params) {
        def result = [:];
        def programList = null
        def session = utilService.getSession();
        def bAuthOK = true
        def isFromRecycler = false
        def delIdList = params.idList
        def operation = CTools.nullToBlank(params.operation)
        List<Long> ids = new ArrayList<Long>();
        //如果只选中一条记录，其为字符串，collect 会分其为单个字符
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

        /*delIdList = [params.idList.toLong()]
    else
        delIdList = params.idList.collect { elem -> elem.toLong() }*/

        isFromRecycler = (params.fromModel == 'myRecycler' || params.fromModel == 'programMgrRecycler')

        //删除来源于回收站且（删除ID不为空或者是清空回收站操作）
        //if (isFromRecycler && ((delIdList && delIdList.size() > 0) || operation == 'clearRecycler')) {

        if (operation == 'directoryDelete') {
            programList = Program.createCriteria().list() {
                inList('id', ids)
            }
        } else {
            //查询条件
            programList = Program.createCriteria().list {
                //如果是清空回收站操作
                if (operation == 'clearRecycler') {
                    //来自管理端回收站
                    if (params.fromModel == 'programMgrRecycler') {
                        //清空已处于回收站的入库资源
                        lt("state", -Program.APPLY_STATE)
                    }
                    //来自个人空间回收站
                    else {
                        //清空已处于回收站的未入库且是本人的资源
                        ge("state", -Program.APPLY_STATE)
                        lt("state", 0)
                        eq("consumer", session.consumer)
                    }

                }
                //是删除选中操作
                else {
                    //删除已处于回收站的资源
                    'in'("id", ids)
                    lt("state", 0)
                }

            }
        }
        //为了安全一个一个删除
        if (programList.size() > 0) {
            programList?.each { program ->
                if (program) {
                    //防止恶意用户恶意删除
                    bAuthOK = (params.consumer.role <= Consumer.MANAGER_ROLE) || (program.state <= 0 && program.state >= -Program.APPLY_STATE && program.consumer.id == params.consumer.id)
                    if (bAuthOK) {

                        //删除相关
                        /* program.relationPrograms.toList().each { rProgram ->
                              program.removeFromRelationPrograms(rProgram);
                              rProgram.removeFromRelationPrograms(program);
                              rProgram.delete(flush: true);
                          }
                          program.remarks.toList().each { remark ->
                              program.removeFromRemarks(remark);
                              remark.delete(flush: true);
                          }
                          program.collectedPrograms.toList().each { collected ->
                              program.removeFromCollectedPrograms(collected);
                              collected.delete(flush: true);
                          }
                          program.downloadedPrograms.toList().each { downloadProgram ->
                              program.removeFromDownloadedPrograms(downloadProgram);
                              downloadProgram.delete(flush: true);
                          }
                          program.playedPrograms.toList().each { played ->
                              program.removeFromPlayedPrograms(played);
                              played.delete(flush: true);
                          }
                          program.viewedPrograms.toList().each { viewedProgram ->
                              program.removeFromViewedPrograms(viewedProgram);
                              viewedProgram.delete(flush: true);
                          }
                          program.recommendedPrograms.toList().each { recommend ->
                              program.removeFromRecommendedPrograms(recommend);
                              recommend.delete(flush: true);
                          }
                          program.metaContents.toList().each { metaContent ->
                              //program.removeFromMetaContents(metaContent);
                              program.metaContents.remove(metaContent)
                          }
                          program.playGroups.toList().each { playGroup ->
                              program.removeFromPlayGroups(playGroup);
                              playGroup.delete(flush: true);
                          }
                          program.downloadGroups.toList().each { downloadGroup ->
                              program.removeFromDownloadGroups(downloadGroup);
                              downloadGroup.delete(flush: true);
                          }
                          program.programTopics.toList().each { programTopic ->
                              program.removeFromProgramTopics(programTopic);
                              programTopic.delete(flush: true);
                          }
                          program.distributePrograms.toList().each { distribute ->
                              program.removeFromDistributePrograms(distribute);
                              distribute.delete(flush: true);
                          }
                          program.programTags.toList().each {tag ->
                              program.removeFromProgramTags(tag);
                              tag.removeFromPrograms(program);
                              tag.delete(flush: true);
                          }
                          List<ProgramNote> notes = ProgramNote.findAllByProgram(program);
                          notes.each { programNote ->
                              if(programNote.noteRecommends.size()>0){
                                  programNote.noteRecommends.each { noteRecommend ->
                                      programNote.removeFromNoteRecommends(noteRecommend);
                                      noteRecommend.delete(flush: true);
                                  };
                              }

                              programNote.delete(flush: true);
                          }
                          List<CourseQuestion> questions = CourseQuestion.findAllByCourse(program);
                          questions.each { question ->
                              if(question.answer.size()>0){
                                  question.answer.each {answer ->
                                      question.removeFromAnswer(answer);
                                      answer.delete(flush: true);
                                  }
                              }
                              question.delete(flush: true);
                          }
                          program.serials.toList().each {serial ->
                              program.removeFromSerials(serial);
                              serial.delete(flush: true);
                          }*/

                        //删除物理文件
                        //deleteFiles(program);
                        deleteProgram2(program);
                        //删除数据库中记录
                        program.delete(flush: true);
                        result.success = true;
                        //生成操作日志
                        new OperationLog(operation: OperationEnum.DELETE_PROGRAM, modelName: OperationEnum.cnType[OperationEnum.DELETE_PROGRAM.id], tableName: 'program', tableId: program.id, brief: "删除回收站资源：" + program.name, operator: params.consumer.name, operatorId: params.consumer.id).save(flush: true)
                    } else {
                        result.message = "操作被禁止！";
                        result.success = false;
                    }
                } else {
                    result.message = "program not found with id ${program.id}";
                    result.success = false;
                }
            }
        } else {
            result.message = "参数不全,无法删除！";
            result.success = false;
        }

        return result;
    }


    public void deleteProgram2(Program program) {
        //delete notes
        deleteProgramNote(program);
        //detele programTags
        deleteProgramTag(program)
        //delete courseQuestion
        deleteCourseQuestion(program)
        //delete meta
        deleteProgramMetaContent(program);
        //delete remark
        deleteRemark(program);
        //collecton program
        deleteCollectionProgram(program)
        //downlaod program
        program.playedPrograms.toList().each { PlayedProgram playedProgram ->
            Consumer consumer = Consumer.get(playedProgram.consumer.id)
            consumer.playedPrograms.remove(playedProgram)
            consumer.save(flush: true)
            program.playedPrograms.remove(playedProgram)
            program.save(flush: true)
            playedProgram.delete()
        }
        program.downloadedPrograms.toList().each { DownloadedProgram downloadedProgram ->
            Consumer consumer = Consumer.get(downloadedProgram.consumer.id)
            consumer.downloadedPrograms.remove(downloadedProgram)
            consumer.save(flush: true)
            program.downloadedPrograms.remove(downloadedProgram)
            program.save(flush: true)
            downloadedProgram.delete()
        }
        //viewprogram
        program.viewedPrograms.toList().each { ViewedProgram viewedProgram ->
            Consumer consumer = Consumer.get(viewedProgram.consumer.id)
            consumer.viewedPrograms.remove(viewedProgram)
            consumer.save(flush: true)
            program.viewedPrograms.remove(viewedProgram)
            program.save(flush: true)
            viewedProgram.delete()
        }
        //
        program.recommendedPrograms.toList().each { RecommendedProgram recommendedProgram ->
            Consumer consumer = Consumer.get(recommendedProgram.consumer.id)
            consumer.recommendedPrograms.remove(recommendedProgram)
            consumer.save(flush: true)
            program.recommendedPrograms.remove(recommendedProgram)
            program.save(flush: true)
            recommendedProgram.delete()
        }
        program.relationPrograms.toList().each { RelationProgram relationProgram ->
            program.relationPrograms.remove(relationProgram)
            program.save(flush: true)
            relationProgram.delete()
        }
        program.playGroups.toList().each { UserGroup userGroup ->
            Consumer consumer = Consumer.get(userGroup.consumer)
            consumer.userGroups.remove(userGroup)
            consumer.save(flush: true)
            userGroup.playPrograms.remove(program)
            userGroup.save(flush: true)
            userGroup.downloadPrograms.remove(program)
            userGroup.save(flush: true);
            program.playGroups.remove(userGroup)
            program.save(flush: true)
            /*userGroup.delete()*/
        }
        program.downloadGroups.toList().each { UserGroup userGroup ->
            Consumer consumer = Consumer.get(userGroup.consumer)
            consumer.userGroups.remove(userGroup)
            consumer.save(flush: true)
            userGroup.playPrograms.remove(program)
            userGroup.save(flush: true)
            userGroup.downloadPrograms.remove(program)
            userGroup.save(flush: true);
            program.downloadGroups.remove(userGroup)
            program.save(flush: true)
            /*userGroup.delete()*/
        }

        program.programTopics.toList().each { ProgramTopic programTopic ->
            programTopic.programs.remove(program)
            programTopic.save(flush: true);
            program.programTopics.remove(programTopic)
            program.save(flush: true)
            programTopic.delete()
        }

        program.distributePrograms.toList().each { DistributeProgram distributeProgram ->
            distributeProgram.delete();
            program.distributePrograms.remove(distributeProgram)
            program.save(flush: true)
            distributeProgram.delete()
        }

        List<Serial> serialList = program.serials.toList();
        Consumer consumer = Consumer.get(program.consumer.id);
        serialList.each { Serial serial ->
            if (serial.subtitles.toList().size() > 0) {
                serial.subtitles.toList()?.each { Subtitle subtitle ->
                    subtitle.delete()
                    serial.removeFromSubtitles(subtitle);
                    subtitle.save(flush: true)
                }
            }
            if(serial.fileSize) {
                consumer.useSpaceSize = consumer.useSpaceSize.longValue() - serial.fileSize.longValue();
            }
            program.serials.remove(serial)
            program.save(flush: true);
            serial.delete()
        }
        consumer.save();
    }

    public void deleteProgramNote(Program program) {
        def notes = ProgramNote.findAllByProgram(program);
        notes.each { programNote ->
            if (programNote.noteRecommends.size() > 0) {
                programNote.noteRecommends.toList().each { noteRecommend ->
                    programNote.removeFromNoteRecommends(noteRecommend);
                    noteRecommend.delete();
                };
            }

            programNote.delete();
        }
    }

    public void deleteCollectionProgram(Program program) {
        program.collectedPrograms.toList().each { CollectedProgram collectedProgram ->
            Consumer consumer = Consumer.get(collectedProgram.consumer.id);
            consumer.collectedPrograms.remove(collectedProgram);
            consumer.save()
            program.collectedPrograms.remove(collectedProgram);
            program.save();
            collectedProgram.delete();
        }
    }

    public void deleteRemark(Program program) {
        program.remarks.toList().each { Remark remark ->
            remark.remarkReplys.each { RemarkReply remarkReply ->
                remarkReply.delete()
            }
            Consumer consumer = Consumer.get(remark.consumer.id);
            consumer.remarks.remove(remark)
            // consumer.save(flush: true);
            program.remarks.remove(remark)
//            program.save(flush: true);
            remark.delete();
        }
    }

    public void deleteCourseQuestion(Program program) {
        //delte ask
        /* def courses = CourseQuestion.findAllByCourse(program);
         courses.answer.each {CourseAnswer courseAnswer->
             deleteCourseAsk(courseAnswer)
         }
         courses.each{CourseQuestion courseQuestion->
             courseQuestion.delete();
         }*/
        List<CourseQuestion> questions = CourseQuestion.findAllByCourse(program);
        questions.toList().each { question ->
            if (question.answer.size() > 0) {
                question.answer.toList().each { answer ->
                    question.removeFromAnswer(answer);
                    answer.delete();
                }
            }
            question.delete();
        }
    }

    public void deleteCourseAsk(CourseAnswer courseAnswer) {
        //
    }

    public void deleteProgramTag(Program program) {
        def programTags = program.programTags;
        if (programTags.size() > 0) {
            programTags.clear();
            program.save(flush: true);
            def programTags2 = ProgramTag.list();
            programTags2.toList().each { ProgramTag programTag ->
                if (programTag.programs.contains(program)) {
                    programTag.programs.remove(program)
                    programTag.save(flush: true);
                    if (programTag.programs.size() == 1) {
                        programTag.delete()
                    }
                }
            }
        }

    }

    public void deleteProgramMetaContent(Program program) {
        List<MetaContent> metaContentList = MetaContent.findAllByProgram(program)
        for (MetaContent metaContent : metaContentList) {
            MetaDefine metaDefine = MetaDefine.get(metaContent.metaDefine.id);
            metaDefine.metaContents.remove(metaContent);
            metaDefine.directorys.remove(program.classLib);
            program.metaContents.remove(metaContent);
            metaDefine.save(flush: true)
            program.save(flush: true);
            metaContent.delete()
        }
    }
    /**
     * 添加修改子目
     * @param params
     * @return
     */
    public Map operateSerial(Map params) {
        def result = [:];
        result.success = true;
        def session = utilService.getSession();
        def program = null
        def serial = null
        def programId = CTools.nullToZero(params.programId)
        def oldSerialNo = CTools.nullToZero(params.oldSerialNo)//原来的 serialNo,因为可以改serialNo
        def urlType = CTools.nullToZero(params.urlType)
        def oldUrlType = CTools.nullToZero(params.oldUrlType)
        def posterPath;
        def posterHash;
        def posterType;
        if (params.photo) {
            File poster = new File(params.photo);
            posterPath = poster.getAbsolutePath();
            posterHash = FileUtils.getFilePrefix(poster.getName());
            posterType = FileUtils.getFileSufix(poster.getName());
        }

        //如果是修改资源
        if (programId > 0) {
            program = Program.get(programId)
            program.posterPath = posterPath;
            program.posterHash = posterHash;
            program.posterType = posterType;
            program.save(flush: true);
        } else {
            program = session.program
        }

        //如果是修改子目
        if (params.operation == "edit") {
            serial = findSerial(program, "serialNo", oldSerialNo, oldUrlType)
            if (!serial) {
                result.success = false;
                result.message = "serial not found with serialNo ${oldSerialNo}"
            } else {
                serial.properties = params
                //println params.urlType
                serial.save(flush: true);
            }
        } else {//如果是添加子目
            serial = new Serial(params)
            serial.dateModified = new Date()
            program.addToSerials(serial)
        }
        return result;
    }
    /**
     * 资源修改
     * @param params
     * @return
     */
    public Map programUpdate(Map params) {
        def result = [:];
        result.message = "";
        result.success = false;
        def session = utilService.getSession();
        def program = Program.get(params.id)
        if (program && (program.consumer.id == session.consumer?.id || session.consumer?.role <= Consumer.MANAGER_ROLE)) {
            if (!params.canDownload) params.canDownload = false
            if (program.state >= Program.CLOSE_STATE && !params.state) params.state = program.state
            if (!params.canDistribute) params.canDistribute = false
            if (!params.canUnion) params.canUnion = false
            if (!params.canPublic) params.canPublic = false

            //防止用户自己恶意审批：管理员才能修改审批状态
            if (session.consumer?.role > Consumer.MANAGER_ROLE) params?.state = program.state

            program.properties = params

            program.dateModified = new Date()
            program.nowVersion++

            def descOpt = CTools.nullToZero(params.descOpt)
            program.description = descOpt > 0 ? params.description1 : params.description0

            //设置其它选项
            //def otherOption = 0;
            //params.otherOptionList.each {
            //    otherOption += nts.utils.CTools.nullToZero(it)
            //}

            //if (descOpt == 1) otherOption += nts.program.domain.Program.RICH_TEXT_OPTION
            //program.otherOption = otherOption

            //设置资源类型
            //def serialType = nts.utils.CTools.nullToZero(params.serialType)
            //program.otherOption += serialType;
            if (params.otherOption == '8') {
                program.otherOption = Program.ONLY_TXT_OPTION
            } else if (params.otherOption == '16') {
                program.otherOption = Program.ONLY_IMG_OPTION
            } else if (params.otherOption == '32') {
                program.otherOption = Program.ONLY_LINK_OPTION
            } else if (params.otherOption == '128') {
                program.otherOption = Program.ONLY_LESSION_OPTION
            } else {
                program.otherOption = 0
            }

            if (categoryId) {
                String[] categoryIds = categoryId.split(",");
                categoryIds?.each {
                    def programCategory = ProgramCategory.get(it as long);
                    program.addToProgramCategories(programCategory);
                }
            } else {
                //默认资源库
                ProgramCategory programCategory = ProgramCategory.findByName("默认资源库");
                program.addToProgramCategories(programCategory);
            }
            if (params.categoryId) {
                String[] categoryIds = params.categoryId.split(",");
                categoryIds?.each {
                    def programCategory = ProgramCategory.get(it as long);
                    if (programCategory) {
                        program.addToProgramCategories(programCategory);
                    } else {
                        programCategory = ProgramCategory.findByLevelAndMediaType(2, 0);
                        program.addToProgramCategories(programCategory);
                    }

                }
            }
            //设置限制范围
            /*def limitRange = 2;
            params.limitRangeList.each {
                limitRange *= nts.utils.CTools.nullToOne(it)
            }
            //println limitRange
            program.limitRange = limitRange*/

            //元数据
            //dealMetaData.call(program, params)

            //删除以前存在的标签关联，因为关联表没有自增字段，id不会偏大
            program.programTags.toList().each {
                it.removeFromPrograms(program)
            }

            //poster
            if (params.posterFile) {
                /*CommonsMultipartFile multipartFile = params.posterFile;
                File posterRoot = new File(com.boful.nts.utils.SystemConfig.webRootDir, "upload/posters");
                if (!posterRoot.exists()) {
                    posterRoot.mkdirs();
                }
                String sufix = FileUtils.getFileSufix(multipartFile.originalFilename);
                File tempFile = File.createTempFile(new Date().getTime() as String, sufix);
                multipartFile.transferTo(tempFile);
                String hash = FileUtils.getHexHash(tempFile);
                File dest = new File(posterRoot, hash + "." + sufix);
                if (!dest.exists()) {
                    if (dest.createNewFile()) {
                        FileUtils.copyFile(tempFile.getAbsolutePath(), dest.getAbsolutePath());
                    }
                }
                if (StringUtils.isNotBlank(dest.getAbsolutePath()) && StringUtils.isNotBlank(sufix) && StringUtils.isNotBlank(hash)) {
                    program.posterPath = dest.getAbsolutePath();
                    program.posterType = sufix;
                    program.posterHash = hash;
                }*/
                File file = new File(params.posterFile)
                program.posterPath = file.getAbsolutePath();
                program.posterType = FileUtils.getFileSufix(file.getName());
                program.posterHash = FileUtils.getFilePrefix(file.getName());

            }
            def curTag
            params.programTag.each { val ->
                if (val != "") {
                    curTag = ProgramTag.findByName(val)
                    if (curTag) {
                        program.addToProgramTags(curTag)
                    } else {
                        if (ProgramTag.countByName(val) == 0) {
                            program.addToProgramTags(new ProgramTag(
                                    name: val,
                                    dateModified: new Date()
                            ))
                        }
                    }
                }
            }

            //设置子资源数
            program.serialNum = program.serials.size()

            if (program.save()) {
                //生成操作日志
                new OperationLog(operation: OperationEnum.EDIT_PROGRAM, tableName: 'program', tableId: program.id, brief: program.name, operator: session.consumer.name, operatorId: session.consumer.id).save()

                //设置DistributeProgram表中state=1(已分发)的为2(更新)
                DistributeProgram.executeUpdate("update nts.program.domain.DistributeProgram a set a.state=${DistributeProgram.STATE_UPDATE} where a.program=? and a.state=?", [program, DistributeProgram.STATE_DISTRIBUTED])

                //设置DistributeProgram表中isSendObject(已分发的不更新)
                DistributeProgram.executeUpdate("update nts.program.domain.DistributeProgram a set a.isSendObject=${(program.otherOption & Program.REAP_OBJ_OPTION) == Program.REAP_OBJ_OPTION} where a.program=?", [program])

                //此处直接传params可能太大，故麻烦点一个一个写提高效率
                result.message = "资源修改成功。"
                result.success = true;
                //redirect(controller:"my",action:"manageProgram",params:[schState:params.schState,schType:params.schType,schWord:params.schWord,max:params.max,offset:params.offset,sort:params.sort,order:params.order,fromModel:params.fromModel,directoryId:params.directoryId])
            } else {
                result.success = false;
                result.program = program;
            }
        } else {
            result.notFind = true;
            result.message = "nts.program.domain.Program not found with id ${params.id}"
        }
        return result;
    }
    /**
     * 编辑资源元数据信息
     * @param params
     * @return
     */
    public Map dealMetaData(Map params) {
        def result = [:];
        def servletContext = utilService.getServletContext();
        def session = utilService.getSession();
        def metaDefine = null
        def metaContent = null
        def metaTitleId = servletContext.metaTitleId
        def metaCreatorId = servletContext.metaCreatorId

        def metaId = 0
        def content = ''
        def numContentList = []
        def strContentList = []
        def titleMap = new TreeMap()
        def creatorMap = new TreeMap()
        def metaContentList = null //资源修改时原来的meteContent记录数
        def contentCount = 0 //表单提交的meteContent记数

        def program = Program.get(params.id)
        if (program && (program.consumer.id == session.consumer?.id || session.consumer?.role <= Consumer.MANAGER_ROLE)) {
            metaContentList = program.metaContents.toList()

            Object key = null
            Object value = null
            Iterator iterater = params.keySet().iterator()
            while (iterater.hasNext()) {
                content = ''
                numContentList = null
                key = iterater.next()
                if (key.startsWith('id_')) {
                    value = params.get(key)
                    if (value instanceof String)
                        content = value
                    else
                        value.each { content += "${it};" }
                    if (content != '') {
                        metaId = key.substring(3).toLong()
                        metaDefine = MetaDefine.get(metaId)
                        if (metaDefine && metaDefine.dataType != 'decorate') {
                            if (MetaContent.numDataTypes.contains(metaDefine.dataType)) {
                                //数字类型，分开，比如跨学科:1;2
                                numContentList = content.tokenize(';').unique()//content.toInteger()
                                numContentList.eachWithIndex { elem, i ->
                                    strContentList[i] = ''
                                }
                            } else {
                                numContentList = [0]
                                strContentList = [content]
                            }

                            numContentList.eachWithIndex { elem, i ->
                                if (metaContentList != null && contentCount < metaContentList.size()) {
                                    metaContent = metaContentList[contentCount]
                                    metaContent.numContent = CTools.nullToZero(numContentList[i])
                                    metaContent.strContent = CTools.nullToBlank(strContentList[i])
                                    metaContent.metaDefine = metaDefine
                                } else {
                                    program.addToMetaContents(new MetaContent(
                                            numContent: CTools.nullToZero(numContentList[i]),
                                            strContent: CTools.nullToBlank(strContentList[i]),
                                            metaDefine: metaDefine
                                    ))
                                }

                                contentCount++
                            }


                        }
                    }
                }
            }//while(iterater.hasNext())

            //program.name = titleMap.values().asList().join(';')
            //program.actor = creatorMap.values().asList().join(';')

            if (metaContentList != null && contentCount < metaContentList.size()) {
                metaContentList[contentCount..<metaContentList.size()].each {
                    //it.delete()
                    //program.removeFromMetaContents(it)
                    //metaDefine.removeFromMetaContents(it)
                    MetaContent.executeUpdate("delete nts.meta.domain.MetaContent a where a.id=?", [it.id])
                }
            }

            result.message = "元数据信息修改成功。"
        } else {
            result.message = "nts.program.domain.Program not found or not allowed with id ${params.id}"
        }
        return result;
    }
    /**
     * 资源编辑显示
     * @param params
     * @return
     */
    public Map programEdit(Map params) {
        def result = [:];
        result.success = false;
        def session = utilService.getSession();
        def program = Program.get(params.id)
        def relationProgramList = null
        def groupList = null
        def classLibId = 0
        def directoryList = null
        boolean isRichText = false

        if (program && (program.consumer.id == session.consumer?.id || session.consumer?.role <= Consumer.MANAGER_ROLE)) {
            classLibId = program.classLib.id
            groupList = UserGroup.list()
            directoryList = Consumer.get(session.consumer.id).directorys

            //管理员，未具体设置库的（默认） 能上传到所有库
            if (session.consumer.role < Consumer.MANAGER_ROLE || directoryList == null || directoryList.size() < 1) {
                directoryList = Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])
            }

            isRichText = (program.otherOption & Program.RICH_TEXT_OPTION) == Program.RICH_TEXT_OPTION
            result.program = program;
            result.groupList = groupList;
            result.directoryList = directoryList;
            result.operation = 'edit';
            result.classLibId = classLibId;
            result.isRichText = isRichText;
            result.params = params;
            result.success = true;
        } else {
            result.message = "program not found with id ${params.id}"
            result.success = false;
        }
        return result;
    }
    /**
     * 字幕编辑
     * @param params
     * @return
     */
    public Map editSubtitle(Map params) {
        def result = [:];
        def session = utilService.getSession();
        def programId = CTools.nullToZero(params.programId)
        def serialId = CTools.nullToZero(params.serialId)
        def serialNo = CTools.nullToZero(params.serialNo)
        def urlType = CTools.nullToZero(params.urlType)
        def subtitleId = CTools.nullToZero(params.subtitleId)
        def subtitle = null
        def serial = null
        def program = null
        def langList = null

        langList = Lang.list()

        if (serialId > 0) {
            serial = Serial.get(serialId)
        } else {
            program = session.program
            serial = findSerial(program, "serialNo", serialNo, urlType)
        }

        if (subtitleId > 0) subtitle = Subtitle.get(subtitleId)

        if (!subtitle) {
            //flash.message = "serial not found with serialNo ${subtitleId}"
        }
        result.serial = serial;
        result.subtitle = subtitle;
        result.langList = langList;
        return result;
    }
    /**
     * 添加修改字幕
     * @param params
     * @return
     */
    public Map operateSubtitle(Map params) {
        def result = [:];
        def session = utilService.getSession();
        def program = null
        def serial = null
        def subtitle = null
        def lang = null

        def programId = CTools.nullToZero(params.programId)
        def serialId = CTools.nullToZero(params.serialId)
        def oldSerialNo = CTools.nullToZero(params.oldSerialNo)//原来的 serialNo,因为可以改serialNo
        def urlType = CTools.nullToZero(params.urlType)
        def oldUrlType = CTools.nullToZero(params.oldUrlType)

        subtitle = Subtitle.get(params.id)

        lang = Lang.get(params.langId)

        //如果是修改资源
        if (serialId > 0) {
            serial = Serial.get(serialId)
        } else {
            program = Program.get(programId);
            serial = findSerial(program, "serialNo", oldSerialNo, oldUrlType)
        }

        //如果是修改
        if (subtitle) {
            subtitle.properties = params
            if (lang) subtitle.lang = lang
        } else {//如果是添加
            subtitle = new Subtitle(params)
            if (lang) subtitle.lang = lang
            serial.addToSubtitles(subtitle)
        }
        subtitle.save(flush: true);
        serial.save(flush: true);
        result.serial = serial;
        return result;
    }
    /**
     * 放入回收站
     * @param params
     * @return
     */
    public Map toRecycler(Map params) {
        def result = [:];
        def session = utilService.getSession();
        def fromModel = CTools.nullToBlank(params.fromModel)
        boolean isFromMgr = true;    //来自管理端
        List<Long> ids = new ArrayList<Long>();
        def delIdList = params.idList
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        //if (delIdList instanceof String) delIdList = [params.idList]

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
        if (ids.size() > 0) {
            ids?.each {
                def program = Program.get(it)
                if (program && (program.consumer.id == session.consumer.id || session.consumer?.role <= Consumer.MANAGER_ROLE)) {
                    //管理端可删除任意资源，个人空间只能删除未入库的资源
                    if (isFromMgr || (!isFromMgr && program.state <= program.APPLY_STATE)) {
                        //删除时 放入回收站，状态值是对应的相反数，以便还原到原始状态
                        program.state = -Math.abs(program.state)
                        program.dateDeleted = new Date();
                        result.success = true;
                        result.message = "删除成功!"
                        new OperationLog(tableName: 'program', tableId: program.id, operator: params.consumer.name, operatorIP: params.request.getRemoteAddr(),
                                modelName: '删除资源', brief: program.name, operatorId: params.consumer.id, operation: OperationEnum.DELETE_PROGRAM).save()
                    }
                    if (fromModel == "programMgrRecycler") {
                        program.delete();
                        result.success = true;
                        result.message = "删除成功!"
                        new OperationLog(tableName: 'program', tableId: program.id, operator: params.consumer.name, operatorIP: params.request.getRemoteAddr(),
                                modelName: '删除资源', brief: program.name, operatorId: params.consumer.id, operation: OperationEnum.DELETE_PROGRAM).save()
                    }
                } else {
                    result.success = false;
                    result.message = "program not found with id ${it}"
                }
            }
        } else {
            result.success = false;
            result.message = "program not found with id";
        }

        return result;
    }
    /**
     * 用户组列表
     * @param params
     * @return
     */
    public Map userGroupList(Map params) {
        def result = [:];
        result.success = false;
        def session = utilService.getSession();
        if (!params.max) params.max = 10
        if (!params.sort) params.sort = 'dateCreated'
        if (!params.order) params.order = 'desc'
        if (!params.offset) params.offset = 0
        def idList = params.idList;
        List<String> ids = new ArrayList<String>();
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
        if (ids) {
            if (!session.programIdList) {
                session.programIdList = ids
            }
        } else {
            result.message = "请先选择要分配组的资源"
            return result;
        }
        session.programIdList = ids

        //取得最大显示页面，并转换为整型
        //取得页面偏移量，并转换为整型
        def _max = params.max.toInteger()
        def _offset = params.offset.toInteger()
        def total = UserGroup.count()
        int pageCount = Math.round(Math.ceil(total / _max))
        int pageNow = (_offset / _max) + 1

        //****
        def programIdList = session.programIdList
        if (programIdList instanceof String) {
            programIdList = [session.programIdList]
        }

        def userGroups = []
        def userGroupIds = []
        programIdList.each { proId ->
            def program = Program.get(proId)
            def playGroups = program.playGroups
            playGroups?.each { pg ->
                if (!userGroups.contains(pg)) {
                    userGroups.add(pg)
                    userGroupIds.add(pg.id)
                }
            }
        }
        result.userGroupList = UserGroup.list();
        result.total = total;
        result.pageCount = pageCount;
        result.pageNow = pageNow;
        result.programIdList = ids;
        result.selectedUserGroups = userGroups;
        result.selectedUserGroupIds = userGroupIds;
        result.flag = params.flag ? 2 : 1;
        result.success = true;
        return result;
    }

    /**
     * 取消组权限
     * @param params
     * @return
     */
    public Map delProgramGroup(Map params) {
        def result = [:];
        result.success = true;
        def session = utilService.getSession();
        def programIdList = session.programIdList
        def userGroupIdList = params.idList


        if (programIdList instanceof String) {
            programIdList = [session.programIdList]
        }

        if (userGroupIdList instanceof String) {
            userGroupIdList = [params.idList]
        }

        programIdList?.each { proId ->
            userGroupIdList?.each { userGroupId ->
                def program = Program.get(proId)
                def userGroup = UserGroup.get(userGroupId)
                if (program.playGroups.contains(userGroup)) {
                    if (!program.removeFromPlayGroups(userGroup)) {
                        result.success = false
                        result.message = "取消组出现问题"
                    }
                }
            }
        }

        session.removeAttribute("programIdList")
        return result;
    }
    /**
     * 查询用户组列表
     * @param params
     * @return
     */
    public Map groupSelectList(Map params) {
        def result = [:];
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        java.util.Date begin_date = null;
        java.util.Date end_date = null;

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
        def total = consumerList.totalCount
        result.searchList = consumerList;
        result.userGroupList = UserGroup.list();
        result.total = total;
        return result;
    }
    /**
     *
     * @param params
     * @return
     */
    public Map groupConsumerList(Map params) {
        def result = [:];
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

        result.userGroupConsumerList = userGroupConsumerList;
        result.userGroupList = userGroupList;
        result.total = total;
        result.groupId = params.groupId;
        result.groupName = userGroupName;
        result.pageCount = pageCount;
        result.pageNow = pageNow;
        return result;
    }
    /**
     * 删除单个组员与组的关系
     * @param params
     */
    public void groupDeleteConsumerOne(Map params) {
        def result = [:];
        def group = UserGroup.get(params.groupId)
        def consumer = Consumer.get(params.id)
        group.removeFromConsumers(consumer)
    }
    /**
     * 组中添加新单个用户
     * @param params
     * @return
     */
    public Map groupAddConsumerOne(Map params) {
        def result = [:];
        result.success = true;
        def group = UserGroup.get(params.groupId)
        def consumer = Consumer.findByName(params.consumerId)

        if (consumer) {
            group.addToConsumers(consumer)
        } else {
            result.success = false;
            result.message = " 没有该用户"
        }
        return result;
    }
    /**
     * 复制一个节目
     * @param params
     * @return
     */
    public Map copyProgram(Map params) {
        def result = [:];
        result.success = true;
        def session = utilService.getSession();
        def program1 = Program.get(params.id)

        if (program1 && (program1.consumer.id == session.consumer?.id || session.consumer?.role <= Consumer.MANAGER_ROLE)) {

            def program2 = new Program()

            program2.state = program1.state
            program2.classLib = program1.classLib
            program2.name = program1.name
            program2.actor = program1.actor
            program2.directory = program1?.directory
            program2.description = program1.description
            program2.consumer = session.consumer

            if (CTools.nullToZero(program1?.directory?.id) < 1) program2.directory = program2?.classLib
            program2.dateModified = new Date()
            program2.datePassed = program2.dateModified
            program2.nowVersion = 0    //分发时，新增资源标志
            program2.preVersion = -1    //分发时，新增资源标志
            program2.posterHash = program1.posterHash;
            program2.posterType = program1.posterType;
            program2.posterPath = program1.posterPath;
            program2.otherOption = program1.otherOption;
            program2.type = program1.type;

            program1.programTags.toList().each { val ->
                if (val != "") {
                    program2.addToProgramTags(val)
                }
            }

            program1.metaContents.toList().each { val ->
                if (val != "") {
                    program2.addToMetaContents(new MetaContent(
                            metaDefine: val.metaDefine, parentId: val.parentId, program: program2, numContent: val.numContent,
                            strContent: val.strContent))

                }


            }

            program1.serials.toList().each { Serial val ->
                if (val != "") {
                    Serial serial = new Serial(bandWidth: val.bandWidth, dateCreated: new Date(), dateModified: new Date(),
                            endTime: val.endTime, description: val.description, filePath: val.filePath, formatAbstract: val.formatAbstract,
                            name: val.name, progType: val.progType, programId: val.programId, serialNo: val.serialNo, startTime: val.startTime,
                            strProgType: val.strProgType, svrAddress: val.svrAddress, timeLength: val.timeLength, urlType: val.urlType, webPath: val.webPath);
                    serial.fileHash = val.fileHash;
                    serial.filePath = val.filePath;
                    serial.fileType = val.fileType;
                    serial.photo = val.photo;
                    program2.addToSerials(serial)
                }
            }

            if (program2.save()) {
                session.program = null
                result.saveMessage = "资源上传成功，可连续上传。 "
                //生成操作日志
                new OperationLog(operation: OperationEnum.ADD_PROGRAM, tableName: 'program', tableId: program2.id, brief: program2.name, operator: session.consumer.name, operatorId: session.consumer.id).save()
                Consumer.get(session.consumer.id).uploadNum++
                result.id = program2.id;
                result.fromModel = params.fromModel;

            } else {
                result.success = false;
                result.program = program2;
            }
        } else {
            result.success = false;
            result.noFind = true;
            result.message = "nts.program.domain.Program not found with id ${params.id}"
        }
        return result;
    }
    /**
     * 创建节目
     * @param params
     * @return
     */
    public Map programCreate() {
        def result = [:];
        result.success = true;
        def session = utilService.getSession();
        def webUtils = WebUtils.retrieveGrailsWebRequest();
        def response = webUtils.getCurrentResponse();

        Cookie cookie1 = new Cookie("uploadServerAddress", systemConfigService.findUploadServerAddress());
        Cookie cookie2 = new Cookie("uploadServerPort", systemConfigService.findUploadPort().toString());
        Cookie cookie3 = new Cookie("fileSizeLimit", systemConfigService.findFileSizeLimit().toString());
        //cookie1.setDomain(request.getServerName())
        //cookie1.setSecure(true);
        //cookie2.setDomain(request.getServerName())
        //cookie2.setSecure(true);
        response.addCookie(cookie1);
        response.addCookie(cookie2);
        response.addCookie(cookie3);


        if (session.consumer.uploadState == Consumer.CAN_UPLOAD_STATE) {
            def directoryList = Consumer.get(session.consumer.id).directorys

            //管理员，未具体设置库的（默认） 能上传到所有库
            if (session.consumer.role < Consumer.MANAGER_ROLE || directoryList == null || directoryList.size() < 1) {
                directoryList = Directory.findAllByParentIdAndShowOrderGreaterThan(0, 0, [sort: "showOrder", order: "asc"])
            }
            result.directoryList = directoryList;
        } else {
            result.success = false;
            result.message = "对不起,目前你没有上传的权限,请申请!"
        }
        return result;
    }
    /**
     * Serial保存
     * @param params
     * @return
     */
    public Map saveSerial(params) {
        def result = [:];
        result.success = true;
        Serial serial = Serial.findById(params.id);
        def name = params.name;
        def desc = params.desc;
        def serialNum = CTools.nullToOne(params.serialNum);
        def photo = params.photo;
        def urlType = params.urlType;
        serial.name = name;
        serial.description = desc;
        serial.serialNo = serialNum;
        serial.urlType = Integer.parseInt(urlType);
        if (serial.save(flush: true)) {
            result.programId = serial.program.id;
            result.serialId = serial.id;
            result.success = true;
        } else {
            result.success = false;
            result.serialId = serial.id;
        }
        return result;
    }
    /**
     * 更改资源分类
     * @param params
     * @return
     */
    public Map changeProgramCategory(Map params) {
        def result = [:];
        result.success = true;
        def idList = params.idList;
        def categoryId = params.categoryId;
        String[] idArray = idList.toString().split(",");
        String[] categoryIdArray = categoryId.split(",");
        ProgramCategory programCategory = null;
        Program program1 = null;

        idArray?.each {
            program1 = Program.findById(Long.parseLong(it));
            //清除分类
            def categoryList = program1?.programCategories?.toList();
            categoryList?.each{ProgramCategory category->
                program1.removeFromProgramCategories(category);
            };
            //清除分面值
            def facetedValues = program1?.factedValues?.toList();
            facetedValues?.each{FactedValue value->
                program1.removeFromFactedValues(value);
            }
            program1.save(flush: true);
        }

        idArray?.each {
            program1 = Program.findById(Long.parseLong(it));
            if(categoryIdArray && categoryIdArray.length>0) {
                // 设置分类
                categoryIdArray?.each{String cId ->
                    programCategory = ProgramCategory.findById(cId as long);
                    program1.addToProgramCategories(programCategory);
                }
                // 设置元数据标准,第一个分类id
                def firstCategoryId = categoryIdArray[0] as long;
                programCategory = ProgramCategory.findById(firstCategoryId);
                def directoryId = queryCategoryDirectoryId(firstCategoryId);
                def directory = Directory.findById(directoryId);
                program1.directory = directory;
                program1.classLib = directory
                program1.firstCategoryId = firstCategoryId;
                program1.save(flush: true);
            }
        }
        return result;
    }

    /**
     * 查询元数据标准
     * @param params
     * @return
     */
    public long queryCategoryDirectoryId(long categoryId) {
        def directoryId = 0;
        // 获取第二级分类list
        List<ProgramCategory> categoryList = programCategoryService.querySubCategoryForAdmin(programCategoryService.querySuperCategory());
        def categoryIdList = categoryList?.id;
        ProgramCategory category = ProgramCategory.get(categoryId as long);
        if (category) {
            ProgramCategory parent = queryParentCategory(category, categoryIdList);
            if(parent) {
                directoryId = parent.directoryId;
            }
        } else {
            return directoryId;
        }

        return directoryId;
    }

    /**
     * 查询第二级分类
     * @param category
     * @return
     */
    private ProgramCategory queryParentCategory(ProgramCategory category, List<Long> categoryIdList) {
        ProgramCategory parentCategory = null;
        if(!categoryIdList.contains(category?.id)) {
            parentCategory = queryParentCategory(category.parentCategory, categoryIdList);
        } else {
            parentCategory = category;
        }
        return parentCategory;
    }

    /**
     * 目录保存
     * @param params
     * @return
     */
    public Map directorySave(Map params) {
        def result = [:];
        result.success = true;
        result.message = null;
        def directory = new Directory(
                name: params.name,                            //目录名称
                showOrder: params.showOrder,                    //显示顺序
                canUpload: true,                                //上传标记
                description: params.description,                    //目录描术
                parentId: 0,                                    //因不用树目录，故没有用Directory类型		--暂为0
                classId: 0,                                        //类库ID 用来标识所属类库
                childNumber: 0,                                //子目录数目，建树目录时提高效率用		--暂为0
                allGroup: true                                    //所属组
        )

        /*def uploadResult = uploadImg("save", params.updateId)
        if (!uploadResult.success) {
            result.message = uploadResult.message;
        }
        if (params.uploadPath) directory.uploadPath = params.uploadPath;
        directory.img = uploadResult.imgPath;*/

        if (directory.description == null) {
            directory.description = "";
        }
        if (!directory.hasErrors() && directory.save()) {
            result.success = true;
            result.message = "元数据标准 ${directory.name} 创建成功！"
        } else {
            result.success = false;
        }
        return result;
    }
    /**
     * 目录更新
     * @param params
     * @return result
     *      success:为true，不一定修改成功，因为成功失败转跳页面都一样
     *              未false，表示找不到该目录，查看message才能知道是否修改成功
     */
    public Map directoryUpdate(Map params) {
        def result = [:];
        result.success = true;
        result.message = "";
        def session = utilService.getSession();
        if (session.consumer.role == 0) {
            def directory = Directory.get(params.id)
            if (directory) {
                directory.name = params.name
                directory.showOrder = params.showOrder.toInteger()
                directory.description = params.description

                /*def uploadResult;
                uploadResult = uploadImg("update", params.id);
                if (!uploadResult.success) {
                    result.message = uploadResult.message;
                }
                if (params.uploadPath) directory.uploadPath = params.uploadPath;
                directory.img = uploadResult.imgPath;*/

                if (!directory.hasErrors() && directory.save()) {
                    result.message = "元数据标准 ${directory.name} 修改完成"
                } else {
                    result.message = "元数据标准 ${directory.name} 修改失败"
                }
            } else {
                result.message = "nts.system.domain.Directory not found with id ${params.id}"
                result.success = false;
            }
        } else {
            result.message = "只有超级管理员才可修改"
        }
        return result;
    }
    /**
     * /////////////////////////方法
     //搜索名称供素材,相关资源
     * @param params
     * @return
     */
    public Map search(Map params) {
        def result = [:];
        def session = utilService.getSession();
        def keyword = CTools.nullToBlank(params.keyword)
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0

        params.sort = "id"
        params.order = "desc"

        def programList = null
        def total = 0

        programList = Program.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            if (keyword != '') like("name", "%${keyword}%")
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

        result = [programList: programList, total: total]
        return result;
    }
    //上传图片
    private Map uploadImg(def opt, def updateId) {
        def result = [:];
        result.success = true;
        def request = utilService.getRequest();
        def servletContext = utilService.getServletContext();
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
                    imgFile.transferTo(new java.io.File("${path}/directoryImg/" + imgPath))
                } else if (opt == "update") {
                    def directory = Directory.get(updateId)
                    def id = directory.id
                    imgPath = "i_" + id + ".jpg"
                    imgFile.transferTo(new java.io.File("${path}/directoryImg/" + imgPath))
                }
            } else {
                result.success = false;
                result.message = "上传图片格式不对..."
            }
        }
        result.imgPath = imgPath;
        return result;
    }
    /**
     * 删除文件
     * @param program
     * @return
     */
    public void deleteFiles(def program) {
        def servletContext = utilService.getServletContext();
        if (servletContext.fileDelOpt == 1) {
            def filePath = ""
            Serial serial = null

            if (program && program.serials) {
                program.serials.toList().each {
                    filePath = it.filePath
                    //链接类型不删除
                    if (filePath.indexOf("://") == -1) {
                        serial = Serial.findByFilePathAndProgramNotEqual(filePath, program)
                        //如果没有其它资源引用此文件才删除
                        if (!serial) {
                            def file = new File(filePath)
                            if (file.exists()) {
                                boolean bOK = file.delete();
                            } else {
                                //println "file not exists:"+filePath
                            }
                        }
                    }
                }
            }
        }
    }
    //现暂时只实现通过serialNo，urlType来获取
    /**
     * 获取Serial
     * @param program
     * @param prop
     * @param value
     * @param urlType
     * @return
     */
    private Serial findSerial(program, prop, value, urlType) {
        def serial = null
        if (program && program.serials) {
            program.serials.toList().each {
                if (prop == "serialNo" && it.serialNo == value && it.urlType == urlType) {
                    serial = it
                    //break //each 不支持break, 可用for(it in list) 试试
                }
            }
        }

        return serial
    }

    /**
     * 资源是否能点播、下载
     * @param params
     * @return
     */
    public Map programCanOperationSet(Map params) {
        def result = [:];
        def idList = params.idList
        def operation = CTools.nullToBlank(params.operation)
        def val = CTools.nullToBlank(params.val)
        List<String> ids = new ArrayList<String>();
        //如果只选中一条记录，其为字符串，each会分其为单个字符
        List<String> stateName = new ArrayList<String>();
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

        def canOperation = false
        if (val == '1') {
            canOperation = true
        } else if (val == '0') {
            canOperation = false
        }

        ids?.each { String id ->
            def program = Program.get(id as long)
            //权限待调整,管理员才能审批发布
            if (program) {
                if (operation == 'canPlay') {
                    program.canPlay = canOperation;
                    if (!canOperation) {
                        program.canAllPlay = canOperation;
                    }
                } else if (operation == 'canAllPlay') {
                    program.canAllPlay = canOperation
                } else if (operation == 'canDownload') {
                    program.canDownload = canOperation
                    if (!canOperation) {
                        program.canAllDownload = canOperation;
                    }
                } else if (operation == 'canAllDownload') {
                    program.canAllDownload = canOperation
                }
                program.save()
                result.message = "操作成功";
                result.success = true;
            } else {
                result.message = "program not found with id ${id}";
                result.success = false;
            }
        }
        return result;
    }


}
