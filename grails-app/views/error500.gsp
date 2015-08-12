<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/5/28
  Time: 14:36
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>服务器内部错误</title>
    <meta content="none" name="layout">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'ouknow_error_404.css')}">
</head>

<body>
<div class="ou_error_f">
    <div class="ou_e_l">
        <p><a href="${createLink(controller: 'index', action: 'index')}">返回首页</a></p>
    </div>
</div>
</body>
</html>