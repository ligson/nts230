<%@ page import="nts.program.domain.Serial; nts.program.domain.PlayedProgram; nts.utils.CTools; nts.program.domain.Program" %>
<html>
<head>
%{--<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>--}%
    <title>${message(code: 'my.mined.name')}${message(code: 'my.courses.name')}</title>
    %{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'myHistoryProgramlist.css')}">--}%
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
%{--<script type="text/javascript" src="${resource(dir: 'js', file: 'truevod.js')}"></script>--}%
<SCRIPT LANGUAGE="JavaScript" type="text/javascript">
    <!--
    function submitSch() {
        document.form1.submit();
    }
    function onPageNumPer(max) {
        document.form1.max.value = max;
        document.form1.offset.value = 0;
        submitSch();
    }
    //如果右边页面用类库(目录) 则metaId2是目录ID，enumId2为0 名称后缀2表示是右边的类别,如此设计是为了用户如果...
    function categorySch(metaId2, enumId2) {
        document.form1.metaId2.value = metaId2;
        document.form1.keyword.value = "";//点击时不使用搜索条件
        submitSch();
    }

    function init() {
        changePageImg(${CTools.nullToOne(params.max)});
    }
    //-->
</SCRIPT>
<Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css  rel=stylesheet>
%{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_coursesytyle.css')}">--}%
<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'dropdown.js')}"></script>
%{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'myHistoryProgramlist_course.css')}">--}%
<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_userspace_index.css')}">
</head>

<body>

<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.mined.name')}${message(code: 'my.courses.name')}</a>
</div>

<div class="tabs_nav">
    <ul>
        <li><a href="javascript:void(0)"
               <g:if test="${flag == 1}">class="cur"</g:if>>${message(code: 'my.unfinished.name')}${message(code: 'my.courses.name')}</a>
        </li>
        <li><a href="javascript:void(0)"
               <g:if test="${flag == 2}">class="cur"</g:if>>${message(code: 'my.completed.name')}${message(code: 'my.courses.name')}</a>
        </li>
        <li><a href="javascript:void(0)"
               <g:if test="${flag == 3}">class="cur"</g:if>>${message(code: 'my.collection.name')}${message(code: 'my.courses.name')}</a>
        </li>
    </ul>
</div>


