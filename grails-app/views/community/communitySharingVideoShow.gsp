<%@ page import="nts.user.domain.Consumer; java.text.SimpleDateFormat; com.boful.common.file.utils.FileType; nts.utils.CTools" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<r:require modules="jwplayer"/>
<head>
    <title>视频共享</title>
    <r:require modules="raty,jquery-ui"></r:require>
    <meta name="layout" content="index">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_share_show.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'audio_index_play.css')}">

    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_group.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index_tab.css')}">
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/community', file: 'communityGroupIndex.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>


    <script type="text/javascript" src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper_handlers.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofulFlexpaper.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/swfobject', file: 'swfobject.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'bofulswfobject.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/community', file: 'communitySharingShow.js')}"></script>
    <style type="text/css">
    .doc_style {
        width: 948px;
        height: 900px;
    }
    </style>
</head>

<body>
<input type="hidden" id="userDownload" value="${Consumer.findByName(session?.consumer.name)?.canDownload}"/>

<div id="sharingDialog">
    <div class="group_dialog_title" id="specialTitle"></div>

    <div class="group_dialog_list" id="specialTab"></div>
</div>
<input type="hidden" id="fileHash" value="${userFile?.fileHash}">
<input type="hidden" id="filePath" value="${userFile?.filePath}">
<input type="hidden" id="studyCommunityId" value="${studyCommunity?.id}"/>

<div class="share_show_content">
<div class="share_show_body wrap">
    <div class="share_show_content_left">
        <!----------------导航-------------->
        <div class="share_show_content_left_tit">
            <div class="commubity_share_nav" style="padding: 0">
                <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: studyCommunity?.id])}">社区首页</a>%{--<span>/</span>
                    <a href="${createLink(controller: 'community', action: 'communityShareList', params: [communityId: studyCommunity?.id])}">共享资源</a>--}%
            </div>

            <div class="commubity_share_files_title">
                <a class="community_share_images_name"
                   href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id: userFile?.id, sharingId: sharing?.id, isFlag: 1])}">${userFile?.name}</a>
                <g:if test="${sharing?.canDownload && ((Consumer.findByName(session?.consumer.name)?.canDownload) || userFile?.consumer.name == session?.consumer.name)}">
                    <a class="community_share_images_download"
                       onclick="downloadUserFile2(${userFile?.id}, '${userFileCanDownload(shareRange: sharing?.shareRange, forumBoardId: sharing?.forumBoard?.id)}')">下载</a>
                </g:if>
            </div>
        </div>
        %{--<div class="share_show_title">
            <p class="share_show_class"></p>

            <p class="share_show_name">${CTools.cutString(sharing?.description, 20)}</p>
        </div>--}%

        <div class="share_show_window">
            <div class="see_show_window">
                <div id="boful_video_player"></div>
            </div>
        </div>

        <div class="share_show_infor">
            <div>
                <p class="see_number">浏览：<span>${userFile?.viewNum}次</span></p>

                <p class="see_download">下载：<span>${userFile?.downloadNum}次</span></p>

                %{-- <p class="see_share">分享：<span>12656次</span></p>--}%
            </div>
        </div>
    </div>

    %{-- <div class="share_show_content_right">
         <div class="ou_share_upload">
             <a href="javascript:void(0);" onclick="checkAuthority(1, ${studyCommunity?.id}, null, null, null)">上传共享</a>
         </div>

         <div class="ou_share_upload_line"></div>
         --}%%{--    <div class="share_show_hot">
                 <div class="posent_infor">
                     <img src="${generalUserPhotoUrl(consumer: sharing?.shareConsumer)}" width="28" height="28"
                          onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                 </div>

                 <div class="posent_infor_other">
                     <h1>${sharing?.name}</h1>

                     <p>下载：<span>${sharing?.download}次</span></p>
                 </div>
             </div>--}%%{--

         <div class="share_rank">
             <h1>热门分享</h1>

             <div class="rank_list">
                 <g:each in="${sharings}" var="shar">
                     <p><a href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id: shar?.id, communityId: studyCommunity?.id])}">${CTools.cutString(shar?.description, 20)}</a>
                     </p>
                 </g:each>
             </div>
         </div>
     </div>--}%
</div>

