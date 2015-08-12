<%@ page import="com.boful.common.file.utils.FileType; nts.front.community.controllers.CommunityController; nts.commity.domain.Notice; nts.commity.domain.ForumReplyArticle; nts.commity.domain.ForumBoard; nts.commity.domain.ForumMainArticle; nts.commity.domain.Activity; java.text.SimpleDateFormat; nts.commity.domain.Sharing; nts.utils.CTools; nts.user.domain.Consumer" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'communityIndex.css')}">
    <meta name="layout" content="index">
    <r:require modules="jquery-ui"/>
    <title>社区首页</title>
</head>

<body>
<div class="communityMain_content">
    <div class="wrap" style="margin-top:-40px;">
        <div class="commubity_share_nav " style=" padding-top: 0;">
            <a href="${createLink(controller: 'community', action: 'Index')}">社区首页</a><span>/</span>
            <a href="javascript:void(0)">${CTools.cutString(studyCommunity?.name, 8)}</a>
        </div>
    </div>

    <div class="communityMain_content_bnanar wrap">

        <div class="communityMain_content_bnanar_left">
            <img src="${generalCommunityPhotoUrl(community: studyCommunity)}" width="600" height="290"/>
        </div>

        <div class="communityMain_content_bnanar_right">
            <div class="communityMain_top">
                <div class="communityMain_top_lf">
                    <a href="${createLink(controller: 'community', action: 'communityActivityIndex', params: [studyCommunityId: studyCommunity?.id])}">
                        <div class="communityMain_bom_rh_icon">
                            主题讨论
                        </div>
                    </a>
                </div>
                <a href="${createLink(controller: 'community', action: 'communityGroupList', params: [isCheck: "true", communityId: studyCommunity?.id])}">
                    <div class="communityMain_top_rh">
                        <div class="communityMain_bom_min_icon">
                            社区小组
                        </div>
                    </div></a>
            </div>

            <div class="communityMain_bom">
                <a href="${createLink(controller: 'community', action: 'communityShareList', params: [communityId: studyCommunity?.id])}">
                    <div class="communityMain_seach_icon_see">
                        发现资源
                    </div></a>

                <div class="communityMain_bom_rh">
                    <a href="${createLink(controller: 'community', action: 'communityGroupList', params: [isCheck: "false", communityId: studyCommunity?.id])}">
                        <div class="communityMain_bom_rh_icon_see">
                            发现小组
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
%{--<g:if test="${session?.consumer?.id==studyCommunity?.create_comsumer_id}">
<h3><a href="${createLink(controller:'CommunityMgr',action:'forumBoradList',params:[studyCommunityId:studyCommunity?.id])}">社区管理</a></h3>
</g:if>--}%
<g:if test="${notice?.description != null}">
    <div class="post_massage wrap">

        <h1><span class="post_massage_tit_icon"></span></h1>

        <div class="post_massage_one">
            <p>
                ${CTools.htmlToBlank(notice?.description)}
            </p>
        </div>
    </div></g:if>

