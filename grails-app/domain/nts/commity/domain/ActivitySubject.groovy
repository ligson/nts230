package nts.commity.domain

import nts.user.domain.Consumer

/**
* 活动建议
*/
class ActivitySubject
{
	//nts.commity.domain.Activity activity 活动 n：1
	//nts.user.domain.Consumer createConsumer 活动建议者 n：1
	static belongsTo = [activity:Activity, createConsumer:Consumer]

	String description //建议内容
	Date dateCreated = new Date() //创建时间

	static mapping = {
		description  type:"text"
	}

	static constraints = {
		description(nullable:false,blank:false,maxSize:500)
		dateCreated(nullable:false)		
	}
}