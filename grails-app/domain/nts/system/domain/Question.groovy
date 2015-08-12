package nts.system.domain

class Question {

	String name					//问题标题
	String answer					//问题答案
	String consumer				//用户帐号

	int consumerId				//用户ID

	boolean questionState			//问题状态	true -已回答  false-未回答

	Date dateCreated				//创建时间

	static mapping = {
			answer  type:"text"
		}

	static constraints = {
		name(nullable:false,blank:false,maxSize:1000)
		answer(nullable:true,blank:true,maxSize:2000)
		consumer(nullable:true,blank:true)
		consumerId(nullable:true,blank:true)
	}
}
