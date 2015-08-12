<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 13-12-19
  Time: 下午8:06
--%>

<%@ page import="mooc.course.services.CourseAppService; java.text.SimpleDateFormat; nts.program.category.domain.ProgramCategory; com.boful.common.date.utils.TimeLengthUtils; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>${message(code: 'my.index.name')}</title>
    <meta name="baidu-site-verification" content="Cf3C4H2N13"/>
    <meta name="keywords"
          content="${message(code: "application.name", default: "邦丰资源管理平台")},最新电影,教育资源,资源平台,mooc平台,教育咨询,数字资源,邦丰,vod,课件,数字资源管理"/>
    <meta name="description"
          content="北京邦丰信息技术有限公司是国内专业从事网络多媒体和网络通信软件研发、服务，并且完全自有核心技术的高新技术企业。自2002年推出邦丰视音频服务系列产品以来，产品以领先的技术、卓越的性能、完善易用的管理功能、细致周到的服务，赢得了广大用户的认同和信赖，在同类产品市场的占有率连年稳居国内第一！"/>
    <meta name="layout" content="index">
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/' + frontTheme() + '/pc/front/css', file: 'index_index.css')}"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_index.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.lazyload.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.flexslider-min.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'jquery.shuffling.js')}"></script>
    <!--[if lt IE 7]>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'boful_global_iehack.css')}">
<![endif]-->

    <script type="text/javascript">

    $(function () {
            var imgArr = $(".boful_item").find("img");
            var len = imgArr.length;
            var loadCount = 0;
            if (len == 0) {
                $(".boful_item_loading").hide();
            }
            $.each(imgArr, function (index, data) {

                $(data).load(function () {
                    //alert($(this).attr("src"));
                    loadCount++;
                    if (loadCount >= len / 2) {
                        $(".boful_item_loading").hide();
                        $(".boful_item").show();
                    }
                });


            });

            //头部banner
            $('.flexslider').flexslider({
                directionNav: true,
                pauseOnAction: false
            });

            //头部推荐
            $('#carousel ul').carouFredSel({
                prev: '#prev',
                next: '#next',
                pagination: "#pager",
                scroll: 2000
            });


            //头部通知公告和资讯切换
            $(".cla-t-v").click(function () {
                $(".cla-t-v").addClass("c-cli");
                $(".cla-t-n").removeClass("c-cli");
                $(".cla-voices").hide();
                $(".cla-news").show();
            });

            $(".cla-t-n").click(function () {
                $(".cla-t-n").addClass("c-cli");
                $(".cla-t-v").removeClass("c-cli");
                $(".cla-voices").show();
                $(".cla-news").hide();
            });

            $(".tab_menu").find("li").mouseenter(function () {
                var parent = $(this).parent("ul");
                var index = parent.find("li").index($(this));
                var tabBox = parent.next();
                tabBox.find(">div").hide();
                $(tabBox.find(">div")[index]).show();
            });
        })

        $(function () {
            //修改音频背景颜色不显示
            $("#hotAudio").css("background", "#1771AC");
            $(".caroufredsel_wrapper").css("width", "940px");
        });
    </script>
</head>

<body>

