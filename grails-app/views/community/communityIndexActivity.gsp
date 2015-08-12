<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/6/16
  Time: 10:36
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.community.name')}${message(code: "my.activity.name")}</title>
    <meta name="layout" content="communityIndexLayout">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index_tab.css')}">
</head>

<body>
<div class="c_index_tab">
    <g:each in="${activityList}" var="activity">
        <div class="c_index_form">
            <div class="c_index_a_img"><a
                    href="javascript:void(0);" onclick="checkTimeout(${activity?.id}, ${studyCommunity?.id})"><img
                        src="${resource(dir: 'upload/communityImg/activity', file: activity.photo)}"
                        onerror="this.src='${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
            </a></div>

            <div class="c_index_a_in">

                <h1>
                    <span class="c_in_ing">${userActivityState(startDate: activity.startTime, endDate: activity.endTime)}</span>
                    <a href="javascript:void(0);"
                       onclick="checkTimeout(${activity?.id}, ${studyCommunity?.id})">${CTools.cutString(activity?.name, 20)}</a>
                </h1>

                <p class="c_index_a_des">${CTools.htmlToBlank(activity?.description)}</p>

                <p class="c_index_a_time">${message(code: 'my.time.name')}:&nbsp;&nbsp;<span>${activity?.startTime}</span>-<span>${activity?.endTime}</span><a
                        class=" c_a_j" href="javascript:void(0);"
                        onclick="checkTimeout(${activity?.id}, ${studyCommunity?.id})">${message(code: 'my.attend.name')}${message(code: 'my.talk.name')}</a>
                </p>
            </div>
        </div>
    </g:each>
    <div class="f_page">
        <g:guiPaginate controller="community" action="communityIndexActivity" total="${total}" params="${params}"
                       max="20"/>
    </div>
</div>
<script type="text/javascript" language="JavaScript">
    function checkTimeout(activityId, communityId) {
        $.ajax({
            url: baseUrl + 'community/checkTimeout',
            data: "id=" + activityId,
            success: function (data) {
                if (data == 'true') {
                    location.href = baseUrl + "community/communityActivityShow?id=" + activityId + "&communityId=" + communityId;
                }
                else {
                    alert("对不起，该活动已过期！");
                }
            }
        })

    }
</script>
</body>
</html>