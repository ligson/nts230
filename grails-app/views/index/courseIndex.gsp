<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-27
  Time: 下午4:12
--%>

<%@ page import="nts.utils.CTools;nts.program.domain.Program" contentType="text/html;charset=UTF-8" %>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <title>${courseName}</title>
    <r:require modules="raty,jquery"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'courseIndex.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'flashindex.css')}">
    %{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'course_index_c.css')}">--}%

    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/course/course_index.js')}"></script>--}%
    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/course/course_window.js')}"></script>--}%
    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/course/ZoomPic.js')}"></script>--}%

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
            });

        })


    </script>
    <script type="text/javascript">
        //        $(document).ready(function () {
        //
        //            var iframeHeight = function () {
        //                var _height = $(window).height() - 34;
        //                $('#content').height(_height);
        //            };
        //            window.onresize = iframeHeight;
        //            $(function () {
        //                iframeHeight();
        //            });
        //        });

    </script>
</head>

<body>
<div class="boful_body_container_bg">
<!--------图片切换----->
%{--<div class="course_bananr_tab">
    --}%%{--<div class="wrap course_bananr_tab_mgr">
        <div id="focus_Box">
            <span class="prev">&nbsp;</span>
            <span class="next">&nbsp;</span>
            <ul>
                <g:each in="${tuijianList}" var="program">
                    <li>
                        <a title="${program?.name}" href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: program?.id])}" target="_blank"><img
                                data-original="${posterLinkNew(program: program, size: '634x330')}"
                                class="imgLazy"
                                onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                        </a>
                        --}%%{----}%%{--href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: program?.id])}"--}%%{----}%%{--
                        <p>
                            <span>${CTools.cutString(program?.name, 10)}</span>
                            <a href="#">
                                演讲不仅是对新生大有启迪，对于老生同样。他演讲的技巧，演讲的内容对每一个普通人也是意思深远。
                            </a>
                        </p>
                    </li>
                </g:each>
            </ul>
        </div>

    </div>--}%%{--
   --}%%{-- <div id="banner">
        <ul id="banner_img">
            <g:each in="${tuijianList}" var="program" status="ss">
                <li style="display: ${ss == 1 ? "list-item" : "none"}" class="item1">
                    <div class="wrapper">
                        <div style="left: 35px; opacity: 1;" class="ad_txt">
                            --}%%{----}%%{-- <p><img src="${resource(dir: 'skin/blue/pc/front/images', file: 'xl-ico011.png')}"><img
                                     src="${resource(dir: 'skin/blue/pc/front/images', file: 'banner-logo-kd.png')}" class="ml12 mb7">
                             </p>--}%%{----}%%{--

                            <h2 title="${CTools.htmlToBlank(program?.name)}">${CTools.htmlToBlank(program?.name)}</h2>

                            <p class="col33ff" title="${CTools.htmlToBlank(program?.description)}">${CTools.htmlToBlank(program?.description)}</p>

                            <p class="go_btn_box"><a
                                    href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                    target="_blank"
                                    title="${CTools.htmlToBlank(program?.name)}" class="go_btn"></a><a
                                    href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                    target="_blank">${message(code: 'my.gotolearn.name')}！</a>
                            </p>
                        </div>

                        <div style="right: 10px; opacity: 1;" class="ad_img"><a
                                href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                title="${CTools.htmlToBlank(program?.name)}"
                                target="_blank"><img src="${posterLinkNew(program: program, size: '1024x400')}"
                                                     alt="" width="1024" height="400" border="0"
                                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'" />
                        </a>
                        </div>
                    </div>
                </li>
            </g:each>

        --}%%{----}%%{-- <li style="display: list-item;" class="item2">
             <div class="wrapper">
                 <div style="left: 35px; opacity: 1;" class="ad_txt">
                     <p><img src="${resource(dir: 'skin/blue/pc/front/images', file: 'xl-ico.png')}"><img
                             src="${resource(dir: 'skin/blue/pc/front/images', file: 'banner-logo-bhh.png')}" class="ml12 mb7">
                     </p>

                     <h2>航空航天概论</h2>

                     <p class="col33ff">它的飞行原理、动力系统、机载设备、构造及其地面设备等方面的基本知识...<br>
                         基本原理和常用技术</p>

                     <p class="col58">激发学生热爱航空、献身航空的有效途径</p>

                     <p class="go_btn_box"><a
                             href="${createLink(controller: 'program', action: 'showProgram', params: [id: tuijianList[1].id])}"
                             title="航空航天概论" class="go_btn" target="_blank"></a><a
                             href="${createLink(controller: 'program', action: 'showProgram', params: [id: tuijianList[1].id])}">上课去！4月24日开课</a>
                     </p>
                 </div>

                 <div style="right: 10px; opacity: 1;" class="ad_img"><a
                         href="${createLink(controller: 'program', action: 'showProgram', params: [id: tuijianList[1].id])}"
                         title="航空航天概论"
                         target="_blank"><img
                             src="${resource(dir: 'skin/blue/pc/front/images', file: 'banner_img021231.png')}" alt="航空航天概论">
                 </a></div>
             </div>
         </li>
         <li style="display: none;" class="item3">
             <div class="wrapper">
                 <div style="left: 35px; opacity: 1;" class="ad_txt">
                     <p><img src="${resource(dir: 'skin/blue/pc/front/images', file: 'xl-ico.png')}"><img
                             src="${resource(dir: 'skin/blue/pc/front/images', file: 'banner-logo-qh.png')}"
                             class="ml12 mb7"></p>

                     <h2>全国高校微课教学比赛</h2>

                     <p class="col33ff">引导广大电影爱好者发现正能量，用微电影手段和传播正能量...<br>
                         展现新时代青年大学生的责任与担当</p>

                     <p class="col58">本届大赛指导单位为国家新闻出版广电总局电影局</p>

                     <p class="go_btn_box"><a
                             href="${createLink(controller: 'program', action: 'showProgram', params: [id: tuijianList[2].id])}"
                             title="全国高校微课教学比赛" class="go_btn" target="_blank"></a><a
                             href="${createLink(controller: 'program', action: 'showProgram', params: [id: tuijianList[2].id])}"
                             target="_blank">3月15日开始，去参加！</a></p>
                 </div>

                 <div style="right: 10px; opacity: 1;" class="ad_img"><a
                         href="${createLink(controller: 'program', action: 'showProgram', params: [id: tuijianList[2].id])}"
                         title="全国高校微课教学比赛"
                         target="_blank"><img
                             src="${resource(dir: 'skin/blue/pc/front/images', file: 'banner_img0654165546.png')}"
                             alt="全国高校微课教学比赛"></a>
                 </div>
             </div>
         </li>
         <li style="display: none;" class="item4">
             <div class="wrapper">
                 <div style="left: 35px; opacity: 1;" class="ad_txt">
                     <p><img src="${resource(dir: 'skin/blue/pc/front/images', file: 'xl-ico.png')}"><img
                             src="${resource(dir: 'skin/blue/pc/front/images', file: 'banner-logo-cd.png')}" class="ml12 mb7">
                     </p>

                     <h2>世界经济五百年</h2>

                     <p class="col33ff">世界贸易和经济的发展，特别是近代西方资本主义的.... <br>
                         发展和现代世界资本主义经济体系的建立</p>

                     <p class="col58">中国经济在世界经济发展中的变化</p>

                     <p class="go_btn_box"><a
                             href="${createLink(controller: 'program', action: 'showProgram', params: [id: tuijianList[3].id])}"
                             title="世界经济五百年" class="go_btn" target="_blank"></a><a
                             href="${createLink(controller: 'program', action: 'showProgram', params: [id: tuijianList[3].id])}">3月10日开课，上课去！</a>
                     </p>
                 </div>

                 <div style="right: 10px; opacity: 1;" class="ad_img"><a
                         href="${createLink(controller: 'program', action: 'showProgram', params: [id: tuijianList[3].id])}"
                         title="世界经济五百年"
                         target="_blank"><img
                             src="${resource(dir: 'skin/blue/pc/front/images', file: 'banner_img541666.png')}" alt="世界经济五百年">
                 </a>
                 </div>
             </div>
         </li>
         <li style="display: none;" class="item5">
             <div class="wrapper">
                 <div style="left: 35px; opacity: 1;" class="ad_txt">
                     <p><img src="${resource(dir: 'skin/blue/pc/front/images', file: 'xl-ico.png')}"><img
                             src="${resource(dir: 'skin/blue/pc/front/images', file: 'banner-logo-bd.png')}" class="ml12 mb7">
                     </p>

                     <h2>操作系统与虚拟化安全</h2>

                     <p class="col33ff">系统全面介绍操作系统与虚拟化安全...<br>
                         探讨云计算平台安全核心技术及其发展趋势</p>

                     <p class="col58">为掌握计算机信息系统安全奠定坚实基础</p>

                     <p class="go_btn_box"><a
                             href="${createLink(controller: 'program', action: 'showProgram', params: [id: tuijianList[4].id])}"
                             title="操作系统与虚拟化安全" class="go_btn" target="_blank"></a><a
                             href="${createLink(controller: 'program', action: 'showProgram', params: [id: tuijianList[4].id])}">上课去！</a>
                     </p>
                 </div>

                 <div style="right: 10px; opacity: 1;" class="ad_img"><a
                         href="${createLink(controller: 'program', action: 'showProgram', params: [id: tuijianList[4].id])}"
                         title="操作系统与虚拟化安全"
                         target="_blank"><img
                             src="${resource(dir: 'skin/blue/pc/front/images', file: 'banner_img05.png')}" alt="操作系统与虚拟化安全">
                 </a></div>
             </div>
         </li>--}%%{----}%%{--
        </ul>

        <div id="banner_ctr">
            <div style="left: 30px;" id="drag_ctr"></div>
            <ul>
                <li class=""></li>
                <li class=""></li>
                <li class=""></li>
                <li class=""></li>
                <li class=""></li>

            </ul>

            <div style="left: 30px;" id="drag_arrow"></div>
        </div>
    </div>--}%%{--
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/fashionflash.js')}"></script>
</div>--}%

