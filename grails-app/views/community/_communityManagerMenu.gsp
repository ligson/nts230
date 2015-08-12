<ul>
<li id="m1" class='${session.communityManagerMenuId==1?"on":""}'><a href="${createLink(controller: 'community', action: 'showInfo' )}">基本信息</a></li>
<li id="m2" class='${session.communityManagerMenuId==2?"on":""}'><a href="${createLink(controller: 'community', action: 'listMember', params: [toPage: 'memberManager'])}">成员管理</a></li>
<li id="m3" class='${session.communityManagerMenuId==3?"on":""}'><a href="${createLink(controller: 'notice', action: 'list', params: [toPage: 'noticeManager'])}">公告管理</a></li>
<li id="m4" class='${session.communityManagerMenuId==4?"on":""}'><a href="${createLink(controller: 'forumBoard', action: 'list', params: [toPage: 'forumBoardManager'])}">讨论区管理</a></li>
<li id="m5" class='${session.communityManagerMenuId==5?"on":""}'><a href="${createLink(controller: 'sharing', action: 'list', params: [toPage: 'sharingManager'])}">共享管理</a></li>
<li id="m6" class='${session.communityManagerMenuId==6?"on":""}'><a href="${createLink(controller: 'activity', action: 'list', params: [toPage: 'activityManager'])}">活动管理</a></li>
</ul>