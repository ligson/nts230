<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <script type="text/javascript"
            src="${resource(dir: "js/boful/appMgr/serverNode", file: "serverNodeListTree.js")}"></script>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'node_list.css')}">
    <title>节点管理</title>
    <r:require modules="zTree"/>
    <style type="text/css">
.buttons_right {
    float: left;
    margin-left: 20px;
    margin-top: 20px;
    width: 110px;;
}
    </style>
</head>

<body>
<div class="tree_main">

    <div class="tree_left">
        <div id="serverNodeTree" class="ztree">
        </div>
    </div>

    <div class="tree_content" style="width:450px;">
        <div class="tree_content_but">
            <input class="admin_default_but_green" type="button" value="创建节点" id="createServerNode">
            <input class="admin_default_but_green" type="button" value="创建子节点" id="createChildServerNode">
            <input class="admin_default_but_green" type="button" value="创建根节点" id="createParentServerNode">
            <input class="admin_default_but_green" type="button" value="删除节点" id="removeServerNode">

        </div>
        <br><input type="hidden" value="" id="selectServerNodeTypeId">
        <g:form method="post" action="updateServerNode" controller="distributeApply">
            <g:hiddenField name="id" value=""/>
            <g:hiddenField name="version" value=""/>
            <div class="dialog">
                <table class="table">
                    <tbody>

                    <tr class="prop">
                        <td valign="top" class="name">
                            名称：
                        </td>
                        <td valign="top">
                            <g:textField class="admin_default_inp" name="name" id="name" maxlength="250" value=""/>
                        </td>
                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name">
                            IP：
                        </td>
                        <td valign="top">
                            <g:textField class="admin_default_inp" name="ip" id="ip" maxlength="250" value=""/>（分发或者收割的IP）
                        </td>
                    </tr>
                    <tr class="prop">
                        <td valign="top" class="name">
                            端口：
                        </td>
                        <td valign="top">
                            <g:textField class="admin_default_inp" name="port" id="port" maxlength="20" value=""/>（分发或者收割的端口）
                        </td>
                    </tr>
                    <tr class="prop">
                        <td valign="top" class="name">是否发送文件</td>
                        <td valign="top" id="updateObj"><input style="width: 25px;" type="radio" value="true" name="isSendObject"/>是<input style="width: 25px;" type="radio" value="false" name="isSendObject"/>否</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="buttons" style="text-align: center">
                <span class="buttons buttons_right"><input class="admin_default_but_yellow" type="submit" value="修改"/>
                </span>
                <span class="buttons buttons_right"><input class="admin_default_but_yellow" type="button"
                                                           onclick="history.back();" value="取消"/></span>


            </div>
        </g:form>
    </div>

    <div id="createRootServerNodeDialog" style="display:none;">
        <g:form action="createServerNode" controller="distributeApply" name="createServerNodeForm"
                onsubmit="return check();">
            <div class="ui-dialog-content ui-widget-content">

                <table class="table">
                    <tr style="height: 32px;">
                        <td width="80">节点名称</td>
                        <td><input  type="text" value="" name="name"/></td>
                    </tr>
                    <tr style="height: 32px;">
                        <td>IP</td>
                        <td><input type="text" value="" name="ip"></td>
                    </tr>
                    <tr style="height: 32px;">
                        <td>端口</td>
                        <td><input  type="text" value="" name="port"></td>
                    </tr>
                </table>
            </div>
        </g:form>
    </div>

    <div id="createChildServerNodeDialog" style="display:none;">
        <g:form action="createServerNode" controller="distributeApply" name="createChildServerNodeForm"
                onsubmit="return checkChild();">
            <div class="ui-dialog-content ui-widget-content">
                <input type="hidden" value="" id="parentId" name="parentId">

                <table class="table">
                    <tr style="height: 32px;">
                        <td width="80">节点名称</td>
                        <td><input style="height: 26px;" type="text" value="" name="name"/></td>
                    </tr>
                    <tr style="height: 32px;">
                        <td>IP</td>
                        <td><input style="height: 26px;" type="text" value="" name="ip"></td>
                    </tr>
                    <tr style="height: 32px;">
                        <td>端口</td>
                        <td><input style="height: 26px;" type="text" value="" name="port"></td>
                    </tr>
                    <tr style="height: 32px;">
                        <td>是否发送文件</td>
                        <td><input type="radio" value="true" name="isSendObject" checked>是<input type="radio" value="false" name="isSendObject">否</td>
                    </tr>
                </table>
            </div>
        </g:form>
    </div>

    <div id="createParentServerNodeDialog" style="display:none;">
        <g:form action="createServerNode" controller="distributeApply" name="createParentServerNodeForm"
                onsubmit="return checkParent();">
            <div class="ui-dialog-content ui-widget-content">
                <input type="hidden" value="" id="childId" name="childId">

                <table class="table">
                    <tr style="height: 32px;">
                        <td width="80">节点名称</td>
                        <td><input style="height: 26px;" type="text" value="" name="name"/></td>
                    </tr>
                    <tr style="height: 32px;">
                        <td>IP</td>
                        <td><input style="height: 26px;" type="text" value="" name="ip"></td>
                    </tr>
                    <tr style="height: 32px;">
                        <td>端口</td>
                        <td><input style="height: 26px;" type="text" value="" name="port"></td>
                    </tr>
                    <tr style="height: 32px;">
                        <td>是否发送文件</td>
                        <td><input type="radio" value="true" name="isSendObject" checked>是<input type="radio" value="false" name="isSendObject">否</td>
                    </tr>
                </table>
            </div>
        </g:form>
    </div>

