package nts.user.file.domain

/***
 * 文件海报
 */
class FilePoster {

    UserFile userFile;
    String fileHash;
    String fileType;
    String filePath;
    long fileSize;
    String fileName;
    //展示的位置
    int showLocation = 0;
    static constraints = {
    }

    static final locationCnField = [
            0: "默认海报",
            1: "社区大图",
            2: "活动大图"
    ]

}
