package nts.program.domain

import nts.program.domain.Program

class ProgramTag {
	static belongsTo = Program
	static hasMany = [programs:Program]

	String name
	int frequency

	Date dateCreated
	Date dateModified

	static constraints = {
		name(blank:false,maxSize:40)
		frequency(nullable:false)
	}

	def beforeInsert = {
		dateCreated = new Date()
		dateModified = new Date()
	}

	def beforeUpdate = {
		dateModified = new Date()
	}

	String toString() { name }

    //mysql
    //alter table program_tag drop index name
}