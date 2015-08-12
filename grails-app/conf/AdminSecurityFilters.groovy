

class AdminSecurityFilters {
    def commonService

    def filters = {
        all(controller:'*', action:'*') {
            def mgrControllerName = ["programMgr","appMgr","userMgr","coreMgr","communityManager","userActivityMgr"];
            before = {

                if(mgrControllerName.contains(controllerName)){
                    if(!(session.consumer&&session.consumer.role<=1)){
                        redirect(controller:'admin',action:'login');
                        return false;
                    }
                    else {
                        if(commonService.checkUserResource(controllerName, actionName)=='false') {
                            redirect(controller:'admin',action:'errorAuthority');
                            return false;
                        }
                    }
                }
            }
            after = { Map model ->

            }
            afterView = { Exception e ->

            }
        }

    }
}
