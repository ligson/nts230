<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="index"/>
    <title>新闻公告</title>
    %{--<link href="${resource(dir: 'skin/blue/pc/front/css', file: 'uniform.default.css')}" rel="stylesheet"/>--}%
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_common.css')}"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'xindex.css')}" type="text/css"/>
</head>

<body>
<div class="boful_news_show">
    <div class="boful_news_show_titile wrap">
        <p>
            <b>当前位置：</b>
            <a href="${createLink(controller: 'index', action: 'newsMore', params: [type: 'new'])}">学术资讯</a>&nbsp;&gt;&nbsp;
            <a href="${createLink(controller: 'index', action: 'showNews', params: [id: fieldValue(bean: news, field: 'id')])}">${fieldValue(bean: news, field: 'title')}</a>
        </p>
    </div>

    <div class="wrap center clear" style="background:#FFF;">
        <div class="tit719">${fieldValue(bean: news, field: 'title')}</div>

        <div class="titb719">发布人:${fieldValue(bean: news, field: 'publisher')}        发布时间: <g:formatDate
                format="yyyy-MM-dd" date="${news.submitTime}"/>
        </div>

        <div class="conx719">${news.content}</div>

        <div class="close719"></div>
    </div>
</div>
</body>
</html>
