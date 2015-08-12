/**
 * Created by ligson on 13-12-20.
 */
function resizeUI() {

    //设置最外边的宽
    var container = $(".boful_img_box");
    if ($(window).width() >= 1024) {
        container.css("width", $(window).width());
    } else {
        container.css("width", 1024);
    }

    var container_img = $(".boful_container_img");


    var container_bottom = $(".boful_container_bottom");
    container_bottom.css("left", parseInt(container_img.offset().left + 50));
    container_bottom.css("top", parseInt(container_img.offset().top + 280));

    var right = $(".boful_container_right");
    right.css("left", container_img.offset().left + container_img.width() - right.width());
    right.css("top", container_img.offset().top);

    var itemTitle = $(".boful_item_title_content");
    itemTitle.css("left", container_img.offset().left + 25);
    itemTitle.css("top", container_img.offset().top + 150);


    var contentHeader = $(".boful_content_header");
    var contentItem = $(".boful_content_item");
    if ($(window).width() >= 1024) {
        contentHeader.css("width", $(window).width());
        contentItem.css("width", $(window).width());
    } else {
        contentHeader.css("width", 1024);
        contentItem.css("width", 1024);
    }


}

/**
 *资源库加载
 * @param categoryId
 * @param target
 * @param index
 */
function loadProgram(categoryId, target, index) {
    $.ajax({
        url: baseUrl + "mobileApp/programQuery",
        data: "categoryId=" + categoryId,
        success: function (data) {
            var className = data.className;
            var programList = data.programList;
            var mType = data.mType;

            if (index > 0) {
                $(target).addClass("hide");
            } else {
                $(target).attr("style", "block");
            }
            var proItem = $("#proItem").children().eq(0);
            if (programList && programList.length > 0) {
                for (var i = 0; i < programList.length; i++) {
                    var proItemCopy = proItem.clone();
                    proItemCopy.attr("style", "block");
                    proItemCopy.addClass("boful_" + className + "_item");
                    proItemCopy.attr("title", programList[i].name);
                    if (className == "video") {
                        proItemCopy.attr("onmouseenter", "showVideoPlayIcon(this)");
                        proItemCopy.attr("onmouseleave", "hideVideoPlayIcon(this)");
                    }
                    if (className != "doc") {//资源类型不是文档
                        if (mType != 4) { //不是图片
                            proItemCopy.find("#proItemPlay").addClass("boful_recommond_" + className + "_item_play");
                            proItemCopy.find("#proItemPlayHref").attr("href", baseUrl + "program/showProgram?id=" + programList[i].id);
                        } else {
                            proItemCopy.find("#proItemPlay").remove();
                        }

                        proItemCopy.find("#proItemData").addClass("boful_recommond_" + className + "_item_date");
                        proItemCopy.find("#proItemData").append("共" + programList[i].serialNum + "个");
                    } else {
                        proItemCopy.find("#proItemPlay").remove();
                        proItemCopy.find("#proItemData").remove();
                    }

                    proItemCopy.find("#proItemHref").attr("href", baseUrl + "program/showProgram?id=" + programList[i].id);

                    var size = "";
                    if (className == "doc") {
                        size = "97x123";
                    } else {
                        size = "160x100";
                    }
                    proItemCopy.find("#proItemHref").find("img").addClass("imgLazy program_poster");
                    proItemCopy.find("#proItemHref").find("img").attr("name", "posterImg");
                    proItemCopy.find("#proItemHref").find("img").attr("posterId", programList[i].id);

                    proItemCopy.find("p").find("a").attr("href", baseUrl + "program/showProgram?id=" + programList[i].id)
                    var proName = programList[i].name;
                    if (programList[i].name.length > 10) {
                        proName = programList[i].name.substring(0, 10);
                    }
                    proItemCopy.find("p").find("a").append(proName);
                    proItemCopy.appendTo($(target));
                }
            } else {
                $(target).append("<strong>此分类下目前没有资源！</strong>");
            }
            $(document).dequeue();
        }
    });
}

function hideVideoPlayIcon(target) {
    var itemPlay = $(target).find(".boful_recommond_video_item_play");
    itemPlay.css("visibility", "hidden");
}
function showVideoPlayIcon(target) {
    var itemPlay = $(target).find(".boful_recommond_video_item_play");
    itemPlay.css("visibility", "visible");
}

