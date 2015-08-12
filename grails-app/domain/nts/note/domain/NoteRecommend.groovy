package nts.note.domain

import nts.user.domain.Consumer

/***
 * 防止对公开笔记重复推荐
 */
class NoteRecommend {
    ProgramNote programNote;
    Consumer consumer
    Date createDate = new Date();
    static constraints = {
    }
}
