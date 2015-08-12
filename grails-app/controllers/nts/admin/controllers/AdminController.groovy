package nts.admin.controllers

import com.sun.tools.jxc.ap.Const
import nts.program.domain.Program
import nts.system.domain.OperationEnum
import nts.system.domain.OperationLog
import nts.user.domain.Consumer
import nts.user.domain.Role
import nts.user.domain.SecurityResource
import nts.user.services.ActionNameAnnotation
import nts.user.services.ControllerNameAnnotation

import javax.servlet.http.Cookie

@ControllerNameAnnotation(name = "资源中心")
class AdminController {
    def licenseManagerService
    def securityResourceService

    @ActionNameAnnotation(name = "首页")
    def index() {}

    @ActionNameAnnotation(name = "登陆")
    def login() {
        return render(view: 'login');
    }

    def errorAuthority() {
        def errorMsg = "对不起，您没有权限访问该后台地址！";
        return render(view: 'errorAuthority', model: [errorMsg: errorMsg])
    }

    @ActionNameAnnotation(name = "后台登陆")
    def adminLogin() {
        def result = [:];
        String name = params.adminLoginName;
        String password = params.adminPassword;
        String remFlg = params.remFlg;
        def consumer = null
        if (name && password) {
            consumer = Consumer.findByNameAndPassword(name, password.encodeAsPassword());
            if (consumer) {
                if (new Date() > consumer.dateValid) {
                    result.success = false;
                    result.errorMsg = "用户已过期！"
                } else {
                    if (consumer.isRegister) {
                        result.success = false;
                        result.errorMsg = "用户未审批！"
                    } else {
                        if (consumer.role > 1) {
                            result.success = false;
                            result.errorMsg = "没有登录权限！"
                        } else {
                            result.success = true;
                            session.consumer = consumer;

                            Cookie[] cookies = request.getCookies();
                            Cookie cookieLoginName = null;
                            if (cookies && cookies.size() > 0) {
                                for (Cookie cookie : cookies) {
                                    if (cookie.getName() == "adminLoginName") {
                                        cookieLoginName = cookie;
                                        break;
                                    }
                                }
                            }
                            if ("1".equals(remFlg)) { //记住用户名
                                // 保存cookie
                                if (cookieLoginName) {
                                    cookieLoginName.setValue(consumer.name);
                                    response.addCookie(cookieLoginName);
                                } else {
                                    Cookie newCookie = new Cookie("adminLoginName", consumer.name);
                                    newCookie.setMaxAge(60 * 60 * 24 * 30); //保存30天
                                    response.addCookie(newCookie);
                                }
                            } else {
                                try {
                                    if (cookieLoginName) {
                                        cookieLoginName.setMaxAge(0);
                                        response.addCookie(cookieLoginName);
                                    }
                                } catch (Exception e) {
                                }
                            }

                            long total = Program.count();
                            long frequency = Program.createCriteria().get {
                                projections {
                                    sum("frequency")
                                }
                            } ?: 0;
                            long downloadNum = Program.createCriteria().get {
                                projections {
                                    sum("downloadNum")
                                }
                            } ?: 0;

                            session.programTotal = total;
                            session.programFrequency = frequency;
                            session.programDownloadNum = downloadNum;
                            new OperationLog(tableName: 'consumer', tableId: consumer.id, operator: consumer.name, operatorIP: request.getRemoteAddr(),
                                    modelName: '用户登陆', brief: '登陆操作', operatorId: consumer.id, operation: OperationEnum.LOGIN).save()
                        }
                    }
                }

            } else {
                result.success = false;
                result.errorMsg = "用户名不存在或密码错误！"
            }
        } else {
            result.success = false;
            result.errorMsg = "用户名或者密码不能为空！";
        }

        if (result.success) {
            //登陆验证成功则将用户所有的功能权限存入session
            def Map<String, String> resources = securityResourceService.getUserSecurityResources(consumer);

            // 如果没有设置资源管理员权限，添加此权限
            if (!resources.containsKey("index-programMgr")) {
                resources.put("index-programMgr", "programMgr");
            }

            session.setAttribute("userResources", resources);

            // 设置各标签的Action
            session.setAttribute("communityAction", "index");
            session.setAttribute("userActivityAction", "index");
            session.setAttribute("userAction", "index");
            session.setAttribute("coreAction", "index");

            if (session.consumer.role != Consumer.SUPER_ROLE) {
                setTagAction();
            }

            redirect(controller: 'programMgr', action: 'index');
            /*List<String> resourceList = licenseManagerService.roleResources;
            List<String> controllerList = new ArrayList<>();
            resourceList.each {
                String[] strs = it.split("-");
                controllerList.add(strs[0]);
            }
            String controllerEnName;
            def checkController = ["programMgr","communityManager","userActivityMgr","userMgr","coreMgr"];
            controllerList.each {
                if(checkController.contains(it)){
                    controllerEnName=it;
                    return ;
                }
            }
            if(controllerEnName){
                redirect(controller: controllerEnName, action: 'index');
            }else{
                result.success = false;
                result.errorMsg = "没有权限登录后台,请与管理员联系！";
                return render(view: 'login', model: [errorMsg: result.errorMsg]);
            }
*/
        } else {
            return render(view: 'login', model: [errorMsg: result.errorMsg]);
        }

    }

