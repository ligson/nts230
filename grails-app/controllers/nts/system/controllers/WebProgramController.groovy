package nts.system.controllers

import grails.converters.JSON
import groovy.xml.MarkupBuilder
import nts.program.domain.DistributeApply
import nts.program.domain.DistributeProgram
import nts.program.domain.Program
import nts.system.domain.ServerNode
import nts.system.domain.SysConfig
import nts.utils.CTools

import java.text.SimpleDateFormat
import org.codehaus.groovy.grails.web.json.JSONObject

class WebProgramController {

    //获取上级资源
    def listProgram = {
        //生成xml，带分页（total放到xml中）
        def writer = new StringWriter()
        def builder = new MarkupBuilder(writer)

        if (!params.max) params.max = 15
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        java.util.Date begin_date = null;
        java.util.Date end_date = null;

        def dateBegin = params.dateBegin                    //创建开始时间
        def dateEnd = params.dateEnd                    //创建结束时间

        if (dateBegin) {
            dateBegin = params.dateBegin + ' 00:00:01'

            begin_date = sdf.parse(dateBegin);
        } else {
            begin_date = sdf.parse("1970-01-01 00:00:00");
        }
        if (dateEnd) {
            dateEnd = params.dateEnd + ' 23:59:59'
            end_date = sdf.parse(dateEnd);
        } else {
            end_date = sdf.parse(sdf.format(new Date()));
        }

        //countChild实为：下级节点或联盟节点
        //def countChild = nts.system.domain.ServerNode.countByGradeAndIp(nts.system.domain.ServerNode.GRADE_CHILD, params.ip);
        def countChild = ServerNode.countByIp(params.ip);

        if (countChild == 0) {
            builder.programs(total: -1)
            render writer.toString()
            return
        }

        //已分发给某节点的资源id
        def distributedProgramIds = []

        //得到目标节点以获取过的资源
        def cDistributeProgram = DistributeProgram.createCriteria()
        def distributePrograms = cDistributeProgram.list() {
            //已发送的
            eq("state", DistributeProgram.STATE_DISTRIBUTED)

            //目标节点
            serverNode {
                eq("ip", params.ip)
            }
        }

        distributePrograms.each {
            distributedProgramIds << it.program.id
        }

        def c = Program.createCriteria()
        def programList = c.list(params) {
            if (params.name) {
                like('name', "%${params.name.trim()}%")
            }
            if (params.actor) {
                like('actor', "%${params.actor.trim()}%")
            }

            //是否可分发          
            if (params.to.toInteger() == ServerNode.GRADE_UNION) {
                eq('canUnion', true)
            } else {
                eq("canDistribute", true)
            }

            //过滤已分发资源
            if (distributedProgramIds.size() > 0) {
                not {
                    'in'("id", distributedProgramIds)
                }
            }

            //入库打开（已发布）
            ge("state", Program.PUBLIC_STATE)
            between("dateCreated", begin_date, end_date)
        }

        builder.programs(total: programList.totalCount) {
            programList.each { item ->
                builder.program(id: item.id) {
                    name(item.name)
                    actor(item.actor)
                    dateCreated(item.dateCreated)
                    guid(item.guid)
                }
            }
        }

        render writer.toString()
    }

    //定时获取列表
    def listTimerAcquireProgram = {
        //生成xml，带分页（total放到xml中）
        def writer = new StringWriter()
        def builder = new MarkupBuilder(writer)

        if (!params.max) params.max = 15
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        java.util.Date begin_date = null;
        java.util.Date end_date = null;

        def dateBegin = params.dateBegin                    //创建开始时间
        def dateEnd = params.dateEnd                    //创建结束时间

        if (dateBegin) {
            dateBegin = params.dateBegin + ' 00:00:01'

            begin_date = sdf.parse(dateBegin);
        } else {
            begin_date = sdf.parse("1970-01-01 00:00:00");
        }
        if (dateEnd) {
            dateEnd = params.dateEnd + ' 23:59:59'
            end_date = sdf.parse(dateEnd);
        } else {
            end_date = sdf.parse(sdf.format(new Date()));
        }

        //countChild实为：下级节点或联盟节点
        //def countChild = nts.system.domain.ServerNode.countByGradeAndIp(nts.system.domain.ServerNode.GRADE_CHILD, params.ip);
        def countChild = ServerNode.countByIp(params.ip);

        if (countChild == 0) {
            builder.programs(total: -1)
            render writer.toString()
            return
        }

        //已分发给某节点的资源id
        def distributedProgramIds = []

        //得到目标节点以获取过的资源
        def cDistributeProgram = DistributeProgram.createCriteria()
        def distributePrograms = cDistributeProgram.list(params) {
            //已发送或者更新的
            ne("state", DistributeProgram.STATE_DISTRIBUTED)

            //目标节点
            serverNode {
                eq("ip", params.ip)
            }
            program {
                if (params.name) {
                    like('name', "%${params.name.trim()}%")
                }
                if (params.actor) {
                    like('actor', "%${params.actor.trim()}%")
                }

                //入库打开
                ge("state", Program.PUBLIC_STATE)
                between("dateCreated", begin_date, end_date)
            }
        }

        builder.programs(total: distributePrograms.totalCount) {
            distributePrograms.each { item ->
                builder.program(id: item.program.id) {
                    name(item.program.name)
                    actor(item.program.actor)
                    dateCreated(item.program.dateCreated)
                }
            }
        }

        render writer.toString()
    }

