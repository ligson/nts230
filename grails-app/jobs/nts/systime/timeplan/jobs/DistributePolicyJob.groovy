package nts.systime.timeplan.jobs

import nts.program.domain.DistributePolicy
import nts.program.services.DistributeService
import nts.program.services.TimePlanJobService
import nts.system.domain.ServerNode
import org.quartz.Job
import org.quartz.JobDataMap
import org.quartz.JobExecutionContext
import org.quartz.JobExecutionException

import java.text.SimpleDateFormat

/**
 * Created by lvy6 on 14-6-12.
 */
class DistributePolicyJob implements Job{
    //DistributeService distributeService = new DistributeService();
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
                distributeService.startSendDistributePolicyJob(disId as Long,serverNodeId as Long);
            }
        }
    }

}
