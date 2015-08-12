package nts.user.domain

class SecurityResource {
    static belongsTo = Role
    static hasMany = [roles:Role]
    String controllerName
    String actionName
    String controllerEnName
    String actionEnName
    String patternName
    String patternEnName
    static constraints = {
        patternEnName(nullable: true)
        patternName(nullable: true)
    }
}
