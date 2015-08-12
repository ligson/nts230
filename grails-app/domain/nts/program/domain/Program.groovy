package nts.program.domain

import nts.meta.domain.MetaContent
import nts.program.category.domain.FactedValue
import nts.program.category.domain.ProgramCategory
import nts.studycircle.domain.StudyCircle
import nts.system.domain.Directory
import nts.user.domain.Consumer
import nts.user.domain.UserGroup

class Program implements Serializable {
    Set<Serial> serials = new HashSet<Serial>();
    Set<MetaContent> metaContents = new HashSet<MetaContent>()
    Set<ProgramTag> programTags = new HashSet<ProgramTag>();
    Set<FactedValue> factedValues = new HashSet<FactedValue>();
    Set<ProgramCategory> programCategories = new HashSet<ProgramCategory>();
    static belongsTo = [ProgramCategory, Consumer, Directory]
    static hasMany = [serials            : Serial,
                      programTags        : ProgramTag,
                      remarks            : Remark,
                      collectedPrograms  : CollectedProgram,
                      playedPrograms     : PlayedProgram,
                      downloadedPrograms : DownloadedProgram,
                      viewedPrograms     : ViewedProgram,
                      recommendedPrograms: RecommendedProgram,
                      relationPrograms   : Program,
                      metaContents       : MetaContent,
                      playGroups         : UserGroup,
                      downloadGroups     : UserGroup,
                      programTopics      : ProgramTopic,
                      distributePrograms : DistributeProgram,
                      studyCircles       : StudyCircle,
                      factedValues       : FactedValue,
                      programCategories  : ProgramCategory
    ]
    //static searchable = true
    Consumer consumer
    Directory directory
    Directory classLib    //类库 Directory表中的一级目录 为了以后扩展目录树备用
    String name  //资源名称
    String actor = ""    //主演，者主要责任
    String director = ""    //导演，次要责任者，可能不用
    String guid = UUID.randomUUID().toString();    //guid
    String fromNodeName = "" //来源节点名称,用于分发收割,自己创建的资源为空
    String fromNodeIp = "" //来源节点IP,用于分发收割,自己创建的资源为空

    int type = 0    //格式类型
    //nts.program.domain.ProgramState state	//负数对应回收站 1未申请入库 2待审批 3审批未通过 4入库关闭 5入库打开 不用枚举类型是因为删除时×-1不好处理
    int state = 1
    int serialNum = 1    //子资源数
    int fromNodeId = 0    //来源节点id,是指本地serverNode数据表中id,自己创建的为0，分发来的是父节点ID，收割上来的是下级节点ID,一定要是本地的,根据来源ip查询serverNod获取

    int frequency = 0    //点播次数，用playNum更确切，但考虑到原vod系统,视频服务器用到了此字段，故沿用
    int remarkNum = 0    //评论次数
    int viewNum = 0    //浏览次数
    int downloadNum = 0    //下载次数
    int collectNum = 0    //收藏次数
    int recommendNum = 0    //推荐次数
    int fromState = 1    //来源：1是自己创建的 2上级分发下来的 3从下级收割上来的 4是从联盟收割上来的
    int nowVersion = 0    //现在版本,用于收割，新添加的资源为0,修改后加1，上级收割审批后，preVesion=nowVersion
    int preVersion = -1    //前版本,用于收割，新添加的资源为-1,上级收割审批后，preVesion=nowVersion
    int category = 0    //栏目
    int eidtion = 0    //版本
    int otherOption = 0    //其它选项,具体见，_OPTION： 1音频 2收割时是否发送对象 4纯文本 8纯图片
    int outClassId = 0    //来源库ID，如果是来源新东方或爱迪克森等库:100000新东方 100001爱迪科森 100002知识视界 200000其它
    //int limitRange = 2	//限制范围：由于hql不支持位运算，故用质数列取代，2私有 3分发 5联盟 7公开,其值为范围乘积

    boolean canPlay = true    //允许点播
    boolean canDownload = false    //允许下载
    boolean canAllPlay = true    //允许所有组或用户点播
    boolean canAllDownload = false    //允许所有组或用户下载
    boolean canDistribute = true    //是否可分发到下级节点
    boolean canUnion = false    //是否可分发到联盟
    boolean canPublic = false    //是否可公开
    boolean recommendState=false   //推荐状态  false不推荐 true推荐
    //boolean isDeleted	//是否是被删除的

    String description //资源简介
    int fromId = 0    //来源库标识ID，如果是来源新东方或爱迪克森等库，是原库ID，如果是收割或分发，则是源节点program表中id

    //海报
    String posterHash;
    String posterType;
    String posterPath;


    Date dateCreated = new Date()
    Date dateModified = dateCreated
    Date dateDeleted
    Date datePassed = dateCreated    //审批通过日期，即入库日期

    //开始日期
    Date openDate;
    //计划每周播出多少集
    int planCount;
    int transcodeState = STATE_RUNNING;
    //第一个分类的id, 方便寻找分面,上传路径
    long firstCategoryId;

    // 海报名称
    String posterName;

    // 专辑ID
    Long specialId;
    // 专辑名称
    String specialName;

    //竖版海报
    String verticalPosterHash;
    String verticalPosterType;
    String verticalPosterPath;
    String verticalPosterName;

    //资源评分
    float programScore = 0.0;

    static mapping = {
        description type: "text"
        directory(column: "directory_id")
        classLib(column: "class_lib_id")
        serials lazy: true
    }

