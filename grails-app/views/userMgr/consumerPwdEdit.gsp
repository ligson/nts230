<%@ page import="nts.user.domain.Consumer" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">

    <style type="text/css">
<!--
.STYLE1 {
    color: #8B0D11;
    font-weight: bold;
    font-size: 12px;
}

.STYLE2 {
    color: #990000;
    font-weight: bold;
}

.STYLE3 {
    color: #CC0000
}

.zi-cu {
    font-size: 16px;
    padding-left: 20px;
}

-->
</style>
<title>编辑用户</title>
<script Language="JavaScript">

    function update() {
        //---验证用户密码
        if ($('#newPassword1').val().trim() != "") {
            if ($('#newPassword1').val().length < 6 || $('#newPassword1').val().length > 20) {
                alert("密码长度应该在6~20之间");
                return false;
            }
            else if ($('#newPassword1').val() != $('#newPassword2').val()) {
                alert("密码不一致，请检查！");
                return false;
            }
        }
        else{
            alert("密码不能是空值");
            return false;
        }

        var action = "${createLink(action:'consumerPwdUpdate')}";
        consumerEditForm.action = action;
        consumerEditForm.submit()
    }

    function backList() {
        var action = "${createLink(action:'userList')}";
        consumerEditForm.action = action;
        consumerEditForm.submit();
    }
</script>

</head>

<body style="background:#fff;">
<div>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <form method="post" name="consumerEditForm" id="consumerEditForm">
        <input type="hidden" name="id" value="${consumerInstance?.id}"/>
        <input type="hidden" name="oldPwd" value="${consumerInstance?.password}"/>

        <div id="addTable">
            <table width="95%" border="0" cellspacing="0">
                <tr>
                    <td align="left"><font><span class="zi-cu zi-cu1">重置密码</span></font></td>
                </tr>
            </table>

            <table border="0" cellspacing="0" cellpadding="0" class="table">
                <tr>
                    <td width="90" align="center">新密码</td>
                    <td><input name="newPassword" id="newPassword1" maxlength="20" type="password" size="52"
                               class="form-control"
                               style="width: 200px" value=""/></td>
                </tr>
                <tr>
                    <td width="90" align="center">确认密码</td>
                    <td><input name="conformPassword" id="newPassword2" maxlength="20" type="password" size="52"
                               class="form-control" style="width: 200px"
                               value=""/></td>
                </tr>
                <tr>
                    <td></td>
                    <td valign="bottom">
                        <label>
                            <input name="update_enter" type="button" class="btn btn-primary" onClick="update()"
                                   value="确定"/>
                        </label>
                    </td>
                </tr>
            </table>

        </div>

    </form>
</div>
</body>
</html>
