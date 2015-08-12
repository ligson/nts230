/**
 * Created by xuzhuo on 14-4-23.
 */
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if ('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
/**
 * 用户登陆
 */
$(document).ready(function () {
    var setCookie = $("#setCookie");
    setCookie.change(function () {
//        var loginName = loginName.val();
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
        $("#setCookie").prop("checked", true);
        $("#remFlg").val("1");
        $("#boful_username").val(loginName2);
        $("#boful_password").val(pwd2);
    }


    $("#checkLoginButton").bind("click", function () {
        var pwdInput = $("#boful_password");
        var username = $("#boful_username").val();
        var password = pwdInput.val();
        if (username == "" || password == "") {
            $("#errorMessage").html("请输入用户名，密码！！");
            //光标定位到密码框
            pwdInput.focus();
            pwdInput.select();
        } else {
            $.post(baseUrl + "index/checkLogin", {
                loginName: username,
                password: password,
                remFlg: $("#remFlg").val()
            }, function (data) {
                if (data.success) {
//                    // 关闭登录Dialog
//                    $(".modal_close").click();
//                    // 清空登录信息
//                    $("#boful_username").val("");
//                    $("#boful_password").val("");
//                    // 隐藏登录link
//                    $(".boful_logon_in_box").hide();
//                    // 显示登录用户的信息
//                    var loginedBox = $(".ou_logined_box");
//                    loginedBox.find("img").attr("title", data.name);
//                    $("#user_sub_1").attr("href", "/my/userSpace/" + data.key);
//                    $("#userPhoto").attr("src", "/upload/photo/" + data.photo);
//                    loginedBox.show();
                    window.location.reload();
                } else {
                    $("#errorMessage").html(data.msg);
                    pwdInput.focus();
                    pwdInput.select();
                }
            });
        }
    });

    if($(".ou_logined_box").is(":hidden")) {
        // 获取session值
        $.post(baseUrl + "index/validateLogin", function (data) {
            if (data.success) {
                $(".boful_logon_in_box").hide();
                var loginedBox = $(".ou_logined_box");
                loginedBox.find("img").attr("title", data.name);
                $("#user_sub_1").attr("href", "/my/userSpace/" + data.id);
                $("#userPhoto").attr("src", "/upload/photo/" + data.photo);
                loginedBox.show();
            }
        });
    }
});