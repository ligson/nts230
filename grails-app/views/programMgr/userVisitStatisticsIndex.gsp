<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.text.SimpleDateFormat; nts.program.domain.Program; nts.utils.CTools" %>
<html>
<head>
    <title>用户统计首页</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'programstatistics_index.css')}">
    <r:require modules="highcharts"/>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/programMgr', file: 'userVisitStatistics.js')}"></script>
</head>

<body>
<div class="statistics_index_box">
    <div class="statistics_index_nav">
        <a href="${createLink(controller: 'programMgr', action: 'userVisitPlayNumStatistics')}"
           class="index_nav index_bg" title="查看点播详细">
            <div class="index_nav_box">
                <p class="nav_play_icon"></p>

                <p class="nav_icon_name">点播统计</p>
            </div>
        </a>
        <a href="${createLink(controller: 'programMgr', action: 'userVisitUploadNumStatistics')}" class="index_nav"
           title="查看上传详细">
            <div class="index_nav_box">
                <p class="nav_upload_icon "></p>

                <p class="nav_icon_name">上传统计</p>
            </div>
        </a>
        <a href="${createLink(controller: 'programMgr', action: 'userVisitDownloadNumStatistics')}" class="index_nav"
           title="查看下载详细">
            <div class="index_nav_box">
                <p class="nav_download_icon "></p>

                <p class="nav_icon_name">下载统计</p>
            </div>
        </a>
        <a href="${createLink(controller: 'programMgr', action: 'userVisitCollectNumStatistics')}" class="index_nav"
           title="查看收藏详细">
            <div class="index_nav_box">
                <p class="nav_save_icon"></p>

                <p class="nav_icon_name">收藏统计</p>
            </div>
        </a>
    </div>

    <div class="statistics_index_content">
        <div class="title_statistics">
            <label><input class="title_statistics_but" type="button" value="复位图表位置" onclick="reduceDiv()"></label>
        </div>

        <div id="userVisitplayNumId" class="datasheet_play_box">
            <h1>用户点播排行<a
                    href="${createLink(controller: 'programMgr', action: 'userVisitPlayNumStatistics')}">详&nbsp;细</a>
            </h1>

            <div id="userVisitplayNumRankId" class=" datasheet_play"></div>
        </div>

        <div id="userVisitUploadNumId" class="datasheet_play_box">
            <h1>用户上传排行<a
                    href="${createLink(controller: 'programMgr', action: 'userVisitUploadNumStatistics')}">详&nbsp;细</a>
            </h1>

            <div id="userVisitUploadNumRankId" class=" datasheet_play"></div>
        </div>

        <div id="userVisitDownloadNumId" class="datasheet_play_box">
            <h1>用户下载排行<a
                    href="${createLink(controller: 'programMgr', action: 'userVisitDownloadNumStatistics')}">详&nbsp;细</a>
            </h1>

            <div id="userVisitDownloadNumRankId" class=" datasheet_play"></div>
        </div>

        <div id="userVisitCollectNumId" class="datasheet_play_box">
            <h1>用户收藏排行<a
                    href="${createLink(controller: 'programMgr', action: 'userVisitCollectNumStatistics')}">详&nbsp;细</a>
            </h1>

            <div id="userVisitCollectNumRankId" class=" datasheet_play"></div>
        </div>
    </div>
</div>
</body>
</html>