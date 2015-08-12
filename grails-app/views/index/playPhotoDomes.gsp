<!DOCTYPE html>
<html>
<head>
    <title>jquery瀑布流实例最流行瀑布流图片展示</title>
    <meta name="description">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'playPhotoDomes.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/playPhotoDomes', file: 'jquery-1.4.2.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/playPhotoDomes', file: 'jquery.masonry.js')}"></script>

    <script type="text/javascript">
        var isWidescreen = screen.width >= 1280;
        if (isWidescreen) {
            document.write("<style type='text/css'>.demo{width:1194px;}</style>");
        }
    </script>

    <script type="text/javascript">
        function item_masonry() {
            $('.item img').load(function () {
                $('.infinite_scroll').masonry({
                itemSelector: '.masonry_brick',
                columnWidth: 226,
                gutterWidth: 15
            });
            });

            $('.infinite_scroll').masonry({
                itemSelector: '.masonry_brick',
                columnWidth: 226,
                gutterWidth: 15
            });
        }

        $(function () {

            function item_callback() {

                $('.item').mouseover(function () {
                    $(this).css('box-shadow', '0 1px 5px rgba(35,25,25,0.5)');
                    $('.btns', this).show();
                }).mouseout(function () {
                            $(this).css('box-shadow', '0 1px 3px rgba(34,25,25,0.2)');
                            $('.btns', this).hide();
                        });

                item_masonry();

            }

            item_callback();

            $('.item').fadeIn();

            var sp = 1

            $(".infinite_scroll").infinitescroll({
                navSelector: "#more",
                nextSelector: "#more a",
                itemSelector: ".item",

                loading: {
                    img: "images/masonry_loading_1.gif",
                    msgText: ' ',
                    finishedMsg: '木有了',
                    finished: function () {
                        sp++;
                        if (sp >= 10) { //到第10页结束事件
                            $("#more").remove();
                            $("#infscr-loading").hide();
                            $("#page").show();
                            $(window).unbind('.infscr');
                        }
                }
                }, errorCallback: function () {
                    $("#page").show();
                }

            }, function (newElements) {
                var $newElems = $(newElements);
                $('.infinite_scroll').masonry('appended', $newElems, false);
                $newElems.fadeIn();
                item_callback();
                return;
            });

        });
    </script>
</head>

<body>

<div class="demo clearfix">
    <div class="play_photo_dome">
        <p>
            <span>最新资源</span>
        </p>

        <p>
            <span>推荐资源</span>
        </p>

    </div>

    <div class="item_list infinite_scroll">

        <g:each in="${programList}" var="program">
            <div class="item masonry_brick">
                <div class="item_t">
                    <div class="img">
                        <a href=""><img width="210" alt="" src="${posterLinkNew(program: program, size: '-1x-1')}"/>
                        </a>
                        %{-- <span class="price">￥195.00</span>--}%

                        <div class="btns">
                        <a href="" class="un_img_album_btn" style="color:#FFF">收&nbsp;&nbsp;藏</a>
                    </div>
                    </div>

                    <div class="title">
                        <span><a href="#">${program?.name}</a></span>
                    </div>
                </div>

                <div class="item_b clearfix">
                    <div class="items_likes fl play_photo_wd">
                        <a href="#" class="like_btn"><img
                                src="${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}"/></a>

                        <p class="play_photo_wd_in">
                            <a href="#" class="bold">author</a>
                            <a href="#" class="b_clas">新概念英语</a>
                        </p>
                    </div>

                    <div class="items_comment fr play_photo_talk">
                        <span></span>
                        <span class="img_f">11656</span>
                    </div>
                </div>
            </div><!--item end-->
        </g:each>

    </div>


    <div id="more"><a href="page/2.html"></a></div>

    <div id="page" class="page" style="display:none;">
        <div class="page_num">
            <span class="unprev"></span>
            <span class="current">1</span>
            <a href="">&nbsp;2&nbsp;</a>
            <a href="">&nbsp;3&nbsp;</a>
            <a href="">&nbsp;4&nbsp;</a>
            <a href="">&nbsp;5&nbsp;</a>
            <span class="etc"></span>
            <a href="">12</a>
            <a href="" class="next"></a>
        </div>
    </div>

</div>

<div style="display:none;" id="gotopbtn" class="to_top"><a title="返回顶部" href="javascript:void(0);"></a></div>


<script type="text/javascript">
    $(function () {

        $(window).scroll(function () {
            $(window).scrollTop() > 1000 ? $("#gotopbtn").css('display', '').click(function () {
                $(window).scrollTop(0);
            }) : $("#gotopbtn").css('display', 'none');
        });

    });
</script>

</body>
</html>
