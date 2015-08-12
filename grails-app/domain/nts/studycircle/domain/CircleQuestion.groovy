package nts.studycircle.domain

import nts.user.domain.Consumer

/**
* 答疑库问题
*/
class CircleQuestion
{
	//nts.studycircle.domain.StudyCircle studyCircle 学习圈 n：1
	//nts.user.domain.Consumer createConsumer 提问者 n：1
	//nts.studycircle.domain.Answer answers 回答 1：n
	static belongsTo = [studyCircle:StudyCircle, createConsumer:Consumer]
	static hasMany = [answers:Answer]

	String name //问题标题
	String description //问题内容
	Date dateCreated = new Date() //创建时间
	int visitCount = 0 //浏览次数

	static mapping = {
		description  type:"text"
		visitCount type:"int"
	}

	static constraints = {
		name(nullable:false,blank:false,maxSize:100)
		description(nullable:false,blank:false)//,maxSize:4000
		dateCreated(nullable:false)		
	}
}