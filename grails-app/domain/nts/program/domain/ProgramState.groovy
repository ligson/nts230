package nts.program.domain

enum ProgramState {
	//负数对应回收站 0未定义 1未申请入库 2待审批 3审批未通过 4入库关闭 5入库打开
	//UNDEFINED(0),
	NO_APPLY(1),
	APPLY(2),
	NO_PASS(3),
	CLOSE(4),
	PUBLIC(5)

	//RECOMMEND(6)
	final int id 
	ProgramState(int id) { this.id = id }

	//状态数值对应中文名称
	static cnState = [
		1:'未申请入库',
		2:'待审批',
		3:'审批未通过',
		4:'入库关闭',
		5:'入库打开'
	] 
}