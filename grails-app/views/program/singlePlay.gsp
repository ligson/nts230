<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-10-13
  Time: 下午2:24
--%>

<%@ page import="nts.utils.CTools; nts.program.domain.Program" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="index">
    <title>${serial?.name}</title>
    <script type="text/javascript" src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/jwplayer', file: 'jwplayer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofulFlexpaper.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/swfobject', file: 'swfobject.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'bofulswfobject.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'singlePlay.css')}"
          type="text/css"/>
    <script type="text/javascript">
        var localObj = window.location;
        var contextPath = localObj.pathname.split("/")[1];
        var baseUrl = '';
        if ('nts' != contextPath) {
            baseUrl = localObj.protocol + "//" + localObj.host + "/";
        } else {
            baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
        }
        function resizeVideoShowUI() {
            var imgBanner = $(".boful_img_banner");
            var videoBanner = $(".boful_video_banner");
            var win = $(window);
            if (win.width() > 1024) {
                imgBanner.css("width", win.width());
                videoBanner.css("width", win.width());
            }
        }

        $(function () {
            resizeVideoShowUI();
            $(window).resize(function () {
                resizeVideoShowUI();
            });

            var playType = $("#playType").val();
            var fileHash = $("#fileHash").val();

            if ('video' == playType) {
                var playList = ${playLinksNew(fileHash:serial.fileHash)};
                playList = typeof (playList) == "string" ? eval(playList) : playList;
                jwplayerInit("boful_video_player", playList, "984", "450", true, false);
            } else if ('document' == playType) {
                var swfFileUrl = "${playDocumentLinksNew(serial:serial)}";
                flexpaperInit("boful_video_player", swfFileUrl, baseUrl);
            } else if ('image' == playType) {
                var src = "${posterLinkNew(serial: serial, size: '600x-1')}";
                $("#boful_video_player").empty().append("<img src=\"" + src + "\" onerror=\"this.src = " + baseUrl + "'skin/blue/pc/front/images/boful_default_img.png'\"/>");
            } else if ('audio' == playType) {
                var playList = "${playLinksNew(fileHash:serial.fileHash)}";
                playList = typeof (playList) == "string" ? eval(playList) : playList;
                jwplayerInit("boful_video_player", playList, "984", "20", true, false);
            } else if ('flash' == playType) {
                var swfUrl = "${playDocumentLinksNew(serial:serial)}";
                initSWF(swfUrl, "boful_video_player", "984", "450");
//                var strHtml = "";
//                strHtml = strHtml + "<object classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0\" width=\"984\" height=\"450\" align=\"middle\"\>";
//                strHtml = strHtml + "<embed src=\"" + playList + "\" quality=\"high\" width=\"984\" height=\"450\"  type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" /\>";
//                strHtml = strHtml + "</object\>";
//                $("#boful_video_player").empty().append(strHtml);
            }
        });
    </script>
</head>
<%

    StringBuffer buffer = new StringBuffer();
    Map pars = request.getParameterMap();
    Iterator iterator = pars.keySet().iterator();
    while (iterator.hasNext()) {
        Object object = iterator.next();
        String[] values = pars.get(object);
        buffer.append(object);
        buffer.append("=")
        for (int i = 0; i < values.size(); i++) {
            buffer.append(values[i]);
        }
    }
    String path = request.getForwardURI() + "?" + buffer;
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path;

%>
<body>
%{--
<div class="bf_single_Play wrap">
      <div  class="single_Play"></div>
      <div class="bf_single_infor"></div>
</div>
--}%

<input type="hidden" id="playType" value="${params.playType}"/>
<input type="hidden" id="fileHash" value="${params.fileHash}"/>

<div class="boful_img_banner_container_play_head ">
    <p><a class="boful_img_banner_container_play_class wrap" href="#" title="${serial?.name}">${serial?.name}</a></p>
</div>

<div class="bf_single_Play">
    <div class="single_Play wrap">
        <!--视频播放器-->


        <div class="boful_img_banner_container_play_win">
            <div id="boful_video_player" style="width:100%;height:100%;"></div>
        </div>
    </div>

    <div class="bf_single_infor">

        <div class="video_desc_left">
            <div class="video_desc_tabs">
                <span>分&nbsp;&nbsp;享</span>
            </div>

            <div class="video_desc_share">
                <h1>分享给站外好友，把视频粘帖到Blog、BBS、word文档、ppt中。</h1>
                <table border="0" cellpadding="0" cellspace="0">
                    <tbody>
                    <tr>
                        <td width="80" class="desc_share_size">网页地址：</td>
                        <td width="400"><label><input class="desc_share_in" type="text" value="${basePath}"></label>
                        </td>
                        <td width="140">%{--<label><input class="desc_share_but" type="button" value="复制">
                </label>--}%<span>&nbsp;&nbsp;[当前网页地址]</span></td>
                    </tr>
                    <tr>
                        <td class="desc_share_size">播放地址：</td>
                        <td><label>
                            <g:if test="${serial != null}">
                                <input class="desc_share_in" type="text"
                                       value="${playLinksNew2(serialId: serial?.id)}"></g:if>
                        </label></td>
                        <td>%{--<label><input class="desc_share_but" type="button" value="复制">
                </label>--}%<span>&nbsp;&nbsp;[当前视频地址]</span></td>
                    </tr>
                    <tr>
                        <td class="desc_share_size">内嵌代码：</td>
                        <td><label><input class="desc_share_in" type="text"
                                          value="<iframe width=700 height=400 id='embedPlayFrame' src='${playLinksNew2(serialId: serial?.id)}' />">
                        </label></td>
                        <td>%{--<label><input class="desc_share_but" type="button" value="复制">
                </label>--}%<span>&nbsp;&nbsp;[内嵌视频地址]</span></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>