package nts.user.special.domain

import nts.user.domain.Consumer

class SpecialComment {
    SpecialFileRemark remark
    //评论者
    Consumer consumer;
    //恢复给谁。null等于remark的发表者
    Consumer commentUser;
    Date createdDate = new Date();
    String commentContent;
    static constraints = {
        commentUser(nullable: true)
        commentContent(size: 1..1024)
    }
}
