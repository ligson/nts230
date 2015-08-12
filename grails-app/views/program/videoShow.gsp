<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-21
  Time: 下午1:10
--%>

<%@ page import="com.boful.common.file.utils.FileType; nts.program.domain.RemarkScore; nts.user.domain.Consumer; nts.utils.CTools; nts.program.domain.Program; nts.meta.domain.MetaContent; com.boful.common.date.utils.TimeLengthUtils" contentType="text/html;charset=UTF-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>${program?.name}-视频描述</title>
    <meta name="layout" content="index"/>
    <meta name="keywords"
          content="${program?.name},${message(code: "application.name", default: "邦丰资源管理平台")},数字资源,邦丰,vod,课件,数字资源管理"/>
    <meta name="description" content="${program?.description}"/>

    <r:require modules="jwplayer,raty,string"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_videoShow.css')}"
          type="text/css"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/meta.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'metalist.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/showProgram.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/string.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_videoShow.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/collectionAndrecommend.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
    <script type="text/javascript">
        //全局11变量
        var contentList = [];
        var metaList = [];
        var wtab;
        var gDisciplineId = "${application?.metaDisciplineId}";
        var gProgramId = ${program?.id};
        var isOutPlay = false;//播放来自外部（省图下级节点）
        var gOutHost = "";//用于外部（省图下级节点）批量播放，host,如：http://192.168.1.13:80
        var gFromNodeId = 0;
        var gPosterImg = "${posterLink(serials:program?.serials,isAbbrImg:false)}";
        var gAutoPlayTime = ${application?.autoPlayTime == 0?30:application.autoPlayTime};
        var gLineList = "${application.lineList}";
        var gCanComment = ${session?.consumer?.canComment?"true":"false"};
        var isAnonymous = ${session.consumer?(session.consumer?.name?.equals(application.anonymityUserName)):true};
        var serialId = ${serial.id};
        var lastTime = ${lastTime?lastTime:-1};
        var playList = ${playLinksNew(serials:serialList)};


        //初始化,prototype没有
        window.onload = init;

        function init() {
            //alert(234);
            wtab = document.getElementById("metaContTab");
            setCurMetaList(${program?.directory?.id?program?.directory?.id:-1}, 1, -1);//显示当前类下可摘要显示
            showAllTr();
            //setSerialList();


            //setPlayTrShow();
            //setImgNum();
            //实例化播放器
            //initJWPlay();
            //showSerialSlide();
            //document.getElementById("bodyDiv").style.display = "block";

        }

        <g:each in="${program.metaContents}" status="i" var="metaContent">
        contentList[${i}] = new CContentTypeObj(${metaContent.id}, ${metaContent.metaDefine.id}, ${metaContent.metaDefine.parentId}, ${MetaContent.numDataTypes.contains(metaContent.metaDefine.dataType)?1:2}, ${metaContent.numContent}, '${CTools.nullToBlank(metaContent.strContent).encodeAsJavaScript()}');
        </g:each>

    </script>

    <script type="text/javascript">
        $(function () {
            playList = checkPlayListType(playList);
            jwplayerInit("boful_video_player", playList, "100%", "100%", true, false);
            jwplayer("boful_video_player").playlistItem(${serial?.serialNo-1});

            jwplayer("boful_video_player").onPlaylistItem(function (event) {
                var item = playList[event.index];
                var title = item.title;
                var sId = item.serialId;
                var filePath = item.sources[0].file;

                $("#proSerialId").val(sId);
                $("#currentSerialId").val(sId);

                // 设置标题
                $(".boful_img_banner_container_play_title").attr('title', title).text(title.length > 20 ? title.substring(0, 20) : title);

                // 设置正在播放样式
                var videoItems = $(".video_item");
                for (var i = 0; i < videoItems.length; i++) {
                    $(videoItems[i]).children('.boful_recommond_video_item_playing').remove();
                }
                var playItem = $("#video_item_" + sId).children('.boful_recommond_video_item_play');
                var strHtml = "<div class=\"boful_recommond_video_item_playing\"> <span class=\"boful_recommond_video_item_playing_ing\">正在播放...</span></div>";
                playItem.before(strHtml);

                //设置共享地址
                $("input[name='desc_share_in1']").val(filePath);
                $("input[name='desc_share_in2']").val("<iframe width=700 height=400 id='embedPlayFrame' src='" + filePath + "'/>");

                //虚拟片段地址清空
                $("#cut_startTime").val('');
                $("#cut_endTime").val("");
                $("#desc_share_in_cut").val("");
                $("#cut_real_startTime").val("");
                $("#cut_real_endTime").val("");
                $(".share-win").hide();
            });

            jwplayer("boful_video_player").onTime(function (event) {
                if (!isAnonymous) {
                    var position = event.position;
                    if (position == parseInt(position) && position % 10 == 0) {
                        position = parseInt(position);
                        $.post("${createLink(controller:'program',action:'recoderPosition')}", {
                            time: position,
                            serialId: serialId
                        }, function (data) {

                        });
                    }
                }
            });

            if (lastTime >= 0) {
                jwplayer("boful_video_player").seek(lastTime);
            }
            var videoItem = $(".video_item");
            videoItem.hover(function () {
                $(this).find(".boful_recommond_video_item_play").css("visibility", "visible");
            });
            videoItem.mouseleave(function () {
                $(this).find(".boful_recommond_video_item_play").css("visibility", "hidden");
            });

            //虚拟片段地址修改
            $("#cut_share_start").click(function () {
                var currentStartTime = jwplayer("boful_video_player").getPosition();
                $("#cut_startTime").val(timeLength(currentStartTime));
                $("#cut_real_startTime").val(currentStartTime);
            });

            $("#cut_share_end").click(function () {
                var currentEndTime = jwplayer("boful_video_player").getPosition();
                $("#cut_endTime").val(timeLength(currentEndTime));
                $("#cut_real_endTime").val(currentEndTime);
            });

            $("#cut_share").click(function () {
                var startTime = $("#cut_real_startTime").val();
                var endTime = $("#cut_real_endTime").val();
                if (startTime == "") {
                    alert("开始时间未获取!");
                } else if (endTime == "") {
                    alert("结束时间未获取!");
                } else {
                    var playAddr = $("#desc_share_in1").val();
                    $("#desc_share_in_cut").val(playAddr + "?start=" + startTime + "&end=" + endTime);
                }

                copyUrl();
            })

        });
        function shareOpens() {
            $(".share-win").toggle();
        }

        function timeLength(time) {
            var hour = parseInt(time / (60 * 60));
            var minute = parseInt(time % (60 * 60) / 60);
            var second = parseInt(time - hour * 60 * 60 - minute * 60);
            return fillZero(hour) + ":" + fillZero(minute) + ":" + fillZero(second);

        }
        function fillZero(num) {
            if (num < 10) {
                return "0" + num;
            } else {
                return num;
            }
        }

        function downloadSharing() {
            var serialId = $("#currentSerialId").val();
            window.location.href = baseUrl + "program/downloadSharing?serialId=" + serialId;
        }

        function checkPlayListType(playList) {
            var newPlayList = [];
            for (var i = 0; i < playList.length; i++) {
                var file = playList[i].sources[0].file;
                var filePath = file.substring(file.lastIndexOf(".") - 1);
                if (checkFileType(filePath) == 1 || checkFileType(filePath) == 4) {
                    newPlayList.push(playList[i]);
                }
            }
            return newPlayList;
        }
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
<input id="currentSerialId" value="" type="hidden"/>

