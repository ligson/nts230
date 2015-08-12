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
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}">
    <r:require modules="zTree"></r:require>
    <script type="text/javascript" src="${resource(dir: 'js/boful/userMgr', file: 'consumerRole.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'allselect.js')}"></script>
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
        line-height: 32px;
    }

    .clear_border {
        border: 0;
        /*  background-color: #fff;
          border-bottom: 1px solid #4190d0;*/
        background: none;
        color: #4190D0;
        cursor: pointer;
    }

    .clear_border:hover {
        text-decoration: underline;
        color: #d58905;
    }
    </style>
</head>

<body>

<div style="overflow-y:scroll;height:495px;width:98%; margin: 10px 0 0 10px">
    <div style="width: 1024px;">
        <div class="tree_left">
            <div id="zTree2" class="ztree"></div>
        </div>
        %{--<input class="boful_tree_content_but" type="button" value="用户添加角色" id="createConsumer">--}%

        <input id="id" type="hidden">
        <input id="name" type="hidden">

        <div id="createConsumerRoleDialog" style="display:none;">
            <g:form controller="userMgr" action="consumerRoleCreate" name="createConsumerForm">
                <div class="ui-dialog-content ui-widget-content">
                    <input type="hidden" value="" id="selectRoleTypeId" name="roleId">
                    <input type="hidden" id="idList" name="idList">
                    选择角色:<div id="zTree" class="ztree"></div>
                </div>
            </g:form>
        </div>

        <div class="tree_content" id="appendDiv">

            <h2 style="margin: 0 0 10px 0; font-size: 14px; ">用户角色列表：</h2>
            <table border="1" cellpadding="0" cellspacing="0" bordercolor="#e2e2e2"
                   style="width:800px;line-height:28px;border: #e2e2e2 1px solid; ">

                <thead>
                <tr class="th"><input type="hidden" value="" id="selectTypeId" name="roleId">
                    <td width="35" align="center" class="th">选择</td>
                    <td width="60" align="center" class="th">ID</td>
                    <td width="204" align="center" class="th">用户</td>
                    <td width="196" align="center" class="th">角色</td>
                    <td width="293" align="center" class="th">操作</td>
                </tr>
                </thead>
                <g:each in="${consumers}" var="consumer">
                    <tr>
                        <td align="center">
                            <input type="checkbox" name="idList" id="id${consumer?.id}"
                                   onchange="checkId(${consumer?.id})">
                        </td>
                        <td align="center">${consumer?.id}</td>
                        <td align="center">${consumer?.name}</td>
                        <td align="center">${consumer?.userRole?.name}</td>
                        <td align="center">
                            <input class="clear_border" type="button" value="添加角色"
                                   onclick="createConsumer('${consumer?.name}', ${consumer?.id})">
                            <input class="clear_border" type="button" value="删除角色"
                                   onclick="removeConsumer(${consumer?.id})">
                            <input class="clear_border" type="button" value="调整用户角色"
                                   onclick="moveConsumer('${consumer?.name}', ${consumer?.id})">
                        </td>
                    </tr>
                </g:each>

            </table>
            <input type="button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
                   style="margin-top: 5px;" value="全选" onclick="checkAllConsumer(${consumers?.id})"/>
            <input type="button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
                   style="margin-top: 5px;" value="用户添加角色" onclick="addAll()"/>

            <div id="page" class="page">
                <g:guiPaginate action="consumerRole" controller="userMgr" total="${total}"/>
            </div>

        </div>

        <div id="moveConsumerRoleDialog" style="display:none;">
            <g:form controller="userMgr" action="consumerRoleMove" name="moveConsumerForm">
                <div class="ui-dialog-content ui-widget-content">
                    <input type="hidden" value="" id="selectRoleTypeId1" name="roleId">
                    <input type="hidden" id="idList1" name="idList">
                    用户名&nbsp;&nbsp;<input type="text" value="" name="consumerName" id="consumerName1" disabled><br><br>
                    选择角色:<div id="zTree1" class="ztree"></div>
                </div>
            </g:form>
        </div>
    </div>
</div>
</body>
</html>