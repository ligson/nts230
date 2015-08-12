<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/8/22
  Time: 9:06
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="index">
    <title>${message(code: 'my.mooc.name')}</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/default/pc/front/css', file: 'indexMoocs.css')}">
</head>

<body>
<div class="index_moocs_head">
    <div class="index_moocs_join wrap">
        <a href="#">立即加入</a>
    </div>
</div>

<div class="index_moocs_body wrap">
    <div class="index_moocs_body_left">
        <div class="index_moocs_clum">
            <g:each in="${categoryList}" var="category">
                <p><a href="${createLink(controller: 'index', action: 'moocIndex', params: [categoryId: category?.name?.split("-")[1]])}"
                      class="font14 col333">${category?.name?.split("-")[0]}</a></p>
            </g:each>
        </div>
    </div>

    <div class="index_moocs_body_right">
        <div class="index_moocs_path">
            <p>
                <g:if test="${categoryName == null}">
                    <a href="${createLink(controller: 'index', action: 'moocIndex')}" class="font14 col333">全部课程</a>
                </g:if>
                <g:else>
                    <a href="${createLink(controller: 'index', action: 'moocIndex', params: [categoryId: categoryId])}"
                       class="font14 col333">${categoryName}</a>
                </g:else>
            %{--<span class="font12 col666">/</span><a href="#"
                                                                                            class="font14 col333">经济金融</a><span
                class="font12 col666">/</span><a href="#">经济金融</a></p>--}%
        </div>

        <div class="index_moocs_items">
            <g:each in="${courseList}" var="course">
                <div class="index_moocs_item">
                    <div class="index_moocs_item_img">
                        <a target="_blank"
                           href="http://${mooc.ip}:${mooc.port}/mooc/course/courseDetail?courseId=${course?.id}"
                           class="fontnor font14 col333" title="${course?.name}">
                            <img src="${course?.url}"/>
                        </a>
                    </div>

                    <div class="index_moocs_item_infor">
                        <h1 class="fontnor"><a target="_blank"
                                               href="http://${mooc.ip}:${mooc.port}/mooc/course/courseDetail?courseId=${course?.id}"
                                               class="fontnor font14 col333"
                                               title="${course?.name}">${CTools.cutString(course?.name, 10)}</a></h1>

                        <p class="font12 col666">${CTools.cutString(CTools.htmlToBlank(course?.description), 30)}</p>
                    </div>
                </div>
            </g:each>

        </div>

        <div class="f_page">
            <g:guiPaginate total="${total}" controller="index" action="moocIndex"/>
        </div>
    </div>

</div>

</body>
</html>