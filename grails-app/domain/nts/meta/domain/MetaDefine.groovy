package nts.meta.domain

import nts.system.domain.Directory

class MetaDefine {
	SortedSet metaEnums
	static belongsTo = [Directory]
	static hasMany=[directorys:Directory,metaEnums:MetaEnum,metaContents:MetaContent]
	//static fetchMode = [directorys:'eager']
	//nts.user.domain.Consumer consumer	//不用用户实例是因为元数据太重要
	
	String name
	String cnName
	String dataType
	String defaultValue
	String description
	String creatorName	//用创建者(consumer)的name

	int parentId
	byte isNecessary	
	int showType	//1||2 或运算(1详细，2摘要，4浏览类别,8编目缺省显示，16可导出，32唯一性，64分类统计)
	byte searchType	//1||2 或运算(1客户端，2管理端)
	int maxLength
	int showOrder

	Date dateCreated
	Date dateModified

	static constraints = {
		name(unique:true,blank:false,maxSize:200)
		cnName(blank:false,maxSize:100)
		dataType(blank:false,maxSize:40)
		defaultValue(nullable:true,blank:true,maxSize:40)
		description(nullable: true, blank:true,maxSize:250)
		isNecessary(nullable:false)
		showType(nullable:false)
		searchType(nullable:false)
		parentId(nullable:false)
		maxLength(nullable:false)
		showOrder(nullable:false)
		metaEnums(nullable:true)
		creatorName(blank:false,maxSize:60)
	}

	def beforeInsert = {
		dateCreated = new Date()
		dateModified = new Date()
	}

	def beforeUpdate = {
		dateModified = new Date()
	}

	String toString() { cnName }

	static sysMeta = ['title','creator','discipline']//系统必要元数据name
	static sysMeta2 = ['Title','Contributor','CLC_Class_Name']//系统必要元数据name 福建省图
	//static dataTypeMap = ['decorate':'修饰词','string':'字符串','textarea':'长字符串','number':'数字','date':'日期','time':'时间','datetime':'日期时间','enumeration':'枚举','link':'链接','img':'图片']
	static dataTypeMap = ['decorate':'复合元素','decorate2':'复合修饰词','string':'字符串','textarea':'长字符串','number':'数字','date':'日期','time':'时间','datetime':'日期时间','enumeration':'枚举','link':'链接']
	static simpleSearchMeta = ['title','creator']//简单检索元素名

	final static int DETAIL_SHOW = 1 //1详细显示
	final static int ABSTRACT_SHOW = 2 //2摘要显示
	final static int TREE_SHOW = 4 //树显示
	final static int DEFAULT_SHOW = 8 //编目缺省显示
	final static int EXPORT_SHOW = 16 //可导出
	final static int UNIQUE_SHOW = 32 //唯一性,如架号不能重复
	final static int STAT_SHOW = 64 //分类统计
}