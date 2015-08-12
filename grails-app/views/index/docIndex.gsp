<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-21
  Time: 下午6:02
--%>

<%@ page import="com.boful.nts.utils.SystemConfig; nts.utils.CTools; nts.program.category.domain.ProgramCategory" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>
        %{-- ${message(code: 'my.share.name')}${message(code: 'my.data.name')} --}%
        ${docName}
    </title>
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_docIndex.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_docIndex.js')}"></script>
</head>

<body>
<div class="ou_resource_meau_nav">
    <div class="wrapper">
        <div class="ou_resource_meau_nav_content">
            <div class="ou_resource_meau_nav_list">

                <a>
                    ${docName}
                </a>
            </div>

            %{-- <g:if test="${SystemConfig.configObject.search.enable && Boolean.parseBoolean(SystemConfig.configObject.search.enable)}">
                 <div class="ou_resource_meau_nav_search">
                     <g:form controller="program" action="docSearch">
                         <div class="doc_nav_search_but">
                             <input type="submit" value="文档搜索">
                         </div>

                         <div class="doc_nav_search_inp">
                             <input type="text" value="" name="key" autocomplete="off">
                         </div>
                     </g:form>
                 </div>
             </g:if>--}%
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
                        <a href="${createLink(controller: 'index', action: 'search', params: [program: tag.id])}"
                           target="_blank">${CTools.cutString(tag.name, 5)}</a>
                    </g:each>
                </p>
            </div>
        </div>
    </div>
</div>

<div class="boful_body_container">
%{--<div class="boful_body_container_bannar_bg">
    <div class="boful_doc_nav_banner wrap">
        <div class="doc_nav_left">
            <g:each in="${programCategoryList}" var="category" status="st">
                <g:if test="${st<5}">
                    <div class="doc_nav_item">
                        <div class="doc_nav_category">
                            <a href="${createLink(action: 'search', params: [programCategoryId: category.id])}"
                               target="_blank">${category.name}</a>
                        </div>

                        <div class="doc_nav_category_sub">
                            <g:each in="${ProgramCategory.findAllByParentCategoryAndIsDisplay(category, ProgramCategory.STATE_DISPLAY, [max: 3])}"
                                    var="childCategory">
                                <a href="${createLink(action: 'search', params: [programCategoryId: category.id])}"
                                   target="_blank">${childCategory.name}</a>
                            </g:each>
                            <span class="">
                                <a class="doc_nav_category_sub_more"
                                   href="${createLink(action: 'search', params: [programCategoryId: category.id])}"
                                   target="_blank"></a>
                            </span>
                        </div>
                    </div>
                </g:if>
            </g:each>
        </div>

        <div class="doc_nav_image_box">
            <div class="doc_nav_img_scroll">
                <span></span>
                <span></span>
                <span></span>
            </div>

            <div class="doc_nav_scroll_imgs">
                <div class="nav_scorll_img_container">
                    <g:each in="${tuijianList}" var="docProgram" status="st">
                        <g:if test="${st < 3}">
                            <div class="doc_nav_image_item">
                                <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: docProgram.id])}"
                                   target="_blank">
                                    <img src="${posterLinkNew(program: docProgram, size: '710x300')}"
                                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'" />
                                </a>

                                <div class="image_item_content">
                                    <h1><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: docProgram.id])}"
                                           target="_blank">${docProgram.name}</a></h1>

                                    <p>${CTools.cutString(docProgram.description, 20)}</p>
                                </div>
                            </div>
                        </g:if>
                    </g:each>
                </div>
            </div>
        </div>
    </div>
