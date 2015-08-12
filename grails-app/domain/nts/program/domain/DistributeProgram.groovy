package nts.program.domain

import nts.system.domain.ServerNode

class DistributeProgram {
	static belongsTo = [program:Program,serverNode:ServerNode]
	
	int state = 0	//分发状态:0未分发，1已分发
	int fromProgramId = 0	//资源原始ID

	boolean isSendObject = true	//缺省是否发送对象
	boolean isDistribute = true	//是分发还是收割


	Date dateCreated = new Date()
	Date dateModified = new Date()

	//分发状态
	final static int STATE_NO_DISTRIBUTED = 0 //未分发	
	final static int STATE_DISTRIBUTED = 1 //已分发
	final static int STATE_UPDATE = 2 //更新

	//insert into sys_config(version,config_desc,config_mod,config_name,config_scope,config_value) values(0,'分发模块状态','0','DistributeModState',0,'1')
}
