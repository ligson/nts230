<!DOCTYPE html>
<html>
<head>
    <title><g:message code="application.name" default="确然多媒体资源应用系统"/></title>
    <meta name="layout" content="none">
    <link rel="icon" type="image/x-icon" href="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_logo.ico')}"/>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'admin_user_login.css')}"/>
    <r:require modules="jquery,jquery-cookie"/>
    <r:layoutResources/>
    <r:layoutResources/>
    <%
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
        String indexPath = "${basePath}${createLink(controller: 'index', action: 'index')}";
        String loginPath = "${basePath}${createLink(controller: 'index', action: 'login')}";
        String loginURL = "?goto=" + indexPath + "&gotoOnFail=" + loginPath;
    %>
    <script type="text/javascript">
        function resizeLoginUI() {

            var win = $(window);
            var footerDiv = $(".boful_login_footers");
            var loginDiv = $(".boful_admin_login_box");
            var imgId = $(".boful_admin_login_img_bgs");
            var body = $("body");
            var winClient = $(window).height();

            if (winClient < 768) {
                imgId.css('height', 768);
                footerDiv.css("top", 768 - footerDiv.height());
            } else {
                imgId.css('height', winClient);
                footerDiv.css("top", winClient - footerDiv.height())
            }
            if (win.height() - loginDiv.height() - (win.height() * 1 / 5) - footerDiv.height() > 0) {
                loginDiv.css("top", win.height() * 1 / 5);
            }
            if (win.width() - loginDiv.width() > loginDiv.width()) {
                loginDiv.css("left", win.width() * 2 / 3);
            }
            /*    loginDiv.css("top", win.height()/4);
             loginDiv.css("left", win.width() * 3 / 4);*/
        }
        $(function () {
            resizeLoginUI();
            $(window).resize(function () {
                resizeLoginUI();
            });

            $("#form1").keydown(function (event) {

                if (event.keyCode == 13) {
                    //event.preventDefault();
                    return false;
                }
            })


        });

    </script>
</head>

<body>

<div class="boful_admin_login">

    <!------登录------->
    <form action="http://ids.tust.edu.cn/amserver/UI/Login?goto=http://ura.tust.edu.cn:80/nts/index/index&gotoOnFail=http://ura.tust.edu.cn/nts/index/login"
          method="post" name="form1" id="form1">
        <div class="boful_admin_login_box">

            <div class="boful_admin_login_box_logo">
                <p class="boful_admin_login_box_logo_words">欢迎登录</p>
                <span class="boful_admin_login_box_logo_error">
                    <g:if test="${loginFlg == '0'}">
                        用户名或密码错误！
                    </g:if>
                    <g:if test="${params.loginFlg == '1'}">
                        用户名或密码错误！
                    </g:if>
                    <g:if test="${loginFlg == '2'}">
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

            <!------输入框------->
            <div class="boful_admin_login_box_input_box">
                <input type="text" value="用户名" id="name" name="IDToken1" autocomplete="off">
                <input type="password" value="" id="password" autocomplete="off" name="IDToken2">
            </div>
            <!------记住密码------->
            <div class="boful_admin_login_box_rem_passwprd">
                <p>
                    <input type="checkbox" value="" id="setCookie">
                    <span>记住密码</span>
                </p>
            </div>
            <!------logoin------->

            <div class="boful_admin_login_button">
                <input type="button" onclick="userLogin()" value="登&nbsp;&nbsp;录">
            </div>

            <div class="boful_admin_login_registered">
                <a href="#" onClick="toRegister();">立即注册</a>
            </div>
        </div>
    </form>
</div>

<div class="boful_admin_login_img_bgs">
    <img id="boful_admin_login_img_bg" class="boful_admin_login_img_bg"
         src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_admin_login_img_1.jpg')}"/>
</div>
<!------页脚------->
<div class="boful_login_footers">
    <div class="boful_login_footers_bg">
        <div>copyright by Boful design. All Right Reserved 北京邦丰信息技术有限公司 京ICP备12008431号-1
            <a href="http://www.boful.com/us/contact">联系我们</a> <a href="http://www.boful.com">关于邦丰</a></div>
    </div>
</div>
<SCRIPT LANGUAGE="JavaScript">
    $(function () {

        $("#name").click(function () {
            $("#name").val('');
        });
        $("#name").focus(function () {
            $("#name").val('');
        });
        $("#password").focus(function () {
            $("#password").val('');
        });
        $("#password").click(function () {
            $("#password").val('');
        });

        $("#setCookie").change(function () {
            var name = $("#name").val();
            var pwd = $("#password").val();
            $.cookie("name", name, {expires: 30});
            $.cookie("pwd", pwd, {expires: 30});
        });
        var name = $.cookie("name");
        var pwd = $.cookie("pwd");
        if (name != null) {
            $("#setCookie").attr("checked", "checked");
            $("#name").val(name);
            $("#password").val(pwd)
        }
    })
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" type="text/javascript">

    function userLogin() {
        if (document.form1.name.value == "") {
            alert("请输入用户名");
            document.form1.name.focus();
            return false;
        }
        if (document.form1.password.value == "") {
            alert("请输入密码");
            document.form1.password.focus();
            return false;
        }
        //document.form1.action=baseUrl + "index/login";
        document.form1.submit();
    }

    function OnMyKeyDown() {
        if ((event.which && event.which == 13) || (event.keyCode && event.keyCode == 13)) {
            userLogin();
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


</SCRIPT>
</body>
</html>