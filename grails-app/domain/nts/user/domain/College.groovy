package nts.user.domain

class College {
	String name
	String description

    static constraints = {
		name(nullable:true,blank:true,size:1..50)
		description(nullable:true,blank:true,maxSize:500)
    }
}
