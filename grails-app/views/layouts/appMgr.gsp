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
<div id="sidebar" class="ui-layout-west">
    <h2 class="titlehx"><img src="${resource(dir: 'skin/blue/pc/images', file: 'title_yygl.png')}"></h2>
    <ul id="menu">
        <li><span class="appmgr_massage"></span><a href="${createLink(controller: 'appMgr', action: 'index')}">公告管理</a>
        </li>
        %{--<li><a href="javascript:void(null)" onclick="javascript:ShowFLT(1)">调查问卷</a>
            <ul class="myHide">
                <li><a href="${createLink(controller: 'appMgr', action: 'qnaireList')}"
                       target="_parent">问卷管理</a></li>
                <li><a href="${createLink(controller: 'appMgr', action: 'surveylist')}"
                       target="_parent">答卷管理</a></li>
                <li><a href="${createLink(controller: 'appMgr', action: 'statisticsList')}"
                       target="_parent">答卷统计</a></li>
            </ul>
        </li>--}%
        <li><span class="appmgr_word"></span><a
                href="${createLink(controller: 'appMgr', action: 'operationLogList')}">日志管理</a></li>
        <li><span class="appmgr_answer"></span><a
                href="${createLink(controller: 'appMgr', action: 'questionList')}">问题反馈</a></li>
        %{--  <li><span class="appmgr_come"></span><a
                  href="${createLink(controller: 'appMgr', action: 'importExcel')}">资源导入</a></li>--}%
        %{-- <li><span class="appmgr_explo"></span><a
                 href="${createLink(controller: 'appMgr', action: 'exportExcelorXml')}">资源导出</a></li>--}%
        %{--<a href="${createLink(controller: 'appMgr', action: 'statistics')}">信息统计</a>--}%
        %{-- <li><span class="appmgr_mass"></span><a href="javascript:void(0);" onclick="javascript:ShowFLT(15)">信息统计</a>
             <ul>
                 <li><a href="${createLink(controller: 'appMgr', action: 'statisticsResource')}"
                        target="_parent">资源统计</a></li>
                 <li><a href="${createLink(controller: 'appMgr', action: 'statisticsUserVisit')}"
                        target="_parent">用户统计</a></li>
             </ul>
         </li>--}%

        %{-- <li><span class="appmgr_change"></span><a href="javascript:void(0);" onclick="javascript:ShowFLT(14)">转码管理</a>
             <ul>
                 <li><a href="${createLink(controller: 'appMgr', action: 'transcodeStatstic')}"
                               target="_parent">转码统计</a></li>
                 <li><a href="${createLink(controller: 'appMgr', action: 'transcodeList')}"
                        target="_parent">转码列表</a></li>
             </ul>
         </li>--}%
        <li><span class="appmgr_tools"></span><a
                href="${createLink(controller: 'appMgr', action: 'toolsList')}">工具管理</a></li>
        <li><span class="appmgr_talk"></span><a
                href="${createLink(controller: 'appMgr', action: 'remarkList')}">评论管理</a>
            %{-- <ul>
                 <li><a href="#">节目预告</a></li>
             </ul>--}%
        </li>
        <li><span class="appmgr_wid"></span><a
                href="${createLink(controller: 'appMgr', action: 'friendLinkList')}">外部资源</a></li>
        <li><span class="appmgr_clas"></span><a
                href="${createLink(controller: 'appMgr', action: 'RMSCategoryList')}">活动(社区)类别</a></li>
        <li><span class="appmgr_form"></span><a
                href="${createLink(controller: 'appMgr', action: 'communityList')}">社区管理</a></li>
        <li><span class="appmgr_activit"></span><a
                href="${createLink(controller: 'appMgr', action: 'userActivityList')}">活动管理</a></li>
        <li><span class="appmgr_works"></span><a
                href="${createLink(controller: 'appMgr', action: 'userWorkList')}">作品管理</a></li>
        %{--  <li><span class="appmgr_save"></span><a href="javascript:void(0);" onclick="javascript:ShowFLT(5)">分发收割</a>
              <ul>
                  <li><a href="${createLink(controller: 'appMgr', action: 'serverNodeList')}"
                         target="_parent">节点管理</a></li>
                  <li><a href="${createLink(controller: 'appMgr', action: 'localProgramServerNode')}"
                         target="_parent">本地资源</a></li>
                  <li><a href="${createLink(controller: 'appMgr', action: 'programServerNode')}"
                         target="_parent">节点资源</a></li>
              </ul>
          </li>--}%

    </ul>

</div>

<div id="main" class="ui-layout-center">
    <!-- InstanceBeginEditable name="main" -->
    <g:layoutBody/>
    <!-- InstanceEndEditable -->
</div>
<!--===主界面结束===-->
<g:include view="/layouts/mgrFooter.gsp"/>
</body>
</html>