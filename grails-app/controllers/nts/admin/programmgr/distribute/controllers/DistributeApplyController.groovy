package nts.admin.programmgr.distribute.controllers

import com.boful.nts.domin.model.ProgramModel
import com.boful.nts.service.IApp
import com.boful.nts.service.model.RMSNode
import com.boful.nts.wsdl.client.AppServicePortType
import com.boful.nts.wsdl.client.RmsNode
import grails.converters.XML
import nts.program.domain.DistributeApply
import nts.program.domain.DistributePolicy
import nts.program.domain.Program
import nts.program.domain.TimePlan
import nts.system.domain.OperationEnum
import nts.system.domain.OperationLog
import nts.system.domain.ServerNode
import nts.system.domain.SysConfig
import nts.system.services.AppService
import nts.utils.CTools
import org.apache.http.HttpStatus
import org.apache.http.client.entity.UrlEncodedFormEntity
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpPost
import org.apache.http.impl.client.CloseableHttpClient
import org.apache.http.impl.client.HttpClients
import org.apache.http.message.BasicNameValuePair
import org.codehaus.groovy.grails.web.json.JSONElement
import org.omg.CORBA.NameValuePair
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.remoting.rmi.RmiProxyFactoryBean
import org.w3c.dom.Document
import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONObject

import java.rmi.Naming
import java.util.logging.Logger

class DistributeApplyController {
    def serverNodeService;
    def appService
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def utilService
    def grailsApplication
    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        //parmas.to是发出申请节点的级别,而不是目标节点的级别，之所有用to是为了所有参数统一。
        def distributeApplyList = null
        params.max = Math.min(params.max ? params.int('max') : 15, 100)
        params.type = params.type ? params.int('type') : DistributeApply.TYPE_SEND

        def isExitParentServerNode = false
        def isExitChildServerNode = false
        def isExitUnionServerNode = false
        if (ServerNode.countByGrade(ServerNode.GRADE_PARENT) > 0) isExitParentServerNode = true
        if (ServerNode.countByGrade(ServerNode.GRADE_CHILD) > 0) isExitChildServerNode = true
        if (ServerNode.countByGrade(ServerNode.GRADE_UNION) > 0) isExitUnionServerNode = true

        //如果是收到申请列表
        //if(params.type == nts.program.domain.DistributeApply.TYPE_RECEIVE){
        distributeApplyList = DistributeApply.findAllByTypeAndFromGrade(params.type, params.to)
        //}


