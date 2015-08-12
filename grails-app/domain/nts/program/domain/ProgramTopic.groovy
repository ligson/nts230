package nts.program.domain

import nts.program.domain.Program
import nts.user.domain.Consumer

/**
* 资源专题domain
*将某些有相同属性的资源归类形一个专题
**/

class ProgramTopic {
	static belongsTo = [Program,Consumer]
	Consumer consumer
    Set<Program> programs = new HashSet<Program>();
	static hasMany = [ programs:Program]


	String 	name                //(资源)专题名称
	String 	description			//专题描述
	int state              //状态：1发布 2关闭（专题完毕，对外不展示）
	String img = ""		//专题图片

	Date dateClosed = new Date()	//关闭时间
	Date dateCreated			//创建时间

	def beforeInsert = {
		dateCreated = new Date()
	}
	
	static constraints = {
		name(nullable:false,blank:false,maxSize:250)
		description(nullable:true,blank:true,maxSize:2000)
		img(nullable:true,blank:true,maxSize:250)
	}
	
	//对应state
	final static int PUBLIC_STATE = 1 //发布状态
	final static int CLOSE_STATE = 2 //关闭状态

	static cnState = [	
		1:'发布',
		2:'关闭'
	] 
}
