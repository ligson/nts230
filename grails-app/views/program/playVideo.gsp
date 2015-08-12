<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-21
  Time: 下午2:52
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>${message(code: 'my.video.name')}${message(code: 'my.play.name')}</title>
    <meta name="layout" content="none">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_playVideo.css')}"
          type="text/css"/>
    <r:require modules="jquery,jwplayer"/>
    <r:layoutResources/>
    <r:layoutResources/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_playVideo.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
    <script type="text/javascript">
        $(function () {
            var playList = ${playLinksNew(serials:[serial])};
            jwplayerInit("boful_video_player", playList, "100%", "100%", true, false);
        });
    </script>
</head>

<body>
<div class="boful_video_banner">
    <div class="boful_video_banner_main">
        <div class="boful_video_player_title">
            <a href="">${message(code: 'my.return.name')}${message(code: 'my.list.name')}</a>
        </div>

        <div class="boful_video_player_player">
            <!--视频播放器-->
            <div id="boful_video_player" style="width:100%;height:100%;"></div>
        </div>
    </div>

    <div class="boful_video_banner_right">
        <div class="boful_video_desc">
            <div class="video_desc_name" title="${serial.name}">${CTools.cutString(serial.name, 10)}</div>

            <div class="video_desc_score">${serial.program.remarkNum}</div>
        </div>

        <div class="boful_video_tabs">
            <span class="video_directory_icon">${message(code: 'my.video.name')}${message(code: 'my.directory.name')}</span>
            <span class="rea_infor_icon">${message(code: 'my.video.name')}${message(code: 'my.informations.name')}</span>
            <span class="res_talk_icon">${message(code: 'my.review.name')}</span>
        </div>

        <div class="boful_video_content">
            <!--视频目录-->
            <div class="boful_video_list">
                <g:each in="${serial.program.serials}">
                    <p><span class="boful_photo_lists_icon"></span><a
                            href="${createLink(controller: 'program', action: 'playVideo', params: [id: it.id])}">${serial.name}</a>
                    </p>
                </g:each>
            </div>

            <!--资源信息-->
            <div class="boful_video_info" style="display:none;">

                <table>
                    <tr>
                        <td style="width: 100px">${message(code: 'my.creat.name')}${message(code: 'my.creat.name')}${message(code: 'my.date.name')}</td>
                        <td>${serial.program.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</td>
                    </tr>
                    <tr>
                        <td style="width: 100px">${message(code: 'my.name.name')}</td>
                        <td>${serial.program.name}</td>
                    </tr>
                    <tr>
                        <td style="width: 100px">${message(code: 'my.responsible.name')}</td>
                        <td>${serial.program.consumer}</td>
                    </tr>
                    <tr>
                        <td style="width: 100px">${message(code: 'my.statistical.name')}</td>
                        <td>${message(code: 'my.play.name')}${message(code: 'my.amount.name')}：${serial.program.frequency}</td>
                    </tr>
                    <tr>
                        <td style="width: 100px">${message(code: 'my.keywords.name')}/${message(code: 'my.tally.name')}</td>
                        <td>
                            <g:each in="${serial.program.programTags}">
                                ${it.name}&nbsp;
                            </g:each>
                        </td>
                    </tr>
                </table>
            </div>

            <!--评论-->
            <div class="boful_video_remark" style="display:none;">
                <div class="video_remark_create">
                    主题:<input id="topic">

                    <p></p>
                    <textarea class="photo_remark_create1"
                              id="content">${message(code: 'my.send.name')}${message(code: 'my.review.name')}</textarea>
                    <input type="button" class="photo_remark_create_but" id="remarkBtn" value="发表">
                </div>

                <div class="video_remarks">
                    <g:each in="${serial.program.remarks}" var="remark">
                        <div class="video_remark">
                            <div class="video_remark_user">${remark.consumer.name}：</div>

                            <div class="video_remark_content">${remark.content}</div>

                            <div class="video_remark_user">
                                ${remark.dateCreated}发表
                                <a style="cursor: pointer">回复(${remark.replyNum})</a>
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
                                    <div class="video_remark_user">
                                        ${reply.consumer.name}：${reply.content}
                                        <p>（${reply.dateCreated}）</p>
                                    </div>
                                </g:each>
                            </div>
                        </div>
                    </g:each>

                </div>

            </div>
        </div>
    </div>
</div>
</body>
<script type="text/javascript">
    $(function () {
        $("#content").click(function () {
            $("#content").val('');
        })
        $(".video_remarks a").click(function () {
            var index = $(".video_remarks a").index(this);
            if ($("#remarkName").val() == "${session.consumer?.name}") {
                alert("对不起,不能回复自己发表的评论!")
            } else {
                $(".video_remarks #replayCon").eq(index).show();
            }

        })
        $("#replayContent").click(function () {
            $("#replayContent").val('');
        })
        $("#replayBtn").click(function () {
            var url = "${createLink(controller: 'program',action: 'saveRemarkReply')}";
            var content = $("#replayContent").val();
            var id = $("#remarkId").val();
            var replyNum = $("#replyNum").val();
            $.post(url, {content: content, id: id, replyNum: replyNum}, function (data) {
                if (data.success) {
                    $(".video_remarks #replayCon").hide();
                    alert("回复成功!")
                }

            })
        })
        $("#remarkBtn").click(function () {
            var url = "${createLink(controller: 'program',action: 'saveRemark')}";
            var content = $("#content").val();
            var topic = $("#topic").val();
            var programId =${serial.program.id};
            $.post(url, {content: content, topic: topic, programId: programId}, function (data) {
                if (data.success) {
                    alert("发表评论成功!");
                    var topic = data.topic;
                    var content = data.content;
                    var appendHtml = "<div class='video_remark'>" +
                            "<div class='video_remark_user'>${session.consumer?.name}：</div>" +
                            "<p class='video_remark_content'>" + content + "</p>" +
                            "</div>";
                    $(".video_remarks").after(appendHtml);
                }

            })

        })
    })
</script>
</html>