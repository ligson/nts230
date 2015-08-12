package nts.user.file.domain

import nts.user.domain.Consumer

/**
 * 用户文件标签
 */
class UserFileTag {

    String name
    UserFile userFile
    Date createdDate = new Date();

    static constraints = {
    }
}
