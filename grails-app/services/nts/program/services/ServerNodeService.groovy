package nts.program.services

import com.boful.common.file.utils.FileType
import com.boful.nts.BofulClassUtils
import com.boful.nts.domin.model.DirectoryModel
import com.boful.nts.domin.model.ProgramModel
import com.boful.nts.service.IApp
import com.boful.nts.wsdl.client.AppService
import com.boful.nts.wsdl.client.AppServicePortType
import com.boful.nts.service.model.RMSNode
import com.boful.nts.wsdl.client.RmsNode
import com.boful.nts.wsdl.client.SerialModel
import com.boful.nts.wsdl.client.ServerNodeModel
import grails.converters.JSON
import nts.program.domain.Program
import nts.program.domain.Serial
import nts.system.domain.Directory
import nts.system.domain.ServerNode
import nts.system.domain.SysConfig
import org.apache.cxf.jaxws.JaxWsProxyFactoryBean
import org.apache.http.HttpStatus
import org.apache.http.client.entity.UrlEncodedFormEntity
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpPost
import org.apache.http.impl.client.CloseableHttpClient
import org.apache.http.impl.client.HttpClients
import org.apache.http.message.BasicNameValuePair
import org.codehaus.groovy.grails.web.json.JSONElement
import org.omg.CORBA.NameValuePair
import org.springframework.remoting.rmi.RmiProxyFactoryBean

class ServerNodeService {
    def appService
    def utilService
    def grailsApplication
    /**
     * 分发
     * @param params
     * @return
     */
    public Map sendProgram(Map params) {
        def res = [:];
        Program program = Program.get(params.programId as Long);
        ServerNode serverNode = ServerNode.get(params.serverNodeId as Long);
        if (program && serverNode) {
            RMSNode rmsNode = utilService.findLocalNode();
            String localIP = rmsNode.getRmsIPAddress();
            String localPort = rmsNode.getRmsIPPort();
            ServerNode localNode = ServerNode.findByIpAndPort(localIP, localPort as int);
            if (localNode) {
                if (localNode.id == serverNode.id) {
                    res.success = false;
                    res.msg = "请重新选择节点,不需要往本地节点分发资源";
                } else {
                    //###############判断本地节点是否要发送原始文件#######################
                    if (localNode.isSendObject) {
                        //#####################发送原始文件#############################
                        res = sendFile(serverNode, program);
                        //###########success=true时表示发送完成#########################
                        if (res.success) {
                            //############发送完成后进行资源信息存储##########################
                            res = saveProgram(serverNode, program, localNode);
                        }
                    } else {
                        //############发送完成后进行资源信息存储##########################
                        res = saveProgram(serverNode, program, localNode);
                    }
                }
            } else {
                res.success = false;
                res.msg = "请先在系统设置中配置本地IP、Port";
            }

        }
        return res
    }
    /**
     * 发送文件
     * @return
     */
    public Map sendFile(ServerNode serverNode, Program program) {
        def res = [:];
        def serials = Serial.findAllByProgram(program);
        List<String> hashArr = new ArrayList<String>();
        serials.each {
            hashArr.add(it.fileHash);
        }
        AppServicePortType iApp = queryHttpProtocol(serverNode);
        RmsNode rmsNode = iApp.queryNodeInfo();
        if ((rmsNode.getBmcIPAddress() == null) || (rmsNode.getBmcWebPort().toString() == null)) {
            res.success = false;
            res.msg = serverNode.ip + "系统设置中文件服务器配置不完善";
        } else {
            def videoServ = SysConfig.findByConfigName('VideoSevr')?.configValue;
            def videoPort = SysConfig.findByConfigName("videoPort")?.configValue;
            def serverNodePort = SysConfig.findByConfigName("serverNodePort")?.configValue;
            String conv_url = "http://" + videoServ + ":" + videoPort + "/bmc/distribution/send";
            try {
                CloseableHttpClient httpClient = HttpClients.createDefault();
                HttpPost httpPost = new HttpPost(conv_url);
                List<NameValuePair> lists = new ArrayList<NameValuePair>();
                lists.add(new BasicNameValuePair("address", rmsNode.getBmcIPAddress()));
                lists.add(new BasicNameValuePair("port", rmsNode.getBmcFilePort().toString()));
                hashArr.each {
                    lists.add(new BasicNameValuePair("hashArr", it));
                }
                httpPost.setEntity(new UrlEncodedFormEntity(lists));
                CloseableHttpResponse response = httpClient.execute(httpPost);
                String text = response.getEntity().getContent().getText("UTF-8");
                if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
                    JSONElement result = JSON.parse(text);
                    if (result.success) {
                        res.success = true;
                    }
                } else {
                    res.success = false;
                    res.msg = videoServ + "服务器内部错误";
                    log.error(res.msg)
                }
            } catch (e) {
                res.success = false;
                res.msg = e.getMessage();
                log.error(res.msg)
            }
        }


