<%@ page import="java.text.SimpleDateFormat; nts.utils.CTools" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>小组首页</title>
    <meta name="layout" content="index">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_group_list.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'hader_page.css')}">

</head>

<body>
%{--${flash.message}--}%
<div class="commubity_share_title">
    <div class="wrap">
        <div class="commubity_share_nav">
            <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: studyCommunity?.id])}">社区首页</a><span>/</span>
            <a href="javascript:void(0)">主题讨论</a>
        </div>

        <div class="share_upload">
            <a class="admin_default_but_green"
               href="${createLink(controller: 'community', action: 'communityActivityCreat', params: [communityId: studyCommunity?.id])}">创建讨论</a>
        </div>
    </div>
</div>

<div class="community_see_grouplist_items wrap">
    <div class="community_see_grouplist">
        <g:each in="${activityList}" var="activity">
            <div class="community_see_grouplist_item">
                <div class="ouknow_forum_icon">
                    <img src="${resource(dir: 'upload/communityImg/activity', file: activity.photo)}" width="100"
                         height="100"
                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                </div>

                <div class="ouknow_forum_plate_cont">
                    <h2>${CTools.cutString(activity?.name, 8)}</h2>

                    <div class="ouknow_forum_plate_cont_des">${CTools.cutString(CTools.htmlToBlank(activity?.description), 20)}</div>

                    <div class="ouknow_forum_plate_bot">
                        <div class="ouknow_forum_plate_post">创建者：<span>${activity?.createConsumer?.name}</span></div>

                        <div class="ouknow_forum_plate_post_back"><span>
                            <g:if test="${new SimpleDateFormat("yyyy-MM-dd").parse(activity.endTime) > new Date()}">
                                <a href="${createLink(controller: 'community', action: 'communityActivityShow', params: [id: activity?.id])}">点击进入</a></g:if>
                        </span></div>
                    </div>
                </div>
            </div>
        </g:each>
    </div>

    <div class="page"><g:guiPaginate controller="community" action="communityActivityIndex" total="${total}"/></div>
</div>
</body>
</html>