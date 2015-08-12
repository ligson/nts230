<%@ page import="java.text.SimpleDateFormat; nts.program.domain.Program; nts.utils.CTools" %>
<html>
<head>
    <title>用户统计</title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_statistics.css')}">
</head>

<body>
<div class="program_statistics_content">
    <div class="statistics_time">
        <p class="t_present"><span class="t_today">今&nbsp;天</span><span class="t_weak">本&nbsp;周</span><span
                class="t_month">本&nbsp;月</span></p>

        <p class="t_chose"><input class="t_chose_star" value="起始日期">至<input class="t_chose_end" value="结束日期"></p>

        <p class="t_but"><input class="t_but_sear" type="button" value="查询"></p>
    </div>

    %{-- <div class="statistics_title">
         <p><span>点播统计</span><span>浏览统计</span><span>下载统计</span><span>推荐统计</span><span>收藏统计</span></p>
     </div>--}%

    <div class="statistics_title_infor">
        <p>本周点播统计结果。如下:%{--<a href="#">查看详细</a>--}%</p>
    </div>

    <div class="statistics_math">
        <div class="statistics_math_mark">

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
            </tr>
            <tr>
                <td align="center">1</td>
                <td align="left"><a href="#">本报告数据，来源于百度统计所覆盖的超过150万的站点，而不是baidu.com的流量数据</a></td>
                <td align="center">教育/英语/英语四级</td>
                <td align="center">vivoes</td>
                <td align="center">2014-05-06</td>
            </tr>   <tr>
                <td align="center">1</td>
                <td align="left"><a href="#">本报告数据，来源于百度统计所覆盖的超过150万的站点，而不是baidu.com的流量数据</a></td>
                <td align="center">教育/英语/英语四级</td>
                <td align="center">vivoes</td>
                <td align="center">2014-05-06</td>
            </tr>   <tr>
                <td align="center">1</td>
                <td align="left"><a href="#">本报告数据，来源于百度统计所覆盖的超过150万的站点，而不是baidu.com的流量数据</a></td>
                <td align="center">教育/英语/英语四级</td>
                <td align="center">vivoes</td>
                <td align="center">2014-05-06</td>
            </tr>   <tr>
                <td align="center">1</td>
                <td align="left"><a href="#">本报告数据，来源于百度统计所覆盖的超过150万的站点，而不是baidu.com的流量数据</a></td>
                <td align="center">教育/英语/英语四级</td>
                <td align="center">vivoes</td>
                <td align="center">2014-05-06</td>
            </tr>   <tr>
                <td align="center">1</td>
                <td align="left"><a href="#">本报告数据，来源于百度统计所覆盖的超过150万的站点，而不是baidu.com的流量数据</a></td>
                <td align="center">教育/英语/英语四级</td>
                <td align="center">vivoes</td>
                <td align="center">2014-05-06</td>
            </tr>   <tr>
                <td align="center">1</td>
                <td align="left"><a href="#">本报告数据，来源于百度统计所覆盖的超过150万的站点，而不是baidu.com的流量数据</a></td>
                <td align="center">教育/英语/英语四级</td>
                <td align="center">vivoes</td>
                <td align="center">2014-05-06</td>
            </tr>   <tr>
                <td align="center">1</td>
                <td align="left"><a href="#">本报告数据，来源于百度统计所覆盖的超过150万的站点，而不是baidu.com的流量数据</a></td>
                <td align="center">教育/英语/英语四级</td>
                <td align="center">vivoes</td>
                <td align="center">2014-05-06</td>
            </tr>
            </tbody>
        </table>

        <!------------分页------------->
        %{--  <div class="">
              <g:guiPaginate action="statisticsResource" class="all_page" controller="programMgr"
                             total="${downTotal}"/>
          </div>--}%
    </div>
</div>
</body>
</html>