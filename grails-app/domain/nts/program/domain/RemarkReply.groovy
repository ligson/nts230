package nts.program.domain

import nts.user.domain.Consumer

class RemarkReply {
	static belongsTo = [remark:Remark,consumer:Consumer]

	String content
	
	Date dateCreated
	
	static constraints = {
		content(blank:false,maxSize:6000)
	}
}
