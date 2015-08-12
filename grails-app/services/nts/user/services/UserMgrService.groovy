package nts.user.services

import groovy.sql.Sql
import nts.studycircle.domain.Participant
import nts.system.domain.OperationEnum
import nts.system.domain.OperationLog
import nts.user.domain.College
import nts.user.domain.Consumer
import nts.user.domain.Role
import nts.user.domain.SecurityResource
import nts.user.domain.UserGroup
import nts.utils.CTools
import org.springframework.dao.DataIntegrityViolationException

import java.text.DateFormat
import java.text.SimpleDateFormat

class UserMgrService {
    def utilService;
    def dataSource;

    public Map roleManager(Map params){
        def parentRole=null;
        if(params.parentId){
            parentRole=Role.findAllByParentRole(Role.get(params.parentId as Long));
        }else{
            parentRole=Role.findAllByParentRole(null);
        }
        List<Role> roleList = new ArrayList<Role>();
        parentRole.each {
            def tmp=[:];
            tmp.id=it.id;
            tmp.name=it.name;
            tmp.isParent=Role.countByParentRole(it);
            if(parentRole){
                tmp.parentRole=it.parentRole;
            }
            tmp.level=it.level;
            tmp.orderIndex=it.orderIndex;
            roleList.add(tmp);
        }
        def result=[:];
        result.roleList=roleList;
        return result;
    }

    public Map createRole(Map params){
        def result=[:];
        String name=params.name;
        def parentId;
        if(params.parentId==""){
            parentId=0;
        }else{
            parentId=Long.parseLong(params.parentId);
        }
        Role parentRole=Role.get(parentId);
        Role role=Role.findByParentRoleAndName(parentRole,name);
        if(role){
            result.success=false;
            result.msg="该角色已经存在!";
        }else{
            Role role1=new Role();
            role1.name=name;
            role1.dataCreated=new Date();
            role1.parentRole=parentRole;
            if(role1.save(flush: true)&&(!role1.hasErrors())){
                result.success=true;
                result.msg="角色添加成功!"
            }else{
                result.success=false;
                result.msg="角色添加失败!"
            }
        }
        return result;
    }

    public Map updateRole(Map params){
        def result=[:];
        Role role1 = Role.findByIdAndName(params.id as Long,params.name)
        if(role1){
            result.success=false;
            result.msg="角色已经存在"
        }else {
            def role=Role.get(params.id as Long);
            if(role){
                role.name=params.name;
                if(role.save(flush: true)&&(!role.hasErrors())){
                    result.success=true;
                    result.msg="修改成功"
                }else{
                    result.success=false;
                    result.msg="修改失败"
                }
            }else{
                result.success=false;
                result.msg="角色不存在"
            }
        }

        return result;
    }
    public Map deleteRole(Map params){
        def result=[:];
        if(params.id){
            Role role=Role.get(params.id as Long);
            if(role){
                int count=Role.countByParentRole(role);
                int userGroupCount=UserGroup.countByRole(role);
                int consumerCount=Consumer.countByUserRole(role);
                if(count==0 && userGroupCount==0 && consumerCount==0){
                    role.delete(flush: true);
                    result.success = true;
                    result.msg = "节点删除成功!"
                }else{
                    result.success = false;
                    result.msg = "节点下面还有子节点、用户、用户组!";
                }
            }else{
                result.success = false;
                result.msg = "节点不存在!";
            }
        }else{
            result.success = false;
            result.msg = "参数不全!";
        }

        return result;
    }

    public Map createResource(Map params){
        def result=[:];
        List<String> ids = new ArrayList<String>();
        if(params.actionId instanceof String){
            ids.add(params.actionId);
        } else {
            ids.addAll(params.actionId)
        }

        if(params.id){
            Role role=Role.get(params.id as Long);
            def resources;
            ids.each {
                resources = SecurityResource.findAllByPatternName(it);
                if(role&&resources){
                    resources.each {resource ->
                        Role role1=role.addToResources(resource);
                        SecurityResource resource1=resource.addToRoles(role);
                        if(role1&&resource1){
                            result.success = true;
                            result.msg = "角色添加权限成功!"
                        }else{
                            result.success = false;
                            result.msg = "角色添加权限失败!"
                        }
                    }
                }else{
                    result.success = false;
                    result.msg = "节点不存在!";
                }
            }
        }else{
            result.success = false;
            result.msg = "参数不全!";
        }
        return result
    }
    public Map appendActionNameList(Map params){
        def result=[:];
        def appendHtml="";
        List<SecurityResource> resources=[];
        if(params.id){
            SecurityResource resource=SecurityResource.get(params.id as Long);
            Role role = Role.get(params.roleId as Long);
            List<SecurityResource> haveResources = role.resources.toList();
            List<String> havePatternName=[];
            for(int i=0;i<haveResources.size();i++) {
                havePatternName.add(haveResources[i].patternName);
            }

            def controllerName=resource.controllerName;

            Sql sql = new Sql(dataSource);
            resources = sql.rows("SELECT DISTINCT pattern_name FROM security_resource WHERE controller_name=? AND pattern_name IS NOT NULL",controllerName);

            if(resources.size()>0) {
                appendHtml="<input type=\"checkbox\" name=\"userRoleAll\">全选择&nbsp;/&nbsp;取消<br>"
            }

            for(int i=0;i<resources.size();i++){
                def patternName=resources[i].pattern_name;
                appendHtml+="<input ${havePatternName.contains(patternName)?'checked':''} type=\"checkbox\" value=\""+patternName+"\" name='actionId'>"+patternName+"&nbsp;&nbsp;&nbsp;&nbsp;";
            }
        }else{
            result.appendHtml="";
        }
        result.appendHtml=appendHtml;
        return result
    }
//
//    public Map createResourceAjax(Map params){
//        def result=[:];
//        def appendHtml="";
//        def removeHtml="";
//        Role role;
//        if(params.id){
//            role=Role.get(params.id as Long);
//        }
//        def resources=SecurityResource.createCriteria().list(max:params.max,offset:params.offset){
//            if(params.id){
//                roles {
//                    eq('id',params.id as Long)
//                }
//            }
//        }
//        if(resources){
//            appendHtml+="<h2 style=\"margin: 0 0 10px 0; font-size: 14px; \">权限列表：</h2>";
//            appendHtml+="<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" bordercolor=\"#e2e2e2\" style=\"width: 800px;border: #e2e2e2 1px solid;\">";
//            appendHtml+="<tr style=\"height: 32px;\"><td width=\"35\" align=\"center\">ID</td><td width=\"204\" align=\"center\">角色</td><td width=\"204\" align=\"center\">权限</td><td width=\"204\" align=\"center\">操作</td></tr>";
//            for(int i=0;i<resources.size();i++){
//                def id=resources[i].id;
//                def name=resources[i].controllerName+"-"+resources[i].actionName;
//                removeHtml="<input type=\"button\" class=\"clear_border\" value=\"删除权限\" onclick='removeResource("+id+","+role?.id+")'>";
//                appendHtml+="<tr id='id"+id+"'><td align=\"center\">"+id+"</td><td align=\"center\">"+role?.name+"</td><td align=\"center\">"+name+"</td><td>"+removeHtml+"</td></tr>";
//            }
//            appendHtml+="</table>";
//        }else{
//            appendHtml+="<div style=\" line-height: 26px; font-size: 14px; font-weight:bold;color:red;margin: 0 0 20px 10px;\">";
//            appendHtml+=role?.name+"没有被赋予任何权限";
//            appendHtml+="</div>";
//        }
//        result.appendHtml=appendHtml;
//        result.total = resources.totalCount;
//        result.roleId = params.id;
//        return result;
//    }