<div class="boful_img_box">
    <div class="wrap">
        <div class="bf-cla-box">
            <div class="bf-cla-voice">
                <div class="cla-voice-item">
                    <div class="cla-v">

                        <h2 class="cla-t">
                            <span class="cla-t-v c-cli">公告</span>
                            <span class="cla-t-n ">资讯</span>
                        </h2>

                        <div class="cla-voices" style="display: none">
                            <g:each in="${newsList}" var="news">
                                <p title="${news.title}"><span><em>■</em></span><a
                                        href="${createLink(controller: 'index', action: 'showNews', params: [id: news.id])}">${news.title}</a>
                                </p>
                            </g:each>
                        </div>

                        <div class="cla-news" style="display: block">

                            <div class="c-n-in"><img src="${resource(dir: 'images', file: 'vice.png')}"/>
                                <i>${nts.utils.CTools.htmlToBlank(application?.sysNotice)}</i>
                            </div>

                        </div>

                    </div>
                </div>

                <div class="cla-app">
                    <div class="cla-app-left">
                        <img src="${resource(dir: 'images', file: 'boful_app_down.png')}"/>
                    </div>

                    <div class="cla-app-infor">
                        <p class="app-in-img"><img src="${resource(dir: 'images', file: 'an-img.png')}"/></p>

                        <p class="app-in-size">移动学习助手</br>等你体验</p>
                    </div>
                </div>
            </div>

            %{-- <div class="bf-cla-items">
             </div>--}%
        </div>

        <div class="bf-cla-btm">
            <a href="${createLink(controller: 'index', action: 'moocIndex')}" class="b-mar">
                <span>Mooc</span>
                <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'path-mooc1.png')}"/>
            </a>
            <a href="${createLink(controller: 'userActivity', action: 'index')}">
                <span>校园活动</span>
                <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'path-mooc3.png')}"/></a>
            <a href="${createLink(controller: 'community', action: 'index')}" class="b-mar">
                <span>学习社区</span>
                <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'path-mooc2.png')}"/>
            </a>
        </div>
    </div>
    <!----------banner----------->
    <div class="boful_img_box_container" style="visibility:hidden;">
        <!--大海报图片-->
        <div class="boful_container_img">
            <!-------图片切换-------->
    <div class="flexslider">
        <ul class="slides">
            <g:each in="${remenList}" var="program">
                        <li title="${program.name}">
                            <a target="_blank"
                               href="${createLink(controller: "program", action: "showProgram", params: [id: program.id])}">
                                <img src="${posterLinkNew(program: program, size: '540x280')}"/></a>
                        </li>
                    </g:each>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="boful_content_header" style="background: #FFF;">
    <div class="boful_content_header_container">

        <div class="boful_recommond">
            <div class="boful_recommond_title recommond_pad">
                <h2>${message(code: 'my.resources.name')}${message(code: 'my.recommend.name')}</h2>

                <p class="boful_recommond_title_cut">
                    <span class="tltle_prior" onclick="prior_btn()"></span>
                    <span class="tltle_next" onclick="next_btn()"></span>
                </p>
            </div>
            <!--视频+图片+音频-->
            <div class="video_inner" id="video_inner">
                <div class="video_inner_program" id="video_inner_program">
                    %{--<g:each in="${tuijianList}" var="program">
                        <div class="boful_video_item" title="${program.name}">

                            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               target="_blank">
                                <img src="${resource(dir: 'images/poster', file: program.posterName)}" width="160"
                                     height="100"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                            </a>

                            <div class="boful_recommond_video_name">
                                <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                   target="_blank">${CTools.cutString(program.name, 10)}</a>
                            </div>

                        </div>
                    </g:each>--}%
                </div>
            </div>
            <!--文档-->
            <div class="boful_recommond_doc">
                <div class="ul_rec_arrow">
                    <span id="prev" class="prev-l"></span>
                    <span id="next" class="next-r"></span>
                </div>

                <div id="wrapper">
                    <div id="carousel">
                        <ul>
                            <g:each in="${wendangList}" var="program" status="pro">
                                <li class="boful_doc_item" title="${program.name}">

                                    <div class="boful_recommond_doc_item_infor_hot">${message(code: 'my.hot.name')}</div>

                                    <div class="boful_recommond_doc_item_infor">共${querySerialFirstTimeLength(program: program, type: 'doc')}页</div>
                                    <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                       target="_blank">
                                        <img src="${resource(dir: 'images/poster', file: program.posterName)}"
                                             width="97" height="127" class="imgLay"
                                             href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                             target="_blank"
                                             onerror="
                                             this.src='${resource(dir: 'skin/blue/pc/front/images', file: 'p_nav_thumbs.png')}'">
                                    </a>

                                    <div class="boful_recommond_video_name">
                                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                           target="_blank">${CTools.cutString(program.name, 5)}</a>
                                    </div>
                                </li>
                            </g:each>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!---------开放课程------>
