<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-4-9
  Time: 上午11:33
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>作品管理</title>
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0', file: 'src/css/ui.jqgrid.css')}"/>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0', file: 'js/i18n/grid.locale-cn.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0', file: 'js/jquery.jqGrid.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'common.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/userActivityMgr', file: 'userWorkList.js')}"></script>
</head>

<body>
<div id="searchToolBar" class="admin_content_nav">
    <div class="admin_nav_title">
        <span>标题：</span>
        <label>
            <input class="admin_default_inp admin_default_inp_size1" type="text" name="name">
        </label>
        <span>审批状态:</span>
        <label><select class="admin_default_inp admin_default_inp_size2" name="approval">
            <option value="0">--未选择--</option>
            <option value="1">审批未通过</option>
            <option value="2">待审批</option>
            <option value="3">审批通过</option>
        </select>
        </label>
        <label>
            <input class="admin_default_but_yellow" type="button" value="搜索" id="searchBtn"/>
        </label>
    </div>
</div>
<table id="userWorkListId"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">
    <label>
        <input class="admin_default_but_blue" type="button" value="审批通过" onclick="userWorkApproval('true')"/>
    </label>
    <label>
        <input class="admin_default_but_blue" type="button" value="审批驳回" onclick="userWorkApproval('false')"/>
    </label>
    <label>
        <input class="admin_default_but_blue" type="button" value="批量删除" onclick="userWorkDeletes()"/>
    </label>
</div>
</body>
</html>