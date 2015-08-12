package nts.program.domain

import nts.system.domain.Directory
import nts.system.domain.ServerNode

class DistributePolicy{
	//static belongsTo = [bbsTopic:nts.commity.domain.BbsTopic,consumer:Consumer]
	static hasMany=[serverNodes:ServerNode]
    static belongsTo = [timePlan:TimePlan]
    Set<ServerNode> serverNodes = new HashSet<ServerNode>();
	int latest = 0	//最新的
	int hot = 0	//热播的
	int toGrade = 3	//与ServerNode中grade一致 3分发到下级 4分发到联盟
	boolean isSendObject = true	//是否发送对象
    Directory directory
	Date dateCreated = new Date()			//创建时间
	Date dateModified = new Date()			//修改时间

	static constraints = {
		latest(nullable:false)
		hot(nullable:false)
        directory(nullable: true)
        timePlan(nullable: true)
	}


	final static int TO_GRADE_CHILD = 3              //分发到下级节点
	final static int TO_GRADE_UNION = 4              //分发到联盟节点
	
	//int compareTo(obj) {
       //dateCreated.compareTo(obj.dateCreated)
	   //obj.dateCreated.compareTo(dateCreated)
	//}
}
