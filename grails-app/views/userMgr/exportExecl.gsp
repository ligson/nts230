<%@ page contentType="application/msexcel; charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>Execl</title>
</head>

<body>
<%
    response.setHeader("Content-disposition", "inline; filename=Excel.xls");
%>
<div class="list" id="consumer_list">
    <table border="1">
        <thead>
        <tr>
            <td>用户帐号</td>
            <td>用户昵称</td>
            <td>真实姓名</td>
            <td>性别</td>
            <td>所属院系</td>
            <td>角色</td>
            <td>状态</td>
            <td>上传</td>
            <td>下载</td>
            <td>审核</td>
            <td>评论</td>
            <td>创建时间</td>
        </tr>
        </thead>
        <tbody>
        <g:each in="${searchList}" status="i" var="consumer">
            <tr>
                <td>${fieldValue(bean: consumer, field: 'name')}</td>
                <td>${fieldValue(bean: consumer, field: 'nickname')}</td>
                <td>${fieldValue(bean: consumer, field: 'trueName')}</td>
                <td>${consumer.gender == 1 ? '男' : '女'}</td>
                <td>${fieldValue(bean: consumer, field: 'college.name')}</td>
                <td>
                    <g:if test="${consumer.role == 1}">管理员</g:if>
                    <g:if test="${consumer.role == 2}">老师</g:if>
                    <g:if test="${consumer.role == 3}">学生</g:if>
                </td>
                <td>${consumer.userState ? '正常' : '锁定'}</td>
                <td>
                    <g:if test="${consumer.uploadState == 1}">允许</g:if>
                    <g:if test="${consumer.uploadState == 0}">禁止</g:if>
                    <g:if test="${consumer.uploadState == 2}">申请</g:if>
                </td>
                <td>${consumer.canDownload ? '允许' : '禁止'}</td>
                <td>${consumer.notExamine ? '免审' : '审核'}</td>
                <td>${consumer.canComment ? '允许' : '禁止'}</td>
                <td><g:formatDate format="yyyy-MM-dd" date="${consumer.dateCreated}"/></td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>
</body>
</html>
