<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午4:23
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="nts.user.domain.Consumer" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/资源管理.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
    <link rel="icon" type="image/x-icon" href="${resource(dir: 'skin/blue/pc/images', file: 'boful_logo.ico')}"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <!-- InstanceBeginEditable name="doctitle" -->
    <meta name="Keywords" content="北京邦丰信息技术有限公司,邦丰网络教学资源发布系统,邦丰公司"/>
    <meta name="Description" content="邦丰网络教学资源发布系统"/>
    <meta name="robots" content="index，follow"/>
    <meta name="googlebot" content="index，follow"/>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'appmgr_left_icons.css')}">
    <title><g:layoutTitle/>-<g:message code="application.name" default="邦丰资源管理平台"/></title>
    <!-- InstanceEndEditable --><!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
    <r:require modules="zTree"/>
    <g:include view="/layouts/mgrCommonResources.gsp"/>
    <g:layoutHead/>
    <style type="text/css">
    .ui-menu {
        width: 198px;
    }
    </style>
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0/css', file: 'ui.jqgrid.css')}"/>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0/js/i18n', file: 'grid.locale-cn.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/jquery/jquery.jqGrid-4.6.0/js', file: 'jquery.jqGrid.min.js')}"></script>
</head>

<body>
<g:include view="/layouts/mgrHeader.gsp"/>
<!--===主界面开始===-->
<div id="sidebar" class="ui-layout-west scrolling-content">
    <div class="sidebar_resource_box">
        <div class="sidebar_title"><img src="${resource(dir: 'skin/blue/pc/admin/images', file: 'tree_user.png')}"
                                        alt=""/>
        </div>
        <ul id="menu">
            %{--<li><span class="usermgr_use"></span><a href="#">权限管理</a>
                <ul>
                    <li><a href="${createLink(controller: 'userMgr', action: 'userGroupRole')}">用户组管理</a></li>
                    <li><a href="${createLink(controller: 'userMgr', action: 'consumerRole')}">用户管理</a></li>
                    <li><a href="${createLink(controller: 'userMgr', action: 'roleManager')}">权限管理</a></li>
                </ul>
            </li>--}%
            <g:if test="${(checkUserResource(controllerEnName: 'userMgr',actionEnName: 'userGroupRole')=='true')||(checkUserResource(controllerEnName: 'userMgr',actionEnName: 'consumerRole')=='true')||(checkUserResource(controllerEnName: 'userMgr',actionEnName: 'roleManager')=='true')}">
                <li><span class="usermgr_user"></span>
                    <a>角色管理</a>
                    <ul>
                        <g:if test="${checkUserResource(controllerEnName: 'userMgr',actionEnName: 'userGroupRole')=='true'}">
                            <li><a href="${createLink(controller: 'userMgr', action: 'userGroupRole')}">用户组管理</a></li>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'userMgr',actionEnName: 'consumerRole')=='true'}">
                            <li><a href="${createLink(controller: 'userMgr', action: 'consumerRole')}">用户管理</a></li>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'userMgr',actionEnName: 'roleManager')=='true'}">
                            <li><a href="${createLink(controller: 'userMgr', action: 'roleManager')}">权限管理</a></li>
                        </g:if>
                    </ul>
                </li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'userMgr',actionEnName: 'userList')=='true'}">
                <li><span class="usermgr_users"></span><a
                        href="${createLink(controller: 'userMgr', action: 'userList', params: [userRole: 'user', roleList: '2,3'])}">用户管理</a>
                </li>
                <li><span class="usermgr_mgrs"></span><a
                        href="${createLink(controller: 'userMgr', action: 'userList', params: [userRole: 'mg', roleList: '1'])}">管理员</a>
                </li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'userMgr',actionEnName: 'userGroupList')=='true'}">
                <li><span class="usermgr_prsent"></span><a
                        href="${createLink(controller: 'userMgr', action: 'userGroupList')}">个人用户组管理</a>
                </li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'userMgr',actionEnName: 'collegeList')=='true'}">
                <li><span class="usermgr_door"></span><a
                        href="${createLink(controller: 'userMgr', action: 'collegeList')}">部门设置</a>
                </li>
            </g:if>
            <g:if test="${(checkUserResource(controllerEnName: 'userMgr', actionEnName: 'masterEdit') == 'true') && (session.consumer?.role == Consumer.SUPER_ROLE)}">
                <li><span class="usermgr_Musers"></span><a
                    href="${createLink(controller: 'userMgr', action: 'masterEdit')}">Master管理</a>
            </g:if>
            %{--<li><span class="usermgr_search"></span><a
                    href="${createLink(controller: 'userMgr', action: 'showSearch')}">用户检索</a>
            </li>--}%
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
<!-- InstanceEnd -->
</html>