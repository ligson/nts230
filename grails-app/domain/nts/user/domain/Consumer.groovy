package nts.user.domain

import nts.activity.domain.UserActivity
import nts.activity.domain.UserVote
import nts.activity.domain.UserWork
import nts.commity.domain.Activity
import nts.commity.domain.ActivitySubject
import nts.commity.domain.BbsTopic
import nts.commity.domain.ForumBoard
import nts.commity.domain.ForumMainArticle
import nts.commity.domain.ForumReplyArticle
import nts.commity.domain.ForumReplySubjectArticle
import nts.commity.domain.Sharing
import nts.commity.domain.StudyCommunity
import nts.program.category.domain.ProgramCategory
import nts.program.domain.CollectedProgram
import nts.program.domain.DownloadedProgram
import nts.program.domain.PlayedProgram
import nts.program.domain.Program
import nts.program.domain.ProgramTag
import nts.program.domain.ProgramTopic
import nts.program.domain.RecommendedProgram
import nts.program.domain.Remark
import nts.program.domain.ViewedProgram
import nts.studycircle.domain.Answer
import nts.studycircle.domain.CircleQuestion
import nts.studycircle.domain.StudyCircle
import nts.system.domain.Directory
import nts.system.domain.Errors
import nts.system.domain.News
import nts.system.domain.Qnaire
import nts.system.domain.Survey

class Consumer {

    Set<Directory> directorys = new HashSet<Directory>();
	Set<ProgramCategory> programCategorys = new HashSet<ProgramCategory>();
    static belongsTo = [StudyCommunity]
	static hasMany=[userGroups:UserGroup,
		directorys:Directory,
		programCategorys:ProgramCategory,
		programs:Program,
		collectedPrograms:CollectedProgram,
		playedPrograms:PlayedProgram,
		viewedPrograms:ViewedProgram,
		downloadedPrograms:DownloadedProgram,
		recommendedPrograms:RecommendedProgram,
		programTags:ProgramTag,
		userErrors:Errors,
		userNews:News,
		remarks:Remark,
		consumerSubjects:ConsumerSubject,
		subject:Subjects,
		topics:Topic,
		surveys:Survey,
		qnaires:Qnaire,
		programTopics:ProgramTopic,
		bbsTopics:BbsTopic,
		studyCircles:StudyCircle,
		circleQuestion:CircleQuestion,
		forumBoards:ForumBoard,
		forumMainArticles:ForumMainArticle,
		forumReplyArticles:ForumReplyArticle,
		forumReplySubjectArticles:ForumReplySubjectArticle,
		memberCommunitys:StudyCommunity,
		sharings:Sharing,
		activitys:Activity,
		activitySubjects:ActivitySubject,
		userActivitys:UserActivity,
		userWorks:UserWork,
		userVotes:UserVote,
		answers:Answer]
	


    String name					//用户名
	String password				//密码
	String nickname				//昵称
	String trueName				//真实姓名
	String photo					//照片
	String address					//用户住址
	String postalcode				//邮政编码
	String telephone				//联系电话
	String idCard					//身份证号
	String email					//邮件
	String savePath				//保存路径
	String descriptions				//用户描述信息
	String profession				//用户专业
	College	college				//学生所属院系
	
    Role userRole
	int gender = 1						//性别 0-女 1-男
	int uploadState	= 0					//是否上传 0-否 1-是 2-申请  用户默认是0 管理员是1
	int bandWidth = 10						//带宽
	int role = 3								//用户角色 0-Master(超级管理员)  1-资源管理员（可对节目）2-普通用户-教师 3-普通用户-学生
	int userJob = 16							//用户工作&身份   1教师  2科研人员  4行政管理人员  8教辅管理人员  16学生  32其他 
	int userEducation = 1						//用户学历  0专科  1本科  2硕士  3博士  4博士后  5其他 
	int jobName	= 64						//用户职称   1助教  2讲师  4副教授  8教授  16硕士生导师  32博士生导师  64其他
	int loginNum = 0							//登陆次数
	int viewNum	= 0						//浏览次数
	int playNum	= 0						//点播次数
	int downloadNum	= 0						//下载次数
	int uploadNum = 0							//上传次数，指创建资源数
	int collectNum	= 0							//收藏次数

