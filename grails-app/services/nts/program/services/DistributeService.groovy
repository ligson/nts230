package nts.program.services

import com.boful.nts.BofulClassUtils
import com.boful.nts.domin.model.DirectoryModel
import com.boful.nts.domin.model.ProgramModel
import com.boful.nts.domin.model.SerialModel
import com.boful.nts.service.IApp
import com.boful.nts.wsdl.client.AppServicePortType
import com.boful.nts.wsdl.client.AppServicePortType
import com.boful.nts.service.model.RMSNode
import com.boful.nts.wsdl.client.RmsNode
import com.boful.nts.wsdl.client.ServerNodeModel
import nts.program.domain.DistributePolicy
import nts.program.domain.Program
import nts.system.domain.ServerNode
import nts.utils.BfConfig
import org.springframework.remoting.rmi.RmiProxyFactoryBean

/***
 * 分发收割相关业务逻辑
 */
class DistributeService {
	def jobManagerService
    boolean transactional = false
    def appService
    def serverNodeService
    def utilService

    public Map localProgramServerNode(Map params){
        def result=[:];
        ServerNode serverNode = utilService.findLocalServerNode();
        result.localNode = serverNode;
        return result;
    }
    Map programServerNode(Map params){
        def res=[:];
        if (!params.max) params.max = 10;
        if (!params.offset) params.offset = 0;
        List<Program> programs = new ArrayList<Program>();
        def total;
        def errors;
        ServerNode serverNode = ServerNode.get(params.serverNodeId as Long);
        AppServicePortType iApp = serverNodeService.queryHttpProtocol(serverNode);
        String videoServ = serverNode.ip;
        Integer videoPort = serverNode.port;
        /*RmiProxyFactoryBean factoryBean = new RmiProxyFactoryBean();
        factoryBean.setServiceUrl("rmi://${videoServ}:9999/AppService");
        factoryBean.setServiceInterface(IApp.class)
        factoryBean.afterPropertiesSet();
        IApp iApp = (IApp)factoryBean.getObject();*/
        programs = iApp.queryPublicPrograms(false,false,params.offset as int,params.max as int);
        total = iApp.queryPublicProgramTotal();
        /*String url = "http://" + videoServ + ":"+videoPort+"/nts/serverNode/queryAllProgram";
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpPost httpPost = new HttpPost(url);
        List<NameValuePair> lists = new ArrayList<NameValuePair>();
        lists.add(new BasicNameValuePair("max", params.max.toString()));
        lists.add(new BasicNameValuePair("offset", params.offset.toString()));
        httpPost.setEntity(new UrlEncodedFormEntity(lists));
        try{
            CloseableHttpResponse response = httpClient.execute(httpPost);
            String text = response.getEntity().getContent().getText("UTF-8");
            JSONElement result = JSON.parse(text);

            if (result.programList) {
                programs.addAll(result.programList);
                total = result.total;
            }
        }catch(e){
            String msg=e.getMessage();
            if(msg.equals("Error parsing JSON")){
                errors="没有数据返回!";
            }else{
                errors=msg;
            }

        }*/
        if(programs.size()==0){
            errors="没有数据返回!";
        }
        res.programs=programs;
        res.total=total;
        res.errors=errors;
        return res;
    }
    /**
     * 获取联盟节点
     * @param serverNode
     * @return
     */
    public List<ServerNode> toGradeServerNodeList(ServerNode serverNode){
        List<ServerNode> serverNodeList = [];
        ServerNode fatherServer = ServerNode.findByParentId(serverNode.parentId);
        if(fatherServer!=null){
             serverNodeList.addAll(ServerNode.findAllByParentId(fatherServer.id));
        }else{
            serverNodeList.add(serverNode);
        }
        return serverNodeList
    }
    /**
     * 获取某节点下的所有子节点
     * @param serverNode
     * @return
     */
    public List<ServerNode> childrenServerNode(ServerNode serverNode){
        List<ServerNode> childrenServerNodes = [];
        List<ServerNode> serverNodeList = ServerNode.findAllByParentId(serverNode.id);
        childrenServerNodes.addAll(serverNodeList);
        serverNodeList?.each {ServerNode serverNode1->
            childrenServerNodes.addAll(childrenServerNode(serverNode1));
        }
        return childrenServerNodes;
    }
    //分发任务
    public void startSendDistributePolicyJob(Long disId,Long serverNodeId){
        ServerNode localServerNode = utilService.findLocalServerNode();
        RMSNode rmsNode = utilService.findLocalNode();
        if ((!localServerNode) || (!rmsNode)) {
            log.error("本地服务器节点未配置!");
        }else{
            String localIP = rmsNode.getRmsIPAddress();
            String localPort = rmsNode.getRmsIPPort();
            ServerNode localNode = ServerNode.findByIpAndPort(localIP,localPort as int);
            DistributePolicy distributePolicy = DistributePolicy.get(disId);
            ServerNode serverNode = ServerNode.get(serverNodeId);
            List<ServerNode> serverNodeList = [];
            def latest = distributePolicy.latest;
            def hot = distributePolicy.hot;
            String stringName = "";
            if(latest>hot){
                stringName="frequency"
            }
            else if(latest<hot){
                stringName="dateCreated"
            }
            def toGrade = distributePolicy.toGrade;
            //联盟节点集合
            if(toGrade==4){
                serverNodeList =toGradeServerNodeList(serverNode);
            }
            //下级节点集合
            else if(toGrade==3){
                serverNodeList.add(serverNode);
                serverNodeList.addAll(ServerNode.findAllByParentId(serverNode.id));
            }
            def isSendObject = distributePolicy.isSendObject;
            //根据分发收割策略获取资源集合
            List<Program> programList = Program.createCriteria().list(){
                if(stringName!=""){
                    order(stringName)
                }
                eq("canPublic",true)
            }
            serverNodeList?.each {ServerNode serverNode1->
                programList?.each {Program program->
                    if((program.canDistribute&&(toGrade==3))||(program.canUnion&&(toGrade==4))){
                        //分发原始文件
                        if(isSendObject){
                            serverNodeService.sendFile(serverNode1,program);
                        }
                        //保存资源数据
                        serverNodeService.saveProgram(serverNode1,program,localNode);
                    }
                }
            }
        }


    }
    /***
     * 使用策略disId下载serverNodeId的资源
     * @param disId 策略id
     * @param serverNodeId 要收割服务器id
     */
    public void startRecDistributePolicyJob(Long disId,Long serverNodeId){

        //本地节点确定
        ServerNode localServerNode = utilService.findLocalServerNode();
        RMSNode localNode = utilService.findLocalNode();
        //本地服务是否配置
        if ((!localServerNode) || (!localNode)) {
            log.error("本地服务器节点未配置!");
        }else{
            DistributePolicy distributePolicy = DistributePolicy.get(disId);
            ServerNode serverNode = ServerNode.get(serverNodeId);
            com.boful.nts.domin.model.ServerNodeModel serverNodeModel1 = new com.boful.nts.domin.model.ServerNodeModel();
            BofulClassUtils.cloneObject(serverNode,serverNodeModel1);
            List hashArr = [];
            List pathArr = [];
            List<ServerNode> serverNodeList = [];
            def latest = distributePolicy.latest;
            def hot = distributePolicy.hot;
            def isSendObject = distributePolicy.isSendObject;
            boolean isHot = false;
            boolean isNew = false;
            if(latest>hot){
                isNew = true;
            }
            else if(latest<hot){
                isHot = true;
            }
            def toGrade = distributePolicy.toGrade;
            //联盟节点集合
            if(toGrade==4){
                serverNodeList =toGradeServerNodeList(serverNode);
            }
            //下级节点集合
            else if(toGrade==3){
                serverNodeList.add(serverNode);
                serverNodeList.addAll(ServerNode.findAllByParentId(serverNode.id));
            }
            try {
                serverNodeList?.each {ServerNode serverNode1->
                    AppServicePortType iApp = serverNodeService.queryHttpProtocol(serverNode);
                    List<com.boful.nts.wsdl.client.ProgramModel> programModels = iApp.queryPublicPrograms(isHot,isNew,0,0);
                    ServerNodeModel serverNodeModel = iApp.queryRmsServerNode();
                    if(programModels.size()){
                        programModels?.each {com.boful.nts.wsdl.client.ProgramModel programModel->
                            if(programModel.getSerials().size()>0){
                                programModel.getSerials().each {com.boful.nts.wsdl.client.SerialModel serialModel->
                                    hashArr.add(serialModel.fileHash)
                                    pathArr.add(serialModel.filePath)
                                }
                            }else{
                                log.error(serverNode1.ip+"下没有可收割的资源!");
                            }

                            if(isSendObject){
                                serverNodeService.receiveFile(serverNode1,hashArr)
                            }
                            ProgramModel localProgramModel = new ProgramModel();
                            BofulClassUtils.cloneObject(programModel,localProgramModel);
                            DirectoryModel localDirectoryModel = new DirectoryModel();
                            BofulClassUtils.cloneObject(programModel.getClassLib(),localDirectoryModel);
                            SerialModel[] serialModels = new SerialModel[programModel.getSerials().size()];
                            for(int i=0;i<programModel.getSerials().size();i++){
                                SerialModel localSerialModel = new SerialModel();
                                BofulClassUtils.cloneObject(programModel.getSerials().get(i),localSerialModel);
                                serialModels[i]=localSerialModel;
                            }
                            localProgramModel.setSerials(serialModels);
                            localProgramModel.setClassLib(localDirectoryModel);
                            RmsNode rmsNode = iApp.queryNodeInfo();
                            serverNodeModel1.setIp(rmsNode.getBmcIPAddress());
                            serverNodeModel1.setPort(rmsNode.getBmcWebPort());

                            com.boful.nts.domin.model.ServerNodeModel fromNode = new com.boful.nts.domin.model.ServerNodeModel();
                            BofulClassUtils.cloneObject(serverNode,serverNodeModel1);

                            appService.invokeRmsSaveProgram(localProgramModel,fromNode);
                        }
                    }else{
                        log.error(serverNode1.ip+"下没有可收割的资源!");
                    }
                }


            }catch (e){
                log.error(e.getMessage());
            }
        }
    }



