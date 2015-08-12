<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-3-18
  Time: 下午12:18
--%>

<%@ page import="mooc.course.services.CourseAppService" contentType="text/html;charset=UTF-8" %>
<div id="html5css3"
     style="position:fixed;z-index:9999; left:0px; top:0px;display:none">您的浏览器不支持html5和css3，为保证正常的浏览和使用,建议您使用<a
        href="http://www.microsoft.com/china/windows/internet-explorer/" target="_blank">Internet Explorer 9及以上版本</a>
    或使用： <a href="http://www.mozillaonline.com/">Firefox</a> / <a
        href="http://www.google.com/chrome/?hl=zh-CN">Chrome</a>/ <a href="http://chrome.360.cn/">360极速</a> 等浏览器浏览。
</div>

<!--[if lte IE 6]>
<div id="ie6-warning">您的浏览器不支持html5和css3，为保证正常的浏览和使用。建议您升级到 <a href="http://www.microsoft.com/china/windows/internet-explorer/" target="_blank">Internet Explorer 9及以上版本</a>
或使用： <a href="http://www.mozillaonline.com/">Firefox</a> / <a href="http://www.google.com/chrome/?hl=zh-CN">Chrome</a>/ <a href="http://chrome.360.cn/">360极速</a> 等浏览器浏览。
</div>
<script type="text/javascript">
function position_fixed(el, eltop, elleft){
       // check if this is IE6
       if(!window.XMLHttpRequest)
              window.onscroll = function(){
                     el.style.top = (document.documentElement.scrollTop + eltop)+"px";
                     el.style.left = (document.documentElement.scrollLeft + elleft)+"px";
       }
       else el.style.position = "fixed";
}
       position_fixed(document.getElementById("ie6-warning"),0, 0);
</script>
<![endif]-->
<link type="text/css" rel="stylesheet"
      href="${resource(dir: 'skin/' + frontTheme() + '/pc/front/css', file: 'index_base_second.css')}"/>