$(function () {
    resizeUI();
    $(window).resize(function () {
        resizeUI();
    });

    $(".boful_item_title_content").show();
    $(".boful_container_bottom .boful_item_img").show();
    $(".boful_container_right").show();
    var imgArr = $(".boful_img_box_container").find("img");
    imgArr.ready(function () {
        $(".boful_img_box_container").css("visibility", "visible");
    });

    $(".boful_ui_tab_title span").hover(function () {
        var index = $(".boful_ui_tab_title span").index($(this));
        var tabItem = $(".boful_ui_tab_content .boful_ui_tab_item");
        if (index == 0) {

            $(".boful_ui_tab_title_bottom_line").animate({'marginLeft': 45}, 200, function () {
                $(tabItem[1]).hide();
                $(tabItem[0]).show();
            });
        } else {
            $(".boful_ui_tab_title_bottom_line").animate({'marginLeft': 145}, 200, function () {
                $(tabItem[0]).hide();
                $(tabItem[1]).show();
            });
        }
    });
    var itemImg = $(".boful_item_img");
    itemImg.mouseover(function () {
        //$(this).css("marginTop",);
        $(this).css({marginTop: 10});
    });
    itemImg.mouseout(function () {
        $(this).css({marginTop: 20});
    });


    var images = [];
    var el = $(".boful_item img");
    for (var i = 0; i < el.size(); i++) {
        images[i] = el[i];
    }

    var titles = $(".boful_item_title");

    var beforeIndex = 0;
    showItemIndex(images, beforeIndex, 0);


    $(".boful_container_bottom").find(".boful_item_img").hover(function () {
        var index = $(".boful_container_bottom").find(".boful_item_img").index($(this));
        showItemIndex(images, beforeIndex, index);
        showItemTitle(titles, index);
        beforeIndex = index;
    });
    /*------------视频播放--------------*/
    $(".boful_video_item").hover(function () {
        $(this).find(".boful_recommond_video_item_play").css("visibility", "visible");
    });
    $(".boful_video_item").mouseleave(function () {
        $(this).find(".boful_recommond_video_item_play").css("visibility", "hidden");
    });


    /*------文档---------*/
    $(".boful_doc_item").hover(function () {
        $(this).find(".boful_recommond_doc_reading").css("visibility", "visible");
    });
    $(".boful_doc_item").mouseleave(function () {
        $(this).find(".boful_recommond_doc_reading").css("visibility", "hidden");
    });
    /*--------图片-----*/
    $(".boful_photo_itme").hover(function () {
        $(this).find(".boful_photo_itme_see").css("visibility", "visible");
    });
    $(".boful_photo_itme").mouseleave(function () {
        $(this).find(".boful_photo_itme_see").css("visibility", "hidden");
    });

    //全文检索判断
    $.post(baseUrl + "mobileApp/searchEnable", function (data) {
        if (data.success) {
            if (data.searchEnable) {
                $(".right_search").attr("style", "display:block");
            } else {
                $(".right_search").attr("style", "display:none");
            }
        } else {
            $(".right_search").attr("style", "display:none");
        }
    });

    $(document).queue(function () {
        loadBofulContainerImg();
        $(this).dequeue();
    });

//加载热门资源
//    var remUl = $("#bf-banners").children().eq(0);
//    loadRemenProgram(remUl);
    //加载视频推荐资源
    var videoTemplate = $("#video_inner_program");
    //loadVideoProgram(videoTemplate);
    //加载文档推荐资源
    var wendangTemplate = $("#carousel").find("ul");
//    loadDocProgram(wendangTemplate);

    //加载最新视频
    $(document).queue(function () {
        $.post(baseUrl + "mobileApp/programSearch", {
            orderBy: "dateCreated",
            order: "desc",
            max: 12,
            offset: 0,
            otherOption: 0,
            canPublic: true,
            state: 5
        }, function (data) {
            if (data.success) {
                if (data.programList.length == 0) {
                    $("#video_inner").hide();
                    $(".boful_recommond_title_cut").hide();
                } else {
                    $.each(data.programList, function (index, program) {
                        var htmlString = "<div class=\"boful_video_item\" title=\"" + program.name + "\" onmouseenter=\"showVideoPlayIcon(this)\" onmouseleave=\"hideVideoPlayIcon(this)\">";
                        /*           htmlString+="<div class=\"boful_recommond_video_item_play\">";
                         htmlString+="<a href=\""+baseUrl+"program/showProgram?id="+program.id+"\" target=\"_blank\"><img style=\"box-shadow: none\" src=\"/skin/blue/pc/front/images/boful_recommond_video_item_play_icon.png\"> </a>";
                         htmlString+="</div>";*/

                        htmlString += "<a href=\"" + baseUrl + "program/showProgram?id=" + program.id + "\" target=\"_blank\">";
                        htmlString += "<img name=\"videoProster\" src=\"" + baseUrl + "images/boful_default_img.png\" width=\"160\" height=\"100\" onerror=\"this.src = '" + baseUrl + "images/boful_default_img.png'\">";
                        htmlString += "</a>";

                        htmlString += "<div class=\"boful_recommond_video_name\">";
                        htmlString += "<a href=\"" + baseUrl + "program/showProgram?id=" + program.id + "\" target=\"_blank\">" + program.name + "</a>";
                        htmlString += "</div>";
                        htmlString += "</div>";
                        videoTemplate.append(htmlString);

                        $.post(baseUrl + "mobileApp/programPoster", {
                            width: 160,
                            height: 100,
                            id: program.id
                        }, function (data2) {
                            if (data2.success) {
                                $(videoTemplate.find("img[name='videoProster']")[index]).attr("src", data2.url);
                            }
                        });
                    });
                }
            }
            $(document).dequeue();
        });
    });

    //加载最新文档
    $(document).queue(function () {
        $.post(baseUrl + "mobileApp/programSearch", {
            orderBy: "dateCreated",
            order: "desc",
            max: 12,
            offset: 0,
            otherOption: 8,
            canPublic: true,
            state: 5
        }, function (data) {
            if (data.success) {
                var total = data.programList.length;
                if (total == 0) {
                    $(".boful_recommond_doc").hide();
                    if (!$("#video_inner").is(":visible")) {
                        $(".boful_content_header_container").hide();
                    }
                } else {
                    var indexSize = 0;
                    $.each(data.programList, function (index, program) {
                        var htmlString = "<li class=\"boful_doc_item\" title=\"" + program.name + "\">";
                        htmlString += "<div class=\"boful_recommond_doc_item_infor_hot\">热门</div>";
                        htmlString += "<div class=\"boful_recommond_doc_item_infor\">共" + program.serialNum + "个</div>";
                        htmlString += "<a href=\"" + baseUrl + "program/showProgram/" + program.id + "\" target=\"_blank\">";
                        htmlString += "<img src=\"" + baseUrl + "images/boful_default_img.png\" width=\"97\" height=\"127\" class=\"imgLay\" href=\"" + baseUrl + "program/showProgram/" + program.id + "\" target=\"_blank\" onerror=\"this.src = '" + baseUrl + "images/boful_default_img.png'\">";
                        htmlString += "</a>";
                        htmlString += "<div class=\"boful_recommond_video_name\">";
                        htmlString += "<a href=\"" + baseUrl + "program/showProgram/" + program.id + "\" target=\"_blank\">" + program.name + "</a>";
                        htmlString += "</div>";
                        htmlString += "</li>";
                        wendangTemplate.append(htmlString);

                        $.post(baseUrl + "mobileApp/programPoster", {
                            width: 160,
                            height: 100,
                            id: program.id
                        }, function (data2) {
                            if (data2.success) {
                                $(wendangTemplate.find("img")[index]).attr("src", data2.url);
                            }
                        });

                        indexSize++;
                        if (indexSize == total) {

                            //头部推荐
                            $('#carousel ul').carouFredSel({
                                items: 6,
                                prev: '#prev',
                                next: '#next',
                                pagination: "#pager",
                                scroll: 2000
                            });
                        }
                    });
                }
            }
            $(document).dequeue();
        });
    });

    //分类的最新资源标签
    var categoryContentContainer = $(".container-fuil");

    $.each(programCategoryTree, function (index, category) {
        var htmlString = "";
        if (index % 2 == 0) {
            htmlString = "<div class=\"boful_content_item\" style=\"background:#f4f4f4\">";
        } else {
            htmlString = "<div class=\"boful_content_item\">";
        }

        htmlString += "           <div class=\"boful_content_container width-doc\">";
        htmlString += "               <div class=\"boful_video_left\">";
        htmlString += "                   <div class=\"left-cla-tit\">";
        htmlString += "                       <h2>";
        if (category.mediaType == 1) {
            htmlString += "                           <a target='_blank' href=\"" + baseUrl + "index/videoIndex?categoryId=" + category.id + "\">" + category.name + "</a>";
        } else if (category.mediaType == 2) {
            htmlString += "                           <a target='_blank' href=\"" + baseUrl + "index/audioIndex?categoryId=" + category.id + "\">" + category.name + "</a>";
        } else if (category.mediaType == 3) {
            htmlString += "                           <a target='_blank' href=\"" + baseUrl + "index/docIndex?categoryId=" + category.id + "\">" + category.name + "</a>";
        } else if (category.mediaType == 4) {
            htmlString += "                           <a target='_blank' href=\"" + baseUrl + "index/imageIndex?categoryId=" + category.id + "\">" + category.name + "</a>";
        } else if (category.mediaType == 5) {
            htmlString += "                           <a target='_blank' href=\"" + baseUrl + "index/courseIndex?categoryId=" + category.id + "\">" + category.name + "</a>";
        } else if (category.mediaType == 6) {
            htmlString += "                           <a target='_blank' href=\"" + baseUrl + "index/flashIndex?categoryId=" + category.id + "\">" + category.name + "</a>";
        }
        htmlString += "                       </h2>";
        htmlString += "                   </div>";
        htmlString += "                   <div class=\"left-cla-big\">";
        htmlString += "                       <div class=\"left-cla-t\">";
        if (category.description) {
            htmlString += "                           <p>" + category.description + "</p>";
        } else {
            htmlString += "                           <p>" + category.name + "</p>";
        }

        htmlString += "                       </div>";
        var imgSrc = baseUrl + "skin/blue/pc/front/images/resource_img_1.png";
        if (category.mediaType == 1) {
            htmlString += "                       <a target='_blank' href=\"" + baseUrl + "index/videoIndex?categoryId=" + category.id + "\">";
            imgSrc = baseUrl + "skin/blue/pc/front/images/resource_img_1.png";
        } else if (category.mediaType == 2) {
            htmlString += "                       <a target='_blank' href=\"" + baseUrl + "index/audioIndex?categoryId=" + category.id + "\">";
            imgSrc = baseUrl + "skin/blue/pc/front/images/resource_img_1.png";
        } else if (category.mediaType == 3) {
            htmlString += "                       <a target='_blank' href=\"" + baseUrl + "index/docIndex?categoryId=" + category.id + "\">";
            imgSrc = baseUrl + "skin/blue/pc/front/images/resource_img_2.png";
        } else if (category.mediaType == 4) {
            htmlString += "                       <a target='_blank' href=\"" + baseUrl + "index/imageIndex?categoryId=" + category.id + "\">";
            imgSrc = baseUrl + "skin/blue/pc/front/images/resource_img_2.png";
        } else if (category.mediaType == 5) {
            htmlString += "                       <a target='_blank' href=\"" + baseUrl + "index/courseIndex?categoryId=" + category.id + "\">";
            imgSrc = baseUrl + "skin/blue/pc/front/images/resource_img_3.png";
        } else if (category.mediaType == 6) {
            htmlString += "                       <a target='_blank' href=\"" + baseUrl + "index/flashIndex?categoryId=" + category.id + "\">";
            imgSrc = baseUrl + "skin/blue/pc/front/images/resource_img_1.png";
        }
        htmlString += "                            <img src=\"" + baseUrl + "upload/programCategoryImg/i_" + category.id + ".jpg\" width=\"220\" height=\"385\" onerror=\"this.src = '" + imgSrc + "'\" />";
        htmlString += "                        </a>";
        htmlString += "                   </div>";
        htmlString += "               </div>";
        htmlString += "               <div class=\"boful_video_mid\">";
        htmlString += "                   <div class=\"box tab-cut\">";
        htmlString += "                       <ul class=\"tab_menu\" menuId=\"" + category.id + "\">";
        $.each(category.childCategoryList, function (index2, childCategory) {
            if (index2 < 6) {
                htmlString += "                           <li><a cid=\"" + childCategory.id + "\" href=\"" + baseUrl + "index/search?programCategoryId=" + childCategory.id + "\">" + childCategory.name + "</a> </li>";
            }
        });
        if (category.childCategoryList.length > 6) {
            htmlString += "                           <li><a class=\"con-more\" href=\"" + baseUrl + "index/search\">更多</a></li>";
        }
        htmlString += "                       </ul>";
        htmlString += "                   </div>";
        htmlString += "               </div>";
        htmlString += "           </div>";
        htmlString += " </div>";
        categoryContentContainer.append(htmlString);
    });


    //加载资源库
    var template = $("#programTemplate").children().eq(0);
    var menuArr = $(".tab_menu");
    $.each(menuArr, function (index, data) {
        var categoryIds = $(data).find("a");
        var menuId = $(data).attr("menuId");
        var programCopy;
        var tabbox = $("<div class='tab_box'></div>");
        $.each(categoryIds, function (cIndex, category) {
            var templateCopy = template.clone();
            var categoryId = $(category).attr("cid");
            if (categoryId) {
                $(document).queue(function () {
                    loadProgram(categoryId, templateCopy, cIndex);
                });
                $(document).queue(function () {
                    tabbox.append(templateCopy);
                    $(this).dequeue();
                });
            }
        });
        $(document).queue(function () {
            if (tabbox.children().size() == 0) {
                tabbox.append("<strong>此资源库下目前没有资源！</strong>");
            }
            $(data).parent().append(tabbox);
            $(this).dequeue();
        });
    });

    // 加载资源图片
    $(document).queue(function () {
        $("img[name=posterImg]").each(function () {
            var pId = $(this).attr("posterId");
            var imgObj = this;
            var height = $(this).height();
            var width = $(this).width();
            $.post(baseUrl + "mobileApp/programPoster", {width: width, height: height, id: pId}, function (data) {
                if (data.success) {
                    if (data.url.indexOf('/images/flash/flash-imgs.png') < 0) {
                        $(imgObj).attr("src", data.url);
                    } else {
                        $(imgObj).attr("src", data.url);
                    }

                }
            });
        });
    });

    $(".tab_menu").find("li").mouseenter(function () {
        var parent = $(this).parent("ul");
        var index = parent.find("li").index($(this));
        var tabBox = parent.next();
        tabBox.find(">div").hide();
        $(tabBox.find(">div")[index]).show();
    });


    $.post(baseUrl + "mobileApp/newsList", {max: 4}, function (data) {
        var newsContainer = $("#cla-voices");
        if (data.success) {
            var htmlString = "";
            $.each(data.newsList, function (index, news) {
                htmlString = "<p title=\"" + news.title + "\">";
                htmlString += "<span><em>■</em></span>";
                htmlString += "<a href=\"" + baseUrl + "index/showNews/" + news.id + "\">" + news.title + "</a></p>";
                newsContainer.append(htmlString);
            });

        }
    });


    $.post(baseUrl + "mobileApp/sysNotice", {}, function (data) {
        if (data.success) {
            $(".cla-news").find("i").empty().append(data.notice);
        }
    });


});


