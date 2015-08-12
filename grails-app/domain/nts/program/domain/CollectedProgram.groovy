package nts.program.domain

import nts.user.domain.Consumer

class CollectedProgram {
	static belongsTo = [program:Program,consumer:Consumer]

	String tag	//对外经贸称标签，如果不称标签，可改cnField
	Date dateCreated
	
	static constraints = {
		tag(maxSize:100)
	}

	def beforeInsert = {
		dateCreated = new Date()
	}

	static cnField = [
		tag:'标签'
    ]
}