<div class="container" style="margin:0; padding: 0;">
    <div class="sub-con userspace_history <g:if test="${flag == 1}">cur-sub-con</g:if>">
        <div class="userspace_history_list_video">

        %{--添加课程--}%

            <g:each in="${unfinishedProgramList}" var="play">
                <div class="course_video_item">
                    <div class="course_video_item_head">
                        <div style="visibility: hidden;" class="course_video_item_head_see">
                            <p>
                                <a title="" href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: 225])}">
                                    ${message(code: 'my.learn.name')}${message(code: 'my.course.name')}
                                </a>
                            </p>
                        </div>

                        <div class="course_video_item_user">
                            <div class="course_video_item_user_name">${message(code: 'my.lecturer.name')}:${play?.program?.actor}</div>
                        </div>
                        <img class="imgLazy course_img_size" data-original="${posterLinkNew(program: play?.program, size: '160x100')}"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                    </div>
                    <span class="course_video_item_content_study">
                        <a target="_blank" href="${createLink(controller: 'program', action: 'courseView', params: [serialId: play?.serial?.id])}"
                           class="btn btn-success">${message(code: 'my.continue.name')}
                        ${message(code: 'my.learn.name')}
                        </a>
                        %{--<a href="${createLink(controller: 'my', action: 'deleteHistoryProgram', params: [id: play?.program?.id])}"
                            class="btn btn-danger">删除</a>--}%</span>

                    <div class="course_video_item_content">
                        <div class="course_video_item_head_title">
                            <h2><a title="${play?.program?.name}"
                                   href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: play?.program?.id])}">${CTools.cutString(play?.program?.name, 6)}</a>
                            </h2>

                            <div class="course_video_item_head_title_infor"><span
                                    style="height: 5px; width:${programPercent(program: play?.program, serialNo: play?.serial?.serialNo)}; background-color:#2d84af; display: block"></span>
                            </div>
                        </div>

                        <div class="course_video_item_mgr">
                            <div class="course_video_item_content_users"><span
                                    class="users">${PlayedProgram.findAllByProgram(play?.program)?.size()}${message(code: 'my.people.name')}${message(code: 'my.learn.name')}</span>
                                <span class="course_video_item_content_number">共${play?.program?.serials?.size()}${message(code: 'my.period.name')}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </g:each>

        </div>
        %{--我的课程介绍--}%
    </div>

    <div class="sub-con <g:if test="${flag == 2}">cur-sub-con</g:if>">

    %{--添加课程--}%
        <g:each in="${finishedProgramList}" var="pro">
            <div class="course_video_item">
                <div class="course_video_item_head">
                    <div style="visibility: hidden;" class="course_video_item_head_see">
                        <p><a title=""
                              href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: 225])}">${message(code: 'my.learn.name')}${message(code: 'my.courses.name')}</a>
                        </p>
                    </div>

                    <div class="course_video_item_user">
                        <div class="course_video_item_user_name">${message(code: 'my.lecturer.name')}:${pro?.program?.actor}</div>
                    </div>
                    <img class="imgLazy course_img_size" data-original="${posterLinkNew(program: pro?.program, size: '160x100')}"
                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                </div>
                <span class="course_video_item_content_study"><a target="_blank"
                                                                 href="${createLink(controller: 'program', action: 'courseView', params: [serialId: pro?.serial?.id])}"
                                                                 class="btn btn-success">${message(code: 'my.continueTo.name')}${message(code: 'my.learn.name')}</a>%{-- <a
                        href="${createLink(controller: 'my', action: 'deleteHistoryProgram', params: [id: pro?.program?.id])}"
                        class="btn btn-danger">删除</a>--}%</span>

                <div class="course_video_item_content">
                    <div class="course_video_item_head_title">
                        <h2><a title="${pro?.program?.name}"
                               href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: pro?.program?.id])}">${CTools.cutString(pro?.program?.name, 6)}</a>
                        </h2>

                        <div class="course_video_item_head_title_infor">
                        </div>
                    </div>

                    <div class="course_video_item_mgr">
                        <div class="course_video_item_content_users"><span
                                class="users">${PlayedProgram.findAllByProgram(pro?.program)?.size()}${message(code: 'my.people.name')}${message(code: 'my.learn.name')}</span>
                            <span class="course_video_item_content_number">共${pro?.program?.serials?.size()}${message(code: 'my.period.name')}</span>
                        </div>
                    </div>
                </div>
            </div>
        </g:each>
    </div>

    <div class="sub-con <g:if test="${flag == 3}">cur-sub-con</g:if>">
        <div class="userspace_history_list_video">
            <g:each in="${historyCollected}" var="pro">
                <div class="course_video_item">
                    <div class="course_video_item_head">
                        <div style="visibility: hidden;" class="course_video_item_head_see">
                            <p><a title=""
                                  href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: 225])}">${message(code: 'my.learn.name')}${message(code: 'my.courses.name')}</a>
                            </p>
                        </div>

                        <div class="course_video_item_user">
                            <div class="course_video_item_user_name">${message(code: 'my.lecturer.name')}:${pro?.program?.actor}</div>
                        </div>
                        <img class="imgLazy course_img_size" data-original="${posterLinkNew(program: pro?.program, size: '160x100')}"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                    </div>
                    <span class="course_video_item_content_study">
                        <a target="_blank"
                           href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: pro?.program?.id])}"
                           class="btn btn-success">${message(code: 'my.learn.name')}</a>
                        <a href="${createLink(controller: 'my', action: 'deleteCollectProgram', params: [idList: pro?.id.toString(), fromUri: "myHistoryProgramList"])}"
                           class="btn btn-danger">${message(code: 'my.delete.name')}</a>
                    </span>

                    <div class="course_video_item_content">
                        <div class="course_video_item_head_title">
                            <h2>
                                <a title="${pro?.program?.name}"
                                   href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: pro?.program?.id])}">${CTools.cutString(pro?.program?.name, 6)}</a>
                            </h2>

                            <div class="course_video_item_head_title_infor"></div>
                        </div>

                        <div class="course_video_item_mgr">
                            <div class="course_video_item_content_users"><span
                                    class="users">${PlayedProgram.findAllByProgram(pro?.program)?.size()}${message(code: 'my.people.name')}${message(code: 'my.learn.name')}</span>
                                <span class="course_video_item_content_number">共${pro?.program?.serials?.size()}${message(code: 'my.period.name')}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </g:each>
        </div>
    </div>
    %{--我的课程介绍--}%
</div>

<div class="page">
    <g:guiPaginate controller="my" action="myHistoryProgramList" total="${total}" params="[flag: flag]"/>
</div>
</div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        var tabNav = $(".tabs_nav li a");
        tabNav.click(function () {
            var index = $(".tabs_nav li a").index(this);
            var flag = 1;
            if (index == 0) {
                flag = 1;
            }
            else if (index == 1) {
                flag = 2;
            }
            else if (index == 2) {
                flag = 3;
            }
            window.location.href = baseUrl + 'my/myHistoryProgramList?flag=' + flag + '&offset=0';
        });
        /*
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
         */
    });
</script>
</body>
</html>