</div>
<script type="text/javascript">
    function checkChild() {
        if (!document.createChildServerNodeForm.name.value) {
            alert("节点名称不能为空！");
            document.createChildServerNodeForm.name.focus();
            return false;
        }
        if (!document.createChildServerNodeForm.ip.value) {
            alert("节点IP不能为空！");
            document.createChildServerNodeForm.ip.focus();
            return false;
        }
        if (!document.createChildServerNodeForm.port.value) {
            alert("节点端口不能为空！");
            document.createChildServerNodeForm.port.focus();
            return false;
        } else if (isNaN(document.createChildServerNodeForm.port.value)) {
            alert("节点端口只能是数字！");
            document.createChildServerNodeForm.port.focus();
            document.createChildServerNodeForm.port.value = "";
            return false;
        }

    }
    function check() {
        if (!document.createServerNodeForm.name.value) {
            alert("节点名称不能为空！");
            document.createServerNodeForm.name.focus();
            return false;
        }
        if (!document.createServerNodeForm.ip.value) {
            alert("节点IP不能为空！");
            document.createServerNodeForm.ip.focus();
            return false;
        }
        if (!document.createServerNodeForm.port.value) {
            alert("节点端口不能为空！");
            document.createServerNodeForm.port.focus();
            return false;
        } else if (isNaN(document.createServerNodeForm.port.value)) {
            alert("节点端口只能是数字！");
            document.createServerNodeForm.port.focus();
            document.createServerNodeForm.port.value = "";
            return false;
        }

    }

    function checkParent(){
        if (!document.createParentServerNodeForm.name.value) {
            alert("节点名称不能为空！");
            document.createParentServerNodeForm.name.focus();
            return false;
        }
        if (!document.createParentServerNodeForm.ip.value) {
            alert("节点IP不能为空！");
            document.createParentServerNodeForm.ip.focus();
            return false;
        }
        if (!document.createParentServerNodeForm.port.value) {
            alert("节点端口不能为空！");
            document.createParentServerNodeForm.port.focus();
            return false;
        } else if (isNaN(document.createParentServerNodeForm.port.value)) {
            alert("节点端口只能是数字！");
            document.createParentServerNodeForm.port.focus();
            document.createParentServerNodeForm.port.value = "";
            return false;
        }
    }
</script>
</body>
</html>

