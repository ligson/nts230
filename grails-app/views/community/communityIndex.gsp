<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <meta name="layout" content="communityIndexLayout">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index_tab.css')}">
    <title>${studyCommunity.name}</title>
</head>

<body>
<div class="c_index_tab">
<!-------------帖子------->

    <g:each in="${articleList}" var="article">
        <div class="c_index_form">

            <div class="c_f_user">
                <a href=""><img src="${generalUserPhotoUrl(consumer: article.createConsumer)}"/></a>

                <div class="c_f_user_back">${article.forumReplyArticle.size()}</div>
            </div>

            <div class="c_index_form_in">
                <h2>
                    <g:if test="${article.isTop}">
                        <span>置顶</span>
                    </g:if>
                    <g:if test="${article.isElite}">
                        <span>精华贴</span>
                    </g:if>
                    <a
                            href="${createLink(controller: 'community', action: 'communityArticle', params: [id: article.id])}">${article.name}</a>
                </h2>

                <div class="c_in_word">${nts.utils.CTools.htmlToBlank(article.description)}</div>

                <p><span><a
                        href="${createLink(controller: 'my', action: 'userSpace', params: [id: article.createConsumer.id])}">${consumerName(id: article.createConsumer.id)}</a>
                </span><span>${article.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</span></p>
            </div>
        </div>
    </g:each>
</div>
    <div class="f_page">
        <g:guiPaginate controller="community" action="communityIndex" total="${total}" params="${params}" max="20"/>
    </div>
</body>
</html>