    //可收割资源
    def listReapProgram = {
        //生成xml，带分页（total放到xml中）
        def writer = new StringWriter()
        def builder = new MarkupBuilder(writer)

        if (!params.max) params.max = 15
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        java.util.Date begin_date = null;
        java.util.Date end_date = null;

        def dateBegin = params.dateBegin                    //创建开始时间
        def dateEnd = params.dateEnd                    //创建结束时间

        if (dateBegin) {
            dateBegin = params.dateBegin + ' 00:00:01'

            begin_date = sdf.parse(dateBegin);
        } else {
            begin_date = sdf.parse("1970-01-01 00:00:00");
        }
        if (dateEnd) {
            dateEnd = params.dateEnd + ' 23:59:59'
            end_date = sdf.parse(dateEnd);
        } else {
            end_date = sdf.parse(sdf.format(new Date()));
        }

        //因为增加了联盟收割，故
        //def countParent = nts.system.domain.ServerNode.countByGradeAndIp(nts.system.domain.ServerNode.GRADE_PARENT, params.ip);
        def countParent = ServerNode.countByIp(params.ip);

        if (countParent == 0) {
            builder.programs(total: -1)
            render writer.toString()
            return
        }

        def c = Program.createCriteria()
        def programList = c.list(params) {
            if (params.name) {
                like('name', "%${params.name.trim()}%")
            }
            if (params.actor) {
                like('actor', "%${params.actor.trim()}%")
            }
            //过滤已收割的资源
            gtProperty("nowVersion", "preVersion")
            //过滤从上级分发下来的资源
            ne("fromState", 2)

            if (params.to.toInteger() == ServerNode.GRADE_UNION) {
                eq('canUnion', true)
            }

            //入库打开（已发布）
            ge("state", Program.PUBLIC_STATE)
            between("dateCreated", begin_date, end_date)
        }

        builder.programs(total: programList.totalCount) {
            programList.each { item ->
                builder.program(id: item.id) {
                    name(item.name)
                    actor(item.actor)
                    dateCreated(item.dateCreated)
                    guid(item.guid)
                    preVersion(item.preVersion)
                    otherOption(item.otherOption)
                }
            }
        }

        render writer.toString()
        //println writer.toString()
    }

    //定时收割列表
    def listTimerReapProgram = {
        if (!params.max) params.max = 15
        if (!params.offset) params.offset = 0
        if (!params.sort) params.sort = 'id'
        if (!params.order) params.order = 'desc'

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        java.util.Date begin_date = null;
        java.util.Date end_date = null;

        def dateBegin = params.dateBegin                    //创建开始时间
        def dateEnd = params.dateEnd                    //创建结束时间

        if (dateBegin) {
            dateBegin = params.dateBegin + ' 00:00:01'

            begin_date = sdf.parse(dateBegin);
        } else {
            begin_date = sdf.parse("1970-01-01 00:00:00");
        }
        if (dateEnd) {
            dateEnd = params.dateEnd + ' 23:59:59'
            end_date = sdf.parse(dateEnd);
        } else {
            end_date = sdf.parse(sdf.format(new Date()));
        }

        def c = DistributeProgram.createCriteria()
        def programList = c.list(params) {
            //未发送的 或 更新的
            ne("state", DistributeProgram.STATE_DISTRIBUTED)
            serverNode {
                eq("ip", params.ip)
            }
            program {
                if (params.name) {
                    like('name', "%${params.name.trim()}%")
                }
                if (params.actor) {
                    like('actor', "%${params.actor.trim()}%")
                }
                //如果是收割资源
                if (params.distribute == 'false') {
                    //过滤从上级分发下来的资源
                    ne("fromState", 2)
                } else {
                    //是否可分发
                    eq("canDistribute", true)
                }

                //入库打开
                ge("state", Program.PUBLIC_STATE)
                between("dateCreated", begin_date, end_date)
            }
        }

        //生成xml，带分页（total放到xml中）
        def writer = new StringWriter()
        def builder = new MarkupBuilder(writer)


        builder.programs(total: programList.totalCount) {
            programList.each { item ->
                builder.program(id: item.program.id) {
                    name(item.program.name)
                    actor(item.program.actor)
                    dateCreated(item.program.dateCreated)
                }
            }
        }

        render writer.toString()
    }

