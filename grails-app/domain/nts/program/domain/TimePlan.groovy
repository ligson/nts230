package nts.program.domain

class TimePlan{
	static hasMany = [distributePolicys:DistributePolicy]
	String name	//时间计划名称
	String descriptions		//描述信息

	int timePlan = 0	//0天 1周  2月  3年
	int startTime = 0	//计划开始时间
	int endTime = 0	//计划结束时间
	int timeOrder = 0	//优先级
	int category = 0	//0分发 1收割

	boolean isActive = true	//是否启用

    String expression
	
	Date dateCreated = new Date()			//创建时间

	static constraints = {
		name(nullable:false,blank:false,maxSize:250)
		descriptions(nullable:true,blank:true,maxSize:250)
		startTime(nullable:false)
		endTime(nullable:false)
        expression(nullable: true)
        distributePolicys(nullable: true)
	}
	
	//时间计划
	final static int TIME_PLAN_DAY = 0	//按天
    final static int TIME_PLAN_WEEK = 1	//按周
    final static int TIME_PLAN_MONTH = 2	//按月
	final static int TIME_PLAN_YEAR = 3	//按年

	//类别
	final static int CATEGORY_DISTRIBUTE = 0	//用于分发
    final static int CATEGORY_HARVEST = 1	//用于收割

	final static CN_CATEGORY = [
		0:'分发',		
		1:'收割'
	] 

	def afterInsert = {
		//distributeService.restartDistributeJob()	//记得放到对应controller
	}

	def afterUpdate = {
		//distributeService.restartDistributeJob()
	}

	def afterDelete = {
		//distributeService.restartDistributeJob()
	}
}
