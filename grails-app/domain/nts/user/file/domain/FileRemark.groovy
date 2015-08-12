package nts.user.file.domain

import nts.user.domain.Consumer

/***
 * 文件评论
 */
class FileRemark {

    //评论回复
    static hasMany = [comments: RemarkComment]
    Consumer consumer;
    UserFile file
    //评论内容
    String remarkContent;
    Date createdDate = new Date();
    static constraints = {
        remarkContent(size: 1..1024)
    }
}
