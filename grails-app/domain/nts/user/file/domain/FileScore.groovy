package nts.user.file.domain

import nts.user.domain.Consumer

/***
 * 文件打分
 */
class FileScore {
    UserFile userFile;
    //打分者,null未匿名用户，现在不支持
    Consumer consumer;
    //分值在0-10分
    double score = 0;
    //打分日期
    Date createdDate = new Date();
    static constraints = {
        consumer(nullable: true)
        score(range: 0..10)
    }

}
