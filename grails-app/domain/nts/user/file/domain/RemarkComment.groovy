package nts.user.file.domain

import nts.user.domain.Consumer

/***
 * 评论恢复
 */
class RemarkComment {
    FileRemark remark;
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