    public Map resourceList(Map params){
        def result=[:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def appendHtml="";
        def removeHtml="";
        Role role;
        if(params.id){
            role=Role.get(params.id as Long);
        }
        def resources=SecurityResource.createCriteria().list(max:params.max,offset:params.offset){
            if(params.id){
                roles {
                    eq('id',params.id as Long)
                }
            }
        }
        if(resources){
            def total = resources.totalCount;
            result.page = page;
            //总记录数
            result.records = total;
            //总页数
            result.total = Math.ceil(total * 1.00 / params.max);
            result.rows = [];
            resources?.each{
                def tmp = [:];
                tmp.id = it.id;
                tmp.roleId = role?.id;
                tmp.role = role?.name;
                tmp.resource = it.controllerName+"-"+it.actionName;
                result.rows.add(tmp);
            }
        }
        return result;
    }

    public Map removeResource(Map params){
        def result=[:];
        if(params.id&&params.roleId){
            SecurityResource resource=SecurityResource.get(params.id as Long);
            Role role=Role.get(params.roleId as Long);
            if(resource&&role){
                resource.removeFromRoles(role);
                role.removeFromResources(resource);
                result.success=true;
                result.msg="角色"+role?.name+"移除"+resource?.actionName+"权限成功!";
            }else{
                result.success=false;
                result.msg="权限不存在"
            }
        }else{
            result.success = false;
            result.msg = "参数不全!";
        }
        return result
    }

    public Map createUserGroupRole(Map params){
        def result=[:];
        def idList=[];
        if(params.idList.indexOf(',')){
            String[] str=params.idList.split(',');
            str.each {
                idList.add(it);
            }
        }else{
            idList=[params.idList];
        }
        if(params.roleId&&idList.size()>0){
            Role role=Role.get(params.roleId as Long);
            idList.each {
                UserGroup userGroup=UserGroup.get(it as Long);
                if(role&&userGroup){
                    def isExist=userGroup.role;
                    if(isExist){
                        result.success=false;
                        result.msg=userGroup?.name+"用户组角色已经存在"
                    }else{
                        Role role1=role.addToUserGroups(userGroup);
                        if(role1.save(flush: true)&&(!role1.hasErrors())){
                            result.success=true;
                            result.msg=userGroup?.name+"用户组添加角色成功"
                        }else{
                            result.success=false;
                            result.msg=userGroup?.name+"用户组添加角色失败"
                        }
                    }

                }else{
                    result.success=false;
                    result.msg="用户组不存在"
                }
            }
        }else{
            result.success = false;
            result.msg = "参数不全!";
        }

        return result
    }
    public Map moveUserGroup(Map params){
        def result=[:];
        def idList=[];
        if(params.idList.indexOf(',')){
            String[] str=params.idList.split(',');
            str.each {
                idList.add(it);
            }
        }else{
            idList=[params.idList];
        }
        if(params.roleId&&idList.size()>0){
            Role role=Role.get(params.roleId as Long);
            idList.each {
                UserGroup userGroup=UserGroup.get(it as Long);
                if(role&&userGroup){
                    def isExist=UserGroup.createCriteria().list(){
                        eq("role",role)
                        eq("id",userGroup.id)
                    };
                    if(isExist){
                        result.success=false;
                        result.msg=userGroup?.name+"用户组角色已经存在"
                    }else{
                        Role oldRole=userGroup.role;
                        oldRole.removeFromUserGroups(userGroup);
                        Role newRole=role.addToUserGroups(userGroup);
                        if(newRole.save(flush: true)&&(!newRole.hasErrors())){
                            result.success=true;
                            result.msg=userGroup?.name+"用户组角色移动成功"
                        }else{
                            result.success=false;
                            result.msg=userGroup?.name+"用户组角色移动失败"
                        }
                    }
                }else{
                    result.success=false;
                    result.msg=role?.name+"角色没有用户组"+userGroup?.name
                }
            }
        }else{
            result.success = false;
            result.msg = "参数不全!";
        }

        return result
    }

    public Map userGroupList(Map params){
        def result=[:];
        def appendHtml="";
        def buttonHtml="";
        def removeHtml="";
        def moveRole="";
        def total=0;
        if(params.roleId){
            Role role=Role.get(params.roleId as Long);
            if(role){
                def userGroups=UserGroup.createCriteria().list(max:params.max,offset:params.offset){
                    eq("role",role)
                }

                if(userGroups){
                    total=userGroups.totalCount
                    appendHtml+="<h2 style=\"margin: 0 0 10px 0; font-size: 14px; \">用户组角色列表：</h2>";
                    appendHtml+="<table  border=\"1\" cellpadding=\"0\" cellspacing=\"0\" bordercolor=\"#e2e2e2\" style=\"width: 800px;border: #e2e2e2 1px solid;\">";
                    appendHtml+="<tr style=\"height: 32px;\"><td width=\"35\" align=\"center\">选择</td><td width=\"60\" align=\"center\">ID</td><td width=\"204\" align=\"center\">用户组</td><td width=\"196\" align=\"center\">角色</td><td align=\"center\" width=\"293\">操作</td></tr>";
                    for(int i=0;i<userGroups.size();i++){
                        def id=userGroups[i].id;
                        def name=userGroups[i].name;
                        def check="<input type=\"checkbox\" name=\"idList\" id=\"id"+id+"\" onchange=\"checkId("+id+")\">";
                        buttonHtml="<input class=\"clear_border\" type=\"button\" value=\"添加角色\" onclick=\"createUserGroup('"+name+"',"+id+")\">";
                        removeHtml="<input class=\"clear_border\" type=\"button\" value=\"删除角色\" onclick=\"removeUserGroup("+id+")\">";
                        moveRole="<input class=\"clear_border\" type=\"button\" value=\"调整用户组角色\" onclick=\"moveUserGroup('"+name+"',"+id+")\">";
                        appendHtml+="<tr><td align=\"center\">"+check+"</td><td align=\"center\">"+id+"</td><td align=\"center\">"+name+"</td><td align=\"center\">"+role?.name+"</td><td>"+buttonHtml+""+removeHtml+""+moveRole+"</td></tr>";
                    }
                    appendHtml+="</table>";
                    appendHtml+="<input type=\"button\" class=\"ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only\" style=\"margin-top: 5px;\" value=\"全选\" onclick=\"checkAllUserGroup(${userGroups?.id})\">";
                    appendHtml+="<input type=\"button\" class=\"ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only\" style=\"margin-top: 5px;\" value=\"用户组添加角色\" onclick=\"addAll()\"/>";
                }else{
                    appendHtml+="<div style=\" line-height: 26px; font-size: 14px; font-weight:bold;color:red;margin: 0 0 20px 0;\">";
                    appendHtml+=role?.name+"角色下没有用户组";
                    appendHtml+="</div>";
                }

            }
        }
        result.appendHtml=appendHtml;
        result.total=total;
        return result
    }

    public Map removeUserGroup(Map params){
        def result=[:];
        if(params.userGroupId){
            UserGroup userGroup=UserGroup.get(params.userGroupId as Long);
            if(userGroup){
                def role=userGroup.role
                if(role){
                    role.removeFromUserGroups(userGroup);
                    result.success=true;
                    result.msg=role?.name+"移除用户组成功";
                }else{
                    result.success=false;
                    result.msg=userGroup?.name+"用户组没有角色"
                }
            }else{
                result.success=false;
                result.msg=userGroup?.name+"用户组没有"+role?.name+"角色"
            }
        }else{
            result.success = false;
            result.msg = "参数不全!";
        }
        return result
    }
    public Map consumerRoleAjax(Map params){
        def result=[:];
        def appendHtml="";
        def buttonHtml="";
        def removeHtml="";
        def moveRole="";
        def total=0;
        if(params.roleId){
            Role role=Role.get(params.roleId as Long);
            if(role){
                def consumers=Consumer.createCriteria().list(max:params.amx,offset:params.offset){
                    eq("userRole",role)
                };

                if(consumers){
                    total=consumers.totalCount;
                    appendHtml+="<h2 style=\"margin: 0 0 10px 0; font-size: 14px; \">用户角色列表：</h2>";
                    appendHtml+="<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" bordercolor=\"#e2e2e2\" style=\"width:800px;line-height:28px;border: #e2e2e2 1px solid; \">";
                    appendHtml+="<tr class=\"th\"><td width=\"35\" align=\"center\">选择</td><td width=\"60\" align=\"center\">ID</td><td width=\"196\" align=\"center\">角色</td><td width=\"204\" align=\"center\">用户</td><td width=\"293\" align=\"center\">操作</td></tr>";
                    for(int i=0;i<consumers.size();i++){
                        def id=consumers[i].id;
                        def name=consumers[i].name;
                        def check="<input type=\"checkbox\" name=\"idList\" id=\"id"+id+"\" onchange=\"checkId("+id+")\">";
                        buttonHtml="<input type=\"button\" class=\"clear_border\" value=\"添加角色\" onclick=\"createConsumer('"+name+"',"+id+")\">";
                        removeHtml="<input type=\"button\" class=\"clear_border\" value=\"删除角色\" onclick=\"removeConsumer("+id+")\">";
                        moveRole="<input type=\"button\" class=\"clear_border\" value=\"调整用户角色\" onclick=\"moveConsumer('"+name+"',"+id+")\">";
                        appendHtml+="<tr><td align=\"center\">"+check+"</td><td align=\"center\">"+id+"</td><td align=\"center\">"+role?.name+"</td><td align=\"center\">"+name+"</td><td>"+buttonHtml+""+removeHtml+""+moveRole+"</td></tr>";
                    }
                    appendHtml+="</table>";
                    appendHtml+="<input type=\"button\" class=\"ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only\" style=\"margin-top: 5px;\" value=\"全选\" onclick=\"checkAllConsumer(${consumers?.id})\"/>";
                    appendHtml+="<input type=\"button\" class=\"ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only\" style=\"margin-top: 5px;\" value=\"用户添加角色\" onclick=\"addAll()\"/>";
                }else{
                    appendHtml+="<div style=\" line-height: 26px; font-size: 14px; font-weight:bold;color:red;margin: 0 0 20px 0;\">";
                    appendHtml+=role?.name+"角色下没有用户";
                    appendHtml+="</div>";
                }

            }
        }
        result.appendHtml=appendHtml;
        result.total=total;
        return result
    }
    public Map createConsumerRole(Map params){
        def result=[:];
        def idList=[];
        if(params.idList instanceof String){
            if(params.idList.indexOf(',')){
                String[] str=params.idList.split(',');
                str.each {
                    idList.add(it);
                }
            }else{
                idList=[params.idList];
            }
        }else{
            idList=params.idList;
        }
        if(params.roleId&&idList.size()>0){
            Role role=Role.get(params.roleId as Long);
            idList.each {
                Consumer consumer=Consumer.get(it as Long)
                if(role&&consumer){
                    def isExist=consumer.userRole;
                    if(isExist){
                        result.success=false;
                        result.msg=consumer?.name+"用户角色已经存在"
                    }else{
                        Role role1=role.addToConsumers(consumer);
                        if(role1.save(flush: true)&&(!role1.hasErrors())){
                            result.success=true;
                            result.msg=consumer?.name+"用户添加角色成功"
                        }else{
                            result.success=false;
                            result.msg=consumer?.name+"用户添加角色失败"
                        }
                    }
                }
            }
        }else{
            result.success = false;
            result.msg = "参数不全!";
        }
        return result
    }
    public Map moveConsumerRole(Map params){
        def result=[:];
        def idList=[];
        if(params.idList.indexOf(',')){
            String[] str=params.idList.split(',');
            str.each {
                idList.add(it);
            }
        }else{
            idList=[params.idList];
        }
        if(params.roleId&&idList.size()>0){
            Role role=Role.get(params.roleId as Long);
            idList.each {
                Consumer consumer=Consumer.get(it as Long);
                if(role&&consumer){
                    def isExist=Consumer.createCriteria().list(){
                        eq("userRole",role)
                        eq("id",consumer.id)
                    }
                    if(isExist){
                        result.success=false;
                        result.msg=consumer?.name+"用户角色已经存在"
                    }else{
                        Role oldRole=consumer.userRole;
                        if(oldRole){
                            oldRole.removeFromConsumers(consumer);
                            oldRole.save(flush:true);
                        }

                        Role newRole=role.addToConsumers(consumer);
                        if(newRole.save(flush: true)&&(!newRole.hasErrors())){
                            result.success=true;
                            result.msg=consumer?.name+"用户角色移动成功"
                        }else{
                            result.success=false;
                            result.msg=consumer?.name+"用户角色移动失败"
                        }
                    }
                }else{
                    result.success=false;
                    result.msg=role?.name+"角色没有用户"+consumer?.name
                }
            }
        }else{
            result.success = false;
            result.msg = "参数不全!";
        }

        return result
    }
    public Map removeConsumer(Map params){
        def result=[:];
        if(params.consumerId){
            Consumer consumer=Consumer.get(params.consumerId as Long);
            if(consumer){
                def role=consumer.userRole;
                if(role){
                    role.removeFromConsumers(consumer);
                    result.success=true;
                    result.msg=role?.name+"移除用户成功";
                }else{
                    result.success=false;
                    result.msg=consumer?.name+"用户没有"+role?.name+"角色"
                }
            }else{
                result.success=false;
                result.msg=role?.name+"角色没有用户"+consumer?.name;
            }
        }else{
            result.success = false;
            result.msg = "参数不全!";
        }
        return result
    }

    //2014-04-11 获取用户列表
    public Map consumerList(Map params){
        def result = [:];
        if (!params.max) params.max = 10
        if (!params.offset) params.offset = 0
        def page = params.page ? (params.page as int) : 1;
        params.offset = (page - 1) * params.max;
        def order = params.sord ? params.sord : "desc";
        def sort = params.sidx ? params.sidx : "id";
        def name = params.searchName                    //用户帐号
        def college = params.searchCollege                //学生所属院系
        def searchNickName = params.searchNickName        //用户昵称
        def searchTrueName = params.searchTrueName        //用户真实姓名
        List<Consumer> consumerList=Consumer.createCriteria().list(){
            //帐号为真，添加用户帐户条件
            if (name) {
                name = name.trim()
                like('name', "%${name}%")
            }
            //用户昵称为真，进行昵称条件查询
            if (searchNickName) {
                searchNickName = searchNickName.trim()
                like('nickname', "%${searchNickName}%")
            }
            //用户真实姓名为真，进行姓名查询
            if (searchTrueName) {
                searchTrueName = searchTrueName.trim()
                like('trueName', "%${searchTrueName}%")
            }
            //用户所属院系为真，进行院系条件查询
            if (college) {
                eq('college', College.get(college))
            }
            //除超级管理员角色意外的
            gt("role",Consumer.SUPER_ROLE)
        }

        if(consumerList.size()>0){
            def total=consumerList.size();

            result.page = page;
            //总记录数
            result.records = total;
            //总页数
            result.total = Math.ceil(total * 1.00 / params.max);
            result.rows = [];
            consumerList.each {
                def tmp = [:];
                tmp.id = it.id;
                tmp.name = it.name;
                tmp.nickname=it.nickname;
                tmp.trueName=it.trueName;
                tmp.userState=it.userState;
                tmp.uploadState=it.uploadState;
                tmp.canDownload=it.canDownload;
                tmp.canComment=it.canComment;
                tmp.notExamine=it.notExamine;
                result.rows.add(tmp);
            }


        }
        return result
    }
    /**
     * 搜索
     * @param params
     * @return
     */
    public List search(Map params) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        java.util.Date begin_date = null;
        java.util.Date end_date = null;

        def row = params.row                            //每行页显示的行数
        def name = params.searchName                    //用户帐号
        def searchType = params.searchType                //searchType是查询类型，1-为全字匹配，2-模糊查询
        def college = params.searchCollege                //学生所属院系
        def dateBegin = params.dateBegin                    //创建开始时间
        def dateEnd = params.dateEnd                    //创建结束时间
        def role = params.roleList                        //用户角色
        def roleList = null                                //页面获得角色列表
        def roleid = []

        def selectState = params.selectState                //用户是否选择用户状态查询
        def state = params.searchState                    //用户是否锁定或启用标记
        def selectUpload = params.selectUpload                //用户是否选择上传状态查询
        def upload = params.searchUpload
        def selectDownload = params.selectDownload        //用户是否选择下载状态查询
        def download = params.searchDownload
        def selectExamine = params.selectExamine            //用户是否选择审核状态查询
        def examine = params.searchExamine
        def searchNickName = params.searchNickName        //用户昵称
        def searchTrueName = params.searchTrueName        //用户真实姓名
        def offset = 0
        def sort = "id"

        if (role)                                            //用来判断用户角色
        {
            roleList = role.split(',')
            if (roleList instanceof String) roleList = [params.roleList]
            roleList?.each { id ->

                roleid << id.toInteger()                        //转换成数字型
            }
        }

        if (dateBegin && !dateEnd)                            //用户判断用使用的是哪一种时间段查询方式
        {
            dateBegin = params.dateBegin + ' 00:00:01'
            dateEnd = params.dateBegin + ' 23:59:59'

            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        } else if (dateBegin && dateEnd) {
            dateBegin = params.dateBegin + ' 00:00:01'
            dateEnd = params.dateEnd + ' 23:59:59'
            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        }
        //设置反回行数最大值
        if (!params.max) params.max = row
        if (!params.offset) {
            params.offset = '0'
        } else {
            offset = params.offset
        }
        if (!params.sort) {
            params.sort = 'id'
        } else {
            sort = params.sort
        }
        if (!params.order) params.order = 'asc'
        def searchList = Consumer.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {
            //帐号为真，添加用户帐户条件
            if (name) {
                name = name.trim()
                //判断查询条件是为全字匹配还是模糊查询，进行不同的查询
                if (searchType == "1") {
                    eq('name', name)
                } else {
                    like('name', "%${name}%")
                }
            }
            //用户昵称为真，进行昵称条件查询
            if (searchNickName) {
                searchNickName = searchNickName.trim()
                like('nickname', "%${searchNickName}%")
            }
            //用户真实姓名为真，进行姓名查询
            if (searchTrueName) {
                searchTrueName = searchTrueName.trim()
                like('trueName', "%${searchTrueName}%")
            }
            //用户所属院系为真，进行院系条件查询
            if (college) {
                eq('college', College.get(college))
            }
            //查询时间为真，进行时间段查询，如果只选择开始时间，那么就是某单独一天
            if (dateBegin) {
                between("dateCreated", begin_date, end_date)
            }
            //用户角色为真，根据用户角色进行查询
            if (role) {
                'in'("role", roleid)
            }
            //用户选择锁定查询为真，进行锁定条件查询
            if (selectState) {
                if (state == '1') {
                    eq("userState", true)
                } else {
                    eq("userState", false)
                }

            }
            //用户选择上传查询为真，进行锁定条件查询
            if (selectUpload) {
                eq("uploadState", upload.toInteger())
            }
            if (selectDownload) {
                if (download == '1') {
                    eq("canDownload", true)
                } else {
                    eq("canDownload", false)
                }

            }
            if (selectExamine) {
                if (examine == '1') {
                    eq("notExamine", true)
                } else {
                    eq("notExamine", false)
                }

            }
            ne("role", 0)
        }
        return searchList;
    }
    /**
     * 更改状态
     * @param params
     * @return
     */
    public void setPro(Map params) {
        def changeId = params.changeId
        def changeTag = params.changeTag
        def changeOpt = params.changeOpt
        def consumer = Consumer.get(changeId)
        //---判断是否是修改上传属性，如果是按数字类型修改，如果不是按布尔类型修改
        if (changeOpt == 'upload') {
            if (changeTag == '1') {
                changeTag = 0
            } else {
                changeTag = 1
            }
        } else {
            if (changeTag == 'true') {
                changeTag = false
            } else {
                changeTag = true
            }
        }

        if (consumer) {
            if (changeOpt == 'state') {
                consumer.userState = changeTag
            }
            if (changeOpt == 'download') {
                consumer.canDownload = changeTag
            }
            if (changeOpt == 'upload') {
                consumer.uploadState = changeTag
            }
            if (changeOpt == 'comment') {
                consumer.canComment = changeTag
            }
            if (changeOpt == 'examine') {
                consumer.notExamine = changeTag
            }
            if (changeOpt == 'isRegister') {
                consumer.isRegister = changeTag
            }
        }
    }
    /**
     * 用户保存
     * @param params
     * @return
     */
    public Map userSave(Map params) {
        def result = [:];
        result.success = true;
        def dateValid = params.dateValid
        def dateEnter = new Date()
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd")
        if (dateValid) {
            dateValid = dateValid + " 00:00:00"
        } else {
            dateValid = CTools.readAfterOrBeforeDate("YEAR", 4, "-") + " 00:00:00"
        }
        dateValid = dateFormat.parse(dateValid)
        if (!params.nickname)                                //如果昵名为空，则与帐号相同
        {
            params.nickname = params.name
        }
        Long spaceSize = 1;
        Long maxSpaceSize = 1024;
        if(params.spaceSize){
            Long unitSize = Math.pow(1024,params.spaceSizeUnit as int) as Long
            spaceSize = params.spaceSize as Long;
            maxSpaceSize = spaceSize * unitSize
        }
        def consumer = new Consumer(
                name: params.name,                            //用户名
                password: params.password.encodeAsPassword(),    //密码
                nickname: params.nickname,                    //昵称
                trueName: params.trueName,                    //真实姓名
                telephone: params.telephone,                    //联系电话
                idCard: params.idCard,                            //身份证号
                email: params.email,                            //邮件
                college: College.get(params.college),                //学生所属院系
                descriptions: params.descriptions,                //用户描述信息
                gender: params.gender,                            //性别 0-女 1-男
                uploadState: params.uploadState,                    //是否上传 0-否 1-是 2-审请中  用户默认是0 管理员是1
                canDownload: params.canDownload,                //是否下载 0-否 1-是 用户默认是0 管理员是1
                userState: params.userState,                    //用户状态  0-禁用 1-活动 禁用后不可点播节目
                canComment: params.canComment,                //是否可以发表评论 0-否 1-是 默认是1
                role: params.role,                                //用户角色 0-Master(超级管理员)  1-部门管理员（可对节目和用户操作）2-普通管理员（只对节目操作）3-用户
                notExamine: params.notExamine,                    //审核状态上传节目是否审核  1-免审 0-审核
                dateEnterSchool: dateEnter,                            //入学时间
                dateValid: dateValid,                                //有效时间
                userJob: params.userJob,                        //用户身份 1教师  2科研人员  4行政管理人员  8教辅管理人员  16学生  32其他
                userEducation: params.userEducation,                //用户学历  0专科  1本科  2硕士  3博士  4博士后  5其他
                jobName: params.jobName,
                isRegister: false,
                profession: params.profession,                    //用户专业
                // 个人空间相关设置
                spaceSize: spaceSize,
                spaceSizeUnit: params.spaceSizeUnit,
                maxSpaceSize: maxSpaceSize
        )

        if (!consumer.hasErrors() && consumer.save()) {
            result.message = "用户${consumer.nickname} 创建成功"
            new OperationLog(tableName: 'consumer', tableId: consumer.id, operator: params.consumer.name,operatorIP:params.request.getRemoteAddr(),
                    modelName: '添加用户', brief: consumer.name, operatorId: params.consumer.id, operation: OperationEnum.ADD_USER).save(flush: true)
        } else {
            result.success = false;
            result.consumer = consumer;
        }
        return result;
    }
    /**
     * 删除列表用户信息
     * @param params
     * @return
     */
    public void delConsumerList(Map params) {
        def delIdList = params.idList
        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            //获得用户对像
            def consumer = Consumer.get(id)
            //删除与用户相关的参与者
            def participantList = Participant.findAllByConsumer(consumer)
            if (participantList && participantList.size() > 0) {
                participantList?.each { participant ->
                    if (participant) {
                        participant.delete();
                    }
                }
            }
            //根据用户ID，获得该用户所创建的组列表
            def groupList = UserGroup.findAllByConsumer(consumer.id)
            //循环该组中的对像
            groupList.toList().each { group ->
                //循环该用户所创建的组中有多少个用户
                group.consumers.toList().each {
                    //删除与userGroup对像的关系
                    it.removeFromUserGroups(group)
                    //删除consumer对像实列
                    group.delete()
                }
            }
            //删除用户对像
            consumer.delete()
        }
    }
    /**
     *
     * @param params
     * @return
     */
    public void setUpload(Map params) {
        def updateIdList = params.idList
        def page = params.page
        def updateid = 0
        if (updateIdList instanceof String) updateIdList = [params.idList]
        updateIdList?.each { id ->
            updateid = updateid + "," + id
        }
        if (page == "") {
            page = "0"
        }
        Consumer.executeUpdate("update nts.user.domain.Consumer c set uploadState=${params.uploadTag}  where c.id in(${updateid}) ")
    }
    /**
     * 设置用户评论权限
     * @param params
     * @return
     */
    public void setComment(Map params) {
        def updateIdList = params.idList
        def page = params.page
        def updateid = 0

        if (updateIdList instanceof String) updateIdList = [params.idList]
        updateIdList?.each { id ->

            updateid = updateid + "," + id
        }
        Consumer.executeUpdate("update nts.user.domain.Consumer c set canComment=${params.commentTag}  where c.id in(${updateid}) ")
    }
    /**
     * 用户下载权限
     * @param params
     * @return
     */
    public void setDownload(Map params) {
        def updateIdList = params.idList
        def page = params.page
        def updateid = 0

        if (updateIdList instanceof String) updateIdList = [params.idList]
        updateIdList?.each { id ->

            updateid = updateid + "," + id
        }
        Consumer.executeUpdate("update nts.user.domain.Consumer c set canDownload=${params.downloadTag}  where c.id in(${updateid}) ")
    }
    /**
     * 对用户审核发布资源进行设置
     * @param params
     * @return
     */
    public void setExamine(Map params) {
        def updateIdList = params.idList
        def page = params.page
        def updateid = 0

        if (updateIdList instanceof String) updateIdList = [params.idList]
        updateIdList?.each { id ->

            updateid = updateid + "," + id
        }
        Consumer.executeUpdate("update nts.user.domain.Consumer c set notExamine=${params.examineTag}  where c.id in(${updateid}) ")

    }
    /**
     * 设置正式用户
     * @param params
     * @return
     */
    public void setRegister(Map params) {
        def updateIdList = params.idList
        def page = params.page
        def updateid = 0

        if (updateIdList instanceof String) updateIdList = [params.idList]
        updateIdList?.each { id ->

            updateid = updateid + "," + id
        }
        Consumer.executeUpdate("update nts.user.domain.Consumer c set isRegister=${params.registerTag}  where c.id in(${updateid}) ")
    }
    /**
     * 锁定用户
     * @param params
     * @return
     */
    public void setLock(Map params) {
        def lockIdList = params.idList
        def lockid = 0

        if (lockIdList instanceof String) lockIdList = [params.idList]
        lockIdList?.each { id ->
            lockid = lockid + "," + id
        }
        //注意params.lockTag参数，是从前端页面传来的标记，决定着是锁定还是解锁
        Consumer.executeUpdate("update nts.user.domain.Consumer c set userState=${params.lockTag}  where c.id in(${lockid}) ")
    }
    /**
     * 用户组删除
     * @param params
     * @return
     */
    public void deleteUserGroup(Map params) {
        def delIdList = params.idList
        def userGroup

        if (delIdList instanceof String) delIdList = [params.idList]
        delIdList?.each { id ->
            userGroup = UserGroup.get(id)
            //删除用户组与用户间所建立的关系
            userGroup.consumers.toList().each {
                it.removeFromUserGroups(userGroup)
            }

            //删除用户组与节目播放权限间的关系
            userGroup.playPrograms.toList().each {
                it.removeFromPlayGroups(userGroup)
            }

            //删除用户组与节目下载权限间的关系
            userGroup.downloadPrograms.toList().each {
                it.removeFromDownloadGroups(userGroup)
            }

            //删除用户组与节目下载权限间的关系
            //def db = new groovy.sql.Sql(dataSource)
            //db.executeUpdate("delete program_play_groups where user_group_id=${id}")
            //db.executeUpdate("delete program_download_groups where user_group_id=${id}")

            userGroup.delete()
        }
    }
    /**
     * 用户组保存
     * @param params
     * @return
     */
    public Map saveUserGroup(Map params) {
        def result = [:];
        result.success = true;
        def session = utilService.getSession();
        def userGroup = new UserGroup(
                name: params.name,
                description: params.description,
                creator: session.consumer.nickname,
                consumer: session.consumer.id,
                dateCreated: new Date(),
                dateModified: new Date()
        )

        if (!userGroup.hasErrors() && userGroup.save()) {
            result.message = "用户组 ${userGroup.name} 创建成功"
        } else {
            result.success = false;
            result.userGroup = userGroup;
        }
        return result;
    }
    /**
     * 用户组更新
     * @param params
     * @return
     */
    public Map updateUserGroup(Map params) {
        def result = [:];
        result.success = true;
        result.notFind = false;
        def userGroup = UserGroup.get(params.updateId)
        if (userGroup) {
            userGroup.name = params.updateName
            userGroup.description = params.updateDescription
            if (!userGroup.hasErrors() && userGroup.save()) {
                result.message = "${userGroup.name} 修改 成功"
            } else {
                result.success = false;
                result.userGroup = userGroup;
            }
        } else {
            result.success = false;
            result.notFind = true;
            result.message = "无法找到 ${userGroup.name}"
        }
        return result;
    }
    /**
     * 向组中添加成员
     * @param params
     * @return
     */
    public void groupAddConsumer(Map params) {
        def result = [:];
        def delIdList = params.idList

        def group = UserGroup.get(params.groupId)
        if (delIdList instanceof String) delIdList = [params.idList]

        delIdList?.each { id ->
            def consumer = Consumer.get(id)
            group.addToConsumers(consumer)                        //删除与userGroup对像的关系
        }
    }
    /**
     * 向所选择的组中添加新单个用户
     * @param params
     * @return
     */
    public Map groupAddConsumerOne(Map params) {
        def result = [:];
        result.success = true;
        def group = UserGroup.get(params.groupId)
        def consumer = Consumer.findByName(params.consumerId)

        if (consumer) {
            group.addToConsumers(consumer)
        } else {
            result.success = false;
            result.message = " 没有该用户"
        }
        return result;
    }
    /**
     * 删除单个组员与组的关系
     * @param params
     * @return
     */
    public Map groupDeleteConsumerOne(Map params) {
        def group = UserGroup.get(params.groupId)
        def consumer = Consumer.get(params.id)
        group.removeFromConsumers(consumer)
    }
    /**
     * 条件查询列表
     * @param params
     * @return
     */
    public Map groupSelectList(Map params) {
        def result = [:];
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");        //声明时间格式化对像
        Date begin_date = null;
        Date end_date = null;

        def row = params.row                            //每行页显示的行数
        def name = params.searchName                    //用户帐号
        def nickname = params.searchNickname            //用户昵称
        def searchTrueName = params.searchTrueName        //用户姓名
        def searchNNType = params.searchNNType            //searchNNType是昵称查询类型，1-为全字匹配，2-模糊查询
        def searchType = params.searchType                //searchType是查询类型，1-为全字匹配，2-模糊查询

        def college = params.searchCollege                //学生所属院系
        def dateBegin = params.dateBegin                    //创建开始时间
        def dateEnd = params.dateEnd                    //创建结束时间
        def role = params.roleList                        //用户角色
        def numBegin = params.numBegin                //学号范围开始段
        def numEnd = params.numEnd                    //学号范围结束段

        def offset = 0
        def sort = "id"

        //用户判断用使用的是哪一种时间段查询方式
        if (dateBegin && !dateEnd) {
            dateBegin = params.dateBegin + ' 00:00:01'
            dateEnd = params.dateBegin + ' 23:59:59'

            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        } else if (dateBegin && dateEnd) {
            dateBegin = params.dateBegin + ' 00:00:01'
            dateEnd = params.dateEnd + ' 23:59:59'
            begin_date = sdf.parse(dateBegin);
            end_date = sdf.parse(dateEnd);
        }

        if (!params.max) params.max = row                                //设置反回行数最大值
        if (!params.offset) {
            params.offset = '0'
        } else {
            offset = params.offset
        }
        if (!params.sort) {
            params.sort = 'id'
        } else {
            sort = params.sort
        }
        if (!params.order) params.order = 'asc'
        def consumerList = Consumer.createCriteria().list(max: params.max, offset: params.offset, sort: params.sort, order: params.order) {

            if (name)                                        //帐号为真，添加用户帐户条件
            {
                if (searchType == "1")                        //判断查询条件是为全字匹配还是模糊查询，进行不同的查询
                {
                    eq('name', name)
                } else {
                    like('name', "%${name}%")
                }
            }
            if (nickname) {

                if (searchNNType == "1") {
                    eq('nickname', nickname)
                } else {
                    like('nickname', "%${nickname}%")
                }
            }
            if (searchTrueName) {
                like('trueName', "%${searchTrueName}%")
            }
            if (college)                                    //用户所属院系为真，进行院系条件查询
            {
                eq('college', College.get(college))
            }
            if (dateBegin)                                    //查询时间为真，进行时间段查询，如果只选择开始时间，那么就是某单独一天
            {
                between("dateCreated", begin_date, end_date)
            }
            if (numBegin && numEnd) {
                between("name", numBegin, numEnd)
            }

            ne("role", 0)
        }
        def total = consumerList.totalCount;
        result.searchList = consumerList;
        result.userGroupList = UserGroup.list();
        result.total = total;
        return result;
    }
    /**
     * 用户批量导入到组
     * @param params
     * @return
     */
    public void searchLoadGroup(Map params) {
        def consumerIdList = params.idList
        def groupIdList = params.groupIdList
        if (groupIdList instanceof String) groupIdList = [params.groupIdList]
        if (consumerIdList instanceof String) consumerIdList = [params.idList]
        groupIdList?.each { id ->                                        //循环组列表
            def group = UserGroup.get(id)                                //获得组对像
            consumerIdList?.each { cid ->                            //循环用户列表
                def consumer = Consumer.get(cid)                        //获得用户对像
                consumer.allGroup = false                            //记录用户ID，更新用记的groupTag标记使其变为1
                group.addToConsumers(consumer)                    //添加UserGroup 与 nts.user.domain.Consumer 所属关系
            }
        }
    }
    /**
     * 用来将用户导出组
     * @param params
     * @return
     */
    public void searchLoadAllGroup(Map params) {
        def consumerIdList = params.idList

        if (consumerIdList instanceof String) consumerIdList = [params.idList]
        consumerIdList?.each { id ->

            def consumer = Consumer.get(id)
            consumer.allGroup = true
            consumer.userGroups.toList().each {
                it.removeFromConsumers(consumer)                        //删除与userGroup对像的关系
            }
        }
    }
    /**
     * 将用户批量导出组
     * @param params
     * @return
     */
    public void searchUnloadGroup(Map params) {
        def consumerIdList = params.idList
        def groupIdList = params.groupIdList

        if (groupIdList instanceof String) groupIdList = [params.groupIdList]
        if (consumerIdList instanceof String) consumerIdList = [params.idList]
        groupIdList?.each { id ->                                        //循环组列表
            def g = UserGroup.get(id)                                        //获得组对像
            consumerIdList?.each { cid ->                        //循环用户列表
                def c = Consumer.get(cid)                            //获得用户对像
                g.removeFromConsumers(c)                            //删除UserGroup 与 nts.user.domain.Consumer 所属关系
            }
        }
    }/**
     * 编辑用户时以，导入或导入出操作
     * @param params
     * @return
     */
    public void loadGroupEdit(Map params) {
        def groupIdList = params.groupIdList
        def consumer = Consumer.get(params.id)
        def inout = params.inout
        if (groupIdList instanceof String) groupIdList = [params.groupIdList]
        groupIdList?.each { id ->                                            //循环组列表
            def group = UserGroup.get(id)
            if (inout == "load")                                            //判断页面传入的inout标记，load 加入组，unload 导出组
            {
                group.addToConsumers(consumer)
            }
            if (inout == "unload") {
                group.removeFromConsumers(consumer)
            }
        }
    }
    /**
     * 更新用户是信息
     * @param params
     * @return
     */
    public Map searchUpdate(Map params) {
        def result = [:];
        result.success = true;
        result.noFind = false;
        def a = params.dateValid
        def b = params.dateEnterSchool
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");        //声明时间格式化对像
        java.util.Date _dateValid = sdf.parse(a);
        java.util.Date _dateEnterSchool = sdf.parse(b);

        def gender = params.gender
        def role = params.role
        def uploadState = params.uploadState
        def canDownload = params.canDownload
        def userState = params.userState
        def canComment = params.canComment
        def notExamine = params.notExamine
        def consumer = Consumer.get(params.updateId)
        if (consumer) {

            consumer.nickname = params.nickname                    //昵称
            consumer.trueName = params.trueName                    //真实姓名
            consumer.address = params.address                        //用户住 址
            consumer.postalcode = params.postalcode                    //邮编
            consumer.telephone = params.telephone                    //联系电话
            consumer.idCard = params.idCard                            //身份证号
            consumer.email = params.email                            //邮件
            consumer.college = College.get(params.college)                //学生所属院系
            consumer.descriptions = params.descriptions                //用户描述信息
            consumer.gender = gender.toInteger()                        //性别 0-女 1-男
            consumer.uploadState = uploadState.toInteger()                //是否上传 0-否 1-是 2-审请中  用户默认是0 管理员是1
            consumer.canDownload = canDownload.toInteger()            //是否下载 0-否 1-是 用户默认是0 管理员是1
            consumer.userState = userState.toInteger()                    //用户状态  0-禁用 1-活动 禁用后不可点播节目
            consumer.canComment = canComment.toInteger()            //是否可以发表评论 0-否 1-是 默认是1
            consumer.role = role.toInteger()
            //用户角色 0-Master(超级管理员)  1-部门管理员（可对节目和用户操作）2-普通管理员（只对节目操作）3-用户
            consumer.notExamine = notExamine.toInteger()                //审核状态上传节目是否审核  1-免审 0-审核
            consumer.dateValid = _dateValid
            consumer.dateEnterSchool = _dateEnterSchool
            consumer.userJob = params.userJob.toInteger()                //用户身份 1教师  2科研人员  4行政管理人员  8教辅管理人员  16学生  32其他
            consumer.userEducation = params.userEducation.toInteger()    //用户学历  0专科  1本科  2硕士  3博士  4博士后  5其他
            consumer.jobName = params.jobName.toInteger()            //用户职称 1助教  2讲师  4副教授  8教授  16硕士生导师  32博士生导师  64其他
            consumer.profession = params.profession                    //用户专业
            if (params.modPassword) {
                //--- 加密后修改密码
                consumer.password = params.modPassword.encodeAsPassword()
            }
            //---修改用户组的创建者名称
            if (params.nickname) {
                UserGroup.executeUpdate("update nts.user.domain.UserGroup c set creator='${params.nickname}'  where c.consumer=${consumer.id}  ")
            }


            if (!consumer.hasErrors() && consumer.save()) {
                result.message = "用户 ${consumer.name} 修改完成！"
            } else {
                result.success = false;
                result.consumer = consumer;
            }
        } else {
            result.noFind = true;
            result.success = false;
            result.message = "nts.user.domain.Consumer not found with id ${params.id}"
        }
        return result;
    }
    /**
     * 删除查询结果中的用户
     * @param params
     * @return
     */
    public Map searchEditDelete(Map params) {
        def result = [:];
        result.success = true;
        def consumer = Consumer.get(params.id)
        if (consumer) {
            //通过用户组创建者查询出该用户共创建过多少组
            def groupList = UserGroup.findAllByConsumer(consumer.id)
            //循环该组中的对像
            groupList.toList().each { group ->
                //循环该用户所创建的组中有多少个用户
                group.consumers.toList().each {
                    //删除与userGroup对像的关系
                    it.removeFromUserGroups(group)
                    //删除consumer对像实列
                    group.delete()
                }
            }
            consumer.delete()
        } else {
            result.success = false;
            result.message = "找不到用户 ${consumer.name}"
        }
        return result;
    }
    /**
     * 高校保存
     * @param params
     * @return
     */
    public Map saveCollege(Map params) {
        def result = [:];
        result.success = true;
        def college = new College(params)
        if (!college.hasErrors() && college.save()) {
            result.message = "部门 ${college.name} 创建成功"
        } else {
            result.success = false;
            result.college = college;
        }
        return result;
    }
    /**
     * 高校更新
     * @param params
     * @return
     */
    public Map updateCollege(Map params) {
        def result = [:];
        result.success = true;
        result.noFind = false;
        def college = College.get(params.updateId)
        if (college) {
            college.name = params.updateName
            college.description = params.updateDescription
            if (!college.hasErrors() && college.save()) {
                // flash.message = "nts.user.domain.College ${params.id} updated"
                result.success = true;
            } else {
                result.success = false;
                result.college = college;
            }
        } else {
            result.noFind = true;
            result.success = false;
            result.message = "nts.user.domain.College not found with id ${params.id}"
        }
        return result;
    }

    /**
     * 部门名称重复校验
     * @param params
     * @return
     */
    public Map checkCollegeName(Map params) {
        def result = [:];
        result.success = true;
        def opt = params.opt;
        def name = params.name;
        def collegeId = params.collegeId;
        def colleges = null;
        if("save".equals(opt)) {
            colleges = College.findAllByName(name);
        } else if("update".equals(opt)) {
            colleges = College.findAllByIdNotEqualAndName(collegeId as long, name);
        }
        if(colleges && colleges.size()>0) {
            result.success = false;
            result.msg = '部门名称重复';
        }
        return result;
    }

    /**
     * 高校删除
     * @param params
     * @return
     */
    public Map deleteCollege(Map params) {
        def result = [:];
        def college = College.get(params.id)
        if (college) {
            try {
                def collegeName = college.name;
                //userList=nts.user.domain.Consumer.findAllByCollege(college)
                Consumer.executeUpdate("update nts.user.domain.Consumer c set college=null  where c.college=${college.id} ")
                college.delete(flush: true)
                result.success = true;
                result.message = "部门 " + collegeName + "删除成功"
            }
            catch (DataIntegrityViolationException e) {
                result.success = false;
                result.message = "nts.user.domain.College ${params.id} could not be deleted"
            }
        } else {
            result.success = false;
            result.message = "nts.user.domain.College not found with id ${params.id}"
        }
        return result;
    }
    /**
     * 更新超级管理员
     * @param params
     * @return
     */
    public Map masterUpdate(Map params) {
        def result = [:];
        result.success = true;
        def master = Consumer.findByName('master')
        master.properties = params
        //---判断用户昵称
        if (params.nickname) {
            master.nickname = params.nickname
        }
        if(params.trueName) {
            master.trueName = params.trueName
        }
        //---判断用户是否修改密码
        if (params.modPassword) {
            //--- 加密后修改密码
            master.password = params.modPassword.encodeAsPassword()
        }

        if (!master.hasErrors() && master.save()) {
            result.message = "Master修改完成！"
        } else {
            result.success = false;
            result.master = master;
        }
        return result;
    }
    /**
     * 角色管理
     * @param params
     * @return
     */
    public Map roleManagerOther(Map params) {
        def result = [:];
        if (!params.msg) params.msg = ''
        String[] controllerList = ['programMgr','communityManager','userActivityMgr','userMgr','coreMgr'];
        List<Role> roles = Role.list();
        List<String> resourcesName = SecurityResource.withCriteria {
            projections {
                distinct('controllerName')
            }
            inList('controllerEnName',controllerList)
        }
        List<SecurityResource> resources = [];
        resourcesName.each {
            resources.add(SecurityResource.findByControllerName(it));
        }
        result.roles = roles;
        result.resources = resources;
        return result;
    }
}
