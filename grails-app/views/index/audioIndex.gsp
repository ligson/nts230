<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="index">
    <title>${audioName}</title>
    %{-- <link rel="stylesheet" type="text/css"
           href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_videoIndex.css')}">--}%
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'audio_index.css')}">
  %{--  <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_index.js')}"></script>--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_audioIndexTow.js')}"></script>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'flashindexTow.css')}">
</head>

<body>
<div class="banner1">
    <div class="banner-btn">
        <a href="javascript:;" class="prevBtn"><i></i></a>
        <a href="javascript:;" class="nextBtn"><i></i></a>
    </div>
    <ul class="banner-img">
    <g:each in="${recommendNumList}" status="i" var="rPro">
        <li>
            <a class="" title="${rPro.name}" target="_blank"
               href="${createLink(controller: 'program', action: 'showProgram', params: [id: rPro.id])}">
                %{--<img data-original="${resource(dir: 'skin/blue/pc/front/images', file: 'b_img_c1.jpg')}"
                                     class="imgLazy"
                                     alt=""
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>--}%
                <img src="${posterLinkNew(program: rPro, size: '380x-1')}"
                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
            </a>
        </li>
    </g:each>
    </ul>
      %{--  <li><a class="b_img_c1"><img data-original="${resource(dir: 'skin/blue/pc/front/images', file: 'b_img_c1.jpg')}"
                                     class="imgLazy"
                                     alt=""
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
        </a></li>--}%
        %{--<li><a href="${createLink(controller: 'index', action: 'courseIndex')}" class="b_img_c2"><img
                data-original="${resource(dir: 'skin/blue/pc/front/images', file: 'b_img_c2.jpg')}"
                class="imgLazy"
                alt=""
                onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
        </a></li>
        <li><a href="${createLink(controller: 'index', action: 'programIndex')}" class="b_img_c3"><img
                data-original="${resource(dir: 'skin/blue/pc/front/images', file: 'b_img_c3.jpg')}"
                class="imgLazy"
                alt=""
                onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
        </a></li>
        <li><a href="${createLink(controller: 'userActivity', action: 'index')}" class="b_img_c4"><img
                data-original="${resource(dir: 'skin/blue/pc/front/images', file: 'b_img_c4.jpg')}"
                class="imgLazy"
                alt=""
                onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
        </a></li>
        <li><a href="${createLink(controller: 'community', action: 'index')}" class="b_img_c5"><img
                data-original="${resource(dir: 'skin/blue/pc/front/images', file: 'b_img_c5.jpg')}"
                class="imgLazy"
                alt=""
                onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
        </a></li>--}%
    </ul>
    <ul class="banner-circle"></ul>
