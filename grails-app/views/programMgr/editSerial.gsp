<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-27
  Time: 下午7:11
--%>

<%@ page import="nts.utils.CTools; nts.program.domain.Serial" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>编辑文件</title>
    <r:require modules="swfupload,jquery-ui,zTree,string,jquery-cookie"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_editProgram.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/fileType.js')}"></script>
    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/bfUploadMy.js')}"></script>--}%
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'boful/programMgr/bfUploadMySerialPoster.js')}"></script>
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
                <tr>
                    <th style="width: 80px;">文件类型</th>
                    <td><select class="admin_default_inp admin_default_inp_size2" name="urlType" style="float: left">
                        <g:each in="${Serial.urlTypeName}" status="i" var="urlType">
                            <option value="${urlType.key}" ${(serial.urlType == urlType.key) ? "selected='selected'" : ""}>${urlType.value}</option>
                        </g:each>
                    </select><span style="font-size: 12px;color: red; float: left ; margin-left: 20px">请谨慎修改！！！</span>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <th style="width: 90px;">海报截图：</th>
                    <td>
                        <a class="btn btn-default" id="viewPhoto"
                           href="${posterLinkNew(serial: serial, size: '200x200')}" target="_blank"
                           style="float: left; margin-right: 15px">查看</a>
                        <a class="btn btn-default" id="replacePoster" style="float: left; ">替换</a></td>
                </tr>
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