<div class="community_share_other_files ">
    <div class="community_share_other_files_left">
        <div class="com_share_other_tab">
            <span class="com_chose_meau" id="sharingContent">${specialFile != null ? '专辑简介' : '文件简介'}</span><em>
            <g:if test="${specialFile != null}">
                |</em><span id="sharingList">专辑列表</span><g:if
                    test="${Consumer.findByName(session?.consumer.name)?.canComment}"><em>
                    |</em><span id="sharingArtial">讨论</span></g:if></g:if>
        </div>

        <div class="com_share_other_infor">
            <!-------------专辑简介---------->
            <div class="com_files_introduction" id="sharingContentDiv">
                <p>${CTools.cutString(CTools.htmlToBlank(sharing?.description), 50)}</p>
            </div>
        <!-------------专辑列表---------->
            <g:if test="${specialFile != null}">
                <div class="com_files_list" style="display: none" id="sharingListDiv">
                    <g:each in="${sharing?.special?.files}" var="specialFile">
                        <p>
                            <g:if test="${FileType.isVideo(specialFile?.userFile?.filePath) || (specialFile?.userFile?.filePath.endsWith("swf")) || (specialFile?.userFile?.filePath.endsWith("SWF"))}">
                                <em style="background-image: url('${resource(dir: "skin/blue/pc/front/images", file: "course_sup_videos.png")}')"></em>
                            </g:if>
                            <g:elseif test="${FileType.isImage(specialFile?.userFile?.filePath)}">
                                <em style="background-image: url('${resource(dir: "skin/blue/pc/front/images", file: "course_sup_image.png")}')"></em>
                            </g:elseif>
                            <g:elseif
                                    test="${FileType.isDocument(specialFile?.userFile?.filePath) || (specialFile?.userFile?.filePath.endsWith("pdf")) || (specialFile?.userFile?.filePath.endsWith("PDF"))}">
                                <em style="background-image: url('${resource(dir: "skin/blue/pc/front/images", file: "course_sup_word.png")}')"></em>
                            </g:elseif>
                            <g:elseif test="${FileType.isAudio(specialFile?.userFile?.filePath)}">
                                <em style="background-image: url('${resource(dir: "skin/blue/pc/front/images", file: "course_sup_voice.png")}')"></em>
                            </g:elseif>
                            <g:else>
                                <em style="background-image: url('${resource(dir: "skin/blue/pc/front/images", file: "course_sup_other.png")}')"></em>
                            </g:else>
                            <g:if test="${(FileType.isVideo(specialFile?.userFile?.filePath)) || (FileType.isAudio(specialFile?.userFile?.filePath)) || (FileType.isImage(specialFile?.userFile?.filePath)) || (FileType.isDocument(specialFile?.userFile?.filePath)) || (specialFile?.userFile?.filePath.endsWith("pdf")) || (specialFile?.userFile?.filePath.endsWith("PDF")) || (specialFile?.userFile?.filePath.endsWith("SWF")) || (specialFile?.userFile?.filePath.endsWith("swf"))}">
                                <a title="${specialFile?.userFile?.name}"
                                   href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id: specialFile?.userFile?.id, sharingId: sharing?.id])}">${CTools.cutString(specialFile?.userFile?.name, 20)}</a>
                            </g:if>
                            <g:else>
                                <a onclick="downloadUserFile(${specialFile?.userFile?.id}, '${Consumer.findByName(session?.consumer.name)?.canDownload}')"
                                   title="${specialFile?.userFile?.name}">${CTools.cutString(specialFile?.userFile?.name, 20)}</a>
                            </g:else>
                            <span>${new SimpleDateFormat('yyyy-MM-dd').format(specialFile?.userFile?.createdDate)}</span>
                        </p>
                    </g:each>
                </div>
            </g:if>
        <!-------------讨论---------->
            <g:if test="${specialFile != null}">
                <div class="com_files_talk" style="display: none" id="sharingArtialDiv">
                    <input type="hidden" id="fileId" value="${userFile?.id}"/>

                    <div class="audio_album_talk">

                        <div class="album_talk_inp_box">
                            <div class="album_talk_inp"><label><textarea id="remarkContent"></textarea></label></div>

                            <div class="album_talk_inp_but">
                                <div class="album_talk_inp_star">
                                    <p style="float: left">评价:</p>

                                    <div id="rankScore"></div>
                                </div>

                                <div class="album_talk_inp_sum">
                                    <label><input type="button" value="评价" id="remarkSaveBtn"></label>
                                </div>
                            </div>
                        </div>

                        <div class="album_talk_content">
                            <div class="album_talk_item" id="remarkDiv">
                                <g:each in="${specialFile?.remarks}" var="remark">
                                    <div class="album_talk_item_pom"><img
                                            src="${generalUserPhotoUrl(consumer: remark?.consumer)}"/></div>

                                    <div class="album_talk_item_infor">
                                        <div class="album_talk_item_des">
                                            <p class="album_talk_user"><span class="tl_user"><a
                                                    href="#">${remark?.consumer?.name}</a>
                                            </span><span
                                                    class="tl_time">${new SimpleDateFormat('yyyy-MM-dd').format(remark?.createdDate)}</span>
                                            </p>

                                            <p class="album_user_back">${remark?.remarkContent}</p>
                                        </div>

                                        <div id="reply_${remark?.id}">
                                            <g:each in="${remark?.comments}" var="reply">
                                                <div class="album_talk_back_items">
                                                    <p class="album_talk_user"><span class="tl_user"><a
                                                            href="#">${reply?.consumer?.name}</a>
                                                    </span><span
                                                            class="tl_time">${new SimpleDateFormat('yyyy-MM-dd').format(reply?.createdDate)}</span>
                                                    </p>

                                                    <p class="album_user_back">${reply?.commentContent}</p>
                                                </div>
                                            </g:each>
                                        </div>


                                        <p class="aum_back_word"><span
                                                onclick="replyShow(${remark?.id})">回&nbsp;复</span></p>

                                        <div class="album_talk_back" id="replyShowDiv_${remark?.id}"
                                             style="display: none">
                                            <div class="album_talk_back_inp"><label><textarea
                                                    id="replyContent_${remark?.id}"></textarea></label></div>

                                            <div class="album_talk_back_but"><label><input class="" type="button"
                                                                                           value="评价"
                                                                                           onclick="replySave(${remark?.id})">
                                            </label>
                                            </div>
                                        </div>
                                    </div>
                                </g:each>

                            </div>
                        </div>

                    </div>

                </div>
            </g:if>

        </div>
    </div>

    <div class="community_share_other_files_right">
        <div class="community_share_hot_box">
            <h1>热门分享</h1>

            <div class="community_share_hot_files">
                <g:each in="${hotSharings}" var="sharing" status="sta">
                    <p><em class="${sta <= 2 ? 'share_hot_files' : 'share_other_files'}">${sta + 1}</em>
                        <g:if test="${sharing?.userFile != null}">
                            <g:if test="${(FileType.isVideo(sharing?.userFile?.filePath)) || (FileType.isAudio(sharing?.userFile?.filePath)) || (FileType.isImage(sharing?.userFile?.filePath)) || (FileType.isDocument(sharing?.userFile?.filePath)) || (sharing?.userFile?.filePath.endsWith("pdf")) || (sharing?.userFile?.filePath.endsWith("PDF")) || (sharing?.userFile?.filePath.endsWith("SWF")) || (sharing?.userFile?.filePath.endsWith("swf"))}">
                                <a href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id: sharing?.userFile?.id, sharingId: sharing?.id, isFlag: 1])}"
                                   title="${sharing?.userFile?.name}">${CTools.cutString(sharing?.userFile?.name, 15)}</a>
                            </g:if>
                            <g:else>
                                <a onclick="downloadUserFile(${sharing?.userFile?.id}, '${Consumer.findByName(session?.consumer.name)?.canDownload}')"
                                   title="${sharing?.userFile?.name}">${CTools.cutString(sharing?.userFile?.name, 20)}</a>
                            </g:else>

                        </g:if>
                        <g:else>
                            <a onclick="showAlbum(${sharing?.id});"
                               title="${sharing?.special?.name}">${CTools.cutString(sharing?.special?.name, 15)}</a>
                        </g:else>
                        <span>${new SimpleDateFormat('yyyy-MM-dd').format(sharing?.createdDate)}</span></p>
                </g:each>
            </div>
        </div>

        %{--<div class="community_share_recommend_box">
            <h1>推荐分享</h1>

            <div class="community_share_hot_files">
                <p><em class="share_hot_files">1</em><a href="#">社会现代化发展使消费者更趋于</a><span>2014-08-09</span></p>

                <p><em class="share_hot_files">2</em><a href="#">社会现代化发展使消费者更趋于</a><span>2014-08-09</span></p>

                <p><em class="share_hot_files">3</em><a href="#">社会现代化发展使消费者更趋于</a><span>2014-08-09</span></p>

                <p><em class="share_other_files">4</em><a href="#">社会现代化发展使消费者更趋于</a><span>2014-08-09</span></p>

                <p><em class="share_other_files">5</em><a href="#">社会现代化发展使消费者更趋于</a><span>2014-08-09</span></p>

                <p><em class="share_other_files">6</em><a href="#">社会现代化发展使消费者更趋于</a><span>2014-08-09</span></p>

                <p><em class="share_other_files">7</em><a href="#">社会现代化发展使消费者更趋于</a><span>2014-08-09</span></p>
            </div>
        </div>--}%
    </div>
</div>
</div>
<script type="text/javascript" language="JavaScript">
    function checkAuthority(type, communityId, sharingId, fileHash, fileType) {
        $.ajax({
            url: baseUrl + 'community/checkAuthority',
            data: "type=" + type + "&communityId=" + communityId,
            success: function (data) {
                if (data == 'true') {
                    if (type == 1) {
                        window.location.href = baseUrl + 'community/createSharing?communityId=' + communityId;
                    }
                    else {
                        window.location.href = baseUrl + 'community/downloadSharing?communityId=' + communityId + "&id=" + sharingId + '&fileHash=' + fileHash + '&fileType=' + fileType;
                    }
                }
                else {
                    if (type == 1) {
                        alert('对不起，您没有权限上传共享！');
                    }
                    else {
                        alert('对不起，您没有权限下载共享！');
                    }
                }
            }
        })

    }
</script>
</body>
</html>