	boolean allGroup = false						//用户分组标志  0-表示用户不分组属于用户组，值为1表示用户已经分组。
	boolean canDownload	= true				//是否下载 0-否 1-是 用户默认是0 管理员是1
	boolean canComment = true					//是否可以发表评论 0-否 1-是 默认是1 
	boolean notExamine = false						//审核状态上传节目是否审核  1-免审 0-审核
	boolean isRegister = false					//检查用户是否是正式用户 1-正式用户 0-未审批用户 
	boolean userState = true						//用户状态  0-禁用 1-活动 禁用后不可点播节目
    boolean canPlay = false                 //是否可点播资源 0-否 1-是

	Date dateCreated = new Date()				//创建时间 
	Date dateModified = new Date()				//修改时间
	Date dateLastLogin = new Date()				//最后登陆时间 
	Date dateEnterSchool = new Date()			//入学时间
	Date dateValid = Date.parse("yyyy-MM-dd","2080-11-11")  				//有效时间

    // 个人空间大小
    Integer spaceSize = 0;
    // 个人空间大小的单位 1：KB 2:MB 3:GB
    Integer spaceSizeUnit=0;
    // 个人空间的最大值
    Long maxSpaceSize=0;
    // 已经使用的个人空间
    Long useSpaceSize=0;

	static constraints = {

		name(unique:true,blank:false,size:2..50)
		password(blank:false,size:6..100)
		nickname(unique:false,blank:true,size:2..50)
		trueName(nullable:true,blank:true,maxSize:50)
		email(nullable:true,email:true,maxSize:200)
		telephone(nullable:true,blank:true,maxSize:40)
		photo(nullable:true,blank:true,maxSize:250)
		savePath(nullable:true,blank:true,maxSize:250)
		dateCreated(nullable:true,blank:true)
		dateValid(nullable:true,blank:true)
		dateEnterSchool(nullable:true,blank:true)
		address(nullable:true,blank:true,maxSize:200)			
		postalcode(nullable:true,blank:true,maxSize:6)		
		idCard(nullable:true,blank:true,matchs:/[0-9]/,maxSize:40)		
		college(nullable:true,blank:true)				
		descriptions(nullable:true,blank:true,maxSize:200)
		profession(nullable:true,blank:true,maxSize:100)		


		gender(range:0..1)
		uploadState(range:0..2)	
		canDownload(range:0..1)
        canPlay(range:0..1)
		userState(range:0..1)
		canComment(range:0..1)
		role(range:0..4)
		userJob(nullable:true,blank:true)	
		userEducation(nullable:true,blank:true)
		jobName(nullable:true,blank:true)

		allGroup(nullable:true)
		isRegister(nullable:true,blank:true,range:0..1)
		notExamine(nullable:true,blank:true,range:0..1)
		bandWidth(nullable:true,blank:true)

		dateLastLogin(nullable:true,blank:true)
		dateModified(nullable:true,blank:true)
        userRole(nullable: true)
        spaceSize(nullable: true)
        spaceSizeUnit(nullable: true)
        maxSpaceSize(nullable: true)
        useSpaceSize(nullable: true)
	}

	def beforeInsert = {
		dateModified = new Date()
		dateLastLogin=new Date()
	}

	def beforeUpdate = {
		dateModified = new Date()
	}

	static cnTableName = '用户'
	static cnField = [
		name:'用户名称'
		]

	String toString() { name }

	final static int NO_UPLOAD_STATE  = 0		//上传 0-否
	final static int CAN_UPLOAD_STATE  = 1		//上传 1-是
	final static int APPLY_UPLOAD_STATE  = 2 	//上传 2-申请

	final static int SUPER_ROLE  = 0				//用户角色 0-Master(超级管理员)
	final static int MANAGER_ROLE  = 1			//1-资源管理员
	final static int TEACHER_ROLE  = 2			//2-普通用户-教师
	final static int STUDENT_ROLE  = 3			//3-普通用户-学生
}