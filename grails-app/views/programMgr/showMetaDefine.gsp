<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-4-11
  Time: 上午9:01
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
    <r:require modules="jqGrid"/>
    <script type="text/javascript" src="${resource(dir: 'js/boful/programMgr', file: 'metaDefineList.js')}"></script>
</head>

<body>
<table id="metaDefineGrid"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">
    <input class="admin_default_but_blue" onclick="operate()" value="删除" type="button">
</div>
</body>
</html>