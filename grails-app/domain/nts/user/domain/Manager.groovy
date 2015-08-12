package nts.user.domain

class Manager {
	//static belongsTo =[parent:nts.user.domain.Manager ];
	//static hasMany = [childrens:nts.user.domain.Manager];
	
    String name
	String password
	String trueName
	String savePath
	String description

	int role
	int privilege 
	int parentId

	Date dateCreated
	Date dateModified
	Date dateLastLogin

	static constraints = {
		name(unique:true,blank:false,size:4..20)
		//password(matchs:/[\w\d]+/,size:6..12)
		password(size:6..30)
		trueName(nullable:true,blank:true,maxSize:20)
		savePath(maxSize:250)
		description(nullable:true,blank:true,maxSize:250)
		privilege(nullable:false,range:1..128)
		role(nullable:false,range:1..10)
		dateLastLogin(nullable:true)
	}

	//static mapping = {   
      // parent:[column:'parent_Id',lazy:"true",cascade:"none"]   
       //children joinTable:[name:'children', key:'parent_Id', column:'Id',lazy:"true",inverse:"false",cascade:"none"]   
    //} 

	def beforeInsert = {
		dateCreated = new Date()
		dateModified = new Date()
		dateLastLogin = new Date()
	}

	def beforeUpdate = {
		dateModified = new Date()
	}

	String toString() { name }
}