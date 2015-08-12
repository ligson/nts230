<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-6-11
  Time: 下午3:35
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>job列表</title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
</head>

<body>
    <table class="table" width="600">
        <thead>
        <tr>
            <td>id</td>
            <td>节点名称</td>
            <td>job组</td>
            <td>操作</td>
        </tr>
        </thead>

        <g:each in="${jobs}" var="job" status="sta">
            <tr>
                <td>${job?.group}</td>
                <td>${job?.name}</td>
                <td>${job?.id}</td>
                <td><input type="button" class="btn btn-primary btn-xs"  value="关闭" onclick="window.location.href='${createLink(controller: 'programMgr',action: 'closeTimePlanJob',params: [group:job.group,name:job.id])}'"/></td>
            </tr>
        </g:each>
    </table>
</body>
</html>