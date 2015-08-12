<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 5/19/14
  Time: 1:51 PM
--%>

<%@ page import="nts.user.domain.Consumer; nts.meta.domain.MetaContent; nts.utils.CTools; java.text.SimpleDateFormat" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="index">
    <title>音频点播页面</title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'audio_index_play.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'audio_index.css')}">
    <r:require modules="jwplayer,raty"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/meta.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'metalist.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/string.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/audio', file: 'audioIndexPlay.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/index', file: 'collectionAndrecommend.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/showProgram.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
    <script type="text/javascript">
        //全局变量
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
            var audioPlayList = ${playLinksNew(serials:specialProgramList)};
            $(audioPlayList).each(function(){
                this.image = "";
            });
            jwplayerInit("audioPlayer", audioPlayList, "100%", "100%", true, false);
            $("#playingItem").text("正在播放${serial.name}");
            jwplayer("audioPlayer").playlistItem(0);
            jwplayer("audioPlayer").onPlaylistItem(function (event) {
                var item = audioPlayList[event.index];
                var title = item.title;
                $("#playingItem").text("正在播放" + title);
            });
        });
    </script>
</head>

<body>
<g:hiddenField name="pId" id="pId" value="${program.id}"/>
<div class="audio_album wrap">
    <div class="audio_album_poster">
        %{--<img src="${resource(dir: 'skin/blue/pc/front/images', file: 'audio_album_img.png')}"/>--}%
        <img data-original="${posterLinkNew(program: program, size: '300x200')}" class="imgLazy"
             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
    </div>

    <div class="audio_album_infor">
        <h1 title="${program?.name}">${program?.name}</h1>

        <div class=""></div>

        <div class="album_infor_des">
            %{--<p class="al_in_ds">作者：<span>Christmas</span></p>--}%

            %{--<p class="al_in_ds">分类：<span>教育视频</span></p>--}%

            %{--<p class="al_in_ds">上传时间：<span>2014-05-09</span></p>--}%

            %{--<p class="al_in_ds">点播次数：<span>11213</span></p>--}%
        </div>

        <div class="audio_album_icon">
            <p><span class="al_play" onclick="playProgram('0')"></span><span id="play_program"
                                                                             onclick="playProgram('0')">点&nbsp;播</span>
            </p>

            <p><span class="al_recommend"></span>
                <g:if test="${judgeCollectProgram(program: program) == 'true'}">
                    <span class="container_play_save" style="color: #FFF; background: #999">已收藏</span>
                </g:if>
                <g:else>
                    <span id="collection_program" class="container_play_save"
                          onclick="collectionProgram(${program.id}, '${session.consumer?.name}')">收&nbsp;藏</span>
                </g:else>
            </p>

            <p><span class="al_save"></span>
                <g:if test="${judgeRecommendProgram(program: program) == 'true'}">
                    <span class="container_play_good" style="color: #FFF; background: #999">已推荐</span>
                </g:if>
                <g:else>
                    <span id="recommend_Program" class="container_play_good"
                          onclick="recommendProgram(${program.id}, '${session.consumer?.name}')">推&nbsp;荐</span>
                </g:else>
            </p>
        </div>
    </div>

</div>

