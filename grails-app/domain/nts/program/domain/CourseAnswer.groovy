package nts.program.domain

import nts.user.domain.Consumer

/***
 * 课程问题答复
 */
class CourseAnswer {
    CourseQuestion courseQuestion;
    //回复人
    Consumer consumer;
    String content;
    //回复内容
    Date createDate = new Date();

    static constraints = {
    }
}
