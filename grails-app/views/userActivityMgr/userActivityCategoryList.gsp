<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-4-10
  Time: 上午10:24
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>活动分类</title>
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0', file: 'src/css/ui.jqgrid.css')}"/>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0', file: 'js/i18n/grid.locale-cn.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0', file: 'js/jquery.jqGrid.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'common.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/userActivityMgr', file: 'userActivityCategoryList.js')}"></script>
</head>

<body>
<div id="searchToolBar" class="admin_content_nav">
    <div class="admin_nav_title">
        <span>分类级别:</span><label>
        <select class="admin_default_inp admin_default_inp_size2" name="level">
        <g:if test="${parentID != '' && parentID != null}">
            <option value="all" <g:if test="${parentID == 'all'}">selected="selected"</g:if>>全部</option>
            <option value="0" <g:if test="${parentID == '0'}">selected="selected"</g:if>>一级类别</option>
            <option value="1" <g:if test="${parentID == '1'}">selected="selected"</g:if>>二级类别</option>
        </g:if>
        <g:else>
            <option value="all"selected="selected">全部</option>
            <option value="0" >一级类别</option>
            <option value="1">二级类别</option>
        </g:else>
        </select>
    </label>
        <span>名称：</span>
        <label><input class="admin_default_inp" type="text" name="name" value="${searchName}"></label>
        <label>
            <input class="admin_default_but_yellow" type="button" value="搜索" id="searchBtn"/>
            <a href="${createLink(controller: 'UserActivityMgr', action: 'rmsCategoryCreate')}">
                <input class="admin_default_but_yellow" type="button" value="添加分类"/></a>
        </label>
    </div>
</div>
<table id="userActivityCategoryListId"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">

    <input class="admin_default_but_blue" type="button" value="批量删除" onclick="rmsCategoryDeletes()"/>
</div>
<input id="editPage" type="hidden" value="${editPage}">
</body>
</html>