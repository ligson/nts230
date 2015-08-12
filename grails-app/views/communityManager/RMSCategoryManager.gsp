<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-4-9
  Time: 下午5:36
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>社区分类管理</title>
    <script type="text/javascript" src="${resource(dir: 'js/boful/communityManager', file: 'RMSCategory.js')}"></script>
</head>

<body>
<div id="searchToolBar" class="admin_content_nav">
    <div class="admin_nav_title">
        <span>分类级别:</span>
        <select class="admin_default_inp admin_default_inp_size2" name="parentid">
            <option value="">全部</option>
            <option value="0">一级类别</option>
            <option value="1">二级类别</option>
        </select>
        <span>分类名称:</span>
        <label>
            <input name="name" class="admin_default_inp admin_default_inp_size1">
        </label>
        <label>
            <input class="admin_default_but_yellow" type="button" id="searchBtn" value="搜索">
            <a class="admin_default_but_yellow" style="color: #FFF"
               href="${createLink(controller: 'communityManager', action: 'categoryCreate')}">添加分类</a>
        </label>
    </div>
</div>
<table id="RMSCategoryGrid"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">
    <input class="admin_default_but_blue" type="button" value="批量删除" onclick="operate()"/>

</div>
</body>
</html>