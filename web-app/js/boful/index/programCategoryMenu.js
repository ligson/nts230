/**
 * Created by ligson on 14-11-5.
 */
function cutNameString(name, len) {
    if (name) {
        return (name + "").substring(0, 4);
    } else {
        return "";
    }

}

function replaceNameString(name) {
    if (name) {
        if (name.indexOf("资源库") > -1) {
            return (name + "").replace("资源库", "资源");
        } else {
            return (name + "");
        }
    } else {
        return "";
    }

}

$(function () {
    //head 资源分类导航
    var headNavHtml = "";
    for (var m = 0; m < programCategoryTree.length; m++) {
        if (m > 3) {
            break;
        }
        var secondCategoryH = programCategoryTree[m];
        var href = baseUrl + "index/videoIndex?categoryId=" + secondCategoryH.id;
        if (secondCategoryH.mediaType == 1) { //视频
            href = baseUrl + "index/videoIndex?categoryId=" + secondCategoryH.id;
        } else if (secondCategoryH.mediaType == 2) { //音频
            href = baseUrl + "index/audioIndex?categoryId=" + secondCategoryH.id;
        } else if (secondCategoryH.mediaType == 3) { //文档
            href = baseUrl + "index/docIndex?categoryId=" + secondCategoryH.id;
        } else if (secondCategoryH.mediaType == 4) { //图片
            href = baseUrl + "index/imageIndex?categoryId=" + secondCategoryH.id;
        } else if (secondCategoryH.mediaType == 5) { //课程
            href = baseUrl + "index/courseIndex?categoryId=" + secondCategoryH.id;
        } else if (secondCategoryH.mediaType == 6) { //flash动画
            href = baseUrl + "index/flashIndex?categoryId=" + secondCategoryH.id;
        }
        var headName = secondCategoryH.name;
        if (headName.length > 4) {
            headName = headName.substring(0, 4);
        }
        headNavHtml += "<div class=\"nav_item\" ><a class=\"font16\" target='_blank' title=" + secondCategoryH.name + " href=" + href + ">" + headName + "</a></div>";
    }

    if (programCategoryTree.length > 4) {
        headNavHtml += "<div class=\"nav_item\" id=\"nav_item_more\" >";
        headNavHtml += "<a class=\"font16 dis-more dis-btm\" href=\"javascript:void(0);\">更多</a>";
        headNavHtml += "<div class=\"mar-top\" style=\"display: block\">";
        for (var n = 4; n < programCategoryTree.length; n++) {
            var secondCategoryHId = programCategoryTree[n].id;
            var mediaType = programCategoryTree[n].mediaType;
            var href = baseUrl + "index/videoIndex?categoryId=" + secondCategoryHId;
            if (mediaType == 1) { //视频
                href = baseUrl + "index/videoIndex?categoryId=" + secondCategoryHId;
            } else if (mediaType == 2) { //音频
                href = baseUrl + "index/audioIndex?categoryId=" + secondCategoryHId;
            } else if (mediaType == 3) { //文档
                href = baseUrl + "index/docIndex?categoryId=" + secondCategoryHId;
            } else if (mediaType == 4) { //图片
                href = baseUrl + "index/imageIndex?categoryId=" + secondCategoryHId;
            } else if (mediaType == 5) { //课程
                href = baseUrl + "index/courseIndex?categoryId=" + secondCategoryHId;
            } else if (mediaType == 6) { //flash动画
                href = baseUrl + "index/flashIndex?categoryId=" + secondCategoryHId;
            }
            headNavHtml += "<div class=\"sub-item\" style=\"display: none;\" ><a class=\"font16 hov-f\"  title=" + programCategoryTree[n].name + " target='_blank' href=" + href + ">" + programCategoryTree[n].name + "</a></div>"
        }
        headNavHtml += "</div></div>"
    }

    $(".hnavcorl1").append(headNavHtml);


    var menuHtml = "<div class=\"bf-cla-it\"><a href=\"" + baseUrl + "\">全部资源</a></div>";
    var displayCss = "";

    var pathname = window.location.pathname;
    if (pathname.indexOf("index/index") == -1) {
        displayCss = "style=\"display:none;\"";
    }
    if(pathname=="/"||pathname=="/index.html"){
        displayCss = "style=\"display:block;\"";
    }

    menuHtml += "<div class=\"bf-cla-boxs\" " + displayCss + " >";
    for (var i = 0; i < programCategoryTree.length; i++) {
        if (i > 5) {
            continue;
        }
        var secondCategory = programCategoryTree[i];


        menuHtml += "<div class=\"bf-cla-item\">";

        if (secondCategory.childCategoryList.length > 0) {
            menuHtml += "<div class=\"bf-cla-sub\" style=\"display:none\">";
            for (var j = 0; j < secondCategory.childCategoryList.length; j++) {
                if (j > 6) {
                    continue;
                }
                var thirdCategory = secondCategory.childCategoryList[j];


                menuHtml += "<div class=\"bf-cla-sub-item\">";

                //two
                menuHtml += "<div class=\"bf-sub-l\">";
                menuHtml += "<a href=\"" + baseUrl + "index/search?programCategoryId=" + thirdCategory.id + "\" title=\"" + thirdCategory.name + "\">" + cutNameString(thirdCategory.name, 4) + "</a>";
                menuHtml += "</div>";


                //three
                menuHtml += "<div class=\"bf-sub-r\">";
                for (var k = 0; k < thirdCategory.childCategoryList.length; k++) {
                    var firthCategory = thirdCategory.childCategoryList[k];
                    menuHtml += "<a href=" + baseUrl + "index/search?programCategoryId=" + firthCategory.id + " title=\"" + firthCategory.name + "\">" + cutNameString(firthCategory.name, 4) + "</a><span>|</span>";
                }
                menuHtml += " </div>";

                menuHtml += "</div>";
            }
            menuHtml += "</div>";
        }


        //one
        var href = baseUrl + "index/videoIndex?categoryId=" + secondCategory.id;
        if (secondCategory.mediaType == 1) { //视频
            href = baseUrl + "index/videoIndex?categoryId=" + secondCategory.id;
        } else if (secondCategory.mediaType == 2) { //音频
            href = baseUrl + "index/audioIndex?categoryId=" + secondCategory.id;
        } else if (secondCategory.mediaType == 3) { //文档
            href = baseUrl + "index/docIndex?categoryId=" + secondCategory.id;
        } else if (secondCategory.mediaType == 4) { //图片
            href = baseUrl + "index/imageIndex?categoryId=" + secondCategory.id;
        } else if (secondCategory.mediaType == 5) { //课程
            href = baseUrl + "index/courseIndex?categoryId=" + secondCategory.id;
        } else if (secondCategory.mediaType == 6) { //flash动画
            href = baseUrl + "index/flashIndex?categoryId=" + secondCategory.id;
        }


        menuHtml += "<h1><a target='_blank' class=\"h-clo\"  href=" + href + " title=\"" + secondCategory.name + "\">" + replaceNameString(secondCategory.name) + "</a></h1>";

        //two
        menuHtml += "<p>";
        for (var h = 0; h < secondCategory.childCategoryList.length; h++) {
            if (h > 2) {
                continue;
            }
            var thirdCategory1 = secondCategory.childCategoryList[h];
            menuHtml += "<a class=\"h-clo\"  href=" + baseUrl + "index/search?programCategoryId=" + thirdCategory1.id + " title=\"" + thirdCategory1.name + "\" >" + cutNameString(thirdCategory1.name, 4) + "</a>";
        }
        menuHtml += "</p>";


        menuHtml += "</div>";

    }
    menuHtml += "</div>";
    $(".bf-cla-items").append(menuHtml);

    //显示

    $(".bf-cla-it").mouseenter(function () {
        $(this).parent().find(".bf-cla-boxs").fadeIn();
    });


    $(".bf-cla-boxs").mouseleave(function () {
        if (pathname.indexOf("index/index") == -1&&pathname!="/"&&pathname!="/index.html") {
            $(".bf-cla-boxs").fadeOut();
        }

    });

    //分类

    $(".bf-cla-item").mouseenter(function () {
        var tagetItem = $(this).find(".bf-cla-sub");
        $(".bf-cla-sub").hide();
        tagetItem.show();
        //alert($(this).parent().find(".h-clo"));
        //console.log($(this).find(".h-clo").html());
        //console.log($(this).parent().find(".h-clo")[0]);
        $(this).find(".h-clo").css("color", "white");
        //alert($(this).parent().css( "color","white"));
        //$(this).parent().css( "color","white")


    });

    $(".bf-cla-item").mouseleave(function () {
        $(this).find(".h-clo").css("color", "#333");
        $(".bf-cla-sub").hide();
    });

    $(".bf-cla-sub").mouseleave(function () {
        //if(window.location.pathname.indexOf("index/index")==-1){
        $(".bf-cla-sub").hide();

        //}
    });

    //头部导航栏鼠标事件
    var navItemMore = $("#nav_item_more");
    if (navItemMore) {
        navItemMore.mouseenter(function () {
            $(this).find("a").removeClass("dis-btm").addClass("dis-top")
            $(this).find("div").attr("style", "display:block");
        });

        navItemMore.mouseleave(function () {
            $(".dis-more").addClass("dis-btm")
            $(this).find("div").attr("style", "display:none");
        });
    }
});

