<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-12
  Time: 下午5:03
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>后台登录</title>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_login.css')}"
          media="all">
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'string.js')}"></script>
    <script type="text/javascript">
        function resizeCenter() {
            var entirety = $(".entirety");
            var box = $(".entirety_bg");
            var top = (entirety.height() - box.height()) / 2;
            var left = (entirety.width() - box.width()) / 2;
            box.css("marginTop", top);
            box.css("marginLeft", left);
        }
        $(function () {
            resizeCenter();
            $(window).resize(function () {
                resizeCenter();
            });

            $("#remAdminLoginName").change(function () {
                var adminLoginName = $("#adminLoginName").val();
                var remFlg = $("#remFlg").val();
                if(remFlg == "0") {
                    $("#remFlg").val("1");
                } else if(remFlg == "1") {
                    $("#remFlg").val("0");
                }
                //$.cookie("adminLoginName", adminLoginName, {expires: 30});
            })
            var adminLoginName = $.cookie("adminLoginName");
            if (adminLoginName != null) {
                $("#remAdminLoginName").attr("checked", "checked");
                $("#remFlg").val("1");
                $("#adminLoginName").val(adminLoginName);
            }
            $("#adminLoginForm").submit(function () {
                var adminLoginName = $("#adminLoginName");
                var adminPassword = $("#adminPassword");
                var loginError = $(".login_error");
                if (adminLoginName.val().toString().trim().isEmpty()) {
                    loginError.empty();
                    loginError.append("用户名不能为空！");
                    adminLoginName.focus();
                    return false;
                }

                if (adminPassword.val().toString().trim().isEmpty()) {
                    loginError.empty();
                    loginError.append("密码不能为空！");
                    adminPassword.focus();
                    return false;
                }

                return true;
            });
        });
    </script>
</head>

<body>
%{--用来标示后台登陆--}%
<input type="hidden" value="后台_登陆页面"/>

<div class="entirety">
    <div class="entirety_bg">
        <div class="login_box">
            <div class="login_top">
                <div class="login_headr">
                    <img class="company_logo"
                         src="${resource(dir: 'skin/blue/pc/admin/images', file: 'boful_logo.png')}"
                         alt=""/>
                    <img class="system_name" src="${resource(dir: 'skin/blue/pc/admin/images', file: 'login_logo.png')}"
                         alt=""/>
                </div>

                <div class="login_content">
                    <div class="login_con_left"></div>

                    <div class="login_con_left1">
                        <img src="${resource(dir: 'skin/blue/pc/admin/images', file: 'login_con_img.png')}" alt=""/>
                    </div>
                    <g:form controller="admin" action="adminLogin" name="adminLoginForm">
                        <div class="login_con_input">
                            <div class="login_error">${errorMsg}</div>
                            <label class="use_name1" for="adminLoginName">
                               用户名：
                            </label>
                            <input class="use_name2" type="text" value="${params.adminLoginName}" id="adminLoginName" name="adminLoginName">
                            <label class="password1" for="adminPassword">
                                密&nbsp;&nbsp;码：
                            </label>
                            <input class="password2" type="password" value="${params.adminPassword}" id="adminPassword"
                                   name="adminPassword">
                            <input class="rem_ps1" type="checkbox" value="" id="remAdminLoginName">
                            <input type="hidden" value="0" id="remFlg" name="remFlg"/>
                            <label class="rem_ps" for="remAdminLoginName">
                                记住用户名
                            </label>

                            <input class="logoin_exit" type="reset" value="重&nbsp;置">
                            <input class="login_access" type="submit" value="登&nbsp;录">
                        </div>
                    </g:form>

                    <div class="login_con_right"></div>
                </div>
            </div>

            <div class="login_show"></div>
        </div>
    </div>
</div>
</body>
</html>