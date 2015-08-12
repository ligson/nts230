<%@ page import="nts.program.domain.Program; nts.utils.CTools" %>
<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午4:22
  To change this template use File | Settings | File Templates.
--%>

<html>
<head>
    <title>资源列表</title>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}"
          media="all">
    <!--jqGrid-->
    <r:require modules="jqGrid"/>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/userMgr', file: 'selectCategoryDialog.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/userMgr', file: 'canOptionProgramList.js')}"></script>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'manager_resource_list.css')}"/>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_index_main.css')}">
</head>

<body>
<div id="searchToolBar" class="admin_content_nav">
    <div class="admin_nav_title">
        <span>资源名称:</span>
        <label><input class="admin_default_inp admin_default_inp_size1" type="text" name="name"></label>
        <label>
            <input class="admin_default_but_yellow" type="button" value="搜索" id="searchBtn">
        </label>
    </div>
    <input type="hidden" name="groupId" id="groupId" value="${groupId}">
    <input type="hidden" name="kind" id="kind" value="1">
</div>
<table id="programGrid"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">
    <input class="admin_default_but_blue" title="从用户组移除可点播资源"
           onclick="operate('userMgr', 'userGroupProgramRemove', 1);"
           type="button"
           value="移除"/>
    <input class="admin_default_but_blue" title="返回"
           onclick="javascript:location.href=baseUrl + 'userMgr/userGroupList?editPage=${editPage}';"
           type="button"
           value="返回"/>
</div>
</body>
</html>