package nts.system.domain
/**
* 类别
*/
class RMSCategory
{
	//nts.studycircle.domain.StudyCircle studyCircles 学习圈 1：n
	//nts.commity.domain.StudyCommunity studyCommunitys 学习社区 1：n
	//static hasMany = [studyCircles:nts.studycircle.domain.StudyCircle]//, studyCommunity:nts.commity.domain.StudyCommunity

	String name //类别名称
	int parentid = 0 //父级类别id
	String parentName = "无" //父级类别名称
	Date dateCreated = new Date() //创建时间
	int type = 0 //0-公共类别 1-学习圈类别 2-学习社区类别 3-活动类别
	boolean state = true //1-使用中 0-回收站

	static constraints = {
		name(nullable:false,blank:false,maxSize:50)
		parentid(nullable:false)
		dateCreated(nullable:false)		
		type(nullable:false,rang:0..2)
	}

    static mapping = {
        type(column:'rms_category_type')
        state(column:'rms_category_state')
    }
    //UPDATE rmscategory r SET r.rms_category_type = r.type,r.rms_category_state = r.state
    //alter table rmscategory drop column type;
    //alter table rmscategory drop column state;

}