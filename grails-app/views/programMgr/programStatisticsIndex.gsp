<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.text.SimpleDateFormat; nts.program.domain.Program; nts.utils.CTools" %>
<html>
<head>
    <title>资源统计首页</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'programstatistics_index.css')}">
    <r:require modules="highcharts"/>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/programMgr', file: 'programStatisticsIndex.js')}"></script>
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

<div class="statistics_index_box">
    <div class="statistics_index_nav">
        <a href="${createLink(controller: 'programMgr', action: 'programFrequencyStatistics')}"
           class="index_nav index_bg" title="查看点播详细">
            <div class="index_nav_box">
                <p class="nav_play_icon"></p>

                <p class="nav_icon_name">点播排行</p>
            </div>
        </a>
        <a href="${createLink(controller: 'programMgr', action: 'programViewNumStatistics')}" class="index_nav"
           title="查看浏览详细">
            <div class="index_nav_box">
                <p class="nav_read_icon "></p>

                <p class="nav_icon_name">浏览排行</p>
            </div>
        </a>
        <a href="${createLink(controller: 'programMgr', action: 'programDownloadNumStatistics')}" class="index_nav"
           title="查看下载详细">
            <div class="index_nav_box">
                <p class="nav_download_icon "></p>

                <p class="nav_icon_name">下载统计</p>
            </div>
        </a>
        <a href="${createLink(controller: 'programMgr', action: 'programRecommendNumStatistics')}" class="index_nav"
           title="查看推荐详细">
            <div class="index_nav_box">
                <p class="nav_recommend_icon "></p>

                <p class="nav_icon_name">推荐统计</p>
            </div>
        </a>
        <a href="${createLink(controller: 'programMgr', action: 'programCollectNumStatistics')}" class="index_nav"
           title="查看收藏详细">
            <div class="index_nav_box">
                <p class="nav_save_icon"></p>

                <p class="nav_icon_name">收藏统计</p>
            </div>
        </a>
        %{--<input type="button" value="还原" onclick="reduceDiv()"/>--}%
    </div>

    <div class="statistics_index_content">
        <div class="title_statistics">
            <label><input class="title_statistics_but" type="button" value="复位图表位置" onclick="reduceDiv()"></label>
        </div>

        <div id="programFrequencyId" class="datasheet_play_box">
            <h1>资源点播排行<a
                    href="${createLink(controller: 'programMgr', action: 'programFrequencyStatistics')}">详&nbsp;细</a>
            </h1>

            <div id="programFrequencyRankId" class=" datasheet_play"></div>
        </div>

        <div id="programViewNumId" class="datasheet_play_box">
            <h1>资源浏览排行<a href="${createLink(controller: 'programMgr', action: 'programViewNumStatistics')}">详&nbsp;细</a>
            </h1>

            <div id="programViewNumRankId" class=" datasheet_play"></div>
        </div>

        <div id="programDownloadNumId" class="datasheet_play_box">
            <h1>资源下载排行<a
                    href="${createLink(controller: 'programMgr', action: 'programDownloadNumStatistics')}">详&nbsp;细</a>
            </h1>

            <div id="programDownloadNumRankId" class=" datasheet_play"></div>
        </div>

        <div id="programRecommendNumId" class="datasheet_play_box">
            <h1>资源推荐排行<a
                    href="${createLink(controller: 'programMgr', action: 'programRecommendNumStatistics')}">详&nbsp;细</a>
            </h1>

            <div id="programRecommendNumRankId" class=" datasheet_play"></div>
        </div>

        <div id="programCollectNumId" class="datasheet_play_box">
            <h1>资源收藏排行<a
                    href="${createLink(controller: 'programMgr', action: 'programCollectNumStatistics')}">详&nbsp;细</a>
            </h1>

            <div id="programCollectNumRankId" class=" datasheet_play"></div>
        </div>
    </div>
</div>
</body>
</html>