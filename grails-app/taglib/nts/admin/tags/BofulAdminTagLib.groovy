package nts.admin.tags

class BofulAdminTagLib {
    static defaultEncodeAs = 'none'
    static namespace = "bofulAdmin"
    //static encodeAsForTags = [tagName: 'raw']
    def securityResourceService

    //生成当前位置
    def pathNavMap = { attrs, body ->
        String controllerName = attrs.controllerName;
        String actionName = attrs.actionName;
        String controllerCnName = securityResourceService.getControllerName(controllerName);
        String actionCnName = securityResourceService.getActionName(controllerName,actionName);
        controllerCnName = controllerCnName ? controllerCnName : controllerName;
        actionCnName = actionCnName ? actionCnName : actionName;
        StringBuffer sb = new StringBuffer();
        sb.append("<a href='${createLink(controller: controllerName, action: "index")}'>${controllerCnName}</a>&gt;");
        sb.append("<a href='#'>${actionCnName}</a>");

        out << sb.toString();
    }
}
