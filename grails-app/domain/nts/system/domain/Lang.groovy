package nts.system.domain
/**
 * 语种表
 */
class Lang {
    String shortName = ""
    String enName = ""
    String zhName = ""

    static constraints = {
        shortName(nullable:false,blank:false,size:1..50)
        enName(nullable:false,blank:false,size:1..100)
        zhName(nullable:false,blank:false,size:1..100)
    }
}
