<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-4-10
  Time: 下午3:29
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>评论列表</title>
    <r:require modules="jqGrid"/>
    <script type="text/javascript" src="${resource(dir: 'js/boful/programMgr', file: 'remarkManager.js')}"></script>
</head>

<body>

<div id="searchToolBar">
    <div class="search-ToolBar">
        <div class="admin_content_nav">
            <span>审批状态：</span>
            <label>
                <g:select id="approveState" class="admin_default_inp admin_default_inp_size2" name="otherOption" style="max-width: 80px"
                          from="${["-1": "全部", false: "待审批", true: '通过']}" optionKey="key"
                          optionValue="value"
                          value="${params.otherOption}"/>
            </label>
            <label style="width: 50px;">
                <input class="admin_default_but_yellow" type="button" value="搜索" id="searchBtn">
            </label>
        </div>
    </div>
</div>

<table id="remarkGrid"></table>

<div id="GridPaper"></div>


<div class="admin_default_but_box">
    <input onclick="operate()" class="admin_default_but_blue" value="删除" type="button">
    <input onclick="operateApprove()" class="admin_default_but_blue" value="审批" type="button">
</div>
</body>
</html>