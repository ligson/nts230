package nts.commity.domain

/***
 * 目前没用，功能待定
 */
class Discussion {
	//static belongsTo = [program:Program,consumer:Consumer]

	String topic	//Ӱ������
	String content
	int replyNum	//�ظ���


	Date dateCreated
	Date dateModified

	static constraints = {
		topic(blank:false,maxSize:80)
		content(blank:false,maxSize:6000)
		replyNum(nullable:false)
	}
}