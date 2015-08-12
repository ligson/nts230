package nts.studycircle.domain

import nts.commity.domain.ForumBoard
import nts.program.domain.Program
import nts.studycircle.domain.CircleQuestion
import nts.studycircle.domain.Participant
import nts.system.domain.RMSCategory
import nts.user.domain.Consumer

/**
*ѧϰȦ
*/
class StudyCircle
{	
	//Forum forum �������� 1:1
	//nts.studycircle.domain.CircleQuestion question ����ɿ������ 1:n
	//nts.system.domain.RMSCategory category ��� n��1
	//nts.program.domain.Program quoteprogram ���õ���Դ n��n
	//nts.studycircle.domain.Participant participant Ȧ�ڳ�Ա��Э���ߣ������ߣ�
	//nts.system.domain.LogsPublic circleLog Ȧ�ڶ�̬����־�� 1��n
	//Forum forum �������� 1:1
	//nts.user.domain.Consumer createConsumer ������ n��1

	//Forum forum 
	Consumer createConsumer
	RMSCategory circleCategory
	static belongsTo = [Program]
    Set<Program> quoteprograms = new HashSet<Program>();
	static hasMany = [quoteprograms:Program, participants:Participant, questions:CircleQuestion, forumBoards:ForumBoard]

	String name //ѧϰȦ����
	String photo //����ͼ
	boolean isOpen = false //�Ƿ񿪷� 0-������ 1-����
	String description //���
	Date dateCreated = new Date() //����ʱ��
	int state = 1 //ѧϰȦ��ϵͳ�е�״̬ 0-�ѽ��� 1-��ͨ�� 2-����� 
	boolean isRecommend = false //�Ƿ�Ϊ�Ƽ�ѧϰȦ true-�Ƽ� false-���Ƽ�
	int participantsCount = 0 //ѧϰȦ��Ա���ݶ�Ӧ��nts.studycircle.domain.Participant���ж�̬����

	static mapping = {
		description  type:"text"
	}

	static constraints = {
		name(nullable:false,blank:false,maxSize:100)
		photo(nullable:false,blank:false,maxSize:100)
		isOpen(nullable:false,rang:0..1)
		description(nullable:false,blank:false,maxSize:500)
		state(nullable:false,rang:0..2)
		dateCreated(nullable:false)
		circleCategory(nullable:true)	
	}

	final static int STUDYCIRCLE_PUBLISH = 1 //�Ƿ񿪷� 1-����
	final static int STUDYCIRCLE_NOPUBLISH = 0 //�Ƿ񿪷� 0-������
	static final int STUDYCIRCLE_STATE_PASS = 1 //ѧϰȦ��ϵͳ�е�״̬ 1-��ͨ��
	static final int STUDYCIRCLE_STATE_EXAMINE = 2 //ѧϰȦ��ϵͳ�е�״̬ 2-�����
	static final int STUDYCIRCLE_STATE_FORBIDDEN = 0 //ѧϰȦ��ϵͳ�е�״̬ 0-�ѽ���

	final static cnField = [
		0:'�ѽ���',
		1:'��ͨ��',
		2:'�����'
	]
}