<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-3-27
  Time: 上午8:32
--%>

<%@ page import="nts.program.domain.Program" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>资源回收站</title>
    <r:require modules="jqGrid"/>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/programMgr', file: 'deletedProgramList.js')}"></script>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'manager_resource_list.css')}">
</head>

<body>
<table id="programGrid"></table>

<div id="GridPaper"></div>


<div class="admin_default_but_box">
    <input class="admin_default_but_blue" onclick=" operate('programMgr', 'programDelete');"
           type="button"
           value="删除"/>
    <input class="admin_default_but_blue" onclick="operate('programMgr', 'programStateSet');"
               type="button"
               value="还原"/>


</div>
</body>
</html>