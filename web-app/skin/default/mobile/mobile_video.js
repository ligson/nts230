$(function(){
    var boful_inner_div=$(".boful_inner_div");
    var boful_image_box=$(".boful_image_box");
    var img1_inner=$(".img1_inner");
    boful_inner_div.css("top",boful_image_box.position().top+img1_inner.height()-40)

    var j=0;
    function showImage() {
        j++;
        if (j > 3)j = 0;
        for (var n = 0; n < 4; n++) {
            if (n == j) {
                $(".img1_inner img:eq(" + n + ")").show();
                $(".boful_inner_div div:eq(" + n + ")").show();
                continue;
            }
            $(".img1_inner img:eq(" + n + ")").hide();
            $(".boful_inner_div div:eq(" + n + ")").hide();
        }
    }
    setInterval(showImage,3500);
})