<%@ page import="nts.user.domain.Consumer" contentType="text/html;charset=UTF-8" %>
%{--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--}%
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title><g:layoutTitle/>-<g:message code="application.name" default="邦丰资源管理平台"/></title>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <g:include view="layouts/indexCommonResources.gsp"/>
    <script type="text/javascript">
        $(function () {
            var header = $(".userspace_nav_item div");
            header.click(function () {
                $.cookie("header_a_id", $(this).attr("id"));
            });
            var a_id = $.cookie("header_a_id");
            if (a_id) {
                $("#" + a_id).find("a").css("color", "#39a53e").css("border-bottom", "#39a53e 3px solid");
            }

        });
    </script>
    <!--个人空间通用 -->
    <link type="text/css" rel="stylesheet"  href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_communityMgrhover.css')}">
    %{--<link rel="stylesheet" type="text/css"  href="${resource(dir: 'skin/blue/pc/front/css', file: 'ouknow_user_space.css')}">--}%
    %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'hader_page.css')}">--}%
    <g:layoutHead/>
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.hoveraccordion.min.js')}"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#accordion").accordion();
            $("#accordion").accordion("option", "collapsible", true);
            var selectBgId=$.cookie("example")
            $(selectBgId).css({"background":"#4DB652"})
            $.cookie('example', null);

        });
        function setCookie(num){

            $.cookie("example","#selectId"+num);
        }
    </script>
</head>

<body>
<g:include view="layouts/indexHeader.gsp"/>
%{--
<div class="userspace_content wrap5">

    <div class="userspace_left">
        <h3 class="onk_space_fisttitle"><a id="my_index" href="${createLink(controller: 'my', action: 'index')}">学习空间</a></h3>
        <div id="accordion">


            <div>
                <div class="onk_box">
                    <ul class="onk_ul">
                        <li><a id="my_index" href="${createLink(controller: 'my', action: 'index')}">学习空间</a></li>
                    </ul>
                </div>
            </div>

            <h3>活动管理</h3>

            <div>
                <div class="onk_box">
                    <ul class="onk_ul">
                        <li><a id="my_myUserActivityManager"
                               href="${createLink(controller: 'my', action: 'myUserActivityManager')}">活动管理</a></li>
                    </ul>
                </div>
            </div>
            <h3 class="onk_space_title">资源管理</h3>
            <div class="onk_box">
            <ul class="onk_ul">
            <li>  <a href="${createLink(controller: 'my', action: 'myManageProgram')}">资源管理</a></li>
            </ul>
            </div>
            <h3 class="onk_space_title">学习记录</h3>

            <div>
                <div class="onk_box">
                    <ul class="onk_ul">
                        <li><a id="my_myHistoryProgramList"
                               href="${createLink(controller: 'my', action: 'myHistoryProgramList')}">我的课程</a></li>
                        <li><a id="my_myCreatCourseListNews"
                               href="${createLink(controller: 'my', action: 'myCreatCourseListNews')}">创建课程</a></li>
                        <li><a href="${createLink(controller: 'my', action: 'myHistoryProgramList')}">学习提醒</a></li>
                        <li><a id="my_myNotesProgramList"
                               href="${createLink(controller: 'my', action: 'myNotesProgramList')}">我的笔记</a></li>
                        <li><a id="my_myProblemListNews"
                               href="${createLink(controller: 'my', action: 'myProblemListNews')}">我的问题</a></li>
                    </ul>
                </div>
            </div>

            <h3 class="onk_space_title">我的资源</h3>

            <div>
                <div class="onk_box">
                    <ul class="onk_ul">
                        <li><a ref="${createLink(controller: 'my', action: 'createProgram')}">资源上传</a></li>
                        <li><a id="my_myManageProgram"
                               href="${createLink(controller: 'my', action: 'myManageProgram')}">我的资源</a></li>
                        <li><a id="my_myRecommendProgramList"
                               href="${createLink(controller: 'my', action: 'myRecommendProgramList')}">我的推荐</a></li>
                        <li><a href="${createLink(controller: 'my', action: 'myProgramList')}">我的订阅</a></li>
                        <li><a id="my_myCollectProgramList"
                               href="${createLink(controller: 'my', action: 'myCollectProgramList')}">我的收藏</a></li>
                        <li><a href="${createLink(controller: 'my', action: 'myManageProgram')}">回收站</a></li>

                    </ul>
                </div>
            </div>

            <h3 class="onk_space_title">社区管理</h3>

            <div>
                <div class="onk_box">
                    <ul class="onk_ul">

                            <li><a  id="my_communityList" href="${createLink(controller: 'my', action: 'myCreatedCommunity')}">我创建的社区</a></li>
                            <li ><a id="my_communityList1" href="${createLink(controller: 'my', action: 'myJoinedCommunity')}">我加入的社区</a></li>


                    </ul>
                </div>
            </div>
        </div>

    </div>

    <div class="userspace_right">

    </div>

    </div>
</div>

 <div class="">

 </div>--}%
