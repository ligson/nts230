package nts.program.domain

import nts.user.domain.Consumer

/***
 * 资源评分
 */
class RemarkScore {
    Consumer consumer;
    Remark remark;
    Program program;
    int rank = 0;
    static constraints = {
        rank(nullable:false,range: 0..10)
    }
}
