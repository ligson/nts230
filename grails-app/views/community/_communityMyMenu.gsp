<ul>
<li id="m1" class='${session.communityMyMenuId==1?"on":""}'><a href="${createLink(controller: 'forumArticle', action: 'list', params: [toPage: 'myForumMainArticle', myId: session.consumer.id])}">我发布的贴子</a></li>
<li id="m2" class='${session.communityMyMenuId==2?"on":""}'><a href="${createLink(controller: 'sharing', action: 'list', params: [toPage: 'sharingManager', sharingType: 'my'])}">我上传的共享</a></li>
<li id="m3" class='${session.communityMyMenuId==3?"on":""}'><a href="${createLink(controller: 'activity', action: 'list', params: [toPage: 'myActivity', activityType: 'my'])}">我发起的活动</a></li>
<li id="m4" class='${session.communityMyMenuId==4?"on":""}'><a href="${createLink(controller: 'recommendedProgram', action: 'list', params: [toPage: 'myRecommendedProgram', myId: session.consumer.id])}">我推荐过的资源</a></li>
</ul>