</div>
<!--------头部切换--------->
%{--<div class="boful_img_box" >
    <div class="boful_img_container" >
        <div class="boful_img_bottom">
            <div class="boful_item_screenshots">
                <span class="boful_item_mark"></span>
                <span></span>
                <span></span>
                <span></span>
                 --}%%{-- <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'ouknow_course_icon.png')}"
                       onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'"
                       width="98"
                       height="58" border="0"/>--}%%{--

            </div>
        </div>

        <div class="boful_img_items">
            <a href="#" target="_blank">
                <img data-original="${resource(dir: 'skin/blue/pc/front/images', file: 'audion_dome_bar.png')}" class="imgLazy"
                     alt="" width="1024" height="260" border="0"
                     onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'">
                <img
                        data-original="${resource(dir: 'skin/blue/pc/front/images', file: 'audion_dome_bar.png')}" class="imgLazy"
                        alt="" width="1024" height="260" border="0"
                        onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'">
                <img
                        data-original="${resource(dir: 'skin/blue/pc/front/images', file: 'audion_dome_bar.png')}" class="imgLazy"
                        alt="" width="1024" height="260" border="0"
                        onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'">
                <img
                        data-original="${resource(dir: 'skin/blue/pc/front/images', file: 'audion_dome_bar.png')}" class="imgLazy"
                        alt="" width="1024" height="260" border="0"
                        onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'">
            </a>
        </div>
    </div>
</div>--}%
<!--------音频资源--------->
<div class="audio_content wrap">
<!--------左侧资源--------->
<div class="audio_content_left">
<!--------最新资源------->
<div class="audio_left_new">
    <h1><p><span>最新资源</span></p></h1>

    <div class="audio_items">
        <g:each in="${newProgramList}" var="program" status="i">
            <g:if test="${i < 4}">
                <div class="audio_item">
                    <a href="#" target="_blank" class="audio_item_img">
                        <img data-original="${posterLinkNew(program: program, size: '160x100')}" class="imgLazy"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                    </a>
                    <div class="audio_item_infor">
                        <p class="audio_item_title"><a target="_blank"
                                                       href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                                       title="${program?.name}">${CTools.cutString(program?.name, 5)}</a>
                        </p>

                        <p class="audio_item_descript" title="${CTools.htmlToBlank(program?.description)}">${CTools.cutString(CTools.htmlToBlank(program?.description),10)}</p>

                        <p class="audio_item_number"><span class="audio_item_user_num" title="${program?.actor}">${CTools.cutString(program?.actor,5)}</span>
                            <span class="audio_item_user_time">${new java.text.SimpleDateFormat('yyyy-MM-dd').format(program?.dateCreated)}</span></p>
                    </div>
                </div>
            </g:if>
        </g:each>
    </div>

    <div class="audio_left_hot">
        <g:each in="${newProgramList}" var="program" status="i">
            <g:if test="${i >= 4}">
                <div class="audio_hot_items left_hot_mar">
                    <div class="audio_hot_item">
                        <span class="hot_item_title"><a target="_blank"
                                                        href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                                                        title="${program?.name}">${CTools.cutString(program?.name, 5)}</a>
                        </span>
                        <span class="hot_item_username" title="${program?.actor}">${CTools.cutString(program?.actor,5)}</span>
                        <span class="hot_play_number">${new java.text.SimpleDateFormat('yyyy-MM-dd').format(program?.dateCreated)}</span>
                        <span class="hot_item_operate">
                            <a class="operate_paly" target="_blank"
                               href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                               title="播放">播放</a>
                            <a class="operate_save" href="#"
                               onclick="collectionProgram(${program.id}, '${session.consumer?.name}')" title="收藏">收藏</a>
                            <a class="operate_offer" href="#"
                               onclick="recommendProgram(${program.id}, '${session.consumer?.name}')" title="推荐">推荐</a>
                        </span>
                    </div>
                </div>
            </g:if>
        </g:each>
    </div>

</div>
<!--------热门资源------->
<div class="audio_left_new">
    <h1><p><span>热门资源</span></p></h1>

    <div class="audio_items">
        <g:each in="${hotProgramList}" var="pHot" status="i">
            <g:if test="${i<4}">
                <div class="audio_item">
                    <a href="#" class="audio_item_img">
                        <img data-original="${posterLinkNew(program: pHot, size: '160x100')}" class="imgLazy"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                    </a>
                    <div class="audio_item_infor">
                        <p class="audio_item_title"><a target="_blank"
                                                       href="${createLink(controller: 'program', action: 'showProgram', params: [id: pHot.id])}"
                                                       title="${pHot.name}">${CTools.cutString(pHot?.name, 5)}</a></p>

                        <p class="audio_item_descript" title="${CTools.htmlToBlank(pHot?.description)}">${CTools.cutString(CTools.htmlToBlank(pHot?.description),10)}</p>

                        <p class="audio_item_number">
                            <span class="audio_item_user_num">${pHot?.frequency}</span>
                            <span class="audio_item_user_time">${new java.text.SimpleDateFormat('yyyy-MM-dd').format(pHot?.dateCreated)}</span>
                        </p>
                    </div>
                </div>
            </g:if>
        </g:each>
    </div>

    <div class="audio_left_hot">
        <div class="audio_hot_items left_hot_mar">
            <g:each in="${hotProgramList}" var="pHot" status="i">
                <g:if test="${i>3&&i<7}">
                    <div class="audio_hot_item">
                        <span class="hot_item_title"><a target="_blank"
                                                        href="${createLink(controller: 'program', action: 'showProgram', params: [id: pHot.id])}"
                                                        title="${pHot.name}">${CTools.cutString(pHot?.name, 5)}</a>
                        </span>
                        <span class="hot_item_username" title="${pHot?.actor}">${CTools.cutString(pHot?.actor,5)}</span>
                        <span class="hot_play_number">${new java.text.SimpleDateFormat('yyyy-MM-dd').format(pHot?.dateCreated)}</span>
                        <span class="hot_item_operate">
                            <a class="operate_paly" href="#" title="播放">播放</a>
                            <a class="operate_save" href="#" title="收藏">收藏</a>
                            <a class="operate_offer" href="#" title="推荐">推荐</a>
                        </span>
                    </div>
                </g:if>
            </g:each>

        </div>

        <div class="audio_hot_items">
            <g:each in="${hotProgramList}" var="pHot" status="i">
                <g:if test="${i>6}">
                    <div class="audio_hot_item">
                        <span class="hot_item_title"><a target="_blank"
                                                        href="${createLink(controller: 'program', action: 'showProgram', params: [id: pHot.id])}"
                                                        title="${pHot.name}">${CTools.cutString(pHot?.name, 5)}</a>
                        </span>
                        <span class="hot_item_username" title="${pHot?.actor}">${CTools.cutString(pHot?.actor,5)}</span>
                        <span class="hot_play_number">${new java.text.SimpleDateFormat('yyyy-MM-dd').format(pHot?.dateCreated)}</span>
                        <span class="hot_item_operate">
                            <a class="operate_paly" href="#" title="播放">播放</a>
                            <a class="operate_save" href="#" title="收藏">收藏</a>
                            <a class="operate_offer" href="#" title="推荐">推荐</a>
                        </span>
                    </div>
                </g:if>
            </g:each>

        </div>
    </div>

