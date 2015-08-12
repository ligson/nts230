<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link href="${createLinkTo(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <title>无标题文档</title>
    <style type="text/css">
    .Tab {
        border-collapse: collapse;
        width: 600px;
        height: 270px;
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
    <script language="javaScript">

        function createSub() {
            var size = 0;
            if (createForm.name.value == "") {
                alert("工具名称不可为空");
                createForm.name.focus();
                return false;
            }
            if (createForm.name.value.length > 50) {
                alert("工具名称不大于50字符");
                createForm.name.focus();
                return false;
            }
            if (createForm.filePath.value == "") {
                alert("请选择要上传的软件");
                createForm.filePath.focus();
                return false;
            }

            createForm.action = "saveTools";
            createForm.submit();


        }

        function getFileSize(filePath) {
            var image = new Image();
            var size = 0;
            image.src = document.getElementById("file").value;
            size = (image.fileSize / 1024);
            return size;
        }

        function textImage() {
            var oImg = new Image();
            var imgsize;
            var iFlag;
            iFlag = false;
            oImg.src = document.getElementById("file").value;
            imgsize = (oImg.fileSize / 1024);
            alert(imgsize)

        }

    </script>
</head>

<body>
<div class="x_daohang">
    <p>当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'tools', action: 'list')}">工具管理</a>>> 添加工具</p>
</div>

<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>
<g:hasErrors bean="${tools}">
    <div class="errors">
        <g:renderErrors bean="${tools}" as="list"/>
    </div>
</g:hasErrors>
<form name="createForm" method="POST" enctype="multipart/form-data">
    <table width="95%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td height="61">&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td><table width="700" border="0" align="center" cellspacing="0" cellpadding="0">
                <tr>
                    <td><table height="87" align="center" cellspacing="0" class="Tab1">
                        <tr>
                            <td height="25" colspan="2" class="Tab_td"><table width="100%" border="0" cellpadding="0"
                                                                              cellspacing="0">
                                <tr>
                                    <td width="5%">&nbsp;<img src="${resource(dir: 'images/skin', file: 'CTools_red.gif')}"></td>
                                    <td width="95%"><B><FONT COLOR="1B3D6A">添加工具</FONT></B></td>
                                </tr>
                            </table></td>
                        </tr>
                        <tr>
                            <td width="109" height="24" align="center" class="Tab_td">&nbsp;工具名称：</td>
                            <td width="485" class="Tab_td">&nbsp; <input name="name" maxLength="50" type="text"
                                                                         id="name" size="50"/></td>
                        </tr>
                        <tr>
                            <td class="Tab_td" align="center">&nbsp;选择文件：</td>
                            <td class="Tab_td">&nbsp; <input name="filePath" id="file" type="file" size="50"></td>
                        </tr>
                        <tr>
                            <td class="Tab_td" height="24" align="center">&nbsp;</td>
                            <td class="Tab_td">&nbsp;
                                <input type="button" value="保存" onClick="createSub()"/>&nbsp;
                                <input type="button" value="返回" onClick="history.go(-1)"/>
                            </td>
                        </tr>
                    </table></td>
                </tr>
            </table></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <td height="83"></tr>
    </table>
</form>
</body>
</html>