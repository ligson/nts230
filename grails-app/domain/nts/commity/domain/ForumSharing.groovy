package nts.commity.domain

import nts.user.domain.Consumer
import nts.user.file.domain.UserFile
import nts.user.special.domain.UserSpecial

/***
 * 板块内共享
 */
class ForumSharing {
    //可以共享专辑，也可以共享文件，有且只能共享一种类型
    UserSpecial special;
    UserFile userFile;
    ForumBoard forumBoard;
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
    final static int SHARE_RANGE_BOARD = 0;
    final static int SHARE_RANGE_COMMUNITY = 1;
    final static int SHARE_RANGE_ALL = 2;


    final static int STATE_SHARING_WAITING_ALREADY = 0;
    final static int STATE_SHARING_ALREADY= 1;
    final static int STATE_SHARING_NO_PUBLISH = 2;
    final static int STATE_SHARING_PUBLISH = 3;
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
