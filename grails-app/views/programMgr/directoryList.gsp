<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-4-10
  Time: 下午2:12
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>元数据标准列表</title>
    <r:require modules="jqGrid,jquery,jquery-ui"/>
    <script type="text/javascript" src="${resource(dir: 'js/boful/programMgr',file: 'directoryList.js')}"></script>
</head>

<body>
<input id="isDeleteView" type="hidden">
<input id="isUpdateView" type="hidden">
<input id="editPage" type="hidden" value="${editPage}">
<table id="directoryGrid"></table>
<div id="GridPaper"></div>
<div>
    <input class="subbtn" onclick="operate()" value="删除" type="button">
</div>
</body>
</html>