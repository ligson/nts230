package nts.program.domain

import nts.program.domain.Program

class Serial implements Comparable {
    Set<Subtitle> subtitles = new HashSet<Subtitle>();
    static belongsTo = [program:Program]
    static hasMany = [subtitles: Subtitle]
    //static searchable = true

    String name
    int serialNo = 1//子节目序号
    int urlType = 0//原来mrs中用于视音频，课件，图片的分类
    int progType = 0    //文件格式
    int bandWidth = 0
    int timeLength = 0
    int state = 3 //转码状态
    int transcodeState = 0    //1. 标清. 2高清, 4超清,表示已经转码的文件
    int process = 0    //转码进度

    String svrAddress = ""
    int svrPort;
    String filePath = ""
    String startTime = "00:00:00" //因为与日期无关，故不用Date或Time
    String endTime = "00:00:00"
    String webPath = ""    //在线课件的虚拟目录
    String strProgType = ""    //字符串型文件格式
    String formatAbstract = ""    //格式摘要
    String description = "" //可能暂不用,mrs中用于描述每张图片
    String photo = ""    //海报
    //文件hash值
    String fileHash
    //文件后缀名
    String fileType

    Date dateCreated
    Date dateModified

    Long fileSize;

    static constraints = {
        name(maxSize: 250)
        serialNo(nullable: false, min: 1)
        urlType(nullable: false, min: -1)
        bandWidth(nullable: true)
        timeLength(nullable: true)
        svrAddress(nullable: true,blank: true, maxSize: 250)
        filePath(blank: true, maxSize: 250)
        startTime(maxSize: 10)
        endTime(maxSize: 10)
        webPath(nullable: true, blank: true, maxSize: 250)
        strProgType(nullable: true, blank: true, maxSize: 50)
        formatAbstract(nullable: true, blank: true, maxSize: 1100)
        description(nullable: true, blank: true, maxSize: 1000)
        photo(nullable: true, blank: true, maxSize: 250)
        //transcoding(nullable:false)
        fileHash(nullable: true)
        fileType(nullable: true)
        svrPort(nullable:true)
        fileSize(nullable:true)
    }

    def beforeInsert = {
        dateCreated = new Date()
        dateModified = dateCreated
    }

    //可在此删除物理文件
    def beforeDelete = {

    }

    int compareTo(obj) {
        (urlType * 1000 + serialNo).compareTo((obj.urlType) * 1000 + obj.serialNo)
    }

    final static cnField = [
            strProgType: '文件格式',
            formatAbstract: '格式摘要'
    ]

    ////对象URL类型数（当前只有视音频0，课件1，图片2 在线课件4）海报图片 3
    final static int URL_TYPE_UNKNOWN = -1 //未知类型
    final static int URL_TYPE_VIDEO = 0 //视频 适用于各种视频文件
    final static int URL_TYPE_COURSE = 1 //下载播放 下载到本地，通过MIME类型播放
    final static int URL_TYPE_IMAGE = 2 //图片
    final static int URL_TYPE_POSTER = 3 //海报图片
    final static int URL_TYPE_DOCUMENT = 4 //文档，适用于WORD,PPT,EXCEL,PDF等支持WEB-DAV协议的文档
    final static int URL_TYPE_MIDDLE_CONTROL = 5 //中控
    final static int URL_TYPE_ONLINE_COURSE = 6 //可以用浏览器打开的课件
    final static int URL_TYPE_TRURAN_COURSE = 7 //确然课件系统制作的课件，如确然的三分屏课件
    final static int URL_TYPE_LINK = 8 //可以用浏览器打开的各种链接，主要是http链接
    final static int URL_TYPE_MOBILE = 9 //移动手机点播
    final static int URL_TYPE_TABLET = 10 //移动平板点播
    final static int URL_TYPE_TEXT_LIBRARY = 11 //文库
    final static int URL_TYPE_EMBED_PC = 12    //嵌入式pc播放
    final static int URL_TYPE_AUDIO = 13  //音频 适用于各种音频文件

    final static int PLAY_TYPE_PC = 0 //pc电脑点播
    final static int PLAY_TYPE_MOBILE = 1 //移动手机点播
    final static int PLAY_TYPE_TABLET = 2 //移动平板点播

    final static int NO_NEED_STATE = 0 //不需要转码
    final static int NO_CODE_STATE = 1 //未转码 待转码
    final static int CODING_STATE = 2 //正在转码
    final static int CODED_STATE = 3 //已转码,系统转码
    final static int CODED_FAILED_STATE = 4 //转码失败

    final static int OPT_IMG_POSTER = 1 //对应字段：transcodeState 海报
    final static int OPT_DOC_LIB = 2 //对应字段：transcodeState 文库
    final static int OPT_ISO_VIRTUAL = 4 //对应字段：transcodeState 虚拟光驱
    final static int OPT_VIDEW_STANDARD = 8 //对应字段：transcodeState 标清,表示已经转码的文件
    final static int OPT_VIDEW_HIGH = 16 //对应字段：transcodeState 高清
    final static int OPT_VIDEW_SUPER = 32 //对应字段：transcodeState 超清

    final static urlTypeName = [
            '-1': '未知',
            0: '视频',
            1: '映象文件',
            2: '图片',
            //3:'海报图片',
            4: '文档',
            //5:'中控',
            6: '课件',
            //7:'确然课件',
            8: '链接',
            //9: "手机点播",
            //10: "平板点播",
            //11: "文库",
            //12: "嵌入式播放"
            13:'音频'
    ]

    final static stateName = [
            0: '不转码',
            1: '待转码',
            2: '正在转码',
            3: '已转码',
            4: '转码失败'
    ]

    //得到子目列表中的子类型文字符串
    def getCodeStateName() {
        def str = ""

        if (this.urlType == URL_TYPE_VIDEO) {
            if ((this.transcodeState & OPT_VIDEW_STANDARD) == OPT_VIDEW_STANDARD) str += "标清&nbsp;"
            if ((this.transcodeState & OPT_VIDEW_HIGH) == OPT_VIDEW_HIGH) str += "高清&nbsp;"
            if ((this.transcodeState & OPT_VIDEW_SUPER) == OPT_VIDEW_SUPER) str += "超清&nbsp;"
        } else if (this.urlType == URL_TYPE_COURSE) {
            if ((this.transcodeState & OPT_ISO_VIRTUAL) == OPT_ISO_VIRTUAL) str = "虚拟光驱"
        } else if (this.urlType == URL_TYPE_IMAGE) {
            if ((this.transcodeState & OPT_IMG_POSTER) == OPT_IMG_POSTER) str = "海报"
        } else if (this.urlType == URL_TYPE_DOCUMENT) {
            if ((this.transcodeState & OPT_DOC_LIB) == OPT_DOC_LIB) str = "文库"
        }

        return str
    }

    /*映象文件
        update serial set transcode_state =0 where transcode_state is null;
        update serial set process =0 where process is null;
    */
    /*修改数据库属性
        ALTER TABLE nts.serial CHANGE svr_address svr_address varchar(250);
        ALTER TABLE nts.serial MODIFY COLUMN svr_address varchar(250) NULL;
    */
}