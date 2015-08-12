<%@ page import="com.boful.common.file.utils.FileUtils; nts.user.domain.Consumer; com.boful.common.file.utils.FileType; nts.commity.domain.ForumMember; java.text.SimpleDateFormat; nts.utils.CTools" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>${message(code: 'my.group.name')}${message(code: 'my.home.name')}</title>
    <meta name="layout" content="index">
    <r:require modules="jquery-ui"></r:require>
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_group.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index_tab.css')}">
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/community', file: 'communityGroupIndex.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
    <ckeditor:resources/>
</head>

<body>
<!----------------------------------->
<input type="hidden" id="userDownload" value="${Consumer.findByName(session?.consumer.name)?.canDownload}"/>
<g:render template="communitySubHeader" model="${[studyCommunity: board.studyCommunity]}"/>
%{--<div class="wrap">
    <div class="commubity_share_nav">
        <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: board.studyCommunity?.id])}">社区首页</a><span>/</span>
        <a href="${createLink(controller: 'community', action: 'communityGroupList', params: [isCheck: true, communityId: board.studyCommunity?.id])}">社区小组</a><span>/</span>
        <a href="javascript:void(0)">${nts.utils.CTools.cutString(board.name, 8)}</a>
    </div>
</div>--}%
<div id="sharingDialog">
    <div class="group_dialog_title" id="specialTitle"></div>

    <div class="group_dialog_list" id="specialTab"></div>
</div>

<div id="albumDiv" class="com_group_dialog_win">
    <h1 class="com_group_dialog_win_close"><input type="button" value="" onclick="closeAlbum();"></h1>

    <div class="group_dialog_title">
        %{-- <div class="group_dialog_img"><img
                 src="${resource(dir: 'skin/blue/pc/front/images', file: 'audio_album_img.png')}"/></div>

         <div class="group_dialog_infor">
             <h1>专辑名称</h1>

             <p>创建灵感库无非就是把自己欣赏的信息收集起来，一但达到一定的数量，有效的分类管理就很重要了。创建适合自己的分类，
             重点在于习惯用什么角度来分类事物，比如图标：从形状分有，方形图标.</p>
         </div>--}%
    </div>

    <div class="group_dialog_list">
        %{--<table width="100%" class="c_tab" border=" 0" cellpadding="0" cellspacing="0">
            <tbody>
            <tr>
                <td width="30" align="center" class="c_i">
                    <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_videos.png')}"/>
                </td>
                <td><a>分享资源名称</a>
                </td>
                <td width="100" align="center">233213次</td>
                <td width="100" align="center"><a href="#">上传者名称</a></td>
                <td width="100" align="center">2014-05-09</td>
            </tr><tr>
                <td width="30" align="center" class="c_i">
                    <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_videos.png')}"/>
                </td>
                <td><a>分享资源名称</a>
                </td>
                <td width="100" align="center">233213次</td>
                <td width="100" align="center"><a href="#">上传者名称</a></td>
                <td width="100" align="center">2014-05-09</td>
            </tr><tr>
                <td width="30" align="center" class="c_i">
                    <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_videos.png')}"/>
                </td>
                <td><a>分享资源名称</a>
                </td>
                <td width="100" align="center">233213次</td>
                <td width="100" align="center"><a href="#">上传者名称</a></td>
                <td width="100" align="center">2014-05-09</td>
            </tr><tr>
                <td width="30" align="center" class="c_i">
                    <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_videos.png')}"/>
                </td>
                <td><a>分享资源名称</a>
                </td>
                <td width="100" align="center">233213次</td>
                <td width="100" align="center"><a href="#">上传者名称</a></td>
                <td width="100" align="center">2014-05-09</td>
            </tr>
            </tbody>
        </table>--}%
    </div>
</div>