<g:if test="${programList.size() > 0}">
    <g:each in="${programList}" var="model" status="stt">
        <g:set var="categoryType" value="${model?.mediaType}"/>
        <g:set var="categoryName" value="${model?.categoryName}"/>
        <g:set var="categoryId" value="${model?.categoryId}"/>
        <g:set var="programList1" value="${model?.secondCategoryMap}"/>
        <g:if test="${programList1 && programList1.size() > 0}">
            <div class="boful_content_item" ${stt % 2 == 0 ? "style=\"background:#f4f4f4\"" : ""}>
                <div class="boful_content_container width-doc">
                    <div class="boful_video_left">
                        <g:if test="${categoryType == 3}">
                            <div class="left-cla-tit">
                                <h2>
                                    <a target='_blank'
                                       href="${createLink(controller: 'index', action: 'docIndex')}">${categoryName}</a>
                                </h2>
                            </div>

                            <div class="left-cla-big">
                                <div class="left-cla-t">
                                    <p>${categoryName}</p>
                                </div>
                                <a target='_blank' href="${createLink(controller: 'index', action: 'docIndex')}"><img
                                        src="${resource(dir: 'upload/programCategoryImg', file: "i_" + ((int) (categoryId)) + ".jpg")}"
                                        width="220" height="385"
                                        onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'resource_img_1.png')}'"/>
                                </a>
                            </div>
                        </g:if>
                        <g:elseif test="${categoryType == 5}">
                            <div class="left-cla-tit">
                                <h2>
                                    <a target='_blank'
                                       href="${createLink(controller: 'index', action: 'courseIndex')}">${categoryName}</a>
                                </h2>
                            </div>

                            <div class="left-cla-big">
                                <div class="left-cla-t">
                                    <p>${categoryName}</p>
                                </div>
                                <a target='_blank' href="${createLink(controller: 'index', action: 'courseIndex')}"><img
                                        src="${resource(dir: 'upload/programCategoryImg', file: "i_" + ((int) (categoryId)) + ".jpg")}"
                                        width="220" height="385"
                                        onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'resource_img_1.png')}'"/>
                                </a>
                            </div>
                        </g:elseif>
                        <g:elseif test="${categoryType == 4}">
                            <div class="left-cla-tit">
                                <h2>
                                    <a target='_blank'
                                       href="${createLink(controller: 'index', action: 'imageIndex')}">${categoryName}</a>
                                </h2>
                            </div>

                            <div class="left-cla-big">
                                <div class="left-cla-t">
                                    <p>${categoryName}</p>
                                </div>
                                <a target='_blank' href="${createLink(controller: 'index', action: 'imageIndex')}"><img
                                        src="${resource(dir: 'upload/programCategoryImg', file: "i_" + ((int) (categoryId)) + ".jpg")}"
                                        width="220" height="385"
                                        onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'resource_img_1.png')}'"/>
                                </a>
                            </div>
                        </g:elseif>
                        <g:elseif test="${categoryType == 1}">
                            <div class="left-cla-tit">
                                <h2>
                                    <a target='_blank'
                                       href="${createLink(controller: 'index', action: 'videoIndex')}">${categoryName}</a>
                                </h2>
                            </div>

                            <div class="left-cla-big">
                                <div class="left-cla-t">
                                    <p>${categoryName}</p>
                                </div>
                                <a target='_blank' href="${createLink(controller: 'index', action: 'videoIndex')}"><img
                                        src="${resource(dir: 'upload/programCategoryImg', file: "i_" + ((int) (categoryId)) + ".jpg")}"
                                        width="220" height="385"
                                        onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'resource_img_1.png')}'"/>
                                </a>
                            </div>
                        </g:elseif>
                        <g:elseif test="${categoryType == 2}">
                            <div class="left-cla-tit">
                                <h2>
                                    <a target='_blank'
                                       href="${createLink(controller: 'index', action: 'audioIndex')}">${categoryName}</a>
                                </h2>
                            </div>

                            <div class="left-cla-big">
                                <div class="left-cla-t">
                                    <p>${categoryName}</p>
                                </div>
                                <a target='_blank'
                                   href="${createLink(controller: 'index', action: 'audioIndex')}"><img
                                        src="${resource(dir: 'upload/programCategoryImg', file: "i_" + ((int) (categoryId)) + ".jpg")}"
                                        width="220" height="385"
                                        onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'resource_img_1.png')}'"/>
                                </a>
                            </div>
                        </g:elseif>
                        <g:elseif test="${categoryType == 6}">
                            <div class="left-cla-tit">
                                <h2>
                                    <a target='_blank'
                                       href="${createLink(controller: 'index', action: 'flashIndex')}">${categoryName}</a>
                                </h2>
                            </div>

                            <div class="left-cla-big">
                                <div class="left-cla-t">
                                    <p>${categoryName}</p>
                                </div>
                                <a target='_blank'
                                   href="${createLink(controller: 'index', action: 'flashIndex')}"><img
                                        src="${resource(dir: 'upload/programCategoryImg', file: "i_" + ((int) (categoryId)) + ".jpg")}"
                                        width="220" height="385"
                                        onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'resource_img_1.png')}'"/>
                                </a>
                            </div>
                        </g:elseif>
                        <g:else>
                            <div class="left-cla-tit">
                                <h2>
                                    <a target='_blank'
                                       href="${createLink(controller: 'index', action: 'videoIndex')}">${categoryName}</a>
                                </h2>
                            </div>

                            <div class="left-cla-big">
                                <div class="left-cla-t">
                                    <p>${categoryName}</p>
                                </div>
                                <a target='_blank' href="${createLink(controller: 'index', action: 'videoIndex')}"><img
                                        src="${resource(dir: 'upload/programCategoryImg', file: "i_" + ((int) (categoryId)) + ".jpg")}"
                                        width="220" height="385"
                                        onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'resource_img_1.png')}'"/>
                                </a>
                            </div>
                        </g:else>
                    </div>

                    <div class="boful_video_mid">
                        <div class="box tab-cut">
                            <ul class="tab_menu" menuId="${stt}">
                                <g:each in="${programList1}" var="category" status="sta">
                                    <g:if test="${sta <= 5}">
                                        <li><a cid="${category?.id}"
                                               href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: category?.id])}">${category?.name}</a>
                                        </li>
                                    </g:if>
                                </g:each>
                                <g:if test="${programList1.size() > 5}">
                                    <li><a class="con-more"
                                           href="${createLink(controller: 'index', action: 'search')}">更多</a></li>
                                </g:if>
                            </ul>

                        </div>
                    </div>
                </div>
            </div>
            </div>
        </g:if>
    </g:each>
