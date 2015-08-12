<%@ page import="nts.program.category.domain.ProgramCategory; nts.program.category.domain.ProgramCategory; nts.utils.CTools; nts.program.domain.Serial; nts.program.category.domain.ProgramCategory; nts.program.domain.Program; java.text.DecimalFormat" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html" xml:lang="zh" lang="zn">

<head>
    <title>${message(code: 'my.search.name')}</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/' + frontTheme() + '/pc/front/css', file: 'searchAll.css')}"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/' + frontTheme() + '/pc/front/css', file: 'list_search.css')}">
    <r:require modules="jquery"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/turnPage.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/programCategoryTree.js')}"></script>
    <script>
        var programCategoryId = "${params.programCategoryId}";
        var facetFieldParams = "${facetFieldParams}";
        var facetValueParams = "${facetValueParams}";
        var otherOption = '${params.otherOption}';
        var programTagId = '${params.programTagId}';
        var orderBy = "${params.orderBy}";
        var order = "${params.order}";

    </script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/search_program.js')}"></script>
</head>

<body>
<g:form controller="index" action="search" name="searchForm">
    <input type="submit" value="" style="display: none;">
</g:form>
<div class="boful_resources_search">
    <div id="programCategoryNavi" class="boful_resources_search_body wrap">
        <div class="boful_resources_search_start">
            <div class="category_nav">
                <a class="boful_resources_search_stat_name"
                   href="javascript:void(0);"
                   onclick="searchDataByCategoryId()">资源库</a>
                <a class="boful_resources_search_stat_more" href="#">
                    <span class="boful_resources_search_stat_more_mark"></span>
                </a>
            </div>
        </div>
    </div>
</div>

<div class="boful_resources_search_other wrap">
    <div class="boful_resources_search_other_class">
        <span>${message(code: 'my.class.name')}:</span>

        <P id="programCategoryList"></P>
    </div>
    <g:each in="${facetList}" var="facet" status="i">
        <div class="boful_resources_search_other_classall">
            <span>${facet?.cnName}&nbsp;:</span>

            <p>
                <g:each in="${facet?.values}" var="factedValue">
                    <g:if test="${factedValue.equals(params.(facet?.enName))}">
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

    <div class="boful_resources_search_other_hotkeys">
        <span>${message(code: 'my.hot.name')} ${message(code: 'my.tally.name')}&nbsp;:</span>

        <p>
            <g:each in="${programTagList}" var="programTag">
                <g:if test="${programTag.id.toString().equals(params.programTagId)}">
                    <a href="javascript:void(0);" onclick="searchDataByProgramTag('${programTag.id}', '0')"
                       style="color:#f9892e;">${programTag.name}</a>
                    <b class="boful_resources_search_other_classall_delete_box"><a
                            style=" width: 15px;margin: 0; padding: 0"
                            class="boful_resources_search_other_classall_delete"
                            href="javascript:void(0);"
                            onclick="searchDataByProgramTag('${params.programTagId}', '1')"></a>
                    </b>
                </g:if>
                <g:else>
                    <a href="javascript:void(0);"
                       onclick="searchDataByProgramTag('${programTag.id}', '0')">${programTag.name}</a>
                </g:else>

            </g:each>
        </p>
    </div>

    <div class="boful-cla-all">
        <span>已选条件:</span>

        <div class="boful-cla-chose">
            <g:if test="${currentCategory}">
                <a href="javascript:void(0);"
                   onclick="searchDataByCategoryId()"><em>${currentCategory?.name}</em><i></i></a>
            </g:if>
            <g:if test="${params.otherOption}">
                <g:if test="${params.otherOption == '0'}">
                    <a href="javascript:void(0);"
                       onclick="searchDataByOtherOption('${Program.ONLY_VIDEO_OPTION}', '1')"><em>视频</em><i></i>
                    </a>
                </g:if>
                <g:elseif test="${params.otherOption == '16'}">
                    <a href="javascript:void(0);"
                       onclick="searchDataByOtherOption('${Program.ONLY_IMG_OPTION}', '1')"><em>图片</em><i></i>
                    </a>
                </g:elseif>
                <g:elseif test="${params.otherOption == '8'}">
                    <a href="javascript:void(0);"
                       onclick="searchDataByOtherOption('${Program.ONLY_TXT_OPTION}', '1')"><em>文档</em><i></i>
                    </a>
                </g:elseif>
                <g:elseif test="${params.otherOption == '1'}">
                    <a href="javascript:void(0);"
                       onclick="searchDataByOtherOption('${Program.ONLY_AUDIO_OPTION}', '1')"><em>音频</em><i></i>
                    </a>
                </g:elseif>
                <g:elseif test="${params.otherOption == '128'}">
                    <a href="javascript:void(0);"
                       onclick="searchDataByOtherOption('${Program.ONLY_LESSION_OPTION}', '1')"><em>课程</em><i></i>
                    </a>
                </g:elseif>
                <g:elseif test="${params.otherOption == '6'}">
                    <a href="javascript:void(0);"
                       onclick="searchDataByOtherOption('${Program.ONLY_FLASH_OPTION}', '1')"><em>flash动画</em><i></i>
                    </a>
                </g:elseif>
            </g:if>
            <g:if test="${params.programTagId}">
                <a href="javascript:void(0);"
                   onclick="searchDataByProgramTag('${params.programTagId}', '1')"><em>${programTagName}</em><i></i>
                </a>
            </g:if>
        </div>
    </div>
