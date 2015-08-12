package nts.commity.domain

import nts.studycircle.domain.StudyCircle
import nts.user.domain.Consumer

/**
* 讨论区版块
*/
class ForumBoard
{
	//Forum forum 讨论区 n：1
	//nts.user.domain.Consumer createConsumer 版块创建者 n：1
	//nts.commity.domain.ForumMainArticle forumMainArticle 主帖 1：n
	static belongsTo = [createConsumer:Consumer] //forum:Forum,
	static hasMany = [forumMainArticle:ForumMainArticle]
	StudyCircle studyCircle
	StudyCommunity studyCommunity
	
	int type = 0 //版块所属 1-学习圈 2-学习社区
	String name //版块名称
	String description //描述
	Date dateCreated = new Date() //创建时间
    //图标：存放/nts/communityMgr
    String photo

    int state = 0 //0-待审核 1-审核通过

	static mapping = {
		description  type:"text"
	}

	static constraints = {
		description(nullable:true,maxSize:1024)
		dateCreated(nullable:false)
		studyCircle(nullable:true)
		studyCommunity(nullable:true)
        photo(nullable:true)
        state(nullable:true)
	}
}