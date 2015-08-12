import nts.program.services.DistributeService
import org.quartz.Job
import org.quartz.CronTrigger
import org.quartz.JobExecutionContext

class DistributeJob implements Job {
	def distributeService = new DistributeService()
	static String JOB_NAME = "DistributeJob"	//"cnen.DistributeJob"
	static String JOB_GROUP_NAME = "GRAILS_JOBS"
	static int DISTRIBUTE_MODSTATE = 1	//CTools.nullToZero(SysConfig.findByConfigName('DistributeModState')?.configValue)    //�ַ�ģ��״̬

    public void execute(JobExecutionContext context){
		if(DISTRIBUTE_MODSTATE == 1){
			def trigger = context.getTrigger()
			def triggerName = trigger.getName()
			def cronExpression = "simple"
			if(trigger instanceof CronTrigger) cronExpression = trigger.getCronExpression() 
			
			//ϵͳ����ʱ���û�д�������Ĭ��ÿ��1�����Ӵ�����Ϊ��ֹ��Ĭ�ϴ���,��_trigger_�ж��������Լ����õĴ������淶
			if(triggerName.indexOf("_trigger_") > 0) distributeService.startDistribute(triggerName,cronExpression)
		}
    }
	
}