<div class="boful_toolbar hborder">
    <div class="b_t_line hcorlor">
        <div class="wrap b_t_bg">

            %{-- <!-----------logo及检索----------->--}%
            <div class="boful_logo_header">
                <div class="boful_logo_small">
                    <a href="${createLink(controller: 'index', action: 'index')}">
                        <img src="${webLogeUrl(filePath: 'upload/Logo')}"/></a>
                </div>

                <div class="ou_search_box">
                    <g:form controller="index" action="search">
                        <div class="ou_search_second">
                            <input type="hidden" value="" id="searchSelectCondition" name="otherOption">

                            <div class="serch_icon_place hserchspan" id="searchSelectBtn">
                                <span></span>
                            </div>

                            <div class="serch_down_list hserchlist" id="searchMenu">
                                <div><span class="ch_all" lang=""></span><span>全&nbsp;部</span></div>

                                <div><span class="ch_course" lang="128"></span><span>课&nbsp;程</span></div>

                                <div><span class="ch_video" lang="0"></span><span>视&nbsp;频</span></div>

                                <div><span class="ch_word" lang="8"></span><span>文&nbsp;档</span></div>

                                <div><span class="ch_img" lang="16"></span><span>图&nbsp;片</span></div>

                                <div><span class="ch_audio" lang="1"></span><span>音&nbsp;频</span></div>
                            </div>
                        </div>

                        <div class="serch_body">
                            <label class="serch_body_class">
                                <input class="boful_search_input ouknow_unstyle_h hserchinput" name="name" type="text"
                                       value="输入搜索内容"
                                       id="search_input">
                            </label>
                            <label class="serch_body_int">
                                <input class="boful_button_ou ouknow_unstyle_h_b hserchbut" type="submit" value="">
                            </label>

                        </div>
                    </g:form>
                </div>

                <g:if test="${application.searchEnable}">
                    <div class="right_search">
                        <a href="${createLink(controller: 'program', action: 'superSearch')}">全文检索</a>
                    </div>
                </g:if>

                <div class="ou_logined_box"
                    <g:if test="${session.consumer && "anonymity" != session.consumer.name}">
                        style="display:block;"
                    </g:if>
                    <g:else>
                        style="display:none;"
                    </g:else>>
                    <div class="user_meau_sub_list" style="display:none;">
                        <a id="user_sub_1"
                           href="${createLink(controller: 'my', action: 'userSpace', params: [id: session.consumer.id])}">个人主页</a>
                        <a id="user_sub_2" href="${createLink(controller: 'my', action: 'index')}">学习空间</a>
                        %{--<a href="${createLink(controller: 'my', action: 'myUserActivityManager')}">我的活动</a>--}%
                        %{--<a href="${createLink(controller: 'my', action: 'mySharingList')}">我的文件</a>--}%
                        %{--<a href="${createLink(controller: 'my', action: 'myHistoryProgramList')}">学习记录</a>--}%
                        %{--<a href="${createLink(controller: 'my', action: 'communityList')}">我的社区</a>--}%
                        <a id="user_sub_3" href="${createLink(controller: 'my', action: 'myInfo')}">个人设置</a>
                        <a class="user_exit" href="${createLink(controller: 'index', action: 'logout')}">退出</a>
                    </div>

                    <div class="ouknow_user_information">
                        <p class="ouknow_user_information_box">
                            <a class="head_portrait" href="${createLink(controller: 'my', action: 'index')}">
                                <img id="userPhoto" src="${generalUserPhotoUrl(consumer: session.consumer)}"
                                     width="38" height="38"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"
                                     title="${session.consumer.name}"/>
                            </a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="o_nav_bg hnavbg">
        <div class="wrap ">
            <!-------------导航---------->
            <div class="ou_header_nav">
                <div class="hnavcorl1">
                    <div class="n-mgr">
                        <div class="bf-cla-items"></div>
                    </div>

                    %{--<div class="nav_item" id="nav_item_3">
                        <a class="font16"
                           --}%%{--href="${createLink(controller: 'index', action: 'index')}">--}%%{--
                            href="/">
                            ${message(code: 'my.home.name')}</a>
                    </div>
                    <g:if test="${CourseAppService.courseQuery != null}">
                        <div class="nav_item" id="nav_item_2"><a class="font16"
                                                                 href="${createLink(controller: 'index', action: 'moocIndex')}">${message(code: 'my.mooc.name')}</a>
                        </div>
                    </g:if>

                --}%%{--<g:if test="${userResourceView(controllerName: 'index', actionName: 'programIndex') == 'true'}">
                    <div class="nav_item" id="nav_item_3"><a
                            href="${createLink(controller: 'program', action: 'programIndex')}">${message(code: 'my.program.name')}</a>
                    </div>
                </g:if>--}%%{--
                    <g:if test="${userResourceView(controllerName: 'userActivity', actionName: 'index') == 'true'}">
                        <div class="nav_item" id="nav_item_6"><a class="font16"
                                                                 href="${createLink(controller: 'userActivity', action: 'index')}">${message(code: 'my.activity.name')}</a>
                        </div>
                    </g:if>
                    <g:if test="${userResourceView(controllerName: 'community', actionName: 'index') == 'true'}">
                        <div class="nav_item" id="nav_item_7"><a class="font16"
                                                                 href="${createLink(controller: 'community', action: 'index')}">${message(code: 'my.studycommunity.name')}</a>
                        </div>
                    </g:if>--}%

                </div>
            </div>

            <div class="ou_header_login_door">
                <g:if test="${session.consumer && session.consumer.name != 'anonymity'}">
                %{--<div class="user_meau_sub_list" style="display:none;">
                    <a href="${createLink(controller: 'my', action: 'userSpace', params: [id: session.consumer.id])}">个人主页</a>
                    <a href="${createLink(controller: 'my', action: 'index')}">学习空间</a>
                    --}%%{--<a href="${createLink(controller: 'my', action: 'myUserActivityManager')}">我的活动</a>--}%%{--
                    --}%%{--<a href="${createLink(controller: 'my', action: 'mySharingList')}">我的文件</a>--}%%{--
                    --}%%{--<a href="${createLink(controller: 'my', action: 'myHistoryProgramList')}">学习记录</a>--}%%{--
                    --}%%{--<a href="${createLink(controller: 'my', action: 'communityList')}">我的社区</a>--}%%{--
                    <a href="${createLink(controller: 'my', action: 'myInfo')}">个人设置</a>
                    <a class="user_exit" href="${createLink(controller: 'index', action: 'logout')}">退出</a>
                </div>--}%
                    <!-----------结束----------->
                %{--  <div class="ouknow_user_information">
                      <p class="ouknow_user_information_box">
                          --}%%{--  <a class="head_remind" title="消息通知"></a>--}%%{--
                          <a class="head_portrait" href="${createLink(controller: 'my', action: 'index')}">
                              <img src="${generalUserPhotoUrl(consumer: session.consumer)}"
                                   width="38" height="38"
                                   onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"
                                   title="${session.consumer.name}"/>
                          </a>
                      </p>
                      --}%%{--   <span class="user_meau_sub" id="show_my">
                             <a class="user_name"
                                href="${createLink(controller: 'my', action: 'index')}">${session.consumer.name}</a>
                         </span>--}%%{--
                      --}%%{--  <a class="user_login_exit" href="${createLink(controller: 'index', action: 'logout')}">退&nbsp;出</a>--}%%{--

                  </div>--}%
                </g:if>
                <g:else>
                    <div class="boful_logon_in_box">
                        <a class="boful_logon_enroll"
                           href="${createLink(controller: 'index', action: 'register')}">${message(code: 'my.register.name')}</a>
                        <g:if test="${isRegister1 == '1'}">
                            <a class="boful_logon_in" rel="leanModal"
                               href="${createLink(controller: 'index', action: 'login')}">${message(code: 'my.login.name')}</a>
                        </g:if>
                        <g:else>
                            <a class="boful_logon_in" rel="leanModal"
                               href="#signup">${message(code: 'my.login.name')}</a>
                        </g:else>
                    </div>
                </g:else>
            </div>
        </div>
    </div>
</div>
%{--<div style="height: 160px"></div>--}%

%{--
<div class="boful_hackie"></div>--}%