</div>
<!--------分类资源------->
<div class="audio_other_items">
<g:each in="${programMap}" var="pMap" >
    <div class="audio_other_item">
        <h2>${pMap?.key}<a href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: pMap?.value[0].programCategories[0].id])}"
                           target="_blank">&nbsp;/&nbsp;${message(code: 'my.more.name')}</a></h2>
        <g:each in="${pMap?.value}" var="pro" >
            <div class="audio_hot_item">
                <span class="hot_item_title"><a target="_blank"
                                                href="${createLink(controller: 'program', action: 'showProgram', params: [id: pro.id])}"
                                                title="${pro?.name}">${CTools.cutString(pro?.name, 5)}</a></span>
                <span class="hot_item_username" title="${pro?.actor}">${CTools.cutString(pro?.actor,5)}</span>
                <span class="hot_play_number">${new java.text.SimpleDateFormat('yyyy-MM-dd').format(pro?.dateCreated)}</span>
                <span class="hot_item_operate">
                    <a class="operate_paly" href="#" title="播放">播放</a>
                    <a class="operate_save" href="#" title="收藏">收藏</a>
                    <a class="operate_offer" href="#" title="推荐">推荐</a>
                </span>
            </div>
        </g:each>
    </div>
</g:each>

</div>
</div>
<!--------右侧--------->
<div class="audio_content_right">
    <div class="audio_list_rank">
        <h1><p><span>推荐排行</span><a href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: programCategory.id])}"
                                   target="_blank">&nbsp;/&nbsp;${message(code: 'my.more.name')}</a></p></h1>

        <div class="audio_rank_items">
            <g:each in="${recommendNumList}" status="i" var="rPro">
                <p>
                    <span class="${i<3 ?'right_rank_number right_rank_yellow':'right_rank_number right_rank_bla'}">${i+1}</span>
                    <a class="right_rank_title" target="_blank"
                       href="${createLink(controller: 'program', action: 'showProgram', params: [id: rPro.id])}"
                       title="${rPro?.name}">${CTools.cutString(rPro?.name, 5)}</a>
                    <span class="right_rank_user">${new java.text.SimpleDateFormat('yyyy-MM-dd').format(rPro?.dateCreated)}</span>
                    <span class="rank_item_operate">
                        <a class="operate_paly" href="#" title="播放">播放</a>
                        <a class="operate_save" href="#" title="收藏">收藏</a>
                        <a class="operate_offer" href="#" title="推荐">推荐</a>
                    </span>
                </p>
            </g:each>
        </div>
    </div>

    <div class="audio_list_tally">
        <h1><span>精选分类</span></h1>

        <p class="audio_tally_itmes">
            <g:each in="${audioTypeOne}" var="pc">
                %{--<a href="" title=""></a>--}%
                <a href="${createLink(controller: 'index', action: 'search', params: [programCategoryId: pc.id])}" target="_blank" title="${pc?.name}">${CTools.cutString(pc?.name,5)}</a>
            </g:each>
        </p>
    </div>

    <div class="audio_list_tally">
        <h1><span>热门标签</span></h1>

        <p class="audio_tally_itmes">
            <g:each in="${programTagsHot}" var="tag">
                %{--<a href="" title="">${pc.name}</a>--}%
                <a href="${createLink(controller: 'index', action: 'search', params: [programTagId: tag.id])}"
                   target="_blank">${CTools.cutString(tag?.name, 5)}</a>
            </g:each>
        </p>
    </div>
</div>
</div>
</body>
</html>
