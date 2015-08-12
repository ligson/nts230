<%--
  Created by IntelliJ IDEA.
  User: boful
  Date: 14-12-17
  Time: 上午8:57
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>在线用户统计</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_statistics.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}">
    <r:require modules="highcharts"/>
    <script type="text/javascript"  src="${resource(dir: 'js/boful/coreMgr', file: 'onlineUserStatistics.js')}"></script>
</head>

<body>
<div class="statistics_time st_mgr">
    <p class="t_chose" style="margin-right: 20px;">
        <a href="javascript:void(0);" onclick="searchDateTo(0)">当天</a>
        <a href="javascript:void(0);" onclick="searchDateTo(1)">昨天</a>
        <a href="javascript:void(0);" onclick="searchDateTo(2)">最近7天</a>
        <a href="javascript:void(0);" onclick="searchDateTo(3)">最近30天</a>
    </p>
    <g:form controller="coreMgr" action="onlineUserStatisticsData" name="coreForm">
        <input type="hidden" name="max" value="${params.max}">
        <input type="hidden" name="offset" value="${params.offset}">
        <input type="hidden" name="sort" value="${params.sort}">
        <input type="hidden" name="order" value="${params.order}">
        <input type="hidden" name="searchDateType" id="searchDateType" value="${params.searchDateType}">

        <p class="t_chose">
            <input class="t_chose_star" id="startTime" name="startDate" value="<g:if test="${params.startDate != null}">${params.startDate}</g:if><g:else>起始日期</g:else>" readonly>至<input id="endTime" name="endDate" class="t_chose_end" value="<g:if test="${params.endDate != null}">${params.endDate}</g:if><g:else>结束日期</g:else>"  readonly></p>

        <p class="t_but"><input class="t_but_sear" type="button" value="查询" onclick="searchDateTo(4)"></p>
    </g:form>
</div>

<div class="histogram_res">
    <div id="onlineUserStatistics"></div>
</div>
</body>
</html>