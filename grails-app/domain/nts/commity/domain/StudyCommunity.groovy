package nts.commity.domain

import nts.commity.domain.Activity
import nts.commity.domain.ForumBoard
import nts.commity.domain.Notice
import nts.commity.domain.Sharing
import nts.system.domain.RMSCategory
import nts.user.domain.Consumer

/**
* 学习社区
*/
class StudyCommunity
{
	//nts.user.domain.Consumer createConsumer 创建者 n：1
	//nts.user.domain.Consumer members 成员 n：n
	//nts.commity.domain.Notice notice 公告 1：n
	//nts.commity.domain.Sharing sharing 共享 1：n
	//Forum forum 跟讨论区 1:1
	//nts.commity.domain.Activity activity 活动 1：n
	//nts.system.domain.RMSCategory category 类别 n：1
	//nts.system.domain.LogsPublic communityLog 社区内动态（日志） 1：n\

	//Forum forum
	RMSCategory communityCategory
	static hasMany = [members:Consumer, notices:Notice, sharings:Sharing, activitys:Activity, forumBoards:ForumBoard]//, communityLogs:nts.system.domain.LogsPublic

	int create_comsumer_id = 0 //创建者id
	String name //学习社区标题
	String photo //缩略图
    String bgPhoto //顶部背景图片
	String description //简介
	int visit = 0 //浏览量
    int articleCount = 0;
	Date dateCreated = new Date() //创建时间
    int state = 2 //学习社区在系统中的状态 0-已禁用 1-已通过 2-审核中 / 以弃*3-申请中*/
    int membersCount = 0 //社区成员数量，根据加入的成员Consumer进行动态更新
	boolean isRecommend = false //是否为推荐学习社区 true-推荐 false-不推荐

	static mapping = {
		description  type:"text"
	}

	static constraints = {
		create_comsumer_id(nullable:false)
		name(nullable:false,blank:false,maxSize:100)
		photo(nullable:false,blank:false,maxSize:100)
        bgPhoto(nullable:false,maxSize:100)
		visit(nullable:false)
		description(nullable:false,blank:false,maxSize:500)
		state(nullable:false,rang:0..2)
		dateCreated(nullable:false)
	}

	static final int STUDYCOMMUNITY_STATE_PASS = 1 //学习社区在系统中的状态 1-已通过
	static final int STUDYCOMMUNITY_STATE_EXAMINE = 2 //学习社区在系统中的状态 2-审核中
	static final int STUDYCOMMUNITY_STATE_FORBIDDEN = 0 //学习社区在系统中的状态 0-已禁用

	final static cnField = [
		0:'已禁用',
		1:'已通过',
		2:'审核中'
	]
}