package nts.system.domain

import nts.program.domain.DistributePolicy
import nts.program.domain.DistributeProgram

class ServerNode{
	static belongsTo = DistributePolicy
	static hasMany = [distributePolicys:DistributePolicy,distributePrograms:DistributeProgram]

	String name	//名称
	String ip	//ip
	int port = 1680	//上传端口
	int webPort = 80	//web端口
	String distriPath = ""	//分发节目预存路径，路径分隔符统一用"/"
	String harvestPath = ""		//收割节目预存路径，路径分隔符统一用"/"
	String descriptions	=""	//节点描述信息

	int parentId = 0	//上级节点ID,根节点parentId=0,为了简单，没有用对象类型，删除节点时注意手工维护数据完整性
	int showOrder = 0	//排序号
	int grade = 1	//级别

	boolean isSendObject = false	//缺省是否发送对象

	Date dateCreated = new Date()			//创建时间

	static constraints = {
		name(unique:true, nullable:false, blank:false, maxSize:250)
        //, matches:/^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$/
		ip(nullable:false, blank:false, maxSize:250)
		port(nullable:false, blank:false, validator:{return it < 65536}, maxSize:20)
		webPort(nullable:false, blank:false, validator:{return it < 65536}, maxSize:20)
		distriPath(nullable:true, blank:true, maxSize:500)
		harvestPath(nullable:true, blank:true, maxSize:500)
		descriptions(nullable:true, blank:true, maxSize:250)
		parentId(nullable:true)
		showOrder(nullable:true)
		grade(nullable:true)
	}

	//int compareTo(obj) {
       //dateCreated.compareTo(obj.dateCreated)
	   //obj.dateCreated.compareTo(dateCreated)
	//}

    final static int GRADE_PARENT = 1          //上级节点
    final static int GRADE_SELF = 2               //本节点
    final static int GRADE_CHILD = 3              //下级节点
	final static int GRADE_UNION = 4              //联盟节点的parentId用本节点的parentId

	final static cnGrade = [
		1:'上级节点',		
		2:'本节点',
		3:'下级节点',
		4:'联盟节点'
	] 

	//ALTER TABLE server_node MODIFY distri_path varchar(500) NULL;
	//ALTER TABLE server_node MODIFY harvest_path varchar(500) NULL;
	//ALTER TABLE server_node MODIFY port int not NULL;
}