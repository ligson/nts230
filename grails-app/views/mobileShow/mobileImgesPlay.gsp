<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
   %{-- <r:require modules="jquery"></r:require>
    <r:layoutResources></r:layoutResources>
    <r:layoutResources></r:layoutResources>--}%
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_img_play.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_imges_views_play.css')}">
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
        $(function(){
            $("#mobile_search").click(function(){
                var name=$("#name").val();
                window.location.href=baseUrl + "mobileShow/mobileSearch?name="+name;
            })
        })
    </script>
</head>

<body>
%{--
<div class="boful_mobile_searchbox ">
    <div class="boful_mobile_back">
        <p>
            <a href="${createLink(action: 'mobileImagesIndex')}">
            <span class="boful_mobile_comeback"></span></a>
            <span class="boful_mobile_home"></span>
        </p>
    </div>
</div>
--}%

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

<!--展示资源-->
<div class="gridContainer clearfix">
    <g:each in="${program?.serials}" var="serial" status="sta">
        <div id="div${sta}" class="fluid boful_mobile_images_infor">
            <a href="javascript:void(0)" onclick="img_btn('${mobilePlayLink(fileHash: serial?.fileHash,isPdf:false)}')">
                <img src="${posterLinkNew(serial: serial, size: '292x193')}" height="193"
                     onerror="this.src = '${resource(dir: 'skin/blue/mobile/images',file: 'boful_mobile_searchbox_bg.jpg')}'"/>
                <p>${CTools.cutString(serial?.name,8)}</p>
            </a>
        </div>
    </g:each>

</div>
<script type="text/javascript">
    function img_btn(address){
        try{
            window.JSInterface.playImage(address);
        }catch(e){

        }
    }
</script>
</body>
</html>
