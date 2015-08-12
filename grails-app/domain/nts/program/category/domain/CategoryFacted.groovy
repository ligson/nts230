package nts.program.category.domain

class CategoryFacted {
    ProgramCategory category
    String name
    String enName
    static hasMany = [values: FactedValue]
    Date createDate = new Date()
    int orderIndex = 1
    static constraints = {
    }
}
