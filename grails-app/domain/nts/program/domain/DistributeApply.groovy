package nts.program.domain

class DistributeApply{
	//static belongsTo = [bbsTopic:nts.commity.domain.BbsTopic,consumer:Consumer]
	//static hasMany=[serverNodes:nts.system.domain.ServerNode]

	String name	//名称
	String description //申请内容
	String toNodeName //针对发出的申请有用,目标节点名称 为空表示是上级节点（且是旧版时的数据）
	String fromNodeName //来源节点名称
	String fromNodeIp //来源节点IP
	String fromUser //申请人
	String contact	//联系方式
	String reply	//回复内容:type=1时是上级回复，type=2时是结下级或联盟回复
	
	int fromNodeId = 0	//来源节点id,用于上级回复本申请
	int type = 1	//类型  1收到的申请 2发出的申请
	int fromGrade = 3	//来源节点grade,与ServerNode中grade一致 用于区别是来自联盟，还是来自下级
	int toNodeId = 0	//针对发出的申请有用,申请目标节点ID，上级节点或联盟节点，是本地表中的ID,为0表示是旧系统中上级id（且是旧版时的数据）

	Date dateCreated = new Date()			//创建时间
	Date dateModified = new Date()			//修改时间

	static constraints = {
		name(nullable:false,blank:false,maxSize:250)
		description(nullable:false,blank:false,maxSize:4000)
		fromNodeName(nullable:false,blank:false,maxSize:250)
		toNodeName(nullable:true,blank:true,maxSize:250)
		fromNodeIp(nullable:false,blank:false,maxSize:250)
		fromUser(nullable:false,blank:false,maxSize:250)
		contact(nullable:true,blank:true,maxSize:250)
		reply(nullable:true,blank:true,maxSize:2000)
	}
	
	final static int TYPE_RECEIVE = 1 //1收到的申请	
	final static int TYPE_SEND = 2 //2发出的申请

	final static int FROM_GRADE_PARENT = 1              //来自上级节点
	final static int FROM_GRADE_CHILD = 3              //来自下级节点
	final static int FROM_GRADE_UNION = 4              //来自联盟节点

	/**
	update distribute_apply set to_node_id = 0 where to_node_id is null;
	update distribute_apply set from_grade = 3 where from_grade is null;
	*/
}
