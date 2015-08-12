package nts.system.domain

import nts.system.domain.Qnaire
import nts.system.domain.QnaireOption

class QnaireQuestion implements Comparable{
	SortedSet qnaireOptions
	static belongsTo = [qnaire:Qnaire]
	static hasMany = [ qnaireOptions : QnaireOption ]
	
	String question    	//问题
	int    type			//问题类型 1：单选 2：多选 3：文本
	int showOrder	//排序
	
	static constraints = {
		question(nullable:false,blank:false)
	}

	int compareTo(obj) {
       showOrder.compareTo(obj.showOrder)
	}

	final static int RADIO_TYPE = 1 //单选
	final static int CHECK_BOX_TYPE = 2 //多选
	final static int TEXT_TYPE = 3 //文本。
}
