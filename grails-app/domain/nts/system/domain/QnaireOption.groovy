package nts.system.domain

class QnaireOption implements Comparable {
	static belongsTo = [qnaireQuestion:QnaireQuestion]
	
	String optionText   //选项
	int count = 0	//选项选择总数
	int showOrder	//排序
	
	static constraints = {
		optionText(nullable:false,blank:false,maxSize:1000)
	}

	int compareTo(obj) {
       showOrder.compareTo(obj.showOrder)
	}
}
