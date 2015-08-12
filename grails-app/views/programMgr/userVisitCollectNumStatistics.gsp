<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-5-5
  Time: 下午8:10
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.text.SimpleDateFormat; nts.utils.CTools" %>
<html>
<head>
    <title>用户统计</title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_statistics.css')}">
    <r:require modules="highcharts, jquery-ui"/>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/programMgr', file: 'userVisitCollectNumStatistics.js')}"></script>
</head>

<body>
<div class="program_statistics_content">
    <div class="statistics_time">
        <p class="t_present"><span class="t_today">今&nbsp;天</span><span class="t_weak">本&nbsp;周</span><span
                class="t_month">本&nbsp;月</span></p>

        <p class="t_chose"><input id="startTime" class="t_chose_star" value="起始日期">至<input id="endTime"
                                                                                           class="t_chose_end"
                                                                                           value="结束日期"></p>

        <p class="t_but"><input class="t_but_sear" type="button" value="查询" onclick="searchDate()"></p>
    </div>

    %{-- <div class="statistics_title">
         <p><span>点播统计</span><span>浏览统计</span><span>下载统计</span><span>推荐统计</span><span>收藏统计</span></p>
     </div>--}%

    <div class="statistics_title_infor">
        <p>收藏统计结果。如下:%{--<a href="#">查看详细</a>--}%</p>
    </div>

    <div class="statistics_math">
        <div id="userVisitCollectNumStatisticsId" class="statistics_math_mark">

        </div>

    </div>

    <div class="statistics_math_tab">
        <table width="100%">
            <tbody>
            <tr>
                <th width="50" align="center">排序</th>
                <th align="left">用户名称</th>
                <th width="120" align="center">收藏次数</th>
            </tr>
            <g:each in="${consumerList}" status="i" var="consumer">
                <tr>
                    <td align="center">${i + 1}</td>
                    <td align="left"><a
                            href="${createLink(controller: 'my', action: 'userSpace', params: [id: consumer.id])}">${consumerName(id: consumer.id)}</a>
                    </td>
                    <td align="center">${consumer.collectNum}</td>
                </tr>
            </g:each>
            </tbody>
        </table>

        <!------------分页------------->
        <div class="">
            <g:guiPaginate action="userVisitCollectNumStatistics" class="all_page" controller="programMgr"
                           total="${total}"/>
        </div>
    </div>
</div>
</body>
</html>