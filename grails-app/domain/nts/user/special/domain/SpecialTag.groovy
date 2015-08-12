package nts.user.special.domain

/**
 * 专辑标签
 */
class SpecialTag {
    String name
    UserSpecial special;
    Date createdDate = new Date();
    static constraints = {
    }
}
