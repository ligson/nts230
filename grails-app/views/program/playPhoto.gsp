<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-21
  Time: 下午2:52
--%>

<%@ page import="nts.program.domain.RemarkScore; nts.user.domain.Consumer; java.text.SimpleDateFormat; nts.meta.domain.MetaContent; nts.utils.CTools; java.text.DecimalFormat" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html" xml:lang="zh" lang="zn">
<head>
    <title>${message(code: 'my.picture.name')}${message(code: 'my.play.name')}</title>
    <meta name="layout" content="none">
    <link rel="icon" type="image/x-icon" href="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_logo.ico')}"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_playPhoto.css')}"
          type="text/css"/>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'playPhoto_demo.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'playPhoto_style.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'playPhoto_elastislide.css')}">
    <style>
    .es-carousel ul {
        display: block;
    }
    </style>
    <r:require modules="jquery,raty"/>
    <r:layoutResources/>
    <r:layoutResources/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_playPhoto.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/meta.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'metalist.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/showProgram.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common',file: 'fileType.js')}"></script>
    <script type="text/javascript">
        var swfFileUrl = "";
        var programId = ${serial.program.id};
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
        var lastTime = ${lastTime?lastTime:-1};

        //初始化,prototype没有
        $(function(){
            wtab = document.getElementById("metaContTab");
            setCurMetaList(${program?.directory?.id?program?.directory?.id:-1}, 1, -1);//显示当前类下可摘要显示
            showAllTr();
        });

        %{--
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

        }--}%

        <g:each in="${program.metaContents}" status="i" var="metaContent">
        contentList[${i}] = new CContentTypeObj(${metaContent.id}, ${metaContent.metaDefine.id}, ${metaContent.metaDefine.parentId}, ${MetaContent.numDataTypes.contains(metaContent.metaDefine.dataType)?1:2}, ${metaContent.numContent}, '${CTools.nullToBlank(metaContent.strContent).encodeAsJavaScript()}');
        </g:each>
    </script>
    <script type="text/javascript" src="${resource(dir: 'js/palyPhoto', file: 'jquery.tmpl.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/palyPhoto', file: 'jquery.easing.1.3.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/palyPhoto', file: 'jquery.elastislide.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/palyPhoto', file: 'gallery.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/collectionAndrecommend.js')}"></script>

    <script id="img-wrapper-tmpl" type="text/x-jquery-tmpl">
    <div class="rg-image-wrapper">
				{{if itemsCount > 1}}
					<div class="rg-image-nav">
						<a href="#" class="rg-image-nav-prev">Previous Image</a>
						<a href="#" class="rg-image-nav-next">Next Image</a>
					</div>
				{{/if}}
				<div class="rg-image"></div>
				<div class="rg-loading"></div>
				<div class="rg-caption-wrapper">
					<div class="rg-caption" style="display:none;">
						<p></p>
					</div>
				</div>
			</div>
    </script>
</head>

