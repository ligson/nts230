<!DOCTYPE html>
<html>
<head>
    <title><g:message code="application.name" default="确然多媒体资源应用系统"/></title>
    <meta name="layout" content="index">
    <link rel="icon" type="image/x-icon" href="${resource(dir: 'skin/blue/pc/images', file: 'boful_logo.ico')}"/>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'admin_user_login.css')}"/>
    <script type="text/javascript">
//        function resizeLoginUI() {
//
//            var win = $(window);
//            var footerDiv = $(".boful_login_footers");
//            var loginDiv = $(".boful_admin_login_box");
//            var imgId = $(".boful_admin_login_img_bgs");
//            var body = $("body");
//            var winClient = $(window).height();
//
//            if (winClient < 768) {
//                imgId.css('height', 768);
//                footerDiv.css("top", 768 - footerDiv.height());
//            } else {
//                imgId.css('height', winClient);
//                footerDiv.css("top", winClient - footerDiv.height())
//            }
//            if (win.height() - loginDiv.height() - (win.height() / 5) - footerDiv.height() > 0) {
//                loginDiv.css("top", win.height() / 5);
//            }
//            if (win.width() - loginDiv.width() > loginDiv.width()) {
//                loginDiv.css("left", win.width() * 2 / 3);
//            }
//            /*    loginDiv.css("top", win.height()/4);
//             loginDiv.css("left", win.width() * 3 / 4);*/
//        }
//        $(function () {
//            resizeLoginUI();
//            $(window).resize(function () {
//                resizeLoginUI();
//            });
//
//            $("#form1").keydown(function (event) {
//
//                return event.keyCode != 13;
//
//            })
//
//
//        });


        /////////////////////////////////
        $(function () {
            var loginName = $("#loginName");
            loginName.click(function () {
                loginName.val('');
            });
            loginName.focus(function () {
                loginName.val('');
            });

            var password = $("#password");
            password.focus(function () {
                password.val('');
            });
            password.click(function () {
                password.val('');
            });

            var setCookie = $("#setCookie");
            setCookie.change(function () {
                var loginName = loginName.val();
                var remFlg = $("#remFlg").val();
                if (remFlg == "0") {
                    $("#remFlg").val("1");
                } else if (remFlg == "1") {
                    $("#remFlg").val("0");
                }

//                $.cookie("loginName", loginName, {expires: 30});
//                $.cookie("pwd", password, {expires: 30});
            });
            var loginName2 = $.cookie("loginName");
            var pwd2 = $.cookie("pwd");
            if (loginName2 != null) {
                setCookie.attr("checked", "checked");
                $("#remFlg").val("1");
                loginName.val(loginName2);
                password.val(pwd2);
            }
        });
        function userLogin() {
            if (document.form1.loginName.value == "") {
                alert("请输入用户名");
                document.form1.loginName.focus();
                return false;
            }
            if (document.form1.password.value == "") {
                alert("请输入密码");
                document.form1.password.focus();
                return false;
            }
            //document.form1.action=baseUrl + "index/login";
            document.form1.submit();
            return true;
        }

        /**
         * @return {boolean}
         */
        function OnMyKeyDown() {
            if ((event.which && event.which == 13) || (event.keyCode && event.keyCode == 13)) {
                return userLogin();
            }
            return true;
        }

        function showhide_obj(obj, icon) {
            obj = document.getElementById(obj);
            icon = document.getElementById(icon);
            if (obj.style.display == "none") {
                //指定文档中的对象为div,仅适用于IE;
                div_list = document.getElementsByTagName("div");
                for (i = 0; i < div_list.length; i++) {
                    thisDiv = div_list[i];
                    if (thisDiv.id.indexOf("title") != -1)//当文档div中的id含有list时,与charAt类似;
                    {
                        //循环把所有菜单链接都隐藏起来
                        thisDiv.style.display = "none";
                        icon.innerHTML = "+";
                    }
                }

                myfont = document.getElementsByTagName("font");
                for (i = 0; i < myfont.length; i++) {
                    thisfont = myfont[i];
                }
                icon.innerHTML = "-";
                obj.style.display = ""; //只显示当前链接
            }
            else {
                //当前对象是打开的，就关闭它;
                icon.innerHTML = "+";
                obj.style.display = "none";
            }
        }

        function toRegister() {
            document.location.href = baseUrl + "index/register";
        }

        ////////////////////////////////



    </script>


    <script>
        //用户登录回车提交 2014-04-24
        document.onkeydown=function(event)
        {
//            if($("#form1")){
//                return;
//            }else{
                e = event ? event :(window.event ? window.event : null);
                if(e.keyCode==13){
                    document.getElementById("checkLoginButton").click();
                }
//            };

        }

    </script>