</div>

<div class="boful_resources_search_sorting wrap">
    <p><span>排序</span>

        <a style="color: ${params.orderBy == "dateCreated" ? '#39a53e' : '#666'}"
           href="javascript:void(0);"
           onclick="searchDataByOrder('dateCreated', 'desc')">上传时间</a>
        <em class="sear_lin">|</em>
        <a style="color: ${params.orderBy == "frequency" ? '#39a53e' : '#666'}"
           href="javascript:void(0);"
           onclick="searchDataByOrder('frequency', 'desc')">点播次数</a><em
            class="sear_lin">|</em>
        <a style="color: ${params.orderBy == "remarkNum" ? '#39a53e' : '#666'}"
           href="javascript:void(0);"
           onclick="searchDataByOrder('remarkNum', 'desc')">评论次数</a><em
            class="sear_lin">|</em>
        <a style="color: ${params.orderBy == "recommendNum" ? '#39a53e' : '#666'}"
           href="javascript:void(0);"
           onclick="searchDataByOrder('recommendNum', 'desc')">用户推荐</a>
        <a style="color: ${params.orderBy == "programScore" ? '#39a53e' : '#666'}"
           href="javascript:void(0);"
           onclick="searchDataByOrder('programScore', 'desc')">评&nbsp;&nbsp;分</a>
        <em class="sear_lin">|</em>
    </p>
</div>

<div class="boful_resources_search_program_show_all">
    <div class="boful_resources_search_program_show">
        <div class="bf-search">
            <g:each in="${programList}" var="program">
                <g:if test="${program.otherOption == 8}">
                    <div class="bf-search-item-doc">
                        <div class="bf-search-doc-img">
                            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               target="_blank"/>
                            <img class="lazyImg" src="${posterLinkNew(program: program, size: '95x127', position: -1)}"
                                 target="_blank"/></a>
                        </div>

                        <div class="bf-search-center-doc">
                            <h2><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                   target="_blank" class="col333-doc">${program.name}</a></h2>

                            <p class="bf-sea-in-doc font12 col666">${program.description}</p>

                            <p class="bf-sea-btm-doc"><span class="font12 col999">作者：<em
                                    class="font12 col999 font-sy">${consumerName(id: program.consumer.id)}</em></span>

                                <span class="font12 col999">时间：<em
                                        class="col999 font-sy">${program.dateCreated.format("yyyy-MM-dd")}</em></span>

                            </p>
                        </div>

                        <div class="bf-search-rigtht">
                            %{--<p class="font14 col999 line-shows"><em>${calcProgramScore(program: program)}</em>&nbsp;&nbsp;分
                            </p>--}%
                            <p class="font14 col999 line-shows"><em>${program.programScore}</em>&nbsp;&nbsp;分
                            </p>

                            <p class=" font12 col999 line-show">${program.recommendNum}次&nbsp;&nbsp;(推荐)</p>

                            <p class="font12 col999 line-show">${program.remarkNum}次&nbsp;&nbsp;(评论)</p>

                            <p class="font14 col999 line-show">${program.frequency}次&nbsp;&nbsp;(点播)</p>
                        </div>
                    </div>
                </g:if>
                <g:else>
                    <div class="bf-search-item">
                        <div class="bf-search-img">
                            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               target="_blank"/>
                            <img class="lazyImg" src="${posterLinkNew(program: program, size: '160x100', position: -1)}"
                                 target="_blank"/></a>
                        </div>

                        <div class="bf-search-center">
                            <h2><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                   target="_blank" class="col333">${program.name}</a></h2>

                            <p class="bf-sea-in font12 col666">${program.description}</p>

                            <p class="bf-sea-btm"><span class="font12 col999">作者：<em
                                    class="font12 col999 font-sy">${consumerName(id: program.consumer.id)}</em></span>

                                <span class="font12 col999">时间：<em
                                        class="col999 font-sy">${program.dateCreated.format("yyyy-MM-dd")}</em></span>

                            </p>
                        </div>

                        <div class="bf-search-rigtht">
                            %{--<p class="font14 col999 line-shows"><em>${calcProgramScore(program: program)}</em>&nbsp;&nbsp;分
                            </p>--}%
                            <p class="font14 col999 line-shows"><em>${program.programScore}</em>&nbsp;&nbsp;分
                            </p>

                            <p class=" font12 col999 line-show">${program.recommendNum}次&nbsp;&nbsp;(推荐)</p>

                            <p class="font12 col999 line-show">${program.remarkNum}次&nbsp;&nbsp;(评论)</p>

                            <p class="font14 col999 line-show">${program.frequency}次&nbsp;&nbsp;(点播)</p>
                        </div>
                    </div>
                </g:else>
            </g:each>

        </div>

        <div class="page">
            <g:paginate offset="${params.offset}" max="${params.max}" total="${total}" action="search"
                        params="${params}"/>
        </div>
    </div>
</div>
</body>
</html>