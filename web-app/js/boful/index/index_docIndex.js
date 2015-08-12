/**
 * Created by ligson on 13-12-21.
 */

//function resizeImgBoxUI() {
//    var imgScroll = $(".doc_nav_img_scroll");
//    var imgBox = $(".doc_nav_image_box");
//    var top = imgBox.offset().top + 300;
//    var left = imgBox.offset().left + 600;
//    imgScroll.css("top", top);
//    imgScroll.css("left", left);
//}
$(function () {
//    resizeImgBoxUI();
//
//    $(window).resize(function () {
//        resizeImgBoxUI();
//    });

//    var imgScroll = $(".doc_nav_img_scroll");
//    var imgSpans = imgScroll.find("span");
//    //var imageItems = $(".doc_nav_image_box").find(".doc_nav_image_item");
//
//    imgSpans.click(function () {
//        var index = imgSpans.index($(this));
//        var imgViewer = $(".nav_scorll_img_container");
//        imgViewer.animate({"marginLeft":-index*710});
//        /*for (var i = 0; i < imageItems.length; i++) {
//            if (i == index) {
//                $(imageItems[i]).show();
//            } else {
//                $(imageItems[i]).hide();
//            }
//        }*/
//    });

    $(".boful_doc_item").hover(function(){
        $(this).find(".boful_recommond_doc_reading").css("visibility","visible");
    });
    $(".boful_doc_item").mouseleave(function(){
        $(this).find(".boful_recommond_doc_reading").css("visibility","hidden");
    });

});