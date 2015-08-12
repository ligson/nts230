package nts.license.tags

import nts.user.domain.SecurityResource

/**
 * Created by lvy6 on 14-5-4.
 */
class UserResourceTagLib {
    def licenseManagerService;
    /**
     * 根据解析出来的controllerEnName和actionEnName判断用户存在的功能
     */
    def userResourceView = {attrs, body ->
        String isRole;
        def controllerEnName=attrs.controllerName;
        def actionEnName=attrs.actionName;
        String query="from SecurityResource where controllerEnName='"+controllerEnName+"'";
        if(actionEnName){
            query+=" and actionEnName='"+actionEnName+"'";
        }
        SecurityResource securityResource = SecurityResource.find(query);
        //SecurityResource securityResource = SecurityResource.findByControllerEnNameAndActionEnName(controllerEnName,actionEnName);
        List<String> resourceList = licenseManagerService.roleResources;
        if(resourceList.size()>0){
            if(actionEnName){
                if(resourceList.contains(controllerEnName+"-"+actionEnName)){
                    isRole='true';
                }else{
                    isRole='false';
                }
            }else{
                List<String> controllerList = new ArrayList<String>();
                resourceList.each {
                    String[] strs=it.split("-");
                    controllerList.add(strs[0]);
                }
                if(controllerList.contains(controllerEnName)){
                    isRole='true';
                }else{
                    isRole='false';
                }
            }
        }else{
            isRole='true';
        }

        out << isRole;
    }
}
