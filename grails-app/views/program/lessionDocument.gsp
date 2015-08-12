<%@ page import="nts.meta.domain.MetaContent; nts.utils.CTools; java.text.DecimalFormat" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html" xml:lang="zh" lang="zn">
<head>
    <title>${serial?.name}</title>
    <meta name="layout" content="index">
    <r:require modules="raty"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_playDocument.css')}"
          type="text/css"/>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'string.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/jwplayer', file: 'jwplayer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper_handlers.js')}"></script>

    %{--<script type="text/javascript">
        var swfFileUrl = "${playDocumentLinksNew(serial:serial)}";
    </script>--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofulFlexpaper.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_playDocument.js')}"></script>--}%

    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/collectionAndrecommend.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/meta.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'metalist.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/showProgram.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/swfobject', file: 'swfobject.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'bofulswfobject.js')}"></script>
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
        var serialId = ${serial.id};
        var lastTime = ${playedProgram?playedProgram.timeLength:-1};

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
            var playType = $("#playType").val();
            var fileHash = $("#fileHash").val();

            if ('video' == playType) {
                var playList = ${playLinksNew(fileHash:serial.fileHash)};
                playList = typeof (playList) == "string" ? eval(playList) : playList;
                jwplayerInit("boful_video_player", playList, "800", "450", true, false);
            } else if ('document' == playType) {
                var swfFileUrl = "${playDocumentLinksNew(serial:serial)}";
                flexpaperInit("boful_video_player", swfFileUrl, baseUrl);
            } else if ('image' == playType) {
                var src = "${posterLinkNew(serial: serial, size: '600x-1')}";
                $("#boful_video_player").empty().append("<img src=\"" + src + "\" onerror=\"this.src = " + baseUrl + "'skin/blue/pc/front/images/boful_default_img.png'\"/>");
            } else if ('audio' == playType) {
                var playList = "${playLinksNew(fileHash:serial.fileHash)}";
                playList = typeof (playList) == "string" ? eval(playList) : playList;
                jwplayerInit("boful_video_player", playList, "800", "20", true, false);
            } else if ('flash' == playType) {
                var swfUrl = "${playDocumentLinksNew(serial:serial)}";
                initSWF(swfUrl, "boful_video_player", "800", "450");
//                var strHtml = "";
//                strHtml = strHtml + "<object classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0\" width=\"984\" height=\"450\" align=\"middle\"\>";
//                strHtml = strHtml + "<embed src=\"" + playList + "\" quality=\"high\" width=\"800\" height=\"450\"  type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" /\>";
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
<input id="con_name" value="${session.consumer?.name}" type="hidden">
<input id="programId" value="${serial?.program.id}" type="hidden">
<input type="hidden" id="playType" value="${params.playType}"/>
<input type="hidden" id="fileHash" value="${params.fileHash}"/>

<div class="playdocumment_body">
<div class="playdocumment_body_warp">
<div class="playdocumment_left">
    <div class="playdocumment_left_head">
        <h1>${serial.name}</h1>
        %{--<div class="playdocumment_left_head_infor">
            <div class="playdocumment_left_head_infor_left">
                <span class="playdocumment_left_head_infor_upload_name"><a
                        title="${serial?.program?.consumer?.name}"
                        href="${createLink(controller: 'my', action: 'userSpace', params: [id: serial?.program?.consumer.id])}">${CTools.cutString(serial?.program?.consumer?.name, 6)}</a>
                </span>
                <span class="playdocumment_left_head_infor_upload_score">${serial.program.remarks.size() ? new DecimalFormat("#.##").format((serial.program.remarks*.rank)?.sum() / serial.program.remarks.size()) : 0.0}分</span>
            </div>

            <div class="playdocumment_left_head_infor_right">
                <span class="playdocumment_left_head_infor_talk">评价${serial.program.remarks.size()}人</span>
                <span class="playdocumment_left_head_infor_browse">浏览${serial.program.frequency}人</span>
            </div>

            <div class="playdocumment_left_head_infor_right1">
                <g:if test="${judgeRecommendProgram(program: serial.program) == 'true'}">
                    <a href="javascript:void(0); " style="color: #FFF; background: #999"><span
                            class="playdocumment_left_head_infor_right_collection"
                            style="color: #FFF; background: #999">已推荐</span></a>
                </g:if>
                <g:else>
                    <a href="javascript:void(0);"
                       onclick="recommendProgram(${serial.program.id}, '${session.consumer?.name}')"
                       id="recommend_Program"><span
                            class="playdocumment_left_head_infor_right_collection">推&nbsp;荐</span></a>
                </g:else>

                <g:if test="${judgeCollectProgram(program: serial.program) == 'true'}">
                    <a href="javascript:void(0);" style="color: #FFF; background: #999"><span
                            class="playdocumment_left_head_infor_right_collection">已收藏</span></a>
                </g:if>
                <g:else>
                    <a href="javascript:void(0);"
                       onclick="collectionProgram(${serial.program.id}, '${session.consumer?.name}')"
                       id="collection_program">
                        <span class="playdocumment_left_head_infor_right_collection">收&nbsp;藏</span></a>
                </g:else>
            </div>
        </div>--}%
    </div>
    <!---文档浏览---->
    <div class="playdocumment_left_show" id="document_player">
        <div id="boful_video_player" style="width:100%;height:100%;"></div>
    </div>
    <!---文档评论---->
    %{--<div class="playdocumment_left_column_talk">
        <div class="playdocumment_left_column_talk_title">
            <h1>评论</h1>
            <span>共${serial.program.remarks.size()}条评论</span>
        </div>


        <div class="playdocumment_left_column_talk_input">
            --}%%{--     <h3>标&nbsp;题</h3>
                 <input id="remarkTopic" name="remarkTopic" type="text"
                        style="width:760px;height: 25px; border:1px solid #e4e4e4;background: #FFF; margin: 5px;color:#000;"
                        value="">--}%%{--

            <h3>内&nbsp;容</h3>
            <textarea id="remarkContent" name="remarkContent"
                      style="width:750px; height: 120px;border: #e4e4e4 1px solid;padding: 5px"></textarea>

            <div class="playdocumment_left_column_talk_input1">
                <div class="playdocumment_left_column_talk_input_star">
                    <p>评&nbsp;&nbsp;价:</p>

                    <div class="playdocumment_left_column_talk_input_star_number">
                        <div style="width: 150px; height: 40px; float: left">
                            <div id="rankScore"></div>
                        </div>
                    </div>
                </div>
                <label>
                    <input type="button" value="评&nbsp;&nbsp;价" id="remarkBtn">
                </label>
            </div>
        </div>
        <!---文档11评论---->
        <div class="playdocumment_left_column_talk_boxs">
            <g:each in="${serial.program.remarks.sort()}" var="remark">
                <div class="playdocumment_left_column_talk_box">
                    <p class="playdocumment_left_column_talk_box_portrait">
                        <a title="${remark?.consumer?.name}"
                           href="${createLink(controller: 'my', action: 'userSpace', params: [id: remark?.consumer?.id])}">
                            <div style="float: left">
                                <img style=" width: 28px; height:28px; "
                                     src="${generalUserPhotoUrl(consumer: remark?.consumer)}"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                            </div></a>
                    </p>
                    <!---文档11评论时间---->
                    <div class="playdocumment_left_column_talk_contets">
                        <div class="playdocumment_left_column_talk_contets_user">
                            <span class="playdocumment_left_column_talk_contets_user_name"><a
                                    title="${remark?.consumer?.name}"
                                    href="${createLink(controller: 'my', action: 'userSpace', params: [id: remark?.consumer?.id])}">${remark.consumer.name}</a>
                            </span>
                            <span class="playdocumment_left_column_talk_contets_user_date">${remark.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</span>
                        </div>

                    --}%%{--  <h3>${remark.topic}</h3>--}%%{--

                    <p class="playdocumment_left_column_talk_contets_user_words">
                            ${remark.content}
                        </p>
                        <!---文档11评论回复---->
                        <div class="playdocumment_left_column_talk_back_others" id="replyList_${remark.id}">
                            <g:each in="${remark.remarkReplys}" var="remarkReply">
                                <div class="playdocumment_left_column_talk_back_other">
                                    <div class="playdocumment_left_column_talk_back_other_backname">
                                        <h3><a title="${remark?.consumer?.name}"
                                               href="${createLink(controller: 'my', action: 'userSpace', params: [id: remark?.consumer?.id])}">${remark.consumer.name}</a>
                                        </h3>
                                        <span>${remarkReply.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</span>
                                    </div>

                                    <p>
                                        ${remarkReply.content}
                                    </p>
                                </div>
                            </g:each>

                        </div>

                        <div class="playdocumment_left_column_talk_contets_user_words_back">
                            <a href="javascript:void(0);">回复</a>
                        </div>

                        <div class="playdocumment_left_column_talk_contets_user_words_content"
                             style="display:none;">
                            <input type="hidden" value="${remark.replyNum}" id="replyNum">
                            <label>
                                <textarea
                                        style="height: 100px;width: 678px;border: 1px solid #e4e4e4; padding: 5px"
                                        id="reply_${remark.id}"></textarea>
                                <input class="playdocumment_left_column_talk_contets_user_words_content_but1"
                                       type="button" value="确认评价" onclick="replyRemark(${remark.id})">
                            </label>
                        </div>
                    </div>
                </div>
            </g:each>

        </div>
    </div>--}%
</div>

<!------------右侧-------->
<div class="playdocumment_right">
    <div class="playdocumment_right_upload_but">
        <a id="downloadP">
            <span class="playdocumment_right_upload_but_icon"></span>

            <p>下&nbsp;&nbsp;载</p>
        </a>
    </div>

    <div class="playdocumment_right_infor_word">
        <h1>基本信息</h1>

        <div class="playdocumment_right_infor_word_line"></div>
        <table padding="0" margin="0" collspacing="0" cellspaciong="0">
            <tr>
                <td style="width: 70px">创建日期</td>
                <td>${serial.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</td>
            </tr>
            <tr>
                <td style="width: 70px">题名</td>
                <td>${serial.program.name}</td>
            </tr>
            <tr>
                <td style="width: 70px">负责人</td>
                <td><a style="color: #53A93F" title="${serial?.program?.consumer?.name}"
                       href="${createLink(controller: 'my', action: 'userSpace', params: [id: serial?.program?.consumer.id])}">${CTools.cutString(serial?.program?.consumer?.name, 8)}</a>
                </td>
            </tr>
            <tr>
                <td style="width: 70px">关键词</td>
                <td></td>
            </tr>
            <tr><td class="playdocumment_right_infor_ktywords" colspan="4">
                <g:each in="${serial.program.programTags}" var="tag">
                    <a href="#">${tag.name}</a>
                </g:each>
            </td></tr>
        </table>
    </div>

    <div class="playdocumment_right_data_infor">
        <h1>元数据</h1>

        <div class="playdocumment_right_infor_word_line"></div>
        <table id="metaContTab"></table>
    </div>

    <div class="playdocumment_right_data_directory">
        <h1>${message(code: 'my.Relatedaccessories.name')}</h1>

        <div class="playdocumment_right_infor_word_line"></div>

        <div class="playdocumment_right_data_directory_list">
            <g:each in="${otherSerial}" var="ss">
                <a href="${createLink(controller: 'program', action: 'lessionProgram', params: [serialId: ss.id, max: params.max, offset: params.offset])}">${ss.name}</a>
            </g:each>
        %{--            <div class="f_page">
                        <g:guiPaginate controller="program" action="lessionProgram" total="${otherSerialTotal}" params="${params}" />
                    </div>--}%

        </div>

        <div class="file-page">
            <g:if test="${Integer.parseInt(params.offset) > 0}">
                <a href="${createLink(controller: 'program', action: 'lessionProgram', params: [serialId: serial?.id, max: params.max, offset: Integer.parseInt(params.offset) - Integer.parseInt(params.max)])}">上一页</a>
            </g:if>
            <g:else>
                <span>上一页</span></g:else>
            <span>${Integer.parseInt(params.offset) / Integer.parseInt(params.max) + 1}/
                <g:if test="${otherSerialTotal < Integer.parseInt(params.max)}">1</g:if>
                <g:else>${Math.round(Math.ceil(otherSerialTotal / Integer.parseInt(params.max)))}</g:else></span>
            <g:if test="${otherSerialTotal - Integer.parseInt(params.offset) > Integer.parseInt(params.max)}">
                <a href="${createLink(controller: 'program', action: 'lessionProgram', params: [serialId: serial?.id, max: params.max, offset: Integer.parseInt(params.offset) + Integer.parseInt(params.max)])}">下一页</a>
            </g:if>
            <g:else><span>下一页</span></g:else>
        </div>
    </div>

    <g:if test="${serial.program.relationPrograms && serial.program.relationPrograms.size() > 0}">
        <div class="playdocumment_right_others">
            <h1>相关资源</h1>

            <div class="playdocumment_right_infor_word_line"></div>

            <g:each in="${serial.program.relationPrograms}" var="program1" status="j">
                <g:if test="${j < 5}">
                    <div class="playdocumment_right_other_list">
                        <h2><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program1.id])}">${program1.name}</a>
                        </h2>

                        <p>
                            <span class="playdocumment_right_other_list_score">${program1.remarks.size() ? new DecimalFormat("#.##").format((program1.remarks*.rank)?.sum() / program1.remarks.size()) : 0.0}分</span>
                            <span class="playdocumment_right_other_list_page">共${program1.serials.size()}个</span>
                        </p>
                    </div>
                </g:if>
            </g:each>

        </div>
    </g:if>


%{--<div class="playdocumment_right_share">
    <h1>playdocumment_left_head_infor_right_collection</h1>

    <div class="playdocumment_right_infor_word_line"></div>

    <div class="playdocumment_right_sharing">
        <table border="0" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
            <tr>
                <td class="share_win_address">网页地址：<span>[当前网页地址]</span></td>

            </tr>
            <tr><td><label><input type="text" value="${basePath}"></label></td>
                --}%%{--<td><label><input class="desc_share_but" type="button" value="复制"></label></td>--}%%{--
            </tr>
            <tr>
                <td class="share_win_address">播放地址：<span>[当前网页地址]</span></td>

            </tr>
            <tr>
                <td><label>
                    <input type="text" value="${playDocumentLinksNew(serial: serial)}">
                </label></td>
                --}%%{--<td><label><input class="desc_share_but" type="button" value="复制"></label></td>--}%%{--
            </tr>
            <tr>
                <td class="share_win_address">内嵌代码：<span>[当前网页地址]</span></td>

            </tr>
            <tr>
                <td><label><input type="text"
                                  value="<iframe width=700 height=400 id='embedPlayFrame' src='${playDocumentLinksNew(serial: serial)}' />">
                </label></td>
                --}%%{--<td><label><input class="desc_share_but" type="button" value="复制"></label></td>--}%%{--
            </tr>
            </tbody>
        </table>
    </div>
</div>--}%

</div>
</div>

</div>
<g:form name="photoForm" controller="program" action="downloadSharing">
    <input type="hidden" id="programID" name="programId">
    <input type="hidden" id="fileHash" name="fileHash" value="${serial?.fileHash}">
    <input type="hidden" id="fileType" name="fileType" value="${serial?.fileType}">
</g:form>
<script type="text/javascript">
    $(function () {
        $('#downloadP').click(function () {
            $('#programID').val(gProgramId);
            $.ajax({
                url: baseUrl + 'program/checkAuthority',
                data: "programId=" + gProgramId,
                success: function (data) {
                    if (data == 'true') {
                        $('#photoForm').submit();
                    } else {
                        alert('对不起，您没有权限下载该资源！');
                    }
                }
            })
        });
    })
</script>

%{--<div class="boful_doc_banner">
    <div class="boful_doc_banner_main">
        <div class="boful_doc_player_title">
            <a href="">返回列表</a>
        </div>

        <div class="boful_doc_player_player">
            <!--视频播放器-->
            <div id="boful_doc_player" style="width:100%;height:100%;"></div>
        </div>
    </div>

    <div class="boful_doc_banner_right">
        <div class="boful_doc_desc">
            <div class="doc_desc_name">${serial.program.name}</div>

            <div class="doc_desc_score">${serial.program.frequency}</div>
        </div>

        <div class="boful_doc_tabs">
            <span class="doc_directory_icon">文档目录</span>
            <span class="rea_infor_icon">资源信息</span>
            <span class="res_talk_icon">评论</span>
        </div>

        <div class="boful_doc_content">
            <!--视频目录-->
            <div class="boful_doc_list">
                <g:each in="${serial.program.serials}">
                    <p><span class="boful_photo_lists_icon"></span><a
                            href="${createLink(controller: 'program', action: 'playDocument', params: [id: serial.id])}">${it.name}</a>
                    </p>
                </g:each>
            </div>

            <!--资源信息-->
            <div class="boful_doc_info" style="display:none;">

                <table>
                    <tr>
                        <td style="width: 100px">创建日期</td>
                        <td>${serial.program.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</td>
                    </tr>
                    <tr>
                        <td style="width: 100px">题名</td>
                        <td>${serial.name}</td>
                    </tr>
                    <tr>
                        <td style="width: 100px">主要责任制</td>
                        <td>${serial.program.consumer.name}</td>
                    </tr>
                    <tr>
                        <td style="width: 100px">统计</td>
                        <td>${serial.program.frequency}</td>
                    </tr>
                    <tr>
                        <td style="width: 100px">关键词/标签</td>
                        <td>
                            <g:each in="${serial.program.programTags}">
                                ${it.name}&nbsp;
                            </g:each>
                        </td>
                    </tr>
                </table>
            </div>

            <!--评论-->
            <div class="boful_doc_remark" style="display:none;">
                <div class="doc_remark_create">
                    <textarea class="photo_remark_create1">发表评论</textarea>
                    <input type="button" class="photo_remark_create_but" value="发表">
                </div>

                <div class="doc_remarks">
                    <g:each in="${serial.program.remarks}" var="remark">
                        <div class="doc_remark">
                            <div class="doc_remark_user">${remark.consumer.name}：</div>

                            <div class="doc_remark_content">${remark.content}</div>
                        </div>
                    </g:each>
                </div>
            </div>
        </div>
    </div>
</div>--}%
</body>
</html>