	//重启分发任务
	def restartDistributeJob() { 
		/*Scheduler quartzScheduler = jobManagerService.quartzScheduler

		//////////////////////////////////////////////////删除原来所有触发器和任务 开始
		def listJobGroups = quartzScheduler.getJobGroupNames()
        listJobGroups?.each {jobGroup ->
            quartzScheduler.getJobNames(jobGroup)?.each {jobName ->
			println jobGroup+"="+jobName
				if(jobName == DistributeJob.JOB_NAME){
					def triggers = quartzScheduler.getTriggersOfJob(jobName, jobGroup)
					if (triggers != null && triggers.size() > 0) {
						triggers.each {trigger ->
							//println "triggerName:"+trigger.name
							//println "triggerGroup:"+trigger.group
							println quartzScheduler.unscheduleJob(trigger.name, trigger.group) 					  
						}
					}
					quartzScheduler.deleteJob(jobName, jobGroup)
                }
            }
        } 
        //////////////////////////////////////////////////删除原来所有触发器和任务 结束


		//////////////////////////////////////////////////重新创建所有触发器 开始
		def timePlanList = nts.program.domain.TimePlan.findAllByIsActive(true,[sort:"startTime", order:"asc"])
		def cronExpression = ""
		def categoryList = ["dist","reap"]
		def cronExpressionList = []	//表达式列表,二个相同的表达式会报错

		timePlanList?.each {
			//必须try捕获，否则比如年等不再可能触发的触发器会报异常，并跳出each循环
			try{
				cronExpression = nts.utils.CTools.getCronExpression(it.timePlan, it.startTime)
				//if(!cronExpressionList.contains(cronExpression)){
				JobDetail jobDetail = new JobDetail(DistributeJob.JOB_NAME,"dist_job_group_${it.id}", DistributeJob.class)
				//def trigger = new SimpleTrigger("dist_trigger_${it.id}", "dist_trigger_group_${it.id}", 100000, it.timeout)  					
				//println cronExpression
				//trigger名称，组规范：dist_trigger_${it.id},dist_trigger_group_${it.id}
				def trigger = new CronTrigger("${categoryList[it.category]}_trigger_${it.id}", "dist_trigger_group_${it.id}", cronExpression) 
				quartzScheduler.scheduleJob(jobDetail, trigger)
					
			}
			catch (Exception e){
				
				println "Exception:" + e.toString()
			}
		}
		//////////////////////////////////////////////////重新创建所有触发器 结束
		
		if(quartzScheduler.isShutdown()){
			quartzScheduler.start();
		}
		*/
	} 
	
