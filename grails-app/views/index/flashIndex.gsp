<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-21
  Time: 下午6:02
--%>

<%@ page import="nts.utils.CTools; com.boful.common.date.utils.TimeLengthUtils" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${flashName}</title>
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_videoIndex.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_videoIndex.js')}"></script>
</head>

<body>
%{--<div class="boful_img_box">
    <div class="boful_img_container" style="visibility: hidden">
        <div class="boful_img_items">
            <g:each in="${tuijianList}" var="program">
                <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                   target="_blank">
                    <img src="${posterLinkNew(program: program, size: '1024x425')}" class="imgLazy"
                         alt="" width="1024" height="425" border="0"
                         onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'">
                </a>

            </g:each>
        </div>

        <div class="boful_img_bottom">
            <div class="boful_item_titles">
                <g:each in="${tuijianList}" var="program">
                    <div class="boful_item_title">
                        <div class="boful_item_name"><a href="">${program.classLib}</a></div>

                        <div class="boful_item_desc"><a
                                href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                target="_blank">${CTools.cutString(program.name, 10)}</a>
                        </div>
                    </div>
                </g:each>

            </div>

            <div class="boful_item_screenshots">
                <g:each in="${tuijianList}" var="program">
                    <img src="${posterLinkNew(program: program, size: '98x58')}"
                         onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'"
                         width="98"
                         height="58" border="0"/>
                </g:each>
            </div>
        </div>
    </div>
</div>

<div style="height: 1px; background: #FFF;width: 100%;"></div>--}%
<div class="ou_resource_meau_nav">
    <div class="ou_resource_meau_nav_content">
        <a>${flashName}</a>
    </div>


    <div class="res-cla-box">
        <div class="cla-nice">
            <p><span>精选分类:</span>
                <g:each in="${programCategoryList}" var="category" status="i">
                    <a href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: category.id])}"
                       target="_blank">${category.name}</a>
                </g:each>
            </p>
        </div>

        <div class="cla-hot">
            <p><span>热门标签:</span>
                <g:each in="${programTagList}" var="tag">
                    <a href="${createLink(controller: 'index', action: 'search', params: [programTagId: tag.id])}"
                       target="_blank">${CTools.cutString(tag.name, 5)}</a>
                </g:each>
            </p>
        </div>
    </div>
</div>

<div class="boful_video_banner">
    <div class="boful_video_banner_container recommond_pad">
        <div class="boful_banner_item">
            <div class="boful_banner_item_title">
                <h1>${message(code: 'my.newest.name')}${message(code: 'my.resources.name')}</h1>
                <span class="">
                    <a class="boful_banner_item_title_icon"
                       href="${createLink(action: 'search', params: [dateCreated: 'dateCreated'])}" target="_blank"></a>
                </span>
            </div>

            <div class="boful_banner_items">
                <g:each in="${newProgramList}" var="program">
                    <div class="boful_video_item" title="${program.name}">
                        <div class="boful_recommond_video_item_play"><a
                                href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                target="_blank"><img
                                    style="box-shadow: none"
                                    src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_video_item_play_icon.png')}">
                        </a></div>

                        <div class="boful_recommond_video_item_date_new">${message(code: 'my.new.name')}</div>

                        <div class="boful_recommond_video_item_date">
                            %{--${querySerialFirstTimeLength(program: program, type: 'video')}--}%
                        </div>
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                           target="_blank">
                            <img data-original="${posterLinkNew(program: program, size: '160x100')}" class="imgLazy"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                        </a>


                        <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                              target="_blank">${CTools.cutString(program.name, 7)}</a></p>
                    </div>
                </g:each>

            </div>
        </div>

        <div class="boful_banner_item">
            <div class="boful_banner_item_title">
                <h1>${message(code: 'my.recommend.name')}${message(code: 'my.video.name')}</h1><span class="">
                <a class="boful_banner_item_title_icon1"
                   href="${createLink(action: 'search', params: [recommendNum: 'recommendNum'])}" target="_blank"></a>
            </span>
            </div>

            <div class="boful_banner_items">
                <g:each in="${tuijianList}" var="program">
                    <div class="boful_video_item" title="${program.name}">
                        <div class="boful_recommond_video_item_play"><a
                                href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                target="_blank"><img
                                    style="box-shadow: none"
                                    src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_video_item_play_icon.png')}">
                        </a></div>

                        <div class="boful_recommond_video_item_date_hot">${message(code: 'my.hot.name')}</div>

                        <div class="boful_recommond_video_item_date">
                            %{--${querySerialFirstTimeLength(program: program, type: 'video')}--}%
                        </div>
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                           target="_blank">
                            <img data-original="${posterLinkNew(program: program, size: '160x100')}" class="imgLazy"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                        </a>

                        <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                              target="_blank">${CTools.cutString(program.name, 7)}</a></p>
                    </div>
                </g:each>

            </div>
        </div>
    </div>
</div>

<div class="boful_video_container">
    <div class="video_container_left">

        <g:each in="${programCategoryList}" var="programCategory" status="st">
            <div class="video_container_item">
                <div class="container_left_title">
                    <h3><span class="container_left_title_items_title">${programCategory.name}</span>
                        <span class="container_left_title_items_more">
                            <a class="res-add-more"
                               href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: programCategory.id])}"
                               target="_blank">${message(code: 'my.more.name')}</a>
                        </span>
                    </h3>
                </div>

                <div class="boful_video_container_items">
                    <g:each in="${programList[st]}" var="program">
                        <div class="boful_video_item" title="${program.name}">
                            <div class="boful_recommond_video_item_play"><a
                                    href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                    target="_blank"><img
                                        style="box-shadow: none"
                                        src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_video_item_play_icon.png')}">
                            </a></div>

                            <div class="boful_recommond_video_item_date">
                                %{--${querySerialFirstTimeLength(program: program, type: 'video')}--}%
                            </div>
                            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               target="_blank">
                                <img data-original="${posterLinkNew(program: program, size: '160x100')}" class="imgLazy"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                            </a>

                            <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                  target="_blank">${CTools.cutString(program.name, 8)}</a></p>
                        </div>
                    </g:each>
                </div>
            </div>
        </g:each>

    </div>

    %{--<div class="video_container_right">
        <div class="video_container_right_items">
            <div class="video_container_right_item">
                <div class="container_right_title">${message(code: 'my.select.name')}${message(code: 'my.class.name')}</div>

                <div class="container_right_content">
                    <g:each in="${programCategoryList}" var="category" status="i">
                        <g:if test="${i <= 8}">
                            <a href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: category.id])}"
                               target="_blank">${category.name}</a>
                        </g:if>

                    </g:each>

                </div>
            </div>

            <div class="video_container_right_item">
                <div class="container_right_title">${message(code: 'my.hot.name')}${message(code: 'my.tally.name')}</div>

                <div class="container_right_content">
                    <g:each in="${programTagList}" var="tag">
                        <a href="${createLink(controller: 'index', action: 'search', params: [programTagId: tag.id])}"
                           target="_blank">${CTools.cutString(tag.name, 5)}</a>
                    </g:each>
                </div>
            </div>
        </div>
    </div>--}%

</div>
</body>
</html>