<div class="boful_img_banner">
    <div class="boful_img_banner_container">
        <!--视频播放器-->
        <div class="boful_img_banner_container_play_head wrap">
            <p><a class="boful_img_banner_container_play_class" href="#"
                  title="${program?.name}">${CTools.cutString(program?.name, 20)}</a>
                <g:if test="${isCanDownload}">
                    <a class="container_play_save" style="color: #FFF;" target="_blank" onclick="downloadSharing()"
                       href="javascript:void(0);">下&nbsp;载</a></g:if>
                <span class="boful_img_banner_container_play_title"
                      title="${serial?.name}">${CTools.cutString(serial?.name, 20)}</span>
                <g:if test="${judgeRecommendProgram(program: program) == 'true'}">
                    <span class="container_play_good" style="color: #FFF; background: #999">已推荐</span>
                </g:if>
                <g:else>
                    <span id="recommend_Program" class="container_play_good" style="color: #FFF;"
                          onclick="recommendProgram(${program.id}, '${session.consumer?.name}')">推&nbsp;荐</span>
                </g:else>

                <g:if test="${judgeCollectProgram(program: program) == 'true'}">
                    <span class="container_play_save" style="color: #FFF; background: #999">已收藏</span>
                </g:if>
                <g:else>
                    <span id="collection_program" class="container_play_save" style="color: #FFF;"
                          onclick="collectionProgram(${program.id}, '${session.consumer?.name}')">收&nbsp;藏</span>
                </g:else>
                <span class="container_play_save" style="color: #FFF;" onclick="shareOpens();">分享</span>

            <div class="share-win" style="display:none;">
                <table>
                    <tbody>
                    <tr>
                        <td width="70"><p class="f14 c333">网页地址</p></td>
                        <td width="140"><p><input type="text" value="${basePath}"></p></td>
                        <td width="90"><p class="f12 c999">[当前网页地址]</p></td>
                    </tr>
                    <tr>
                        <td width="70"><p class="f14 c333">播放地址</p></td>
                        <td width="140"><p>
                            <g:if test="${serial != null}">
                                <input type="text" id="desc_share_in1" name="desc_share_in1"
                                       value="${playLinksNew2(serialId: serial?.id)}">
                            </g:if>
                        </p></td>
                        <td width="90"><p class="f14 c333">[当前视频地址]</p></td>
                    </tr>
                    <tr>
                        <td width="70"><p class="f14 c333">内嵌代码</p></td>
                        <td width="140">
                            <p>
                                <input name="desc_share_in2" type="text"
                                       value="<iframe width=700 height=400 id='embedPlayFrame' src='${playLinksNew2(serialId: serial?.id)}' />">
                            </p>
                        </td>
                        <td width="90"><p class="f14 c333">[内嵌视频地址]</p></td>
                    </tr>
                    <tr>
                        <td width="300" colspan="3"><p class="fn16 clFFF lin">截取片段播放地址设置</p></td>
                    </tr>
                    <tr>
                        <td width="70"><p class="f14 c333">开始时间</p></td>
                        <td width="140">
                            <p>
                                <input id="cut_startTime" type="text" value="" disabled>
                                <input id="cut_real_startTime" type="hidden" value="">
                            </p>
                        </td>
                        <td width="90"><p class="f14 c333"><button id="cut_share_start">获取</button></p></td>
                    </tr>
                    <tr>
                        <td width="70"><p class="f14 c333">结束时间</p></td>
                        <td width="140">
                            <p>
                                <input id="cut_endTime" type="text" value="" disabled>
                                <input id="cut_real_endTime" type="hidden" value="">
                            </p>
                        </td>
                        <td width="90"><p class="f14 c333"><button id="cut_share_end">获取</button></p></td>
                    </tr>
                    <tr>
                        <td width="70"><p class="f14 c333">片段地址</p></td>
                        <td width="140"><p><input id="desc_share_in_cut" type="text" value=""></p></td>
                        <td width="90"><p class="f14 c333"><button id="cut_share">截取片段并复制</button></p></td>
                    </tr>

                    </tbody>
                </table>
            </div>
        </div>

        <div class="boful_img_banner_container_play_win">
            <div id="boful_video_player" style="width:100%;height:100%;"></div>
        </div>
    </div>