<div class="community_groups_content">
<div class="community_group_content_left">
    <div class="com_g_des">
        <div class="com_g_des_img">
            <img src="${resource(dir: 'upload/communityImg/forumboard', file: board.photo)}"
                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>

            <p>
                <span class="com_n_tit">${board?.name}</span>
                <g:if test="${judgeJoinBoard(consumer: session.consumer, forumBoard: board) == 'true'}">
                    <span class="con_n_j">${message(code: 'my.already.name')}${message(code: 'my.attending.name')}</span>
                </g:if>
                <g:else>
                    <span class="con_n_j"
                          onclick="addGroup(${board?.id})">${message(code: 'my.attending.name')}${message(code: 'my.group.name')}</span>
                </g:else>

            </p>
        </div>

        <div class="com_g_des_in">
            <p class="con_in_time"><span>${message(code: 'my.creat.name')}${message(code: 'my.time.name')}<em>${new SimpleDateFormat("yyyy-MM-dd").format(board?.dateCreated)}</em>
            </span><span>${message(code: 'my.master.name')}:<em>${board?.createConsumer.nickname}</em></span></p>

            <p class="con_inf_des">${CTools.htmlToBlank(board?.description)}</p>
        </div>
    </div>

    <div class="com_g_t">
        <h3><span
                class="com_g_t_line"
                id="articleBtn">${message(code: 'my.hot.name')}${message(code: 'my.topic.name')}</span><span
                id="sharingBtn">${message(code: 'my.sharing.name')}</span>
        </h3>
    </div>

    <div class="com_">
        <!---------热门话题-------->
        <div class="com_topics_list" id="articleDiv">
            <g:if test="${articleList.size() > 0}">
                <g:each in="${articleList}" var="article">
                    <div class="community_activity_proposal">
                        <div class="activity_proposal_items">
                            <div class="activity_proposal_item">
                                <div class="activity_proposal_item_img">
                                    <a href="${createLink(controller: 'my', action: 'userSpace', params: [id: article?.createConsumer?.id])}">
                                        <span class="posts_imgs">
                                            <img title="${article.createConsumer.name}"
                                                 src="${generalUserPhotoUrl(consumer: article?.createConsumer)}"
                                                 width="28" height="28"
                                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                                        </span>
                                        <em class="p_name">${article?.createConsumer.nickname}</em>
                                    </a>
                                </div>

                                <div class="activity_proposal_item_infor">
                                    <h1><g:if
                                            test="${article?.isTop == 1}"><em>${message(code: 'my.top.name')}</em></g:if><a
                                            title="${article?.name}"
                                            href="${createLink(controller: 'community', action: 'communityArticle', params: [id: article?.id])}">${CTools.cutString(article?.name, 40)}</a>
                                    </h1>

                                    <p class="proposal_item_words">
                                        ${article.description}
                                    </p>

                                </div>

                                <div class="c_from_nuim">${article.forumReplyArticle.size()}</div>
                            </div>
                        </div>
                    </div>
                </g:each>
            </g:if>
            <g:else>
                <span>该小组没有发布的话题</span>
            </g:else>
        </div>
        <!---------小组共享-------->
        <div class="com_topics_sharing" id="sharingDiv">
            <g:if test="${sharingList.size() > 0}">
                <table width="100%" class="c_tab" border=" 0" cellpadding="0" cellspacing="0">
                    <tbody>
                    <g:each in="${sharingList}" var="sharing">
                        <tr>
                            <td width="30" align="center" class="c_i">
                                <g:if test="${sharing?.userFile != null}">
                                    <g:if test="${FileType.isVideo(sharing?.userFile?.filePath) || (sharing?.userFile?.filePath.endsWith("SWF")) || (sharing?.userFile?.filePath.endsWith("swf"))}">
                                        <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_videos.png')}"/>
                                    </g:if>
                                    <g:elseif test="${FileType.isImage(sharing?.userFile?.filePath)}">
                                        <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_image.png')}"/>
                                    </g:elseif>
                                    <g:elseif
                                            test="${FileType.isDocument(sharing?.userFile?.filePath) || sharing?.userFile?.filePath.endsWith("pdf") || sharing?.userFile?.filePath.endsWith("PDF")}">
                                        <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_word.png')}"/>
                                    </g:elseif>
                                    <g:elseif test="${FileType.isAudio(sharing?.userFile?.filePath)}">
                                        <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_voice.png')}"/>
                                    </g:elseif>
                                    <g:else>
                                        <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'course_sup_other.png')}"/>
                                    </g:else>
                                </g:if>
                                <g:else>
                                    <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'share_class_files_icon.png')}"/>
                                </g:else>
                            </td>
                            <g:if test="${sharing?.special != null}">
                                <td><a onclick="showAlbum(${sharing?.id});"
                                       title="${sharing?.special?.name}">${CTools.cutString(sharing?.special?.name, 15)}</a>
                                </td>
                            </g:if>
                            <g:else>
                                <g:if test="${(FileType.isVideo(sharing?.userFile?.filePath)) || (FileType.isAudio(sharing?.userFile?.filePath)) || (FileType.isImage(sharing?.userFile?.filePath)) || (FileType.isDocument(sharing?.userFile?.filePath)) || sharing?.userFile?.filePath.endsWith("pdf") || sharing?.userFile?.filePath.endsWith("PDF") || (sharing?.userFile?.filePath.endsWith("SWF")) || (sharing?.userFile?.filePath.endsWith("swf"))}">
                                    <td><a href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id: sharing?.userFile?.id, sharingId: sharing?.id, isFlag: 1])}"
                                           title="${sharing?.userFile?.name}">${CTools.cutString(sharing?.userFile?.name, 15)}</a>
                                    </td>
                                </g:if>
                                <g:else>
                                    <td><a onclick="downloadUserFile(${sharing?.userFile?.id}, '${Consumer.findByName(session?.consumer.name)?.canDownload}')"
                                           title="${sharing?.userFile?.name}">${CTools.cutString(sharing?.userFile?.name, 15)}</a>
                                    </td>
                                </g:else>
                            </g:else>

                            <td width="100" align="center"><a href="#">${sharing?.consumer?.name}</a></td>
                            <td width="100"
                                align="center">${new SimpleDateFormat('yyyy-MM-dd').format(sharing?.createdDate)}</td>
                        </tr>
                    </g:each>

                    </tbody>
                </table>
                <g:paginate total="${sharingTotal}" action="communityGroupIndex" controller="community"
                            params="[id: board?.id]"></g:paginate>
            </g:if>
            <g:else>
                <span>该小组没有共享</span>
            </g:else>
        </div>
    </div>

    <div class="com_creat_ac">
        <h1 class="com_c_ac"><span>${message(code: 'my.send.name')}${message(code: 'my.topic.name')}</span></h1>
        <g:form controller="community" action="saveArticle" onsubmit="return checkValue()">
            <div class="community_group_release_box">
                <span style="color: red;">${flash.message}</span>

                <div class="user_release_box">
                    <div class="release_boxs_names">
                        <p>话题标题:</p>

                        <div class="user_release_tits">
                            <label class="user_release_tit">
                                <input type="hidden" value="${board.studyCommunity?.id}" name="studyId">
                                <input type="hidden" value="${board?.id}" name="forumBoardId">
                                <input type="text" name="name" id="name" value="输入话题标题">
                            </label>
                        </div>

                        %{--<p>还可输入100字</p>--}%
                    </div>

                    <div>
                        <ckeditor:config var="toolbar_bar01">
                            [
                                %{--['Source'],--}%
                                ['Bold','Italic','Underline','Strike'],
                                ['Format'],
                                ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
                                ['Link','Unlink','Anchor'],
                                ['Image','Flash','Table','Smiley','PageBreak']
                            ]
                        </ckeditor:config>
                        <ckeditor:editor name="description" id="description" height="400px" width="100%"
                                         toolbar="bar01">
                        </ckeditor:editor>
                    </div>
                    %{-- <label>
                         <textarea name="description" id="description">输入话题内容</textarea>
                     </label>--}%
                    <label>
                        <input class="user_release_but" type="submit" value="发布话题">
                    </label>
                </div>
            </div>
        </g:form>
    </div>

