package nts.system.services

import com.boful.common.file.utils.FileType
import com.boful.common.file.utils.FileUtils
import com.boful.nts.domin.model.DirectoryModel
import com.boful.nts.domin.model.ProgramModel
import com.boful.nts.domin.model.SerialModel
import com.boful.nts.service.IApp
import com.boful.nts.service.model.RMSNode
import com.boful.nts.domin.model.ServerNodeModel
import nts.program.domain.DistributeProgram
import nts.program.domain.Program
import nts.program.domain.ProgramTag
import nts.program.domain.Serial
import nts.system.domain.Directory
import nts.system.domain.ServerNode
import nts.system.domain.SysConfig
import nts.user.domain.Consumer
import com.boful.nts.BofulClassUtils;
import org.apache.catalina.Server
import org.apache.cxf.jaxws.JaxWsServerFactoryBean
import org.apache.cxf.jaxws.endpoint.dynamic.JaxWsDynamicClientFactory

import javax.jws.WebParam
import javax.jws.WebService
import java.rmi.RemoteException

class AppService implements IApp {
    static expose = ['cxf'];
    // static scope = "singleton";
    static excludes = ["initAppService"]
    private static final RMSNode rmsNode = new RMSNode();

    public void initAppService() {
        String localWebPort = SysConfig.findByConfigName('LocalWebPort')?.configValue;    //省中心web服务器端口
        String localWebIp = SysConfig.findByConfigName('LocalWebIp')?.configValue;//本地web服务器端口
        String videoServ = SysConfig.findByConfigName('VideoSevr')?.configValue;
        String videoPort = SysConfig.findByConfigName("videoPort")?.configValue;
        String serverNodePort = SysConfig.findByConfigName("serverNodePort")?.configValue;
        if (localWebIp != null) rmsNode.setRmsIPAddress(localWebIp);
        if (localWebPort != null) rmsNode.setRmsIPPort(localWebPort as int);
        if (videoServ != null) rmsNode.setBmcIPAddress(videoServ);
        if (videoPort != null) rmsNode.setBmcFilePort(serverNodePort as int);
        if (serverNodePort != null) rmsNode.setBmcWebPort(videoPort as int);
        //指定RMI服务使用的IP地址
        //System.setProperty("java.rmi.server.hostname", localWebIp);

        /* try {
             IApp iApp = new AppService();
             JaxWsServerFactoryBean factoryBean = new JaxWsServerFactoryBean();
             factoryBean.setServiceClass(IApp.class);
             factoryBean.setAddress("http://" + localWebIp + ":9000/iApp");
             factoryBean.setServiceBean(iApp);
             factoryBean.create();
             println("webService 服务器启动完成................")
         } catch (e) {
             log.error(e.getMessage());
         }*/

        /*IApp iApp = new MyApp();
        LocateRegistry.createRegistry(9999);
        Naming.bind("rmi://${InetAddress.getLocalHost().getHostAddress()}:9999/IApp",iApp);*/
    }


    @Override
    public RMSNode queryNodeInfo() throws RemoteException {
        if (!(rmsNode.getRmsIPAddress() && rmsNode.getBmcIPAddress() && rmsNode.getBmcFilePort())) {
            String localWebPort = SysConfig.findByConfigName('LocalWebPort')?.configValue;    //省中心web服务器端口
            String localWebIp = SysConfig.findByConfigName('LocalWebIp')?.configValue;//本地web服务器端口
            String videoServ = SysConfig.findByConfigName('VideoSevr')?.configValue;
            String videoPort = SysConfig.findByConfigName("videoPort")?.configValue;
            String serverNodePort = SysConfig.findByConfigName("serverNodePort")?.configValue;
            String bmcRmiPort = SysConfig.findByConfigName("bmcRmiPort")?.configValue;
            if (localWebIp != null) rmsNode.setRmsIPAddress(localWebIp);
            if (localWebPort != null) rmsNode.setRmsIPPort(localWebPort as int);
            if (videoServ != null) rmsNode.setBmcIPAddress(videoServ);
            if (serverNodePort != null) rmsNode.setBmcFilePort(serverNodePort as int);
            if (videoPort != null) rmsNode.setBmcWebPort(videoPort as int);
            if (bmcRmiPort != null) {
                rmsNode.setBmcRmiPort(bmcRmiPort as int);
            }
        }
        return rmsNode;
    }


