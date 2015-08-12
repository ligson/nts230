<%--
  Created by IntelliJ IDEA.
  User: lvyangtao
  Date: 14-3-9
  Time: 下午4:04
--%>

<%@ page import="nts.user.domain.Role" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>角色管理</title>
    <r:require modules="zTree"/>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/boful/userMgr', file: 'moveUserGroup.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'allselect.js')}"></script>

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
        line-height: 32px;
    }

    .user_add_role {
        border: 0;
        background: none;
        color: #4190D0;
        cursor: pointer;
    }

    .user_add_role:hover {
        border: 0;
        color: #d58905;
        text-decoration: underline;
        cursor: pointer;
    }

    /*.clear_border {
        border: 0;
        *//*  background-color: #fff;
          border-bottom: 1px solid #4190d0;*//*
        background: none;
        color: #4190D0;
        cursor: pointer;
    }*/

    .clear_border:hover {
        text-decoration: underline;
        color: #d58905;
    }
    </style>
</head>

<body>

<div style="width: 1024px;">
    <div class="tree_left">
        <div id="zTree2" class="ztree"></div>
    </div>
    <input id="id" type="hidden">
    <input id="name" type="hidden">

    <div id="createUserGroupRoleDialog" style="display:none;">
        <g:form controller="userMgr" action="userGroupRoleCreate" name="createUserGroupForm">
            <div class="ui-dialog-content ui-widget-content">
                <input type="hidden" value="" id="roleId" name="roleId">
                <input type="hidden" id="idList" name="idList">
                选择角色:<div id="zTree" class="ztree"></div>
            </div>
        </g:form>
    </div>

    <div class="tree_content" id="appendDiv">

        <h2 style="margin: 0 0 10px 0; font-size: 14px; ">用户组角色列表：</h2>
        <table border="1" cellpadding="0" cellspacing="0" bordercolor="#e2e2e2">

            <thead>
            <tr style="height: 32px;"><input type="hidden" value="" id="selectTypeId" name="roleId">
                <td width="35" align="center" class="th">选择</td>
                <td width="60" align="center" class="th">ID</td>
                <td width="204" align="center" class="th">用户组</td>
                <td width="196" align="center" class="th">角色</td>
                <td width="293" align="center" class="th">操作</td>
            </tr></thead>
            <g:each in="${userGroups}" var="userGroup">
                <tr>
                    <td align="center">
                        <input type="checkbox" name="idList" id="id${userGroup?.id}"
                               onchange="checkId(${userGroup?.id})">
                    </td>
                    <td align="center">${userGroup?.id}</td>
                    <td align="center">${userGroup?.name}</td>
                    <td align="center">${userGroup?.role?.name}</td>
                    <td align="center">
                        <input class="user_add_role" type="button" value="添加角色"
                               onclick="createUserGroup('${userGroup?.name}', ${userGroup?.id})">
                        <input class="user_add_role" type="button" value="删除角色"
                               onClick="removeUserGroup(${userGroup?.id})">
                        <input class="user_add_role" type="button" value="调整用户组角色"
                               onclick="moveUserGroup('${userGroup?.name}', ${userGroup?.id})">
                    </td>
                </tr>
            </g:each>
        </table>

        <input type="button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
               style="margin-top: 5px;" value="全选" onClick="checkAllUserGroup(${userGroups?.id})">
        <input type="button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
               value="用户组添加角色" style="margin-top: 5px;" onClick="addAll()"/>

        <div id="page" class="page">
            <g:guiPaginate action="userGroupRole" controller="userMgr" total="${total}"/>
        </div>

    </div>

    <div id="moveUserGroupRoleDialog" style="display:none;">
    <p>
        <g:form controller="userMgr" action="userGroupMove" name="moveUserGroupForm">

            <input type="hidden" value="" id="roleId1" name="roleId">
            <input type="hidden" id="idList1" name="idList">
            用户组名:&nbsp;&nbsp;<input type="text" value="" name="userGroupName" id="userGroupName1"
                                    disabled><br><br>
            选择角色:<div id="zTree1" class="ztree"></div>

        </g:form>
    </p>
    </div>
</div>

</body>
</html>