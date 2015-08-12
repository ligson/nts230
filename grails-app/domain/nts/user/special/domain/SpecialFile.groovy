package nts.user.special.domain

import nts.user.file.domain.UserFile

/***
 * 专辑文件，简化多对多，便于搜索
 */
class SpecialFile implements Comparable<SpecialFile> {

    static hasMany = [remarks: SpecialFileRemark]

    UserSpecial userSpecial
    UserFile userFile
    int orderIndex = 0;
    //专辑文件名称,默认等于userfile.name
    String name;
    //专辑文件描述,默认等于userfile的描述
    String description;
    //增加到专辑的日期
    Date createdDate = new Date();

    static constraints = {
        description(nullable: true, size: 0..1024)
    }

    @Override
    int compareTo(SpecialFile o) {
        return o.orderIndex - orderIndex
    }
}
