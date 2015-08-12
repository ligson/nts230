<html>
<head>
    <title>无标题文档</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link href="${createLinkTo(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" rel="stylesheet"
          type="text/css">
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

            createForm.action = "toolsSave";
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
<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>
<g:hasErrors bean="${tools}">
    <div class="errors">
        <g:renderErrors bean="${tools}" as="list"/>
    </div>
</g:hasErrors>
<form name="createForm" method="POST" enctype="multipart/form-data">
    <div>
        <p style="height: 25px; margin-top: 10px; font-size: 16px; padding-left: 10px">添加工具</p>
        <table class="table">
            <tr>
                <td width="110" align="center">工具名称：</td>
                <td><input class="form-control" name="name" maxLength="50" type="text" id="name" size="50"/></td>
            </tr>
            <tr>
                <td align="center">选择文件：</td>
                <td><input name="filePath" id="file" type="file" size="50"></td>
            </tr>
            <tr>
                <td align="center">&nbsp;</td>
                <td>
                    <input class="btn btn-primary btn-sm" type="button" value="保存" onClick="createSub()"/>&nbsp;
                    <input class="btn btn-primary btn-sm" type="button" value="返回" onClick="history.go(-1)"/>
                </td>
            </tr>
        </table>
    </div>
</form>
</body>
</html>