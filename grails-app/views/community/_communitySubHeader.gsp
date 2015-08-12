<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/6/17
  Time: 12:52
--%>

<%@ page import="nts.commity.domain.ForumMember" contentType="text/html;charset=UTF-8" %>
<div class="c_act_box">
    <div class="c_act_con">
        <img src="${generalCommunityPhotoUrl(community: studyCommunity)}"/>

        <div class="c_act_in">
            <h1>${studyCommunity.name}</h1>

            <p>
                <span>创建者：<em>${readStudyCommunityCreater(id: studyCommunity.create_comsumer_id)}</em></span>
                <span>成员：<em>${readStudyCommunityMembersCount(studyCommunity: studyCommunity)}</em></span>
                %{--<span>帖子：<em>${studyCommunity.forumBoards.size()}</em></span>--}%
                <span>小组：<em>${studyCommunity.forumBoards.size()}</em></span>
                <a class="c_a_b"
                   href="${createLink(controller: 'community', action: 'communityIndex', params: [id: studyCommunity.id])}">返回社区首页</a>
            </p>
        </div>
    </div>
    %{--<img  class="c_x_ng" src="${resource(dir: 'skin/blue/pc/front/images',file: 'ou_index_domes3.jpg')}"/>--}%
</div>