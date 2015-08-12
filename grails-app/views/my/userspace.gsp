<%@ page import="nts.utils.CTools; nts.user.domain.Consumer; com.boful.common.date.utils.TimeLengthUtils" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>${message(code: 'my.space.name')}${message(code: 'my.home.name')}</title>
    <meta name="layout" content="index">
<link rel="icon" type="image/x-icon" href="${resource(dir: 'skin/blue/pc/images', file: 'boful_logo.ico')}"/>
    <title>${message(code: 'my.space.name')}${message(code: 'my.home.name')}</title>
    <meta name="layout" content="index">
    <link rel="icon" type="image/x-icon" href="${resource(dir: 'skin/blue/pc/images', file: 'boful_logo.ico')}"/>

    %{--用户空间HEADER,FOOTER等通用CSS--}%

%{--空间主页BODY样式--}%
<link type="text/css" rel="stylesheet"  href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_communityMgrhover.css')}"/>
<link type="text/css" rel="stylesheet"  href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_userspace_index.css')}"/>
%{--空间整体样式 my_space.css--}%
<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_userspace.css')}">

%{--空间资源图片鼠标效果--}%
<script type="text/javascript">
    $(function () {
        var videoItem = $(".boful_video_item");
        videoItem.hover(function () {
            $(this).find(".boful_recommond_video_item_play_p").css("visibility", "visible");
        });
        videoItem.mouseleave(function () {
            $(this).find(".boful_recommond_video_item_play_p").css("visibility", "hidden");
        });

        var docItem = $(".boful_doc_item");
        docItem.hover(function () {
            $(this).find(".boful_recommond_doc_reading").css("visibility", "visible");
        });
        docItem.mouseleave(function () {
            $(this).find(".boful_recommond_doc_reading").css("visibility", "hidden");
        });
    });
</script>
%{--这里js以及被模板引入了--}%
%{--<script type="text/javascript" src="${resource(dir: 'js/boful/index', file: 'index_base.js')}"></script>--}%
</head>

<body>

