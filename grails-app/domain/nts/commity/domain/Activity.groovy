package nts.commity.domain

import nts.user.domain.Consumer

/**
* 活动
*/
class Activity
{
	//nts.commity.domain.StudyCommunity studyCommunity 学习社区 n：1
	//nts.user.domain.Consumer createConsumer 创建活动者 n：1
	//nts.commity.domain.ActivitySubject activitySubject 活动建议 1：n
	static belongsTo = [studyCommunity:StudyCommunity, createConsumer:Consumer]
	static hasMany = [activitySubject:ActivitySubject]

	String name //活动标题
	String description //活动内容
	String startTime //活动开始时间
	String endTime //活动结束时间
	boolean isOpen = true //活动状态 1-开启 0-关闭
	Date dateCreated = new Date() //创建时间
    String photo;
	static mapping = {
		description  type:"text"
	}

	static constraints = {
		name(nullable:false,blank:false,maxSize:100)
		description(nullable:false,blank:false,maxSize:500)
		startTime(nullable:false,blank:false,maxSize:20)
		endTime(nullable:false,blank:false,maxSize:20)
		isOpen(nullable:false,rang:0..1)
		dateCreated(nullable:false)
        photo(nullable:true)
	}

	final static int ACTIVITY_STATE_OPEN = 1 //活动状态 1-开启
	final static int ACTIVITY_STATE_CLOSE = 0 //活动状态 0-关闭

}