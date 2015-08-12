<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <r:require modules="jquery"></r:require>
    <r:layoutResources></r:layoutResources>
    <r:layoutResources></r:layoutResources>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_search_index.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_search_views.css')}">
    <link rel="script" href="${resource(dir: 'js/mobile', file: 'mobile_views.js')}">
    <title>搜索</title>
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
 <script type="text/javascript">
    var localObj = window.location;
    var contextPath = localObj.pathname.split("/")[1];
    var baseUrl = '';
    if ('nts' != contextPath) {
        baseUrl = localObj.protocol + "//" + localObj.host + "/";
    } else {
        baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
    }

    $(function(){

        $("#mobile_search").click(function(){
            var name=$("#name").val();
            window.location.href=baseUrl + "mobileShow/mobileSearch?name="+name;
        })

        $("#footer").click(function(){
            var url="${createLink(action: 'mobileAjaxSearch')}";
            var max=$("#max").val()-0+6;
            var name="${params?.name}";
            $.post(url,{max:max,name:name},function(data){
                $("#max").val(data.max);
                var program_div=$("#program_div");
                var boful_mobile_recommend_item=$(".boful_mobile_recommend_item");
                var appendHtml='';
                var programList=data.programList;
                program_div.empty().append(data.appendHtml);
            })
        })

    })
 </script>
</head>

<body>
<div class="boful_mobile_searchbox ">
    <input type="hidden" id="max">
    %{--<div class="boful_mobile_back">
         <p>
         <a href="${createLink(action: 'index')}">
         <span class="boful_mobile_comeback" title="返回"></span></a>
         <span class="boful_mobile_home"></span>
         </p>
    </div>--}%
    <div class="boful_mobile_search">
        <input class="boful_mobile_search_input" id="name" name="name" type="text" value="${params?.name}">
        <input class="boful_mobile_search_button" type="button" id="mobile_search">
    </div>
</div>

<!--检索类别-->
%{--<div class="gridContainer clearfix">
    <div class="boful_mobile_content_recommend">
        <h1>推荐资源<span class="boful_mobile_content_label"></span></h1>
    </div>
    <g:each in="${programCategoryList}" var="programCategory" status="sta">
         <div id="div${sta%6}" class="fluid boful_mobile_search_item">
             <a href="#">${programCategory?.name}</a>
         </div>
    </g:each>

</div>--}%
    %{--<div>
       <div>
           资源分类:<g:each in="${firstCategory}" var="programcategory">
               <a href="${createLink(action: 'mobileSearch',params: [programcategoryId:programcategory?.id,name:params?.name])}">${programcategory?.name}</a>
           </g:each>
       </div>
        <div>
            类库:<g:each in="${directoryList}" var="directory">
                <a href="${createLink(action: 'mobileSearch',params: [classLibId:directory?.id,name:params?.name])}">${directory?.name}</a>
            </g:each>
        </div>
        <div>
            媒体类型:<g:each in="${nts.program.category.domain.ProgramCategory?.mediaTypeCn}" var="mediaType">
            <g:if test="${(mediaType?.key!=0)&(mediaType?.key!=2)}">
                <a href="${createLink(action: 'mobileSearch',params: [mediaType:mediaType?.key,name:params?.name])}">${mediaType?.value}</a>
            </g:if>
        </g:each>
        </div>
        <div>
           热门标签:<g:each in="${programTagList}" var="tag">
               <a href="${createLink(action: 'mobileSearch',params: [programTagId:tag?.id,name:params?.name])}">${tag?.name}</a>
           </g:each>
        </div>
    </div>--}%
    <!--展示资源-->
<div class="gridContainer clearfix">
<g:if test="${programList.size()==0}"><div class="not_find">
<p>未找到相关资源!</p></div></g:if>
<div id="program_div">
<g:each in="${programList}" var="program" status="sta">
    <div id="div${sta%6}" class="fluid boful_mobile_recommend_item">
        <a href="${createLink(action: 'mobileShow',params: [id:program?.id])}" title="${program?.name}">

            <img src="${posterLinkNew(program: program, size: '289x289')}"
                 onerror="this.src ='${resource(dir: 'skin/blue/mobile/images', file: 'boful_mobile_recommend_item_img.jpg')}'"/>
            <p>${CTools.cutString(program?.name,5)}</p>
        </a>
    </div>
</g:each>
</div>
%{--<div style="margin-top: 20px;display: block;overflow: hidden;text-align: center" id="program_div">
<g:each in="${programList}" var="program" status="sta">
    <div id="search_div">
        <a href="${createLink(action: 'mobile_video_show',params: [id:program?.id])}" title="${program?.name}">

            <img src="${posterLinkNew(program: program, size: '289x289')}"
                 onerror="this.src ='${resource(dir: 'skin/blue/mobile/images', file: 'boful_mobile_recommend_item_img.jpg')}'"/>
            <p>${nts.utils.CTools.cutString(program?.name,4)}</p>
        </a>
    </div>
</g:each>
</div>--}%
<div id="footer" class="footer_more" style="width: 100%;float: left;cursor: pointer">
    查看更多
</div>

</body>
</html>
