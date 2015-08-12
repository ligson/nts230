<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <r:require modules="jquery"></r:require>
    <r:layoutResources></r:layoutResources>
    <r:layoutResources></r:layoutResources>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_doc_index.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_index.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_views.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_doc_views.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_video_img.css')}">
    <link rel="script" href="${resource(dir: 'js/mobile', file: 'mobile_views.js')}">
    <title>${docName}</title>
    <!--
To learn more about the conditional comments around the html tags at the top of the file:
paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/

Do the following if you're using your customized build of modernizr (http://www.modernizr.com/):
* insert the link to your js here
* remove the link below to the html5shiv
* add the "no-js" class to the html tags at the top
* you can also remove the link to respond.min.js if you included the MQ Polyfill in your modernizr build
-->
    <!--[if lt IE 9]>
 <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
</head>
<script type="text/javascript" src="${resource(dir: 'skin/blue/mobile', file: 'mobile_video.js')}"></script>
<script type="text/javascript">
    $(function () {
        var boful_mobile_search_meau = $(".boful_mobile_search_meau");
        var boful_mobile_search_meau_list = $(".boful_mobile_search_meau_list");
        boful_mobile_search_meau.click(function () {
            if (boful_mobile_search_meau_list.css("display") == 'none')
                boful_mobile_search_meau_list.css("display", "block");
            else
                boful_mobile_search_meau_list.css("display", "none");
        })

    })
</script>

<body>
<!-----------图标切换-------------->
<div class="boful_mobile_icon">
    <a class="boful_mobile_icon_video" href="${createLink(action: 'mobileVideoIndex')}"></a>
    <a class="boful_mobile_icon_doc" href="${createLink(action: 'mobileDocIndex')}"></a>
    <a class="boful_mobile_icon_images" href="${createLink(action: 'mobileImagesIndex')}"></a>
</div>
<!----------导航--------------->
<div class="boful_mobile_search_meau_list" style="display: none">
    <div class="gridContainer  clearfix">
        <g:each in="${programCategoryList}" var="programCatgory" status="sta">
            <div id="meau${sta % 6 + 1}" class="boful_mobile_search_meau_list1">
                <a href="${createLink(action: 'mobileSearch', params: [programcategoryId: programCatgory?.id])}">${programCatgory?.name}</a>
            </div>

        </g:each>
    </div>
</div>
<!----------------结束----------------->
%{--<div class="boful_mobile_searchbox ">
    <div class="boful_mobile_search">
        <div class="boful_mobile_logo">
            <img src="${resource(dir: 'skin/blue/mobile/images',file: 'boful_mobile_logo.png')}"/>
        </div>
        <span class="boful_mobile_search_meau"></span>
        <a href="${createLink(action: 'mobileSearch')}">
        <span class="boful_mobile_search_button"></span></a>
    </div>
</div>--}%

<div class="boful_mobile_nav">
    <p>
        <g:each in="${programCategoryList}" var="programCategory" status="sta">
            <g:if test="${sta < 3}">
                <a href="${createLink(action: 'mobileSearch', params: [programcategoryId: programCategory?.id])}">${programCategory?.name}</a>
            </g:if>

        </g:each>
        <span class="boful_mobile_nav_more"><a
                href="${createLink(action: 'mobileSearchMeau', params: [mediaType: '3'])}"></a></span>
    </p>
</div>
<!--头部切换图片-->
<div class="boful_mobile_bananr">
    <div class="boful_image_box">
        <g:each in="${newDoc}" var="program">
            <div class="img1_inner">
                <a class="boful_mobile_bananr1"
                   href="${createLink(action: 'mobileDocPlay', params: [id: program?.id])}">
                    <img src="${posterLinkNew(program: program, size: '1024x425')}"
                         onerror="this.src = '${resource(dir: 'skin/blue/mobile/images', file: 'boful_mobile_bananr1.jpg')}'"/>
                </a>
            </div>
        </g:each>
    </div>

    <div class="boful_inner_div">
        <g:each in="${newDoc}" var="program">
            <div style="padding-top: 0.6em">
                <span class="boful_mobile_bananr_new">NEW</span>
                <span class="boful_mobile_bananr_title">${CTools.cutString(program?.name, 10)}</span>
            </div>
        </g:each>
    </div>
</div>

<div class="gridContainer clearfix">
    <div class="boful_mobile_content_recommend">
        <h1>推荐资源</h1>
        <a class="boful_mobile_content_more" href="${createLink(action: 'mobileSearch')}"></a>
    </div>

    <g:each in="${recommendDocList}" var="program" status="sta">
        <div id="div${sta}" class="fluid boful_mobile_recommend_item" style="background: none; box-shadow: none">
            <a href="${createLink(action: 'mobileDocPlay', params: [id: program?.id])}" title="${program?.name}">
                <div class="boful_mobile_recommend_item_name">${CTools.cutString(program?.name, 5)}</div>
                <img style="height: 9.375em"
                     src="${resource(dir: 'skin/blue/mobile/images', file: 'boful_mobile_recommend_doc_item_img.png')}"/>
            </a>
        </div>
    </g:each>

</div>

</div>
</body>
</html>
