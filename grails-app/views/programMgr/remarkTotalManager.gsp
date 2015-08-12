<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-4-10
  Time: 下午4:11
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>评论统计</title>
    <r:require modules="jqGrid"/>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/programMgr', file: 'remarkTotalManager.js')}"></script>
</head>

<body>
<div class="admin_content_nav">
    <input class="admin_default_but_yellow" value="资源评论统计" type="button" id="programRemark">
    <input class="admin_default_but_yellow" value="用户评论统计" type="button" id="consumerRemark">
</div>

<div id="programDiv">
    <table id="sortProgramGrid"></table>

    <div id="GridPaper"></div>
</div>

<div style="display: none;" id="consumerDiv">
    <table id="sortConsumerGrid"></table>

    <div id="GridConPaper"></div>
</div>

</body>
</html>