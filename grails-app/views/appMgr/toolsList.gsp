<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link href="${createLinkTo(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <title>工具管理</title>
    <style type="text/css">
    .Tab {
        border-collapse: collapse;
        width: 100%;
        height: 500px;
    }

    .Tab1 {
        border-collapse: collapse;
        width: 600px;
        height: 75px;
    }

    .Tab2 {
        border-collapse: collapse;
        width: 270px;
        height: 270px;
    }

    .Tab5 {
        border-collapse: collapse;
        width: 410px;
        height: 120px;
    }

    .Tab_td {
        border: solid 1px #DDDDDD
    }
    </style>
    <script language="javascript">
        function deleteFile(delId) {
            toolsFrm.action = "deleteTools?delId=" + delId + "";
            toolsFrm.submit();
        }
    </script>
</head>

<body>
<form name="toolsFrm" method="POST">
    <div class="x_daohang"><span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>> 工具管理</div>
    <table width="99%" border="0" cellspacing="0" cellpadding="0" style="margin: 10px 0 10px 10px;">
        <tr>
            <td><table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
                <tr>
                    <td><div class="message">${flash.message}</div>
                        <table align="center" cellspacing="0" class="Tab">
                            <tr>
                                <td height="25" class="Tab_td">

                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td width="4%">&nbsp;<img src="${resource(dir: 'images/skin', file: 'statistics.gif')}"></td>
                                            <td width="79%"><B><FONT COLOR="1B3D6A">工具列表</FONT></B></td>
                                            <td width="4%">&nbsp;<a href="create"><img
                                                    src="${resource(dir: 'images/skin', file: 'CTools_red.gif')}" border="0"></a></td>
                                            <td width="13%"><B><FONT COLOR="ff9933"><a
                                                    href="${createLink(controller: 'appMgr', action: 'createTools')}">添加工具</a>
                                            </FONT></B></td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                            <tr>
                                <td valign="top" class="Tab_td"><table width="100%" border="1" cellpadding="0"
                                                                       cellspacing="0" bordercolor="#FFFFFF"
                                                                       class="table_1">
                                    <tr bgcolor="#EAF4FC">
                                        <td width="42%" height="25" align="center">&nbsp;&nbsp;<b>工具名称</b></td>
                                        <td width="17%" align="center"><b>上传者</b></td>
                                        <td width="17%" align="center"><b>上传时间</b></td>
                                        <td width="10%" align="center"><b>删除</b></td>
                                    </tr>
                                    <g:each in="${toolsList}" status="i" var="tools">
                                        <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#EAF4FC'}" align="center">
                                            <td align="left" height="23" title="">&nbsp;${tools.name}</td>
                                            <td>${tools.consumer}</td>
                                            <td>&nbsp;
                                                <g:formatDate format="yyyy-MM-dd" date="${tools.dateCreated}"/></td>
                                            <td width="10%" align="center"><b><a href="#"
                                                                                 onClick="deleteFile(${tools.id})"><img
                                                        src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0"></a></b></td>
                                        </tr>
                                    </g:each>
                                </table></td>
                            </tr>
                        </table></td>
                </tr>
            </table></td>
        </tr>

    </table>
</form>
</body>

</html>