package nts.program.domain

import nts.user.domain.Consumer

class DownloadedProgram {
	static belongsTo = [program:Program,consumer:Consumer]

	Date dateCreated

	def beforeInsert = {
		dateCreated = new Date()
	}
}
