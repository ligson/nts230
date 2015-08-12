package nts.system.domain

public enum	DataType {
	string("字符串"),
	textarea("长字符串"),
	number("数字")
	DataType(String label) {
		this.displayString = label
	}
	String displayString
}