    public ArrayList<ProgramModel> queryPublicPrograms(boolean isHot, boolean isNew, int offset, int max) {

        List<Program> programList = Program.createCriteria().list() {
            if (isHot) {
                order('frequency')
            }
            if (isNew) {
                order('dateCreated')
            }
            if (max != 0) {
                maxResults(max)
            }
            if (offset != 0) {
                firstResult(offset)
            }
            eq("state", Program.PUBLIC_STATE)
            eq("canPublic",true)
        }
        ProgramModel[] programModelList = new ProgramModel[programList.size()];
        for (int i = 0; i < programList.size(); i++) {
            Program program = programList.get(i);
            programModelList[i] = queryProgramModel(program.id.toString());
        }
        return programModelList;
    }

    /**
     * 资源转为为资源模型类
     * @param programId 资源ID
     * @return
     * @throws RemoteException
     */
    @Override
    public ProgramModel queryProgramModel(String programId) throws RemoteException {
        def res = [:];
        Program program = Program.get(programId);
        if (program) {
            ProgramModel programModel = new ProgramModel();
            BofulClassUtils.cloneObject(program, programModel);
            String tags = "";
            List<ProgramTag> programTags = ProgramTag.createCriteria().list() {
                programs {
                    eq('id', program.id)
                }
            }
            int tagTotal = programTags.size();
            if (tagTotal > 0) {
                for (int i = 0; i < tagTotal; i++) {
                    tags += programTags.get(i).name + ",";
                }
            }
            programModel.setProgramTag(tags);
            Directory directory = program.directory
            DirectoryModel directoryModel = new DirectoryModel();
            BofulClassUtils.cloneObject(directory, directoryModel);
            programModel.setClassLib(directoryModel);
            List<Serial> serialList = Serial.findAllByProgram(program);
            SerialModel[] serialModels = new SerialModel[serialList.size()];
            for (int j = 0; j < serialList.size(); j++) {
                Serial serial = serialList.get(j);
                SerialModel serialModel = new SerialModel();
                BofulClassUtils.cloneObject(serial, serialModel);
                serialModels[j] = serialModel;
                serialModel.setProgramId(programModel.getId());
            }
            programModel.setSerials(serialModels);
            return programModel;
        } else {
            return null
        }

    }
    /***
     * 通知rms保存资源信息
     * @param programModel 资源模型
     * @param fromNode 源节点
     * @return 执行结果 succes:true/false
     * @throws RemoteException
     */
    @Override
    public int invokeRmsSaveProgram(ProgramModel programModel, ServerNodeModel fromNode) throws RemoteException {
        //###################################     num数字代表    #####################################
        //1:资源已存在   2:保存资源类库失败   3:分发完成   4:保存资源serial类失败   5:保存资源失败
        //####################################################################################
        int num = 0;
        String str1 = "";
        Directory directory = null;
        DirectoryModel directoryModel = programModel.getClassLib();
        System.out.println("directoryModel:----" + directoryModel.toString() + "-------------------------")
        //判断资源是否存在
        //TODO 现阶段只支持判断guid，暂时不支持资源版本控制
        Program program1 = Program.findByGuid(programModel.getGuid());
        System.out.println("program1:----" + program1.toString() + "------------------------")
        if (program1) {
            num = 1;
            str1 = "资源已存在";
            return num;
        }
        //save directory
        if (directoryModel) {
            directory = Directory.findByName(directoryModel.name);
            if (!directory) {
                directory = new Directory();
                BofulClassUtils.cloneObject(directoryModel, directory);
                if (directory.save(flush: true) && directory.hasErrors()) {
                    num = 2;
                    str1 = "保存资源类库失败";
                    log.error(directory.errors.allErrors);
                    System.out.println("dir error:------" + directory.errors.allErrors + "--------------------")
                }
            }
        }
        Program program = new Program();

        BofulClassUtils.cloneObject(programModel, program);
        program.directory = directory;
        program.classLib = directory;

        //TODO 默认接收到的资源为待审批入库
        program.state = 3;
        program.consumer = Consumer.findByName("master");
        program.fromId = programModel.id as int;

        //from node info
        if (fromNode) {
            ServerNode serverNode = ServerNode.findByIpAndPort(fromNode.ip, fromNode.port)
            if (serverNode) {
                program.fromNodeId = serverNode.getId();
                program.fromNodeIp = serverNode.getIp();
                program.fromNodeName = serverNode.getName();
                RMSNode rmsNode1 = queryNodeInfo();
                ServerNode localNode = ServerNode.findByIpAndPort(rmsNode1.getRmsIPAddress(), rmsNode1.getRmsIPPort());
                if (serverNode == localNode) {
                    program.fromState = Program.FROM_STATE_SELF;
                } else {
                    if (serverNode.grade > localNode.grade) {
                        program.fromState = Program.FROM_STATE_HARVEST;
                    } else {
                        program.fromState = Program.FROM_STATE_DISTRIBUTE;
                    }
                }
            } else {
                program.fromState = Program.FROM_STATE_SELF;
            }
        } else {
            program.fromState = Program.FROM_STATE_SELF;
        }

        //program tag
        if (programModel.programTag != null) {
            String str = programModel.programTag;
            if (str.indexOf(',') != -1) {
                String[] strings = str.split(',');
                for (int i = 0; i < strings.size(); i++) {
                    ProgramTag tag = new ProgramTag();
                    tag.dateModified = new Date();
                    tag.name = strings[i];
                    if (tag.save(flush: true) && (!tag.hasErrors())) {
                        tag.addToPrograms(program);
                        program.addToProgramTags(tag);
                    } else {
                        log.error(tag.errors.allErrors)
                        System.out.println("tag error---------" + tag.errors.allErrors + "------------------")
                    }
                }
            }
        }

        //serial
        if (program.save(flush: true) && !program.hasErrors()) {
            //serial save
            for (SerialModel serialModel : programModel.serials) {
                Serial serial = new Serial();
                BofulClassUtils.cloneObject(serialModel, serial);
                if (fromNode.isSendObject()) {
                    serial.svrAddress = rmsNode.getBmcIPAddress();
                    serial.svrPort = rmsNode.getBmcWebPort();
                } else {
                    serial.svrAddress = fromNode.getIp();
                    serial.svrPort = fromNode.getPort();
                }

                serial.name = serialModel.getName();
                serial.id = null;
                serial.dateModified = new Date();
                serial.program = program;
                if (serial.validate()) {
                    //serial.save(flush:true);
                    program.getSerials().add(serial);
                    program.serialNum++;
                    program.save(flush: true);
                    num = 3;
                } else {
                    num = 4
                    log.error(serial.errors.allErrors)
                    System.out.println("serial error ------" + serial.errors.allErrors + "-------------------")
                }

            }

            DistributeProgram distributeProgram = new DistributeProgram();
            distributeProgram.program = program;
            distributeProgram.fromProgramId = programModel.id;
            //如果本地节点grade比fromNode高
            distributeProgram.isDistribute = false;
            distributeProgram.isSendObject = fromNode.isSendObject();
            distributeProgram.save();
        } else {
            num = 5
            log.error(program.errors.allErrors)
        }


        return num;
    }

    @Override
    public ServerNodeModel queryRmsServerNode() throws RemoteException {
        ServerNodeModel serverNodeModel = new ServerNodeModel();
        RMSNode rms = queryNodeInfo();
        ServerNode serverNode = null;
        if (rms.getBmcIPAddress() != null && rms.getRmsIPPort() != null) {
            serverNode = ServerNode.findByIpAndPort(rms.getRmsIPAddress(), rms.getRmsIPPort() as int);
            if (serverNode) {
                BofulClassUtils.cloneObject(serverNode, serverNodeModel)
            }
        }
        return serverNodeModel
    }

    @Override
    public int queryPublicProgramTotal() throws RemoteException {
        return Program.countByStateAndCanPublic(Program.PUBLIC_STATE,true);
    }

}
