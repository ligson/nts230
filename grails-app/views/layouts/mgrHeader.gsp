<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午6:10
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<div id="boful_ui_shaded" class="ou_admin_loading_box">
    <div class="ou_admin_loading">

        <img src="${resource(dir: 'skin/blue/pc/admin/images', file: 'admin_loading_gif1.gif')}"/>

        <p>正在加载...</p>

    </div>
</div>
<!--===头部开始===-->
<div id="header" class="ui-layout-north">
    <div id="mainnav">
        <div id="sitelogo"></div>

        <div id="mainnavr">
            %{--   <div class="mainnavr_top">
                   <p>
                       <span class="super_user">${session.consumer.nickname ?: session.consumer.name}</span>
                       <a class="psw" href="${createLink(controller: 'userMgr', action: 'edit', params: [id: session.consumer.id])}">个人空间</a>
                       <a class="quit" href="${createLink(controller: 'admin', action: 'logout')}">退&nbsp;&nbsp;出</a>
                   </p>
               </div>--}%

            <div class="mainnavr_bottom">
                <div class="mainnav">
                    %{--<span><a href="${createLink(controller: 'index', action: 'index')}">首页</a></span>--}%
                    <g:if test="${checkUserTopResource(controllerEnName: 'programMgr', actionEnName: 'index')=='true'}">
                        <span><a href="${createLink(controller: 'programMgr', action: 'index')}">资源管理</a></span>
                    </g:if>
                    <g:if test="${checkUserTopResource(controllerEnName: 'communityManager', actionEnName: 'index')=='true'}">
                        <span><a href="${createLink(controller: 'communityManager', action: "${session.communityAction}")}">社区管理</a></span>
                    </g:if>
                    <g:if test="${checkUserTopResource(controllerEnName: 'userActivityMgr', actionEnName: 'index')=='true'}">
                        <span><a href="${createLink(controller: 'userActivityMgr', action: "${session.userActivityAction}")}">活动管理</a></span>
                    </g:if>
                    %{--<span><a href="${createLink(controller: 'appMgr', action: 'index')}">应用管理</a></span>--}%
                    <g:if test="${checkUserTopResource(controllerEnName: 'userMgr', actionEnName: 'index')=='true'}">
                        <span><a href="${createLink(controller: 'userMgr', action: "${session.userAction}")}">用户管理</a></span>
                    </g:if>
                    <g:if test="${checkUserTopResource(controllerEnName: 'coreMgr', actionEnName: 'index')=='true'}">
                        <span><a href="${createLink(controller: 'coreMgr', action: "${session.coreAction}")}">系统管理</a></span>
                    </g:if>
                </div>
            </div>
        </div>
    </div>

    <div id="summary">
        <div id="summaryl"><span>
            ${new Date().format("yyyy年MM月dd日 HH:mm:ss")}
            ，</span><span>欢迎使用"<font class="boful">邦丰资源管理系统</font>"</span></div>

        <div id="summaryr">
            <p>
                <span class="super_user">${session.consumer.nickname ?: session.consumer.name}</span>
                <g:if test="${session.consumer.role == 0}">
                    <a class="psw"
                       href="${createLink(controller: 'userMgr', action: 'masterEdit', params: [id: session.consumer.id])}">个人空间</a>
                </g:if>
                <g:else>
                    <a class="psw"
                       href="${createLink(controller: 'userMgr', action: 'userEdit', params: [id: session.consumer.id])}">个人空间</a>
                </g:else>
                <a class="quit" href="${createLink(controller: 'admin', action: 'logout')}">退&nbsp;&nbsp;出</a>
            </p>
        </div>
    </div>
</div>
<!--===头部结束===-->
