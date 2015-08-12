<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-4-9
  Time: 下午4:43
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>社区活动管理</title>
    <script type="text/javascript" src="${resource(dir: 'js/boful/communityManager', file: 'activity.js')}"></script>
</head>

<body>
<table id="activityGrid"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">
    <input class="admin_default_but_blue" type="button" value="删除" onclick="operate('deleteActivity', null)">
    <input class="admin_default_but_blue" type="button" value="打开" onclick="operate('operaActivityState', true)">
    <input class="admin_default_but_blue" type="button" value="关闭" onclick="operate('operaActivityState', false)">


</div>
</body>
</html>