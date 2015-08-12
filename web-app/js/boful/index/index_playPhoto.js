/**
 * Created by ligson on 13-12-21.
 */
function resizePlayPhotoUI() {
    var win = $(window);
    var photoBanner = $(".boful_photo_banner");
    var photoMain = $(".boful_photo_banner_main");
    var photoRight = $(".boful_photo_banner_right");

    var player = $(".boful_photo_player_player");
    var title = $(".boful_photo_player_title");
    var inner_img=$(".boful_photo_inner img");
    $(".boful_photo_inner").css("width",(inner_img.length+1)*65);

    if (win.width() > 1024) {

        photoBanner.css("width", win.width());
        photoMain.css("width", win.width() - photoRight.width());
        player.css("width", photoMain.width());

        title.css("width", player.width());


    }
    if (win.height() > 768) {
        photoBanner.css("height", win.height());
        photoMain.css("height", win.height());
        photoRight.css("height", win.height());
        player.css("height", photoMain.height()-50);
    }

}
$(function () {
    resizePlayPhotoUI();
    $(window).resize(function () {
        resizePlayPhotoUI();
    });
    var tabs = $(".boful_photo_tabs").find("span");
    var tabContents = $(".boful_photo_content>div");
    tabs.hover(function () {
        var index = tabs.index($(this));
        for (var i = 0; i < tabContents.length; i++) {
            if (index == i) {
                $(tabContents[i]).show();
            } else {
                $(tabContents[i]).hide();
            }
        }
    });

    var boxImages = $(".boful_photo_player_img").find("img");
    var imageIndex = 0;
    var prev = $(".boful_photo_prev");
    var next = $(".boful_photo_next");
    prev.click(function () {
        boxImages.hide();
        if(boxImages.length==1){
            imageIndex=1;
            showImage(boxImages, imageIndex, imageIndex - 1);
        }else{
            if(imageIndex<=0)imageIndex=boxImages.length-1;
            var afterIndex = imageIndex - 1;
            if ((afterIndex >= 0) && (afterIndex <= boxImages.length - 1)) {
                showImage(boxImages, imageIndex, imageIndex - 1);
                imageIndex--;
            }
        }


    });
    next.click(function () {
        boxImages.hide();
        if(boxImages.length==1){
            imageIndex=1;
            showImage(boxImages, imageIndex, imageIndex - 1);
        }else{
            if(boxImages.length<=imageIndex+1)imageIndex=0;
            var afterIndex = imageIndex + 1;
            if ((afterIndex >= 0) && (afterIndex <= boxImages.length - 1)) {
                showImage(boxImages, imageIndex, imageIndex + 1);
                imageIndex++;
            }
        }


    });

    var imageList = $(".boful_photo_list").find("img");
    imageList.click(function () {
        boxImages.hide();
        var index = imageList.index($(this));
        showImage(boxImages, imageIndex, index);
        imageIndex = index;
    });
    $(".boful_photo_player_list_packup").click(function(){
        $(".boful_photo_banner_right").toggle();
    });
});
function showImage(images, beforeIndex, index) {
    if ((index >= 0) && (index <= images.length - 1)) {
        $(images[index]).fadeIn("slow");
    }
}