package nts.activity.domain

import nts.user.domain.Consumer

/**
* 投票表，对活动中的作品投票
*/
class UserVote {
	static belongsTo = [userWork:UserWork,consumer:Consumer]

	Date dateCreated = new Date()

}
