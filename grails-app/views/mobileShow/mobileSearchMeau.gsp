<%@ page import="nts.program.category.domain.ProgramCategory" %>
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
        $(function () {
            $("#mobile_search").click(function () {
                var name = $("#name").val();
                window.location.href = baseUrl + "mobileShow/mobileSearch?name=" + name;
            })
            var len = $("#category .child_category").length;
            for (var i = 0; i < len; i++) {
                if (i == 0)
                    $("#category .child_category:eq(" + i + ")").show();
                else
                    $("#category .child_category:eq(" + i + ")").hide();
            }

            $(".boful_mobile_content_recommend").click(function () {
                var index = $("#category .boful_mobile_content_recommend").index(this);
                var categorySize=$(".child_category #categorySize:eq("+index+")").val();
                if(categorySize>0){
                    var child_category = $("#category .child_category:eq(" + index + ")").css("display");
                    if (child_category == 'none') {
                        $("#category .child_category:eq(" + index + ")").show("slow");
                    }
                    ;

                    if (child_category == 'block') {
                        $("#category .child_category:eq(" + index + ")").hide("slow");
                    }
                }

            })

        })
        function btn_label(tag){
            var programcategoryId=tag;
            window.location.href=baseUrl + "mobileShow/mobileSearch?programcategoryId="+tag;
        }
    </script>
</head>

<body>

<!--检索类别-->
<div class="clear"></div>
<div class="gridContainer clearfix" id="category">

    <g:each in="${secondCategoryList}" var="programCategory" status="sta">
    %{--<div class="fluid boful_mobile_search_item content_labe_list">
        <a href="${createLink(action: 'mobileSearch',params: [programcategoryId:programCategory?.id])}">${programCategory?.name}</a>
    </div>--}%
        <div class="boful_mobile_content_recommend">
            <h1 onclick="btn_label('${programCategory?.id}')"><span class="boful_mobile_content_label"></span>${programCategory?.name}</h1>
        </div>

        <div class="child_category">
            <input type="hidden" value="${ProgramCategory.findAllByParentCategory(programCategory).size()}" id="categorySize">
            <g:each in="${ProgramCategory.findAllByParentCategory(programCategory)}" var="cate">
                <div class="boful_mobile_search_item content_labe_list"><a
                        href="${createLink(action: 'mobileSearch', params: [programcategoryId: cate?.id])}">${cate?.name}</a>
                </div>
            </g:each>
        </div>
    </g:each>

</body>

</html>
