package nts.program.domain

import nts.user.domain.Consumer

class Remark {
	static belongsTo = [program:Program,consumer:Consumer]
	static hasMany=[remarkReplys:RemarkReply]
	//static searchable = true

	String topic	//影评主题
	String content
	int replyNum = 0	//回复数
    int rank = 0;

	boolean isPass = true;//是否审批通过 RemarkAuthOpt

	Date dateCreated
	Date dateModified

	static constraints = {
		topic(blank:false,maxSize:80)
		content(blank:false,maxSize:6000)
		replyNum(nullable:false)
        rank(nullable:false,range: 0..10)
	}

	def beforeInsert = {
		dateCreated = new Date()
		dateModified = dateCreated
	}

	def beforeUpdate = {
		dateModified = new Date()
	}
}
