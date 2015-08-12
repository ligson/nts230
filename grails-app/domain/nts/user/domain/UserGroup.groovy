package nts.user.domain

import nts.program.domain.Program
import nts.user.domain.IpAddress
import nts.user.domain.Consumer

class UserGroup {
	static belongsTo = [Consumer,Program]

	static hasMany=[consumers:Consumer,playPrograms:Program,downloadPrograms:Program,ipAddresses:IpAddress]

    Set<Program> downloadPrograms = new HashSet<Program>();
	String name
	String description
	String creator					 //������
    Role role
	int active
	Long consumer					//������ID

	Date dateCreated
	Date dateModified

	/*	---2009-11-13�������� ��Ӱ����ʱ����ʹ�á�
	static mapping = {
	     name index:'IDX_UserGroup_Name'
	}
	*/
	
	static constraints = 
	{
		name(blank:false,maxSize:40)
		description(blank:true,nullable:true,maxSize:250)
		active(blank:true,nullable:true,range:0..1)
		dateCreated(blank:true,nullable:true)
		dateModified(blank:true,nullable:true)
		creator(blank:true,nullable:true)
		consumer(blank:true,nullable:true)
        role(nullable: true)
	}

	def beforeInsert = {
		dateCreated = new Date()
		dateModified = new Date()
	}

	def beforeUpdate = {
		dateModified = new Date()
	}

	String toString() { name }
}
