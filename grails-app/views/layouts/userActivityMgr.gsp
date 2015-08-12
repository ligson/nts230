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
</head>

<body>

<g:include view="/layouts/mgrHeader.gsp"/>
<!--===主界面开始===-->
<div id="sidebar" class="ui-layout-west scrolling-content">
    <div class="sidebar_resource_box">
        <div class="sidebar_title"><img src="${resource(dir: 'skin/blue/pc/admin/images', file: 'tree_activity.png')}">
        </div>
        <ul id="menu">
            <g:if test="${checkUserResource(controllerEnName: 'userActivityMgr',actionEnName: 'index')=='true'}">
                <li><span class="usermgr_Musers"></span><a
                        href="${createLink(controller: 'userActivityMgr', action: 'index')}">活动管理</a></li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'userActivityMgr',actionEnName: 'userActivityCategoryList')=='true'}">
                <li><span class="appmgr_clas"></span><a
                        href="${createLink(controller: 'userActivityMgr', action: 'userActivityCategoryList')}">活动分类</a>
                </li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'userActivityMgr',actionEnName: 'userWorkList')=='true'}">
                <li><span class="appmgr_works"></span><a
                        href="${createLink(controller: 'userActivityMgr', action: 'userWorkList')}">作品管理</a></li>
            </g:if>

        </ul>
    </div>
</div>

<div id="main" class="ui-layout-center">
    <div class=x_daohang><span class="dangqian">当前位置：</span>&gt;&gt;
    <bofulAdmin:pathNavMap controllerName="${controllerName}" actionName="${actionName}"/>
    </div>

    <div class="programMgrMain ">
        <g:layoutBody/>
    </div>
</div>
<!--===主界面结束===-->
<g:include view="/layouts/mgrFooter.gsp"/>
</body>
</html>