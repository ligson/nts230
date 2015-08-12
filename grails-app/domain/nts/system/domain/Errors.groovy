package nts.system.domain

import nts.user.domain.Consumer

class Errors {
	static belongsTo = Consumer
	String errorTitle						//�������
	String errorContent						//��������
	Consumer publisher					//�ύ��
	Date submitTime						//�ύʱ��
	int errorState							//����״̬ 0-δ��� 1-�ѽ��
	int programId = 0

	static constraints = {

		errorTitle(blank:false,maxSize:200)
		errorContent(blank:false,maxSize:5000)
		publisher(blank:true,nullable:true)
		submitTime(blank:true,nullable:true)
		errorState(blank:true,nullable:true)
	}
}
