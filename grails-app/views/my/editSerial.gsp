<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-27
  Time: 下午7:11
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>编辑文件</title>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'boful/userspace/bfUploadMySerialPoster.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/css', file: 'editSerial.css')}">
    <r:require modules="swfupload,jquery-ui,string,jquery-cookie"/>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/css', file: 'my_userspace_index.css')}">
</head>

<body>
<div class="space_width">
    <div class="boful_edit_rea">
        <g:form action="saveSerial">
            <input type="hidden" name="id" id="serialId" value="${serial.id}">
            <table class="table" style="width: 700px;">
                <tr>
                    <th style="width: 80px;">名称</th>
                    <td><input class="form-control" type="text" value="${serial.name}" name="name"></td>
                    <td></td>
                </tr>
                <tr>
                    <th style="width: 80px;">描述</th>
                    <td><textarea class="form-control" rows="3" name="desc">${CTools.htmlToBlank(serial.description)}</textarea></Td>
                    <td></Td>
                </tr>
                <tr>
                    <th style="width: 80px;">序号</th>
                    <td><input class="form-control" type="text" value="${serial.serialNo}" name="serialNum">
                    </td>
                    <td></td>
                </tr>
                %{--<tr>
                    <th style="width: 90px;">海报截图：</th>
                    <td>
                        <a class="btn btn-default" style="margin-bottom: 20px;"
                           href="${posterLinkNew(serial: serial, size: '200x200')}" target="_blank">查看</a>
                        <a class="btn btn-default" id="replacePoster">替换</a></td>
                </tr>--}%
                <tr>
                    <td colspan="3">
                        <input type="submit" class="btn btn-primary" value="保存" style="margin-left:48%;">

                    </td>
                </tr>
            </table>
        </g:form>
    </div>
</div>
</body>
</html>