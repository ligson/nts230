package nts.commity.domain
/**
* 公告
*/
class Notice
{
	//nts.commity.domain.StudyCommunity studyCommunity 学习社区 n：1
	static belongsTo = [studyCommunity:StudyCommunity]

	String name //公告标题
	String description //公告内容
	Date dateCreated = new Date() //公告时间

	static mapping = {
		description  type:"text"
	}

	static constraints = {
		name(nullable:false,blank:false,maxSize:100)
		description(nullable:false,blank:false,maxSize:300)
		dateCreated(nullable:false)		
	}

}