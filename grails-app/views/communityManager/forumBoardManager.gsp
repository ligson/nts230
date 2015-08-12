<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-4-9
  Time: 上午11:53
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>小组管理</title>
    <script type="text/javascript" src="${resource(dir: 'js/boful/communityManager', file: 'forumBoard.js')}"></script>
</head>

<body>
<table id="boardGrid"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">
    <input class="admin_default_but_blue" type="button" value="删除" onclick="operate()">
</div>
</body>
</html>