	//开始分发或收割
	def startDistribute(triggerName,cronExpression){
		//println "start triggerName:" + triggerName + nts.utils.CTools.getNowDateTime("yyyy-MM-dd HH:mm:ss")
		String sUrl = ""
		String args = ""
		String description ="" 
		String category = "send"	//send 分发   recv 收割
		String nodeIp = ""
		String nodeName = ""
		URL url = null
		HttpURLConnection httpUrl = null

		int httpCode = 0
		

		////////////////////////////////////////////////////////////////调用分发或收割服务链接 开始
		def serverNode = null
		def videoSevr = BfConfig.getVideoSevr()
		def videoPort = BfConfig.getVideoPort()

		if(videoSevr == "") videoSevr = "127.0.0.1"
		//videoPort = "8080"	//测试用，正式须注释掉

		if(triggerName.startsWith("reap")) category = "recv"
		
		serverNode = ServerNode.findByGrade(ServerNode.GRADE_SELF)
		if(serverNode) {
			nodeName = serverNode.name.getBytes("utf-8").encodeAsBase64()
			nodeIp = serverNode.ip.encodeAsURL()
		}
		//http://192.168.1.27:1680/bmsp-task-handle/task_send?guid=d81949d1-1c8c-11e0-abd0-005056c00008&name=%s&type=send&object=1
		//http://192.168.1.128:1680/bmsp-task-handle/task_auto_send?name=5Y6m6Zeo5biC&type=send
		//sUrl = "http://${videoSevr}:${videoPort}/timPlan/testJob?category=${category}&nodeName=${serverNode?.name.encodeAsURL()}&nodeIp=${serverNode?.ip.encodeAsURL()}"
		sUrl = "http://${videoSevr}:${videoPort}/bmsp-task-handle/task_auto_send?type=${category}&name=${nodeName}&nodeIp=${nodeIp}"
		println sUrl
		try {
			url = new URL (sUrl);
			httpUrl = (HttpURLConnection)url.openConnection();
			httpUrl.setConnectTimeout(60000);//设置连接主机超时（单位：毫秒）
			httpUrl.setRequestMethod("GET"); 
			httpCode = httpUrl.getResponseCode();
			httpUrl.disconnect();
		}
		catch (Exception e) { 			     
			description = e.toString()
		}
		////////////////////////////////////////////////////////////////////调用分发或收割服务链接 结束

		
		////////////////////////////////////////////////////////////////////写入分发日志表 开始
		//直接new nts.program.domain.DistributeLog，job会由于线程问题，报错，故采用调用本机链接处理
		//def distributeLog = new nts.program.domain.DistributeLog(triggerName:triggerName,cronExpression:cronExpression,httpCode:httpCode).save(flush: true)
		def localWebPort = BfConfig.getLocalWebPort()
		if(localWebPort == "") localWebPort = "80"
		//localWebPort = "8080"	//测试用，正式须注释掉

		sUrl = "http://localhost:${localWebPort}/distributeLog/save?triggerName=${triggerName.encodeAsURL()}&cronExpression=${cronExpression.encodeAsURL()}&httpCode=${httpCode}&description=${description.encodeAsURL()}"
		//println sUrl
		try {
			url = new URL (sUrl);
			httpUrl = (HttpURLConnection)url.openConnection();
			httpUrl.setConnectTimeout(60000);//设置连接主机超时（单位：毫秒）
			httpUrl.setRequestMethod("GET"); 
			httpCode = httpUrl.getResponseCode();
			httpUrl.disconnect();
		}
		catch (Exception e) { 			     
			println "distributeLog save Exception:" + e.toString()
		}
		////////////////////////////////////////////////////////////////////////写入分发日志表 结束
	}
}
/*
调用接口说明:
http://ip:port/bmsp-task-handle/task_send?guid=&name=&type=&object=
参数说明:
ip:port ,资源发送者的ip，端口为视频服务器端口，缺省1680
guid 
name: base64(utf8(名称)) ,这个名称指的是资源接收者的名称
type: send=分发 recv=收割
object: 1 发送对象 0，不发送对象
发送成功后，返回
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<message stauts=></message>

status 含义:
success:成功
e_xxx失败
*/