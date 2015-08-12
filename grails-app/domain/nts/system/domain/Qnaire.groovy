package nts.system.domain

import nts.user.domain.Consumer

class Qnaire {
	SortedSet qnaireQuestions
	static belongsTo = [consumer:Consumer]
	static hasMany = [ qnaireQuestions : QnaireQuestion,surveys:Survey]
	
	String 	name                //问卷名称
	String 	description			//问卷描述
	int state              //状态：1 ，2发布 3关闭（调查完毕，关闭些问卷）
	int surveyNum = 0	//答卷数，即该问卷收到了多少份答卷	
	
	Date datePublished = new Date()	//问卷发布时间
	Date dateClosed = new Date()	//问卷关闭时间
	Date dateCreated			//问卷创建时间

	def beforeInsert = {
		dateCreated = new Date()
	}
	
	static constraints = {
		name(nullable:false,blank:false,maxSize:250)
		description(nullable:true,blank:true,maxSize:2000)
	}
	
	//对应state
	final static int NO_PUBLIC_STATE = 1 //未发布状态：问卷尚未形成，不对外发布，此状态可编辑问卷。
	final static int PUBLIC_STATE = 2 //发布状态：问卷已编辑无误，对外发布，用户填写问卷表，此状态不可编辑问卷。
	final static int CLOSE_STATE = 3 //关闭状态：调查已结束，不对外发布，此状态不可编辑问卷。

	static cnState = [
		1:'未发布',		
		2:'发布',
		3:'关闭'
	] 
}