    def setTagAction() {
        def communityFlag = false;
        def userActivityFlag = false;
        def userFLag = false;
        def coreFlag = false;

        Map<String, String> resources = session.getAttribute("userResources")

        if (resources.containsKey("index-communityManager")) {
            communityFlag = true;
        }
        if (resources.containsKey("index-userActivityMgr")) {
            userActivityFlag = true;
        }
        if (resources.containsKey("index-userMgr")) {
            userFLag = true;
        }
        if (resources.containsKey("index-coreMgr")) {
            coreFlag = true;
        }

        if (!(communityFlag && userActivityFlag && userFLag && coreFlag)) {
            def List<Role> roles = [];
            def userRole = session.consumer.userRole //当前登陆用户的角色
            roles.add(userRole)
            //如果角色下有子角色
            def childrenRole = Role.findAllByParentRole(userRole)
            if (childrenRole.size() > 0) {
                roles.addAll(childrenRole)
            }

            //查当前登录用户所在的用户组的角色
            def userGroups = session.consumer.userGroups
            userGroups?.each {
                if (it.role) {
                    roles.add(it.role)
                    //如果角色下有子角色
                    childrenRole = Role.findAllByParentRole(it.role)
                    if (childrenRole.size() > 0) {
                        roles.addAll(childrenRole)
                    }
                }
            }

            roles.unique()

            //合并用户角色和用户所在用户组角色的所有功能权限
            List<SecurityResource> allSecurityResources = []
            roles.each {
                if (it?.resources) {
                    allSecurityResources.addAll(it.resources)
                }
            }

            allSecurityResources.unique()
            allSecurityResources.sort { s1, s2 ->
                return s1.id - s2.id;
            }

            List<SecurityResource> securityResources = []
            allSecurityResources.each{
                if(it.actionName == it.patternName) {
                    securityResources.add(it);
                }
            }

            for (String key : resources.keySet()) {
                if (!communityFlag && (key.split('-')[1]) == "communityManager") {
                    def resource = securityResources.find {
                        it.controllerEnName == "communityManager";
                    }
                    session.setAttribute("communityAction", resource.actionEnName);
                    communityFlag = true;
                }
                if (!userActivityFlag && (key.split('-')[1]) == "userActivityMgr") {
                    def resource = securityResources.find {
                        it.controllerEnName == "userActivityMgr";
                    }
                    session.setAttribute("userActivityAction", resource.actionEnName);
                    userActivityFlag = true;
                }
                if (!userFLag && (key.split('-')[1]) == "userMgr") {
                    def resource = securityResources.find {
                        it.controllerEnName == "userMgr";
                    }
                    session.setAttribute("userAction", resource.actionEnName);
                    userFLag = true;
                }
                if (!coreFlag && (key.split('-')[1]) == "coreMgr") {
                    def resource = securityResources.find {
                        it.controllerEnName == "coreMgr";
                    }
                    session.setAttribute("coreAction", resource.actionEnName);
                    coreFlag = true;
                }
            }
        }
    }

    @ActionNameAnnotation(name = "退出")
    def logout() {
        session.consumer = null;
        return redirect(action: 'login');
    }
}
