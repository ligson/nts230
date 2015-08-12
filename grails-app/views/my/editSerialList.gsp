<%@ page import="nts.utils.CTools; nts.program.domain.Program" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>二级资源列表</title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <r:require modules="swfupload,jquery-ui,zTree,string,jquery-cookie"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_editProgram.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/editSerialList.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_coursesytyle.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_userspace_index.css')}">
</head>

<body>

<div class="table-responsive">

    <table class="table">

        <thead>
        <tr>
            <td width="70">文件序号</td>
            <td>名称</td>
            <td width="110">操作</td>
        </tr>
        </thead>
        <g:each in="${program.serials}" var="serail">
            <tr id="serial_${serail.id}">
                <td>${serail.serialNo}</td>
                <td align="left">${serail.name}</td>

                <td>
                    <a class="btn btn-default btn-xs"
                       href="${createLink(controller: 'my', action: 'editSerial', params: [id: serail.id])}">编辑</a>
                    <span class="btn btn-default btn-xs"
                          onclick="removeSerial('${createLink(controller: 'my', action: 'removeSerial')}', ${serail.id}, 'serial_${serail.id}')">删除</span>
                </td>
            </tr>
        </g:each>
    </table>
    <input type="hidden" name="programId" id="programId" value="${program.id}">
    %{--<table>
        <tr>
            <td style="width: 620px;"></td>
            <td style="width: 100px;"><input class="btn btn-default" type="button" value="继续上传" id="bfUploadFileBtn"/>
            </td>
        </tr>
    </table>--}%
</div>

%{--
<table class="table" style="margin-bottom: 0px;">
    <tbody>

    <tr>
        <td width="5"></td>
        <td align="left" style="line-height: 30px;">上传文件个数：<span id="fileCountShow">0</span></td>
    </tr>
    </tbody>
</table>


<g:form name="editSerialListForm" controller="my" action="saveSerialList">
    <input type="hidden" name="programId" id="programId" value="${program.id}">
    <input type="hidden" value="0" class="form-control" name="fileCount" id="fileCount">
    <table class="table">
        <tbody>
        <tr>
            <td>
                <div class="upload_list">
                </div>
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
                <input class="btn btn-primary btn-sm" type="submit" value="提交"/>
            </td>
        </tr>
        </tbody>
    </table>
</g:form>
--}%
</body>
</html>
