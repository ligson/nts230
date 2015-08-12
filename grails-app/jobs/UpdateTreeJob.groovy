import nts.program.services.MetaDefineService

class UpdateTreeJob {
   //def timeout = 100000l // execute job once in 5 seconds
	def cronExpression = "0 0 2 * * ?" // 每天早上2点执行 ,测试
	MetaDefineService metaDefineService

    def execute() {
		metaDefineService.creatMetaJs()
    }

	/*
	//quartz http://tianyuzhu.javaeye.com/blog/538404
	//http://globalzhu.javaeye.com/blog/562118
	表达式     含义 
	"0 0 12 * * ?"                     每天中午十二点触发 
	"0 15 10 ? * *"                          每天早上 10 ： 15 触发 
	"0 15 10 * * ?"                          每天早上 10 ： 15 触发 
	"0 15 10 * * ? *"                      每天早上 10 ： 15 触发 
	"0 15 10 * * ? 2005"               2005年的每天早上 10 ： 15 触发 
	"0 * 14 * * ?"                            每天从下午 2 点开始到 2 点 59 分每分钟一次触发 
	"0 0/5 14 * * ?"                       每天从下午 2 点开始到 2 ： 55 分结束每 5 分钟一次触发 
	"0 0/5 14,18 * * ?"                  每天的下午 2 点至 2 ： 55 和 6 点至 6 点 55 分两个时间段内每 5 分钟一次触发 
	"0 0-5 14 * * ?"                       每天 14:00 至 14:05 每分钟一次触发 
	"0 10,44 14 ? 3 WED"            三月的每周三的 14 ： 10 和 14 ： 44 触发 
	"0 15 10 ? * MON-FRI"          每个周一、周二、周三、周四、周五的10 ： 15 触发 
	"0 15 10 15 * ?"                       每月 15 号的 10 ： 15 触发 
	"0 15 10 L * ?"                         每月的最后一天的 10 ： 15 触发 
	"0 15 10 ? * 6L"                      每月最后一个周五的 10 ： 15 触发 
	"0 15 10 ? * 6L"                      每月最后一个周五的 10 ： 15 触发 
	"0 15 10 ? * 6L 2002-2005"      2002年至 2005 年的每月最后一个周五的 10 ： 15 触发 
	"0 15 10 ? * 6#3"                   每月的第三个周五的 10 ： 15 触发 
	*/
}
