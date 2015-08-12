package nts.systime.timeplan.jobs

import org.quartz.Job
import org.quartz.JobDataMap
import org.quartz.JobExecutionContext
import org.quartz.JobExecutionException

/**
 * Created by lvy6 on 14-6-12.
 */
class RecDistributePolicyJob implements Job{
    def distributeService
    static triggers = {

    }

    @Override
    void execute(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        JobDataMap jobDataMap = jobExecutionContext.getJobDetail().jobDataMap;
        def disId = jobDataMap.get("disId");
        def serverNodeId = jobDataMap.get("serverNodeId");
        if(disId&&serverNodeId){
            if(!distributeService){
                if(jobDataMap.get("distributeService")){
                    distributeService = jobDataMap.get("distributeService")
                }
            }
            if(distributeService){
                distributeService.startRecDistributePolicyJob(disId as Long,serverNodeId as Long);
            }
        }
    }
}
