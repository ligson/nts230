package nts.system.domain

import nts.user.domain.Consumer

class News {

	String title						//�������
	String content						//����
	Consumer  publisher				//������
	Date submitTime					//����ʱ��

	static mapping = {
			content  type:"text"
		}

	static constraints = {

		title(blank:false,maxSize:200)
		content(blank:false)
	}

}
