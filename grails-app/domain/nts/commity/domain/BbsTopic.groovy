package nts.commity.domain

import nts.user.domain.Consumer

class BbsTopic {
	static belongsTo = [consumer:Consumer]
	static hasMany = [ bbsReplys:BbsReply]
	
	String name	//主题名称
	String content		//主题内容
	String username		//发贴人名称，提高效率
	String memo		//留言者可填写填写姓名、单位、班级、EMAIL等备注信息的字段
	String fromIp		//留言者IP

	int replyNum = 0	//回复数	

	boolean isBest = false	//是否精华帖
	boolean isLocked = false	//是否锁定
	
	Date dateLastReply = new Date()	//最后回复时间
	Date dateCreated			//创建时间

	def beforeInsert = {
		dateCreated = new Date()
	}

	static mapping = {
		content  type:"text"
	}
	
	static constraints = {
		name(nullable:false,blank:false,maxSize:250)
		content(nullable:true,blank:true,maxSize:10000)
		memo(nullable:true,blank:true,maxSize:250)
		username(nullable:false,blank:false,maxSize:250)
		fromIp(nullable:true,blank:true,maxSize:250)
	}

}
