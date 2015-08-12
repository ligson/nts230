<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-4-9
  Time: 上午9:05
--%>

<%@ page import="nts.commity.domain.StudyCommunity" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>社区管理</title>
    <script type="text/javascript" src="${resource(dir: 'js/boful/communityManager', file: 'index.js')}"></script>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'communityManager_index.css')}">
</head>

<body>
<div id="searchToolBar" class="admin_content_nav">
    <div class="admin_nav_title">
        <span>主题名称:</span>
        <label><input class="admin_default_inp admin_default_inp_size1" name="name"></label>
        <span>状态:</span>
        <select name="state" class="admin_default_inp admin_default_inp_size2">
            <option value="-1">--请选择--</option>
            <g:each in="${StudyCommunity.cnField}" var="state">
                <option value="${state.getKey()}">${state.getValue()}</option>
            </g:each>
        </select>
        <input class="admin_default_but_yellow" type="button" value="查询" id="searchBtn">
    </div>
</div>

%{--<div class="admin_recommend">
    <div class="btn-group rec_mr">
        <button type="button" class="btn  btn-default dropdown-toggle rec_wid"
                style="font-size: 12px; padding: 5px 10px;" data-toggle="dropdown">
            社区状态设置<span class="caret" style="margin-left:5px"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="javascript:void(0);" class="rec_mr_inp " onclick="operate('communityState', 1)">通过</a>
            </li>
            <li><a href="javascript:void(0);" class="rec_mr_inp "
                   onclick="operate('deleteCommunity', null)">删除</a></li>
            <li><a href="javascript:void(0);" class="rec_mr_inp" onclick="operate('communityState', 0)">禁用</a></li>
        </ul>
    </div>

    <div class="btn-group rec_mr">
        <button type="button" class="btn  btn-default dropdown-toggle rec_wid"
                style="font-size: 12px; padding: 5px 10px;" data-toggle="dropdown">
            社区推荐设置<span class="caret" style="margin-left:5px"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="javascript:void(0);" class="rec_mr_inp " onclick="operate('communityRecommend', true)">推荐</a>
            </li>
            <li><a href="javascript:void(0);" class="rec_mr_inp "
                   onclick="operate('communityRecommend', false)">取消推荐</a></li>
        </ul>
    </div>
</div>--}%

<table id="communityGrid"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">
    <input class="admin_default_but_blue" type="button" value="删除" onclick="operate('deleteCommunity', null)">
    <input class="admin_default_but_blue" type="button" value="通过" onclick="operate('communityState', 1)">
    <input class="admin_default_but_blue" type="button" value="禁用" onclick="operate('communityState', 0)">
    <input class="admin_default_but_blue" type="button" value="推荐" onclick="operate('communityRecommend', true)">
    <input class="admin_default_but_blue" type="button" value="取消推荐" onclick="operate('communityRecommend', false)">
</div>
</body>
</html>