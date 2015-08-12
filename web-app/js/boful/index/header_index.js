$(function(){
    var img1_inner=$(".img1_inner");
    var boful_image_box=$(".boful_image_box");
    var img1_content=$(".img1_content");
    var img1_border=$(".img1_border");
    img1_inner.show();
    img1_content.show();
    img1_border.show();
   /* img1_inner.css("left",boful_image_box.position().left);
    img1_content.css("left",boful_image_box.position().left+boful_image_box.width()-165);
    img1_content.css("top",boful_image_box.position().top+boful_image_box.height()-20);
    img1_border.css("top",boful_image_box.position().top+boful_image_box.height()-50);
    img1_border.css("left",boful_image_box.position().left);*/
    var j = 0;
    $(".img1_content div").mouseover(function(){
        $(".img1_content div").css("background-color","#fff");
        $(this).css("background-color","#006666");
        var index=$(".img1_content div").index(this);
        for(var n=0;n<4;n++){
            if (n == index) {
                $(".img1_inner img:eq(" + n + ")").show();
                $(".img1_border div:eq(" + n + ")").show();
                continue;
            }
            $(".img1_inner img:eq(" + n + ")").hide();
            $(".img1_border div:eq(" + n + ")").hide();
        }
    });
    $(".img1_content div").mouseout(function(){
        $(this).css("background-color","#ffffff");
    });

    function showImage() {
        j++;
        if (j > 3)j = 0;
        for (var n = 0; n < 4; n++) {
            if (n == j) {
                $(".img1_inner img:eq(" + n + ")").show();
                $(".img1_border div:eq(" + n + ")").show();
                $(".img1_content div:eq("+n+")").css("background-color","#006666");
                continue;
            }
            $(".img1_inner img:eq(" + n + ")").hide();
            $(".img1_border div:eq(" + n + ")").hide();
            $(".img1_content div:eq("+n+")").css("background-color","#ffffff");
        }
    }
    setInterval(showImage,3500);
});