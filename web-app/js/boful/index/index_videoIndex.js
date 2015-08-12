/**
 * Created by ligson on 13-12-21.
 */
function resizeUI() {
    var win = $(window);
    var imgBox = $(".boful_img_box");
    var videoBanner = $(".boful_video_banner");

    if (win.width() > 1024) {
        imgBox.css("width", win.width());
        videoBanner.css("width", win.width());
    }

    var imgContainer = $(".boful_img_container");
    var imgBottom = $(".boful_img_bottom");


    imgBottom.css("left", imgContainer.offset().left + 50);
    imgBottom.css("top", imgContainer.offset().top + (imgContainer.height() - imgBottom.height() - 25));
}
$(function () {
    try{
        resizeUI();
        $(window).resize(function () {
            resizeUI();
        });
    }catch(e){
    }


    $(".boful_img_bottom").show();
    var imgArr=$(".boful_img_container").find("img");
    imgArr.ready(function(){
        $(".boful_img_container").css("visibility","visible");
    })

    var screenshots = $(".boful_item_screenshots").find("img");
    var posterImages = $(".boful_img_items").find("img");
    var itemTitles = $(".boful_item_titles").find(".boful_item_title");

    var beforeIndex = 0;


    screenshots.hover(function () {
        var index = screenshots.index($(this));
        showItemTitle(itemTitles, index);
        showPosterImage(posterImages, beforeIndex, index);
        beforeIndex = index;
    });

    /*----播放-------*/
    $(".boful_video_item ").hover(function () {
        $(this).find(".boful_recommond_video_item_play").css("visibility", "visible");
    });
    $(".boful_video_item").mouseleave(function () {
        $(this).find(".boful_recommond_video_item_play").css("visibility", "hidden");
    });


});

function showPosterImage(items, beforeIndex, index) {
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
function showItemTitle(items, index) {
    for (var i = 0; i < items.length; i++) {
        if (i != index) {
            $(items[i]).hide();
        } else {
            $(items[i]).show();
        }
    }
}