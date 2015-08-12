package nts.user.domain

/**
 * Created by boful on 14-12-25.
 */
public enum ByteEnum {
    KILO(1),
    MEGA(2),
    GIGA(3),
    TRILLION(4),
    PETA(5),
    EXA(6),
    ZETTA(7),
    YOTTA(8),
    BRONTO(9)

    final int id
    ByteEnum(int id) { this.id = id }

    //状态数值对应中文名称
    static cnType = [
            1:'KB',
            2:'MB',
            3:'GB',
            4:'TB',
            5:'PB',
            6:'EB',
            7:'ZB',
            8:'YB',
            9:'BB'
    ]
}