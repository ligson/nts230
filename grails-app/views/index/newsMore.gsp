<%@ page import="nts.utils.CTools" %>
<html>
<head>
    <title>学术资讯</title>
    <meta name="layout" content="index">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'admin_newsMore.css')}">
</head>

<body>
<div class="boful_news_content">
    <div class="boful_news_content_items">
        <div class="boful_news_content_items_head">学术资讯&nbsp;|&nbsp;<span
                class="boful_news_content_items_head_title">NEWS</span><span
                class="boful_news_content_items_head_second">收集最新鲜的资讯内容</span></div>
        <g:each in="${newsList}" var="news">
            <div class="boful_news_content_item">
                <div class="boful_news_content_item_title">
                    <h4>%{--<span class="boful_news_content_title_left"></span>--}%
                        <a href="${createLink(controller: 'index', action: 'showNews', params: [id: news.id])}"
                           target="_blank">${news.title}</a>
                        %{-- <span class="boful_news_content_title_right"></span>--}%
                        <p class="boful_news_content_item_title_second"><span
                                class="boful_news_user">${news.publisher}</span><span
                                class="boful_news_time"><g:formatDate date="${news.submitTime}" format="yyyy-MM-dd HH:mm:ss"/></span></p>
                    </h4>

                </div>

                <p class="boful_news_content_words">
                    ${CTools.cutString(CTools.htmlToBlank(news.content), 100)}
                </p>
            </div>
        </g:each>

    </div>

    <div class="boful_news_footer">
        <div class="page">
            <g:paginate offset="${params.offset}" total="${total}" action="newsMore"
                        params="${[offset: params.offset, sort: params.sort, order: params.order, max: params.max]}"/>
        </div>
    </div>
</div>
</body>
</html>