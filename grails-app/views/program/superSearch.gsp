<%@ page import="nts.program.category.domain.ProgramCategory; nts.program.category.domain.ProgramCategory; nts.utils.CTools; nts.program.domain.Serial; nts.program.category.domain.ProgramCategory; nts.program.domain.Program; java.text.DecimalFormat" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html" xml:lang="zh" lang="zn">

<head>
    <title>${message(code: 'my.search.name')}</title>
    <meta name="layout" content="index">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/' + frontTheme() + '/pc/front/css', file: 'federated_search.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/' + frontTheme() + '/pc/front/css', file: 'superSeacher.css')}">
    <r:require modules="jquery,string"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/programCategoryTree.js')}"></script>
    <script>
        var programCategoryId = "${params.programCategoryId}";
        var otherOption = '${params.otherOption}';
        var orderBy = "${params.orderBy}";
        var order = "${params.order}";
        var facetFieldParams = "${facetFieldParams}";
        var facetValueParams = "${facetValueParams}";
    </script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/super_search.js')}"></script>
</head>

<body>
<div class="f_s_bar">
    <div class="f-wra">
        <div class="f_s_head">
            <div class="f_inp_remin" style="display:none;">
        </div>

        <div class="f_s_box">
            <g:form controller="program" action="superSearch" name="searchForm">
                <input class="f_s_in" type="text" value="${params.key}" name="key" autocomplete="off" id="keyInput">
                <input class="f_s_but" type="submit" value="">
            </g:form>
        </div>

        <div class="f_s_num">
            <p>找到相关结果约<span>${total}</span>个，用时<span>${useTime}s</span></p>
        </div>
        </div>
    </div>
</div>

%{--<div class="boful_resources_search">
    <div class="boful_resources_search_body wrap">
        <g:each in="${categoryNavList}" var="category" status="st">
            <g:if test="${st == 0}">
                <div class="boful_resources_search_start">

                    <!--链接-->
                    <div class="category_nav">
                        <a class="boful_resources_search_stat_name"
                           href="${createLink(controller: 'program', action: 'superSearch', params: [key: params.key, otherOption: params.otherOption, programCategoryId: category.id]).decodeURL()}">${category.name}</a>
                        <a class="boful_resources_search_stat_more" href="#">
                            <span class="boful_resources_search_stat_more_mark"></span>
                        </a>
                    </div>
                </div>
                <g:if test="${categoryNavList.size() > 1}">
                    <div class="boful_resources_search_second_left"><img
                            src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_resources_search_body_center.png')}">
                    </div>
                </g:if>
            </g:if>
            <g:elseif test="${categoryNavList.size() > 1 && (st == (categoryNavList.size() - 1))}">
                <div class="boful_resources_search_second">
                    <div class="boful_resources_search_start_list category_nav_sub">
                        <p>
                            <g:each in="${nts.program.category.domain.ProgramCategory.findAllByParentCategory(category.parentCategory) - category}"
                                    var="subCategory">
                                <a href="${createLink(controller: 'program', action: 'superSearch', params: [key: params.key, otherOption: params.otherOption, programCategoryId: subCategory.id]).decodeURL()}">${subCategory.name}</a>
                            </g:each>
                        </p>
                    </div>
                    <!--链接-->
                    <div class="category_nav">
                        <a class="boful_resources_search_stat_name"
                           href="${createLink(controller: 'program', action: 'superSearch', params: [key: params.key, otherOption: params.otherOption, programCategoryId: category.id]).decodeURL()}">${category.name}</a>
                        <a class="boful_resources_search_stat_more" href="#">
                            <span class="boful_resources_search_stat_more_mark"></span>
                        </a>
                    </div>
                </div>
            </g:elseif>
            <g:else>
                <div class="boful_resources_search_second">
                    <div class="boful_resources_search_start_list category_nav_sub">
                        <p>
                            <g:each in="${nts.program.category.domain.ProgramCategory.findAllByParentCategory(category.parentCategory) - category}"
                                    var="subCategory">
                                <a href="${createLink(controller: 'program', action: 'superSearch', params: [key: params.key, otherOption: params.otherOption, programCategoryId: subCategory.id]).decodeURL()}">${subCategory.name}</a>
                            </g:each>
                        </p>
                    </div>
                    <!--链接-->
                    <div class="category_nav">
                        <a class="boful_resources_search_stat_name"
                           href="${createLink(controller: 'program', action: 'superSearch', params: [key: params.key, otherOption: params.otherOption, programCategoryId: category.id]).decodeURL()}">${category.name}</a>
                        <a class="boful_resources_search_stat_more" href="#">
                            <span class="boful_resources_search_stat_more_mark"></span>
                        </a>
                    </div>
                </div>

                <div class="boful_resources_search_second_left"><img
                        src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_resources_search_body_center.png')}">
                </div>
            </g:else>
        </g:each>
    </div>
</div>--}%

