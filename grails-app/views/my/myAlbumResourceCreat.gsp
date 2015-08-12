<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/6/4
  Time: 17:09
--%>

<%@ page import="com.boful.common.file.utils.FileType; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.creat.name')}${message(code: 'my.album.name')}</title>
    <r:require modules="jwplayer,zTree"></r:require>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'myAlbumResourceCreat.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'communiuty_share_list.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper_handlers.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofulFlexpaper.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/swfobject', file: 'swfobject.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'bofulswfobject.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/special', file: 'userSpecialTree.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/special', file: 'userSpecial.js')}"></script>
    <style type="text/css">
    .boful_toolbar{
        z-index: 100;
    }
    </style>
</head>

<body>
<div class="row" style="width: 760px ; height: 20px; float: right">
    <div id="topDiv"><a>${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.creat.name')}${message(code: 'my.album.name')} ></a><span
            name="app"></span></div>
</div>

<div class="myAlbumResourceCreat">
    <h1 class="creat_tit">${message(code: 'my.creat.name')}${message(code: 'my.album.name')}</h1>
    <table class="table" id="createBtn">
        <tbody>
        <tr>
            <td width="100" align="center"><span
                    style="color: red">*</span>${message(code: 'my.album.name')}${message(code: 'my.designation.name')}：
            </td>
            <td><input type="text" class="form-control" name="specialName"/><input type="hidden" id="idList"
                                                                                   name="idList" value="${idList}"/>
            </td>
        </tr>
        <tr>
            <td width="100" align="center"><span
                    style="color: red">*</span>${message(code: 'my.album.name')}${message(code: 'my.tally.name')}：</td>
            <td><input type="text" class="form-control" name="specialTag"/>(多标签用空格区分)</td>
        </tr>
        <tr>
            <td width="100" align="center"><span
                    style="color: red">*</span>${message(code: 'my.album.name')}${message(code: 'my.introduction.name')}：
            </td>
            <td><textarea class="form-control" name="specialDes"></textarea></td>
        </tr>
        <tr>
            <td colspan="2" align="right"><input class="btn btn-success btn-sm" type="button" onclick="createSpecial()"
                                                 value="创建专辑"/></td>
        </tr>
        </tbody>
    </table>
</div>

<div class="myAlbum_chose_list">
    <h1 class="creat_tit">${message(code: 'my.album.name')}${message(code: 'my.files.name')}%{--<a class="btn btn-success btn-sm" onclick="choseNew()" style="float: right">继续添加</a>--}%</h1>
    <table class="table table-hover">
        <tbody>
        <tr>
            <th width="80" align="center">${message(code: 'my.media.name')}${message(code: 'my.type.name')}</th>
            <th align="center">${message(code: 'my.files.name')}${message(code: 'my.designation.name')}</th>
            <th width="100" align="center">${message(code: 'my.files.name')}${message(code: 'my.size.name')}</th>
          %{--  <th width="100" align="center">${message(code: 'my.browse.name')}${message(code: 'my.amount.name')}</th>--}%
            <th width="120" align="center">${message(code: 'my.upload.name')}${message(code: 'my.time.name')}</th>
            <th width="80" align="center">${message(code: 'my.files.name')}${message(code: 'my.operation.name')}</th>
        </tr>
        <g:each in="${userFileList}" var="userFile">
            <tr>
                <td align="center">
                    <g:if test="${FileType.isVideo(userFile?.name)}">
                        <span class="tab_math_icon"></span>
                    </g:if>
                    <g:elseif test="${FileType.isImage(userFile?.name)}">
                        <span class="tab_math_image_icon"></span>
                    </g:elseif>
                    <g:elseif test="${FileType.isDocument(userFile?.name) || userFile?.name.endsWith("pdf") || userFile?.name.endsWith("PDF")}">
                        <span class="tab_math_doc_icon"></span>
                    </g:elseif>
                    <g:elseif test="${FileType.isAudio(userFile?.name)}">
                        <span class="tab_math_audio_icon"></span>
                    </g:elseif>
                    <g:elseif test="${userFile?.name.endsWith("swf") || userFile?.name.endsWith("SWF")}">
                        <span class="tab_math_icon"></span>
                    </g:elseif>
                    <g:else>
                        <span class="tab_math_other_icon"></span>
                    </g:else>
                </td>
                <td>
                    <a onclick="playPreview(${userFile?.id}, '${userFile?.name}', '${userFile?.filePath}', '${userFile?.fileHash}')" title="${userFile?.name}">${CTools.cutString(userFile?.name, 10)}</a>
                </td>
                <td>${convertHumanUnit(fileSize: userFile?.fileSize)}</td>
                %{--<td>456次</td>--}%
                <td>${userFile?.createdDate}</td>
                <td><label><input type="button" class="btn btn-warning btn-sm" onclick="removeFile(${userFile?.id})"
                                  value="删除"></label></td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<div id="treeDialog" title="选择文件">
    <div class="dia_box">
        <div class="dia_aibum_left">

            <div id="zTree" class="ztree"></div>
        </div>

        <div class="dia_aibum_right" id="fileDiv">
            <g:each in="${userFileList}" var="userFile">
                <div><a onclick="addSpecial(${userFile?.id})">${userFile?.name}</a></div>
            </g:each>
        </div>
    </div>
</div>
<div id="playViewDialog"></div>
</body>
</html>