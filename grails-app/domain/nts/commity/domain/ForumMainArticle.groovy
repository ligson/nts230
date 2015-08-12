package nts.commity.domain

import nts.user.domain.Consumer

/**
* 主帖
*/
class ForumMainArticle
{
	//nts.commity.domain.ForumBoard forumBoard 版块 n：1
	//nts.user.domain.Consumer createConsumer 主帖创建者 n：1
	//nts.commity.domain.ForumReplyArticle forumReplyArticle 回帖 1：n
	static belongsTo = [forumBoard:ForumBoard, createConsumer:Consumer]
	static hasMany = [forumReplyArticle:ForumReplyArticle]

	String name //帖子标题
	String description //帖子内容
	int isElite = 0 //精华帖 1-精华帖 0-不是
	int isTop = 0 //置顶 1-置顶 0-不是
	Date dateCreated = new Date() //创建时间
    String forumViewNum //帖子浏览次数
	static mapping = {
		description  type:"text"
	}

	static constraints = {
		name(nullable:false,blank:false,maxSize:100)
		description(nullable:false,blank:false) //,maxSize:1000
		isElite(nullable:false,rang:0..1)
		isTop(nullable:false,rang:0..1)
		dateCreated(nullable:false)
        forumViewNum(nullable:true)
	}

	static final int ARTICLE_ELITE = 1
	static final int ARTICLE_NOT_ELITE = 0
	static final int ARTICLE_TOP = 1
	static final int ARTICLE_NOT_TOP = 0
}