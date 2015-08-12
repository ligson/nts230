/**
 * Created by ligson on 13-12-21.
 */
function resizePlayVideoUI() {
    var win = $(window);
    var videoBanner = $(".boful_video_banner");
    var videoMain = $(".boful_video_banner_main");
    var videoRight = $(".boful_video_banner_right");

    var player = $(".boful_video_player_player");
    var title = $(".boful_video_player_title");


    if (win.width() > 1024) {
        videoBanner.css("width", win.width());
        videoMain.css("width", win.width() - videoRight.width());
        player.css("width", videoMain.width() - 50);
        title.css("width", player.width());
    }
    console.log(win.height());
    if (win.height() > 700) {
        videoBanner.css("height", win.height());
        videoMain.css("height", win.height());
        videoRight.css("height", win.height());

        player.css("height", videoMain.height() - 200);
    }
}
$(function () {
    resizePlayVideoUI();
    $(window).resize(function () {
        resizePlayVideoUI();
    });
    var tabs = $(".boful_video_tabs").find("span");
    var tabContents = $(".boful_video_content>div");
    tabs.hover(function(){
        var index = tabs.index($(this));
        for(var i = 0;i<tabContents.length;i++){
            if(index==i){
                $(tabContents[i]).show();
            }else{
                $(tabContents[i]).hide();
            }
        }
    });
});