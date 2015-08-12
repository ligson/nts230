<%@ page import="nts.commity.domain.ForumMember; nts.utils.CTools" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>小组首页</title>
    <meta name="layout" content="index">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_group_list.css')}">
    <script type="text/javascript">
        $(document).ready(function () {
            var message = ${flash.message? "'"+flash.message+"'" : "''"};
            if (message != '') {
                alert(message);
            }
        })
    </script>
</head>

<body>
<div class="see_header">
    <div class="wrap">
        <div class="commubity_share_nav">
            <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: studyCommunity?.id])}">社区首页</a><span>/</span>
            <a href="javascript:void(0)">社区小组</a>
        </div>

    </div>
</div>
<div class="community_see_grouplist_items wrap">
    <div class="community_see_s_tit">
        <h1><span class="see_hot_icon"></span>
            <g:if test="${isCheck == "false"}">发现小组</g:if>
            <g:if test="${isCheck == "true"}">社区小组</g:if>
        </h1>
    </div>

    <div class="community_see_grouplist">
    %{--<h2 class="see_hot">
        <g:if test="${isCheck == "true"}">社区小组</g:if>
        <g:if test="${isCheck == "false"}">推荐小组</g:if>
    </h2>--}%
        <g:each in="${boards}" var="board">
            <div class="community_see_grouplist_item">
                <div class="ouknow_forum_icon">
                    <img src="${resource(dir: 'upload/communityImg/forumboard', file: board.photo)}" width="100"
                         height="100"
                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                </div>

                <div class="ouknow_forum_plate_cont">
                    <g:if test="${isCheck == "true"}">
                        <h2><a href="${createLink(controller: 'community', action: 'communityGroupIndex', params: [id: board?.id])}">
                            ${CTools.cutString(board?.name, 8)}</a></h2>
                    </g:if>
                    <g:if test="${isCheck == "false"}">
                        <h2><a href="${createLink(controller: 'community', action: 'communityGroupIndex', params: [id: board?.id])}">
                            ${CTools.cutString(board?.name, 8)}</a></h2>
                    </g:if>

                    <div class="ouknow_forum_plate_cont_des">${CTools.cutString(CTools.htmlToBlank(board?.description), 20)}</div>

                    <div class="ouknow_forum_plate_bot">
                        <div class="ouknow_forum_plate_post">人数：<span>${ForumMember.findAllByForumBoard(board)?.size()}</span>
                        </div>

                        <div class="ouknow_forum_plate_post_back">
                        %{--<g:if test="${isCheck == "false"}">--}%
                                <g:if test="${judgeJoinBoard(consumer: session.consumer, forumBoard: board) == 'true'}">
                                    <p class="other_group_jioned" style="cursor: pointer"><span
                                            class="">√</span>&nbsp;已经加入</p>
                                </g:if>
                                <g:else>
                                    <p><a onclick="addGroup(${board?.id})">+加入小组</a></p>
                                </g:else>
                        %{--</g:if>--}%
                        %{--<span>

                        <a onclick="addGroup(${board?.id})">+申请加入</a>
                    </span>--}%</div>
                    </div>
                </div>
            </div>
        </g:each>
    </div>

</div>
<script type="text/javascript">
    function addGroup(tag) {
        var pars = {id: tag};
        var url = baseUrl + "community/addConsumerAjax";
        $.ajax({
            url: url,
            data: pars,
            success: function (data) {
                alert(data.msg);
                window.location.reload();
            }
        });
    }
</script>
</body>
</html>