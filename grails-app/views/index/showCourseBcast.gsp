<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <!--meta name="layout" content="main" /-->

    <title>频道信息</title>
    <style type="text/css">
    body {
        background-color: #ECF5FE;
        margin-top: 5px;
    }

    .tdbg07 {
        BORDER: #6997C1 1px solid;
    }
    </style>
    <script LANGUAGE="javascript">

    </script>

</head>

<body>
<table width="440" border="0" align="center" class="tdbg07">
    <tr align="center">
        <td height="23" colspan="2">频道信息</td>
    </tr>
    <tr>
        <td width="100" height="24">频道名称：</td>
        <td width="361">${courseBcast?.channel}</td>
    </tr>
    <tr>
        <td height="20">媒体URL：</td>
        <td>${courseBcast?.mediaUrl}</td>
    </tr>
    <g:if test="${courseBcast?.isMultcast == true}">
        <tr>
            <td height="20">组播地址：</td>
            <td>${courseBcast?.multcastIP}:${courseBcast?.multcastPort}</td>
        </tr>
    </g:if>
    <tr>
        <td height="20">屏幕URL：</td>
        <td>${courseBcast?.screenUrl}</td>
    </tr>

    <tr>
        <td height="20">开始时间：</td>
        <td><g:formatDate format="yyyy-MM-dd HH:mm" date="${courseBcast.datePlayed}"/></td>
    </tr>
    <tr>
        <td height="20">结束时间：</td>
        <td><g:formatDate format="yyyy-MM-dd HH:mm" date="${courseBcast.dateDeleted}"/></td>
    </tr>
    <tr>
        <td height="20">权限级别：</td>
        <td>${courseBcast?.privilege}</td>
    </tr>
    <tr>
        <td height="23">频道主题：</td>
        <td>${courseBcast?.title}</td>
    </tr>
    <tr>
        <td height="20">频道主讲：</td>
        <td>${courseBcast?.author}</td>
    </tr>

    <tr>
        <td height="20" valign="top">频道描述：</td>
        <td valign="top">　</td>
    </tr>
    <tr>
        <td colspan=2 style="padding-left:20px;" valign="top">&nbsp;&nbsp;&nbsp;&nbsp;${courseBcast?.notes}</td>
    </tr>
</table>
</body>
</html>
