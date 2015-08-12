package nts.studycircle.domain

import nts.user.domain.Consumer

/**
* 学习圈内的参与者
*/
class Participant
{
	//nts.studycircle.domain.StudyCircle studyCircle 学习圈 n：1
	//nts.user.domain.Consumer consumer rms用户 n：1
	static belongsTo = [studyCircle:StudyCircle, consumer:Consumer]

	int state = 2 //状态 1-正式 2-待审核
	int role = 2 //角色 1-协作者 2-普通参与者
	Date dateCreated = new Date() //加入学习圈时间

	static constraints = {
		state(nullable:false,rang:1..2)
		role(nullable:false,rang:1..2)
		dateCreated(nullable:false)		
	}

	static final int PARTICIPANT_STATE_OFFICIAL = 1 //状态 1-正式
	static final int PARTICIPANT_STATE_EXAMINE = 2 //状态 2-待审核

	static final int PARTICIPANT_ROLE_TEAMWORKER = 1 //角色 1-协作者
	static final int PARTICIPANT_ROLE_SUBSCRIBER = 2 //角色 2-普通参与者

}