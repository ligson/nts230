package nts.user.file.domain

import nts.user.domain.Consumer

/***
 * 用户自己分类，相当于目录
 */
class UserCategory implements Comparable<UserCategory> {
    static hasMany = [childCategories: UserCategory, userFiles: UserFile]

    //文件夹名称
    String name;
    //分类创建者
    Consumer consumer
    //子分类
    SortedSet<UserCategory> childCategories;
    //文件
    SortedSet<UserFile> userFiles;

    Date createdDate = new Date();
    Date modifyDate = new Date();

    //父分类。允许为空
    UserCategory fatherCategory

    //排序
    int orderIndex = 0;

    int state = 0;

    static constraints = {
        fatherCategory(nullable: true)
    }

    @Override
    int compareTo(UserCategory o) {
        return o.orderIndex - orderIndex;
    }

    static final stateCn = [
            0: "正常",
            1: "回收站",
            2: "已删除",
            3: "丢失",
            4: "不完整"
    ]
}
