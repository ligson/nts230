package nts.program.domain

import nts.user.domain.Consumer

/***
 * 课程提问
 */
class CourseQuestion {


    //课程
    Program course;

    static hasMany = [answer:CourseAnswer]

    //提问人
    Consumer consumer
    //提问时间
    Date createDate = new Date();
    //提问标题
    String title;
    //描述，目前允许为空
    String description;

    //状态。目前不用。

    int state = 1;

    //最佳答案
    CourseAnswer rightAnswer

    static constraints = {
        description(nullable:true)
        rightAnswer(nullable:true)
    }

    static mapping = {
        state(column:"question_state")
    }
}
