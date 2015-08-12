package nts.broadcast.domain

class  CourseBcast{
	String channel		//频道名称
	String title		//频道主题
	String author		//频道主讲
	String notes		//频道描述
	String screenUrl	//屏幕流Url
	String mediaUrl		//音视频流Url
	String multcastIP	//组播地址
	String mediaPushIP 	//
	String screenPushIP 	//
	String askServerIP	//服务器地址
	String screenSource	//屏幕流信号来源
	String mediaSource	//音视频信号来源
	String askServerTeacher //主讲人账号

	boolean isMultcast = true	//是否允许组播
	boolean isMediaPush = true	//音视频模式是否为推模式
	

	int multcastPort = 0 	//组播端口
	int multcastSize = 0 	//
	int mediaPushPort = 0	//音视频接受端口
	int screenPushPort = 0 	//屏幕流接受端口
	int askServerPort = 0	//服务器端口
	int privilege = 0  	//权限级别
	int state = 0		//状态 ru
	
	Date dateCreated = new Date()
	Date dateModified = new Date()
	Date datePlayed = new Date()
	Date dateDeleted = new Date()
	static constraints={
		
		notes(maxSize:800,blank:true,nullable:true)
		multcastIP(maxSize:100,blank:true,nullable:true)
		mediaSource(maxSize:200,blank:true,nullable:true)
		screenSource(maxSize:200,blank:true,nullable:true)
		mediaPushIP(maxSize:100,blank:true,nullable:true)
	        screenPushIP(maxSize:100,blank:true,nullable:true)
		askServerIP(maxSize:100,blank:true,nullable:true)
		askServerTeacher(maxSize:100,blank:true,nullable:true)
		 state(blank:true,nullable:true)

		dateCreated(nullable:true)
		dateModified(nullable:true)
		dateDeleted(nullable:true)

         }
}
