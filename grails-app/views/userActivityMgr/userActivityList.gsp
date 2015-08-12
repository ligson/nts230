<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-4-9
  Time: 上午9:53
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>活动管理</title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <!--[if lte IE 6]>
   <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style-ie6.css')}" type=text/css rel=stylesheet>
  <![endif]-->
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'dropdown.js')}"></script>
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0', file: 'src/css/ui.jqgrid.css')}"/>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'userActivityList.css')}">
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0', file: 'js/i18n/grid.locale-cn.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0', file: 'js/jquery.jqGrid.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'common.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/userActivityMgr', file: 'userActivityList.js')}"></script>
</head>

<body>
<div id="searchToolBar" class="admin_content_nav">
    <div class="admin_nav_title">
        <span>标题：</span>
        <label>
            <input class="admin_default_inp admin_default_inp_size1" type="text" name="name"
                   style="height: 30px; padding: 0">
        </label>
        <span>审批状态:</span>
        <label>
            <select class="admin_default_inp admin_default_inp_size2" name="approval">
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

<div class="admin_recommend">
    <div class="btn-group rec_mr" onclick="createUserActivity('${createLink(controller: 'UserActivityMgr', action: 'userActivityCreate')}')">
            <label><button type="button" class="btn  btn-default dropdown-toggle rec_wid"
                           style="font-size: 12px; padding: 5px 10px;">创建系统活动</button></label>
    </div>

    <div class="btn-group rec_mr">
        <button type="button" class="btn  btn-default dropdown-toggle rec_wid"
                style="font-size: 12px; padding: 5px 10px;" data-toggle="dropdown">
            活动设置<span class="caret" style="margin-left:5px"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="javascript:void(0);" class="rec_mr_inp" onclick="userActivityApproval('true')">审批通过</a></li>
            <li><a href="javascript:void(0);" class="rec_mr_inp  res_dieer"
                   onclick="userActivityApproval('false')">审批驳回</a></li>
            <li><a href="javascript:void(0);" class="rec_mr_inp" onclick="userActivityOpenChanges('true')">开启活动</a></li>
            <li><a href="javascript:void(0);" class="rec_mr_inp res_dieer"
                   onclick="userActivityOpenChanges('false')">关闭活动</a>
            </li>
            <li><a href="javascript:void(0);" class="rec_mr_inp" onclick="userActivityDeletes()">批量删除</a></li>
        </ul>
    </div>

</div>
<table id="userActivityListId"></table>

<div id="GridPaper"></div>

%{--<div class="admin_default_but_box">
    <a href="${createLink(controller: 'UserActivityMgr', action: 'userActivityCreate')}">
        <input class="admin_default_but_blue" type="button" value="创建系统活动"/></a>
    <input class="admin_default_but_blue" type="button" value="审批通过" onclick="userActivityApproval('true')"/>
    <input class="admin_default_but_blue" type="button" value="审批驳回" onclick="userActivityApproval('false')"/>
    <input class="admin_default_but_blue" type="button" value="开启活动" onclick="userActivityOpenChanges('true')"/>
    <input class="admin_default_but_blue" type="button" value="关闭活动" onclick="userActivityOpenChanges('false')"/>
    <input class="admin_default_but_blue" type="button" value="批量删除" onclick="userActivityDeletes()"/>
</div>--}%
<input id="editPage" type="hidden" value="${editPage}">
</body>
</html>