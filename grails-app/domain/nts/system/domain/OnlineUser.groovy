package nts.system.domain

/**
 * 在线人数记录表
 */
class OnlineUser {

    /** 在线人数 */
    int onlineUserCount;
    /** 统计 */
    String statisticsDate
    /** 时间 */
    String statisticsTime;

    static constraints = {
        onlineUserCount(nullable:false);
        statisticsDate(nullable:false);
        statisticsTime(nullable:false);
    }
}
