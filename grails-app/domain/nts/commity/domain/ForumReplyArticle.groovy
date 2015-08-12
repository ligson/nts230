package nts.commity.domain

import nts.user.domain.Consumer

/**
* 回帖
*/
class ForumReplyArticle
{
	//nts.commity.domain.ForumMainArticle forumMainArticle 主帖 n：1
	//nts.user.domain.Consumer replyConsumer 回帖者 n：1
	//nts.commity.domain.ForumReplySubjectArticle forumReplySubjectArticle 回复回帖 1：n
	static belongsTo = [forumMainArticle:ForumMainArticle, replyConsumer:Consumer]
	static hasMany = [forumReplySubjectArticle:ForumReplySubjectArticle]

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