<body>
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
<div class="boful_photo_banner">
<div class="boful_photo_banner_main">
    <div class="boful_photo_player_title">
        <a href="${createLink(controller: 'index', action: 'index')}">${message(code: 'my.return.name')}${message(code: 'my.list.name')}</a>
        <span class="see_img"
              onclick="openImgShow()">${message(code: 'my.view.name')}${message(code: 'my.picture.name')}</span>
        <g:if test="${Consumer.findByName(session.consumer.name)?.canDownload}">
            <span class="see_img" id="downloadSpan">${message(code: 'my.download.name')}</span>
        </g:if>
        %{--  <span class="boful_photo_player_list_packup"><img src="${resource(dir: 'skin/blue/pc/images',file: 'boful_photo_player_list_packup_icon.png')}"/></span>--}%
        %{--<a class="boful_photo_player_list_an" href="#"></a>--}%
    </div>

    <div class="boful_photo_player_player" style="float:left;text-align:center;">

        <div class="content">
            <div id="rg-gallery" class="rg-gallery">
                <div class="rg-thumbs">
                    <div class="es-carousel-wrapper">
                        <div class="es-nav">
                            <span class="es-nav-prev">Previous</span>
                            <span class="es-nav-next">Next</span>
                        </div>

                        <div class="es-carousel">
                            <ul>
                                <g:if test="${isImg == 1}">
                                    <g:each in="${serialList}" status="st" var="serial2">
                                        <li><a href="#"><img
                                                src="${posterLinkNew(fileHash: serial2.fileHash, size: '500x-1')}"
                                                onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"
                                                data-large="${posterLinkNew(fileHash: serial2.fileHash, size: '-1x500')}"
                                                id="imgSerial_${serial.id}_${serial.fileHash}_${serial.fileType}"></a></li>
                                    </g:each>
                                </g:if>
                                <g:else>
                                    <g:each in="${serialList}" status="st" var="serial">
                                        <li><a href="#"><img
                                                src="${posterLinkNew(fileHash: serial.fileHash, size: '500x-1')}"
                                                onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"
                                                data-large="${posterLinkNew(fileHash: serial.fileHash, size: '-1x500')}"
                                                id="imgSerial_${serial.id}_${serial.fileHash}_${serial.fileType}"></a></li>
                                    </g:each></g:else>
                            </ul>
                        </div>

                        <div class="es-nav"></div>
                    </div>
                </div>
            </div>
        </div>

    </div>

</div>

