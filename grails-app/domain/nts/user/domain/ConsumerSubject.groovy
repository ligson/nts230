package nts.user.domain

import nts.user.domain.Consumer

class ConsumerSubject {
		static belongsTo = [Consumer,Subjects]

		Consumer consumer			//�û�����
		Subjects subject				//�������
		int subjectType				//��������
		int userRole					//�û���� 0-������ 1-��ͨ�û� 

		boolean isSubjectUser			//�Ƿ������������Ա	1-�� 0-����

		Date dateCreated				//����ʱ��
		
	    static constraints = {
		
	    }
}
