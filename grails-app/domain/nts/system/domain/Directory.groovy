package nts.system.domain

import nts.meta.domain.MetaDefine
import nts.program.domain.Program
import nts.user.domain.Consumer

class Directory {
	static belongsTo = Consumer
	static hasMany=[consumers:Consumer,metaDefines:MetaDefine,programs:Program]
	
	String name						//目录名称
	String uploadPath					//上传路径
	String description					//目录描术

	int showOrder						//显示顺序
	int parentId						//因不用树目录，故没有用Directory类型		--暂为0
	int classId						//类库ID 用来标识所属类库					
	int childNumber					//子目录数目，建树目录时提高效率用		--暂为0

	boolean allGroup					//所属组	
	boolean canUpload					//上传标记

	String img = ""						//类库图片
	
	Date dateCreated					//创建时间
	Date dateModified					//修改时间

	static constraints = {
		name(blank:false,maxSize:50)
		showOrder(nullable:false)
		parentId(nullable:false,)
		uploadPath(blank:true,nullable:true,maxSize:500)
		description(maxSize:1000,nullable: true)
		childNumber(nullable:true)

		canUpload(nullable:true)
		allGroup(nullable:true)

		dateModified(nullable:true,blank:true)
		dateCreated(nullable:true,blank:true)
		img(nullable: true, blank: true,maxSize:250)
	}

	def beforeInsert = {
		dateCreated = new Date()
		dateModified = new Date()
	}

	def beforeUpdate = {
		dateModified = new Date()
	}

	String toString() { name }
	static cnTableName = '类库'
}