<div class="boful_photo_banner_right">
    <div class="boful_photo_desc">
        <div class="photo_desc_name">${CTools.cutString(serial?.program.name, 10)}</div>

        <div class="photo_desc_score">
            <div class="photo_desc_score_l">
                <span class="photo_desc_score_name">${message(code: 'my.resources.name')}${message(code: 'my.score.name')}</span>
                <span class="photo_desc_score_score">
                    ${queryProgramRemarkScore(program: serial.program)}
                    %{--${serial.program.remarks.size() ? new DecimalFormat("#.##").format((serial.program.remarks*.rank)?.sum() / serial.program.remarks.size()) : 0.0}--}%分</span>
            </div>

            <div class="photo_desc_score_r">
                <g:if test="${judgeRecommendProgram(program: program) == 'true'}">
                    <span class="photo_desc_hot"
                          style="color: #FFF; background: #999">${message(code: 'my.recommended.name')}</span>
                </g:if>
                <g:else>
                    <span id="recommend_Program" class="photo_desc_hot"
                          onclick="recommendProgram(${program.id}, '${session.consumer?.name}')">${message(code: 'my.recommend.name')}</span>
                </g:else>

                <g:if test="${judgeCollectProgram(program: program) == 'true'}">
                    <span class="photo_desc_save"
                          style="color: #FFF; background: #999">${message(code: 'my.collected.name')}</span>
                </g:if>
                <g:else>
                    <span id="collection_program" class="photo_desc_save"
                          onclick="collectionProgram(${program.id}, '${session.consumer?.name}')">${message(code: 'my.collect.name')}</span>
                </g:else>
            </div>
        </div>
    </div>

    <div class="boful_photo_tabs">
        <p>
            <span class="rea_infor_icon">${message(code: 'my.resources.name')}${message(code: 'my.informations.name')}</span>
            <g:if test="${Consumer.findByName(session.consumer.name)?.canComment}">
            <span class="res_talk_icon">${message(code: 'my.review.name')}</span></g:if>
            %{--<span class="video_directory_import">元数据</span>--}%
            <span class="video_directory_share">${message(code: 'my.share.name')}</span>
        </p>
    </div>

    <div class="boful_photo_content">

        <!--资源信息-->
        <div class="boful_photo_info">

            <table style="width: 100%; margin-bottom: 0;">
                <tr>
                    <td style="width: 100px">${message(code: 'my.creat.name')}${message(code: 'my.date.name')}</td>
                    <td>${program.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</td>
                </tr>
                <tr>
                    <td style="width: 100px">${message(code: 'my.name.name')}</td>
                    <td>${program.name}</td>
                </tr>
                <tr>
                    <td style="width: 100px">${message(code: 'my.responsible.name')}</td>
                    <td><a style="color: #333" title="${program?.consumer?.name}"
                           href="${createLink(controller: 'my', action: 'userSpace', params: [id: program.consumer.id])}">${CTools.cutString(program?.consumer?.name, 8)}</a>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px">${message(code: 'my.statistical.name')}</td>
                    <td>${message(code: 'my.play.name')}${message(code: 'my.amount.name')}：${program.frequency}</td>
                </tr>
                <tr>
                    <td style="width: 100px">${message(code: 'my.keywords.name')}/${message(code: 'my.tally.name')}</td>
                    <td>
                        <g:each in="${program.programTags}">
                            ${it.name}&nbsp;
                        </g:each>
                    </td>
                </tr>
            </table>
            <table id="metaContTab">

            </table>
        </div>

        <!--评论-->
        <div class="boful_photo_remark" style="display:none;">
            <div class="photo_remark_create">
                <input type="hidden" id="remark_name" value="${session.consumer?.name}">
                %{--主题:<input
                    style="padding: 3px; margin: 5px 0; width: 330px;height: 25px; line-height: 25px; border: #cccbcb 1px solid;background: #fafafa;"
                    id="topic">--}%

                <p><input type="hidden" id="rank"></p>
                <textarea class="photo_remark_create1" id="content">我来说两句....</textarea>

                    <div class="playdocumment_left_column_talk_input_star">
                        <p>${message(code: 'my.evaluation.name')}:</p>

                        <div id="rankScore"></div>
                    </div>


                <input class="photo_remark_create_but" id="remarkBtn" type="button" value="发表">
            </div>


            <div class="photo_remarks">
                <g:each in="${remarkList}" var="remark">
                    <div class="photo_remark" id="remark${remark?.id}">
                        <div class="photo_remark_user">${remark.consumer.name}：</div>

                        <p class="photo_remark_content">${CTools.htmlToBlank(remark.content)}</p>

                        <div class="photo_remark_user">
                            ${new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(remark.dateCreated)}${message(code: 'my.evaluation.name')}
                            <a style="cursor: pointer" id="remark_a">${message(code: 'my.reply.name')}(${remark.replyNum})</a>
                            <g:if test="${remark?.consumer?.id == session?.consumer?.id}">
                                <a href="javascript:void(0);" onclick="remarkDelete(${remark?.id})">${message(code: 'my.remarkDelete.name')}</a>
                            </g:if>
                        </div>

                        <div class="photo_remark_content" style="display: none" id="replayCon">
                            <input type="hidden" id="remarkId" value="${remark.id}">
                            <input type="hidden" id="replyNum" value="${remark.replyNum}">
                            <input type="hidden" id="remarkName" value="${remark.consumer.name}">
                            <textarea class="photo_remark_create1" id="replayContent">回复内容....</textarea>
                            <input class="photo_remark_create_but" id="replayBtn" type="button" value="回复">
                        </div>

                        <div id="replay">
                            <g:each in="${remark.remarkReplys}" var="reply">
                                <div class="photo_remark_user">
                                    ${reply.consumer.name}：${reply.content}
                                    <p>（${reply.dateCreated}）</p>
                                </div>
                            </g:each>
                        </div>

                    </div>
                </g:each>
            </div>

        </div>
        <!-----元数据----->
        %{--<div></div>--}%
        <!------分享------>
        <div class="boful_photo_sharings" style="display: none">
            <div>
                <h1 class="photo_sharing_adress">${message(code: 'my.web.name')}${message(code: 'my.adress.name')}：<em>[${message(code: 'my.present.name')}${message(code: 'my.adress.name')}]</em>
                </h1>

                <p class="photo_sharing_box_w"><label><input class="photo_sharing_word" type="text" value="${basePath}">
                </label></p>

                %{--<p class="photo_sharing_box_c"><label><input class="photo_sharing_copy" type="text" value="复制">
                </label></p>--}%
            </div>

            <div>
                <h1 class="photo_sharing_adress">${message(code: 'my.play.name')}${message(code: 'my.adress.name')}：<em>[[${message(code: 'my.present.name')}${message(code: 'my.adress.name')}]]</em>
                </h1>

                <p class="photo_sharing_box_w"><label><input id="sharing_address" class="photo_sharing_word" type="text"
                                                             value="${playUserFileLink(fileHash: serial.fileHash)}">
                </label></p>

                %{--<p class="photo_sharing_box_c"><label><input class="photo_sharing_copy" type="text" value="复制">
                </label></p>--}%
            </div>

            <div>
                <h1 class="photo_sharing_adress">${message(code: 'my.embedded.name')}${message(code: 'my.code.name')}：<em>[[${message(code: 'my.present.name')}${message(code: 'my.adress.name')}]]</em>
                </h1>

                <p class="photo_sharing_box_w"><label><input  id="sharing_address2" class="photo_sharing_word" type="text"
                                                             value="<iframe width=700 height=400 id='embedPlayFrame' src='${playUserFileLink(fileHash: serial.fileHash)}' />">
                </label></p>

                %{--<p class="photo_sharing_box_c"><label><input class="photo_sharing_copy" type="text" value="复制">
                </label></p>--}%
            </div>
        </div>
    </div>
</div>
</div>
<g:form name="photoForm" controller="program" action="downloadSharing">
    <input type="hidden" id="programId" name="programId">
    <input type="hidden" id="serialId" name="serialId" value="${serial?.id}">
    <input type="hidden" id="fileHash" name="fileHash" value="${serial?.fileHash}">
    <input type="hidden" id="fileType" name="fileType" value="${serial?.fileType}">
</g:form>
<script type="text/javascript">
    function remarkDelete(remarkID) {
        $.post(baseUrl + "program/remarkDelete", {remarkID: remarkID}, function (data) {
            if (data.success) {
                alert(data.msg);
                $("#remark"+remarkID).remove();
            } else {
                alert(data.msg);
            }
        });
    }

    $(function () {
        var n = 0;
        var remarkScore = 0;
        var index = $(".boful_photo_inner img").length;
        if (index <= 7) {
            $("#photo_left").hide();
            $("#photo_right").hide();
        }
        $("#photo_left").click(function () {
            if (n + 7 >= index)n = 0;
            n += 3;
            for (var i = 0; i < index; i++) {
                if (i < n) {
                    $(".boful_photo_inner img:eq(" + i + ")").hide();
                } else {
                    $(".boful_photo_inner img:eq(" + i + ")").show();
                }
            }
        });
        $("#photo_right").click(function () {
            if (n + 7 >= index)n = 0;
            n += 3;
            for (var i = 0; i < index; i++) {
                if (i < n) {
                    $(".boful_photo_inner img:eq(" + i + ")").hide();
                } else {
                    $(".boful_photo_inner img:eq(" + i + ")").show();
                }
            }
        });

        $(".boful_photo_inner img").click(function () {
            var ind = $(".boful_photo_inner img").index(this);
            for (var i = 0; i < index; i++) {
                if (i == ind) {
                    $(".boful_photo_player_img img:eq(" + i + ")").show();
                } else {
                    $(".boful_photo_player_img img:eq(" + i + ")").hide();
                }
            }

        });


        $("#content").click(function () {
            if ($("#content").val() == '我来说两句....') {
                $("#content").val('');
            }
        });

        $(".photo_remarks #remark_a").click(function () {
            var index = $(".photo_remarks #remark_a").index(this);
            var remark_name = $("#remark_name").val();
            var remarkName = $(".photo_remarks .photo_remark:eq(" + index + ") input[id='remarkName']").val();
            if (remark_name == '' || remark_name == 'anonymity') {
                alert("请登录后再做回复!");
            }
            else if (remarkName == remark_name) {
                alert("对不起,不能回复自己发表的评论!")
            } else {
                $(".photo_remarks #replayCon").eq(index).show();
            }

        });
        $(".photo_remark_content #replayContent").click(function () {
            $(this).val('');
        });
        $(".photo_remark_content #replayBtn").click(function () {
            var remark_name = $("#remark_name").val();
            if (remark_name == '' || remark_name == 'anonymity') {
                alert("请登录后再做评论!");
                return false;
            }
            var url = "${createLink(controller: 'program',action: 'saveRemarkReply')}";
            var content = $("#replayContent").val();
            var id = $("#remarkId").val();
            var replyNum = $("#replyNum").val();
            $.post(url, {content: content, id: id, replyNum: replyNum}, function (data) {
                if (data.success) {
                    $(".photo_remarks #replayCon").hide();
                    alert("回复成功!");
                    window.location.reload();
                }

            })
        });
        $("#remarkBtn").click(function () {
            var remark_name = $("#remark_name").val();
            if (remark_name == 'anonymity') {
                alert("请登录后在做评论!");
                return false;
            }
            var url = "${createLink(controller: 'program',action: 'saveRemark')}";
            var content = $("#content").val();
            if (content == "我来说两句...." || content == '') {
                alert("内容不能为空");
                content.focus();
                return false;
            }
            var programId =${serial.program.id};
            $.post(url, {content: content, rank: remarkScore, programId: programId,serialId :$("#serialId").val()}, function (data) {
                if (data.success) {
                    var remark = data.remark;
                    if(!remark.isPass) {
                        alert(data.msg);
                        return;
                    }
                    alert("评论成功!");
                    window.location.reload();
                }

            })

        })

        $("#rankScore").raty({half: true, width: 110, click: function (score) {
            remarkScore = score * 2;
        }});

        $('#downloadSpan').click(function () {
            $('#programId').val(gProgramId);
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

        $('.es-carousel').find('img').click(function () {
            var imgId = $(this).attr('id');
            var str1 = imgId.substring(0, imgId.lastIndexOf('_'));
            var id = str1.substring(str1.indexOf('_')+1, str1.lastIndexOf('_'));
            var fileHash = str1.substring(str1.lastIndexOf('_') + 1);
            var fileType = imgId.substring(imgId.lastIndexOf('_') + 1);
            $('#fileHash').val(fileHash);
            $('#fileType').val(fileType);
            var filePath = fileHash+"."+fileType;
            if(checkFileType(filePath)==1) {
                window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=video&fileHash=" + fileHash, '_blank');
            } else if(checkFileType(filePath)==2){
                window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=document&fileHash=" + fileHash, '_blank');
            } else if(checkFileType(filePath)==4){
                window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=audio&fileHash=" + fileHash, '_blank');
            } else if(checkFileType(filePath)==3){
                //获取当前播放地址
                $.post(baseUrl+"ntsService/playUserFileImg",{fileHash:fileHash},function(data){
                    $("#sharing_address").val(data.fileUrl);
                    $("#sharing_address2").val("<iframe width=700 height=400 id='embedPlayFrame' src='" + data.fileUrl + "' />");
                });
            }else if(checkFileType(filePath)==5){
                window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=flash&fileHash=" + fileHash, '_blank');
            }
        });
    })

    function openImgShow(){
        var fileHash = $('#fileHash').val();
        $.post(baseUrl + "ntsService/posterUserFileImg", {fileHash: fileHash}, function (data) {
            window.open(data.src, '_blank');
        });

    }


</script>
</body>

</html>