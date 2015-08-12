package nts.user.domain

class Role {
    static hasMany = [resources:SecurityResource,userGroups:UserGroup,consumers:Consumer]
    String name
    String nickName
    Role parentRole
    int level=1 //级别
    int orderIndex=0 //顺序
    Date dataCreated=new Date() //创建时间
    Date dateCreated=dataCreated
    static constraints = {
        name(unique: true)
        parentRole(nullable: true)
        nickName(nullable: true)
    }
    static mapping = {
        table("nts_role")
    }
}
