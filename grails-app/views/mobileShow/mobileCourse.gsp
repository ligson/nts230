<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8"/>
    <r:require modules="jquery"></r:require>
    <r:layoutResources></r:layoutResources>
    <r:layoutResources></r:layoutResources>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile/css', file: 'mobile_course.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_index.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_views.css')}">
    <link rel="script" href="${resource(dir: 'js/mobile', file: 'mobile_views.js')}">
    <title>公开课</title>
</head>
<script type="text/javascript">
    $(function(){
        var boful_mobile_search_meau=$(".boful_mobile_search_meau");
        var boful_mobile_search_meau_list=$(".boful_mobile_search_meau_list");
        boful_mobile_search_meau.click(function(){
            if(boful_mobile_search_meau_list.css("display")=='none')
                boful_mobile_search_meau_list.css("display","block");
            else
                boful_mobile_search_meau_list.css("display","none");
        });
        $("#items_more").click(function(){
            var num=$("#max").val();
            var max=(num-0+0)*2;
            var url="${createLink(action: 'mobileAjaxCourse')}";
            $.ajax({
                url:url,
                data:"max="+max,
                success:function(data){
                    if(data.studyCount>num){
                        $("#max").val(num);
                    }else{
                        $("#max").val(max);
                    }
                    var coures_items=$("#boful_coures_items");
                    coures_items.empty().append(data.appendDiv);
                }
            })
        })
    })
</script>

<!-------导航-------->
<div class="boful_mobile_search_meau_list" style="display: none">
    <div class="gridContainer  clearfix">
        <g:each in="${programCategoryList}" var="programCatgory" status="sta">
            <div id="meau${sta % 6 + 1}" class="boful_mobile_search_meau_list1">
                <a href="${createLink(action: 'mobileSearch', params: [programcategoryId: programCatgory?.id])}">${programCatgory?.name}</a>
            </div>

        </g:each>
    </div>
</div>

<div class="boful_mobile_nav">
    <p id="touchId">
        <g:each in="${programCategoryList}" var="programCatgory" status="sta">
            <g:if test="${sta<3}">
                <a href="${createLink(action: 'mobileSearch',params: [programcategoryId:programCatgory?.id])}">${programCatgory?.name}</a>
            </g:if></g:each>
        <span class="boful_mobile_nav_more" title="更多"><a href="${createLink(action: 'mobileSearchMeau',params: [mediaType:'5'])}"></a></span>
    </p>
</div>
<!----------课程列表--------->
<div class="gridContainer  clearfix boful_coures_items">
    <div id="boful_coures_items">
    <g:each in="${publicStudyList}" var="program">
        <div class="boful_coures_item">
            <div class="boful_coures_item_img">
                <a href="${createLink(action: 'mobileCourseList',params: [id:program?.id])}" title="${program?.name}">
                    <img src="${posterLinkNew(program: program, size: '95x95')}" height="193"
                         onerror="this.src ='${resource(dir: 'skin/blue/mobile/images', file: 'boful_mobile_recommend_item_img.jpg')}'"/></a>
            </div>
            <div class="boful_coures_item_infors">
                <h4>${CTools.cutString(program?.name,15)}</h4>

                <p class="boful_coures_item_author"><span>讲师：</span><span>${program?.actor}</span></p>

                <p class="boful_coures_item_number"><span>${studyCourse(playedPrograms: program?.playedPrograms)}人在学习</span></p>
            </div>

            <div class="boful_coures_item_play">
                <a class="boful_coures_item_play_icon" href="${createLink(action: 'mobileCourseList',params: [id:program?.id])}" title="${program?.name}">去学习</a>
            </div>
        </div>
    </g:each></div>

    <div class="boful_coures_items_more" id="items_more">更多课程</div>
    <input type="hidden" id="max" value="${params.max}">

</div>
</body>
</html>