    static constraints = {
        planCount(nullable: true)
        openDate(nullable: true)
        directory(nullable: true)
        classLib(nullable: true)
        posterHash(nullable: true)
        posterType(nullable: true)
        posterPath(nullable: true)
        posterName(nullable: true)
        name(nullable: false, blank: false, maxSize: 400)
        type(nullable: false)
        frequency(nullable: false)
        actor(nullable: true, blank: true, maxSize: 600)
        director(nullable: true, blank: true, maxSize: 400)
        description(nullable: true, blank: true, maxSize: 40000)
        guid(nullable: true, blank: true, maxSize: 250)
        remarkNum(nullable: false)
        viewNum(nullable: false)
        downloadNum(nullable: false)
        collectNum(nullable: false)
        recommendNum(nullable: false)
        state(nullable: false, rang: 1..100)
        dateDeleted(nullable: true)
        fromId(nullable: true, blank: true)
        fromNodeName(nullable: true, blank: true, maxSize: 250)
        fromNodeIp(nullable: true, blank: true, maxSize: 250)
        firstCategoryId(nullable: true)
        specialId(nullable: true)
        specialName(nullable: true)
        verticalPosterHash(nullable: true)
        verticalPosterType(nullable: true)
        verticalPosterPath(nullable: true)
        verticalPosterName(nullable: true)
        programScore(nullable: true)
    }

    def beforeUpdate = {
        dateModified = new Date()
    }

    final static cnTableName = '资源'
    final static cnField = [
            name         : '资源名称',
            type         : '资源格式',
            serialNum    : '资源数',
            frequency    : '点播次数',
            viewNum      : '浏览次数',
            downloadNum  : '下载次数',
            collectNum   : '收藏次数',
            recommendNum : '推荐次数',
            viewPrivilege: '浏览权限',
            playPrivilege: '点播权限',
            actor        : '主要责任者',
            director     : '次要责任者',
            directory    : '分类',
            description  : '内容描述',
            dateCreated  : '创建日期',
            dateModified : '修改日期',
            dateDeleted  : '删除日期',

            consumer     : '编辑者',
            serials      : '子目',
            programTags  : '关键词/标签',
            datePassed   : '上架日期',
            state        : '状态',
            canDistribute: '是否允许分发'
    ]

    public static final transcodeStateCn = [
            100: "不需要转码",
            0  : "等待转码",
            1  : "正在转码",
            2  : "转码成功",
            3  : "转码失败",
            4  : "已加入队列",
            5  : "部分转码成功"
    ]

    final static int NO_APPLY_STATE = 1 //未申请入库
    final static int NO_PASS_STATE = 2 //审批未通过
    final static int APPLY_STATE = 3 //待审批
    final static int CLOSE_STATE = 4 //入库关闭
    final static int PUBLIC_STATE = 5 //入库打开
    //final static int RECOMMEND_STATE = 6 //推荐值，可能不用

    //来源：1是自己创建的 2上级分发下来的 3从下级收割上来的
    final static int FROM_STATE_SELF = 1 //自己创建的
    final static int FROM_STATE_DISTRIBUTE = 2 //上级分发下来的
    final static int FROM_STATE_HARVEST = 3 //从下级收割上来的

    final static int ONLY_VIDEO_OPTION = 0    //0为默认纯视频
    final static int ONLY_AUDIO_OPTION = 1 //1纯音频
    final static int REAP_OBJ_OPTION = 2 // 2收割时是否发送对象
    final static int RICH_TEXT_OPTION = 4 // 4富文本
    final static int ONLY_TXT_OPTION = 8 // 8纯文本
    final static int ONLY_IMG_OPTION = 16 // 16纯图片
    final static int ONLY_LINK_OPTION = 32 // 32纯链接
    final static int ONLY_COURSE_OPTION = 64 // 64三分屏
    final static int ONLY_LESSION_OPTION = 128 //课程
    final static int ONLY_FLASH_OPTION = 6 //FLASH动画

    // 不需要转码
    public static final int STATE_NONE = 100;
    // 等待转码
    public static final int STATE_WAIT = 0;

    // 正在转码
    public static final int STATE_RUNNING = 1;
    // 部分转码成功
    public static final int STATE_SUCCESS_PART = 5;
    // 转码成功
    public static final int STATE_SUCCESS = 2;
    // 转码失败
    public static final int STATE_FAIL = 3;

    //正在转码队列中
    public static final int STATE_JOIN = 4;

    //权限范围
    //final static int LIMIT_RANGE_SELF = 2 //私有
    //final static int LIMIT_RANGE_DISTRIBUTE = 3 //分发
    //final static int LIMIT_RANGE_UNION = 5 //联盟
    //final static int LIMIT_RANGE_PUBLIC = 7 //公开


    final static cnState = [
            1: '未申请入库',
            2: '审批未通过',
            3: '待审批',
            4: '不发布',
            5: '发布'
    ]

    //推荐状态

    public  final static  boolean  PROGRAM_RECOMMEND=true;
    public  final static  boolean  PROGRAM_NOT_RECOMMEND=false;

    /*final static cnLimitRange = [
        2:'私有',
        3:'分发',
        5:'联盟',
        7:'公开'
    ]*/

    /** new field
     alter table program add category int not null default 0;
     alter table program add eidtion int not null default 0;
     alter table program add other_option int not null default 0;
     alter table program add out_class_id int not null default 0;

     update program set can_distribute = 0 where can_distribute is null;
     update program set pre_version = -1 where pre_version is null;
     update program set from_state = 0 where from_state is null;
     update program set from_node_id = 0 where from_node_id is null;
     update program set now_version = 0 where now_version is null;
     update program set category = 0 where category is null;
     update program set eidtion = 0 where eidtion is null;
     update program set other_option = 0 where other_option is null;
     update program set out_class_id = 0 where out_class_id is null;

     2012-06-29 later
     --update program set limit_range = 2 where limit_range is null;

     update program set can_union = 0 where can_union is null;
     update program set can_public = 0 where can_public is null;

     */
}