function showItemTitle(items, index) {
    for (var i = 0; i < items.length; i++) {
        if (i != index) {
            $(items[i]).hide();
        } else {
            $(items[i]).show();
        }
    }
}
function showItemIndex(items, beforeIndex, index) {
    for (var i = 0; i < items.length; i++) {
        if (!((i == beforeIndex) || (i == index))) {
            $(items[i]).hide();
        }
    }
    if (beforeIndex != index) {
        $(items[beforeIndex]).fadeOut("slow", function () {
            $(items[index]).fadeIn("slow");
        });
    }

}


function next_btn() {
    var inner = document.getElementById("video_inner");
    var inner_program = document.getElementById("video_inner_program");
    var index = $("#video_inner_program").find(".boful_video_item").length;
    if (index > 6) {
        $("#video_inner").animate({"scrollLeft": "+=170px"}, 100);
    }
}
function prior_btn() {
    var inner = document.getElementById("video_inner");
    var inner_program = document.getElementById("video_inner_program");
    $("#video_inner").animate({"scrollLeft": "-=170px"}, 100);
}

$(function () {
    $("#search_input").click(function () {
        $("#search_input").val('');
    });
    $(".imgLazy").lazyload({
        effect: "fadeIn"
    });

    var navItems = $(".nav_items").find(".nav_item");
    navItems.click(function () {
        $.cookie("index_nav_id", null, {path: "/"});
        $.cookie("index_nav_id", $(this).attr("id"), {path: "/"});
    });
    var navId = $.cookie("index_nav_id");
    if (navId) {
        $("#" + navId).find("a").css("Color", "#53a93f");
    }

    $("#returnTop").click(function () {
        $("body,html").animate({scrollTop: 0}, 1000);
        return false;
    });
    /*
     $(".boful_footer_code_small1").click(function () {

     if ($("#footerCode").css("display") == "block")
     $("#footerCode").hide("slow");
     else
     $("#footerCode").show("slow");

     });
     */
    var user_meau_sub_list = $(".user_meau_sub_list");
    var show_my = $("#show_my");

    $("#show_my").mousemove(function () {
        $(".user_meau_sub_list").show();
        if (user_meau_sub_list.css("display") == "block") {
            user_meau_sub_list.css("left", show_my.offset().left);
        }
    });
    $(".wrap").mouseleave(function () {
        $(".user_meau_sub_list").hide();
    });

});

