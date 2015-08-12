package nts.studycircle.domain

import nts.studycircle.domain.CircleQuestion
import nts.user.domain.Consumer

/**
* 回答
*/
class Answer
{
	//nts.studycircle.domain.CircleQuestion question 问题 n：1
	//nts.user.domain.Consumer answerConsumer 回答者 n：1
	static belongsTo = [question:CircleQuestion, answerConsumer:Consumer]
	StudyCircle studyCircle

	String description //回答的内容
	String url //参考链接
	Date dateCreated = new Date() //回答时间

	static mapping = {
		description  type:"text"
	}

	static constraints = {
		description(nullable:false,blank:false)//,maxSize:4000
		url(nullable:true,blank:true,maxSize:500)
		dateCreated(nullable:false)		
	}
}