package nts.program.domain

class OutPlayLog {
	//福建省图采集点播日志,日志类型，尽量不用表关联，用于采集播放频率高的进入到分发列表,保存在访问的web节点数据库中
	//static belongsTo = 

    int programId = 0	//资源id
	int frequency = 1	//点播次数
	int consumerId = 0	//点播人在来源consmer中ID ，现在暂不用，用于扩展，可能以后会用
	int toNodeId = 0	//要分发对象的id(本地serverNode id),现在是上级节点,以后可能是同级节点或下级节点
	
	String playIP = ""	//点播人的IP
	
	Date dateCreated = new Date()				//操作时间 
	Date dateModified = new Date()

	int state = 1	//1未进入分发列表，2已进入分发列表 3已分发留作后用
	
	//大部分属性可为空，为以后扩展用，程序员据操作重要性方便性，设置相关属性
	static constraints = {
		playIP(nullable:true,blank:true,maxSize:250)		
	}

	final static int NO_DIST_STATE = 1 //未进入分发列表	
	final static int IN_DIST_STATE = 2 //已进入分发列表

	
	String toString() { programId }

	/** 福建省图采集点播日志 建表语句
	mysql:
	  CREATE TABLE out_play_log (
		id int auto_increment PRIMARY KEY NOT NULL ,
		version int NOT NULL ,
		consumer_id int NOT NULL ,
		date_created datetime NOT NULL ,
		date_modified datetime NOT NULL ,
		frequency int NOT NULL ,
		playip varchar (250) ,
		program_id int NOT NULL ,
		to_node_id int NOT NULL ,
		state int NOT NULL
	);
	ALTER TABLE out_play_log ADD INDEX ix_program_id (program_id);

	sqlserver:
		CREATE TABLE out_play_log (
		id int IDENTITY (1, 1) PRIMARY KEY NOT NULL ,
		version int NOT NULL ,
		consumer_id int NOT NULL ,
		date_created datetime NOT NULL ,
		date_modified datetime NOT NULL ,
		frequency int NOT NULL ,
		playip varchar (250) ,
		program_id int NOT NULL ,
		to_node_id int NOT NULL ,
		state int NOT NULL
	);
	create index ix_program_id on out_play_log (program_id);

	*/
}