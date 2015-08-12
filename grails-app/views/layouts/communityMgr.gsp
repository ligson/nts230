<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 13-12-19
  Time: 下午8:06
--%>

<%@ page import="nts.user.domain.Consumer; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title><g:layoutTitle/>-<g:message code="application.name" default="邦丰资源管理平台"/></title>
    <g:include view="layouts/indexCommonResources.gsp"/>
    %{--<link rel="stylesheet" type="text/css"  href="${resource(dir: 'skin/blue/pc/front/css', file: 'communityMgr_index.css')}">--}%
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_communityMgrhover.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_userspace_index.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'space_community_mgr.css')}">
    %{--<link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_layout.css')}">--}%
    %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'hader_page.css')}"> --}%
    <script type="text/javascript">
        $(document).ready(function () {
            var num = $.cookie("example");
            //alert(num);
            $("#accordion").accordion({
                active: Number(num)
            });
            $.cookie("example", null)
        });
        function setCookie(num) {
            $.cookie("example", num);
        }
    </script>
    <g:layoutHead/>
</head>

<body>
<g:include view="layouts/indexHeader.gsp"/>
<!------主体--------->
<div class="userspace_content wrap5">

    <div class="userspace_left">
        <div class="userspace_left_mgr">
            <h1>${message(code: 'my.community.name')}${message(code: 'my.manage.name')}</h1>
        </div>

        <div id="accordion">
            <g:if test="${(type == 'community') && (Consumer.findByName(session.consumer)?.uploadState == 1)}">
                <h3><span
                        class="accordion_form"></span>${message(code: 'my.group.name')}${message(code: 'my.manage.name')}
                </h3>

                <div>

                    <p onclick="setCookie('0')"><a
                            href="${createLink(controller: 'CommunityMgr', action: 'forumBoradList', params: [studyCommunityId: studyCommunity?.id])}">${message(code: 'my.group.name')}${message(code: 'my.list.name')}</a>
                    </p>

                    <p onclick="setCookie('0')"><a
                            href="${createLink(controller: 'CommunityMgr', action: 'forumBoradCreate', params: [studyCommunityId: studyCommunity?.id])}">${message(code: 'my.creat.name')}${message(code: 'my.group.name')}</a>
                    </p>

                </div>
            </g:if>
            <g:if test="${(type == 'community') || (type == 'board')}">
            <h3><span
                    class="accordion_masage"></span>${message(code: 'my.topic.name')}${message(code: 'my.manage.name')}
            </h3>

            <div>
                <p onclick="setCookie('1')"><a class=""
                                               href="${createLink(controller: 'CommunityMgr', action: 'forumMainArticleList', params: [studyCommunityId: studyCommunity?.id])}">${message(code: 'my.topic.name')}${message(code: 'my.list.name')}</a>
                </p>
            </div>
            </g:if>
            <g:if test="${type == 'community'}">
                <h3><span
                        class="accordion_voc"></span>${message(code: 'my.notice.name')}${message(code: 'my.manage.name')}
                </h3>

                <div>
                    <p onclick="setCookie('2')"><a class=""
                                                   href="${createLink(controller: 'CommunityMgr', action: 'noticeList', params: [studyCommunityId: studyCommunity?.id])}">${message(code: 'my.notice.name')}${message(code: 'my.list.name')}</a>
                    </p>

                    <p onclick="setCookie('2')"><a class=""
                                                   href="${createLink(controller: 'CommunityMgr', action: 'noticeCreate', params: [studyCommunityId: studyCommunity?.id])}">${message(code: 'my.creat.name')}${message(code: 'my.notice.name')}</a>
                    </p>
                </div>
            </g:if>

            <g:if test="${(type == 'community') || (type == 'board')}">
            <h3><span class="accordion_mem"></span>${message(code: 'my.members.name')}${message(code: 'my.manage.name')}
            </h3>

            <div>
                <p onclick="setCookie('3')"><a class=""
                                               href="${createLink(controller: 'CommunityMgr', action: 'membersList', params: [studyCommunityId: studyCommunity?.id])}">${message(code: 'my.members.name')}${message(code: 'my.list.name')}</a>
                </p>
            </div>
            </g:if>
            <g:if test="${(type == 'community') || (type == 'board')}">
                <h3><span
                        class="accordion_share"></span>${message(code: 'my.share.name')}${message(code: 'my.manage.name')}
                </h3>

                <div>
                    <p onclick="setCookie('4')"><a class=""
                                                   href="${createLink(controller: 'CommunityMgr', action: 'sharingList', params: [studyCommunityId: studyCommunity?.id])}">${message(code: 'my.share.name')}${message(code: 'my.list.name')}</a>
                    </p>
                </div>
                <g:if test="${(type == 'community')}">
                <h3><span
                        class="accordion_act"></span>${message(code: 'my.activities.name')}${message(code: 'my.manage.name')}
                </h3>

                <div>
                    <p onclick="setCookie('5')"><a class=""
                                                   href="${createLink(controller: 'CommunityMgr', action: 'activityList', params: [studyCommunityId: studyCommunity?.id])}">${message(code: 'my.activities.name')}${message(code: 'my.list.name')}</a>
                    </p>

                        <p onclick="setCookie('5')"><a class=""
                                                       href="${createLink(controller: 'CommunityMgr', action: 'activityCreate', params: [studyCommunityId: studyCommunity?.id])}">${message(code: 'my.creat.name')}${message(code: 'my.activities.name')}</a>
                        </p>
                </div>
                </g:if>
            </g:if>
        </div>
    </div>

    <div class="userspace_right">
        <div class="userspace_communitymgr_title">
            <div class="userspace_communitymgr_img">
                <a href="#"><img src="${generalCommunityPhotoUrl(community: studyCommunity)}"/></a>
            </div>

            <div class="userspace_communitymgr_infor">
                <h1>${CTools.cutString(studyCommunity?.name, 10)}</h1>

                <p class="userspace_communitymgr_des">${CTools.cutString(CTools.htmlToBlank(studyCommunity?.description), 50)}</p>

                <p class="userspace_communitymgr_introdution">
                    <span>成员：<em>${readStudyCommunityMembersCount(studyCommunity: studyCommunity)}</em></span>
                    <span>小组：<em>${studyCommunity?.forumBoards?.size()}</em></span>
                    <span>活动：<em>${studyCommunity?.activitys?.size()}</em></span>
                </p>
            </div>

            <div class="userspace_communitymgr_back">
                <a href="${createLink(controller: 'my', action: 'myCreatedCommunity')}"
                   class="btn btn-success btn-sm">返回社区列表</a>
            </div>
            %{--<g:if test="${forumBoard?.id}">
                <a href="">当前位置：修改板块</a>
            </g:if>
            <g:else>
                <a href="">当前位置：创建板块</a>
            </g:else>--}%
        </div>

        <div class="user_communitymgr_box">
            <g:layoutBody/>
        </div>
    </div>
</div>
<g:include view="layouts/indexFooter.gsp"/>

</body>
</html>