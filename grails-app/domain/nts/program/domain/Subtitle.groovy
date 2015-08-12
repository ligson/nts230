package nts.program.domain

import nts.program.domain.Serial
import nts.system.domain.Lang

class Subtitle implements Comparable {
    static belongsTo = [serial: Serial]

    String filePath = ""    //文件路径
    String fileHash
    String fileType
    int serialNo = 1    //序号,以便以后一个资源有多个字幕文件前后顺序问题
    int type = 1    //字幕类型 1 单文件 2 多文件
    Lang lang

    static constraints = {
        filePath(blank: true, maxSize: 250)
        serialNo(nullable: false, rang: 1..1000)
        type(nullable: false, rang: 0..1000)
        lang(nullable: true, blank: true)
        fileHash(nullable: true)
        fileType(nullable: true)
    }

    int compareTo(obj) {
        serialNo.compareTo(obj.serialNo)
    }
}
