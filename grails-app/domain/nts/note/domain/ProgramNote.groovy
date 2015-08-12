package nts.note.domain

import nts.program.domain.Program
import nts.program.domain.Serial
import nts.user.domain.Consumer

/**
 * 笔记
 */
class ProgramNote {

    static hasMany = [noteRecommends:NoteRecommend]

    Consumer consumer
    Serial serial;
    //便于检索
    Program program;
    String content;

    //文档代表页，视音频长度秒
    long logicLength = 0

    //公开后，其他人可以看
    boolean canPublic = false

    int recommend = 0
    //创建时间
    String createDate = new Date().format("yyyyMMddHHmmss");


    static constraints = {
    }
}
