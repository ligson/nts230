package nts.admin.usermgr.controllers

import grails.converters.JSON

class UserResourceController {

    def userResourceView(){
        def result=[:];
        String controllerEnName=params.controllerEnName;
        String actionEnName=params.actionEnName;
        result.success="${userResourceView(controllerName: 'communityManager',actionName: 'deleteCommunity')}";
        return render(result as JSON)
    }
    def index() {}
}
