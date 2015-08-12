<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/6/25
  Time: 10:09
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.text.SimpleDateFormat; nts.program.domain.Program; nts.utils.CTools" %>
<html>
<head>
    <title>用户统计</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'programstatistics_index.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_statistics.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}">
    <r:require modules="highcharts,jqGrid"/>
    <script type="text/javascript"  src="${resource(dir: 'js/boful/programMgr', file: 'userStatistics.js')}"></script>
</head>

<body>
<div class="statistics_time st_mgr">
    <p class="t_chose" style="margin-right: 20px;">
        <a href="${createLink(controller: 'coreMgr', action: 'userStatistics', params: [searchDateType: '0'])}">当天</a>
        <a href="${createLink(controller: 'coreMgr', action: 'userStatistics', params: [searchDateType: '1'])}">昨天</a>
        <a href="${createLink(controller: 'coreMgr', action: 'userStatistics', params: [searchDateType: '2'])}">最近7天</a>
        <a href="${createLink(controller: 'coreMgr', action: 'userStatistics', params: [searchDateType: '3'])}">最近30天</a>
       %{-- <a href="javascript:void(0);" --}%%{--<g:if test="${params.searchDateType == '0'}">class="corr"</g:if>--}%%{-- onclick="searchgeneral('0')">当天</a>
        <a href="javascript:void(0);"--}%%{-- <g:if test="${params.searchDateType == '1'}">class="corr"</g:if>--}%%{-- onclick="searchgeneral('1')">昨天</a>
        <a href="javascript:void(0);"--}%%{-- <g:if test="${params.searchDateType == '2'}">class="corr"</g:if> --}%%{--onclick="searchgeneral('2')">最近7天</a>
        <a href="javascript:void(0);" --}%%{--<g:if test="${params.searchDateType == '3'}">class="corr"</g:if>--}%%{-- onclick="searchgeneral('3')">最近30天</a>--}%
    </p>
    <g:form controller="coreMgr" action="userStatistics" name="coreForm">
        <input type="hidden" name="max" value="${params.max}">
        <input type="hidden" name="offset" value="${params.offset}">
        <input type="hidden" name="sort" value="${params.sort}">
        <input type="hidden" name="order" value="${params.order}">
        <input type="hidden" name="searchDateType" id="searchDateType" value="${params.searchDateType}">

        <p class="t_chose">
            <input class="t_chose_star" id="startTime" name="startDate" value="<g:if test="${params.startDate != null}">${params.startDate}</g:if><g:else>起始日期</g:else>" readonly>至<input id="endTime" name="endDate" class="t_chose_end" value="<g:if test="${params.endDate != null}">${params.endDate}</g:if><g:else>结束日期</g:else>"  readonly></p>

        <p class="t_but"><input class="t_but_sear" type="button" value="查询" onclick="searchDateTo()"></p>
    </g:form>
</div>
%{--<div class="program_statistics_search">
    <p class="program_ser_star"><label><input type="text" id="startTime" value="起始日期" readonly/></label></p>
    <p class="program_ser_end"><label><input type="text" id="endTime" value="结束日期" readonly/></label></p>
    <p class="program_ser_but"><label><input type="button" value="查询" onclick="searchData()"/></label></p>
</div>--}%
<div class="statistics_infor">
    <table border="0" width="100%">
        <tbody>
        <tr>
            <td width="25%">
                <p class="statistics_res_title"><span class="statistics_res_icon"  style="width: 100px;">用户数</span></p>

                <p><span class="statistics_res_number">${userCount}</span></p>
            </td>
            <td width="25%">
                <p class="statistics_res_title"><span class="statistics_res_icon" style="width: 100px;">新用户比例</span></p>

                <p>
                    <span class="statistics_res_number"></span>
                    <span class="statistics_res_percent">${newUserPercent}%</span>
                </p>
            </td>
            <td width="25%">
                <p class="statistics_res_title" ><span class="statistics_res_icon" style="width: 110px;">用户访问时长</span></p>

                <p>
                    <span class="statistics_res_number"></span>
                    <span  class="statistics_res_percent">${visitTimes}</span>
                </p>
            </td>
            <td width="25%">
                <p class="statistics_res_title"><span class="statistics_res_icon">跳出率</span></p>

                <p>      <span class="statistics_res_number"></span>
                    <span class="statistics_res_percent">${outPercent}%</span>

                </p>
            </td>
        </tr>
        </tbody>
    </table>
</div>
%{--
<div class="histogram_res">
    <div id="programStatistics" class="program_statistics_sector"></div>

    <div id="programYearStatistics" class="program_statistics_histogram"></div>
</div>--}%
<br/>
%{--黏贴列表--}%
<div id="tblist">
    <table id="userStatisticeList">
    </table>
    <div id="userStatisticePager"></div>
%{--
    <table id="progListTab" cellpadding="0" cellspacing="1" bgcolor="#ffffff" border="0" width="100%">
        <tbody><tr class="th">
            <td align="center" width="50"></td>
            <th class="sortable" style="text-align: left"><a href="#">(ID)操作用户名</a></th>
            <th class="sortable" align="center" width="135"><a href="#">用户IP</a></th>
            <th class="sortable" align="center" width="200"><a href="#">用户访问contorller</a></th>
            <th class="sortable" align="center" width="200"><a href="#">用户访问action</a></th>
            <th class="sortable" align="center" width="100"><a href="#">返回状态码</a></th>
            <th class="sortable" align="center" width="100"><a href="#">请求时间</a></th>
            <th class="sortable" align="center" width="100"><a href="#">请求方式</a></th>
        </tr>
        <g:each in="${consumerLogList}" var="consumerLog" status="no">
        <tr <g:if test="${(no+1) % 2 == 0}">class="odd"</g:if><g:else>class="even"</g:else>>
            <td align="center">${no+1}</td>
            <td >${consumerLog?.consumerName}</td>
            <td align="center">${consumerLog?.ip}</td>
            <td align="center">${consumerLog?.controllerName}</td>
            <td align="center">${consumerLog?.actionName}</td>
            <td align="center">${consumerLog?.statusCode}</td>
            <td align="center"><g:formatDate date="${consumerLog?.dateCreated}" format="yyyy-MM-dd HH:mm:ss"/></td>
            <td align="center">${consumerLog?.requestMethod}</td>
        </tr>
        </g:each>
        </tbody>
    </table>

    <table cellpadding="0" cellspacing="1" bgcolor="#ffffff"  border="0" width="100%">
        <tr >
            <td align="right" style="margin: 8px 0; padding: 8px 0">
                <div class="paginateButtons">
                    <g:guiPaginate total="${total}" params="${params}"/>
                </div>
            </td>
        </tr>
        </table>
--}%


</div>

<script type="text/javascript" language="JavaScript">
    $(function () {
        $(".t_chose a").click(function () {
            var index = $(".t_chose a").index($(this));
            $("#searchDateType").val(index) ;
//            $("#coreForm").submit() ;
        });
    })

/*    function searchDate(){
        if($("#startTime").val().toString() == '起始日期' && $("#endTime").val().toString() != '结束日期'){
            alert("请选择起始日期");
            return;
        }
        if($("#startTime").val().toString() != '起始日期' && $("#endTime").val().toString() == '结束日期'){
            alert("请选择结束日期");
            return;
        }
        if (new Date(Date.parse($("#startTime").val().toString().replace(/-/g, "/"))) > new Date(Date.parse($("#endTime").val().toString().replace(/-/g, "/")))) {
            alert("起始日期不能大于结束日期");
            return;
        }
        $("#coreForm").submit() ;
    }*/
</script>
</body>
</html>