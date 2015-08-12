package nts.commity.domain

import nts.user.domain.Consumer

/**
* 回复回帖
*/
class ForumReplySubjectArticle
{
	//nts.commity.domain.ForumReplyArticle forumReplyArticle 回帖 n：1
	//nts.user.domain.Consumer consumer 回复者 n：1
	static belongsTo = [consumer:Consumer, forumReplyArticle:ForumReplyArticle]

	String name //回帖子标题
	String description //回帖子内容
	Date dateCreated = new Date() //创建时间

	static mapping = {
		description  type:"text"
	}

	static constraints = {
		name(nullable:false,blank:false,maxSize:100)
		description(nullable:false,blank:false)//,maxSize:1000
		dateCreated(nullable:false)		
	}
}