        [distributeApplyList: distributeApplyList, total: DistributeApply.countByType(params.type), isExitParentServerNode: isExitParentServerNode, isExitChildServerNode: isExitChildServerNode, isExitUnionServerNode: isExitUnionServerNode, to: params.to, type: params.type]
    }

    def create = {
        def serverNodeList = null
        def distributeApply = new DistributeApply()
        distributeApply.properties = params
        if (params.to.toInteger() == DistributeApply.FROM_GRADE_UNION) serverNodeList = ServerNode.findAllByGrade(ServerNode.GRADE_UNION)
        return [serverNodeList: serverNodeList, distributeApply: distributeApply, to: params.to]
    }

    //申请在本地保存一份，在上级也保存一份
    def save = {
        def distributeApply = new DistributeApply(params)
        def serverNodeSelf = ServerNode.findByGrade(ServerNode.GRADE_SELF)
        def toNode = null

        if (params.to.toInteger() == DistributeApply.FROM_GRADE_UNION)
            toNode = ServerNode.get(params.fromNodeId)
        else
            toNode = ServerNode.findByGrade(ServerNode.GRADE_PARENT)


        distributeApply.fromNodeId = serverNodeSelf.id
        distributeApply.fromNodeName = serverNodeSelf.name
        distributeApply.fromNodeIp = serverNodeSelf.ip
        distributeApply.reply = 1
        distributeApply.type = 2
        distributeApply.fromGrade = params.to.toInteger()
        distributeApply.toNodeId = toNode.id
        distributeApply.toNodeName = toNode.name

        def distributeApplyJson = distributeApply as JSON
        def contextPath = grailsApplication.metadata['app.context'];
        if("/".equals(contextPath)){
            contextPath = '';
        }

        //上级节点保存申请信息
        def result = CTools.remoteService("http://${toNode.ip}:${toNode.webPort}"+contextPath+"/webProgram/saveDistributeApply", distributeApplyJson, "POST", "UTF-8")

        if (result && distributeApply.save(flush: true)) {
            redirect(action: "list", params: [type: 2, to: params.to])
        } else {
            render(view: "create", model: [distributeApply: distributeApply, error: "error", to: params.to])
        }
    }

    def show = {
        def distributeApply = DistributeApply.get(params.id)
        if (!distributeApply) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'distributeApply.label', default: 'nts.program.domain.DistributeApply'), params.id])}"
            redirect(action: "list", params: [to: params.to])
        } else {
            [distributeApply: distributeApply, to: params.to]
        }
    }

    def edit = {
        def distributeApply = DistributeApply.get(params.id)
        if (!distributeApply) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'distributeApply.label', default: 'nts.program.domain.DistributeApply'), params.id])}"
            redirect(action: "list", params: [to: params.to])
        } else {
            return [distributeApply: distributeApply, to: params.to]
        }
    }

    def update = {
        def distributeApply = DistributeApply.get(params.id)
        if (distributeApply) {
            if (params.version) {
                def version = params.version.toLong()
                if (distributeApply.version > version) {

                    distributeApply.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'distributeApply.label', default: 'nts.program.domain.DistributeApply')] as Object[], "Another user has updated this nts.program.domain.DistributeApply while you were editing")
                    render(view: "edit", model: [distributeApply: distributeApply, to: params.to])
                    return
                }
            }
            distributeApply.properties = params
            if (!distributeApply.hasErrors() && distributeApply.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'distributeApply.label', default: 'nts.program.domain.DistributeApply'), distributeApply.id])}"
                redirect(action: "show", id: distributeApply.id, params: [to: params.to])
            } else {
                render(view: "edit", model: [distributeApply: distributeApply, to: params.to])
            }
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'distributeApply.label', default: 'nts.program.domain.DistributeApply'), params.id])}"
            redirect(action: "list", params: [to: params.to])
        }
    }

    def delete = {
        params.type = params.type ? params.int('type') : 1
        def idLists = params.idLists

        if (idLists instanceof String) idLists = [idLists.toLong()]
        else idLists = idLists.collect { elem -> elem.toLong() }

        idLists.each {

            def distributeApply = DistributeApply.get(it)
            if (distributeApply) {
                try {
                    distributeApply.delete(flush: true)
                }
                catch (DataIntegrityViolationException e) {
                    e.printStackTrace();
                }
            }
        }

        redirect(action: "list", params: [type: params.type, to: params.to])
    }


    def sendProgram = {
        def result = [:];
        if (params.programId && params.serverNodeId) {
            result = serverNodeService.sendProgram(params)
        } else {
            result.success = false;
            result.msg = "参数不全";
        }
        return render(result as JSON)
    }

    def resourceProgram = {
        def result = [:];
        if (params.programId && params.serverNodeId) {
            result = serverNodeService.receiveProgram(params);
        } else {
            result.success = false;
            result.msg = "参数不全";
        }
        return render(result as JSON)
    }

    def serverNodeMgr = {
        def serverNodeList = null;
        def parentServerNode = [];
        if (params.parentId) {
            parentServerNode = ServerNode.findAllByParentId(params.parentId);
        } else {
            parentServerNode = ServerNode.findAllByParentId(0);
        }
        def result = [];
        parentServerNode.each {
            def tmp = [:];
            tmp.id = it.id;
            tmp.name = it.name;
            tmp.grade = it.grade;
            tmp.isParent = ServerNode.countByParentId(it.id) > 0
            tmp.parentId = it.parentId;
            tmp.ip = it.ip;
            tmp.port = it.port;
            tmp.isSendObject = it.isSendObject;
            result.add(tmp);

        }

        return render(result as JSON);
    }

    def createServerNode = {
        def serverNode = new ServerNode()

        if (params.parentId) {
            ServerNode fatherServerNode = ServerNode.findById(params.parentId as Long);
            if (fatherServerNode) {
                serverNode.grade = fatherServerNode.grade + 1;
            }
        }
        serverNode.properties = params
        def result = [:];
        if (serverNode.save(flush: true) && (!serverNode.hasErrors())) {
            if (params.childId) {
                ServerNode childServerNode = ServerNode.get(params.childId as Long);
                childServerNode.parentId = serverNode.id;
                childServerNode.save(flush: true);
            }
            result.id = serverNode.id;
            result.success = true;
        } else {
            result.success = false;
            result.msg = serverNode.errors.allErrors;
        }
        if (params.returnType && params.returnType.toString().equals("json")) {
            return render(result as JSON);
        }
        return redirect(action: 'serverNodeList', controller: 'programMgr')
    }

    def updateServerNode = {
        def serverNode = ServerNode.get(params.id)
        if (serverNode) {
            if (params.version) {
                def version = params.version.toLong()
                if (serverNode.version > version) {

                    serverNode.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'serverNode.label', default: 'nts.system.domain.ServerNode')] as Object[], "Another user has updated this nts.system.domain.ServerNode while you were editing")
                    render(view: "editServerNode", model: [serverNode: serverNode])
                    return
                }
            }
            serverNode.properties = params
            if (!serverNode.hasErrors() && serverNode.save(flush: true)) {
                redirect(controller: 'programMgr', action: "serverNodeList", id: serverNode.id)
            } else {
                redirect(controller: 'programMgr', action: "serverNodeList")
            }
        } else {
            redirect(controller: 'programMgr', action: "serverNodeList")
        }
    }

    def deleteServerNode = {
        def result = [:];
        if (params.id) {
            ServerNode serverNode = ServerNode.findById(params.id as Long);
            if (serverNode) {

                int subCount = ServerNode.countByParentId(serverNode.id);
                if (subCount > 0) {
                    result.success = false;
                    result.msg = "节点下面还有子节点!";
                } else {
                    def policy = DistributePolicy.createCriteria().list() {
                        serverNodes {
                            eq('id', serverNode.id);
                        }
                    }
                    policy?.each { DistributePolicy distributePolicy ->
                        TimePlan timePlan = distributePolicy.timePlan;
                        if (timePlan) {
                            timePlan.removeFromDistributePolicys(distributePolicy);
                            timePlan.delete();
                        }
                        distributePolicy.removeFromServerNodes(serverNode);
                        serverNode.removeFromDistributePolicys(distributePolicy);
                        distributePolicy.delete();
                    }
                    serverNode.delete();
                    result.success = true;
                    result.msg = "节点删除成功!"
                    new OperationLog(tableName: 'serverNode', tableId: serverNode.id, operator: session.consumer.name, operatorIP: request.getRemoteAddr(),
                            modelName: '删除服务器节点', brief: serverNode.name, operatorId: session.consumer.id, operation: OperationEnum.DELETE_SERVER_NODE).save(flush: true)
                }
            } else {
                result.success = false;
                result.msg = "节点不存在!";
            }

        } else {
            result.success = false;
            result.msg = "参数不全!";
        }
        return render(result as JSON)
    }

    def programAjaxServerNode = {

        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        if (params.rows) {
            params.max = params.rows as int;
        }
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;

        def result = [:];
        def ip = params.ip;
        def port = params.port;
        def serverNodeId = params.id;
        def List<ProgramModel> programs = [];
        int total;
        def appendErrors = "";
        Map<String, String> errors = new HashMap<String, String>();

        try {
            ServerNode serverNode = ServerNode.get(serverNodeId);
            /*RmiProxyFactoryBean factoryBean = new RmiProxyFactoryBean();
            factoryBean.setServiceInterface(IApp.class)
            factoryBean.setServiceUrl("rmi://${ip}:9999/AppService");
            factoryBean.afterPropertiesSet();
            IApp iApp = (IApp)factoryBean.getObject();*/
            AppServicePortType iApp = serverNodeService.queryHttpProtocol(serverNode);
            //AppServicePortType iApp = serverNodeService.queryHttpProtocol(serverNode,"http://"+serverNode.ip+":"+serverNode.port+"/nts/services/app?wsdl");
            programs = iApp.queryPublicPrograms(false, false, params.offset as int, params.max as int);
            total = iApp.queryPublicProgramTotal();
            result.page = page;
            //总记录数
            result.records = total;
            //总页数
            result.total = Math.ceil(total * 1.00 / params.max);
            result.rows = [];
            programs.each {
                def tmp = [:];
                tmp.id = it.id;
                tmp.name = it.name;
                if (it.dateCreated instanceof Date) {
                    tmp.dateCreated = it.dateCreated.format("yyyy-MM-dd");
                } else {
                    tmp.dateCreated = it.dateCreated.toGregorianCalendar().getTime().format("yyyy-MM-dd");
                }

                tmp.recommendNum = it.recommendNum;
                tmp.collectNum = it.collectNum;
                tmp.canDownload = it.canDownload;
                tmp.frequency = it.frequency;
                tmp.state = Program.cnState.get(it.state);
                result.rows.add(tmp);
            }
            result.success = true;
        } catch (e) {
            result.success = false;
            result.msg = e.message;
        }
        response.setContentType("text/json");
        return render(result as JSON);
    }
    //判断当前的IP、PORT是否已经配置过
    def isExistLocalWebIPAndPort() {
        def res = [:];
        RMSNode rmsNode = utilService.findLocalNode();
        ServerNode serverNode = utilService.findLocalServerNode();
        if ((!rmsNode) || (!serverNode)) {
            res.success = false;
            res.msg = "系统配置不完善,请配置....";
        } else {
            res.success = true;
        }
        return render(res as JSON)
    }

    def isLocalNode() {
        def result = [:];
        ServerNode serverNode = utilService.findLocalServerNode();
        String ip = params.ip;
        int port = params.port as int;
        if (serverNode.ip.equals(ip) && (serverNode.port == port)) {
            result.success = true;
        } else {
            result.success = false;
        }
        return render(result as JSON);
    }

}
