<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-6-4
  Time: 下午4:42
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>评论展示</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'p_mgr_showRemark.css')}">
</head>

<body>
<h2 class="showRemark_tit">评论展示</h2>
<table class="table ">
    <tr>
        <th width="120" align="center">评论名称</th>
        <td>${remark?.topic}</td>
    </tr>
    <tr>
        <th width="120" align="center">评论内容</th>
        <td>${remark?.content}</td>
    </tr>
    <tr>
        <th width="120" align="center">回复内容</th>
        <td>
            <g:each in="${remark?.remarkReplys}" var="reply" status="sta">
                <div class="answer_back_word">${reply?.consumer.name}回复:&nbsp;&nbsp;&nbsp;&nbsp;${reply?.content}</div>
            </g:each>
        </td>

    </tr>
    <tr>
        <td colspan="2"><a href="${createLink(controller: 'programMgr', action: 'remarkManager')}"
                           class="btn btn-primary" style="color: #FFF">返回</a></td>
    </tr>
</table>
</body>
</html>