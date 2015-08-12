package nts.user.special.domain

import nts.user.domain.Consumer

/***
 * 专辑文件评论
 */
class SpecialFileRemark {


    static hasMany = [comments: SpecialComment]
    Consumer consumer

    SpecialFile file
    String remarkContent;
    Date createdDate = new Date();
    static mapping = {
    }
    static constraints = {
        remarkContent(size: 1..1024)
    }
}
