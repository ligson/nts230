<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 13-12-21
  Time: 下午12:33
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>11</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/css', file: 'createProgram.css')}">
    <r:require modules="swfupload,zTree"/>
    <r:require modules="jquery,jquery-cookie,jquery-ui"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/my_createProgram.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/admin/admin.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/bfUploadProgram.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/progedit.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/commonLib',file:'string.js')}"></script>

</head>

<body>
${flash.message}
</body>
</html>