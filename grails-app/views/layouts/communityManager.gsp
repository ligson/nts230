<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午4:23
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/资源管理.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
    <link rel="icon" type="image/x-icon" href="${resource(dir: 'skin/blue/pc/images', file: 'boful_logo.ico')}"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'appmgr_left_icons.css')}">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <title><g:layoutTitle/>-<g:message code="application.name" default="邦丰资源管理平台"/></title>
    <g:include view="/layouts/mgrCommonResources.gsp"/>
    <g:layoutHead/>
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0/css', file: 'ui.jqgrid.css')}"/>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0/js/i18n', file: 'grid.locale-cn.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0/js', file: 'jquery.jqGrid.min.js')}"></script>
</head>

<body>

<g:include view="/layouts/mgrHeader.gsp"/>
<!--===主界面社区信息开始===-->

%{--<div class="ou_community_mgr">
    <div class="ou_space_head">
        <div class="ou_space_head_box">
            <div class="ou_space_head_img">
                <img src="${generalCommunityPhotoUrl(community: studyCommunity)}"/>
            </div>

            <div class="ou_space_head_right">
                <div class="ou_s_h_right"><p class="o_s_name">${studyCommunity.name}</p>

                    <p class="ou_s_h_opeart">
                        <span>创建者：<em>${getStudyCommunityCreater(id: studyCommunity.create_comsumer_id)}</em></span>
                        <span>成员：<em>${getStudyCommunityMembersCount(studyCommunity: studyCommunity)}</em></span>
                        --}%%{--<span>帖子：<em>000</em></span>--}%%{--
                        <span>小组：<em>${studyCommunity.forumBoards.size()}</em></span>
                    </p>
                </div>

                <p class="ou_s_h_des">${studyCommunity.description}</p>
            </div>
        </div>
        <img class="ou_spou_space_con_img"
             src="${resource(dir: 'skin/blue/pc/front/images', file: 'community_space_bg.png')}"/>
    </div>
</div>--}%

<!--===主界面社区信息开始===-->
<!--===主界面开始===-->
<div id="sidebar" class="ui-layout-west scrolling-content">
    <div class="sidebar_resource_box">
        <div class="sidebar_title"><img src="${resource(dir: 'skin/blue/pc/admin/images', file: 'tree_form.png')}">
        </div>
        <ul id="menu">
            <g:if test="${checkUserResource(controllerEnName: 'communityManager', actionEnName: 'index') == 'true'}">
                <li><span class="usermgr_prsent"></span><a
                        href="${createLink(controller: 'communityManager', action: 'index')}">社区管理</a></li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'communityManager', actionEnName: 'RMSCategoryManager') == 'true'}">
                <li><span class="appmgr_clas"></span><a
                        href="${createLink(controller: 'communityManager', action: 'RMSCategoryManager')}">社区分类</a></li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'communityManager', actionEnName: 'forumBoardManager') == 'true'}">
                <li><span class="appmgr_talk"></span><a
                        href="${createLink(controller: 'communityManager', action: 'forumBoardManager')}">小组管理</a></li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'communityManager', actionEnName: 'index') == 'true'}">
                <li><span class="appmgr_form"></span><a
                        href="${createLink(controller: 'communityManager', action: 'forumMainArticleManager')}">帖子管理</a>
                </li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'communityManager', actionEnName: 'sharingManager') == 'true'}">
                <li><span class="appmgr_save"></span><a
                        href="${createLink(controller: 'communityManager', action: 'sharingManager')}">共享管理</a></li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'communityManager', actionEnName: 'noticeManager') == 'true'}">
                <li><span class="appmgr_word"></span><a
                        href="${createLink(controller: 'communityManager', action: 'noticeManager')}">公告管理</a></li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'communityManager', actionEnName: 'activityManager') == 'true'}">
                <li><span class="appmgr_activit"></span><a
                        href="${createLink(controller: 'communityManager', action: 'activityManager')}">社区活动</a></li>
            </g:if>
            <g:if test="${(checkUserResource(controllerEnName: 'communityManager', actionEnName: 'communityAdmin') == 'true') || (checkUserResource(controllerEnName: 'communityManager', actionEnName: 'forumBoardAdmin') == 'true') || (checkUserResource(controllerEnName: 'communityManager', actionEnName: 'communityConsumer') == 'true')}">
                <li><span class="usermgr_users"></span><a>社区用户</a>
                    <ul>
                        <g:if test="${checkUserResource(controllerEnName: 'communityManager', actionEnName: 'communityAdmin') == 'true'}">
                            <li><a href="${createLink(controller: 'communityManager', action: 'communityAdmin')}">社区管理员</a>
                            </li>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'communityManager', actionEnName: 'forumBoardAdmin') == 'true'}">
                            <li><a href="${createLink(controller: 'communityManager', action: 'forumBoardAdmin')}">小组管理员</a>
                            </li>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'communityManager', actionEnName: 'communityConsumer') == 'true'}">
                            <li><a href="${createLink(controller: 'communityManager', action: 'communityConsumer')}">社区用户</a>
                            </li>
                        </g:if>
                    </ul>
                </li>
            </g:if>
        </ul>
    </div>
</div>

<div id="main" class="ui-layout-center">
    <div class=x_daohang><span class="dangqian">当前位置：</span>&gt;&gt;
    <bofulAdmin:pathNavMap controllerName="${controllerName}" actionName="${actionName}"/>
    </div>

    <div class="programMgrMain">
        <g:layoutBody/>
    </div>
</div>
<!--===主界面结束===-->
<g:include view="/layouts/mgrFooter.gsp"/>
</body>
</html>