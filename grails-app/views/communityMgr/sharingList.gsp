<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-3-15
  Time: 下午5:36
--%>

<%@ page import="com.boful.common.file.utils.FileType; nts.user.domain.Consumer;  java.text.SimpleDateFormat; nts.commity.domain.ForumSharing; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.share.name')}${message(code: 'my.list.name')}</title>
    <r:require modules="jquery-ui"/>
    <script type="text/javascript" src="${resource(dir: 'js/boful/communityMgr',file: 'mySharing.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common',file: 'fileType.js')}"></script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>

</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.share.name')}${message(code: 'my.list.name')}</a>
</div>
<table class="table table-striped" id="sharingTable">
    <thead>
    <tr>
        <th width="60" style="text-align: center">${message(code: 'my.chose.name')}</th>
        <th width="100">${message(code: 'my.share.name')}${message(code: 'my.title.name')}</th>
        <th width="80">${message(code: 'my.share.name')}${message(code: 'my.people.name')}</th>
        <th width="40">${message(code: 'my.download.name')}</th>
        <th width="90">${message(code: 'my.creat.name')}${message(code: 'my.time.name')}</th>
        <th width="60">${message(code: 'my.state.name')}</th>
        <th width="100">${message(code: 'my.operation.name')}</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${sharingList}" var="sharing">
        <tr id="tr${sharing.id}">
            <td><g:checkBox name="sharingId" value="${sharing.id}" checked="false"></g:checkBox></td>
            <g:if test="${sharing?.special != null}">
                <td style="text-align: left"
                    title="${sharing?.special?.name}"><a class="c_td_a" onclick="showAlbum(${sharing?.id});">${CTools.cutString(sharing?.special?.name, 5)}</a></td>
            </g:if>
            <g:else>
                <g:if test="${(FileType.isVideo(sharing?.userFile?.filePath))||(FileType.isAudio(sharing?.userFile?.filePath))||(FileType.isImage(sharing?.userFile?.filePath))||(FileType.isDocument(sharing?.userFile?.filePath))||(sharing?.userFile?.filePath.endsWith("pdf"))||(sharing?.userFile?.filePath.endsWith("PDF"))||(sharing?.userFile?.filePath.endsWith("SWF"))||(sharing?.userFile?.filePath.endsWith("swf"))}">
                    <td style="text-align: left"
                        title="${sharing?.userFile?.name}"><a class="c_td_a" target="_blank"
                           href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id:sharing?.userFile?.id,sharingId:sharing?.id,isFlag:1])}" title="${sharing?.userFile?.name}">${CTools.cutString(sharing?.userFile?.name, 5)}</a>
                    </td>
                </g:if>
                <g:else>
                    <td style="text-align: left"
                        title="${sharing?.userFile?.name}"><a class="c_td_a"
                           onclick="downloadUserFile(${sharing?.userFile?.id},'${Consumer.findByName(session?.consumer?.name)?.canDownload}')" title="${sharing?.userFile?.name}">${CTools.cutString(sharing?.userFile?.name, 5)}</a>
                    </td>
                </g:else>
               %{-- <td style="text-align: left"
                    title="${sharing?.userFile?.name}">${CTools.cutString(sharing?.userFile?.name, 5)}</td>--}%
            </g:else>
            <td>${sharing?.consumer?.name}</td>
            <td>
                <a id="canDownload${sharing.id}"
                   onclick="changeCanDownload(${sharing.id}, ${sharing?.canDownload}, ${studyCommunity?.id})"
                   class="btn btn-success btn-xs">${sharing?.canDownload ? "是" : "否"}</a>
            </td>
            <td>
                ${new SimpleDateFormat("yyyy-MM-dd").format(sharing?.createdDate)}
            </td>
            <td><span id="state_${sharing?.id}">${ForumSharing.stateCnField.get(sharing?.state)}</span></td>
            <td>
                <a onclick="changeSharingState(${sharing.id}, ${studyCommunity.id})"
                   class="btn btn-success btn-xs">审批</a>
                <a onclick="deleteSharing(${sharing.id}, ${studyCommunity?.id})" class="btn btn-warning btn-xs">删除</a>
            </td>
        </tr>
    </g:each>
    <tr>
        <g:if test="${sharingList?.size() >= 2}">
            <td><input class="btn btn-default" value="批量删除" type="button"
                       onclick="deleteSharingList(${studyCommunity.id})"/>
            </td>
        </g:if>
    </tr>
    </tbody>

</table>

<div class="page">
    <g:guiPaginate controller="communityMgr" action="sharingList" total="${total}"
                   params="${[studyCommunityId: studyCommunity?.id]}"/></div>

<div id="sharingDialog">
    <div class="group_dialog_title" id="specialTitle"></div>
    <div class="group_dialog_list" id="specialTab"></div>
</div>
</body>
</html>