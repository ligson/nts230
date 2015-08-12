<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'toolsList.css')}">
    <title>工具管理</title>
    <script type="text/javascript">
        function deleteFile(delId) {
            toolsFrm.action = "toolsDelete?delId=" + delId + "";
            toolsFrm.submit();
        }
    </script>
</head>

<body>
<form name="toolsFrm" method="POST">
    <div style="margin: 10px 0 10px 10px;">
        <div class="message">${flash.message}</div>

        <div class="tools_message">
            <p><span style="font-size: 16px">工具列表</span><a class="btn btn-warning btn-sm"
                                                           style="color: #FFF; float: right; margin-right: 20px"
                                                           href="${createLink(controller: 'coreMgr', action: 'toolsCreate')}">+添加工具</a>
            </p>


            <table width="100%" class="table table-hover">
                <tr>
                    <td align="r">&nbsp;&nbsp;<b>工具名称</b></td>
                    <td width="200" align="center"><b>上传者</b></td>
                    <td width="200" align="center"><b>上传时间</b></td>
                    <td width="200" align="center"><b>删除</b></td>
                </tr>
                <g:each in="${toolsList}" status="i" var="tools">
                    <tr align="center">
                        <td align="left" height="23" title="">&nbsp;${tools.name}</td>
                        <td>${tools.consumer}</td>
                        <td>&nbsp;
                            <g:formatDate format="yyyy-MM-dd"
                                          date="${tools.dateCreated}"/></td>
                        <td width="10%" align="center"><b><a href="#" onclick="deleteFile(${tools.id})"><img
                                    src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0"></a></b>
                        </td>
                            </tr>
                </g:each>
            </table></td>
        </div>
    </div>
</form>
</body>

</html>