<div class="communityMain_content_other wrap">
    <div class="communityMain_content_other_left">
        <div class="communityMain_left_tits">
            <h1 class="communityMain_left_tit">社区动态</h1>
        </div>

        <div class="communityMain_left_items">
            <g:each in="${sharings}" var="sharing" status="ss">
                <div class="communityMain_left_item">
                    <div class="communityMain_user">
                        <a href="${createLink(controller: 'my', action: 'userSpace', params: [id: sharing?.shareConsumer?.id])}">
                            <div class="communityMain_user_img">
                                <img src="${generalUserPhotoUrl(consumer: sharing?.shareConsumer)}" width="28"
                                     height="28"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                            </div></a>

                        <p class="communityMain_user_infor">
                            <a href="${createLink(controller: 'my', action: 'userSpace', params: [id: sharing?.shareConsumer?.id])}">
                                <span class="communityMain_user_infor_name">${sharing.shareConsumer?.name}</span></a>
                            <span class="communityMain_user_infor_class">上传了：</span>
                            <a class="communityMain_uplosd_name"
                               href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id: sharing?.id, communityId: studyCommunity?.id])}">${CTools.cutString(sharing?.name, 10)}</a>
                        </p>

                        <div class="communityMain_uplosd_con">${CTools.htmlToBlank(sharing.description)}</div>
                    </div>

                    <div class="communityMain_upload_resourse">
                        <a href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id: sharing?.id, communityId: studyCommunity?.id])}">
                            <g:if test="${FileType.isImage(sharing?.fileType)}">
                                <img src="${playSharingLink(sharing: sharing)}" width="267" height="141"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                            </g:if>
                            <g:else>
                                <img src="${posterLinkNew(fileHash: sharing?.fileHash)}" width="267" height="141"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                            </g:else>
                        </a>
                    </div>

                    <div class="communityMain_upload_time">
                        <p>
                            <span class="upload_res_timer">${new SimpleDateFormat('yyyy-MM-dd').format(sharing?.dateCreated)}</span>
                            %{--<span class="upload_res_save">收&nbsp;藏</span>--}%
                        </p>
                    </div>
                </div>
            </g:each>
        <!----------帖子---------------->
            <g:each in="${articls}" var="article" status="ss">
                <div class="communityMain_left_item">
                    <div class="communityMain_user">
                        <div class="communityMain_user_img">
                            <a href="${createLink(controller: 'my', action: 'userSpace', params: [id: article?.createConsumer?.id])}">
                                <img src="${generalUserPhotoUrl(consumer: article?.createConsumer)}" width="28"
                                     height="28"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                            </a>
                        </div>

                        <p class="communityMain_user_infor">
                            <a href="${createLink(controller: 'my', action: 'userSpace', params: [id: article?.createConsumer?.id])}">
                                <span class="communityMain_user_infor_name">${article?.createConsumer?.name}</span></a>
                            <span class="communityMain_user_infor_class">发布了帖子：</span>
                            <a href="${createLink(action: 'communityArticle', controller: 'community', params: [id: article?.id, communityId: studyCommunity?.id])}">${CTools.cutString(article?.name, 10)}</a>
                        </p>

                    </div>

                    <div class="communityMain_upload_time">
                        <div class="communityMain_uplosd_con">${CTools.cutString(CTools.htmlToBlank(article?.description), 100)}</div>

                        <p>
                            <span class="upload_res_timer">${new SimpleDateFormat('yyyy-MM-dd').format(article?.dateCreated)}</span>
                            %{--<span class="upload_res_save">收&nbsp;藏</span>--}%
                        </p>
                    </div>
                </div>
            </g:each>
            <g:each in="${activitys}" var="activity" status="ss">
                <div class="communityMain_left_item">
                    <div class="communityMain_user">
                        <div class="communityMain_user_img">
                            <a href="${createLink(controller: 'my', action: 'userSpace', params: [id: activity?.createConsumer?.id])}">
                                <img src="${generalUserPhotoUrl(consumer: activity?.createConsumer)}" width="28"
                                     height="28"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                            </a>
                        </div>

                        <p class="communityMain_user_infor">
                            <a href="${createLink(controller: 'my', action: 'userSpace', params: [id: activity?.createConsumer?.id])}">
                                <span class="communityMain_user_infor_name">${activity?.createConsumer?.name}</span></a>
                            <span class="communityMain_user_infor_class">发布活动：</span>
                            <a href="${createLink(action: 'communityActivityShow', controller: 'community', params: [id: activity?.id, communityId: studyCommunity?.id])}">${CTools.cutString(activity?.name, 10)}</a>
                        </p>

                        <div class="communityMain_uplosd_con">${CTools.htmlToBlank(activity.description)}</div>
                    </div>

                    <div class="communityMain_upload_resourse">
                        <a title="${activity?.name}"
                           href="${createLink(controller: 'community', action: 'communityActivityShow', params: [id: activity.id, communityId: studyCommunity?.id])}">
                            <img src="${resource(dir: 'upload/communityImg/activity', file: activity.photo)}"
                                 width="267"
                                 height="141"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                        </a>
                    </div>

                    <div class="communityMain_upload_time">
                        <p>
                            <span class="upload_res_timer">${new SimpleDateFormat('yyyy-MM-dd').format(activity?.dateCreated)}</span>
                            %{--<span class="upload_res_save">收&nbsp;藏</span>--}%
                        </p>
                    </div>
                </div>
            </g:each>
        </div>
    </div>

    <!----------右测-------->
    <div class="communityMain_content_other_right">
        <div class="communityMain_post_hot">
            <h1 class="community_post_hot_title">热帖排行</h1>

            <div class="community_post_hot_title_cont">
                <g:each in="${remenArticleList}" var="article" status="ss">
                    <g:if test="${ss < 3}">
                        <p><span class="hot_r">${ss + 1}</span><a
                                href="${createLink(controller: 'community', action: 'communityArticle', params: [id: article?.id, communityId: studyCommunity?.id])}">${CTools.cutString(article?.name, 10)}</a>
                        </p>
                    </g:if>
                    <g:if test="${ss >= 3}">
                        <p><span>${ss + 1}</span><a
                                href="${createLink(controller: 'community', action: 'communityArticle', params: [id: article?.id, communityId: studyCommunity?.id])}">${CTools.cutString(article?.name, 10)}</a>
                        </p>
                    </g:if>
                </g:each>
            </div>
        </div>

        <div class="communityMain_activity_hot">
            <h1 class="community_post_hot_title">热门活动</h1>

            <div class="communityMain_activity_lists">
                <g:each in="${remenActivityList}" var="activity">
                    <div class="communityMain_activity_list">
                        <a href="${createLink(action: 'communityActivityShow', controller: 'community', params: [id: activity?.id, communityId: studyCommunity?.id])}">
                            <div class="communityMain_activity_list_img">
                                <img src="${resource(dir: 'upload/communityImg/activity', file: activity.photo)}"
                                     width="267"
                                     height="141"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                            </div></a>

                        <div class="communityMain_activity_list_infor">
                            <p class="communityMain_activity_ins">
                                <a href="${createLink(action: 'communityActivityShow', controller: 'community', params: [id: activity?.id, communityId: studyCommunity?.id])}">
                                    ${CTools.cutString(activity?.name, 10)}</a>
                            </p>

                            <p class="communityMain_activity_jion"><a
                                    href="${createLink(action: 'communityActivityShow', controller: 'community', params: [id: activity?.id, communityId: studyCommunity?.id])}">立即参加</a>
                            </p>
                        </div>
                    </div>
                </g:each>
            </div>
        </div>
    </div>
