<%@ page import="nts.utils.CTools" %>

<html>
<head>
    <title>个人用户组管理</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <script type="text/javascript" src="${resource(dir: 'js/boful/userMgr', file: 'userGroupList.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/userMgr', file: 'consumerShowDialog.js')}"></script>
</head>

<body>
<table id="userGroupGrid"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">
    <input class="admin_default_but_blue" type="button" value="删除所选" onclick="operate('deleteUserGroup', null)">
    <input class="admin_default_but_blue" type="button" value="添加用户组" onclick="operate('addUserGroup', null)">
    %{-- <input class="admin_default_but_blue" type="button" value="允许点播" onclick="operate('canPlay', 1)">
     <input class="admin_default_but_blue" type="button" value="禁止点播" onclick="operate('canPlay', 0)">
     <input class="admin_default_but_blue" type="button" value="允许下载" onclick="operate('canDownload', 1)">
     <input class="admin_default_but_blue" type="button" value="禁止下载" onclick="operate('canDownload', 0)">--}%
</div>

<div id="consumerDialog" class="bg" style="display:none;" title="导入组成员">
    <div id="searchToolBar" class="admin_content_nav">
        <div class="admin_nav_title">
            <span>帐号:</span><label><input class="admin_default_inp admin_default_inp_size1" name="searchName"></label>
            <span>院系:</span><label><select class="admin_default_inp admin_default_inp_size2" name="searchCollege">
            <option value="-1">--请选择--</option>
            <g:each in="${nts.user.domain.College.list()}" var="college">
                <option value="${college.id}">${college.name}</option>
            </g:each>
        </select>
        </label>
            <label>
                <input class="admin_default_but_yellow" value="检索" id="searchConsumerBtn" type="button">
            </label>
        </div>
        <input type="hidden" name="groupId" id="groupId">
    </div>

    <table id="consumerGrid"></table>
    <div id="consumerGridPaper"></div>

    <div class="admin_default_but_box">
        <input class="admin_default_but_blue" type="button" value="加入到组" onclick="operate2('addToUserGroup', null)">
    </div>
</div>

<input id="editPage" type="hidden" value="${editPage}">
</body>
</html>