<!--课程分类--------->
%{--<div class="boful_body_container_nav wrap">
    <p><g:each in="${programCategoryList}" var="category" status="sta">
        <g:if test="${sta < 8}">
            <a href="${createLink(controller: 'program', action: 'courseList', params: [categoryId: category?.id])}">${CTools.htmlToBlank(category?.name)}</a>
        </g:if>
    </g:each>
        <g:if test="${categoryList?.size() > 8}">
            <a href="${createLink(controller: 'index', action: 'search', params: [otherOption: Program.ONLY_LESSION_OPTION])}">${message(code: 'my.more.name')}<span
                    class="boful_body_container_nav_more"></span></a></g:if>
    </p>
</div>--}%
<div class="ou_resource_meau_nav">
    <div class="ou_resource_meau_nav_content">
        <a href="${createLink(controller: 'index', action: 'courseIndex')}">${courseName}</a>
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
<div class="boful_body_container">
    <!---------列表-------------->
    %{--  <g:each in="${publicLession}" var="program" status="sta">--}%
    <div class="boful_course_item">
        <div class="course_item_header" style="background:none">
            <h4><span class="course_item_header_title"
                      href="#">${message(code: 'my.newcourse.name')}${message(code: 'my.recommend.name')}</span><em></em>
                %{--<a
                    class="course_item_header_more"
                    href="${createLink(controller: 'program', action: 'courseList', params: [isNew: 1])}">${message(code: 'my.more.name')}...</a>--}%
            </h4>
        </div>


        <div class="course_video_items">
            <g:if test="${newProgram?.size() == 0}">目前没有资源!</g:if>
            <g:each in="${newProgram}" var="program">
                <div class="course_video_item">
                    <div class="course_video_item_head">
                        <div class="course_video_item_head_see">
                            <p>
                                <a title="${CTools.htmlToBlank(program?.description)}"
                                   href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: program?.id])}"
                                   target="_blank">${message(code: 'my.learn.name')}${message(code: 'my.courses.name')}</a>
                            </p>
                        </div>

                        <div class="course_video_item_user">
                            <a title="${CTools.htmlToBlank(program?.consumer?.name)}"
                               href="${createLink(controller: 'my', action: 'userSpace', params: [id: program?.consumer?.id])}">
                                <div class="course_video_item_user_img">
                                    <img src="${generalUserPhotoUrl(consumer: program?.consumer)}" width="59"
                                         height="59"
                                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                                </div></a>

                            <div class="course_video_item_user_name"><a title="${CTools.htmlToBlank(program?.consumer?.name)}"
                                                                        href="${createLink(controller: 'my', action: 'userSpace', params: [id: program.consumer.id])}">${program?.consumer?.name}</a>
                            </div>
                            %{--<a href="${createLink(controller: 'my', action: 'userSpace', params: [id: program?.consumer?.id])}">
                                <div class="course_video_item_user_img">
                                    <img src="${generalUserPhotoUrl(consumer: program.consumer)}"/>
                                </div></a>

                            <div class="course_video_item_user_name">${program.consumer.name}</div>--}%
                        </div>
                        <img class="imgLazy course_img_size" data-original="${posterLinkNew(program: program, size: '240x130')}"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'defaultPoster.jpg')}'">
                    </div>

                    <div class="course_video_item_content">
                        <div class="course_video_item_head_title">
                            <h2><a title="${CTools.htmlToBlank(program?.name)}"
                                   href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: program?.id])}"
                                   target="_blank">${nts.utils.CTools.cutString(CTools.htmlToBlank(program?.name),20)}</a>
                            </h2>
                            <div class="course_video_item_head_title_infors" title="${CTools.htmlToBlank(program?.description)}">${nts.utils.CTools.cutString(CTools.htmlToBlank(program?.description), 25)}</div>
                        </div>

                        <div class="course_talk_number">
                            %{--显示星星，之后如果要显示星星，直接复制过去就可以，修改program的获取就ok--}%
                            <div class="coures_talk_stars" name="serialLinkShow${program?.id}"></div>
                            <input type="hidden" id="serialLink${program?.id}"
                                   value="${calcProgramScore(program: program)}"/>
                            <input type="hidden" name="programId" value="${program?.id}">
                            <span class="course_video_item_content_talk">(${program?.remarks?.size()}条评价)</span>
                        </div>

                        <div class="course_video_item_mgr">
                            <div class="course_video_item_content_users">
                                <g:if test="${studyCourse(playedPrograms: program?.playedPrograms) != ''}">
                                    <span class="users_lang">${studyCourse(playedPrograms: program?.playedPrograms)}</span>
                                    <span class="users">${message(code: 'my.people.name')}${message(code: 'my.learn.name')}</span>
                                </g:if>
                                <g:else>
                                    <span class="users">目前还没有人在学!</span>
                                </g:else>
                                <span class="course_video_item_content_number">共${publicTotal(serial: program.serials)}学时</span>
                            </div>
                        </div>
                    </div>
                </div>
            </g:each>

        </div>
    </div>
    <g:each in="${publicLession}" var="program" status="sta">
        <div class="boful_course_item">
            <div class="course_item_header">
                <h1><a class="course_item_header_title"
                       href="${createLink(controller: 'program', action: 'courseList', params: [categoryId: programCategoryList.get(sta)?.id])}">${programCategoryList.get(sta)?.name}</a><a
                        class="res-add-more m-mgr" style="font-size: 12px; float: right;"
                        href="${createLink(controller: 'program', action: 'courseList', params: [categoryId: programCategoryList.get(sta)?.id])}">${message(code: 'my.more.name')}</a>
                </h1>
            </div>



            <div class="course_video_items">
                <g:each in="${program}" var="pro" status="ss">
                    <g:if test="${ss<4}">
                        <div class="course_video_item">
                            <div class="course_video_item_head">
                                <div class="course_video_item_head_see">
                                    <p>
                                        <a title="${CTools.htmlToBlank(pro?.description)}"
                                           href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: pro?.id])}"
                                           target="_blank">${message(code: 'my.learn.name')}${message(code: 'my.courses.name')}</a>
                                    </p>
                                </div>

                                <div class="course_video_item_user">
                                    <a title="${CTools.htmlToBlank(pro?.consumer?.name)}"
                                       href="${createLink(controller: 'my', action: 'userSpace', params: [id: pro?.consumer?.id])}">
                                        <div class="course_video_item_user_img">
                                            <img src="${generalUserPhotoUrl(consumer: pro?.consumer)}" width="59"
                                                 height="59"
                                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                                        </div></a>

                                    <div class="course_video_item_user_name">
                                        <a title="${CTools.htmlToBlank(pro?.consumer?.name)}" href="${createLink(controller: 'my', action: 'userSpace', params: [id: pro.consumer.id])}">${CTools.cutString(CTools.htmlToBlank(pro?.consumer?.name), 20)}</a>
                                    </div>
                                </div>
                                <img class="imgLazy course_img_size" data-original="${posterLinkNew(program: pro, size: '240x130')}"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                            </div>

                            <div class="course_video_item_content">
                                <div class="course_video_item_head_title">
                                    <h2><a title="${CTools.htmlToBlank(pro?.name)}"
                                           href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: pro?.id])}"
                                           target="_blank">${nts.utils.CTools.cutString(CTools.htmlToBlank(pro?.name), 20)}</a>
                                    </h2>

                                    <div class="course_video_item_head_title_infors" title="${CTools.htmlToBlank(pro?.description)}">${CTools.htmlToBlank(pro?.description)}</div>
                                </div>

                                <div class="course_talk_number">
                                    <div class="coures_talk_stars" name="serialLinkShow${pro?.id}">
                                    </div>
                                    <input type="hidden" id="serialLink${pro?.id}"
                                           value="${calcProgramScore(program: pro)}"/>
                                    <input type="hidden" name="programId" value="${pro?.id}">
                                    <span class="course_video_item_content_talk">(${pro?.remarks?.size()}条评价)</span>
                                </div>

                                <div class="course_video_item_mgr">
                                    <div class="course_video_item_content_users">
                                        <g:if test="${studyCourse(playedPrograms: pro?.playedPrograms) != ''}">
                                            <span class="users_lang">${studyCourse(playedPrograms: pro?.playedPrograms)}</span>
                                            <span class="users">${message(code: 'my.people.name')}${message(code: 'my.learn.name')}</span>
                                        </g:if>
                                        <g:else>
                                            <span class="users">没有人在学!</span>
                                        </g:else>
                                        <span class="course_video_item_content_number">共${publicTotal(serial: pro?.serials)}${message(code: 'my.period.name')}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </g:if>
                </g:each>
            </div>
        </div>

    </g:each>
%{--  </g:each>--}%

</div>
</div>
</body>
</html>