<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-3-18
  Time: 下午12:23
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
%{--页脚--}%
<div class="boful_footer  ">
    <div class="boful_footer_code">
        <div class="boful_footer_code_small">
            <span class="boful_footer_code_top" id="returnTop"></span>
            <span class="boful_footer_code_small1"><img
                    src="${resource(dir: 'images', file: 'rms_app_down.png')}"/></span>
        </div>

        <div class="boful_footer_code_big" id="footerCode">
            <img src="${resource(dir: 'images', file: 'rms_app_down.png')}"/>

            <p>扫描下载</p>
        </div>
    </div>

    %{-- <div style="width: 100%">
         <div class=" wrap" style=" width:1024px; margin: 0 auto;">
         <div class="boful_footer_head_title">
             <h1 ><span>天津高校资源联盟共享服务平台</span></h1>

             <span class="foot_line"></span>
         </div>
     </div>
     </div>

     <div class="foot_wrap wrap">
         <div class="universitise">
             <!---天津科技--->
             <div class="university_tjkj">
                 <a title="天津科技大学" href="http://59.67.6.16/nts/" target="_blank"></a>
             </div>
             <!---天津南开--->
             <div class="university_tjnaikai">
                 <a title="南开大学" href="http://ura.nankai.edu.cn/nts/" target="_blank"></a>
             </div>
             <!---天津城建--->
             <div class="university_tjcj">
                 <a title="天津城建大学" href="http://ura.tcu.edu.cn/nts/" target="_blank"></a>
             </div>
             <!---天津商业--->
             <div class="university_tjsy">
                 <a title=" 天津商业大学" href="" target="_blank"></a>
             </div>
             <!---天津工业--->
             <div class="university_tjgy">
                 <a title="天津工业大学" href="" target="_blank"></a>
             </div>
             <!---天津财经--->
             <div class="university_tjcjdx">
                 <a title="天津财经大学" href="" target="_blank"></a>
             </div>
             <!---天津音乐--->
             <div class="university_tjyy">
                 <a title="天津音乐学院" href="" target="_blank"></a>
             </div>
             <!---天津中医--->
             <div class="university_tjzy">
                 <a title="天津中医药大学" href="" target="_blank"></a>
             </div>
             <!---天津师范--->
             <div class="university_tjsfdx">
                 <a title="天津师范大学" href="" target="_blank"></a>
             </div>
             <!---天津医科大学--->
             <div class="university_tjyxy">
                 <a title="天津医科大学" href="" target="_blank"></a>
             </div>
             <!---天津外语--->
             <div class="university_tjwgy">
                 <a title="天津外国语大学" href="" target="_blank"></a>
             </div>

         </div>
     </div>--}%
</div>

<div class="foot_copyright fcorl1" style="background: none">
    <div class="foot_content">
        %{--<div class="foot_content_icon">
            <a href="http://webscan.360.cn/index/checkwebsite/url/developer.ouknow.com">
                <img border="0"
                     src="http://img.webscan.360.cn/status/pai/hash/7ae58b262cef91a204109464bacd72db/?size=74x27"/>
            </a>
        </div>-}%

        <div class="foot_content_name">
            %{--<a href="http://nic.tust.edu.cn/">承建单位：天津科技大学</a>--}%
            <a href="http://www.boful.com/" target="_blank"><p>技术支持：<g:message code="application.bottom" default="北京邦丰信息技术有限公司"/></p>

                %{--<a class="p_m" href="http://www.miitbeian.gov.cn/">京ICP备12008431号</a>--}%
            </a>

        </div>

    </div>
</div>

<div id="ouknow_user_login_box">
    <div id="signup">
        <div id="signup-ct">
            <div id="signup-header">
                <h2>${message(code: 'my.login.name')}</h2>
                <a class="modal_close" href="#"></a>
            </div>

            <div class="modal_close_error">
                <span id="errorMessage" class="modal_close_error_word" style="color:red;"></span>
            </div>
            <g:form controller="index" action="checkLogin" name="checkLogin">
                <div class="txt-fld" style="margin-top: 10px">
                    <label>
                        <input id="boful_username" class="good_input" name="loginName" type="text" value="请输入用户名"/>
                    </label>
                </div>

                <div class="txt-fld">
                    <label>
                        <input id="boful_password" name="password" type="password" title="输入密码"/>
                    </label>
                </div>

                <div class="txt-fld" style="margin: 15px 0">
                    <p>
                        <label>
                            <input id="setCookie" style="width: 20px;height: 15px; padding:0; border:0px;float: left"
                                   type="checkbox"><span>${message(code: 'my.remember.name')}${message(code: 'my.password.name')}</span>
                            <input type="hidden" value="0" name="remFlg" id="remFlg"/>
                            %{--<a href="#">忘记密码？</a>--}%
                        </label>
                    </p>
                </div>

                <div class="btn-fld">
                    <button type="button" name="checkLogin"
                            id="checkLoginButton">${message(code: 'my.login.name')}</button>
                </div>

                <div class="btn-fld1">
                    <p>没有帐号？<a href="${createLink(controller: 'index', action: 'register')}">立即注册</a></p>
                </div>
            </g:form>
        </div>
    </div>
</div>

<script type="text/javascript" src="${resource(dir: "/js/boful/index", file: "userLogin.js")}"></script>
