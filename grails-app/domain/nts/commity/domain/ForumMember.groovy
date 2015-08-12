package nts.commity.domain

import nts.user.domain.Consumer

/***
 * 板块成员
 */
class ForumMember {
    ForumBoard forumBoard;
    Consumer consumer;
    StudyCommunity studyCommunity;
    //下载
    boolean canDownload = false;
    //上传共享
    boolean canUpload = false;
    //发帖
    boolean canCreateArticle = false;
    //回帖
    boolean canReply = false;
    //评论
    boolean canComment = false;
    //点播
    boolean canPlay = false;
    //加入日期
    Date joinDate = new Date();
    //状态
    int state = STATE_APPLY;

    static constraints = {
    }

    static mapping = {
        state(column: "member_state")
    }
    static final stateCn = [
            0: "正常",
            1: "锁定",
            2: "退出",
            3: "申请加入"
    ]

    static final int STATE_NORMAIL = 0;
    static final int STATE_LOCKED = 1;
    static final int STATE_QUIT = 2;
    static final int STATE_APPLY = 3;
}
