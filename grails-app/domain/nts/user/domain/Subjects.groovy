package nts.user.domain

import nts.user.domain.Consumer
import nts.user.domain.ConsumerSubject

class Subjects {
	static belongsTo = Consumer
	static hasMany=[topics:Topic,consumerSubjects:ConsumerSubject]

	String name				//�������
	String password			//��������
	String description			//����˵��
	String photoPath			//ͼƬ·��

	Date dateCreated			//����ʱ��

	Consumer consumer		//������

	int browseNum			//�������
	int replyNum				//�ظ�����
	int peopleNum				//��Ա����
	int subjectType			//�������� 0-�����������κ��˼���  1-�������辭����׼���ܼ���  2 -˽��

	static constraints = {
			name(unique:true,blank:false,maxSize:100)
			password(nullable:true,blank:true)
			description(nullable:true,blank:true,maxSize:200)
			photoPath(nullable:true,blank:true,maxSize:500)
	    }
}