    //定时收割
    def saveReapProgram = {
        def distributeProgram
        def programIds = params.idLists

        def programIdList = string2List(programIds)

        def programList = Program.getAll(programIdList)

        //目标节点（上级节点，即收割）
        def serverNode = ServerNode.findByGrade(ServerNode.GRADE_PARENT)
        def serverNodeSelf = ServerNode.findByGrade(ServerNode.GRADE_SELF)

        programList?.each { program ->
            if (program && serverNode) {
                program.preVersion = program.nowVersion
                DistributeProgram obj = DistributeProgram.findByProgramAndServerNode(program, serverNode)
                //如果被收割记录不存在，则save
                if (!obj) {
                    distributeProgram = new DistributeProgram()
                    distributeProgram.isDistribute = false
                    distributeProgram.isSendObject = (program.otherOption & Program.REAP_OBJ_OPTION) == Program.REAP_OBJ_OPTION

                    serverNode.addToDistributePrograms(distributeProgram).save()
                    program.addToDistributePrograms(distributeProgram).save()
                    //更新资源以前的版本
                    if (program.save(flush: true)) {

                    } else {
                        program.errors.allErrors.each { println it }
                    }

                    //如果被收割记录存在，并且发送状态为“更新”，将状态改为“未发送”，update
                } else if (obj && obj.state == DistributeProgram.STATE_UPDATE) {
                    obj.state = DistributeProgram.STATE_NO_DISTRIBUTED
                    obj.isSendObject = (program.otherOption & Program.REAP_OBJ_OPTION) == Program.REAP_OBJ_OPTION
                    serverNode.addToDistributePrograms(obj).save()
                    program.addToDistributePrograms(obj).save()
                    //更新资源以前的版本
                    if (program.save(flush: true)) {

                    } else {
                        program.errors.allErrors.each { println it }
                    }
                }
            }
        }
        def returnList = ["从节点${serverNodeSelf.name}收割了${programList.size()}个资源"] as JSON

        render returnList
    }

    //保存要获取的资源信息
    def saveProgramInformation = {
        def distributeProgram
        def serverNodeIp = params.serverNodeIp
        def programIds = params.idLists

        def programIdList = string2List(programIds)

        def programList = Program.getAll(programIdList)
        def serverNode = ServerNode.findByIp(serverNodeIp)
        if (!serverNode) {
            def result = ["不存在此节点"] as JSON

            render result
            return
        }

        programList?.each { program ->
            distributeProgram = new DistributeProgram()
            if (program && serverNode) {
                DistributeProgram obj = DistributeProgram.findByProgramAndServerNode(program, serverNode)
                //如果记录不存在，则保存
                if (!obj) {
                    program.addToDistributePrograms(distributeProgram).save()
                    serverNode.addToDistributePrograms(distributeProgram).save(flush: true)

                    //如果记录存在，并且发送状态为“更新”，将状态改为“未发送”，update
                } else if (obj && obj.state == DistributeProgram.STATE_UPDATE) {
                    obj.state = DistributeProgram.STATE_NO_DISTRIBUTED

                    serverNode.addToDistributePrograms(obj).save()
                    program.addToDistributePrograms(obj).save()
                }
            }
        }
        def result = ["申请了${programList.size()}个资源"] as JSON

        render result
    }

    def saveDistributeApply = {
        //读取参数
        def distributeApplyObject = CTools.getInputStreamContent(request.getInputStream())
        def distributeApplyJson = (JSONObject) JSON.parse(distributeApplyObject)

        def distributeApply = new DistributeApply()
        distributeApply.type = 1
        distributeApply.name = distributeApplyJson.name
        distributeApply.description = distributeApplyJson.description
        distributeApply.fromNodeName = distributeApplyJson.fromNodeName
        distributeApply.fromNodeIp = distributeApplyJson.fromNodeIp
        distributeApply.fromUser = distributeApplyJson.fromUser
        distributeApply.contact = distributeApplyJson.contact
        distributeApply.reply = distributeApplyJson.reply
        distributeApply.fromNodeId = distributeApplyJson.fromNodeId
        distributeApply.fromGrade = distributeApplyJson.fromGrade

        if (distributeApply.save(flush: true)) {
            render "success"
        } else {
            render "false"
        }
    }

    ////根据节点名称获取节点ID
    def getNodeIdByName = {
        def nodeId = 0
        def serverNode = ServerNode.findByName(params.nodeName)
        if (serverNode) nodeId = serverNode.id

        render nodeId
    }

    ////下级节点获取上级节点OutPlayFrequency配置值
    def getOutPlayFrequency = {
        int frequency = 20
        def outPlayFrequency = SysConfig.findByConfigName('OutPlayFrequency');    //远程点播阀值
        if (outPlayFrequency) frequency = outPlayFrequency.configValue.toInteger()

        render frequency
    }


    def isExitChild = {
        def serverNodeChilds = ServerNode.findAllByGrade(ServerNode.GRADE_CHILD);
        for (int i = 0; i < serverNodeChilds.size(); i++) {

        }
    }

    def string2List(String str) {
        List<Long> list = []
        def strArray = str.split(",")
        strArray.each {
            list << Long.parseLong(it)
        }
        return list
    }
}
