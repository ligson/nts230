<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-27
  Time: 下午4:12
--%>

<%@ page import="nts.program.domain.Program; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.courses.name')}${message(code: 'my.list.name')}</title>
    %{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'courseList.css')}">--}%
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'courseIndex.css')}">
    %{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'course_index_c.css')}">--}%
    <script type="text/javascript">
        //显示评分星星
        $(function () {
            var programIds = $("input[name='programId']");//得到所有program
            for (var i = 0; i < programIds.size(); i++) {
                var programId = programIds[i].value;
                var serialLinkValue = $("#serialLink" + programId).val() / 2;
                var serialLinkShowDiv = $("div[name='serialLinkShow" + programId + "']");
                serialLinkShowDiv.raty({readOnly: true, width: 110, score: serialLinkValue});
            }
        })
    </script>

    <script type="text/javascript">
        $(function () {
            var videoItem = $(".course_video_item");
            videoItem.hover(function () {
                $(this).find(".course_video_item_head_see").css("visibility", "visible")
            });
            videoItem.mouseleave(function () {
                $(this).find(".course_video_item_head_see").css("visibility", "hidden")
            })

            //加载页面初始化类别
            $("div[id^='first_second']").hide();
            var isNew = '${isNew}';
            var categoryId = '${categoryId}';
            if (isNew != '1') {
                $("#first_second" + categoryId).show();
            }
            else {
                $("div[id^='first_second']:first").show();
            }

            //当鼠标悬停在一级类别上时的动作
            var parentCategory = $(".boful_body_map_list > div[class^='first']");
            parentCategory.hover(function () {
                var classname = $(this).attr('class');
                var parentId = classname.substring(5);
                $("div[id^='first_second']").hide();
                $("#first_second" + parentId).show();
            })
                    .click(function () {
                        var classname = $(this).attr('class');
                        var parentId = classname.substring(5);
                        location.href = baseUrl + "index/courseList?categoryId=" + parentId;
                    });

        })

    </script>
    <r:require modules="raty"/>
</head>

<body>

<div class="boful_body_container_bg">

    <div class="boful_body_map">
        <div class="boful_body_map_sub">
            <div class="wrap">
                <g:each in="${programCategoryList}" var="category" status="sta">
                    <g:if test="${sta < 8}">
                        <div class="boful_body_map_list">
                            <div class="first${category?.id}">${category?.name}</div>
                        </div>
                    </g:if>
                </g:each>
                <g:if test="${programCategoryList?.size() >= 8}">
                    <div class="boful_body_map_list">
                        <div class="boful_body_map_first"><a
                                href="${createLink(controller: 'index', action: 'search', params: [otherOption: Program.ONLY_LESSION_OPTION])}">${message(code: 'my.more.name')}</a>
                        </div>
                    </div>
                </g:if>
            </div>
        </div>

        <div class="user_cla_res">
            <g:each in="${childCategoryList}" var="childCategory">
                <g:if test="${childCategoryList.get(childCategory.key).collect().size() > 0}">
                    <div class="boful_body_map_sup" id="first_second${childCategory.key}">
                        <p class="wrap">
                            <g:each in="${childCategory.value}" var="category" status="no">
                                <a href="${createLink(controller: 'index', action: 'courseList', params: [categoryId: category?.id])}">${category?.name}<span>|</span>
                                </a>
                            </g:each>
                            <a href="${createLink(controller: 'index', action: 'search', params: [otherOption: Program.ONLY_LESSION_OPTION])}">${message(code: 'my.more.name')}</a>
                        </p>
                    </div>
                </g:if>
            </g:each>
        </div>
    </div>

    <div class="boful_body_container">
        <!---------列表-------------->
        <div class="boful_course_item">
            <div class="course_item_header">
                <h1><a class="course_item_header_title" href="#">
                    <g:if test="${isNew == '1'}">${message(code: 'my.newcourse.name')}${message(code: 'my.recommend.name')}</g:if>
                    <g:else>${parentCategory?.name}</g:else>
                </a>%{--<a class="course_item_header_more" href="#">更多...</a>--}%</h1>
            </div>

            %{--  <div class="course_item_header_line"></div>--}%

            <div class="course_video_items">
                <g:if test="${programList?.size() == 0}">目前没有添加课程!</g:if>
                <g:each in="${programList}" var="program">
                    <div class="course_video_item item_mar">
                        <div class="course_video_item_head">
                            <div class="course_video_item_head_see">
                                <p>
                                    <a title="${CTools.htmlToBlank(program?.description)}"
                                       href="${createLink(controller: 'index', action: 'courseDetail', params: [programId: program?.id])}"
                                       target="_blank">${message(code: 'my.learn.name')}${message(code: 'my.courses.name')}</a>
                                </p>
                            </div>

                            <div class="course_video_item_user">
                                <a title="${program?.consumer?.name}"
                                   href="${createLink(controller: 'my', action: 'userSpace', params: [id: program?.consumer?.id])}">
                                    <div class="course_video_item_user_img">
                                        <img src="${generalUserPhotoUrl(consumer: program?.consumer)}" width="59"
                                             height="59"
                                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                                    </div></a>

                                <div class="course_video_item_user_name"><a title="${program?.consumer?.name}"
                                                                            href="${createLink(controller: 'my', action: 'userSpace', params: [id: program.consumer.id])}">${CTools.cutString(program?.consumer?.name, 8)}</a>
                                </div>
                            </div>
                            <img class="imgLazy course_video_img_m" data-original="${posterLinkNew(program: program, size: '240x130')}"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                        </div>

                        <div class="course_video_item_content">
                            <div class="course_video_item_head_title">
                                <h2><a title="${program?.name}"
                                       href="${createLink(controller: 'index', action: 'courseDetail', params: [programId: program?.id])}"
                                       target="_blank">${nts.utils.CTools.cutString(program?.name, 8)}</a>
                                </h2>

                                <div class="course_video_item_head_title_infor">${nts.utils.CTools.cutString(CTools.htmlToBlank(program?.description), 25)}</div>
                            </div>

                            <div class="course_talk_number">
                                <div class="coures_talk_stars" name="serialLinkShow${program?.id}">
                                </div>
                                <input type="hidden" id="serialLink${program?.id}"
                                       value="${calcProgramScore(program: program)}"/>
                                <input type="hidden" name="programId" value="${program?.id}">
                                <span class="course_video_item_content_talk">(${program?.remarks?.size()}条评价)</span>
                            </div>

                            <div class="course_video_item_mgr">
                                <div class="course_video_item_content_users">
                                    <g:if test="${studyCourse(playedPrograms: program?.playedPrograms) != ''}">
                                        <span class="users_lang">${studyCourse(playedPrograms: program?.playedPrograms)}</span><span
                                            class="users">${message(code: 'my.people.name')}${message(code: 'my.learn.name')}</span>
                                    </g:if>
                                    <g:else>
                                        <span class="users">没有人在学</span>
                                    </g:else>
                                    <span class="course_video_item_content_number">共${publicTotal(serial: program?.serials)}${message(code: 'my.period.name')}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                </g:each>
            </div>
        </div>
        <!---------分页----------->
        <div class="boful_activity_footer_page wrap f_page">
            <p>
                <g:guiPaginate controller="index" action="courseList" total="${total}" params="${params}"/>
            </p>
        </div>
    </div>

</div>
</body>
</html>