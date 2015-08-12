<%--
  Created by IntelliJ IDEA.
  User: lvyangtao
  Date: 14-3-9
  Time: 下午4:04
--%>

<%@ page import="nts.user.domain.SecurityResource; nts.user.domain.Role" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>角色管理</title>
    <r:require modules="zTree"/>
    <!--jqGrid-->
    <r:require modules="jqGrid"/>
    <script type="text/javascript" src="${resource(dir: 'js/boful/userMgr', file: 'roleTree.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/admin', file: 'admin.js')}"></script>
    <style type="text/css">

    .tree_left {
        width: 200px;
        height: 480px;
        float: left;
        margin-left: 15px;
        padding-top: 10px;
        border-right: 1px solid #E2E3E4;
    }

    .tree_content {
        width: 750px;
        height: 460px;
        padding: 5px 15px 15px 15px;
        float: left;
        margin-left: 5px;
        border-left: 1px solid #FFF;
    }

    table, td, tr, th {
        font-size: 12px;
        margin: 0px;
        border-collapse: collapse;
        /*line-height: 32px;*/
    }

    .quanxian_style1 {
        float: left;
        width: 80%;
        margin-top: 10px;

    }

    .quanxian_style2 {
        float: left;
        width: 300px;
        margin-top: 30px;
    }

    .clear_border {
        border: 0;
        color: #4190d0;
        /* border-bottom: 1px solid #4190d0;*/
        cursor: pointer;
    }

    .clear_border:hover {
        color: #d58905;
        text-decoration: underline;
    }

    .ui-jqgrid .ui-jqgrid-htable th div {
        overflow: hidden;
        position: relative;
        height: 35px;
    }

    /*    #jqgh_resourcesGrid_role,
        #jqgh_resourcesGrid_id,
        #jqgh_resourcesGrid_resource,
        #jqgh_resourcesGrid_操作 {
            height: 30px;
            line-height: 20px;
        }*/

    .ui-th-ltr, .ui-jqgrid .ui-jqgrid-htable th.ui-th-ltr {
        border-left: 0 none;
    }

    .ui-jqgrid .ui-jqgrid-pager {
        border-left: 0 none !important;
        border-right: 0 none !important;
        border-bottom: 0 none !important;
        margin: 0 !important;
        padding: 0 !important;
        position: relative;
        height: 30px;
        line-height: 20px;
        white-space: nowrap;
        overflow: hidden;
        font-size: 11px;
    }

    #pg_GridPaper table tr td {
        padding: 0;
    }

    .ui-jqgrid .ui-jqgrid-pager {
        border-left: 0 none !important;
        border-right: 0 none !important;
        border-bottom: 0 none !important;
        margin: 0 !important;
        padding: 0 !important;
        position: relative;
        height: 30px;
        line-height: 20px;
        white-space: nowrap;
        overflow: hidden;
        font-size: 11px;
    }
    </style>
</head>

<body>

<div style="overflow-y:scroll;height:495px;width:98%; margin: 10px 0 0 10px">
    <div style="width: 1024px;">
        <div class="tree_left">
            <div id="zTree" class="ztree"></div>
        </div>

        <div class="tree_content">

            <input type="hidden" value="" id="selectRoleTypeId">
            <input class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button"
                   value="添加角色" id="createRole">
            <input class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button"
                   value="添加权限" id="createResource">
            <input class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button"
                   value="删除角色" id="removeRole">
            <input class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button" value="权限下载" onclick="window.location.href='${createLink(controller: 'userMgr',action: 'exportResource')}'">
            <em style="margin: 20px 0 0 20px; font-size: 12px;width: 120px; ">添加角色请选择左侧相应节点，默认为根节点</em>
            <g:form method="post" action="roleUpdate" name="updateRoleForm" controller="userMgr"
                    onsubmit="return checkRole();">
                <g:hiddenField name="id" value=""/>
                <g:hiddenField name="version" value=""/>
                <div class="dialog">
                    <table style="margin: 20px 0 20px 0;">
                        <tbody>

                        <tr class="prop">
                            <td valign="top" class="name">
                                角色名称：
                            </td>
                            <td valign="top">
                                <g:textField name="name" class="admin_default_inp" id="name" maxlength="250" value=""/>
                            </td>
                        </tr>

                        </tbody>
                    </table>

                </div>

                <div class="buttons">
                    <span class="buttons buttons_right" style="margin-left: 65px;"><input
                            class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button"
                            onclick="history.back();"
                            value="取消"/></span>
                    <span class="buttons buttons_right"><input onclick="updateRoleBtn()"
                            class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button"
                            value="修改"/></span>

                </div>
            </g:form>
            <div id="appendDiv" style="margin-top: 20px;">
                <h2 style="margin: 0 0 10px 0; font-size: 14px; ">权限列表：</h2>
                <table id="resourcesGrid"></table>

                <div id="GridPaper"></div>
            </div>
        </div>

        <div id="createRoleDialog" style="display:none;">
            <g:form controller="userMgr" action="roleCreate" name="createRoleForm" onsubmit="return check();">
                <div class="ui-dialog-content ui-widget-content">
                    <input type="hidden" value="" id="parentId" name="parentId">
                    角色名称&nbsp;&nbsp;<input type="text" value="" name="name" id="roleName">
                </div>
            </g:form>
        </div>

        <div id="createResourceDialog" style="display:none;">
            <g:form controller="userMgr" action="resourceCreate" name="createResourceForm"
                    onsubmit="return checkResource();">
                <div class="ui-dialog-content ui-widget-content">
                    <input id="resourceId" name="id" type="hidden">

                    <div class="quanxian_style1">
                        角色名称&nbsp;&nbsp;<input type="text" disabled value="" name="name" id="resourceName">
                    </div>

                    <div class="quanxian_style2">
                        <div style="float: left; margin-right: 8px;">
                            权限选择&nbsp;&nbsp;<select onchange="changeControllerName()" id="selectCheck"
                                                    name="selectCheck">
                            <option>--请选择--</option>
                            <g:each in="${resources}" var="resource">
                                <option value="${resource?.id}">${resource?.controllerName}</option>
                            </g:each>

                        </select>
                        </div>

                        <div id="appendSelect" style="float:left;width: 500px">

                        </div>
                    </div>
                </div>
            </g:form>
        </div>

    </div>
</div>

<script type="text/javascript">
    function check() {
        if (!document.createRoleForm.name.value) {
            alert("角色名称不能为空！");
            document.createRoleForm.name.focus();
            return false;
        }
    }
    function checkResource() {
        if (document.createResourceForm.selectCheck.value == '--请选择--') {
            myAlert("请选择权限");
            return false;
        }
        var actionTotal = $("#appendSelect input[name=actionId]:checked").length;
        if(actionTotal==0){
            myAlert("请选择相应权限");
            return false;
        }

    }
    function checkRole() {
        if (!document.updateRoleForm.id.value) {
            alert("请选择角色节点！");
            return false;
        }
        if (!document.updateRoleForm.name.value) {
            alert("角色名称不能为空！");
            document.updateRoleForm.name.focus();
            return false;
        }
    }
</script>
</body>
</html>