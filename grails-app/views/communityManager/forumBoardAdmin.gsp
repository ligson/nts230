<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-4-10
  Time: 上午11:38
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/communityManager', file: 'forumBoardAdmin.js')}"></script>
</head>

<body>
<div id="searchToolBar" class="admin_content_nav">
    <div class="admin_nav_title">
        <span>小组名:</span>
        <label>
            <select class="admin_default_inp admin_default_inp_size2" name="communityId">
                <option value="-1">--请选择--</option>
                <g:each in="${boardList}" var="board">
                    <option value="${board?.id}">${board?.name}</option>
                </g:each>
            </select>
        </label>

        <span>管理员:</span>
        <label>
            <input class="admin_default_inp admin_default_inp_size1" name="name">
        </label>
        <label>
            <input value="检索" class="admin_default_but_yellow" id="searchBtn" type="button">
        </label>
    </div>
</div>
<table id="boardGrid"></table>

<div id="GridPaper"></div>

%{--<div class="admin_default_but_box">
    <input class="admin_default_but_blue" type="button" value="删除" onclick="operate('deleteConsumer', null, null)">
    <input class="admin_default_but_blue" type="button" value="禁用"
           onclick="operate('operaCommunityConsumer', 'userState', false)">
    <input class="admin_default_but_blue" type="button" value="解锁"
           onclick="operate('operaCommunityConsumer', 'userState', true)">
    <input class="admin_default_but_blue" type="button" value="允许上传"
           onclick="operate('operaCommunityConsumer', 'uploadState', true)">
    <input class="admin_default_but_blue" type="button" value="禁止上传"
           onclick="operate('operaCommunityConsumer', 'uploadState', false)">
    <input class="admin_default_but_blue" type="button" value="禁用下载"
           onclick="operate('operaCommunityConsumer', 'canDownload', false)">
    <input class="admin_default_but_blue" type="button" value="允许下载"
           onclick="operate('operaCommunityConsumer', 'canDownload', true)">
    <input class="admin_default_but_blue" type="button" value="禁止评论"
           onclick="operate('operaCommunityConsumer', 'canComment', false)">
    <input class="admin_default_but_blue" type="button" value="允许评论"
           onclick="operate('operaCommunityConsumer', 'canComment', true)">
    <input class="admin_default_but_blue" type="button" value="审核"
           onclick="operate('operaCommunityConsumer', 'notExamine', false)">
</div>--}%
</body>
</html>