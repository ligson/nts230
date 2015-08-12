package nts.user.domain

class IpAddress{
	static belongsTo = [userGroup:UserGroup]
	
	String name	//IP地址段名称
	String beginIp		//开始IP
	String endIp		//结束IP
	String description //描述

	int priLevel = 0	//权限数值
	int bandWidth = 0	//带宽限制
	int ipOrder = 0	//优先级
	int firstSvr = 0	//就近服务器1
	int secondSvr = 0	//就近服务器2

	boolean isActive = true	//是否禁用
	boolean isAllGroup = true	//使用所有组的权限 可能以后会用
	
	Date dateCreated = new Date()			//创建时间
	Date dateModified = new Date()			//修改时间

	static constraints = {
		name(nullable:false,blank:false,maxSize:250)
		beginIp(nullable:false,blank:false,maxSize:250)
		endIp(nullable:false,blank:false,maxSize:250)
		description(nullable:true,blank:true,maxSize:250)
	}
	
	def beforeUpdate = {
		dateModified = new Date()
	}
}