</div>
<input id="con_name" value="${session.consumer?.name}" type="hidden">
<input id="consumerId" value="${session.consumer?.id}" type="hidden">
<input id="consumerPhoto" value="${session.consumer?.photo}" type="hidden">
<input type="hidden" value="${program?.id}" id="programId">
<input type="hidden" value="" id="proSerialId"/>

<div class="boful_video_banner">
    <g:if test="${program?.serials?.size() > 1}">
        <div class="boful_video_banner_container">
            <div class="video_banner_title">
                <h1>视频列表</h1>
            </div>

            <div class="video_banner_list">
                <g:each in="${serialList2}" status="st" var="serialModel">
                    <div class="video_item" id="video_item_${serialModel?.id}" title="${serialModel?.name}">
                        <g:if test="${serialModel == serial}">
                            <div class="boful_recommond_video_item_playing">
                                <span class="boful_recommond_video_item_playing_ing">正在播放...</span>
                            </div>
                        </g:if>
                        <div class="boful_recommond_video_item_play"><a href="javascript:void(0);"
                                                                        onclick="checkPlayType('${serialModel.id}', '${serialModel.fileHash}', '${serialModel.filePath}')"><img
                                    style="box-shadow: none"
                                    src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_video_item_play_icon.png')}">
                        </a></div>

                        <g:if test="${FileType.VIDEO_TYPES.contains(serialModel.fileType.toLowerCase()) || FileType.AUDIO_TYPES.contains(serialModel.fileType.toLowerCase())}">
                            <div class="boful_recommond_video_item_date">
                                ${TimeLengthUtils.formatTime(TimeLengthUtils.NumberToString(serialModel.timeLength))}
                            </div>
                        </g:if>
                        <a href="javascript:void(0);"
                           onclick="checkPlayType('${serialModel.id}', '${serialModel.fileHash}', '${serialModel.filePath}')"><img
                                src="${posterLinkNew(serial: serialModel, size: '1024x320')}"
                                border="0" class="imgLazy"
                                onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                        </a>

                        <p title="${serialModel?.name}"><a
                                href="javascript:void(0);"
                                onclick="checkPlayType('${serialModel.id}', '${serialModel.fileHash}', '${serialModel.filePath}')">${CTools.cutString(serialModel?.name, 6)}</a>
                        </p>
                    </div>
                </g:each>
            </div>
        </div>
    </g:if>
