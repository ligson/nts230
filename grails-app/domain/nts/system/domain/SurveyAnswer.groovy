package nts.system.domain

class SurveyAnswer {
	static belongsTo = [survey:Survey,qnaireQuestion:QnaireQuestion,qnaireOption:QnaireOption]

	String text	//用于文本题，用户在问卷中可输入文本，供以后扩充
	
	static constraints = {
		text(nullable:true,blank:true,maxSize:1200)
	}
	
}
