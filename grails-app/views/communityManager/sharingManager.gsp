<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-4-9
  Time: 下午3:12
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>共享管理</title>
    <script type="text/javascript" src="${resource(dir: 'js/boful/communityManager', file: 'sharing.js')}"></script>
</head>

<body>
<input id="isDeleteView" type="hidden">
<input id="isState" type="hidden">
<table id="sharingGrid"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">
    <input class="admin_default_but_blue" type="button" value="删除" onclick="operate('deleteSharing', null, null)">
    <input class="admin_default_but_blue" type="button" value="下载"
               onclick="operate('operateSharing', 'canDownload', true)">
    <input class="admin_default_but_blue" type="button" value="取消下载"
               onclick="operate('operateSharing', 'canDownload', false)">

</div>
</body>
</html>