</head>

<body>

<div class="boful_admin_login_img_bgs" style="_height:768px;_width: 1024px; height: 817px">
    <div class="wrap">
    <div class="boful_admin_login" >
    <!------登录------->
        <g:form controller="index" action="checkLogin" method="post" name="form1">
            <input type="hidden" value="${url}" name="url"/>
            <div class="boful_admin_login_box">


                <!------输入框------->
                <div class="boful_admin_login_box_input_box">
                    <input type="text" value="用户名" id="loginName" class="dl_input_border" name="loginName" autocomplete="off">
                    <input type="password" value="" id="password" class="dl_input_border" autocomplete="off" name="password">
                </div>
                <!------记住密码------->
                <div class="boful_admin_login_box_rem_passwprd">
                    <p>
                        <input type="checkbox" value="" id="setCookie">
                        <input type="hidden" value="0" name="remFlg" id="remFlg"/>
                        <span>记住密码</span>
                    </p>
                </div>
                <!------logoin------->

            </div>
            <div style="float: right; width: 195px;_width: 165px; _margin-top: -100px; float: right;  height: 200px; margin: 20px 20px 0 0;">

                <div class="boful_admin_login_box_logo">
                    %{--<p class="boful_admin_login_box_logo_words">欢迎登录</p>--}%
                    <span class="boful_admin_login_box_logo_error">
                        <g:if test="${params.loginFlg == '0'}">
                            用户名或密码错误！
                        </g:if>
                        <g:if test="${params.loginFlg == '1'}">
                            用户名或密码错误！
                        </g:if>
                        <g:if test="${params.loginFlg == '2'}">
                            用户有效期已过！
                        </g:if>
                        <g:if test="${params.loginFlg == '3'}">
                            不是管理员，无权操作!
                        </g:if>
                        <g:if test="${params.loginFlg == '4'}">
                            该用户已经被锁定，无法登陆，请联系管理员！
                        </g:if>
                        <g:if test="${params.loginFlg == '5'}">
                            用户名或密码错误！
                        </g:if>
                        <g:if test="${params.loginFlg == '6'}">
                            用户名或密码错误！
                        </g:if>
                        <g:if test="${params.loginFlg == '7'}">
                            注册帐号，尚未审批通过！
                        </g:if>

                        <g:if test="${params.loginFlg == '8'}">
                            ${params.ERRMSG}
                        </g:if>
                    </span>
                </div>

                <div class="boful_admin_login_button"  >
                    <input type="button" onclick="userLogin()" style="width: 120px; "  id="checkLoginButton" value="登&nbsp;&nbsp;录">
                </div>

                <div class="boful_admin_login_registered">
                    <a href="#" onClick="toRegister();">立即注册</a>
                </div>
            </div>
        </g:form>
    </div>
    <div class="boful_tishi">
        <div class="boful_tishitxt"><em>HELLO</em></div>
    </div>
</div>
    %{--<!------页脚------->--}%
    %{--<div class="boful_login_footers">--}%
        %{--<div class="boful_login_footers_bg">--}%
            %{--<div class="boful_login_footers_infor">copyright by Boful design. All Right Reserved 北京邦丰信息技术有限公司 京ICP备12008431号-1--}%
                %{--<a href="http://www.boful.com/us/contact">联系我们</a> <a href="http://www.boful.com">关于邦丰</a></div>--}%
        %{--</div>--}%
    %{--</div>--}%
</div>

%{--
<div class="foot_copyright">
    <div class="foot_content">
        <div class="foot_content_icon">
            <a href="http://webscan.360.cn/index/checkwebsite/url/developer.ouknow.com">
                <img src="http://img.webscan.360.cn/status/pai/hash/7ae58b262cef91a204109464bacd72db/?size=74x27" border="0">
            </a>
        </div>

        <div class="foot_content_name">

            <a href="http://www.boful.com/"><p>技术支持：北京邦丰信息技术有限公司</p>

            </a><a class="p_m" href="http://www.miitbeian.gov.cn/">京ICP备12008431号</a>


        </div>

    </div>
</div>
--}%

</body>
</html>