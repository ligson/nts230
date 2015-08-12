<%@ page import="nts.utils.CTools" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="index"/>
    <title>学习社区公告</title>
    %{--<link href="${resource(dir: 'skin/blue/pc/front/css', file: 'uniform.default.css')}" rel="stylesheet"/>--}%
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'xindex.css')}" type="text/css"/>
</head>

<body>
<style>
    .wrap{
        width: 1024px;
        margin: 0 auto;
    }
    .boful_notice_show{
        background: #f0f5f5;
        width: 100%;
        height: 100%;
        min-height: 600px;
        display: block;
        overflow: hidden;
    }
    .boful_notice_show_titile{
        width: 1012px;
        height: 35px;
        color: #786b60;
        font-size: 16px;
        text-align: left;
        font-weight: bold;
        padding: 15px 0 0 10px;
        margin-top: 20px;
        border: #d1cd8c 1px dashed;
        background: #FFFDDB;
    }
    .boful_notice_show_titile a:hover{
        color: #db731b;
    }
</style>
<div class="boful_notice_show">
    <div class="boful_notice_show_titile wrap">
        <p>
            <b>当前位置：</b>
            <a href="${createLink(controller: 'community', action: 'index')}">学习社区</a>&nbsp;&gt;&nbsp;
            <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: studyCommunity?.id])}">${studyCommunity?.name}</a>&nbsp;&gt;&nbsp;
            <a href="#">通知公告</a>
        </p>
    </div>

    <div class="wrap center clear" style="background:#FFF;">
        <div class="tit719">${notice?.name}</div>

        <div class="titb719">发布时间: <g:formatDate
                format="yyyy-MM-dd" date="${notice?.dateCreated}"/>
        </div>

        <div class="conx719">${ CTools.htmlToBlank(notice?.description)}</div>

        <div class="close719"></div>
    </div>
</div>
</body>
</html>