function resizeIndexBaseUI() {
    var toolbar = $(".boful_toolbar");
    var bofulLogo = $(".boful_logo");
    var headerNav = $(".header_nav");
    var footer = $(".boful_footer");
    var copyRight = $(".foot_copyright");
    var win = $(window);
    if (win.width() >= 1024) {
        toolbar.css("width", win.width());
        bofulLogo.css("width", win.width());
        headerNav.css("width", win.width());
        footer.css("width", win.width());
        copyRight.css("width", win.width());
    } else {
        toolbar.css("width", 1024);
        bofulLogo.css("width", 1024);
        headerNav.css("width", 1024);
        footer.css("width", 1024);
        copyRight.css("width", 1024);
    }
}
$(function () {
    resizeIndexBaseUI();
    $(window).resize(function () {
        resizeIndexBaseUI();
    });
});

function loadBofulContainerImg() {
    var imgArr = $(".boful_item").find("img");
    var len = imgArr.length;
    var loadCount = 0;
    if (len == 0) {
        $(".boful_item_loading").hide();
    }
    $.each(imgArr, function (index, data) {

        $(data).load(function () {
            //alert($(this).attr("src"));
            loadCount++;
            if (loadCount >= len / 2) {
                $(".boful_item_loading").hide();
                $(".boful_item").show();
            }
        });
    });


    $.post(baseUrl + "mobileApp/programSearch", {
        offset: 0,
        max: 10,
        canPublic: true,
        state: 5,
        orderBy: "recommendNum",
        order: "desc"
    }, function (data) {
        var ulContainer = $("#bf-banners").find(".slides");
        var total = data.programList.length;
        var indexSize = 0;
        $.each(data.programList, function (index, program) {
            var htmlString = "<li title=\"" + program.name + "\">";
            htmlString += "<a target=\"_blank\" href=\"/program/showProgram/" + program.id + "\">";
            htmlString += "<img src=\"/images/boful_default_img.png\"/></a>";
            htmlString += "</li>";
            ulContainer.append(htmlString);
            $.post(baseUrl + "mobileApp/programPoster", {width: 564, height: 280, id: program.id}, function (data2) {
                if (data2.success) {
                    $(ulContainer.find("img")[index]).attr("src", data2.url);
                }

            });
            indexSize++;
            if (indexSize == total) {
                //头部banner
                $('.flexslider').flexslider({
                    directionNav: true,
                    pauseOnAction: false
                });
            }
        });
    });


    //头部通知公告和资讯切换
    $(".cla-t-v").click(function () {
        $(".cla-t-v").addClass("c-cli");
        $(".cla-t-n").removeClass("c-cli");
        $(".cla-voices").hide();
        $(".cla-news").show();
    });

    $(".cla-t-n").click(function () {
        $(".cla-t-n").addClass("c-cli");
        $(".cla-t-v").removeClass("c-cli");
        $(".cla-voices").show();
        $(".cla-news").hide();
    });


}

$(function () {
    //修改音频背景颜色不显示
    $("#hotAudio").css("background", "#1771AC");
    $(".caroufredsel_wrapper").css("width", "940px");
});