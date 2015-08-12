package nts.broadcast.domain

class  Channel{
	
	static hasMany = [dvbforeNotices:DvbforeNotice]  //�趨һ�Զ��ϵ 
	
	String channelName	//Ƶ�����
	String bcastAddr	//������ַ
	String channelDesc	//������Ϣ
	
	int serverid = 1	//������ID 
	int bcastType = 0		//Ƶ������
	int prilevel = 0		//Ȩ�޼���
	
	boolean isAllGroup = true	//�Ƿ������������û���

	Date dateCreated = new Date()
	Date dateModified = new Date()

	static constraints={
		
		channelName(unique:true,maxSize:80)
		bcastAddr(maxSize:400)
		dateCreated(maxSize:40)
		dateModified(maxSize:40)
		channelDesc(maxSize:2000,blank:true,nullable:true)
	}

	
	final static int BROADCAST_STATE = 1 //�㲥
	final static int LIVE_BROADCAST_STATE = 0 //ֱ��
	final static int RE_BROADCAST_STATE = 2 //ת��
	

	static cnBcastType = [
		1:'�㲥',		
		0:'ֱ��',
		2:'ת��'
	] 
}
