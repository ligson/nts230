package com.boful.nts.service;

import com.boful.nts.domin.model.DirectoryModel;
import com.boful.nts.domin.model.ProgramModel
import com.boful.nts.service.model.RMSNode;
import com.boful.nts.wsdl.client.RmsNode
import com.boful.nts.domin.model.ServerNodeModel;
import nts.program.domain.Program;
import nts.system.domain.Directory;
import nts.system.domain.ServerNode;
import org.apache.poi.hssf.record.formula.functions.T;

import javax.jws.WebParam;
import javax.jws.WebService;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;
import java.util.Map;

/**
 * Created by lvy6 on 14-6-9.
 */
public interface IApp {
    /**
     * 获取rms的IP、port，bmc的IP、port、filePort
     *
     * @return
     */
    public RMSNode queryNodeInfo();

    public ServerNodeModel queryRmsServerNode();

    /**
     * 获取资源
     *
     * @param isHot 是否最热
     * @param isNew 是否最新
     * @param offset 开始行数
     * @param max 最大数
     * @return
     */
    public ArrayList<ProgramModel> queryPublicPrograms(boolean isHot, boolean isNew, int offset, int max);

    public ProgramModel queryProgramModel(String programId) throws RemoteException;

    public int invokeRmsSaveProgram(ProgramModel programModel, ServerNodeModel fromNode) throws RemoteException;

    public int queryPublicProgramTotal() throws RemoteException;

}
