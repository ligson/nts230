<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <r:require modules="jwplayer,jquery"/>
    <r:layoutResources/>
    <r:layoutResources/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_video_play.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/mobile', file: 'css/mobile_video_views_play.css')}">
    <link rel="script" href="${resource(dir: 'js/mobile', file: 'mobile_views.js')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
    <title>搜索</title>
    <!--
To learn more about the conditional comments around the html tags at the top of the file:
paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/

Do the following if you're using your customized build of modernizr (http://www.modernizr.com/):
* insert the link to your js here
* remove the link below to the html5shiv
* add the "no-js" class to the html tags at the top
* you can also remove the link to respond.min.js if you included the MQ Polyfill in your modernizr build
-->
    <!--[if lt IE 9]>
 <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
    <script type="text/javascript">
        $(function () {
            $("#programList").click(function () {
                $(".boful_mobile_content_play_list").show();
                $(".boful_mobile_content_play_des").hide();
            });
            $("#programDes").click(function () {
                $(".boful_mobile_content_play_list").hide();
                $(".boful_mobile_content_play_des").show();
            });
        });
    </script>
    <script type="text/javascript">
        var swfFileUrl = "${playDocumentLinksNew(serial:serial)}";
        var firstSerialAddress = "${mobilePlayLink(fileHash:serial.fileHash,isPdf: false)}";
        $(function () {
            var playList = ${playLinksNew(serials:[serial])};

            jwplayerInit("boful_video_player", playList, "100%", "100%", true, false);

            jwplayer("boful_video_player").onPlay(function(){
                try{
                    jwplayer("boful_video_player").stop();
                    window.JSInterface.startVideo(firstSerialAddress);
                } catch(e){

                }
            });

            //记录点播次数;
            var frequency = $("#frequency").val();
            var programId = $("#programId").val();
            var url = "${createLink(action: 'frequencyNum')}";
            $.post(url, {frequency: frequency, programId: programId}, function (data) {

            })
        });

        function serial_btn(address) {
            try {
                jwplayer("boful_video_player").stop();
                window.JSInterface.startVideo(address);
            } catch (e) {

            }
        }
    </script>
</head>

<body>
<input type="hidden" id="frequency" value="${program?.frequency}">
<input type="hidden" id="programId" value="${program?.id}">

<div class="boful_mobile_searchbox ">
    %{-- <div class="boful_mobile_back">
         <p><a href="${createLink(action: 'mobileVideo_inde')}">
             <span class="boful_mobile_comeback"></span></a>
             --}%%{--<span class="boful_mobile_home"></span>--}%%{--
         </p>
     </div>--}%
    <!----------播放窗口------------>
    <div class="boful_mobile_back_play_win" id="boful_video_player">
    </div>
    <!----------播放窗口结束------------>
</div>

<!--检索类别-->
<div class="gridContainer clearfix">
    <div class="boful_mobile_content_recommend">
        <h1><span class="boful_mobile_content_recommend_name">${CTools.cutString(program?.name, 10)}</span><span
                class="boful_mobile_content_label">播放${program?.frequency}次</span></h1>
    </div>

    <div class="boful_mobile_content_play_infor">
        <a id="programList" style="cursor: pointer">资源列表</a>
        <a id="programDes" style="cursor: pointer">资源简介</a>
    </div>

<div class="boful_mobile_content_play_list">
    <g:each in="${program?.serials}" var="serial">
        <div>
            <a onclick="serial_btn('${mobilePlayLink(fileHash:serial.fileHash,isPdf: false)}')"
               href="javascript:void(0);"
               title="${serial?.name}">${CTools.cutString(serial?.name, 20)}</a>
        </div>
    </g:each>
</div>

    <div class="boful_mobile_content_play_des" style="display: none">
        <p>${CTools.htmlToBlank(program?.description)}</p>
    </div>
</div>

</body>
</html>
