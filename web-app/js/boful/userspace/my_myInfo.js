/**
 * Created by ligson on 13-12-22.
 */
$(function () {
    var tabs = $(".my_info_tab");
    tabs.click(function () {
        var index = $(tabs).index($(this));
        var infoContents = $(".my_info_content");
        for (var i = 0; i < infoContents.length; i++) {
            if (i == index) {
                $(infoContents[i]).slideDown();
            } else {
                $(infoContents[i]).slideUp();
            }
        }

    });
    $("#password_btn").click(function(){
        var newPassword=$("#newPassword").val();
        var chkPassword=$("#chkPassword").val();
        var oldPassWord = $("#oldPassWord").val();
        if (newPassword == "" || oldPassWord == "") {
            alert("密码不能为空！");
            return false;
        }
        if(chkPassword==""||newPassword!=chkPassword){
            alert("两次密码不一致");
            return false;
        }
        $.post("verifyPassword", {
            oldPassWord: oldPassWord
        }, function (data) {
            if (!data.success) {
                alert("原密码输入错误！！！");
            } else {
                $("#modifyPassWord").submit();
            }
        })
    })
});


function userInfoSubmit() {
    var nickname = $("#nicknameId").val();
    var email = $("#emailId").val();
    var address = $("#addressId").val();
    var descriptions = $("#descriptionsId").val();
    if (nickname.length < 2 || nickname.length > 50) {
        alert("昵称长度应该在2～50个长度以内!!!");
        email.focus();
        return false;
    }
    if (!checkEmail(email)) {
        alert("邮箱格式不对!!");
        return false;
    }
    if (address.length > 200) {
        alert("居住地长度在200以内!!");
        return false;
    }
    if (descriptions.length > 200) {
        alert("个人介绍长度在200以内!!");
        return false;
    }
    $("#modifyInfoForm").submit();
}