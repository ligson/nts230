package nts.program.domain

import nts.program.domain.Program
import nts.user.domain.Consumer

class ViewedProgram {
	static belongsTo = [program:Program,consumer:Consumer]

	Date dateCreated

	def beforeInsert = {
		dateCreated = new Date()
	}
}