<div class="boful_resources_search">
    <div id="programCategoryNavi" class="boful_resources_search_body wrap">
        <div class="boful_resources_search_start">
            <div class="category_nav">
                %{--<a class="boful_resources_search_stat_name"
                   href="/program/superSearch?programCategoryId=1">资源库</a>--}%
                <a class="boful_resources_search_stat_name"
                   href="javascript:void(0);" onclick="searchDataByCategoryId()">资源库</a>
                <a class="boful_resources_search_stat_more" href="#">
                    <span class="boful_resources_search_stat_more_mark"></span>
                </a>
            </div>
        </div>
    </div>
</div>

<div class="boful_resources_search_other wrap">
    %{--<g:if test="${childCategoryList && childCategoryList.size() > 0}">--}%
        <div class="boful_resources_search_other_class" id="programCategoryListDiv">
            <span>${message(code: 'my.class.name')}:</span>
    <P id="programCategoryList"></P>
    %{--<P>
       <g:each in="${childCategoryList}" var="child">
           <a href="${createLink(controller: 'program', action: 'superSearch', params: [key: params.key, otherOption: params.otherOption, programCategoryId: child?.id]).decodeURL()}">${child?.name}</a>
       </g:each>
   </P>--}%
        </div>
    %{--</g:if>--}%

    <g:each in="${facetList}" var="facet" status="i">
        <div class="boful_resources_search_other_classall">
            <span>${facet?.cnName}&nbsp;:</span>

            <p>
                <g:each in="${facet?.values}" var="factedValue">
                    <g:if test="${factedValue.equals(params.(facet?.enName))}">
                    %{-- <a href="${createLink(controller: 'program', action: 'superSearch', params: params + [(facet?.enName): factedValue]).decodeURL()}"--}%
                        <a href="javascript:void(0);"
                           onclick="searchDataByFacet('${facet?.enName}', '${factedValue}', '0')"
                           style="color:#f9892e;">${factedValue}</a>
                        <b class="boful_resources_search_other_classall_delete_box"><a
                                style=" width: 15px;margin: 0; padding: 0"
                                class="boful_resources_search_other_classall_delete"
                                href="javascript:void(0);"
                                onclick="searchDataByFacet('${facet?.enName}', '${params.(facet?.enName)}', '1')"></a>
                        </b>
                    </g:if>
                    <g:else>
                        <a href="javascript:void(0);"
                           onclick="searchDataByFacet('${facet?.enName}', '${factedValue}', '0')">${factedValue}</a>
                    </g:else>
                </g:each>
            </p>
        </div>
    </g:each>
    <div class="boful_resources_search_other_media">
        <span>${message(code: 'my.media.name')}${message(code: 'my.type.name')}&nbsp;:</span>

        <p>
            <g:if test="${Program.ONLY_VIDEO_OPTION.toString().equals(params.otherOption)}">
                <a href="javascript:void(0);" onclick="searchDataByOtherOption('${Program.ONLY_VIDEO_OPTION}', '0')"
                   style="color:#f9892e;">${message(code: 'my.video.name')}</a>
                <b class="boful_resources_search_other_classall_delete_box"><a
                        style=" width: 15px;margin: 0; padding: 0"
                        class="boful_resources_search_other_classall_delete"
                        href="javascript:void(0);" onclick="searchDataByOtherOption('${params.otherOption}', '1')"></a>
                </b>
            </g:if>
            <g:else>
                <a href="javascript:void(0);"
                   onclick="searchDataByOtherOption('${Program.ONLY_VIDEO_OPTION}', '0')">${message(code: 'my.video.name')}</a>
            </g:else>
            <g:if test="${Program.ONLY_IMG_OPTION.toString().equals(params.otherOption)}">
                <a href="javascript:void(0);" onclick="searchDataByOtherOption('${Program.ONLY_IMG_OPTION}', '0')"
                   style="color:#f9892e;">${message(code: 'my.picture.name')}</a>
                <b class="boful_resources_search_other_classall_delete_box"><a
                        style=" width: 15px;margin: 0; padding: 0"
                        class="boful_resources_search_other_classall_delete"
                        href="javascript:void(0);" onclick="searchDataByOtherOption('${params.otherOption}', '1')"></a>
                </b>
            </g:if>
            <g:else>
                <a href="javascript:void(0);"
                   onclick="searchDataByOtherOption('${Program.ONLY_IMG_OPTION}', '0')">${message(code: 'my.picture.name')}</a>
            </g:else>
            <g:if test="${Program.ONLY_TXT_OPTION.toString().equals(params.otherOption)}">
                <a href="javascript:void(0);" onclick="searchDataByOtherOption('${Program.ONLY_TXT_OPTION}', '0')"
                   style="color:#f9892e;">${message(code: 'my.word.name')}</a>
                <b class="boful_resources_search_other_classall_delete_box"><a
                        style=" width: 15px;margin: 0; padding: 0"
                        class="boful_resources_search_other_classall_delete"
                        href="javascript:void(0);" onclick="searchDataByOtherOption('${params.otherOption}', '1')"></a>
                </b>
            </g:if>
            <g:else>
                <a href="javascript:void(0);"
                   onclick="searchDataByOtherOption('${Program.ONLY_TXT_OPTION}', '0')">${message(code: 'my.word.name')}</a>
            </g:else>

            <g:if test="${Program.ONLY_AUDIO_OPTION.toString().equals(params.otherOption)}">
                <a href="javascript:void(0);" onclick="searchDataByOtherOption('${Program.ONLY_AUDIO_OPTION}', '0')"
                   style="color:#f9892e;">${message(code: 'my.audio.name')}</a>
                <b class="boful_resources_search_other_classall_delete_box"><a
                        style=" width: 15px;margin: 0; padding: 0"
                        class="boful_resources_search_other_classall_delete"
                        href="javascript:void(0);" onclick="searchDataByOtherOption('${params.otherOption}', '1')"></a>
                </b>
            </g:if>
            <g:else>
                <a href="javascript:void(0);"
                   onclick="searchDataByOtherOption('${Program.ONLY_AUDIO_OPTION}', '0')">${message(code: 'my.audio.name')}</a>
            </g:else>
            <g:if test="${Program.ONLY_LESSION_OPTION.toString().equals(params.otherOption)}">
                <a href="javascript:void(0);" onclick="searchDataByOtherOption('${Program.ONLY_LESSION_OPTION}', '0')"
                   style="color:#f9892e;">${message(code: 'my.courses.name')}</a>
                <b class="boful_resources_search_other_classall_delete_box"><a
                        style=" width: 15px;margin: 0; padding: 0"
                        class="boful_resources_search_other_classall_delete"
                        href="javascript:void(0);" onclick="searchDataByOtherOption('${params.otherOption}', '1')"></a>
                </b>
            </g:if>
            <g:else>
                <a href="javascript:void(0);"
                   onclick="searchDataByOtherOption('${Program.ONLY_LESSION_OPTION}', '0')">${message(code: 'my.courses.name')}</a>
            </g:else>

        </p>
    </div>
