<%@ page import="nts.utils.CTools; nts.user.domain.Consumer; com.boful.common.date.utils.TimeLengthUtils" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
<title>个人空间首页</title>
    %{--左侧jQuery ui部分 --}%
 <!--   我的空间合并通用 -->
<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_userspace_index.css')}">
%{--<link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_space.css')}"/>--}%
<script type="text/javascript">
    $(function () {
        $(".boful_video_item").hover(function () {
            $(this).find(".boful_recommond_video_item_play_p").css("visibility", "visible");
        });
        $(".boful_video_item").mouseleave(function () {
            $(this).find(".boful_recommond_video_item_play_p").css("visibility", "hidden");
        });

        $(".boful_doc_item").hover(function () {
            $(this).find(".boful_recommond_doc_reading").css("visibility", "visible");
        });
        $(".boful_doc_item").mouseleave(function () {
            $(this).find(".boful_recommond_doc_reading").css("visibility", "hidden");
        });

    });
</script>
</head>

<body>

%{--<div class="userspace_group">--}%
%{--<div class="userspace_title" style="width:750px">--}%
%{--<a href="">我的用户组</a>--}%
%{--</div>--}%

%{--<div class="userspace_group_list">--}%
%{--<g:if test="${userGroup.size() == 0}">--}%
%{--<p class="userspace_group_list_none"><span>目前没有加入任何用户组!</span></p>--}%
%{--</g:if>--}%
%{--<g:each in="${userGroup}" var="user">--}%
%{--<div class="userspace_group_item">--}%
%{--<img src="${resource(dir: 'upload/photo',file:user?.consumers?.first()?.photo )}"--}%
%{--onerror="this.src = '${resource(dir:'images',file:'defaultPoster.jpg')}'"/>--}%

%{--<div class="group_item_content">--}%
%{--<span>--}%
%{--<a href="">${user.name}</a>--}%
%{--</span>--}%

%{--<p>--}%
%{--${user.description}--}%
%{--</p>--}%
%{--</div>--}%
%{--</div>--}%
%{--</g:each>--}%
%{--</div>--}%
%{--</div>--}%

<div class="userspace_history">
    <div class="userspace_title" style="width:100%">
        <a href="">播放记录</a>
    </div>

    <div class="userspace_history_list_video sertspace_newswidth">
        <g:if test="${videoPrograms.size() == 0}">
            <p class="userspace_group_list_none"><span>目前没有视频播放记录!</span></p>
        </g:if>
        <g:each in="${videoPrograms}" var="video" status="st">
            <g:if test="${st < 8}">
                <g:set var="viewProcess"
                       value="${(int) (CTools.nullToZero(video.timeLength) * 100 / CTools.nullToOne(video.serial.timeLength > 0 ? video.serial.timeLength : 1))}"/>
                <div class="boful_video_item boful_video_item_news" title="${video.program.name}">
                    <div class="boful_recommond_video_item_play_p"><a
                            href="${createLink(controller: 'program', action: 'showProgram', params: [id: video.program.id])}"
                            target="_blank">继续观看</a>
                    </div>

                    <div class="boful_recommond_video_item_date">${querySerialFirstTimeLength(program: video?.program, type: 'video')}</div>

                    <div class="boful_recommond_video_item_see"><p
                            style="width:${viewProcess}%"></p>
                    </div>
                    <img src="${posterLinkNew(serial: video.serial, size: '160x100')}"
                         onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'"/>

                    <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: video.program.id])}">${CTools.cutString(video.program.name, 5)}</a>
                        <span class="boful_recommond_video_item_see_icon">看到${CTools.cutString(video.serial.name, 5)}${viewProcess}%</span>
                    </p>
                </div>
            </g:if>

        </g:each>

    </div>

    <div class="userspace_history_list_doc sertspace_newswidth">
        <g:if test="${docPrograms.size() == 0}">
            <p class="userspace_group_list_none"><span>目前没有文档点播记录!</span></p>
        </g:if>
        <g:each in="${docPrograms}" var="doc" status="st">
            <g:if test="${st < 8}">
                <g:set var="viewProcess"
                       value="${(int) (CTools.nullToZero(doc.timeLength) * 100 / CTools.nullToOne(doc.serial.timeLength > 0 ? doc.serial.timeLength : 1))}"/>
                <div class="boful_doc_item boful_video_item_news" title="${doc.program.name}">

                    <div class="boful_doc_video_item_play_p"><a
                            href="#"
                            target="_blank">继续阅读</a>
                    </div>

                    <div class="boful_my_doc_item_infor">共${querySerialFirstTimeLength(program: doc?.program, type: 'doc')}页</div>
                    %{--<div class="boful_doc_video_item_date" style="width:20%"></div>--}%
                    <div class="boful_doc_video_item_date_jd">
                        <div class="boful_doc_video_item_date">
                            <p style="width:${viewProcess}%"></p>
                        </div>
                    </div>
                    %{--        <div class="boful_recommond_doc_reading"><a style=" width: 95px;  height: 127px;"
                                                                        href="${createLink(controller: 'program', action: 'showProgram', params: [id: doc.program.id])}"
                                                                        target="_blank"><img
                                        src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_doc_reading_icon.png')}"/><span>开始阅读</span>
                            </a></div>--}%

                    <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: doc.program.id])}" style="width: 160px;height: 130px; display: block">
                        <img src="${posterLinkNew(serial: doc.serial, size: '95x130')}"
                             onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'"/>
                    </a>

                    <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: doc.program.id])}">${CTools.cutString(doc.program.name, 5)}</a>
                    </p>
                </div>
            </g:if>

        </g:each>

    </div>

</div>

</body>
</html>