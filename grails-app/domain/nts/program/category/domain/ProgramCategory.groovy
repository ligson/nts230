package nts.program.category.domain

import nts.program.domain.Program

/**
 * 资源分类
 */
class ProgramCategory implements Comparable {

    Set<Program> programs = new HashSet<Program>();
    static hasMany = [programs: Program, facteds: CategoryFacted]
    String name;
    ProgramCategory parentCategory;//父类资源对象
    int level = 1;
    int orderIndex = 0 //顺序
    String description;
    int isDisplay = STATE_DISPLAY; //是否显示

    int mediaType = 1;//file type

    boolean allowDelete = true;
    String uploadPath                    //上传路径
    String img = ""                        //类库图片
    long directoryId; //对应元数据标准

    // 海报版式类型 0:横版 1:竖版
    String posterFormatType;

    //资源默认海报图片
    String defaultProgramPosterHash = ""; // 资源默认海报hash
    String defaultProgramPosterPath = ""; // 资源默认海报path

    static mapping = {
        table 'program_category'
        cache true
    }

    static constraints = {
        parentCategory(nullable: true)
        description(nullable: true)
        uploadPath(blank: true, nullable: true, maxSize: 500)
        img(nullable: true, blank: true, maxSize: 250)
        directoryId(nullable: true)
        posterFormatType(nullable: true)
        defaultProgramPosterHash(nullable: true)
        defaultProgramPosterPath(nullable: true)
    }

    static final mediaTypeCn = [
            0: '未知',
            1: '视频',
            2: '音频',
            3: '文档',
            4: '图片',
            5: '课程',
            6: 'flash动画'
    ]

    static final STATE_DISPLAY = 0;
    static final STATE_INVISIBLE = 1;

    @Override
    int compareTo(Object o) {
        if (o instanceof ProgramCategory) {
            ProgramCategory programCategory = (ProgramCategory) o;
            return this.orderIndex - programCategory.orderIndex;
        }
        return 0;
    }
}
