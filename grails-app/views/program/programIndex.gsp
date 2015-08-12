<%@ page import="nts.program.category.domain.ProgramCategory; nts.utils.CTools; com.boful.common.date.utils.TimeLengthUtils" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <!----------头部------->
    <title>${message(code: 'my.sys.name')}</title>
    <meta name="layout" content="index">
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_index.css')}"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_index.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.lazyload.js')}"></script>
    <script type="text/javascript">
        $(function () {
            //$(".boful_item_loading").style("display",block);
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
                $(data).attr("src", data.src);
            });
            /*imgArr.load(function(){
             $(this).attr("src");
             });*/
            //alert(imgArr.length);
        });
        $(function () {
            //修改音频背景颜色不显示
            $("#hotAudio").css("background", "#1771AC")
        })
    </script>

</head>

<body>
%{--<img class="lazy"
                    data-original="${resource(dir: 'skin/blue/pc/front/images', file: 'unknow_loading.gif')}" width="128" height="15" style=" margin: 200px auto"/>--}%
<!-----------结束---------->
<div class="boful_img_box">
    <div class="boful_img_box_container" style="visibility:hidden;">
        <!--大海报图片-->
        <div class="boful_container_img">
            <!-------IE7.IE6--------->
            <!-------结束--------->
            <div class="boful_item_loading" style="display:block;background: #252B33;"><img
                    src="${resource(dir: 'skin/blue/pc/front/images', file: 'unknow_loading.gif')}" width="128"
                    height="15"/></div>

            <div class="boful_item" style="display:none;">
            %{--<img class="lazy"
                 data-original="${resource(dir: 'skin/blue/pc/front/images', file: 'unknow_loading.gif')}" width="128" height="15" style=" margin: 200px auto; "/>--}%
                <g:each in="${tuijianList}" var="program" status="s1">
                    <g:if test="${s1 < 6}">
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                           target="_blank" title="${program.name}">
                            <img src="${posterLinkNew(program: program, size: '1024x400')}"
                                 alt="${program.name}" width="1024" height="400" border="0"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                        </a></g:if>

                </g:each>
            </div>
        </div>

        <!--资源名称-->
        <div class="boful_item_title_content">
            <g:each in="${tuijianList}" var="program" status="s2">
                <g:if test="${s2 < 6}">
                    <div class="boful_item_title">
                        <div class="boful_item_title_dir"><a href="">${program.name}</a></div>

                        <div class="boful_item_title_name"><a
                                href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                target="_blank">${CTools.cutString(program?.classLib?.name, 10)}</a>
                        </div>

                        <div class="boful_item_title_desc">${CTools.cutString(CTools.htmlToBlank(program.description), 100)}</div>
                    </div></g:if>
            </g:each>

        </div>
        <!--海报缩略图-->
        <div class="boful_container_bottom">
            <g:each in="${tuijianList}" var="program" status="s3">
                <g:if test="${s3 < 6}">
                    <div class="boful_item_img">
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                           target="_blank">
                            <img programId="${program?.id}" size="98x58"
                                 class="imgLazy program_poster"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"
                                 width="98"
                                 height="58" border="0"/>
                        </a>
                    </div></g:if>
            </g:each>
        </div>

        <div class="boful_container_right">
            <div class="boful_ui_tab_title">
                <span>${message(code: 'my.hot.name')}${message(code: 'my.rank.name')}</span>
                <span>${message(code: 'my.newest.name')}${message(code: 'my.resources.name')}</span>
            </div>

            <div class="boful_ui_tab_title_bottom">
                <div class="boful_ui_tab_title_bottom_line"></div>
            </div>

            <div class="boful_ui_tab_content">
                <div class="boful_ui_tab_item">
                    <g:each in="${remenList}" var="program" status="pro">
                    %{--前3个资源样式里加上 zy_number_color--}%
                        <p><span class="boful_zy_number ">${pro + 1}、</span>
                            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               target="_blank">${CTools.cutString(program.name, 15)}</a>

                        </p>
                    </g:each>
                </div>

                <div class="boful_ui_tab_item" style="display:none;">
                    <g:each in="${zyphList}" var="program" status="pp">
                        <p><span class="boful_zy_number">${pp + 1}、</span>
                            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               target="_blank">${CTools.cutString(program?.name, 15)}</a>
                        </p>
                    </g:each>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="boful_content_header">
    <div class="boful_content_header_container">
        %{--<div class="boful_news recommond_pad">
            <div class="boful_news_name">
                <h2><a href="${createLink(controller: 'index', action: 'newsMore')}"  >学术资讯</a>
                    --}%%{--  <span class="boful_news_name_number">共203条资讯</span>--}%%{--
                </h2>
            </div>

            <div class="boful_news_hot">
                <g:if test="${newsList.size() > 0}">
                    <a href="${createLink(controller: 'index', action: 'showNews', params: [id: newsList.get(0)?.id])}"><img
                            src="${CTools.findImgFormContent(newsList.get(0).content)}" width="210" height="115"
                            onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'"/>
                    </a>

                    <p>
                        ${CTools.cutString(CTools.htmlToBlank(newsList.get(0)?.content), 70)}
                    </p>
                </g:if>
            </div>

            <div class="boful_news_items">
                <g:each in="${newsList}" var="news">
                    <p><a href="${createLink(controller: 'index', action: 'showNews', params: [id: news.id])}"
                           >${CTools.cutString(news.title, 20)}</a>
                    </p>
                </g:each>
            </div>
        </div>--}%

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
                    <g:each in="${tuijianList}" var="program">
                        <div class="boful_video_item" title="${program.name}">
                            %{--<div class="boful_recommond_video_item_play"><a
                                    href="${createLink(controller: 'program' , action: 'showProgram', params: [id: program.id])}"
                                     ><img
                                        style="box-shadow: none"
                                        src="${resource(dir: 'skin/blue/pc/images', file: 'boful_recommond_video_item_play_icon.png')}">
                            </a></div>--}%

                            %{--<div class="boful_recommond_video_item_date_hot">HOT</div>

                            <div class="boful_recommond_video_item_date">
                                ${TimeLengthUtils.formatTime(TimeLengthUtils.NumberToString(program?.serials?.first()?.timeLength))}
                            </div>--}%
                            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               target="_blank">
                                <img programId="${program?.id}" size="160x100"
                                     class="imgLazy program_poster"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                            </a>

                            <div class="boful_recommond_video_name">
                                <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                   target="_blank">${CTools.cutString(program.name, 10)}</a>
                            </div>

                        </div>
                    </g:each>
                </div>
            </div>
            %{--<div class="boful_recommond_video">
                <g:each in="${tuijianList}" var="program">
                    <div class="boful_video_item" title="${program.name}">
                        <div class="boful_recommond_video_item_play"><a
                                href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                 ><img
                                    style="box-shadow: none"
                                    src="${resource(dir: 'skin/blue/pc/images', file: 'boful_recommond_video_item_play_icon.png')}">
                        </a></div>

                        <div class="boful_recommond_video_item_date_hot">HOT</div>

                        <div class="boful_recommond_video_item_date">
                            ${TimeLengthUtils.formatTime(TimeLengthUtils.NumberToString(program?.serials?.first()?.timeLength))}
                        </div>
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                            >
                            <img data-original="${posterLinkNew(program: program, size: '160x100')}" class="imgLazy"
                                 onerror="this.src = '${resource(dir:'images',file:'defaultPoster.jpg')}'"></a>

                        <div class="boful_recommond_video_name">

                            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                >${nts.nts.utils.CTools.cutString(program.name, 10)}</a>
                        </div>

                    </div>
                </g:each>
            </div>--}%
            <!--文档-->
            <div class="boful_recommond_doc">
                <g:each in="${wendangList}" var="program" status="pro">
                    <div class="boful_doc_item" title="${program.name}">
                        <div class="boful_recommond_doc_reading"><a style=" width: 95px;  height: 127px;"
                                                                    href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                                                    target="_blank"><img
                                    src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_doc_reading_icon.png')}"/><span>开始阅读</span>
                        </a></div>

                        <div class="boful_recommond_doc_item_infor_hot">${message(code: 'my.hot.name')}</div>

                        <div class="boful_recommond_doc_item_infor">共${program.serials.size() == program.serialNum? program.serialNum : program.serials.size()}个</div>
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                           target="_blank">
                            <img programId="${program?.id}" size="97x127"
                                 class="imgLazy program_poster"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'p_nav_thumbs.png')}'">
                        </a>

                        <div class="boful_recommond_video_name">
                            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               target="_blank">${CTools.cutString(program.name, 5)}</a>
                        </div>
                    </div>

                </g:each>

            </div>
        </div>
    </div>
