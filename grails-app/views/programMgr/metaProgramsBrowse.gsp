<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-18
  Time: 上午10:32
--%>

<%@ page import="nts.program.category.domain.ProgramCategory" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>查看元数据对应的资源列表</title>
    <r:require modules="jqGrid"/>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css/skin', file: 'programCategoryMgr.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'meta.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'metalist.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/programMgr', file: 'metaProgram.js')}"></script>
</head>

<body>
    <div class="tree_main" style="width: 1024px;" >
        <div class="tree_left">
            <div id="zTree" class="ztree">
            </div>
        </div>

        <div class="tree_content" style=" width: 800px; ">
            <input type="hidden" value="" id="selectMetaDefineId">
            <input type="hidden" value="" id="enumId">
            <table id="programGrid"></table>
            <div id="GridPaper"></div>
        </div>
    </div>
</body>
</html>