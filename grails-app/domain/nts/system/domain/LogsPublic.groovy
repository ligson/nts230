package nts.system.domain
/**
* 学习圈动态（日志）
*/
class LogsPublic
{
	//nts.studycircle.domain.StudyCircle studyCircle 学习圈 n：1
	//nts.commity.domain.StudyCommunity studyCommunity 学习社区 n：1
	//static belongsTo = [studyCircle:nts.studycircle.domain.StudyCircle, studyCommunity:nts.commity.domain.StudyCommunity]//
	//nts.studycircle.domain.StudyCircle studyCircle
	//nts.commity.domain.StudyCommunity studyCommunity

	int studyCircle_id = 0 //学习圈ID
	int studyCommunity_id = 0  //学习社区ID
	String description //日志内容
	Date dateCreated = new Date() //时间
	int type = 0 //资源社区的日志类型，1-公告 2-版块 3-帖子 4-共享 5-活动
	int typeId = 0 //代表资源社区日志类型中，各类型在各自表中对应的id号

	static mapping = {
		description  type:"text"
	}

	static constraints = {
		studyCircle_id(nullable:false)
		studyCommunity_id(nullable:false)
		description(nullable:true,blank:true,maxSize:1000)
		dateCreated(nullable:true)		
		type(nullable:true)	
		typeId(nullable:true)	
	}

	final static int type_notice = 1		//1-公告
	final static int type_forumBoard = 2	//2-讨论区
	final static int type_article = 3		//3-贴子
	final static int type_sharing = 4		//4-共享
	final static int type_activity = 5		//5-活动

}