</g:if>

<!-- 热门资源模板 -->
%{--<div id="remenTemplate" style="display: none">
    <li>
        <a target="_blank"
           href="">
            <img src=""/></a>
    </li>
</div>--}%

<!-- 视频推荐模板 -->
<div id="videoTemplate" style="display: none">
    <div class="boful_video_item">
        <a href=""
           target="_blank">
            <img src="" width="160" height="100"
                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
        </a>

        <div class="boful_recommond_video_name">
            <a href=""
               target="_blank"></a>
        </div>
    </div>
</div>

<!-- 文档推荐模板 -->
%{--<div id="wendangTemplate" style="display: none">
    <li class="boful_doc_item">
        <div class="boful_recommond_doc_item_infor_hot">${message(code: 'my.hot.name')}</div>

        <div class="boful_recommond_doc_item_infor"></div>
        <a href=""
           target="_blank">
            <img src="" width="97" height="127" class="imgLay"
                 href=""
                 target="_blank"
                 onerror="this.src='${resource(dir: 'skin/blue/pc/front/images', file: 'p_nav_thumbs.png')}'">
        </a>

        <div class="boful_recommond_video_name">
            <a href="" target="_blank"></a>
        </div>
    </li>
</div>--}%

<!-- 资源库模板 -->
<div id="programTemplate" style="display: none">
    <div></div>
</div>

<div id="proItem" style="display: none">
    <div>
        <div id="proItemPlay">
            <a id="proItemPlayHref" href="" target="_blank">
                <img style="box-shadow: none"
                     src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_video_item_play_icon.png')}">
            </a>
        </div>

        <div id="proItemData"></div>
        <a id="proItemHref" href="" target="_blank">
            <img onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
        </a>

        <p>
            <a href="" target="_blank"></a>
        </p>
    </div>
</div>
</body>
</html>