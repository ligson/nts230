package nts.activity.domain

import nts.user.domain.Consumer
import nts.user.file.domain.UserFile
import nts.user.special.domain.UserSpecial

/***
 * 用户的作品
 */
class ActivitySharing {
    //可以共享专辑，也可以共享文件，有且只能共享一种类型
    UserSpecial special;
    UserFile userFile;
    UserActivity userActivity
    //共享人,和file或者special中的创建者一致，便于检索，但数据有冗余
    Consumer consumer
    //共享范围
    int shareRange = 0;
    boolean canDownload = true;
    Date createdDate = new Date();
    //描述，默认和special。file的一致
    String description;
    int state = 0;
    static constraints = {
        special(nullable: true)
        userFile(nullable: true)
        description(nullable: true, size: 0..1024)
    }

    static mapping = {
        state(column: "sharing_state")
    }
    static final rangeCnField = [
            0: "本小组",
            1: "本社区",
            2: "对外可见"
    ]

    static final stateCnField = [
            0: "待审批",
            1: "已审批",
            2: "未发布",
            3: "已发布"
    ]

}
