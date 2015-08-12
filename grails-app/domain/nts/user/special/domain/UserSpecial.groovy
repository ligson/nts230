package nts.user.special.domain

import nts.user.domain.Consumer

/****
 * 用户专辑
 */
class UserSpecial {


    static hasMany = [files: SpecialFile, tags: SpecialTag, posters: SpecialPoster,scores:SpecialScore]

    //专辑创建者
    Consumer consumer
    //专辑名称
    String name
    Set<SpecialFile> files = new HashSet<SpecialFile>()
    //创建日期
    Date createdDate = new Date();
    //开播日期。可以为空
    Date startDate;
    //计划结束日期,可以为空
    Date endDate;
    //专辑描述
    String description;
    //计划有多少集，默认应该等于files.size()，-1未设置
    int planSize = -1;

    //允许评论
    boolean allowRemark = true;

    static constraints = {
        startDate(nullable: true)
        endDate(nullable: true)
        description(nullable: true, size: 0..1024)
    }
}
