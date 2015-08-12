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
<title>通用统计</title>
<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'programstatistics_index.css')}">
<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_statistics.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}">
<r:require modules="jqGrid"/>
<script type="text/javascript"  src="${resource(dir: 'js/boful/programMgr', file: 'generalQuery.js')}"></script>
    %{--<r:require modules="jqGrid"/>--}%

</head>

<body>

%{--<div class="statistics_input">
    <div class="generalq">
        <input type="checkbox" name="checkbox" />
        <label>全部</label>
    </div>
    <div class="generalq">
        <input type="checkbox" name="checkbox"  />
        <label>IP</label>
    </div>
    <div class="generalq">
        <input type="checkbox" name="checkbox"  />
        <label>用户</label>
    </div>
    <div class="generalq">
        <input type="checkbox" name="checkbox"  />
        <label>浏览器</label>
    </div>
</div>--}%
<div class="statistics_time st_mgr">
    <p class="t_chose" style="margin-right: 20px;">
        <a href="javascript:void(0);" onclick="searchgeneral('0')">当天</a>
        %{--<button onclick="searchgeneral('1')">昨天</button>--}%
        <a href="javascript:void(expression)" onclick="searchgeneral('1')">昨天</a>
        <a href="javascript:void(expression)" onclick="searchgeneral('2')" >最近7天</a>
        <a href="javascript:void(expression)" onclick="searchgeneral('3')">最近30天</a>
    </p>
    <g:form controller="coreMgr" action="accessStatistics" name="coreForm">
        <input type="hidden" name="max" value="${params.max}">
        <input type="hidden" name="offset" value="${params.offset}">
        <input type="hidden" name="sort" value="${params.sort}">
        <input type="hidden" name="order" value="${params.order}">
        <input type="hidden" name="searchDateType" id="searchDateType" value="${params.searchDateType}">

        <p class="t_chose">
            <input class="t_chose_star" id="startTime" name="startDate" value="<g:if test="${params.startDate != null}">${params.startDate}</g:if><g:else>起始日期</g:else>" readonly>至<input id="endTime" name="endDate" class="t_chose_end" value="<g:if test="${params.endDate != null}">${params.endDate}</g:if><g:else>结束日期</g:else>"  readonly>
        </p>

        <p class="t_but"><input class="t_but_sear" type="button" value="查询" onclick="searchDateTo()"></p>
    </g:form>
</div>
<g:hiddenField name="showTableId" id="showTableId" value="ipList"></g:hiddenField>
<g:hiddenField name="showTableFlags" id="showTableFlags" value="consumerName"></g:hiddenField>
<div style="width: 99.33%; float: left;">
<div id="accordion11">
    <h3 onclick="ptd('ip')">IP</h3>
    <div>
        <div id="tblist" style="display: block; margin-left: 0;">
            <table id="ipList">
            </table>
            <div id="ipPager"></div>

        </div>
    </div>
    <h3 onclick="ptd('consumerName')">用户</h3>
    <div>
        %{--<p>可用jqGrid嵌套即可</p>--}%
        <table id="consumerNameList">
        </table>
        <div id="consumerNamePager"></div>
    </div>
    <h3 onclick="ptd('userAgent')">浏览器</h3>
    <div>
        %{--<p>可用jqGrid嵌套即可</p>--}%
        <table id="userAgentList">
        </table>
        <div id="userAgentPager"></div>
    </div>
</div>
</div>


%{--黏贴列表--}%


<script type="text/javascript" language="JavaScript">
    $(function () {
        $("#endTime").datepicker();
        $("#startTime").datepicker();
        $(".t_chose a").click(function () {
            var index = $(".t_chose a").index($(this));
            $("#searchDateType").val(index) ;
           // $("#coreForm").submit() ;
        });
    })


</script>
<script>
    $(function() {
        $( "#accordion11" ).accordion({
            heightStyle: "content"
        });
         $(function(){
             $(".ui-accordion-content").addClass("accpan");
             $(".ui-accordion-content").removeClass("ui-accordion-content");
         })
    });
</script>
</body>
</html>