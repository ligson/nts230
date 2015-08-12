<%@ page import="nts.program.domain.Serial" %>
<html>
<head>
    <title>Edit Program</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
    <SCRIPT LANGUAGE="JavaScript">
        <!--
        function showLoading() {
            var divObj = document.getElementById("loadingDiv");
            divObj.style.display = "block";
        }

        function hiddenMsg() {
            var divObj = document.getElementById("msgDiv");
            if (divObj) divObj.style.display = "none";
        }

        function check() {
            if (form1.directoryId.value == 0) {
                alert("请选择类库。");
                form1.directoryId.focus();
                return (false);
            }

            var extName = getExtName(Jtrim(form1.file1.value)).toLowerCase();
            if (extName != "xls" && extName != "xlsx") {
                alert("请选择Excel文件。");
                form1.file1.focus();
                return (false);
            }

            if (!confirm("确定excel文件，类库都选择正确吗?")) {
                return false;
            }

            hiddenMsg();
            showLoading();
            return true;
        }

        function getExtName(fileName) {
            var extName = "";
            if (fileName == null || fileName == "") return "";
            var nPos = fileName.lastIndexOf(".");
            if (nPos > 0) {
                extName = fileName.substr(nPos + 1);
            }

            return extName;
        }
        //-->
    </SCRIPT>

</head>

<body>

<div class="tbsearch">
    <h1>从Excel文件中导入资源</h1>

    <form name="form1" action="excelToDatabase" method="post" onsubmit="return check();" enctype="multipart/form-data">

        <table class="table">
            <tr>
                <td width="120px" align="right"></td>
                <td>
                </td>
            </tr>

            <tr>
                <td align="right">Excel文件：</td>
                <td>
                    <label>
                        <input type="file" name="file1" value="">
                    </label>
                </td>
            </tr>

            <tr>
                <td align="right">导入到库：</td>
                <td><label class="col-xs-2">
                    <g:select from="${directoryList}" class="form-control " name="directoryId"
                              value="${program?.directory?.id}" optionKey="id" optionValue="name"></g:select>
                </label>

                </td>
            </tr>
            <tr>
                <td align="right">资源类型:</td>
                <td>
                    <label class="col-xs-2">
                        <g:select from="${Serial.urlTypeName}" class="form-control" name="urlType" value=""
                                  optionKey="key" optionValue="value"></g:select>
                    </label>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <label><input class="admin_default_but_blue" type="submit" value="开始导入"/></label>
                    <label><input class="admin_default_but_blue" type="button" onclick="form1.reset();" value="重设"/>
                    </label></td>
            </tr>

        </table>
    </form>

    <div style="display:none;position: absolute; top: 150px; left: 200px; font-size:12px;" id="loadingDiv"><img
            src="${resource(dir: 'images/skin', file: 'loading.gif')}">正在导入，请稍候......</div>
    <g:if test="${flash.message}">
        <div class="message" id="msgDiv"
             style="position: absolute; top: 220px; left: 200px; font-size:12px;">${flash.message}</div>
    </g:if>
</div>
</body>
</html>
