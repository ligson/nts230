package nts.program.domain

import nts.user.domain.Consumer

class PlayedProgram{
    static belongsTo = [program: Program, consumer: Consumer]

    Date dateCreated = new Date();

    Serial serial
    //观看进度，文档页，视音频秒
    int timeLength
    Date playDate = new Date();

    static constraints = {
        serial(nullable: true)
        timeLength(nullable: true)
    }

    def beforeInsert = {
        dateCreated = new Date()
    }

}
