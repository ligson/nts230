package nts.activity.domain

import nts.system.domain.RMSCategory
import nts.user.domain.Consumer

/**
* 活动表，因为学习社区中已有活动表Activity,为了以示区别，加了前缀User
*/
class UserActivity
{
	//consumer 活动发起者 现在必须是管理员
	static belongsTo = [consumer:Consumer]
	static hasMany = [userWorks:UserWork]

	RMSCategory activityCategory

	String name //活动标题
	String shortName	//简称
	String description //活动内容
	String startTime //活动开始时间
	String endTime //活动结束时间
	String photo //缩略图

    int approval = 2 //审批状态
    int workNum = 0 //作品数
    int voteNum = 0 //投票数 所有作品投票数之和，可能用于排序

    boolean isOpen = false //活动状态 1-开启 0-关闭

    Date dateCreated = new Date() //创建时间
    Date dateModified = dateCreated

    static mapping = {
		description  type:"text"
	}

	static constraints = {
		name(nullable:false,blank:false,maxSize:100)
		shortName(nullable:false,blank:false,maxSize:100)
		description(nullable:false,blank:false,maxSize:500)
		startTime(nullable:false,blank:false,maxSize:20)
		endTime(nullable:false,blank:false,maxSize:20)
		isOpen(nullable:false,rang:0..1)
		dateCreated(nullable:false)		
	}

	final static int NO_PASS_APPROVAL = 1 //审批未通过  对应approval
	final static int FOR_APPROVAL = 2 //待审批
	final static int PASS_APPROVAL = 3 //审批通过
}