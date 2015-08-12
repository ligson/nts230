<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-21
  Time: 下午2:52
--%>

<%@ page import="nts.program.domain.Remark; nts.program.domain.RemarkScore; nts.user.domain.Consumer; nts.meta.domain.MetaContent; nts.utils.CTools; java.text.DecimalFormat" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html" xml:lang="zh" lang="zn">
<head>
    <title>${message(code: 'my.word.name')}${message(code: 'my.play.name')}</title>
    <meta name="layout" content="index">
    <r:require modules="raty"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_playDocument.css')}"
          type="text/css"/>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'string.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper.js')}"></script>


    <script type="text/javascript">
        var swfFileUrl = "${playDocumentLinksNew(serial:serial)}";
    </script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofulFlexpaper.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_playDocument.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper_handlers.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/collectionAndrecommend.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/meta.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'metalist.js')}"></script>
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
<input id="consumerId" value="${session.consumer?.id}" type="hidden">
<input id="consumerPhoto" value="${session.consumer?.photo}" type="hidden">

<div class="playdocumment_body">
    <div class="playdocumment_body_warp">
        <div class="playdocumment_left">
            <div class="playdocumment_left_head">
                <h1>${serial.name}</h1>

                <div class="playdocumment_left_head_infor">
                    <div class="playdocumment_left_head_infor_left">
                        <span class="playdocumment_left_head_infor_upload_name"><a
                                title="${serial?.program?.consumer?.name}"
                                href="${createLink(controller: 'my', action: 'userSpace', params: [id: serial?.program?.consumer.id])}">${CTools.cutString(serial?.program?.consumer?.name, 6)}</a>
                        </span>
                        <span class="playdocumment_left_head_infor_upload_score">${queryProgramRemarkScore(program: serial.program)}%{--${serial.program.remarks.size() ? new DecimalFormat("#.##").format((serial.program.remarks*.remarkScore?.rank)?.sum() / serial.program.remarks.size()) : 0.0}--}%分</span>
                    </div>

                    <div class="playdocumment_left_head_infor_right">
                        <span class="playdocumment_left_head_infor_talk">评价${serial.program.remarks.size()}人</span>
                        <span class="playdocumment_left_head_infor_browse">浏览${serial.program.viewNum}人</span>
                    </div>

                    <div class="playdocumment_left_head_infor_right1">
                        <g:if test="${judgeRecommendProgram(program: serial.program) == 'true'}">
                            <a href="javascript:void(0); " style="color: #FFF; background: #999"><span
                                    class="playdocumment_left_head_infor_right_collection"
                                    style="color: #FFF; background: #999">${message(code: 'my.recommended.name')}</span>
                            </a>
                        </g:if>
                        <g:else>
                            <a href="javascript:void(0);"
                               onclick="recommendProgram(${serial.program.id}, '${session.consumer?.name}')"
                               id="recommend_Program"><span
                                    class="playdocumment_left_head_infor_right_collection">${message(code: 'my.recommend.name')}</span>
                            </a>
                        </g:else>

                        <g:if test="${judgeCollectProgram(program: serial.program) == 'true'}">
                            <a href="javascript:void(0);" style="color: #FFF; background: #999"><span
                                    class="playdocumment_left_head_infor_right_collection">${message(code: 'my.collected.name')}</span>
                            </a>
                        </g:if>
                        <g:else>
                            <a href="javascript:void(0);"
                               onclick="collectionProgram(${serial.program.id}, '${session.consumer?.name}')"
                               id="collection_program">
                                <span class="playdocumment_left_head_infor_right_collection">${message(code: 'my.collect.name')}</span>
                            </a>
                        </g:else>
                    </div>
                </div>
            </div>
            <!---文档浏览---->
            <div class="playdocumment_left_show" id="document_player">

            </div>
        <!---文档评论---->
            <g:if test="${Consumer.findByName(session.consumer.name)?.canComment}">
                <div class="playdocumment_left_column_talk">
                    <div class="playdocumment_left_column_talk_title">
                        <h1>${message(code: 'my.evaluation.name')}</h1>
                        <span>共${serial.program.remarks.size()}条${message(code: 'my.evaluation.name')}</span>
                    </div>


                    <div class="playdocumment_left_column_talk_input">
                        %{--     <h3>标&nbsp;题</h3>
                             <input id="remarkTopic" name="remarkTopic" type="text"
                                    style="width:760px;height: 25px; border:1px solid #e4e4e4;background: #FFF; margin: 5px;color:#000;"
                                    value="">--}%

                        <h3>${message(code: 'my.content.name')}</h3>
                        <textarea id="remarkContent" name="remarkContent"
                                  style="width:750px; height: 120px;border: #e4e4e4 1px solid;padding: 5px"></textarea>

                        <div class="playdocumment_left_column_talk_input1">
                            <div class="playdocumment_left_column_talk_input_star">
                                <p>${message(code: 'my.evaluation.name')}:</p>

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
                    <div class="playdocumment_left_column_talk_boxs" id="remarkDiv">
                        <g:each in="${remarks}" var="remark">
                            <div class="playdocumment_left_column_talk_box" id="remark${remark?.id}">
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

                                    %{--  <h3>${remark.topic}</h3>--}%

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
                                        <a href="javascript:void(0);"
                                           id="remark_a">${message(code: 'my.reply.name')}</a>
                                        <g:if test="${remark?.consumer?.id == session?.consumer?.id}">
                                            <a href="javascript:void(0);"
                                               onclick="remarkDelete(${remark?.id})">${message(code: 'my.remarkDelete.name')}</a>
                                        </g:if>
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
                </div>
            </g:if>
        </div>

        <!------------右侧-------->
        <div class="playdocumment_right">
            <g:if test="${Consumer.findByName(session.consumer.name)?.canDownload}">
                <div class="playdocumment_right_upload_but">
                    <a id="downloadP">
                        <span class="playdocumment_right_upload_but_icon"></span>

                        <p>${message(code: 'my.download.name')}</p>
                    </a>
                </div>
            </g:if>
            <div class="playdocumment_right_infor_word">
                <h1 class="in-line">${message(code: 'my.word.name')}${message(code: 'my.information.name')}</h1>


                <div class="doc-pad">
                    <table padding="0" margin="0" collspacing="0" cellspaciong="0">
                        <tr>
                            <td width="70">${message(code: 'my.creat.name')}${message(code: 'my.date.name')}</td>
                            <td width="130">${serial.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</td>
                        </tr>
                        <tr>
                            <td width="70">${message(code: 'my.name.name')}</td>
                            <td width="130">${serial.program.name}</td>
                        </tr>
                        <tr>
                            <td width="70">${message(code: 'my.responsible.name')}</td>
                            <td width="130"><a style="color: #53A93F" title="${serial?.program?.consumer?.name}"
                                               href="${createLink(controller: 'my', action: 'userSpace', params: [id: serial?.program?.consumer.id])}">${CTools.cutString(serial?.program?.consumer?.name, 8)}</a>
                            </td>
                        </tr>
                        <tr>
                            <td width="70">${message(code: 'my.keywords.name')}</td>
                            <td width="130"></td>
                        </tr>
                        <tr><td class="playdocumment_right_infor_ktywords" colspan="4">
                            <g:each in="${serial.program.programTags}" var="tag">
                                <a href="#">${tag.name}</a>
                            </g:each>
                        </td></tr>
                    </table>
                </div>
            </div>

            <div class="playdocumment_right_data_infor">
                <h1 class="in-line">元数据</h1>
                <table id="metaContTab">
                </table>
            </div>

            <div class="playdocumment_right_data_directory">
                <h1 class="in-line">${message(code: 'my.word.name')}${message(code: 'my.directory.name')}</h1>


                <div class="playdocumment_right_data_directory_list">
                    <g:each in="${serialList}" var="ss">
                        <a href="javascript:void(0);" title="${ss.name}"
                           onclick="checkPlayType('${ss.id}', '${ss.fileHash}', '${ss.filePath}')">${ss.name}</a>
                    </g:each>
                </div>
            </div>

            <div class="playdocumment_right_others">
                <h1 class="in-line">${message(code: 'my.hot.name')}${message(code: 'my.word.name')}</h1>


                <g:each in="${hotPrograms}" var="program1">
                    <div class="playdocumment_right_other_list">
                        <h2><a title="${program1.name}"
                               href="${createLink(controller: 'program', action: 'showProgram', params: [id: program1.id])}">${CTools.cutString(program1.name, 8)}</a>
                            <span class="playdocumment_right_other_list_score">${queryProgramRemarkScore(program: program1)}%{--${program1.remarks.size() ? new DecimalFormat("#.##").format((program1.remarks*.remarkScore?.rank)?.sum() / program1.remarks.size()) : 0.0}--}%分</span>
                            %{--<span class="playdocumment_right_other_list_page">共${program1.serials.size()}个</span>--}%
                        </h2>

                    </div>
                </g:each>
            </div>

            <div class="playdocumment_right_share">
                <h1 class="in-line">分享</h1>


                <div class="playdocumment_right_sharing">
                    <table border="0" cellspacing="0" cellpadding="0" width="100%">
                        <tbody>
                        <tr>
                            <td class="share_win_address">${message(code: 'my.web.name')}${message(code: 'my.adress.name')}：<span>[${message(code: 'my.present.name')}${message(code: 'my.adress.name')}]</span>
                            </td>

                        </tr>

                        <tr><td><label><input class="def-inp" type="text" value="${basePath}"></label></td>
                            %{--<td><label><input class="desc_share_but" type="button" value="复制"></label></td>--}%
                        </tr>
                        <tr><td></td></tr>
                        <tr>
                            <td class="share_win_address">${message(code: 'my.play.name')}${message(code: 'my.adress.name')}：<span>[${message(code: 'my.present.name')}${message(code: 'my.adress.name')}]</span>
                            </td>

                        </tr>
                        <tr>
                            <td><label>
                                <input class="def-inp" type="text" value="${playDocumentLinksNew(serial: serial)}">
                            </label></td>
                            %{--<td><label><input class="desc_share_but" type="button" value="复制"></label></td>--}%
                        </tr>
                        <tr><td></td></tr>
                        <tr>
                            <td class="share_win_address">${message(code: 'my.embedded.name')}${message(code: 'my.code.name')}：<span>[${message(code: 'my.present.name')}${message(code: 'my.adress.name')}]</span>
                            </td>

                        </tr>
                        <tr>
                            <td><label><input type="text" class="def-inp"
                                              value="<iframe width=700 height=400 id='embedPlayFrame' src='${playDocumentLinksNew(serial: serial)}' />">
                            </label></td>
                            %{--<td><label><input class="desc_share_but" type="button" value="复制"></label></td>--}%
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>

</div>
<g:form name="photoForm" controller="program" action="downloadSharing">
    <input type="hidden" id="programID" name="programId">
%{--<input type="hidden" id="fileHash" name="fileHash" value="${serial?.fileHash}">
<input type="hidden" id="fileType" name="fileType" value="${serial?.fileType}">--}%
    <input type="hidden" id="serialId" name="serialId" value="${serial?.id}">
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

    function checkPlayType(id, fileHash, filePath) {
        if (checkFileType(filePath) == 1) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=video&fileHash=" + fileHash, '_blank');
        } else if (checkFileType(filePath) == 3) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=image&fileHash=" + fileHash, '_blank');
        } else if (checkFileType(filePath) == 4) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=audio&fileHash=" + fileHash, '_blank');
        } else if (checkFileType(filePath) == 2) {
            window.location.href = baseUrl + "program/playDocument?id=" + id;
        } else if (checkFileType(filePath) == 5) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=flash&fileHash=" + fileHash, '_blank');
        }
    }

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