</div>
<!---------开放课程------>
%{--<div class="boful_content_item" style="background:#FFF;">
    <div class="boful_content_container">
        <div class="boful_course_left">
            <div class="boful_type_title boful_type_title_reb">
                <h2>
                    <a href="${createLink(controller: 'index', action: 'courseIndex')}"  >开放课程</a>
                    <a href="#" style="font-size: 12px;" class="boful_news_name_number">共${studyTotal}视频</a>
                </h2>

                <p class="boful_news_name_small_class">
                    <g:each in="${ProgramCategory.findAllByMediaType(5)}" var="category" status="sta">
                        <g:if test="${sta < 8}">
                            <a href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: category.id])}"
                                >${category?.name}</a>
                        </g:if>
                    </g:each>
                </p>
                --}%%{-- <a href=""
                   style="color: #fff;font-size: 22px;text-align: center;width: 330px"  >开放课程</a>--}%%{--
            </div>
            <!------------------->

            <!------------------->
            <div class="course_left_imgs">
                <g:each in="${publicLession}" var="lession" status="le">
                    <g:if test="${le <= 1}">
                        <div class="course_left_img" title="${lession.name}">
                            <div class="boful_recommond_video_item_play"><a  
                                                                            href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: lession.id])}"><img
                                        style="box-shadow: none"
                                        src="${resource(dir: 'skin/blue/pc/images', file: 'boful_recommond_video_item_play_icon.png')}">
                            </a></div>

                            <div class="boful_recommond_video_item_date">共${publicTotal(serial: lession?.serials)}课时</div>
                            <a href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: lession.id])}">
                                <img data-original="${posterLinkNew(program: lession, size: '160x100')}" class="imgLazy"
                                     onerror="this.src = '${resource(dir:'images',file:'defaultPoster.jpg')}'"></a>

                            <p><a href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: lession.id])}"
                                   >${CTools.cutString(lession.name, 10)}</a>
                            </p>
                        </div>
                    </g:if>
                </g:each>
            </div>
        </div>

        <div class="boful_course_mid">
            <g:each in="${publicLession}" var="lession" status="le">
                <g:if test="${le == 2}">
                    <div class="course_mid_img" title="${lession.name}">
                        <div class="boful_recommond_video_item_play_mid"><a
                                href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: lession.id])}"
                                 ><img
                                    style="box-shadow: none"
                                    src="${resource(dir: 'skin/blue/pc/images', file: 'boful_recommond_video_item_play_icon.png')}">
                        </a></div>

                        <div class="boful_recommond_video_item_date_mid">共${publicTotal(serial: lession?.serials)}课时</div>
                        <a href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: lession.id])}">
                            <img data-original="${posterLinkNew(program: lession, size: '160x255')}" class="imgLazy"
                                 onerror="this.src = '${resource(dir:'images',file:'defaultPoster.jpg')}'"></a>

                        <p><a href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: lession.id])}"
                               >${CTools.cutString(lession.name, 6)}</a>
                        </p>
                    </div>
                </g:if>
            </g:each>
        </div>

        <div class="boful_course_right">
            <g:each in="${publicLession}" var="lession" status="le">
                <g:if test="${le > 2}">
                    <div class="course_right_img" title="${lession.name}">
                        <div class="boful_recommond_video_item_play"><a
                                href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: lession.id])}"
                                 ><img
                                    style="box-shadow: none"
                                    src="${resource(dir: 'skin/blue/pc/images', file: 'boful_recommond_video_item_play_icon.png')}">
                        </a></div>

                        <div class="boful_recommond_video_item_date">共${publicTotal(serial: lession?.serials)}课时</div>
                        <a href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: lession.id])}">
                            <img data-original="${posterLinkNew(program: lession, size: '160x100')}" class="imgLazy"
                                 onerror="this.src = '${resource(dir:'images',file:'defaultPoster.jpg')}'"></a>

                        <p><a href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: lession.id])}"
                               >${CTools.cutString(lession.name, 10)}</a>
                        </p>
                    </div>
                </g:if>
            </g:each>

        </div>
    </div>
