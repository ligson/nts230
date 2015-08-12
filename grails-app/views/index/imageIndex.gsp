<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-21
  Time: 下午6:02
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>
        %{-- ${message(code: 'my.teaching.name')}${message(code: 'my.material.name')} --}%
        ${photoName}
    </title>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_image.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_videoIndex.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.lazyload.js')}"></script>
    <script type="text/javascript">
        $(function () {
            //$(".boful_item_loading").style("display",block);
            var imgArr = $(".boful_img_items").find("img");
            var len = imgArr.length;
            var loadCount = 0;
            $.each(imgArr, function (index, data) {

                $(data).load(function () {
                    //alert($(this).attr("src"));
                    loadCount++;
                    if (loadCount >= len / 2) {
                        $(".boful_item_loading").hide();
                        $(".boful_img_items").show();
                    }
                });
            });
            /*imgArr.load(function(){
             $(this).attr("src");
             });*/
            //alert(imgArr.length);
        });
    </script>

</head>

<body>
<div class="ou_resource_meau_nav">
    <div class="ou_resource_meau_nav_content">
        <a>
            %{-- ${message(code: 'my.teaching.name')}${message(code: 'my.material.name')} --}%
            ${photoName}
        </a>
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
%{--<div class="boful_img_box">

    <div class="boful_img_container" style="visibility: hidden">
        <div class="boful_item_loading" style="display:block;background: #252B33;"><img
                src="${resource(dir: 'skin/blue/pc/front/images', file: 'unknow_loading.gif')}" width="128"
                height="15" style="margin-top: 100px;"/></div>
        <div class="boful_img_items" >

            <g:each in="${photoList}" var="program">
                <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                   target="_blank">
                    <img src="${posterLinkNew(program: program, size: '1024x425')}"
                         alt="" width="1024" height="425" border="0" class="imgLazy"
                         onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'">
                </a>

            </g:each>
        </div>

        <div class="boful_img_bottom">
            <div class="boful_item_titles">
                <g:each in="${photoList}" var="program">
                    <div class="boful_item_title">
                        <div class="boful_item_name"><a
                                href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                target="_blank">${CTools.cutString(program.name, 10)}</a>
                        </div>

                        <div class="boful_item_desc">${CTools.cutString(program.description, 100)}</div>
                    </div>
                </g:each>

            </div>

            <div class="boful_item_screenshots">
                <g:each in="${photoList}" var="program">
                    <div class="boful_item_img">
                        <img src="${posterLinkNew(program: program, size: '98x58')}"
                             onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'"
                             width="98"
                             height="58" border="0"/>
                    </div>
                </g:each>
            </div>
        </div>
    </div>
</div>

<div style="height: 1px; background: #FFF;width: 100%;"></div>--}%

<div class="boful_video_banner">
    <div class="boful_video_banner_container">
        <div class="boful_banner_item">
            <div class="boful_banner_item_title">
                <h1>${message(code: 'my.newest.name')}${message(code: 'my.resources.name')}</h1>
                <span class="">
                    <a class="boful_banner_item_title_icon"
                       href="${createLink(action: 'search', params: [dateCreated: 'dateCreated'])}" target="_blank"></a>
                </span>
            </div>

            <div class="boful_banner_items">
                <g:each in="${photoList}" var="program">
                    <div class="boful_photo_item" title="${program.name}">
                        <div class="boful_recommond_video_item_date_new">NEW</div>
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                           target="_blank">
                            <img data-original="${posterLinkNew(program: program, size: '160x100')}" class="imgLazy"
                                 onerror="this.src = '${resource(dir: 'images', file: 'defaultPoster.jpg')}'">
                        </a>

                        <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                              target="_blank">${CTools.cutString(program.name, 10)}</a></p>
                    </div>
                </g:each>

            </div>
        </div>

        <div class="boful_banner_item">
            <div class="boful_banner_item_title">
                <h1>${message(code: 'my.recommend.name')}${message(code: 'my.resources.name')}</h1>
                <span class="">
                    <a class="boful_banner_item_title1_icon1"
                       href="${createLink(action: 'search', params: [recommendNum: 'recommendNum'])}"
                       target="_blank"></a>
                </span>
            </div>

            <div class="boful_banner_items">
                <g:each in="${tuijianList}" var="program">
                    <div class="boful_photo_item" title="${program.name}">
                        <div class="boful_recommond_video_item_date_hot">${message(code: 'my.hot.name')}</div>
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                           target="_blank">
                            <img data-original="${posterLinkNew(program: program, size: '160x100')}" class="imgLazy"
                                 onerror="this.src = '${resource(dir: 'images', file: 'defaultPoster.jpg')}'">
                        </a>

                        <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                              target="_blank">${CTools.cutString(program.name, 10)}</a></p>
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
                            <a class="res-add-more" href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: programCategory.id])}"
                               target="_blank">${message(code: 'my.more.name')}</a>
                        </span>
                    </h3>
                </div>

                <div class="boful_video_container_items">
                    <g:each in="${programList[st]}" var="program">
                        <div class="boful_photo_item" title="${program.name}">
                            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               target="_blank">
                                <img data-original="${posterLinkNew(program: program, size: '160x100')}" class="imgLazy"
                                     onerror="this.src = '${resource(dir: 'images', file: 'defaultPoster.jpg')}'"></a>

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