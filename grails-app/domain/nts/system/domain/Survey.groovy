package nts.system.domain

import nts.user.domain.Consumer

class Survey {
	static belongsTo = [qnaire:Qnaire,consumer:Consumer]
	static hasMany = [ surveyAnswers : SurveyAnswer ]
	Date dateCreated			//提交时间
	
	def beforeInsert = {
		dateCreated = new Date()
	}
}
