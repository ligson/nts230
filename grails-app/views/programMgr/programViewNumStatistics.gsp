<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-5-4
  Time: 下午6:11
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.text.SimpleDateFormat; nts.program.domain.Program; nts.utils.CTools" %>
<html>
<head>
    <title>资源统计</title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_statistics.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}">
    <r:require modules="highcharts, jquery-ui"/>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/programMgr', file: 'programViewNumStatistics.js')}"></script>
</head>

<body>
<div class="program_statistics_content">
    <div class="statistics_time">
        <p class="t_present"><span class="t_today">今&nbsp;天</span><span class="t_weak">本&nbsp;周</span><span
                class="t_month">本&nbsp;月</span></p>

        <p class="t_chose"><input class="t_chose_star" id="startTime" value="起始日期" readonly>至<input id="endTime"
                                                                                                    class="t_chose_end"
                                                                                                    value="结束日期"
                                                                                                    readonly></p>

        <p class="t_but"><input class="t_but_sear" type="button" value="查询" onclick="searchDate()"></p>
    </div>

    %{-- <div class="statistics_title">
         <p><span>点播统计</span><span>浏览统计</span><span>下载统计</span><span>推荐统计</span><span>收藏统计</span></p>
     </div>--}%

    <div class="statistics_title_infor">
        <p>浏览统计结果。如下:%{--<a href="#">查看详细</a>--}%</p>
    </div>

    <div class="statistics_math">
        <div id="programViewNumStatisticsId" class="statistics_math_mark">

        </div>

    </div>

    <div class="statistics_math_tab">
        <table width="100%">
            <tbody>
            <tr>
                <th width="50" align="center">排序</th>
                <th align="left">资源名称</th>
                <th width="200" align="center">分类</th>
                <th width="120" align="center">上传作者</th>
                <th width="120" align="center">上传时间</th>
                <th width="120" align="center">浏览次数</th>
            </tr>
            <g:each in="${programList}" var="program" status="i">
                <tr>
                    <td align="center">${i + 1}</td>
                    <td align="left"><a
                            href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                            target="_blank">${program.name}</a></td>
                    <td align="center">
                        <g:if test="${program?.programCategories && program?.programCategories?.size() > 0}">
                            <g:set var="categoryNames" value=""/>
                            <g:each var="programCategory" in="${program?.programCategories.toList()}">
                                <g:set var="categoryNames"
                                       value="${categoryNames + "," + programCategory?.name}"></g:set>
                            </g:each>
                        </g:if>
                        ${categoryNames}
                    </td>
                    <td align="center">${consumerName(id: program.consumer.id)}</td>
                    <td align="center"><g:formatDate date="${program.dateCreated}"
                                                     format="yyyy-MM-dd"></g:formatDate></td>
                    <td align="center">${program.viewNum}</td>
                </tr>
            </g:each>
            </tbody>
        </table>

        <!------------分页------------->
        <div class="statitics_cadmin_page">
            <g:guiPaginate action="programViewNumStatistics" class="all_page" controller="programMgr"
                           total="${total}"/>
        </div>
    </div>
</div>
</body>
</html>