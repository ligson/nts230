package nts.common.services

import nts.admin.programmgr.controllers.ProgramMgrController
import nts.user.domain.Consumer

import javax.servlet.http.HttpSession

class CommonService {

    def securityResourceService
    def utilService

    public void init() throws Exception{
        securityResourceService.initResource();
    }

    public String checkUserResource(String controllerEnName, String actionEnName) {
        String isRole = 'false';
        HttpSession session = utilService.getSession();
        //如果是超级管理员则显示全部
        if ((session.consumer && session.consumer.role == Consumer.SUPER_ROLE)||(session.consumer&&session.consumer.role==Consumer.MANAGER_ROLE&&controllerEnName.equals("programMgr"))) {
            isRole = 'true'
        } else {
            Map<String, String> userResources = session.getAttribute("userResources")

            if (userResources.get((actionEnName + '-' + controllerEnName)) == controllerEnName) {
                isRole = 'true'
            }
        }
        return isRole
    }
}