<div class="ouknow_user_space_content">
    <div class="ouknow_user_space_left">
        <div class="ouknow_user_point">
            <div class="ouknow_user_point_img">
                <img src="${generalUserPhotoUrl(consumer: session.consumer)}" title="${session.consumer.name}"/>
            </div>

            <div class="ouknow_user_point_other">
                <p><a href="${createLink(controller: 'my', action: 'userSpace', params: [id: session.consumer.id])}">${session.consumer.name}</a>
                </p>
            </div>
        </div>

        <div class="ouknow_user_fuctions">

            <div class="ouknow_user_write_item">
                <g:if test="${userResourceView(controllerName: 'index', actionName: 'courseIndex') == 'true'}">
                    <div class="u_hover" id="selectId1">
                        <a class="ouknow_user_write_course" onclick="setCookie('1')"
                           href="${createLink(controller: 'my', action: 'myHistoryProgramList')}">${message(code: 'my.mined.name')}${message(code: 'my.courses.name')}</a>
                    </div>

                    <div class="u_hover" id="selectId2">
                        <a class="ouknow_user_write_note" onclick="setCookie('2')"
                           href="${createLink(controller: 'my', action: 'myNotesProgramList')}">${message(code: 'my.mined.name')}${message(code: 'my.notes.name')}</a>
                    </div>

                    <div class="u_hover" id="selectId3">
                        <a class="ouknow_user_write_qusetion" onclick="setCookie('3')"
                           href="${createLink(controller: 'my', action: 'myProblemListNews')}">${message(code: 'my.mined.name')}${message(code: 'my.questions.name')}</a>
                    </div>
                </g:if>


            %{--  <a class="ouknow_user_write_creat"
                 href="${createLink(controller: 'my', action: 'myCreatCourseListNews')}">我创建的课程</a>--}%

            </div>

            <div class="ouknow_user_resource_item">
                <g:if test="${session.consumer.role == Consumer.SUPER_ROLE || session.consumer.role == Consumer.MANAGER_ROLE || userResourceView(controllerName: 'community', actionName: 'index') == 'true'}">
                    <div class="u_hover">
                        <a class="ouknow_user_resource_mine" onclick="setCookie('10')"
                           href="${createLink(controller: 'my', action: 'myManageProgram')}">${message(code: 'my.mined.name')}${message(code: 'my.program.name')}</a>
                    </div>
                </g:if>

                <g:if test="${userResourceView(controllerName: 'community', actionName: 'index') == 'true'}">
                    <div class="u_hover" id="selectId4">
                        <a class="ouknow_user_resource_mine" onclick="setCookie('4')"
                           href="${createLink(controller: 'my', action: 'mySharingList')}">${message(code: 'my.mined.name')}${message(code: 'my.files.name')}</a>
                    </div>

                    <div class="u_hover" id="selectId5">
                        <a class="ouknow_user_resource_album" onclick="setCookie('5')"
                           href="${createLink(controller: 'my', action: 'myAlbumResource')}">${message(code: 'my.mined.name')}${message(code: 'my.album.name')}</a>
                    </div>
                </g:if>
                <g:if test="${userResourceView(controllerName: 'program', actionName: 'recommendProgram') == 'true'}">
                    <div class="u_hover" id="selectId6">
                        <a class="ouknow_user_resource_good" onclick="setCookie('6')"
                           href="${createLink(controller: 'my', action: 'myRecommendProgramList')}">${message(code: 'my.mined.name')}${message(code: 'my.recommend.name')}</a>
                    </div>
                </g:if>
                <g:if test="${userResourceView(controllerName: 'program', actionName: 'collectProgram') == 'true'}">
                    <div class="u_hover" id="selectId7">
                        <a class="ouknow_user_resource_save" onclick="setCookie('7')"
                           href="${createLink(controller: 'my', action: 'myCollectProgramList')}">${message(code: 'my.mined.name')}${message(code: 'my.collect.name')}</a>
                    </div>
                </g:if>
            </div>
            <g:if test="${userResourceView(controllerName: 'community', actionName: 'index') == 'true'}">
                <div class="ouknow_user_connmnity_item">
                    <div class="u_hover" id="selectId8">
                        <a class="ouknow_user_connmnitise_item" id="my_communityList" onclick="setCookie('8')"
                           href="${createLink(controller: 'my', action: 'myCreatedCommunity')}">${message(code: 'my.mined.name')}${message(code: 'my.community.name')}</a>
                    </div>
                </div>
            </g:if>
            <g:if test="${userResourceView(controllerName: 'userActivity', actionName: 'index') == 'true'}">
                <div class="ouknow_user_activity_item">
                    <div class="u_hover" id="selectId9">
                        <a class="ouknow_user_activity_mine" onclick="setCookie('9')"
                           href="${createLink(controller: 'my', action: 'myUserActivityManager')}">${message(code: 'my.mined.name')}${message(code: 'my.activities.name')}</a>
                    </div>
                </div>
            </g:if>
        </div>
    </div>

    <div class="ouknow_user_space_right">
        <g:layoutBody/>
    </div>
</div>
<g:include view="layouts/indexFooter.gsp"/>

</body>
</html>