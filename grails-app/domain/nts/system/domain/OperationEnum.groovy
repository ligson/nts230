package nts.system.domain

enum OperationEnum {
	LOGIN(1),
	ADD_PROGRAM(2),
	EDIT_PROGRAM(3),
	DELETE_PROGRAM(4),
	APPROVAL_PROGRAM(5),
	DOWNLOAD_PROGRAM(6),
	ADD_USER(7),
	EDIT_USER(8),
	DELETE_USER(9),
	DELETE_SERVER_NODE(10)

	final int id 
	OperationEnum(int id) { this.id = id }

	//状态数值对应中文名称
	static cnType = [
		1:'用户登录',
		2:'添加资源',
		3:'修改资源',
		4:'删除资源',
		5:'审批资源',
		6:'下载资源',
		7:'添加用户',
		8:'修改用户',
		9:'删除用户',
		10:'删除服务器节点'
	] 
}