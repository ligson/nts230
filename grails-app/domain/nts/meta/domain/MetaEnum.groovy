package nts.meta.domain

class MetaEnum implements Comparable {
	static belongsTo = [metaDefine:MetaDefine]
	
	int enumId
	String name

	Date dateCreated
	Date dateModified

	static constraints = {
		name(blank:false,maxSize:40)
		enumId(nullable:false)
	}

	def beforeInsert = {
		dateCreated = new Date()
		dateModified = new Date()
	}

	def beforeUpdate = {
		dateModified = new Date()
	}

	int compareTo(obj) {
       enumId.compareTo(obj.enumId)
   }

	String toString() { name }
}