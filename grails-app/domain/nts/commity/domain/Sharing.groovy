package nts.commity.domain

import nts.user.domain.Consumer

/**
 * 共享
 */
class Sharing {
    //nts.commity.domain.StudyCommunity studyCommunity 学习社区 n：1
    //Consumer shareConsumer 共享者 n：1
    static belongsTo = [studyCommunity: StudyCommunity, shareConsumer: Consumer]

    String name //共享内容的标题
    String description //描述
    String url //共享文件的相对路径
    String fileType;
    String fileHash;
    int download = 0 //下载量
    Date dateCreated = new Date() //共享时间
    String photo
    boolean canDownload = true;
    boolean canPlay = true;

    static mapping = {
        description type: "text"
    }

    static constraints = {
        name(nullable: false, blank: false, maxSize: 100)
        description(nullable: false, blank: false, maxSize: 300)
        url(nullable: false, blank: false, maxSize: 1024)
        download(nullable: false)
        dateCreated(nullable: false)
        photo(nullable: true)
        canDownload(nullable: true)
        canPlay(nullable: true)
    }
}