</div>--}%
%{--<div class="boful_doc_hot_banner_shaow"></div>--}%
<div class="boful_doc_hot_banner_bgcolor">
    <div class="boful_doc_hot_banner_bg wrap">
        <div class="boful_doc_hot_banner">
            <div class="doc_hot_item">
                <div class="doc_hot_item_title">
                    <h1>${message(code: 'my.newest.name')}${message(code: 'my.resources.name')}</h1>
                    <span class="">
                        <a class="doc_hot_item_title_iocn"
                           href="${createLink(action: 'search', params: [dateCreated: 'dateCreated'])}"
                           target="_blank"></a>
                    </span>
                </div>
                <g:each in="${wendangList}" var="program">
                    <div class="boful_doc_item" title="${program.name}">
                        <div class="boful_recommond_doc_reading"><a style=" width: 95px;  height: 127px;"
                                                                    href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                                                    target="_blank"><img
                                    src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_doc_reading_icon.png')}"/><span>${message(code: 'my.start.name')}${message(code: 'my.reading.name')}</span>
                        </a></div>

                        <div class="boful_recommond_doc_item_infor">共${querySerialFirstTimeLength(program: program, type: 'doc')}页</div>
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                           target="_blank">
                            <img data-original="${posterLinkNew(program: program, size: '96x128')}" class="imgLazy"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                        </a>

                        <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                              target="_blank">${CTools.cutString(program.name, 5)}</a>
                        </p>
                    </div>
                </g:each>

            </div>

            <div class="doc_hot_item">
                <div class="doc_hot_item_title">
                    <h1>${message(code: 'my.recommend.name')}${message(code: 'my.resources.name')}</h1>
                    <span class="">
                        <a class="doc_hot_item_title3"
                           href="${createLink(action: 'search', params: [recommendNum: 'recommendNum'])}"
                           target="_blank"></a>
                    </span>
                </div>
                <g:each in="${tuijianList}" var="program">
                    <div class="boful_doc_item" title="${program.name}">
                        <div class="boful_recommond_doc_reading"><a style=" width: 95px;  height: 127px;"
                                                                    href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                                                    target="_blank"><img
                                    src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_doc_reading_icon.png')}"/><span>${message(code: 'my.start.name')}${message(code: 'my.reading.name')}</span>
                        </a></div>

                        <div class="boful_recommond_doc_item_infor">共${querySerialFirstTimeLength(program: program, type: 'doc')}页</div>
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                           target="_blank">
                            <img data-original="${posterLinkNew(program: program, size: '96x128')}" class="imgLazy"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                        </a>

                        <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                              target="_blank">${CTools.cutString(program.name, 5)}</a>
                        </p>
                    </div>
                </g:each>

            </div>

        </div>
    </div>
</div>

<div class="boful_doc_hot_banner_bg1 wrap">
    <div class="boful_doc_type_banner">
        <div class="doc_container_left">
            <g:each in="${programCategoryList}" var="programCategory" status="st">
                <div class="doc_container_item">
                    <div class="container_left_title">
                        <h3><span class="boful_doc_container_items_title">${programCategory.name}</span>
                            <span class="boful_doc_container_items_more">
                                <a class="res-add-more"
                                   href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: programCategory.id])}"
                                   target="_blank">${message(code: 'my.more.name')}</a>
                            </span>
                        </h3>
                    </div>

                    <div class="boful_doc_container_items">
                        <g:each in="${programList[st]}" var="program">
                            <div class="boful_doc_item" title="${program.name}">
                                <div class="boful_recommond_doc_reading"><a style=" width: 95px;  height: 127px;"
                                                                            href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                                                            target="_blank"><img
                                            src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_doc_reading_icon.png')}"/><span>${message(code: 'my.start.name')}${message(code: 'my.reading.name')}</span>
                                </a></div>
                                <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                   target="_blank">
                                    <img data-original="${posterLinkNew(program: program, size: '96x128')}"
                                         class="imgLazy"
                                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                </a>

                                <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                      target="_blank">${CTools.cutString(program.name, 6)}</a>
                                </p>
                            </div>
                        </g:each>
                    </div>
                </div>
            </g:each>

        </div>

        %{--<div class="doc_container_right">
            <div class="doc_container_right_items">
                <div class="doc_container_right_item">
                    <div class="container_right_title">${message(code: 'my.select.name')}${message(code: 'my.class.name')}</div>

                    <div class="container_right_content">
                        <g:each in="${programCategoryList}" var="category" status="i">
                            <g:if test="${i <= 8}">
                                <a title="${category.name}"
                                   href="${createLink(action: 'search', params: [programCategoryId: category.id])}"
                                   target="_blank">${CTools.cutString(category.name, 3)}</a>
                            </g:if>

                        </g:each>
                    </div>
                </div>

                <div class="doc_container_right_item">
                    <div class="container_right_title">${message(code: 'my.hot.name')}${message(code: 'my.tally.name')}</div>

                    <div class="container_right_content">
                        <g:each in="${programTagList}" var="tag">
                            <a title="${tag.name}"
                               href="${createLink(action: 'search', params: [programTagId: tag.id])}"
                               target="_blank">${CTools.cutString(tag.name, 3)}</a>
                        </g:each>
                    </div>
                </div>
            </div>
        </div>--}%
    </div>
</div>
</div>
</body>
</html>