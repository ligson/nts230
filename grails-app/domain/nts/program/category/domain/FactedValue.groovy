package nts.program.category.domain

import nts.program.domain.Program

class FactedValue {
    CategoryFacted categoryFacted
    String contentValue
    int orderIndex
    static belongsTo = [Program]
    static hasMany = [programs:Program]
    static constraints = {
    }
}
