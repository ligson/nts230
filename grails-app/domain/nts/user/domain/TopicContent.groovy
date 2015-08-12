package nts.user.domain

class TopicContent {
		static belongsTo = Topic

		String content			//�ظ�����
		
		Date	  dateCreated		//�ظ�ʱ��

		Consumer consumer	//�ظ���
		Topic topic			//��������

		static mapping = {
			content  type:"text"
		}

    static constraints = {
		content(nullable:true,blank:true)
    }
}
