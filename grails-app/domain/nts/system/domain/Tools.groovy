package nts.system.domain

class Tools {

	String name			//�ļ����
	String dirName		//ʵ�������
	String size			//�ļ���С
	String consumer		//�ϴ���
	String path			//�ϴ�·��
	Date dateCreated		//����ʱ�� 

	static constraints = {
		name(nullable:true,blank:true,maxSize:200)
		dirName(nullable:true,blank:true,maxSize:200)
		size(nullable:true,blank:true,maxSize:200)
		consumer(nullable:true,blank:true,maxSize:200)
		path(nullable:true,blank:true,maxSize:500)
	}

}
