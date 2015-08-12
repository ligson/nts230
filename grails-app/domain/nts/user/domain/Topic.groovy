package nts.user.domain

class Topic {
		static belongsTo = [Consumer,Subjects]
		static hasMany=[topicContents:TopicContent]

		String name				//�������
		
		Date dateCreated			//����ʱ��
		Date lastReply				//���ظ�ʱ��

		Consumer consumer		//������
		Subjects subject			//��������

		int browseNum			//�������
		int replyNum				//�ظ�����

		 static constraints = {
			 name(unique:true,blank:false,size:1..100)
			 subject(blank:true,nullable:true)
			 consumer(blank:true,nullable:true)

		  }
}
