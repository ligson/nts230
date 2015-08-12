package nts.system.domain
/**
* 消息
*/
class Message
{
	//nts.user.domain.Consumer sendConsumer 发信人 n：1
	//nts.user.domain.Consumer receiveConsumer 收信人 n：1
	//static belongsTo = [sendConsumer:nts.user.domain.Consumer, receiveConsumer:nts.user.domain.Consumer]
	
	int sendConsumerID = 0  //发信人ID
	int receiveConsumerID = 0  //收信人ID

	String name //标题
	String description //内容
	Date dateCreated = new Date() //创建时间
	int state = 0 //状态 0-未读 1-已读 2-垃圾

	static mapping = {
		description  type:"text"
	}

	static constraints = {
		name(nullable:false,blank:false,maxSize:100)
		description(nullable:false,blank:false)//,maxSize:1000
		state(nullable:false,rang:-1..1)
		sendConsumerID(nullable:false)
		receiveConsumerID(nullable:false)
		dateCreated(nullable:false)		
	}

	final static int MESSAGE_STATE_NOREAD = 0  //状态 0-未读
	final static int MESSAGE_STATE_READED = 1  //状态 1-已读
	final static int MESSAGE_STATE_RUBBISH = 2  //状态 2-垃圾

}