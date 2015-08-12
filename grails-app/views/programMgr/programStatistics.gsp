<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.text.SimpleDateFormat; nts.program.domain.Program; nts.utils.CTools" %>
<html>
<head>
    <title>资源统计首页</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'programstatistics_index.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_statistics.css')}">
    <r:require modules="highcharts"/>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/programMgr', file: 'programStatistics.js')}"></script>
</head>

<body>

<div class="statistics_infor">
    <table border="0" width="100%">
        <tbody>
        <tr>
            <td width="15%">
                <p class="statistics_res_title"><span class="statistics_res_icon">资源总量</span></p>

                <p><span class="statistics_res_number">${programTotal}</span></p>
            </td>
            <g:if test="${totalList && totalList?.size() > 0}">
                <g:each in="${totalList}" var="programStat">
                    <g:if test="${programStat?.size() > 0}">
                        <td width="17%">
                            <p class="statistics_res_title"><span
                                    class="statistics_res_icon">${programStat?.name}</span></p>

                            <p>
                                <span class="statistics_res_number">${programStat?.total}</span>
                                <span class="statistics_res_percent">${programStat?.percent}%</span>
                            </p>
                        </td>
                    </g:if>
                </g:each>
            </g:if>
        </tr>
        </tbody>
    </table>
</div>

<div class="statistics_time st_mgr">
    <p class="t_chose"><input class="t_chose_star" id="startTime" value="起始日期" readonly>至<input id="endTime"
                                                                                                class="t_chose_end"
                                                                                                value="结束日期"
                                                                                                readonly></p>

    <p class="t_but"><input class="t_but_sear" type="button" value="查询" onclick="searchData()"></p>
</div>

<div class="histogram_res">
    <div id="programYearStatistics" class="program_statistics_histogram"></div>

    <div id="programStatistics" class="program_statistics_sector"></div>
</div>
</body>
</html>