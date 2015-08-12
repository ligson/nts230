package nts.system.domain

import nts.system.domain.OperationEnum

class OperationLog {
	//操作日志只是流水记录，不必因操作人员或相关表被删除就删除其日志，故不须与其它表关联
	//static belongsTo = 

        String tableName				//表名
	int tableId						//相关表主键值
	String tableField				//被修改的字段 比如资源状态
	String oldValue				//修改前值
	String newValue				//修改后值
	String operator				//操作人：用户名或呢称 个人倾向于用户名，因为呢称易变
	String operatorIP				//操作人的IP
	String modelName				//操作模块
	String brief					//备注 操作资源时可用资源名称

	int operatorId					//操作人在consmer中ID 注意：可能据此查不出用户信息（如果该用户被删除）	
	OperationEnum operation		//操作 枚举:登录，资源添加，资源修改等
	
	Date dateCreated				//操作时间 
	
	//大部分属性可为空，为以后扩展用，程序员据操作重要性方便性，设置相关属性
	static constraints = {
		tableName(nullable:true,blank:true,maxSize:100)
		tableId(nullable:true)
		tableField(nullable:true,blank:true,maxSize:100)
		oldValue(nullable:true,blank:true,maxSize:250)
		newValue(nullable:true,blank:true,maxSize:250)
		operator(nullable:false,blank:false,maxSize:100)
		operatorIP(nullable:true,blank:true,maxSize:100)
		modelName(nullable:true,blank:true,maxSize:100)
		brief(nullable:true,blank:true,maxSize:250)
		operatorId(nullable:true)
	}

	def beforeInsert = {
		dateCreated = new Date()
		
	}

	String toString() { operator }
}