<%@ page import="nts.utils.CTools" %>
<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午6:02
  To change this template use File | Settings | File Templates.
--%>
<html>
<head>
    <title>用户管理</title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'user_mgr_index.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/boful/userMgr', file: 'consumer.js')}"></script>
</head>

<body>
<div id="searchToolBar" class="admin_content_nav">
    <div class="admin_nav_title" style="width: 1024px;">
        <span>帐号:</span><label><input class="admin_default_inp admin_default_inp_size1" style="width: 120px;" name="searchName" value="${searchName}"></label>
        <span>昵称:</span><label><input class="admin_default_inp admin_default_inp_size1" style="width: 120px;" name="searchNickName" value="${searchNickName}"></label>
        <span>姓名:</span><label><input class="admin_default_inp admin_default_inp_size1" style="width: 120px;" name="searchTrueName" value="${searchTrueName}"></label>
        <span>院系:</span><label><select class="admin_default_inp admin_default_inp_size2" style="width: 120px;" name="searchCollege">
        <option value="-1">--请选择--</option>
        <g:each in="${nts.user.domain.College.list()}" var="college">
            <option value="${college.id}" <g:if test="${searchCollege == college.id}">selected="selected"</g:if>>${college.name}</option>
        </g:each>
    </select>
    </label>
        <label>
            <input class="admin_default_but_yellow" value="检索" id="searchBtn" type="button">
        </label>
    </div>
</div>
<table id="consumerGrid"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">
    <input type="button" class="admin_default_but_blue" value="添加" onclick="operate('addConsumer', null, null)">
    <input type="button" class="admin_default_but_blue" value="删除" onclick="operate('deleteConsumer', null, null)">
    <input type="button" class="admin_default_but_blue" value="禁用"
           onclick="operate('operaConsumer', 'userState', true)">
    <input type="button" class="admin_default_but_blue" value="解锁"
           onclick="operate('operaConsumer', 'userState', false)">
    <input type="button" class="admin_default_but_blue" value="允许上传"
           onclick="operate('operaConsumer', 'uploadState', '0')">
    <input type="button" class="admin_default_but_blue" value="禁止上传"
           onclick="operate('operaConsumer', 'uploadState', '1')">
    <input type="button" class="admin_default_but_blue" value="禁用下载"
           onclick="operate('operaConsumer', 'canDownload', true)">
    <input type="button" class="admin_default_but_blue" value="允许下载"
           onclick="operate('operaConsumer', 'canDownload', false)">
    <input type="button" class="admin_default_but_blue" value="禁止评论"
           onclick="operate('operaConsumer', 'canComment', true)">
    <input type="button" class="admin_default_but_blue" value="允许评论"
           onclick="operate('operaConsumer', 'canComment', false)">
    <input type="button" class="admin_default_but_blue" value="审核"
           onclick="operate('operaConsumer', 'isRegister', true)">
</div>
<input id="editPage" type="hidden" value="${editPage}">
<input id="userRole" type="hidden" value="${userRole}">
</body>
</html>