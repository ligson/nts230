package nts.system.domain
/**
* 外部资源或友情链接
*/
class FriendLink
{	
	String name //链接名称
	String url = ""
	String photo = ""	//图片
	String description //说明

	int showOrder = 0	//
	
	Date dateCreated = new Date() //创建时间
	Date dateModified = dateCreated

	static constraints = {
		name(nullable:false,blank:false,maxSize:100)
		url(blank:false,maxSize:250)
		photo(nullable:true,blank:true,maxSize:250)
		description(nullable:true,blank:true,maxSize:500)		
	}

}