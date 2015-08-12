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
    <!-- InstanceBeginEditable name="doctitle" -->
    <meta name="Keywords" content="北京邦丰信息技术有限公司,邦丰网络教学资源发布系统,邦丰公司"/>
    <meta name="Description" content="邦丰网络教学资源发布系统"/>
    <meta name="robots" content="index，follow"/>
    <meta name="googlebot" content="index，follow"/>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <title><g:layoutTitle/>-<g:message code="application.name" default="邦丰资源管理平台"/></title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css/', file: 'appmgr_left_icons.css')}">
    <!-- InstanceEndEditable --><!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
    <g:include view="/layouts/mgrCommonResources.gsp"/>
    <g:layoutHead/>
    <style type="text/css">
    .ui-menu {
        width: 198px;
    }
    </style>
</head>

<body>
<g:include view="/layouts/mgrHeader.gsp"/>
<!--===主界面开始===-->
<div id="sidebar" class="ui-layout-west scrolling-content">
    <div class="sidebar_resource_box">
        <div class="sidebar_title"><img src="${resource(dir: 'skin/blue/pc/admin/images', file: 'tree_sys.png')}">
        </div>
        <ul id="menu">
            <g:if test="${(checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'localWebServerConfig')=='true')||(checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'fileServerConfig')=='true')||(checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'logoConfig')=='true')}">
                <li><span class="core_sys"></span><a
                %{--href="${createLink(controller: 'coreMgr', action: 'systemConfig')}"--}%>系统设置</a>
                    <ul>
                        <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'localWebServerConfig')=='true'}">
                            <li><a href="${createLink(controller: 'coreMgr', action: 'localWebServerConfig')}">本地web服务器配置</a>
                            </li>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'fileServerConfig')=='true'}">
                            <li><a href="${createLink(controller: 'coreMgr', action: 'fileServerConfig')}">文件服务器配置</a></li>
                        </g:if>
                        %{--<g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'fileSizeLimitConfig')=='true'}">
                            <li><a href="${createLink(controller: 'coreMgr', action: 'fileSizeLimitConfig')}">上传文件最大容量配置</a></li>
                        </g:if>--}%
                        <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'seniorSearchConifg')=='true' && application.searchEnable}">
                            <li><a href="${createLink(controller: 'coreMgr', action: 'seniorSearchConifg')}">高级搜索配置</a></li>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'logoConfig')=='true'}">
                            <li><a href="${createLink(controller: 'coreMgr', action: 'logoConfig')}">logo图片</a></li>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'sysNotice')=='true'}">
                            <li><a href="${createLink(controller: 'coreMgr', action: 'sysNotice')}">系统公告</a></li>
                        </g:if>

                    </ul>
                </li>
            </g:if>

            %{--<li><span class="core_old"></span><a
                    href="${createLink(controller: 'coreMgr', action: 'metaDefineList')}">元数据定义</a></li>
            <li><span class="core_save"></span><a
                    href="${createLink(controller: 'coreMgr', action: 'directoryList')}">类库管理</a></li>--}%
            %{-- <li><span class="core_clas"></span><a
                     href="${createLink(controller: 'coreMgr', action: 'programCategoryMgr')}">分类管理</a></li>--}%
            <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'newsList')=='true'}">
                <li><span class="appmgr_word"></span><a
                        href="${createLink(controller: 'coreMgr', action: 'newsList')}">新闻资讯</a></li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'operationLogList')=='true'}">
                <li><span class="appmgr_answer"></span><a
                        href="${createLink(controller: 'coreMgr', action: 'operationLogList')}">系统日志</a></li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'toolsList')=='true'}">
                <li><span class="appmgr_tools"></span><a
                        href="${createLink(controller: 'coreMgr', action: 'toolsList')}">系统工具</a></li>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'accessStatistics')=='true'}">
                <li><span class="appmgr_tools"></span><a href="#">数据统计</a>
                    <ul>
                        <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'accessStatistics')=='true'}">
                            <li><a href="${createLink(controller: 'coreMgr', action: 'accessStatistics')}">访问统计</a>
                            </li>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'userStatistics')=='true'}">
                            <li><a href="${createLink(controller: 'coreMgr', action: 'userStatistics')}">用户统计</a></li>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'generalQuery')=='true'}">
                            <li><a href="${createLink(controller: 'coreMgr', action: 'generalQuery')}">通用统计</a></li>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'coreMgr',actionEnName: 'onlineUserStatistics')=='true'}">
                            <li><a href="${createLink(controller: 'coreMgr', action: 'onlineUserStatistics')}">在线用户统计</a></li>
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
<!-- InstanceEnd -->
</html>