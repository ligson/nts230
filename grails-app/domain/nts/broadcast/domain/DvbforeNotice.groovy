package nts.broadcast.domain

import nts.broadcast.domain.Channel

class  DvbforeNotice{
	
	static belongsTo  =  [channel:Channel] //ӳ��ΪChannelInfo��
	
	String descriptions	//���ݽ���
	String dvbTitle 	//��Ϣ����

	Date dateCreated = new Date()
	Date dateModified = new Date()
	Date datePlayed = new Date()
        Date limitTime 	//����ʱ��
	
	static constraints={
		dvbTitle(maxSize:80)
		dateCreated(maxSize:40)
		dateModified(maxSize:40)
		limitTime(maxSize:40,blank:true,nullable:true)
		descriptions(maxSize:2000,blank:true,nullable:true)
	}
}
