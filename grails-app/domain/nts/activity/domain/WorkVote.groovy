package nts.activity.domain

import nts.user.domain.Consumer

/***
 * 作品投票
 */
class WorkVote {

    Consumer consumer;
    ActivitySharing activitySharing;
    Date createdDate = new Date();
    static constraints = {
    }
}
