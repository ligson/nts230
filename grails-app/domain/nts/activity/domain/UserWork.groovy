package nts.activity.domain

import nts.activity.domain.UserActivity
import nts.activity.domain.UserVote
import nts.user.domain.Consumer

/**
* 作品表，与UserActivity: nts.activity.domain.UserWork 关系1:n
*/
class UserWork
{
	static belongsTo = [userActivity:UserActivity,consumer:Consumer]
	static hasMany = [userVotes:UserVote]

	String name //作品名称
	String description //作品说明
	String svrAddress = ""
	String filePath = ""	//是从serial来的，也须赋值
	String photo = ""	//海报
    String fileHash
    String fileType

	int serialId = 0	//0是上传 大于0是从资源的serial选择,没用serial对象，故删除seria文件时要考虑到此情况
    int approval = 2 //审批状态
    int state = 3 //与serial表中一样定义一样，故宏不再定义 转码状态
    int urlType = 0    //与serial表中一样定义一样，故宏不再定义：final static int URL_TYPE_VIDEO = 0 .....
    int transcodeState = 0    // 与serial表中一样定义一样，故宏不再定义,如果是从seril中来的资源，须同步
    int voteNum = 0 //投票数 UserVote表中记录数,用于提高查询效率 一人一票，匿名用户不能投票
	int process = 0	//转码进度
    int visitCount = 0 //浏览次数

	Date dateCreated = new Date() //创建时间
	Date dateModified = dateCreated

	static mapping = {
		description  type:"text"
	}

	static constraints = {
		name(nullable:false,blank:false,maxSize:100)
		svrAddress(blank:true,maxSize:250)
		filePath(blank:true,maxSize:250)
		dateCreated(nullable:false)
        fileHash(nullable:true)
        fileType(nullable:true)
	}

	final static int NO_PASS_APPROVAL = 1 //审批未通过 对应approval
	final static int FOR_APPROVAL = 2 //待审批
	final static int PASS_APPROVAL = 3 //审批通过
}