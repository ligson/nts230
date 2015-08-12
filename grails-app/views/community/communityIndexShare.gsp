<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/6/16
  Time: 10:35
--%>
<%@ page import="nts.user.domain.Consumer; com.boful.common.file.utils.FileType; nts.commity.domain.ForumMember;java.text.SimpleDateFormat; nts.utils.CTools" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.community.name')}${message(code: 'my.group.name')}</title>
    <r:require modules="jquery-ui"></r:require>
    <meta name="layout" content="communityIndexLayout">
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_group.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index_tab.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/boful/community',file: 'communityGroupIndex.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common',file: 'fileType.js')}"></script>
</head>

<body>
<input type="hidden" id="userDownload" value="${Consumer.findByName(session?.consumer?.name)?.canDownload}"/>
<div id="sharingDialog">
    <div class="group_dialog_title" id="specialTitle"></div>
    <div class="group_dialog_list" id="specialTab"></div>
</div>
<div class="c_index_tab">

    <table width="100%" class="c_tab" border=" 0" cellpadding="0" cellspacing="0">
        <tbody>
        <g:each in="${sharingList}" var="sharing">
            <tr>
                <td width="30" align="center" class="c_i">
                    <g:if test="${sharing?.userFile!=null}">
                        <g:if test="${FileType.isVideo(sharing?.userFile?.filePath)||(sharing?.userFile?.filePath.endsWith("SWF"))||(sharing?.userFile?.filePath.endsWith("swf"))}">
                            <a href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id:sharing?.userFile?.id,sharingId:sharing?.id,isFlag:1])}" title="${sharing?.userFile?.name}">
                                <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_videos.png')}"/>
                            </a>
                        </g:if>
                        <g:elseif test="${FileType.isImage(sharing?.userFile?.filePath)}">
                            <a href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id:sharing?.userFile?.id,sharingId:sharing?.id,isFlag:1])}" title="${sharing?.userFile?.name}">
                                <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_image.png')}"/>
                            </a>
                        </g:elseif>
                        <g:elseif test="${FileType.isDocument(sharing?.userFile?.filePath) || sharing?.userFile?.filePath.endsWith("pdf") || sharing?.userFile?.filePath.endsWith("PDF")}">
                            <a href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id:sharing?.userFile?.id,sharingId:sharing?.id,isFlag:1])}" title="${sharing?.userFile?.name}">
                            <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_word.png')}"/>
                            </a>
                        </g:elseif>
                        <g:elseif test="${FileType.isAudio(sharing?.userFile?.filePath)}">
                            <a href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id:sharing?.userFile?.id,sharingId:sharing?.id,isFlag:1])}" title="${sharing?.userFile?.name}">
                            <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_voice.png')}"/>
                            </a>
                        </g:elseif>
                        <g:else>
                            <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_other.png')}"/>
                        </g:else>
                    </g:if>
                    <g:else>
                        <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'share_class_files_icon.png')}"/>
                    </g:else>
                </td>
                <g:if test="${sharing?.userFile!=null}">
                    <g:if test="${(FileType.isVideo(sharing?.userFile?.filePath))||(FileType.isAudio(sharing?.userFile?.filePath))||(FileType.isImage(sharing?.userFile?.filePath))||(FileType.isDocument(sharing?.userFile?.filePath)) || sharing?.userFile?.filePath.endsWith("pdf") || sharing?.userFile?.filePath.endsWith("PDF")||(sharing?.userFile?.filePath.endsWith("SWF"))||(sharing?.userFile?.filePath.endsWith("swf"))}">
                        <td><a class="c_td_a"
                               href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id:sharing?.userFile?.id,sharingId:sharing?.id,isFlag:1])}" title="${sharing?.userFile?.name}">${CTools.cutString(sharing?.userFile?.name, 15)}</a>
                        </td>
                    </g:if>
                    <g:else>
                        <td><a class="c_td_a"
                               onclick="downloadUserFile(${sharing?.userFile?.id},'${Consumer.findByName(session?.consumer?.name)?.canDownload}')" title="${sharing?.userFile?.name}">${CTools.cutString(sharing?.userFile?.name, 15)}</a>
                        </td>
                    </g:else>
                </g:if>
                <g:else>
                    <td><a class="c_td_a" onclick="showAlbum(${sharing?.id});">${CTools.cutString(sharing?.special?.name, 10)}</a>
                    </td>
                </g:else>
                <td width="100" align="center"><a href="#">${sharing?.consumer?.name}</a></td>
                <g:if test="${sharing?.forumBoard!=null}"><td width="100" align="center"><a href="#">${sharing?.forumBoard?.name}</a></td></g:if>
                <td width="100" align="center">${new SimpleDateFormat("yyyy-MM-dd").format(sharing?.createdDate)}</td>
            </tr>
        </g:each>

        </tbody>
    </table>

    <div class="f_page">
        <g:guiPaginate controller="community" action="communityIndexShare" total="${total}" params="${params}"
                       max="20"/>
    </div>
</div>

</body>
</html>