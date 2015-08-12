<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/index.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/index_views.css')}">
    <link rel="script" href="${resource(dir: 'js/mobile', file: 'mobile_views.js')}">
    <title></title>
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

<body>
%{--<div class="boful_mobile_searchbox ">
    <div class="boful_mobile_search">
        <div class="boful_mobile_logo">
            <img src="${resource(dir: 'skin/blue/mobile/images', file: 'boful_mobile_logo.png')}"/>
        </div>
        --}%%{--<span class="boful_mobile_search_meau"></span>--}%%{--
        <a href="${createLink(action: 'mobileSearch')}">
        <span class="boful_mobile_search_button1" title="搜索"></span></a>
    </div>
</div>--}%

<div class="gridContainer clearfix">
    <div class="boful_mobile_content_recommend">

    </div>

    <div id="div7" class="fluid boful_mobile_content_recommend boful_mobile_recommend_item red_bg">
        <h1 class="boful_mobile_content_recommend_icon6">
            <a href="${createLink(action: 'mobileCourse')}" style="color: #FFF">开放课程</a>
        </h1>
        %{--<a class="boful_mobile_content_more">MORE</a>--}%
    </div>
    <g:each in="${publicStudyList}" var="program" status="sta">
        <div id="div${sta+2}" class="fluid boful_mobile_recommend_item size">
            <a href="${createLink(action: 'mobileCourseList',params: [id:program?.id])}" title="${program?.name}">
                <img src="${posterLinkNew(program: program, size: '292x193')}" height="7.5em"
                     onerror="this.src = '${resource(dir: 'skin/blue/mobile/images', file: 'boful_mobile_bananr1.jpg')}'"/>
                <p>${CTools.cutString(program?.name,5)}</p>
            </a>
        </div>
    </g:each>

    <div id="div1" class="fluid boful_mobile_content_recommend boful_mobile_recommend_item red">
        <h1 class="boful_mobile_content_recommend_icon">
            <a href="${createLink(action: 'mobileVideoIndex')}" style="color: #FFF">${videoName}</a>
        </h1>
        %{--<a class="boful_mobile_content_more">MORE</a>--}%
    </div>
    <g:each in="${videoList}" var="program" status="sta">
        <div id="div${sta+2}" class="fluid boful_mobile_recommend_item size">
            <a href="${createLink(action: 'mobileVideoShow',params: [id:program?.id])}" title="${program?.name}">
                <img src="${posterLinkNew(program: program, size: '292x193')}" height="7.5em"
                     onerror="this.src = '${resource(dir: 'skin/blue/mobile/images', file: 'boful_mobile_bananr1.jpg')}'"/>
                <p>${CTools.cutString(program?.name,5)}</p>
            </a>
        </div>
    </g:each>
<!-----------教学素材--------------->
    <div id="div13" class="fluid boful_mobile_content_recommend boful_mobile_recommend_item blue">
        <h1 class="boful_mobile_content_recommend_icon2">
            <a href="${createLink(action: 'mobileImagesIndex')}" style="color: #FFF">${photoName}</a>
        </h1>
        %{--<a class="boful_mobile_content_more">MORE</a>--}%
    </div>
    <g:each in="${recommendImageList}" var="program" status="sta">
        <div id="div${sta+14}" class="fluid boful_mobile_recommend_item size">
            <a href="${createLink(action: 'mobileImagesPlay',params: [id:program?.id])}" title="${program?.name}">
                <img src="${posterLinkNew(program: program, size: '292x193')}" height="7.5em"
                     onerror="this.src = '${resource(dir: 'skin/blue/mobile/images', file: 'boful_mobile_bananr1.jpg')}'"/>
                <p>${CTools.cutString(program?.name,5)}</p>
            </a>
        </div>
    </g:each>
  <!-------------共享资料----------------->
    <div id="div7" class="fluid boful_mobile_content_recommend boful_mobile_recommend_item green">
        <h1 class="boful_mobile_content_recommend_icon1">
            <a href="${createLink(action: 'mobileDocIndex')}" style="color: #FFF">${docName}</a>
        </h1>
        %{--<a class="boful_mobile_content_more">MORE</a>--}%
    </div>
    <g:each in="${recommendVideoList}" var="program" status="sta">
        <div id="div${sta+8}" class="fluid boful_mobile_recommend_item doc_size" style="background: none; box-shadow: none">
            <a href="${createLink(action: 'mobileDocPlay',params: [id:program?.id])}" title="${program?.name}">
                <div class="boful_doc_item"><img src="${posterLinkNew(program:program,size:'93x45')}" onerror="this.src='${resource(dir: 'skin/blue/mobile/images',file: 'boful_mobile_recommend_item_img.jpg')}'"/></div>
                <div class="boful_mobile_recommend_item_infor">${CTools.cutString(program?.name,5)}</div>
                <img src="${resource(dir: 'skin/blue/mobile/images', file: 'boful_mobile_recommend_doc_item_img.png')}" />
            </a>
        </div>
    </g:each>



</div>





</body>
</html>