</div>--}%

<g:if test="${programList.size()>0}">
    <g:each in="${programList}" var="programCategory">
        <g:set var="categoryType" value="${programCategory?.categoryType}" />
        <g:set var="categoryName" value="${programCategory?.categoryName}"/>
        <g:set var="categoryId" value="${programCategory?.categoryId}"/>
        <g:set var="programTotal" value="${programCategory?.programTotal}"/>
        <g:set var="categoryList" value="${programCategory?.categoryList}"/>
        <g:set var="programList" value="${programCategory?.programList}"/>
        <g:if test="${categoryType == 1}">
            <!---------视频------>
            <div class="boful_content_item">
                <div class="boful_content_container">
                    <div class="boful_video_left">
                        <div class="boful_type_title boful_type_title_reb2 boful_news_name_class_number">
                            %{-- <a href="${createLink(controller: 'index', action: 'videoIndex')}"
                                style="color: #fff;font-size: 22px;text-align: center;width: 330px">学术视频</a>--}%
                            <h2>
                                %{-- <a href="${createLink(controller: 'index', action: 'videoIndex')}">${message(code: 'my.academic.name')}${message(code: 'my.video.name')}</a> --}%
                                <a href="${createLink(controller: 'index', action: 'videoIndex', params: [categoryId: categoryId])}">${categoryName}</a>
                                <a href="#"
                                   class="boful_news_name_number">共${programTotal}${message(code: 'my.video.name')}</a>
                            </h2>

                            <p class="boful_news_name_small_class">
                                <g:each in="${categoryList}" var="category" status="sta">
                                    <g:if test="${sta < 8}">
                                        <a href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: category?.id])}">${category?.name}</a>
                                    </g:if>
                                </g:each>
                            </p>
                        </div>

                        <div class="video_left_imgs">
                            <g:each in="${programList}" var="program" status="le">
                                <g:if test="${le < 2}">
                                    <div class="boful_video_item " title="${program?.name}">
                                        <div class="boful_recommond_video_item_play"><a
                                                href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                                target="_blank"><img
                                                    style="box-shadow: none"
                                                    src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_video_item_play_icon.png')}">
                                        </a></div>

                                        <div class="boful_recommond_video_item_date">共${program?.serials?.size() == program?.serialNum ? program?.serialNum : program?.serials?.size()}个</div>
                                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                           target="_blank">
                                            <img programId="${program?.id}" size="160x100"
                                                 class="imgLazy program_poster"
                                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                        </a>

                                        <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                              target="_blank">${CTools.cutString(program?.name, 10)}</a>
                                        </p>
                                    </div>
                                </g:if>
                            </g:each>

                        </div>
                    </div>

                    <div class="boful_video_mid">
                        <g:each in="${programList}" var="program" status="le">
                            <g:if test="${le >= 2 && le < 6}">
                                <div class="boful_video_item" title="${program?.name}">
                                    <div class="boful_recommond_video_item_play"><a
                                            href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                            target="_blank"><img
                                                style="box-shadow: none"
                                                src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_video_item_play_icon.png')}">
                                    </a></div>

                                    <div class="boful_recommond_video_item_date">共${program?.serials?.size() == program?.serialNum ? program?.serialNum : program?.serials?.size()}个</div>
                                    <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                       target="_blank">
                                        <img programId="${program?.id}" size="160x100"
                                             class="imgLazy program_poster"
                                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                    </a>

                                    <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                          target="_blank">${CTools.cutString(program?.name, 10)}</a>
                                    </p>
                                </div>
                            </g:if>
                        </g:each>
                    </div>

                    <div class="boful_video_right">
                        <g:each in="${programList}" var="program" status="le">
                            <g:if test="${le == 6}">
                                <a style="width: 330px"
                                   href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                   target="_blank">
                                    <div class="boful_recommond_video_item_date_videoright">共${program?.serials?.size() == program?.serialNum ? program?.serialNum : program?.serials?.size()}个</div>
                                    <img programId="${program?.id}" size="330x255"
                                         class="imgLazy program_poster"
                                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"
                                         title="${program?.name}"></a>

                                <p><a style="width: 330px"
                                      href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                      target="_blank">${CTools.cutString(program?.name, 10)}</a>
                                </p>
                            </g:if>
                        </g:each>
                    </div>
                </div>
            </div>
        </g:if>
        <g:elseif test="${categoryType == 2}">
            <!-------音频------>
            <div class="boful_content_item">
                <div class="boful_content_container">

                    <div class="boful_doc_left">
                        <div class="boful_type_title boful_type_title_reb5 boful_news_name_class_number" id="hotAudio">
                            <h2>
                                %{-- <a href="${createLink(controller: 'index', action: 'imageIndex')}">${message(code: 'my.audio.name')}${message(code: 'my.material.name')}</a> --}%
                                <a href="${createLink(controller: 'index', action: 'audioIndex', params: [categoryId: categoryId])}">${categoryName}</a>
                                <a href="#" class="boful_news_name_number">共${programTotal}${message(code: 'my.audio.name')}</a>
                            </h2>

                            <p class="boful_news_name_small_class">
                                <g:each in="${categoryList}" var="category">
                                    <a href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: category?.id])}">${nts.utils.CTools.cutString(category?.name, 5)}</a>
                                </g:each>
                            </p>
                        </div>

                        <div class="doc_left_imgs">
                            <g:each in="${programList}" var="program" status="pro">
                                <g:if test="${pro < 2}">
                                    <div class="boful_photo_item" title="${program?.name}">
                                        <div class="boful_photo_itme_see">
                                            <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_photo_img_see_img.png')}"/>
                                        </div>
                                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                           target="_blank">
                                            <img programId="${program?.id}" size="160x100"
                                                 class="imgLazy program_poster"
                                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                        </a>

                                        <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                              target="_blank">${CTools.cutString(program?.name, 10)}</a>
                                        </p>
                                    </div>
                                </g:if>
                            </g:each>

                        </div>
                    </div>

                    <div class="boful_doc_right">
                        <g:each in="${programList}" var="program" status="pro">
                            <g:if test="${pro >= 2 && pro<=9}">
                                <div class="boful_photo_item" title="${program?.name}">
                                    %{-- <div class="boful_photo_itme_see">
                                         <a href="#"><img src="${resource(dir: 'skin/blue/pc/images', file: 'boful_photo_img_see_img.png')}"/></a>
                                     </div>--}%
                                    <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                       target="_blank">
                                        <img programId="${program?.id}" size="160x100"
                                             class="imgLazy program_poster"
                                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                    </a>

                                    <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                          target="_blank">${CTools.cutString(program?.name, 10)}</a>
                                    </p>
                                </div>
                            </g:if>
                        </g:each>
                    </div>

                    %{--<div class="boful_video_mid">
                        <g:each in="${programList}" var="program" status="pro">
                            <g:if test="${pro >= 6 & pro < 10}">
                                <div class="boful_photo_item" title="${program?.name}">
                                     <div class="boful_photo_itme_see">
                                         <a href="#"><img src="${resource(dir: 'skin/blue/pc/images', file: 'boful_photo_img_see_img.png')}"/></a>
                                     </div>
                                    <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                       target="_blank">
                                        <img data-original="${posterLinkNew(program: program, size: '160x100')}" class="imgLazy"
                                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                    </a>

                                    <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                          target="_blank">${CTools.cutString(program?.name, 10)}</a>
                                    </p>
                                </div>
                            </g:if>
                        </g:each>
                    </div>--}%

                </div>
            </div>
        </g:elseif>
        <g:elseif test="${categoryType == 3}">
            <!-- 文档 -->
            <div class="boful_content_item">
                <div class="boful_content_container" style="background: #FCFCFC">
                    <div class="boful_doc_left">
                        <div class="boful_type_title boful_type_title_reb3 boful_news_name_class_number">
                            %{-- <a href="${createLink(controller: 'index', action: 'docIndex')}"
                                style="color: #fff;font-size: 22px;text-align: center;width: 330px">共享资料</a>--}%
                            <h2>
                                %{-- <a href="${createLink(controller: 'index', action: 'docIndex')}">${message(code: 'my.share.name')}${message(code: 'my.data.name')}</a> --}%
                                <a href="${createLink(controller: 'index', action: 'docIndex', params: [categoryId: categoryId])}">${categoryName}</a>
                                <a href="#" class="boful_news_name_number">共${programTotal}${message(code: 'my.word.name')}</a>
                            </h2>

                            <p class="boful_news_name_small_class">
                                <g:each in="${categoryList}" var="category" status="sta">
                                    <g:if test="${sta < 8}">
                                        <a href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: category?.id])}">${category?.name}</a>
                                    </g:if>
                                </g:each>
                            </p>

                        </div>

                        <div class="doc_left_imgs">
                            <g:each in="${programList}" status="pro" var="program">
                                <g:if test="${pro < 2}">
                                    <div class="boful_doc_item" title="${program?.name}">
                                        <div class="boful_recommond_doc_reading"><a style=" width: 95px;  height: 127px;"
                                                                                    href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                                                                    target="_blank"><img
                                                    src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_doc_reading_icon.png')}"/><span>${message(code: 'my.start.name')}${message(code: 'my.reading.name')}</span>
                                        </a></div>
                                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                           target="_blank">
                                            <img programId="${program?.id}" size="97x123"
                                                 class="imgLazy program_poster"
                                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                        </a>

                                        <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                              target="_blank">${CTools.cutString(program?.name, 5)}</a>
                                        </p>
                                    </div>
                                </g:if>
                            </g:each>
                        </div>

                    </div>

                    <div class="boful_doc_right">
                        <g:each in="${programList}" status="pro" var="program">
                            <g:if test="${pro >= 2}">
                                <div class="boful_doc_item" title="${program?.name}">
                                    <div class="boful_recommond_doc_reading"><a style=" width: 95px;  height: 127px;"
                                                                                href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                                                                target="_blank"><img
                                                src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_doc_reading_icon.png')}"/><span>${message(code: 'my.start.name')}${message(code: 'my.reading.name')}</span>
                                    </a></div>
                                    <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                       target="_blank">
                                        <img programId="${program?.id}" size="97x127"
                                             class="imgLazy program_poster"
                                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                    </a>

                                    <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                          target="_blank">${CTools.cutString(program?.name, 5)}</a>
                                    </p>
                                </div>
                            </g:if>
                        </g:each>
                    </div>
                </div>
            </div>
        </g:elseif>
        <g:elseif test="${categoryType == 4}">
            <div class="boful_content_item">
                <div class="boful_content_container">

                    <div class="boful_video_left">
                        <div class="boful_type_title boful_type_title_reb4 boful_news_name_class_number">
                            %{-- <a href="${createLink(controller: 'index', action: 'imageIndex')}"
                               >教学素材</a>--}%
                            <h2>
                                %{-- <a href="${createLink(controller: 'index', action: 'imageIndex')}">${message(code: 'my.teaching.name')}${message(code: 'my.material.name')}</a> --}%
                                <a href="${createLink(controller: 'index', action: 'imageIndex', params: [categoryId: categoryId])}">${categoryName}</a>
                                <a href="#"
                                   class="boful_news_name_number">共${programTotal}${message(code: 'my.picture.name')}</a>
                            </h2>

                            <p class="boful_news_name_small_class">
                                <g:each in="${categoryList}" var="category" status="sta">
                                    <g:if test="${sta < 8}">
                                        <a href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: category?.id])}">${category?.name}</a>
                                    </g:if>
                                </g:each>
                            </p>
                        </div>

                        <div class="video_left_imgs">
                            <g:each in="${programList}" var="program" status="pro">
                                <g:if test="${pro < 2}">
                                    <div class="boful_photo_item" title="${program?.name}">
                                        <div class="boful_photo_itme_see">
                                            <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_photo_img_see_img.png')}"/>
                                        </div>
                                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                           target="_blank">
                                            <img programId="${program?.id}" size="160x100"
                                                 class="imgLazy program_poster"
                                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                        </a>

                                        <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                              target="_blank">${CTools.cutString(program?.name, 10)}</a>
                                        </p>
                                    </div>
                                </g:if>
                            </g:each>

                        </div>
                    </div>

                    <div class="boful_video_mid">
                        <g:each in="${programList}" var="program" status="pro">
                            <g:if test="${pro >= 2 & pro < 6}">
                                <div class="boful_photo_item" title="${program?.name}">
                                    %{-- <div class="boful_photo_itme_see">
                                         <a href="#"><img src="${resource(dir: 'skin/blue/pc/images', file: 'boful_photo_img_see_img.png')}"/></a>
                                     </div>--}%
                                    <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                       target="_blank">
                                        <img programId="${program?.id}" size="160x100"
                                             class="imgLazy program_poster"
                                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                    </a>

                                    <p><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                          target="_blank">${CTools.cutString(program?.name, 10)}</a>
                                    </p>
                                </div>
                            </g:if>
                        </g:each>
                    </div>

                    <div class="boful_video_right">
                        <g:each in="${programList}" var="program" status="pro">
                            <g:if test="${pro == 6}">
                            %{--<div class="boful_recommond_video_item_date2">05.23s</div>--}%
                                <a style="width: 330px"
                                   href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                   target="_blank">
                                    <img programId="${program?.id}" size="330x255"
                                         class="imgLazy program_poster" title="${program?.name}"
                                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                </a>

                                <p><a style="width: 330px"
                                      href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                      target="_blank">${CTools.cutString(program?.name, 10)}</a>
                                </p>
                            </g:if>
                        </g:each>
                    </div>
                </div>
            </div>
        </g:elseif>
        <g:elseif test="${categoryType == 5}">

            <!------共享课程-------->
            <div class="boful_content_item">
                <div class="boful_content_container">
                    <div class="boful_video_left">
                        <div class="boful_type_title boful_type_title_reb5  boful_news_name_class_number">
                            %{-- <a href="${createLink(controller: 'index', action: 'videoIndex')}"
                                style="color: #fff;font-size: 22px;text-align: center;width: 330px">学术视频</a>--}%
                            <h2><a href="${createLink(controller: 'index', action: 'courseIndex', params: [categoryId: categoryId])}">${categoryName}</a>
                            <a href="#" class="boful_news_name_number">共${programTotal}${message(code: 'my.course.name')}</a>
                            </h2>

                            <p class="boful_news_name_small_class">
                                <g:each in="${categoryList}" var="category">
                                    <a href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: category?.id])}">${CTools.cutString(category?.name, 5)}</a>
                                </g:each>
                            </p>
                        </div>

                        <div class="video_left_imgs">
                            <g:each in="${programList}" var="course" status="ss">
                                <g:if test="${ss<2}">
                                    <div class="boful_video_item " title="">
                                        <div class="boful_recommond_video_item_play"><a href="${createLink(controller: 'program',action: 'courseDetail',params: [programId:course?.id])}" target="_blank"><img
                                                style="box-shadow: none"
                                                src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_video_item_play_icon.png')}">
                                        </a></div>

                                        <div class="boful_recommond_video_item_date"></div>
                                        <a href="${createLink(controller: 'program',action: 'courseDetail',params: [programId:course?.id])}" target="_blank"><img
                                                programId="${course?.id}" size="160x100"
                                                class="imgLazy program_poster" ></a>

                                        <p><a href="${createLink(controller: 'program',action: 'courseDetail',params: [programId:course?.id])}" target="_blank">${CTools.cutString(course?.name,10)}</a></p>
                                    </div>
                                </g:if>
                            </g:each>
                        </div>
                    </div>

                    <div class="boful_video_mid">
                        <g:each in="${programList}" var="course" status="ss">
                            <g:if test="${ss>=2&&ss<6}">
                                <div class="boful_video_item" title="">
                                    <div class="boful_recommond_video_item_play"><a href="${createLink(controller: 'program',action: 'courseDetail',params: [programId:course?.id])}" target="_blank"><img
                                            style="box-shadow: none"
                                            src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_video_item_play_icon.png')}">
                                    </a></div>

                                    <div class="boful_recommond_video_item_date"></div>
                                    <a href="${createLink(controller: 'program',action: 'courseDetail',params: [programId:course?.id])}" target="_blank"><img
                                            programId="${course?.id}" size="160x100"
                                            class="imgLazy program_poster"></a>

                                    <p><a href="${createLink(controller: 'program',action: 'courseDetail',params: [programId:course?.id])}" target="_blank">${CTools.cutString(course?.name,10)}</a></p>
                                </div>
                            </g:if>
                        </g:each>

                    </div>
                    <g:each in="${programList}" var="course" status="ss">
                        <g:if test="${ss==6}">
                            <div class="boful_video_right">
                                <a style="width: 330px" href="${createLink(controller: 'program',action: 'courseDetail',params: [programId:course?.id])}" target="_blank">
                                    <div class="boful_recommond_video_item_date_videoright"></div>
                                    <img programId="${course?.id}" size="160x100"
                                         class="imgLazy program_poster"/></a>

                                <p><a style="width: 330px" href="${createLink(controller: 'program',action: 'courseDetail',params: [programId:course?.id])}" target="_blank">${CTools.cutString(course?.name,10)}</a></p>
                            </div>
                        </g:if>
                    </g:each>

                </div>
            </div>
        </g:elseif>
        <g:elseif test="${categoryType == 6}">
            <div class="boful_content_item">
                <div class="boful_content_container">
                    <div class="boful_video_left">
                        <div class="boful_type_title boful_type_title_reb5  boful_news_name_class_number">
                            <h2><a href="${createLink(controller: 'index', action: 'flashIndex', params: [categoryId: categoryId])}">${categoryName}</a>
                                <a href="#" class="boful_news_name_number">共${programTotal}${message(code: 'my.flash.name')}</a>
                            </h2>

                            <p class="boful_news_name_small_class">
                                <g:each in="${categoryList}" var="category">
                                    <a href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: category?.id])}">${CTools.cutString(category?.name, 5)}</a>
                                </g:each>
                            </p>
                        </div>

                        <div class="video_left_imgs">
                            <g:each in="${programList}" var="program" status="ss">
                                <g:if test="${ss<2}">
                                    <div class="boful_video_item " title="">
                                        <div class="boful_recommond_video_item_play"><a href="${createLink(controller: 'program',action: 'showProgram',params: [id:program?.id])}" target="_blank"><img
                                                style="box-shadow: none"
                                                src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_video_item_play_icon.png')}">
                                        </a></div>

                                        <div class="boful_recommond_video_item_date"></div>
                                        <a href="${createLink(controller: 'program',action: 'showProgram',params: [id:program?.id])}" target="_blank">
                                            <img src="${resource(dir: 'images/flash', file: 'flash-imgs.png')}" onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                                        </a>

                                        <p><a href="${createLink(controller: 'program',action: 'showProgram',params: [id:program?.id])}" target="_blank">${CTools.cutString(program?.name,10)}</a></p>
                                    </div>
                                </g:if>
                            </g:each>
                        </div>
                    </div>

                    <div class="boful_video_mid">
                        <g:each in="${programList}" var="program" status="ss">
                            <g:if test="${ss>=2&&ss<6}">
                                <div class="boful_video_item" title="">
                                    <div class="boful_recommond_video_item_play"><a href="${createLink(controller: 'program',action: 'showProgram',params: [id:program?.id])}" target="_blank"><img
                                            style="box-shadow: none"
                                            src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_video_item_play_icon.png')}">
                                    </a></div>

                                    <div class="boful_recommond_video_item_date"></div>
                                    <a href="${createLink(controller: 'program',action: 'showProgram',params: [id:program?.id])}" target="_blank">
                                        <img src="${resource(dir: 'images/flash', file: 'flash-imgs.png')}" onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                                    </a>

                                    <p><a href="${createLink(controller: 'program',action: 'showProgram',params: [id:program?.id])}" target="_blank">${CTools.cutString(program?.name,10)}</a></p>
                                </div>
                            </g:if>
                        </g:each>

                    </div>
                    <g:each in="${programList}" var="program" status="ss">
                        <g:if test="${ss==6}">
                            <div class="boful_video_right">
                                <a style="width: 330px" href="${createLink(controller: 'program',action: 'courseDetail',params: [programId:program?.id])}" target="_blank">
                                    <div class="boful_recommond_video_item_date_videoright"></div>
                                    <img src="${resource(dir: 'images/flash', file: 'flash-imgs.png')}" onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/></a>
                                <p><a style="width: 330px" href="${createLink(controller: 'program',action: 'courseDetail',params: [programId:program?.id])}" target="_blank">${CTools.cutString(program?.name,10)}</a></p>
                            </div>
                        </g:if>
                    </g:each>

                </div>
            </div>
        </g:elseif>
    </g:each>
</g:if>
</body>
</html>