<div class="audio_play_content wrap">
    <div class="audio_left">

        <div class="audio_infor_word">
            ${CTools.htmlToBlank(program.description)}
        </div>

        <div class="audio_album_items">
            <div class="dis-block">
                <h1><span>专辑资源目录</span></h1>
            </div>

            <div class="dis-bloc"><span class="alum_upload_user" id="playingItem"></span></div>

            <div class="alum-box">
                <div class="alum_tem_sup">
                    <div id="audioPlayer" style="width:100%;height:100%;"></div>
                </div>
            </div>

            <div class="audio_album_list">
                <table width="100%">
                    <tbody id="audioTbody">
                    <g:each in="${specialProgramList}" var="serial" status="i">
                        <tr id="audioTr${i}">
                            <td align="left" class="alum_tit" width="100px"><a href="javascript:void(0);"
                                                                               onclick="playProgram('${i}')"
                                                                               title="${serial.name}">${CTools.cutString(serial.name, 7)}</a>
                            </td>
                            <td width="200" align="left" class="alum_upload_user"
                                title="${program.consumer.name}">${CTools.cutString(program?.consumer?.name, 15)}</td>
                            %{--<td width="200" align="left" class="alum_tem">

                            </td>--}%
                            <td width="60" align="right"
                                class="alum_time">${new SimpleDateFormat('yyyy-MM-dd').format(program.dateCreated)}</td>
                            <td width="50" id="fnPlay_${serial.id}">
                                <span class="aulm_item_operate">
                                    <input type="hidden" id="audioFileHash${i}" value="${serial.fileHash}"/>
                                    <input type="hidden" id="audioPath${i}" value="${serial.filePath}"/>
                                    <input type="hidden" id="audioName${i}" value="${serial.name}"/>
                                    <input type="hidden" id="audioId${i}" value="${serial.id}"/>
                                    <a class="operate_paly" href="javascript:void(0);" title="播放"
                                       onclick="playProgram('${i}')"></a>
                                    <g:if test="${isCanDownload}">
                                        <a title="下载" class="album_resource_download_icon"
                                           href="${createLink(controller: 'program', action: 'downloadSharing', params: [serialId: serial?.id])}"></a>
                                    </g:if>
                                %{--<a class="operate_save" href="#" title="收藏"></a>
                                <a class="operate_offer" href="#" title="推荐"></a>--}%
                                </span>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="audio_album_talk">
            <h1><span>专辑评论</span></h1>

            <div class="album_talk_inp_box">
                <div class="album_talk_inp"><label><textarea id="evaluateTextarea"></textarea></label></div>

                <div class="album_talk_inp_but">
                    <div class="playdocumment_left_column_talk_input_star">
                        <p>评&nbsp;&nbsp;价:</p>

                        <div style="width:200px;height:50px;float:left;">
                            <div id="rankScore">
                            </div>
                        </div>

                    </div>

                    <div class="album_talk_inp_sum">
                        <label><input type="button" value="评价" onclick="fnevaluate('${session.consumer?.name}')"/>
                        </label>
                    </div>
                </div>
            </div>

            <div class="album_talk_content">
                %{--资源评论母板开始-----------}%
                <div class="album_talk_item" id="programRemark0" style="display: none">
                    <div class="album_talk_item_pom">
                        <img src="" id="consumerImg"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                    </div>

                    <div class="album_talk_item_infor">
                        <div class="album_talk_item_des" id="rDiv">
                            <g:hiddenField name="remarkId" id="remarkId" value=""></g:hiddenField>
                            <p class="album_talk_user">
                                <span class="tl_user">
                                    <a href="#" id="remarkConsumerName"></a>
                                </span>
                                <span class="tl_time" id="remarkDateCreate"></span>
                            </p>

                            <p class="album_user_back" id="remarkContent">
                            </p>
                        </div>

                        <div class="album_talk_back_items" id="replyDiv0" style="display: none">
                            <p class="album_talk_user">
                                <span class="tl_user">
                                    <a href="#" id="replyConsumerName"></a>
                                </span>
                                <span class="tl_time" id="replyDateCreate"></span>
                            </p>

                            <p class="album_user_back" id="replyContent">

                            </p>
                        </div>

                        <p class="aum_back_word"><span onclick="fnreply(this)" id="fnReply">回&nbsp;复</span></p>

                        <div class="album_talk_back" style="display: none" id="remarkDiv">
                            <div class="album_talk_back_inp"><label><textarea id="replyTextarea"></textarea></label>
                            </div>

                            <div class="album_talk_back_but">
                                <label>
                                    <input class="" type="button" value="评价" onclick="fnevaluate2(this)"
                                           id="remarkReplyEvaluateId">
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            %{--资源评论母板结束-----------}%
                <g:each in="${evaluateList}" var="remark">
                    <div class="album_talk_item">
                        <div class="album_talk_item_pom">
                            <img src="${generalUserPhotoUrl(consumer: remark.consumer)}"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                        </div>

                        <div class="album_talk_item_infor">
                            <div class="album_talk_item_des" id="rDiv_${remark.id}">
                                <g:hiddenField name="remarkId_${remark?.id}" value="${remark.id}"></g:hiddenField>
                                <p class="album_talk_user"><span class="tl_user"><a href="#">${remark.consumer.name}</a>
                                </span>
                                    <span class="tl_time">${new SimpleDateFormat('yyyy-MM-dd').format(remark.dateCreated)}</span>
                                </p>

                                <p class="album_user_back">
                                    ${remark.content}
                                </p>
                            </div>
                            <g:each in="${remark.remarkReplys}" var="reply">
                                <div class="album_talk_back_items" id="replyDiv_${reply.id}">
                                    <p class="album_talk_user">
                                        <span class="tl_user"><a href="#"
                                                                 id="replyConsumerName_${reply.id}">${reply.consumer.name}</a>
                                        </span>
                                        <span class="tl_time"
                                              id="replyDateCreate_${reply.id}">${new java.text.SimpleDateFormat('yyyy-MM-dd').format(reply.dateCreated)}</span>
                                    </p>

                                    <p class="album_user_back" id="replyContent_${reply.id}">
                                        ${reply.content}
                                    </p>
                                </div>
                            </g:each>

                            <p class="aum_back_word"><span onclick="fnreply(this, '${session.consumer?.name}')"
                                                           id="fnReply_${remark?.id}">回&nbsp;复</span></p>

                            <div class="album_talk_back" style="display: none" id="remarkDiv_${remark?.id}">
                                <div class="album_talk_back_inp"><label><textarea class="replyTextarea"
                                                                                  id="replyTextarea_${remark?.id}"></textarea>
                                </label></div>

                                <div class="album_talk_back_but"><label><input class="" type="button" value="评价"
                                                                               onclick="fnevaluate2(this)"
                                                                               id="remarkReplyEvaluateId_${remark?.id}"/>
                                </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </g:each>
            </div>

        </div>
    </div>

    <div class="audio_right">
        <div class="r_box">
            <h1><span>资源信息</span></h1>
            <table>
                <tbody>
                <tr><td>作者:</td><td><g:consumerName id="${program.consumer.id}"/></td></tr>
                <tr>
                    <td>分类：</td>
                    <td>
                        <g:if test="${program.programCategories && program.programCategories.size() > 0}">
                            <g:set var="categoryNames" value=""/>
                            <g:each var="programCategory" in="${program.programCategories.toList()}">
                                <g:set var="categoryNames"
                                       value="${categoryNames + "," + programCategory.name}"></g:set>
                            </g:each>
                        </g:if>
                        ${categoryNames}
                    </td>
                </tr>
                <tr><td>上传时间:</td><td>${program.dateCreated.format("yyyy-MM-dd")}</td></tr>
                </tbody>
            </table>
            <table id="metaContTab">
            </table>
        </div>

        <div class="r_box">
            <h1><span>热门资源</span></h1>

            <div class="audio_same_items">
                <g:each in="${hotAudio4}" var="program">
                    <div class="audio_same_item">
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}">
                            <img data-original="${posterLinkNew(program: program, size: '160x100')}" class="imgLazy"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                        </a>

                        <p>
                            <a class="same_item_title"
                               href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               title="${program.name}">
                                ${CTools.cutString(program?.name, 5)}
                            </a>
                        </p>

                        <p><span class="same_play">${program?.frequency}</span><span
                                class="same_time">${program.dateCreated.format("yyyy-MM-dd")}</span></p>
                    </div>
                </g:each>
            </div>
        </div>
    </div>

</div>
</body>
</html>