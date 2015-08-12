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
<title>访问统计</title>
<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'programstatistics_index.css')}">
<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_statistics.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}">
<r:require modules="highcharts,jqGrid"/>
<script type="text/javascript"  src="${resource(dir: 'js/boful/programMgr', file: 'accessStatistics.js')}"></script>

</head>

<body>
<div class="statistics_time st_mgr">
    <p class="t_chose" style="margin-right: 20px;">
        %{--<a href="javascript:void(0);" --}%%{--<g:if test="${params.searchDateType == '0'}">class="corr"</g:if>--}%%{-- onclick="searchgeneral('0')">当天</a>
        <a href="javascript:void(0);" --}%%{--<g:if test="${params.searchDateType == '0'}">class="corr"</g:if>--}%%{-- onclick="searchgeneral('1')">昨天</a>
        <a href="javascript:void(0);" --}%%{--<g:if test="${params.searchDateType == '0'}">class="corr"</g:if>--}%%{-- onclick="searchgeneral('2')">最近7天</a>
        <a href="javascript:void(0);" --}%%{--<g:if test="${params.searchDateType == '0'}">class="corr"</g:if>--}%%{-- onclick="searchgeneral('3')">最近30天</a>--}%
        <a href="${createLink(controller: 'coreMgr', action: 'accessStatistics', params: [searchDateType: '0'])}">当天</a>
        <a href="${createLink(controller: 'coreMgr', action: 'accessStatistics', params: [searchDateType: '1'])}">昨天</a>
        <a href="${createLink(controller: 'coreMgr', action: 'accessStatistics', params: [searchDateType: '2'])}">最近7天</a>
        <a href="${createLink(controller: 'coreMgr', action: 'accessStatistics', params: [searchDateType: '3'])}">最近30天</a>
    </p>
    <g:form controller="coreMgr" action="accessStatistics" name="coreForm">
        <input type="hidden" name="max" value="${params.max}">
        <input type="hidden" name="offset" value="${params.offset}">
        <input type="hidden" name="sort" value="${params.sort}">
        <input type="hidden" name="order" value="${params.order}">
        <input type="hidden" name="searchDateType" id="searchDateType" value="${params.searchDateType}">

        <p class="t_chose">
            <input class="t_chose_star" id="startTime" value="<g:if test="${params.startDate != null}">${params.startDate}</g:if><g:else>起始日期</g:else>" readonly>
            至
            <input id="endTime" class="t_chose_end" value="<g:if test="${params.endDate != null}">${params.endDate}</g:if><g:else>结束日期</g:else>" readonly>
        </p>
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
                <p class="statistics_res_title"><span class="statistics_res_icon">浏览量（PV）</span></p>

                <p><span class="statistics_res_number">${browseCount}</span></p>
            </td>
            <td width="25%">
                <p class="statistics_res_title"><span class="statistics_res_icon">访客数（UV）</span></p>

                <p><span class="statistics_res_number">${visitorCount}</span>
                    %{--<span class="statistics_res_percent">55%</span>--}%
                </p>
            </td>
            <td width="25%">
                <p class="statistics_res_title" ><span class="statistics_res_icon" style="width: 100px;">浏览器比例</span></p>

                <p>
                    %{--<span class="statistics_res_number">222</span>--}%
                    <span class="statistics_res_number"></span>
                    <span  class="statistics_res_percent c1">IE ${iePercent}%</span>
                    <span  class="statistics_res_percent c1">火狐 ${fireFoxPercent}%</span>
                    <span  class="statistics_res_percent c1">谷歌 ${chromePercent}%</span>
                    <span  class="statistics_res_percent c1">其他 ${otherPercent}%</span>
                </p>
            </td>
            <td width="25%">
                <p class="statistics_res_title"><span class="statistics_res_icon" style="width: 110px;">操作系统比例</span></p>

                <p>       <span class="statistics_res_number"></span>
                    %{--<span class="statistics_res_number">${imageTotal}</span>--}%
                    <span class="statistics_res_percent c1">XP ${xpPercent}%</span>
                    <span class="statistics_res_percent c1">2003 ${twoPercent}%</span>
                    <span class="statistics_res_percent c1">win7 ${sevenPercent}%</span>
                    <span class="statistics_res_percent c1">苹果 ${macPercent}%</span>

                </p>
            </td>
        </tr>
        </tbody>
    </table>
