<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午4:23
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="nts.system.domain.Directory" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <link rel="icon" type="image/x-icon" href="${resource(dir: 'skin/blue/pc/images', file: 'boful_logo.ico')}"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="Keywords" content="北京邦丰信息技术有限公司,邦丰网络教学资源发布系统,邦丰公司"/>
    <meta name="Description" content="邦丰网络教学资源发布系统"/>
    <meta name="robots" content="index，follow"/>
    <meta name="googlebot" content="index，follow"/>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <title><g:layoutTitle/>-<g:message code="application.name" default="邦丰资源管理平台"/></title>
    <r:require modules="zTree"/>
    <g:include view="/layouts/mgrCommonResources.gsp"/>

    %{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'tree.css')}"/>


    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/meta.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'metalist.js')}"></script>

    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>--}%
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'boful/programMgr/programCategoryTree.js')}"></script>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'manager_resource_list.css')}"/>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_left_tree.css')}"/>
    <g:layoutHead/>
    <script type="text/javascript" language="JavaScript">
        $(document).ready(function () {
//            $.cookie('program_show_cookie', null);
            $.cookie('programList_TreeNode_Tid_Cookie', null);
        });
    </script>
</head>

<body>
<g:include view="/layouts/mgrHeader.gsp"/>
<!--===主界面开始===-->
<div id="sidebar" class="ui-layout-west">

    <div class="sidebar_resource_box">
        <div class="sidebar_title">
            <img src="${resource(dir: 'skin/blue/pc/admin/images', file: 'tree_resource.png')}" width="195"
                 height="40" alt=""/>
        </div>

        <div id="accordion" class="scrolling-content">
            <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'index') == 'true'}">
                <h1 id="program_teach_Id"><span class="program_teach"></span>资源库浏览</h1>

                <div>
                    <div class="program_rtree">
                        <div class="ztree" id="CategoryTree2"></div>
                    </div>
                </div>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'deletedProgramList') == 'true'}">
                <h1 id="program_back_Id"><span class="program_back"></span>回收站</h1>

                <div>
                    <div class="meau_sup">
                        <g:link controller="programMgr" action="deletedProgramList">删除资源列表</g:link>
                    </div>
                </div>
            </g:if>
            <g:if test="${(checkUserResource(controllerEnName: 'programMgr', actionEnName: 'serverNodeList') == 'true') || (checkUserResource(controllerEnName: 'programMgr', actionEnName: 'localProgramServerNode') == 'true') || (checkUserResource(controllerEnName: 'programMgr', actionEnName: 'programServerNode') == 'true')}">
                <h1 id="program_save_id"><span class="program_save"></span>分发收割</h1>

                <div>
                    <div class="meau_sup">
                        <a href="${createLink(controller: 'programMgr', action: 'timePlanList')}"
                           target="_parent">Job列表</a>
                        <a href="${createLink(controller: 'programMgr', action: 'timePlanShow')}"
                           target="_parent">时间计划</a>
                        <a href="${createLink(controller: 'programMgr', action: 'programDistributePolicy')}"
                           target="_parent">分发收割策略</a>
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'serverNodeList') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'serverNodeList')}"
                               target="_parent">节点管理</a>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'localProgramServerNode') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'localProgramServerNode')}"
                               target="_parent">本地资源</a>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'programServerNode') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'programServerNode')}"
                               target="_parent">节点资源</a>
                        </g:if>
                    </div>
                </div>
            </g:if>
            <g:if test="${(checkUserResource(controllerEnName: 'programMgr', actionEnName: 'statisticsResource') == 'true') || (checkUserResource(controllerEnName: 'programMgr', actionEnName: 'statisticsUserVisit') == 'true')}">
                <h1 id="program_number_Id"><span class="program_number"></span>信息统计</h1>

                <div>
                    <div class="meau_sup">
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'programStatisticsIndex') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'programStatisticsIndex')}"
                               target="_parent">资源排行</a>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'programStatistics') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'programStatistics')}"
                               target="_parent">资源统计</a>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'userVisitStatisticsIndex') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'userVisitStatisticsIndex')}"
                               target="_parent">用户统计</a>
                        </g:if>

                    </div>
                </div>
            </g:if>

            %{--<g:if test="${(checkUserResource(controllerEnName: 'programMgr', actionEnName: 'importExcel') == 'true') || (checkUserResource(controllerEnName: 'programMgr', actionEnName: 'exportExcelorXml') == 'true')}">--}%
                %{--<h1 id="program_come_Id"><span class="program_come"></span>导入和导出</h1>--}%

                %{--<div>--}%
                    %{--<div class="meau_sup">--}%
                        %{--<g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'importExcel') == 'true'}">--}%
                            %{--<a href="${createLink(controller: 'programMgr', action: 'importExcel')}">资源导入</a>--}%
                        %{--</g:if>--}%
                        %{--<g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'exportExcelorXml') == 'true'}">--}%
                            %{--<a href="${createLink(controller: 'programMgr', action: 'exportExcelorXml')}">资源导出</a>--}%
                        %{--</g:if>--}%

                    %{--</div>--}%
                %{--</div>--}%
            %{--</g:if>--}%
            <g:if test="${(checkUserResource(controllerEnName: 'programMgr', actionEnName: 'remarkManager') == 'true') || (checkUserResource(controllerEnName: 'programMgr', actionEnName: 'remarkTotalManager') == 'true')}">
                <h1 id="program_talk_id"><span class="program_talk"></span>评论管理</h1>

                <div>
                    <div class="meau_sup">
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'remarkManager') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'remarkManager')}">评论列表</a>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'remarkTotalManager') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'remarkTotalManager')}">评论统计</a>
                        </g:if>

                    </div>
                </div>
            </g:if>

        %{--<g:if test="${(checkUserResource(controllerEnName: 'programMgr', actionEnName: 'createDirectory')=='true') || (checkUserResource(controllerEnName: 'programMgr', actionEnName: 'showDirectory')=='true')}">
            <h1 id="promgram_class_m_id"><span class="promgram_class_m"></span> 类库管理</h1>

            <div>
                <div class="meau_sup">
                    <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'createDirectory')=='true'}">
                        <a href="${createLink(controller: 'programMgr', action: 'createDirectory')}">添加类库</a>
                    </g:if>
                    <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'showDirectory')=='true'}">
                        <a href="${createLink(controller: 'programMgr', action: 'showDirectory')}">类库列表</a>
                    </g:if>

                </div>
            </div>
        </g:if>--}%
            <g:if test="${(checkUserResource(controllerEnName: 'programMgr', actionEnName: 'createDirectory') == 'true') ||
                    (checkUserResource(controllerEnName: 'programMgr', actionEnName: 'showDirectory') == 'true') ||
                    (checkUserResource(controllerEnName: 'programMgr', actionEnName: 'metaDefineCreate') == 'true') ||
                    (checkUserResource(controllerEnName: 'programMgr', actionEnName: 'metaDefineList') == 'true')}">
                <h1 id="program_new_m_id"><span class="program_new_m"></span> 元数据管理</h1>

                <div>
                    <div class="meau_sup">
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'createDirectory') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'createDirectory')}">添加元数据标准</a>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'showDirectory') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'showDirectory')}">元数据标准列表</a>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'metaDefineCreate') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'metaDefineCreate')}">添加元数据</a>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'metaDefineList') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'metaDefineList')}">元数据列表</a>
                        </g:if>
                       %{-- <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'metaProgramsBrowse') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'metaProgramsBrowse')}">浏览资源</a>
                        </g:if>--}%
                    </div>
                </div>
            </g:if>
            <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'programCategoryMgr') == 'true' || checkUserResource(controllerEnName: 'programMgr', actionEnName: 'categoryFactedMgr') == 'true'}">
                <h1 id="program_resource_cla_id"><span class="program_resource_cla"></span>资源分类</h1>

                <div>
                    <div class="meau_sup">
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'programCategoryMgr') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'programCategoryMgr')}">分类列表</a>
                        </g:if>
                        <g:if test="${checkUserResource(controllerEnName: 'programMgr', actionEnName: 'categoryFactedMgr') == 'true'}">
                            <a href="${createLink(controller: 'programMgr', action: 'categoryFactedMgr')}">分面列表</a>
                        </g:if>
                    </div>
                </div>
            </g:if>
        </div>
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