</div>

<div class="video_desc">
    <div class="video_desc_left">
        <div class="video_desc_tabs">
            <span>资源信息</span>

            %{--<span>元数据信息</span>--}%
            %{--<span>分&nbsp;&nbsp;享</span>--}%
        </div>

        <div class="video_desc_content">
            <table class="v-tab" style="width: 100%; margin-bottom: 0;">
                <tr>
                    <td style="width: 100px">${Program.cnField.dateCreated}</td>
                    <td>${program?.dateCreated?.format("yyy-MM-dd HH:mm:ss")}</td>
                </tr>
                <g:if test="${program?.name != null}">
                    <tr>
                        <td style="width: 100px">${Program.cnField.name}</td>
                        <td>${CTools.cutString(program?.name, 10)}</td>
                    </tr></g:if>
                <g:if test="${program?.actor != ""}">
                    <tr>
                        <td style="width: 100px">${Program.cnField.actor}</td>
                        <td>${program?.actor}</td>
                    </tr></g:if>
                <tr>
                    <td style="width: 100px">${Program.cnField.frequency}</td>
                    <td>${program?.frequency}</td>
                </tr>
                <g:if test="${program?.programTags?.size() > 0}">
                    <tr>
                        <td style="width: 100px">${Program.cnField.programTags}</td>
                        <td>
                            <g:each in="${program?.programTags}" var="tags">
                                ${tags?.name}
                            </g:each>
                        </td>
                    </tr></g:if>
            </table>

            <table id="metaContTab"></table>
        </div>

        %{--<div class="video_desc_content" style="display:none">--}%
        %{--<table id="metaContTab">--}%
        %{--</table>--}%
        %{--</div>--}%

        %{--<div class="video_desc_share" style="display:none">
            <h1>分享给站外好友，把视频粘帖到Blog、BBS、word文档、ppt中。</h1>

            <p>
            <table border="0" cellpadding="0" cellspace="0">
                <tbody>
                <tr>
                    <td width="80" class="desc_share_size">网页地址：</td>
                    <td width="400"><label><input class="desc_share_in" type="text" value="${basePath}"></label></td>
                    <td width="140">--}%%{--<label><input class="desc_share_but" type="button" value="复制">
                </label>--}%%{--<span>&nbsp;&nbsp;[当前网页地址]</span></td>
                </tr>
                <tr>
                    <td class="desc_share_size">播放地址：</td>
                    <td><label>
                        <g:if test="${serial != null}">
                            <input class="desc_share_in" name="desc_share_in1" type="text"
                                   value="${playLinksNew2(serialId: serial?.id)}"></g:if>
                    </label></td>
                    <td>--}%%{--<label><input class="desc_share_but" type="button" value="复制">
                </label>--}%%{--<span>&nbsp;&nbsp;[当前视频地址]</span></td>
                </tr>
                <tr>
                    <td class="desc_share_size">内嵌代码：</td>
                    <td><label><input class="desc_share_in" name="desc_share_in2" type="text"
                                      value="<iframe width=700 height=400 id='embedPlayFrame' src='${playLinksNew2(serialId: serial?.id)}' />">
                    </label></td>
                    <td>--}%%{--<label><input class="desc_share_but" type="button" value="复制">
                </label>--}%%{--<span>&nbsp;&nbsp;[内嵌视频地址]</span></td>
                </tr>
                </tbody>
            </table>
        </p>
        </div>--}%

        <div class="video_desc_info">
            <div class="video_desc_info_icon"></div>
            <g:if test="${program?.description == ""}">
                <p>暂无简介</p>
            </g:if>
            <g:else>
                <p>${CTools.htmlToBlank(program?.description)}</p></g:else>
        </div>
    <!--------------评论------------>
        <g:if test="${Consumer.findByName(session.consumer.name)?.canComment}">
            <div class="playdocumment_left_column_talk">
                <div class="playdocumment_left_column_talk_title">
                    <h1>评&nbsp;&nbsp;论</h1>
                    <span>共${serial.program.remarks.size()}条评论</span>
                </div>


                <div class="playdocumment_left_column_talk_input">
                    %{--<h3>标&nbsp;题</h3>
                    <input id="remarkTopic" name="remarkTopic" type="text"
                           style="width:658px;height: 25px; border:1px solid #e4e4e4;background: #FFF; padding: 5px;color:#000;"
                           value="">--}%

                    <h3>内&nbsp;容</h3>
                    <textarea id="remarkContent" name="remarkContent"
                              style="width:658px; height: 120px;border: #e4e4e4 1px solid;padding: 5px"></textarea>

                    <div class="playdocumment_left_column_talk_input1">
                        <div class="playdocumment_left_column_talk_input_star">
                            <p>评&nbsp;&nbsp;价:</p>

                            <div style="width:200px;height:50px;float:left;">
                                <div id="rankScore">
                                </div>
                            </div>

                        </div>
                        <label>
                            <input type="button" value="评&nbsp;&nbsp;价" id="remarkBtn">
                        </label>
                    </div>
                </div>
                <!---文档11评论---->
                <div class="playdocumment_left_column_talk_boxs" id="remarkDiv">
                    <g:each in="${serial.program.remarks.sort()}" var="remark">
                        <g:if test="${remark.isPass}">
                            <div class="playdocumment_left_column_talk_box" id="remark${remark?.id}">
                                <p class="playdocumment_left_column_talk_box_portrait">
                                    <a title="${remark?.consumer?.name}"
                                       href="${createLink(controller: 'my', action: 'userSpace', params: [id: remark?.consumer?.id])}">
                                        <img src="${generalUserPhotoUrl(consumer: remark?.consumer)}" width="35"
                                             height="35"
                                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                                    </a>
                                </p>
                                <!---文档11评论时间---->
                                <div class="playdocumment_left_column_talk_contets">
                                    <div class="playdocumment_left_column_talk_contets_user">
                                        <span class="playdocumment_left_column_talk_contets_user_name"><a
                                                title="${remark?.consumer?.name}"
                                                href="${createLink(controller: 'my', action: 'userSpace', params: [id: remark.consumer.id])}">${CTools.cutString(remark?.consumer?.name, 6)}</a>
                                        </span>
                                        <span class="playdocumment_left_column_talk_contets_user_date">${remark.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</span>
                                    </div>

                                    %{--<h3>${remark.topic}</h3>--}%

                                    <p class="playdocumment_left_column_talk_contets_user_words">
                                        ${remark.content}
                                    </p>
                                    <!---文档11评论回复---->
                                    <div class="playdocumment_left_column_talk_back_others" id="replyList_${remark.id}">
                                        <g:each in="${remark.remarkReplys}" var="remarkReply">
                                            <div class="playdocumment_left_column_talk_back_other">
                                                <div class="playdocumment_left_column_talk_back_other_backname">
                                                    <h3><a title="${remarkReply?.consumer?.name}"
                                                           href="${createLink(controller: 'my', action: 'userSpace', params: [id: remarkReply.consumer.id])}">${remarkReply.consumer.name}</a>
                                                    </h3>
                                                    <span>${remarkReply.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</span>
                                                </div>

                                                <p class="playdocumment_left_column_talk_back_other_backname">
                                                    ${remarkReply.content}
                                                </p>
                                            </div>
                                        </g:each>
                                    </div>

                                    <div class="playdocumment_left_column_talk_contets_user_words_back">
                                        <a href="javascript:void(0);" onclick=""
                                           id="remark_a">${message(code: 'my.reply.name')}</a>
                                        <g:if test="${remark?.consumer?.id == session?.consumer?.id}">
                                            <a href="javascript:void(0);"
                                               onclick="remarkDelete(${remark?.id})">${message(code: 'my.remarkDelete.name')}</a>
                                        </g:if>
                                    </div>

                                    <div class="playdocumment_left_column_talk_contets_user_words_content"
                                         style="display:none;" id="replyDiv_${remark.id}">
                                        <textarea
                                                style="height: 100px;width: 596px;border: 1px solid #e4e4e4; padding: 5px"
                                                id="reply_${remark.id}"></textarea>
                                        <input class="playdocumment_left_column_talk_contets_user_words_content_but1"
                                               type="button" value="确认评价" onclick="replyRemark(${remark.id})">

                                    </div>
                                </div>
                            </div>
                            <input type="hidden" id="remarkId" value="${remark.id}">
                            <input type="hidden" id="replyNum" value="${remark.replyNum}">
                            <input type="hidden" id="remarkName" value="${remark.consumer.name}">
                        </g:if>
                    </g:each>

                </div>
            </div>
        </g:if>

    </div>
    <!--------------评论结束------------>
    <div class="video_desc_right">
        <div class="video_desc_right_hots">
            <div class="video_hot_title">
                <a href="${createLink(controller: 'index', action: 'search')}" style="color: #000000">视频排行</a>
            </div>

            <div class="video_hot_list">
                <g:each in="${videoList}" var="program" status="pro">
                    <g:if test="${pro == 0}">
                        <div class="video_hot_first">
                            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               target="_blank">
                                <div class="video_hot_first_nubmer">1</div>

                                <div class="video_hot_first_infor">${CTools.cutString(program?.name, 20)}</div>
                                <img data-original="${posterLinkNew(program: program, size: '290x100')}"
                                     alt="" width="290" height="120" border="0" class="imgLazy"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                            </a>
                        </div>
                    </g:if>
                    <g:else>
                        <div class="video_hot_item">
                            <span>${pro + 1}</span>
                            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               target="_blank">${CTools.cutString(program.name, 15)}</a>
                        </div>
                    </g:else>
                </g:each>
            </div>
        </div>

        <div class="video_desc_right_import">
            <div class="video_hot_title">
                <a href="${createLink(controller: 'index', action: 'search')}" style="color: #000000">相关资源</a>
            </div>

            <div class="video_hot_list">
                <g:each in="${relationProgram}" var="program" status="pro">
                    <div class="video_import_item">
                        <em>▪</em>
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                           target="_blank">${CTools.cutString(CTools.htmlToBlank(program?.name), 15)}</a>
                    </div>
                </g:each>
            %{--<g:each in="${recommendProgram}" var="program" status="pro">
                <div class="video_import_item">
                    <em>▪</em>
                    <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                       target="_blank">${CTools.cutString(program.name, 15)}</a>
                </div>
            </g:each>--}%
            </div>

        </div>
    </div>
</div>

%{--<g:form name="photoForm" controller="program" action="downloadSharing">--}%
%{--<input type="hidden" id="programID" name="programId">--}%
%{--<input type="hidden" id="fileHash" name="fileHash" value="${serial?.fileHash}">--}%
%{--<input type="hidden" id="serialId" name="serialId" value="${serial?.id}">--}%
%{--<input type="hidden" id="fileType" name="fileType" value="${serial?.fileType}">--}%
%{--</g:form>--}%
<script type="text/javascript">
    //    $(function () {
    //        $('#downloadSpan').click(function () {
    //            $('#programID').val(gProgramId);
    //            $.ajax({
    //                url: baseUrl + 'program/checkAuthority',
    //                data: "programId=" + gProgramId,
    //                success: function (data) {
    //                    if (data == 'true') {
    //                        $('#photoForm').submit();
    //                    } else {
    //                        alert('对不起，您没有权限下载该资源！');
    //                    }
    //                }
    //            })
    //        });
    //    })

    function checkPlayType(id, fileHash, filePath) {
        if (checkFileType(filePath) == 2) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=document&fileHash=" + fileHash, '_blank');
        } else if (checkFileType(filePath) == 3) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=image&fileHash=" + fileHash, '_blank');
        } else if (checkFileType(filePath) == 1 || checkFileType(filePath) == 4) {
            //window.location.href = baseUrl + "program/playVideo?id=" + id;
            play(id);
        } else if (checkFileType(filePath) == 5) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=flash&fileHash=" + fileHash, '_blank');
        }
    }

    function play(serialId) {
        var index = 0;
        for (var i = 0; i < playList.length; i++) {
            var item = playList[i].serialId;
            if (serialId == item) {
                index = i;
                break;
            }
        }
        jwplayer("boful_video_player").playlistItem(index);
    }

    function copyUrl() {
        var clipBoardContent = $("#desc_share_in_cut").val();
        if (window.clipboardData) {
            window.clipboardData.clearData();
            window.clipboardData.setData("Text", clipBoardContent);
            alert("复制完成，请粘贴到你所需要的地方。");
        } else {
            alert("只有IE支持按钮复制功能,请手动选择复制");
        }
    }
</script>
</body>
</html>