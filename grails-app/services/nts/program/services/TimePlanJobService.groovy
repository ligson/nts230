package nts.program.services

import nts.program.domain.DistributePolicy
import nts.program.domain.TimePlan
import nts.system.domain.ServerNode
import nts.systime.timeplan.jobs.DistributePolicyJob
import nts.systime.timeplan.jobs.RecDistributePolicyJob
import org.quartz.CronScheduleBuilder
import org.quartz.Job
import org.quartz.JobBuilder
import org.quartz.JobDataMap
import org.quartz.JobDetail
import org.quartz.JobKey
import org.quartz.Scheduler
import org.quartz.SchedulerFactory
import org.quartz.Trigger
import org.quartz.TriggerBuilder
import org.quartz.impl.StdSchedulerFactory

class TimePlanJobService {
    static scope = "singleton";
    Scheduler scheduler;
    def distributeService

    public Scheduler getDefaultScheduler() {
        return scheduler;
    }

    public Trigger newInstanceCronTrigger(String triggerName, String triggerGroupName, String cronExpression) {
        return TriggerBuilder.newTrigger().withIdentity(triggerName, triggerGroupName).withSchedule(CronScheduleBuilder.cronSchedule(cronExpression)).build();
    }

    public JobDetail newInstanceJobDetail(Class cls, String jobName, String jobGroupName, JobDataMap jobDataMap) {
        return JobBuilder.newJob(cls).withIdentity(jobName, jobGroupName).usingJobData(jobDataMap).build();
    }

    public void startSendTimePlanJob(String expression, Long disId, Long serverNodeId) {
        SchedulerFactory schedulerFactory = new StdSchedulerFactory();
        scheduler = schedulerFactory.getScheduler();
        def jobDataMap = new JobDataMap([disId: disId, serverNodeId: serverNodeId, distributeService: distributeService]);
        String jobId = "sendJobGroup-" + disId + "-" + serverNodeId;

        JobDetail jobDetail = newInstanceJobDetail(DistributePolicyJob.class, "sendJob", jobId, jobDataMap);
        if (scheduler.getJobDetail(jobDetail.key)) {
            scheduler.deleteJob(jobDetail.key);
        }
        Trigger trigger = newInstanceCronTrigger("sendTrigger", "sendTriggerGroup-" + disId + "-" + serverNodeId, expression);
        scheduler.scheduleJob(jobDetail, trigger);
        scheduler.start();

    }

    public void startRecTimePlanJob(String expression, Long disId, Long serverNodeId) {
        SchedulerFactory schedulerFactory = new StdSchedulerFactory();
        scheduler = schedulerFactory.getScheduler();
        def jobDataMap = new JobDataMap([disId: disId, serverNodeId: serverNodeId, distributeService: distributeService]);
        JobDetail jobDetail = newInstanceJobDetail(RecDistributePolicyJob.class, "recJob", "recJobGroup-" + disId + "-" + serverNodeId, jobDataMap);
        if (scheduler.getJobDetail(jobDetail.key)) {
            scheduler.deleteJob(jobDetail.key);
        }
        Trigger trigger = newInstanceCronTrigger("recTrigger", "recGroupTrigger-" + disId + "-" + serverNodeId, expression);
        scheduler.scheduleJob(jobDetail, trigger);
        scheduler.start();

    }


    public void startTimePlanJob() {
        List<TimePlan> timePlanList = TimePlan.createCriteria().list() {
            eq('isActive', true)
        };
        for (int i = 0; i < timePlanList.size(); i++) {
            TimePlan timePlan = timePlanList.get(i);
            def expression = timePlan.expression;
            List<DistributePolicy> distributePolicyList = timePlan.distributePolicys.toList();
            for (int j = 0; j < distributePolicyList.size(); j++) {
                DistributePolicy distributePolicy = distributePolicyList.get(j);
                List<ServerNode> serverNodeList = distributePolicy.serverNodes.toList();
                for (int n = 0; n < serverNodeList.size(); n++) {
                    ServerNode serverNode = serverNodeList.get(n);
                    if (timePlan.category == 0) {
                        startSendTimePlanJob(expression, distributePolicy.id, serverNode.id);
                    } else if (timePlan.category == 1) {
                        startRecTimePlanJob(expression, distributePolicy.id, serverNode.id);
                    }
                }
            }

        }
        /*SchedulerFactory schedulerFactory = new StdSchedulerFactory();
        Scheduler scheduler = schedulerFactory.getScheduler();
        String cronExpression = "0 * 12 * * ?";
        def jobDataMap = new JobDataMap([distributePolicy:"aaaaaaa",serverNode:"bbbbbbbbbbb"]);
        JobDetail jobDetail = newInstanceJobDetail(DistributePolicyJob.class,"sendJob","sendJobGroup",jobDataMap);
        Trigger trigger = newInstanceCronTrigger("sendTrigger","sendTriggerGroup",cronExpression);
        scheduler.scheduleJob(jobDetail,trigger);
        scheduler.start();*/
    }

    public void restartTimePlanJob(String jobName) {
        scheduler.resumeJob(JobKey.jobKey(jobName));
    }

    public void stopTimePlanJob(String jobGroup,String jobName) {
        scheduler.deleteJob(JobKey.jobKey(jobName,jobGroup));
    }
}