</div>

<div class="community_group_content_right">
    %{--<div class="jion_group_mine">
        <div class="jion_group_mine_img">
            <img src="${generalUserPhotoUrl(consumer: session.consumer)}" width="28" height="28"
                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
        </div>

        <div class="jion_group_mine_other">
            <h1 class="jion_group_name">${session?.consumer?.name}</h1>

            <div>
                <p>发起：<span>${articleTotal}</span></p>

                <p>回应：<span>${replyTotal}</span></p>
            </div>
        </div>
    </div>--}%

    %{--        <div class="community_group_user_offer">
                <div class="crate_plate">小组信息
                    <div class="community_jined">
                        <g:if test="${session.consumer && session.consumer.id == board.createConsumer.id}">
                            <p class="other_group_jioned" style="cursor: pointer">
                                <a href="${createLink(controller: 'communityMgr', action: 'forumBoradList', params: [studyCommunityId: board.studyCommunity.id])}">小组管理</a>
                            </p>
                        </g:if>
                        <g:else>
                            <g:if test="${judgeJoinBoard(consumer: session.consumer, forumBoard: board) == 'true'}">
                                <p class="other_group_jioned" style="cursor: pointer">
                                    <span class="">√</span>&nbsp;已经加入
                                </p>
                            </g:if>
                            <g:else>
                                <p>
                                    <a onclick="addGroup(${board?.id})">+加入小组</a>
                                </p>
                            </g:else>
                        </g:else>
                    </div>
                </div>

                <div class="community_group_user_offer_items">
                    <table>
                        <tbody>
                        <td class="group_creat_user">所属社区：</td>
                        <td></td>
                        <tr>
                            <td class="group_creat_user">创建人：</td>
                            <td>${board?.createConsumer?.name}</td>
                        </tr>

                        <tr>
                            <td class="group_creat_user">人员：</td>
                            <td>${board?.forumMainArticle?.size()}</td>
                        </tr>
                        <tr>
                            <td class="group_creat_user">小组：</td>
                            <td>${board?.name}</td>
                        </tr>
                        <tr>
                            <td class="group_creat_user">
                                简介：
                            </td>
                            <td class="g_s">
                                <p>${CTools.cutString(board?.description, 20)}

                                </p></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>--}%
    <!------------推荐小组------->
    <div class="community_group_user_plate">
        <h1 class="crate_plate">${message(code: 'my.recommend.name')}${message(code: 'my.group.name')}</h1>

        <g:each in="${boards}" var="board">
            <div class="group_user_item">
                <div class="community_group_user_plate_imgs">
                    <a href="javascript:void(0);"
                       onclick="checkBoard(${board?.id}, ${board.studyCommunity?.id})">
                        <img src="${resource(dir: 'upload/communityImg/forumboard', file: board.photo)}"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                    </a>
                </div>

                <div class="user_plate_infor">
                    <a href="javascript:void(0);"
                       onclick="checkBoard(${board?.id}, ${board.studyCommunity?.id})">
                        <h1>${CTools.cutString(board?.name, 8)}</h1>
                    </a>

                    <p class="user_plate_infor_des"></p>

                    <div class="user_plate_infor_number">
                        <p><span>${ForumMember.findAllByForumBoard(board)?.size()}</span>人</p>
                        <g:if test="${judgeJoinBoard(consumer: session.consumer, forumBoard: board) == 'true'}">
                            <p class="other_group_jioned" style="cursor: pointer"><span
                                    class="">√</span>&nbsp;${message(code: 'my.already.name')}${message(code: 'my.attending.name')}
                            </p>
                        </g:if>
                        <g:else>
                            <p><a onclick="addGroup(${board?.id})">+${message(code: 'my.attending.name')}${message(code: 'my.group.name')}</a>
                            </p>
                        </g:else>

                    </div>
                </div>
            </div>
        </g:each>
    </div>
    <!------------加入的小组------->
    <div class="community_group_user_plate">
        <h1 class="crate_plate">${message(code: 'my.soon.name')}${message(code: 'my.attending.name')}${message(code: 'my.group.name')}</h1>
        <g:each in="${joinBoards}" var="board">
            <div class="group_user_item">
                <div class="community_group_user_plate_imgs">
                    <a href="javascript:void(0);"
                       onclick="checkBoard(${board?.id}, ${board.studyCommunity?.id})">
                        <img src="${resource(dir: 'upload/communityImg/forumboard', file: board.photo)}"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                    </a>
                </div>

                <div class="user_plate_infor">
                    <a href="javascript:void(0);"
                       onclick="checkBoard(${board?.id}, ${board.studyCommunity?.id})">
                        <h1>${CTools.cutString(board?.name, 8)}</h1>
                    </a>

                    <p class="user_plate_infor_des"></p>

                    <div class="user_plate_infor_number">
                        <p><span>${ForumMember.findAllByForumBoard(board)?.size()}</span>人</p>
                        <g:if test="${judgeJoinBoard(consumer: session.consumer, forumBoard: board) == 'true'}">
                            <p class="other_group_jioned" style="cursor: pointer"><span
                                    class="">√</span>&nbsp;${message(code: 'my.already.name')}${message(code: 'my.attending.name')}
                            </p>
                        </g:if>
                        <g:else>
                            <p><a onclick="addGroup(${board?.id})">+${message(code: 'my.attending.name')}${message(code: 'my.group.name')}</a>
                            </p>
                        </g:else>

                    </div>
                </div>
            </div>
        </g:each>
    </div>
</div>
</div>
<script type="text/javascript">
    function checkBoard(boardId, studyCommunityId) {
        var pars = {studyCommunityId: studyCommunityId};
        var url = baseUrl + "community/checkCommunityState";
        $.post(url, pars, function (data) {
            if (data.success) {
                window.location.href = "/community/communityGroupIndex?id=" + boardId;
            } else {
                alert(data.msg);
            }

        });
    }

    function addGroup(tag) {
        var pars = {id: tag};
        var url = baseUrl + "community/addConsumerAjax";
        $.post(url, {id: tag}, function (data) {
            if (data.success) {
                alert(data.msg);
                window.location.reload();
            } else {
                alert(data.msg);
            }

        });
    }

    function checkValue() {
        var flag = ${judgeJoinBoard(consumer: session.consumer, forumBoard: board) == 'true'};
        if (!flag) {
            alert("请先申请加入小组！");
            return false;
        }
        var name = $("#name").val();
        var description = $("#description").val();
        if ((name == "输入话题标题") || (name.trim() == "")) {
            alert("请输入标题");
            return false;
        }
    }
    $(function () {
        $("#name").click(function () {
            if ($("#name").val() == "输入话题标题")$("#name").val("");
        })
    })
</script>
</body>
</html>