%{--///////////////////////--}%
%{--<div class="boful_toolbar boful_toolbar_flo">--}%
%{--<div class="wrap">--}%
%{--<g:if test="${session.consumer}">--}%
%{--<a href="${createLink(controller: 'index', action: 'index')}"><span class="user_space_back"--}%
%{--style="color: #f4f4f4">返回首页</span>--}%
%{--</a>--}%

%{--<p><span style="color: #f4f4f4">欢迎你！</span>--}%
%{--<a class="head_portrait" href="${createLink(controller: 'my', action: 'index')}"><img--}%
%{--src="${generalUserPhotoUrl(consumer: session.consumer)}" width="20" height="20"--}%
%{--onerror="this.src = '${resource(dir: 'images', file: 'default.gif')}'"/></a>--}%
%{--<a style="color: #FFF" class="user_name" href="${createLink(controller: 'my', action: 'index')}">--}%
%{--${session.consumer.name}--}%
%{--</a>--}%
%{--<a style="color: #f4f4f4" href="${createLink(controller: 'index', action: 'logout')}">退出</a>--}%

%{--</p>--}%
%{--</g:if>--}%
%{--</div>--}%
%{--</div>--}%
<div class="userspace_background_head_img">
    <div class="wrap userspace_background_img wrap">
        <div class="userspace_header">
            <div class="users_portrait">
                %{--<a href="#">--}%
                %{--<div class="users_portrait_size">--}%
                <a href="${createLink(controller: 'my', action: 'myInfo')}">
                    <img src="${generalUserPhotoUrl(consumer: consumer)}"
                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"
                         width="120" height="120"/></a>
                %{--</div>--}%
                %{--</a>--}%
            </div>

            <div class="userspace_infor">
                <div class="userspace_name">
                    <p class="userspace_title">${consumer?.name}</p>
                    <span class="userspace_name_identity">
                        <g:if test="${consumer.role == 0}">
                            ${message(code: 'my.supermaster.name')}
                        </g:if>
                        <g:if test="${consumer.role == 1}">
                            ${message(code: 'my.resourcemaster.name')}
                        </g:if>
                        <g:if test="${consumer.role == 2}">
                            ${message(code: 'my.teacher.name')}
                        </g:if>
                        <g:if test="${consumer.role == 3}">
                            ${message(code: 'my.student.name')}
                        </g:if>

                    </span>
                </div>

                %{--<div class="userspace_datum">
                    <input type="button" value="编辑资料" id="editUser" class="edit_userspace">
                   --}%%{-- <span>${session.consumer?.college?.name}</span>--}%%{--
                </div>--}%
            </div>
        </div>
    </div>
</div>

<div class="userspace_background wrap">

    <div class="userspace_content wrap tabs">
        <div class="userspace_header_items tabs_nav">
            %{--<li class="userspace_header_item" id="my_id_8"><a--}%
            %{--href="${createLink(controller: 'my', action: 'index')}">主页</a></li>--}%
            <ul>
            <li class="userspace_header_item"><a href="javascript:void(0)"
                                                 class="cur">${message(code: 'my.homepage.name')}</a></li>
            <li class="userspace_header_item"><a
                    href="javascript:void(0)">${message(code: 'my.userinformation.name')}</a></li>
        </ul>
            %{--<li class="userspace_header_item" id="my_id_2"><a--}%
            %{--href="${createLink(controller: 'my', action: 'myInfo')}">个人资料</a>--}%
            %{--</li>--}%

        </div>

        <div class="container">

            <div class="sub-con userspace_history cur-sub-con">

                <div class="userspace_history_list_video userspace_width">
                    <div class="userspace_title">
                        <a href="">${message(code: 'my.resources.name')}${message(code: 'my.courses.name')}</a>
                    </div>
                    <g:if test="${programList.size() == 0}">
                        <p class="userspace_group_list_none"><span>目前用户无资源!</span></p>
                    </g:if>
                    <g:each in="${programList}" var="program" status="st">
                        <g:if test="${st < 10}">
                            <div class="boful_video_item userspace_video_width" style="height: 125px;"
                                 title="${program.name}">
                                <div class="boful_recommond_video_item_play_p"><a
                                        href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                        target="_blank">${message(code: 'my.play.name')}</a>
                                </div>

                                <div class="boful_recommond_video_item_date">
                                    ${program.specialName}
                                </div>

                                <img src="${posterLinkNew(program: program, size: '160x100')}"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>

                                <p class="userspace_p_width" style="height: 30px;"><a
                                        href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}">${CTools.cutString(program.name, 5)}</a>

                                </p>
                            </div>
                        </g:if>

                    </g:each>

                </div>

            </div>

            <div class="sub-con">
                <div class="userspace_history_list_video userspace_width">
                    %{--<div class="userspace_title">--}%
                    %{--<a href="">个人资料</a>--}%
                    %{--</div>--}%
                    <div class="personal_data">
                        <ul>
                            <li><span>${message(code: 'my.nickname.name')}：</span>${consumer.nickname}</li>
                            <li><span>${message(code: 'my.gender.name')}：</span>${consumer.gender == 1 ? "男" : "女"}</li>
                            <li><span>${message(code: 'my.live.name')}：</span>${consumer.address}</li>
                            <li><span>${message(code: 'my.personal.name')}：</span>${consumer.descriptions}</li>
                        </ul>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        var intervalID;
        var curLi;
        var tabNav = $(".tabs_nav li a");
        tabNav.mouseover(function () {
            curLi = $(this);
//鼠标移入的时候有一定的延时才会切换到所在项，防止用户不经意的操作
            intervalID = setInterval(onMouseOver, 250);
        });
        function onMouseOver() {
            $(".cur-sub-con").removeClass("cur-sub-con");
            $(".sub-con").eq(tabNav.index(curLi)).addClass("cur-sub-con");
            $(".cur").removeClass("cur");
            curLi.addClass("cur");
        }

        tabNav.mouseout(function () {
            clearInterval(intervalID);
        });

//鼠标点击也可以切换
        tabNav.click(function () {
            clearInterval(intervalID);
            $(".cur-sub-con").removeClass("cur-sub-con");
            $(".sub-con").eq(tabNav.index(curLi)).addClass("cur-sub-con");
            $(".cur").removeClass("cur");
            curLi.addClass("cur");
        });

    });
</script>
</body>
</html>