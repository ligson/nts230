package nts.system.domain

class SysConfig {
	int configScope = 0
	int configMod = 0
	
    String configName
	String configValue
	String configDesc
	
	static constraints = {
		configScope(nullable:false,range:0..10000)
		configMod(nullable:false,range:0..10000)
		configName(unique:true,blank:false,maxSize:40)
		configValue(nullable:true,blank:true,maxSize:200)
		configDesc(nullable:true,blank:true,maxSize:200)
	}

	String toString() { configName }

	//��Ӧϵͳ���ļ���centerGrade
	final static int CENTER_GRADE_STATE = 1	//�������
    final static int CENTER_GRADE_PROVINCE = 2	//ʡ����
    final static int CENTER_GRADE_CITY = 3	//������
	final static int CENTER_GRADE_COUNTY = 4	//��
	final static int CENTER_GRADE_TOWNSHIP = 5	//����

	//��Ӧϵͳģ��ShowModOptѡ��ֵ
	final static int MOD_OPT_STUDY = 1	//ѧϰȦ
	final static int MOD_OPT_COMMUNITY = 2	//ѧϰ����
	final static int MOD_OPT_ACTIVITY = 4	//�
	final static int MOD_OPT_CLOUD = 8	//��Դ��

	// INSERT INTO sys_config(version,config_scope,config_mod,config_name,config_value,config_desc) VALUES (0, 0,0, 'MetaDefineAllowModifyOpt', '0','Ԫ��ݱ༭ʱ�����޸�����ѡ��');
	// INSERT INTO sys_config(version,config_scope,config_mod,config_name,config_value,config_desc) VALUES (0, 0,0, 'DistributeModState', '1','�ַ�ģ��״̬');
	// INSERT INTO sys_config(version,config_scope,config_mod,config_name,config_value,config_desc) VALUES (0, 0,0, 'ClientName', 'boful','�ͻ����');
}