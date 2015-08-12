<%@ page import="com.boful.common.file.utils.FileType; nts.program.domain.Serial; nts.utils.CTools; nts.program.domain.Program" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>二级资源列表</title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <r:require modules="swfupload,jquery-ui,zTree,string,jquery-cookie"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_editProgram.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/editSerialList.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_coursesytyle.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_userspace_index.css')}">
    <script>
        $(function(){
            var videoSevr = $.cookie("uploadServerAddress");
            var videoPort = $.cookie("uploadServerPort");
            var uploadServerRootUrl = "http://" + videoSevr + ":" + videoPort + "/bmc2";
            var uploadUrl = "http://" + videoSevr + ":" + videoPort + "/bmc2/api/upload";
            var filePath = "${uploadPath}";
            var otherOption = "${program.otherOption}";
            if(otherOption=='6'){
                var mediaType = 6;
                params = {filePath: filePath, mediaType: mediaType};
            } else {
                params = {filePath: filePath};
            }
            initMyUpload(uploadServerRootUrl, uploadUrl, params);
        })
    </script>
</head>

<body>

<div class="table-responsive" style="background: #FFF">
    <input type="hidden" id="uploadPath" value="${uploadPath}"/>
    <inpu type="hidden" id="otherOption" value="${program?.otherOption}"/>
    <input type="hidden" id="role" value="${session?.consumer?.role}">
    <table class="table table-striped" id="serialTab">

        <thead>
        <tr>
            <td width="70">文件序号</td>
            <td>名称</td>
            <td>hash</td>
            <td>转码状态</td>
            <td width="100">文件类型</td>
            <td width="160">操作</td>
        </tr>
        </thead>
        <g:each in="${serialList}" var="serail">
            <tr id="serial_${serail.id}">
                <td>${serail.serialNo}</td>
                <td align="left">${serail.name}</td>
                <td>${serail?.fileHash}</td>
                <td><g:if test="${serail?.state == Serial.CODED_STATE}">已转码</g:if>
                <g:elseif test="${serail?.state == Serial.CODING_STATE}">正在转码</g:elseif>
                <g:elseif test="${serail?.state == Serial.NO_CODE_STATE}">未转码</g:elseif>
                <g:elseif test="${serail?.state == Serial.NO_NEED_STATE}">无需转码</g:elseif>
                <g:elseif test="${serail?.state == Serial.CODED_FAILED_STATE}">转码失败</g:elseif>
                </td>
                <td><g:if test="${FileType.isVideo(serail?.filePath)}">视频</g:if>
                <g:elseif test="${FileType.isImage(serail?.filePath)}">图片</g:elseif>
                <g:elseif
                        test="${FileType.isDocument(serail?.filePath) || serail?.filePath.endsWith('pdf') || serail?.filePath.endsWith('pdf'.toUpperCase())}">文档</g:elseif>
                <g:elseif test="${FileType.isAudio(serail?.filePath)}">音频</g:elseif>
                <g:elseif test="${serail?.filePath.endsWith('swf') || serail?.filePath.endsWith('swf'.toUpperCase())}">flash动画</g:elseif>
                <g:elseif
                        test="${serail?.filePath.endsWith('zip') || serail?.filePath.endsWith('zip'.toUpperCase()) || serail?.filePath.endsWith('rar') || serail?.filePath.endsWith('rar'.toUpperCase())}">压缩包</g:elseif>
                <g:else>未知</g:else>
                </td>
                <td>
                    <a class="btn btn-default btn-xs"
                       href="${createLink(controller: 'programMgr', action: 'editSubtitleList', params: [id: serail?.id])}">字幕列表</a>
                    <a class="btn btn-default btn-xs"
                       href="${createLink(controller: 'programMgr', action: 'editSerial', params: [id: serail.id])}">编辑</a>
                    <span class="btn btn-default btn-xs"
                          onclick="removeSerial('${createLink(controller: 'programMgr', action: 'removeSerial')}', ${serail.id}, ${serail?.program?.id}, 'serial_${serail.id}')">删除</span>
                </td>
            </tr>
        </g:each>

    </table>
    <div  id="spaceSizeDiv" class="but-contuniu" style="display:none;">
        <strong>个人空间大小：<span id="showMaxSize"></span>&nbsp;&nbsp;&nbsp;&nbsp;已经使用空间：<span id="showUseSize"></span></strong>
    </div>
    <div class="but-contuniu">
        <input class="btn btn-default" type="button" value="继续上传" id="bfUploadFileBtn"/>
    </div>
    %{--<table>
        <tr>
            <td></td>
            <td style="width: 100px;"><input class="btn btn-default" type="button" value="继续上传" id="bfUploadFileBtn"/>
            </td>
        </tr>
    </table>--}%
</div>

<table class="table" style="margin-bottom: 0px;">
    <tbody>

    <tr>
        <td width="5"></td>
        <td align="left" style="line-height: 30px;">上传文件个数：<span id="fileCountShow">0</span></td>
    </tr>
    </tbody>
</table>


<g:form name="editSerialListForm" controller="programMgr" action="saveSerialList" onsubmit="return checkBtn()">
    <input type="hidden" name="programId" id="programId" value="${program.id}">
    <input type="hidden" value="0" class="form-control" name="fileCount" id="fileCount">
    <input id="maxSpaceSize" value="${session?.consumer.maxSpaceSize}" type="hidden"/>
    <input id="useSpaceSize" name="useSpaceSize" value="${session?.consumer.useSpaceSize}" type="hidden"/>
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

</body>
</html>
