/**
 * Created by ligson on 13-12-21.
 */
//function resizeUI() {
//    var win = $(window);
//    var imgBox = $(".boful_img_box");
//    var videoBanner = $(".boful_video_banner");
//
//    if (win.width() > 1024) {
//        imgBox.css("width", win.width());
//        videoBanner.css("width", win.width());
//    }
//
//    var imgContainer = $(".boful_img_container");
//    var imgBottom = $(".boful_img_bottom");
//
//
//    //imgBottom.css("left", imgContainer.offset().left + 50);
//    //imgBottom.css("top", imgContainer.offset().top + (imgContainer.height() - imgBottom.height() - 25));
//}
//var beforeIndex = 0;
//var imgwidth = $(window).width();
//
//$(function () {
//    resizeUI();
//    $(window).resize(function () {
//        resizeUI();
//    });
//    $(".boful_img_bottom").show();
//    var imgArr = $(".boful_img_container").find("img");
//    imgArr.ready(function () {
//        $(".boful_img_container").css("visibility", "visible");
//    });
//
//    var screenshots = $(".boful_item_screenshots").find("span");
//    var posterImages = $(".boful_img_items").find("img");
//    var itemTitles = $(".boful_item_titles").find(".boful_item_title");
//
//
//    screenshots.hover(function () {
//        var index = screenshots.index($(this));
//        showItemTitle(itemTitles, index);
//        showPosterImage(posterImages, beforeIndex, index);
//        beforeIndex = index;
//    });
//
//    /*----播放-------*/
//    $(".boful_video_item ").hover(function () {
//        $(this).find(".boful_recommond_video_item_play").css("visibility", "visible");
//    });
//    $(".boful_video_item").mouseleave(function () {
//        $(this).find(".boful_recommond_video_item_play").css("visibility", "hidden");
//    });
//
//    $(".boful_img_bottom_tab span").click(function () {
//        var index = $(".boful_img_bottom_tab span").index($(this));
//        //alert(index);
//        var currentIndex = beforeIndex;
//        if (index == 0) {
//            beforeIndex--;
//        } else {
//            beforeIndex++;
//        }
//        if (beforeIndex >= 0 && beforeIndex <= screenshots.length) {
//            showPosterImage(posterImages, currentIndex, beforeIndex);
//        }
//
//    });
//
//
//});
//
//function convertPosterImageTimer() {
//    var currentIndex = beforeIndex;
//    beforeIndex++;
//
//    var posterImages = $(".boful_img_items").find("img");
//
//    if (beforeIndex >= 0 && beforeIndex <= posterImages.length) {
//        showPosterImage(posterImages, currentIndex, beforeIndex);
//    } else {
//        beforeIndex = 0;
//    }
//}
//
//setInterval("convertPosterImageTimer()",5000);
////function showPosterImage(items, beforeIndex, index) {
////    for (var i = 0; i < items.length; i++) {
////        if (!((i == beforeIndex) || (i == index))) {
////            $(items[i]).hide();
////        }
////    }
////    if (beforeIndex != index) {
////        $(items[beforeIndex]).fadeOut("slow", function () {
////            $(items[index]).fadeIn("slow");
////        });
////    }
////}
////2014-06-17
//function showPosterImage(items, beforeIndex, index) {
//
//    for (var i = 0; i < items.length; i++) {
//        if (!((i == beforeIndex) || (i == index))) {
//            $(items[index]).css({'right':-imgwidth});
//            $(items[i]).hide();
//            $(items[beforeIndex]).animate({'right':0},500, function () {
//                $(items[index]).show();
//                $(items[index]).css({'right':imgwidth});
//            });
//        }
//    }
////    if (beforeIndex != index) {
////        $(items[beforeIndex]).animate({'right':0},500, function () {
////            $(items[index]).show();
////            $(items[index]).css({'right':imgwidth});
////        });
////    }
//}
//function showItemTitle(items, index) {
//    for (var i = 0; i < items.length; i++) {
//        if (i != index) {
//            $(items[i]).hide();
//        } else {
//            $(items[i]).show();
//        }
//    }
//}
//$(document).ready(function () {
//    $(".audio_hot_item").bind("mouseover", function () {
//        if (!$(this).children(".hot_play_number")[0].hidden) {
//            $(this).children(".hot_play_number").hide(350);
//            $(this).children(".hot_item_operate").show(350);
//        }
//    })
//    $(".audio_hot_item").bind("mouseleave", function () {
//        $(".hot_item_operate").hide(350);
//        $(".hot_play_number").show(350);
//    })
//})
//$(document).ready(function () {
//    $(".audio_rank_items p").bind("mouseover", function () {
//        if (!$(this).children(".right_rank_user")[0].hidden) {
//            $(this).children(".right_rank_user").hide(350);
//            $(this).children(".rank_item_operate").show(350);
//        }
//    })
//    $(".audio_rank_items p").bind("mouseleave", function () {
//        $(".rank_item_operate").hide(350);
//        $(".right_rank_user").show(350);
//    })
//})
$(function(){
    var $banner=$('.banner1');
    var $banner_ul=$('.banner-img');
    var $btn=$('.banner-btn');
    var $btn_a=$btn.find('a')
    var v_width=$banner.width();

    $(window).resize(function () {

        var win = $(window);
        v_width = win.width();
        var cirLeft=$('.banner-circle').width()*(-0.5);
        $('.banner-circle').css({'margin-Left':cirLeft});
        $('.banner-img').animate({left:0});
        //$('.banner-img').animate({left:'-='+v_width},"slow");
        $('.banner-img li').css({'width':v_width});
        $('.banner-img').width(5*v_width);
    });

    var page=1;

    var timer=null;
    var btnClass=null;

    var page_count=$banner_ul.find('li').length;//把这个值赋给小圆点的个数

    var banner_cir="<li class='selected' href='#'><a></a></li>";
    for(var i=1;i<page_count;i++){
        //动态添加小圆点
        banner_cir+="<li><a href='#'></a></li>";
    }
    $('.banner-circle').append(banner_cir);

    var cirLeft=$('.banner-circle').width()*(-0.5);
    $('.banner-circle').css({'margin-Left':cirLeft});
    $('.banner-img li').css({'width':v_width});
    //$('.banner-img li img').css({'width':v_width,'height':400});
    $banner_ul.width(page_count*v_width);

    function move(obj,classname){
        //手动及自动播放
        if(!$banner_ul.is(':animated')){
            if(classname=='prevBtn'){
                if(page==1){
                    $banner_ul.animate({left:-v_width*(page_count-1)});
                    page=page_count;
                    cirMove();
                }
                else{
                    $banner_ul.animate({left:'+='+v_width},"slow");
                    page--;
                    cirMove();
                }
            }
            else{
                if(page==page_count){
                    $banner_ul.animate({left:0});
                    page=1;
                    cirMove();
                }
                else{
                    $banner_ul.animate({left:'-='+v_width},"slow");
                    page++;
                    cirMove();
                }
            }
        }
    }

    function cirMove(){
        //检测page的值，使当前的page与selected的小圆点一致
        $('.banner-circle li').eq(page-1).addClass('selected')
            .siblings().removeClass('selected');
    }

    $banner.mouseover(function(){
        $btn.css({'display':'block'});
        clearInterval(timer);
    }).mouseout(function(){
        $btn.css({'display':'block'});
        clearInterval(timer);
        timer=setInterval(move,3000);
    }).trigger("mouseout");//激活自动播放

    $btn_a.mouseover(function(){
        //实现透明渐变，阻止冒泡
        $(this).animate({opacity:0.6},'fast');
        $btn.css({'display':'block'});
        return false;
    }).mouseleave(function(){
        $(this).animate({opacity:0.3},'fast');
        $btn.css({'display':'none'});
        return false;
    }).click(function(){
        //手动点击清除计时器
        btnClass=this.className;
        clearInterval(timer);
        timer=setInterval(move,3000);
        move($(this),this.className);
    });

    $('.banner-circle li').on('click',function(){
        var index=$('.banner-circle li').index(this);
        $banner_ul.animate({left:-v_width*index},'slow');
        page=index+1;
        cirMove();
    });
});