</div>

<div id="createArticleDialog" style="display:none;">
    <g:form controller="community" action="save" name="createArticleForm" enctype="multipart/form-data"
            onsubmit="return checkStudy();">
        <div class="ui-dialog-content ui-widget-content">
            <table>
                <tr>
                    <td>标题:</td>
                    <td><input type="text" id="name" name="name"></td>
                </tr>
                <tr>
                    <td>缩略图:</td>
                    <td><input type="file" name="Img"></td>
                </tr>
                <tr>
                    <td>简介:</td>
                    <td><textarea name="description" id="description" cols="30" rows="5"></textarea></td>
                </tr>
            </table>

        </div>
    </g:form>
</div>
<script type="text/javascript">
    $(function () {

        $("#createArticleDialog").dialog({title: "创建社区", autoOpen: false, width: 600, height: 380, buttons: {
            "提交": function () {
                $("#createArticleForm").submit();

            },
            "取消": function () {
                $("#createArticleDialog").dialog("close");
            }
        }});

        $("#saveArticle").click(function () {
            $("#createArticleDialog").dialog("open");
        })


    })

    function checkStudy() {
        var name = $("#name").val();
        var description = $("#description").val();
        if (name == "") {
            alert("请输入社区名称!");
            return false;
        }
        if (description == "") {
            alert("请对社区进行简单描述!");
            return false;
        }
    }
</script>
</body>
</html><%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 14-5-27
  Time: 下午2:21
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
</head>

<body>

</body>
</html>