</div>

%{--<div class="histogram_res">
    <div id="programStatistics" class="program_statistics_sector"></div>

    <div id="programYearStatistics" class="program_statistics_histogram"></div>
</div>--}%
<br/>
%{--黏贴列表--}%
<div id="tblist" style="display: block">
    <table id="accessList">

    </table>
    <div id="accessPager"></div>
%{--    <table id="progListTab" cellpadding="0" cellspacing="1" bgcolor="#ffffff" border="0" width="100%">
        <tbody><tr class="th">
            <td width="30"></td>
            <th  class="sortable" align="left" width="120"><a href="${createLink(controller:'coreMgr',action:'accessStatistics',params:[sort:"requestReferer",order:order])}">请求链接来源</a></th>
            <th class="sortable" align="left"><a href="${createLink(controller:'coreMgr',action:'accessStatistics',params:[sort:"requestUrl",order:order])}">请求url</a></th>
            <th class="sortable" align="left" width="80"><a href="${createLink(controller:'coreMgr',action:'accessStatistics',params:[sort:"requestContentType",order:order])}">请求类型</a></th>
            <th class="sortable" align="left" width="80"><a href="${createLink(controller:'coreMgr',action:'accessStatistics',params:[sort:"responseContentType",order:order])}">响应类型</a></th>
            <th class="sortable" align="left" width="100"><a href="${createLink(controller:'coreMgr',action:'accessStatistics',params:[sort:"responseTime",order:order])}">响应时间</a></th>
            <th class="sortable" align="left" width="100"><a href="${createLink(controller:'coreMgr',action:'accessStatistics',params:[sort:"ajaxRequest",order:order])}">是否AJAX请求</a></th>
            <th class="sortable" align="left" width="80"><a href="${createLink(controller:'coreMgr',action:'accessStatistics',params:[sort:"userAgent",order:order])}">用户浏览器</a></th>
            <th class="sortable" align="left" width="80"><a href="${createLink(controller:'coreMgr',action:'accessStatistics',params:[sort:"userAgent",order:order])}">操作系统</a></th>
        </tr>
        <g:each in="${consumerLogList}" var="consumerLog" status="no">
            <tr class="even">
                <td align="center">${no + 1}</td>
                <td align="center" title="${consumerLog?.requestReferer}">${CTools.cutString(consumerLog?.requestReferer, 20)}</td>
                <td title="${consumerLog?.requestUrl}">${CTools.cutString(consumerLog?.requestUrl, 70)}</td>
                <td align="center" title="${consumerLog?.requestContentType}">${CTools.cutString(consumerLog?.requestContentType, 20)}</td>
                <td align="center" title="${consumerLog?.responseContentType}">${CTools.cutString(consumerLog?.responseContentType, 20)}</td>
                <td align="center" title="${consumerLog?.responseTime}">${CTools.timeMillisToStr(consumerLog?.responseTime)}</td>
                <td align="center">${consumerLog?.ajaxRequest ? '是' : '否'}</td>
                <td align="center">${checkBrowse([userAgent: consumerLog?.userAgent])}</td>
                <td align="center">${checkOS([userAgent: consumerLog?.userAgent])}</td>
            </tr>
        </g:each>
        </tbody>
   </table>

    <table cellpadding="0" cellspacing="1" bgcolor="#ffffff"  border="0" width="100%">
        <tr >
            <td align="right" style="margin: 8px 0; padding: 8px 0">
                <div class="paginateButtons">
                    <g:guiPaginate total="${browseCount}" params="${params}"/>
                </div>
            </td>
        </tr>
    </table>--}%

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