</div>

<div class="boful_resources_search_sorting wrap">
    <p>
        <a style="color: ${params.orderBy == "dateCreated" ? '#39a53e' : '#000000'}"
           href="javascript:void(0);"
           onclick="searchDataByOrder('dateCreated', 'desc')">${message(code: 'my.time.name')}${message(code: 'my.sorting.name')}</a>
        <a style="color: ${params.orderBy == "frequency" ? '#39a53e' : '#000000'}"
           href="javascript:void(0);"
           onclick="searchDataByOrder('frequency', 'desc')">${message(code: 'my.play.name')}${message(code: 'my.sorting.name')}</a>
    </p>
</div>

<div class="f_s_content">
    <div class="wrap">
        <div class="f_c_left">
            <div class="f_c_l_items">
                <g:each in="${programs}" var="program" status="st">
                    <div class="f_c_l_item">
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                           class="f_c_img" target="_blank"><img
                                src="${posterLinkNew(program: Program.get(program.getId()), size: '150x100')}"/></a>

                        <div class="f_item_inf">
                            <h1><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                   target="_blank">${program.name}</a></h1>

                            <p class="f_in_base"><span class="c_f_un">来源：<a href=""></a></span>
                                <span class="c_f_user">创建人：<a href="">${program.getCreatorName()}</a></span>
                                <span class="c_f_time">创建时间：<a href="">${program.dateCreated.format("yyyy-MM-dd")}</a>
                                </span></p>

                            <p class="f_in_des">${program.description}</p>

                        </div>
                    </div>
                </g:each>

            </div>

            <div class="f_page">
                <g:guiPaginate controller="program" action="superSearch" total="${total}" params="${params}" max="20"/>
            </div>
        </div>
    </div>
</div>
</body>
</html>