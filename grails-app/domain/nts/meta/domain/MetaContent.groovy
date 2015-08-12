package nts.meta.domain

import nts.program.domain.Program

class MetaContent implements Comparable {
	static belongsTo = [Program,MetaDefine]
	Program program
	MetaDefine metaDefine
	//static searchable = true

	int numContent
	String strContent
	int parentId	//Ԫ��ݵĸ�ID Ϊ����߲�ѯЧ��

	static constraints = {
		numContent(nullable:true)
		strContent(nullable:true,blank:true,maxSize:2000)		
	}

	def beforeInsert = {
		parentId = metaDefine.parentId
	}

	def beforeUpdate = {
		//
	}

	 static mapping = {
		//table 'meta_content'
		parentId column:'parent_id',index:'ix_metacont_pid'
	 }

	int compareTo(obj) {
		int n = 1;
		if(obj && metaDefine) n = (metaDefine.showOrder).compareTo(obj.metaDefine.showOrder);
		if(n == 0) n = 1;
		return n
	}

	String toString() { numContent }

	//�ڱ�����numContentֵ������
	static numDataTypes = ['number','enumeration']
}

/**
ɾ��ʡͼ�зַ���û��Ԫ��ݶ���ģ�
delete from meta_content where meta_define_id = 425 and meta_define_id not in(select id from meta_define);
*/