        return res
    }

    /***
     * 保存资源信息
     * @param serverNode 目标节点
     * @param program 资源
     * @param localNode 本地节点
     * @return
     */
    public Map saveProgram(ServerNode serverNode, Program program, ServerNode localNode) {
        def res = [:];
        def serials = Serial.findAllByProgram(program);
        try {
            /* RmiProxyFactoryBean factoryBean = new RmiProxyFactoryBean();
             factoryBean.setServiceUrl("rmi://${serverNode.ip}:9999/AppService");
             factoryBean.setServiceInterface(IApp.class)
             factoryBean.afterPropertiesSet();
             IApp iApp = (IApp) factoryBean.getObject();*/
            AppServicePortType iApp = queryHttpProtocol(serverNode);
            com.boful.nts.wsdl.client.ProgramModel programModel = new com.boful.nts.wsdl.client.ProgramModel();
            com.boful.nts.wsdl.client.DirectoryModel directoryModel = new com.boful.nts.wsdl.client.DirectoryModel();
            ServerNodeModel serverNodeModel = new ServerNodeModel();
            BofulClassUtils.cloneObject(localNode, serverNodeModel);
            BofulClassUtils.cloneObject(program, programModel);
            Directory directory = program?.directory;
            BofulClassUtils.cloneObject(directory, directoryModel);
            programModel.setClassLib(directoryModel);
            program.serials?.toList().each {
                SerialModel serialModel = new SerialModel();
                BofulClassUtils.cloneObject(it, serialModel);
                programModel.getSerials().add(serialModel);
            }
            RmsNode rmsNode = iApp.queryNodeInfo();
            serverNodeModel.setIp(rmsNode.getBmcIPAddress());
            serverNodeModel.setPort(rmsNode.getBmcWebPort());

            ServerNodeModel fromNode = new ServerNodeModel();
            BofulClassUtils.cloneObject(serverNode, fromNode);

            int num = iApp.invokeRmsSaveProgram(programModel, fromNode);
            res = returnInformation(num);
        } catch (e) {
            res.success = false;
            res.msg = e.getMessage();
            log.error(res.msg);
        }
        return res
    }
    /**
     * 返回分发收割后的资源信息
     * @param num
     * @return
     */
    public Map returnInformation(int num) {
        def result = [:];
        //###################################     num数字代表    #####################################
        //1:资源已存在   2:保存资源类库失败   3:分发完成   4:保存资源serial类失败   5:保存资源失败
        //####################################################################################
        if (num == 1) {
            result.success = true;
            result.msg = "资源已存在";
        } else if (num == 2) {
            result.success = false;
            result.msg = "保存资源类库失败";
        } else if (num == 3) {
            result.success = true;
            result.msg = "分发完成"
        } else if (num == 4) {
            result.success = false;
            result.msg = "保存资源serial类失败"
        } else if (num == 5) {
            result.success = false;
            result.msg = "保存资源失败"
        }
        return result
    }
    /**
     * 收割资源
     * @param params[programId :要收割资源id,serverNodeId:资源所在服务器]
     * @return
     */
    public Map receiveProgram(Map params) {
        def res = [:];
        List<String> hashArr = [];
        def programId = params.programId;
        //TODO 以ip和端口区分 id不准确
        def serverNodeId = params.serverNodeId;
        //######开始#############判断系统管理中系统设置是否完善#############################
        ServerNode localServerNode = utilService.findLocalServerNode();
        RMSNode localNode = utilService.findLocalNode();
        if ((!localServerNode) || (!localNode)) {
            res.success = false;
            res.msg = "本地服务器节点未配置!";
            return res;
        }
        //#######结束############判断系统管理中系统设置是否完善#############################

        def videoServ = localNode.getBmcIPAddress();
        def videoPort = localNode.getBmcWebPort();
        def serverNodePort = localNode.getBmcFilePort();

        //from node
        ServerNode serverNode = ServerNode.get(serverNodeId as Long);
        if (serverNode) {
            if (serverNode.id == localServerNode.id) {
                res.success = false;
                res.msg = "请重新选择节点,不需要去收割本地资源";
            } else {
                try {
                    //###############获取远程调用方法接口#########################
                    AppServicePortType iApp = queryHttpProtocol(serverNode);
                    //###############远程调用方法################################
                    com.boful.nts.wsdl.client.ProgramModel programModel = iApp.queryProgramModel(programId.toString());
                    programModel?.serials?.toList()?.each {
                        hashArr.add(it.fileHash);
                    }
                    //###############远程调用方法################################
                    ServerNodeModel serverNodeModel = iApp.queryRmsServerNode();
                    //###########判断服务器系统管理中系统设置是否完善#############################
                    if ((serverNodeModel.getIp() == null) || (serverNodeModel.getPort() == null)) {
                        res.success = false;
                        res.msg = serverNode.ip + "系统设置中未配置本地服务器IP、Port";
                    } else {
                        //#####################收割资源#########################
                        res = receiveFile(serverNode, hashArr);
                        //success=true时对资源进行保存########################
                        if (res.success) {
                            if (programModel.classLib) {
                                //###########开始#########两个类之间,类名、属性名、属性类型一致，包名不一致,进行相互赋值############
                                com.boful.nts.domin.model.ServerNodeModel localServerNodeModel = new com.boful.nts.domin.model.ServerNodeModel();
                                BofulClassUtils.cloneObject(serverNodeModel, localServerNodeModel);
                                ProgramModel localProgramModel = new ProgramModel();
                                BofulClassUtils.cloneObject(programModel, localProgramModel);
                                DirectoryModel localDirectoryModel = new DirectoryModel();
                                BofulClassUtils.cloneObject(programModel.getClassLib(), localDirectoryModel);
                                com.boful.nts.domin.model.SerialModel[] serialModels = new com.boful.nts.domin.model.SerialModel[programModel.getSerials().size()];
                                for (int i = 0; i < programModel.getSerials().size(); i++) {
                                    com.boful.nts.domin.model.SerialModel localSerialModel = new com.boful.nts.domin.model.SerialModel();
                                    BofulClassUtils.cloneObject(programModel.getSerials().get(i), localSerialModel);
                                    serialModels[i] = localSerialModel;
                                }
                                localProgramModel.setSerials(serialModels);
                                localProgramModel.setClassLib(localDirectoryModel);
                                //#########结束###########两个类之间,类名、属性名、属性类型一致，包名不一致,进行相互赋值############

                                //############保存收割过来的资源信息#########################################
                                RmsNode rmsNode = iApp.queryNodeInfo();
                                localServerNodeModel.setIp(rmsNode.getBmcIPAddress());
                                localServerNodeModel.setPort(rmsNode.getBmcWebPort());


                                com.boful.nts.domin.model.ServerNodeModel fromServerNode = new com.boful.nts.domin.model.ServerNodeModel();
                                BofulClassUtils.cloneObject(serverNode, fromServerNode);
                                int num = appService.invokeRmsSaveProgram(localProgramModel, fromServerNode);
                                //######################返回保存资源的提示信息######################
                                res = returnInformation(num);
                                if (res.success) res.msg = "收割完成!";
                            } else {
                                res.success = false;
                                res.msg = "类库不存在";
                            }
                        }
                    }

                } catch (e) {
                    res.success = false;
                    res.msg = e.getMessage();
                }
            }

        }
        return res
    }

    public Map receiveFile(ServerNode serverNode, List hashArr) {
        def res = [:];
        def videoServ = SysConfig.findByConfigName('VideoSevr')?.configValue;
        def videoPort = SysConfig.findByConfigName("videoPort")?.configValue;
        def serverNodePort = SysConfig.findByConfigName("serverNodePort")?.configValue;
        AppServicePortType iApp = queryHttpProtocol(serverNode);
        RmsNode rmsNode = iApp.queryNodeInfo();
        if ((rmsNode.getBmcIPAddress() == null) || (rmsNode.getBmcWebPort().toString() == null)) {
            res.success = false;
            res.msg = serverNode.ip + "系统设置中文件服务器配置不完善";
        } else {
            try {
                String conv_url = "http://" + videoServ + ":" + videoPort + "/bmc/distribution/receive";
                CloseableHttpClient httpClient = HttpClients.createDefault();
                HttpPost httpPost = new HttpPost(conv_url);
                List<NameValuePair> lists = new ArrayList<NameValuePair>();
                lists.add(new BasicNameValuePair("address", rmsNode.getBmcIPAddress()));
                lists.add(new BasicNameValuePair("port", rmsNode.getBmcFilePort().toString()));
                hashArr.each {
                    lists.add(new BasicNameValuePair("hashArr", it));
                }
                httpPost.setEntity(new UrlEncodedFormEntity(lists));
                CloseableHttpResponse response = httpClient.execute(httpPost);
                String text = response.getEntity().getContent().getText("UTF-8");
                if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
                    JSONElement result = JSON.parse(text);
                    if (result.success) {
                        res.success = true;
                    } else {
                        res.success = false;
                        res.msg = "连接失败";
                        log.error(res.msg)
                    }
                } else {
                    res.success = false;
//                    res.msg = text;
                    res.msg = "${serverNode.ip}连接失败";
                    log.error(res.msg)
                }
            } catch (e) {
                res.success = false;
                res.msg = e.getMessage();
            }
        }

        return res;
    }


    public Map queryReceiveProgram(Map params) {
        List<String> hashList = new ArrayList<String>();
        if (params.hashArr instanceof String) {
            hashList.add(params.hashArr);
        } else {
            hashList = params.hashArr;
        };
        def videoServ = SysConfig.findByConfigName('VideoSevr')?.configValue;
        def videoPort = SysConfig.findByConfigName("videoPort")?.configValue;
        String conv_url = "http://" + videoServ + ":" + videoPort + "/bmc/distribution/send";
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpPost httpPost = new HttpPost(conv_url);
        List<NameValuePair> lists = new ArrayList<NameValuePair>();
        lists.add(new BasicNameValuePair("address", params.address));
        lists.add(new BasicNameValuePair("port", params.port));
        hashList.each {
            lists.add(new BasicNameValuePair("hashArr", it));
        }
        httpPost.setEntity(new UrlEncodedFormEntity(lists));
        CloseableHttpResponse response = httpClient.execute(httpPost);
        String text = response.getEntity().getContent().getText("UTF-8");
        if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
            JSONElement result = JSON.parse(text);
            return result
        } else {
            def result = [:];
            result.success = false;
            result.msg = text;
            return result
        }
    }

    public Map queryAllProgramHash(Map params) {
        def result = [:];
        Program program;
        List<String> hashArr = new ArrayList<String>();
        if (params.programId) {
            program = Program.get(params.programId as Long);
            program.serials.each { serial ->
                hashArr.add(serial.fileHash);
            }
        }
        result.hashArr = hashArr;
        result.program = program;
        return result;
    }

    public Map queryAllProgram(Map params) {
        def result = [:];
        def max;
        def offset;
        if (params.max instanceof String) {
            max = params.max as int;
        } else {
            max = params.max;
        }
        if (params.offset instanceof String) {
            offset = params.offset as int;
        } else {
            offset = params.offset;
        }
        def programList = Program.list(max: max, offset: offset);
        result.programList = programList;
        result.total = Program.count();
        return result;
    }

    public Map saveProgram(Map params) {
        def result = [:];
        List<String> hashList = new ArrayList<String>();
        List<String> typeList = new ArrayList<String>();
        List<String> pathList = new ArrayList<String>();
        if (params.hashArr instanceof String) {
            hashList.add(params.hashArr);
        } else {
            hashList = params.hashArr;
        };
        if (params.typeArr instanceof String) {
            typeList.add(params.typeArr);
        } else {
            typeList = params.typeArr;
        };
        if (params.pathArr instanceof String) {
            pathList.add(params.pathArr);
        } else {
            pathList = params.pathArr;
        };
        Directory directory = Directory.findByNameIlike(params.classLibName);
        if (!directory) {
            directory = new Directory(
                    parentId: 0,
                    name: params.classLibName,
                    canUpload: true,
                    allGroup: true,
                    classId: 0,
                    childNumber: 0,
                    description: params.classLibName
            );
            directory.save(flush: true);
        }
        Program program = new Program();
        program.name = params.name;
        program.classLib = directory;
        program.otherOption = params.otherOption as int;
        program.directory = program?.classLib;
        program.state = Program.APPLY_STATE;
        program.consumer = params.consumer;
        program.fromId = params.id as int;
        program.dateCreated = new Date()
        if (program.save(flush: true) && !program.hasErrors()) {
            for (int i = 0; i < hashList.size(); i++) {
                def urlType = 1;
                if (FileType.isVideo(typeList[i])) {
                    urlType = Serial.URL_TYPE_VIDEO;
                } else if (FileType.isDocument(typeList[i])) {
                    urlType = Serial.URL_TYPE_DOCUMENT;
                } else if (FileType.isImage(typeList[i])) {
                    urlType = Serial.URL_TYPE_IMAGE;
                }
                Serial serial = new Serial(
                        name: hashList[i],
                        serialNo: i + 1,
                        urlType: urlType,
                        fileHash: hashList[i],
                        fileType: typeList[i],
                        filePath: pathList[i],
                        dateCreated: new Date(),
                        dateModified: new Date(),
                        program: program
                );
                if (serial.save(flush: true) && (!serial.hasErrors())) {
                    program.addToSerials(serial);
                    result.success = true;
                    result.msg = "分发完成";
                }
            }
        } else {
            result.success = false;
            result.msg = "分发失败";
        }
        return result
    }

    public void saveServerNode(String ip, int port) {
        ServerNode serverNode = ServerNode.findByIpAndPort(ip, port)
        if (!serverNode) {
            serverNode = new ServerNode();
            serverNode.name = ip;
            serverNode.ip = ip;
            serverNode.port = port;
            serverNode.save(flush: true);
        }
    }

    public AppServicePortType queryHttpProtocol(ServerNode serverNode) {
        /*JaxWsProxyFactoryBean factoryBean = new JaxWsProxyFactoryBean();
        factoryBean.setServiceClass(IApp.class);
        factoryBean.setAddress("http://"+serverNode.ip+":9000/iApp");
        IApp iApp = (IApp)factoryBean.create();*/
        def contextPath = grailsApplication.metadata['app.context'];
        if ("/".equals(contextPath)) {
            contextPath = '';
        }
        AppService appService = new AppService(new URL("http://" + serverNode.ip + ":8080" + contextPath + "/services/app?wsdl"));
        AppServicePortType portType = appService.getAppServicePort();
        return portType;
    }


}
