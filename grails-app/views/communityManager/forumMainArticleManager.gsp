<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-4-9
  Time: 下午2:06
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>帖子管理</title>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/communityManager', file: 'forumMainArticle.js')}"></script>
</head>

<body>
<table id="articleGrid"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">
    <input class="admin_default_but_blue" type="button" value="删除" onclick="operate()">
</div>
</body>
</html>