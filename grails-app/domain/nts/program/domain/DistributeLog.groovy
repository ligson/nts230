package nts.program.domain

class DistributeLog {
	//日志只是流水记录，故不须与其它表关联
	//static belongsTo = 

    String triggerName				//触发器名dist_trigger_${timePlan.id}
	String cronExpression				//cron表达式
	String description				//描述

	int httpCode = 0					//http响应code
	
	Date dateCreated = new Date()				//操作时间 
	
	//大部分属性可为空，为以后扩展用，程序员据操作重要性方便性，设置相关属性
	static constraints = {
		triggerName(nullable:false,blank:false,maxSize:250)
		cronExpression(nullable:false,blank:false,maxSize:250)
		description(nullable:true,blank:true,maxSize:1000)
		httpCode(nullable:false)
	}

}