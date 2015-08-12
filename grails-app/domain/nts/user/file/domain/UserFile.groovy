package nts.user.file.domain

import nts.user.domain.Consumer

/***
 * 用户文件
 */
class UserFile implements Comparable<UserFile> {

    static hasMany = [tags: UserFileTag, posters: FilePoster]
    //文件名称
    String name
    //文件后缀名
    String fileType
    //文件hash，hex，大写
    String fileHash
    //文件保存路径
    String filePath
    //文件物理大小
    long fileSize;
    //文件描述
    String description
    //文档表示页数，视频是时长（单位秒）
    long timeLength = 0
    int transcodeState = 1    //1. 未转码. 2.正在转码, 3.转码成功,4转码失败
    //文件创建者
    Consumer consumer
    //是否公开,共享后可以被其他人看见
    boolean canPublic = false
    //允许下载
    boolean allowDownload = true;
    boolean allowRemark = true;
    //文件分类，null为未分类
    UserCategory userCategory
    //文件创建日期
    Date createdDate = new Date();
    //文件最后一次修改日期
    Date modifyDate = new Date();
    //排序使用
    int orderIndex = 0;
    int state = 0;
    int viewNum = 0; //浏览量
    int downloadNum = 0; //下载量
    static constraints = {
        userCategory(nullable: true)
        description(nullable: true)
    }

    static mapping = {
        state(column:"file_state")
    }

    @Override
    int compareTo(UserFile o) {
        return o.orderIndex - orderIndex;
    }

    static final transcodeStateCn = [
            1: "未转码",
            2: "正在转码",
            3: "转码成功",
            4: "转码失败"
    ]
    static final  stateCn = [
            0:"正常",
            1:"回收站",
            2:"已删除",
            3:"丢失",
            4:"不完整"
    ]
}
