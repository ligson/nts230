<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title><g:message code="application.name" default="确然多媒体资源应用系统"/></title>
%{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/default/pc/css', file: 'regedit.css')}"/>--}%
%{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/default/pc/css/skin', file: 'list_style.css')}"/>--}%
%{--<link rel="stylesheet" type="text/css"--}%
%{--href="${resource(dir: 'skin/blue/pc/css', file: 'boful_user_register.css')}"/>--}%
%{--<script language="JavaScript" src="${resource(dir: 'js/qinghua', file: 'fenlei.js')}"></script>--}%
<r:require modules="jquery-ui"/>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
<SCRIPT type="text/javascript">
    <!--
    function check() {

        if (Jtrim(document.form1.name.value) == "") {
            alert("请在用户名输入框中输入值。");
            document.form1.name.focus();
            return false;
        }

        if (Jtrim(document.form1.name.value).length < 2) {
            alert("用户名的长度必须大于1");
            document.form1.name.focus();
            return false;
        }

        var reg = /^s*[A-Za-z0-9]{2,50}s*$/;
        if(!reg.test(Jtrim(document.form1.name.value))) {
            alert("用户名只允许输入字母数字,且长度不超过50");
            document.form1.name.focus();
            return false;
        }

        if(document.form1.name.value.indexOf(" ")!=-1){
            alert("用户名有空格！");
            return false;
        }

        if (Jtrim(document.form1.nickname.value) == "") {
            alert("请在昵称输入框中输入值。");
            document.form1.nickname.focus();
            return false;
        }

        if (Jtrim(document.form1.password.value) == "") {
            alert("请在密码输入框中输入值。");
            document.form1.password.focus();
            return false;
        }

        if (Jtrim(document.form1.password.value).length < 6) {
            alert("密码太弱，请至少输入6位。");
            document.form1.password.focus();
            return false;
        }

        if (Jtrim(document.form1.password.value) != Jtrim(document.form1.chkPassword.value)) {
            alert("两次密码输入不一致，请重新输入。");
            document.form1.password.focus();
            return false;
        }

        if (document.form1.email.value.length > 0 && !document.form1.email.value.match(/^.+@.+$/)) {
            alert("电子邮件错误，请重新输入。");
            document.form1.email.focus();
            return false;
        }

        //处理复选框
        var userJob = 0;
        var jobName = 0
        var checkBoxs = document.getElementsByName("jobs");

        //--选择用户身份
        for (var i = 0; i < checkBoxs.length; i++) {
            if (checkBoxs[i].checked) {
                userJob = userJob | checkBoxs[i].value;
            }
        }
        document.form1.userJob.value = userJob;

        //--选择用户职称
        checkBoxs = document.getElementsByName("zc");
        for (var i = 0; i < checkBoxs.length; i++) {
            if (checkBoxs[i].checked) {
                jobName = jobName | checkBoxs[i].value;
            }
        }
        document.form1.jobName.value = jobName;

        document.form1.submit();
        //return true;
    }


    /*function submitForm()
     {
     var name =document.getElementById("name").value;
     alert(name)
     var url = "${createLink(action: 'checkUserName',controller: 'index')}";
     var pars = 'name=' + name;

     $.post(url,
     {name:name},
     function (data) {
     if(data.result == "OK")
     {
     alert(data)
     check();
     }
     else
     {
     alert("用户名已存在，请重新输入。");
     document.form1.name.focus();
     }
     }
     );
     }*/
    function submitForm() {
        var name = $('#name').val();
        var url = 'checkUserName';
        var pars = 'name=' + name;
        try {
            var myAjax = new Ajax.Request(
                    url,
                    {
                        method: 'get',
                        parameters: pars,
                        onComplete: startSubmit
                    });
        } catch (e) {
            $.ajax({
                url: url,
                data: pars,
                success: function (data) {
                    if (data == "exist") {
                        alert("用户名已存在，请重新输入。");
                        //document.form1.name.focus();
                    }
                    if (data == "OK") {
                        check();
                    }
                }
            })
        }

    }


    function startSubmit(originalRequest) {
        var text = originalRequest.responseText;

        if (text.indexOf("OK") == 0) {
            check();
        }
        else {
            alert("用户名已存在，请重新输入。");
            document.form1.name.focus();
        }
    }


    function showhide_obj(obj, icon) {
        obj = $("#" + obj);
        icon = $("#" + icon);
        if (obj.style.display == "none") {
            //指定文档中的对象为div,仅适用于IE;
            div_list = $("div");
            for (i = 0; i < div_list.length; i++) {
                thisDiv = div_list[i];
                if (thisDiv.id.indexOf("title") != -1)//当文档div中的id含有list时,与charAt类似;
                {
                    //循环把所有菜单链接都隐藏起来
                    thisDiv.style.display = "none";
                    icon.innerHTML = "+";
                }
            }

            myfont = $("font");
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

    //-->
</SCRIPT>
<Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
      rel=stylesheet>
<style type="text/css">
.wysty_line {
    line-height: 30px;
}

.zy_style {
    line-height: 30px;;
}

.zy_style span {
    line-height: 30px;
    margin-bottom: 8px;
    margin-right: 5px;;
}

.table > thead > tr > th, .table > tbody > tr > th, .table > tfoot > tr > th, .table > thead > tr > td, .table > tbody > tr > td, .table > tfoot > tr > td {

    border-top: 0px solid #DDD;
}
</style>
</head>

<body>
<style type="text/css">
.form-control {
    width: 100%;;
    *width: 94%;
    _ width: 94%;

}
</style>

<div style="width: 560px; margin: 0 auto; min-height: 747px">
<g:form name="form1" action="saveRegister">

<table class="table" style="border: none;">
    <tr>
        <td colspan="2">
            ${flash.message}
            <g:each in="${consumer?.errors?.fieldErrors}" var="fieldError">
                <p>${message(code: fieldError.defaultMessage, args: fieldError.arguments)}</p>
            </g:each>
        </td>

    </tr>
    <tr>
        <td colspan="2" align="left" valign="middle" style="font-size: 14px; border: none;"><span>新用户注册</span></td>
    </tr>

    <tr>
        <td width="80" align="right" valign="middle" style="line-height: 30px; *width:85px;"><span
                style="color:red;">*</span>用户名：
        </td>
        <td align="left" style="width:475px;"><INPUT class="form-control" type="text" tabIndex="1" id="name" name="name"
                                                     maxlength="20"
                                                     value="${consumer?.name}"></td>
    </tr>
    <tr>
        <td width="80" align="right" valign="middle"><span style="color:red;">*</span><span
                class="wysty_line">昵称：</span></td>
        <td align="left"><INPUT class="form-control" type="text" tabIndex="1" id="nickname" name="nickname"
                                maxlength="20"
                                value="${consumer?.nickname}"></td>
    </tr>
    <tr>
        <td width="85" align="right" valign="middle"><span style="color:red;">*</span><span
                class="wysty_line">设置密码：</span></td>
        <td align="left"><INPUT class="form-control" tabIndex="2" type="password" id="password" name="password"
                                maxlength="20"></td>
    </tr>
    <tr>
        <td width="85" align="right" valign="middle"><span style="color:red;">*</span><span
                class="wysty_line">确认密码：</span></td>
        <td align="left"><INPUT class="form-control" tabIndex="3" type="password" id="chkPassword" name="chkPassword"
                                maxlength="20"></td>
    </tr>
    <tr>
        <td colspan="2" valign="middle"><button class="btn btn-info" id="message_show"
                                                style="margin-left: 25%; *margin-left: 40%; _margin-left: 23%; width: 350px;"
                                                type="button">填写更多详细信息 >>(也可以在后台个人空间中补充)</button></td>
    </tr>

</table>

%{--<div id="contentA" class="area areabg1">--}%


<script type="text/javascript">
    //<![CDATA[
    /*window.onload = function () {
     rolinTab("rolin")
     };*/
    function rolinTab(obj) {
        var list = $("#" + obj + " LI");
        var state = {show: false, hidden: false, showObj: false};
        for (var i = 0; i < list.length; i++) {
            var tmp = new rolinItem(list[i], state);
            if (i == 0) {
                try {
                    tmp.phidden();
                } catch (err) {
                }
            }
        }
    }
    function rolinItem(obj, state) {
        var speed = 0.0666;
        var range = 1;
        var interval;
        var tarH;
        var tar = this;
        var head = getFirstChild(obj);
        var q76content = getNextChild(head);
        var isOpen = false;
        this.pHidden = function () {
            if (isOpen) hidden();
        }
        this.pShow = show;
        var baseH = q76content.offsetHeight;
        q76content.style.display = "none";
        var isOpen = false;
        head.onmouseover = function () {
            this.style.background = "#EFEFEF";
        }
        head.onmouseout = mouseout;
        head.onclick = function () {
            this.style.background = "#EFEFEF";
            if (!state.show && !state.hidden) {
                if (!isOpen) {
                    head.onmouseout = null;
                    show();
                } else {
                    hidden();
                }
            }
        }
        function mouseout() {
            this.style.background = "#FFF"
        }

        function show() {
            head.style.borderBottom = "none";
            state.show = true;
            if (state.openObj && state.openObj != tar) {
                state.openObj.pHidden();
            }
            q76content.style.height = "0px";
            q76content.style.display = "block";
            q76content.style.overflow = "hidden";
            state.openObj = tar;
            tarH = baseH;
            interval = setInterval(move, 10);
        }

        function showS() {
            isOpen = true;
            state.show = false;
        }

        function hidden() {
            state.hidden = true;
            tarH = 0;
            interval = setInterval(move, 10);
        }

        function hiddenS() {
            head.style.borderBottom = "none";
            head.onmouseout = mouseout;
            head.onmouseout();
            q76content.style.display = "none";
            isOpen = false;
            state.hidden = false;
        }

        function move() {
            var dist = (tarH - q76content.style.height.pxToNum()) * speed;
            if (Math.abs(dist) < 1) dist = dist > 0 ? 1 : -1;
            q76content.style.height = (q76content.style.height.pxToNum() + dist) + "px";
            if (Math.abs(q76content.style.height.pxToNum() - tarH) <= range) {
                clearInterval(interval);
                q76content.style.height = tarH + "px";
                if (tarH != 0) {
                    showS()
                } else {
                    hiddenS();
                }
            }
        }
    }
    //var $ = function($) {return document.getElementById($)};
    String.prototype.pxToNum = function () {
        return Number(this.replace("px", ""))
    }
    function getFirstChild(obj) {
        var result = obj.firstChild;
        while (!result.tagName) {
            result = result.nextSibling;
        }
        return result;
    }
    function getNextChild(obj) {
        var result = obj.nextSibling;
        while (!result.tagName) {
            result = result.nextSibling;
        }
        return result;
    }
    $(function () {
        $("#dateEnterSchool").datepicker();
        $("#message_hide").css("display", "none");

        $("#message_show").click(function () {
            if ($("#message_hide").css("display") == "none")
                $("#message_hide").css("display", "block");
            else
                $("#message_hide").css("display", "none");
        })
    });
    //]]>
</script>

<div id="message_hide">
    <table class="table">
        <tr>
            <td colspan="2" valign="middle">基本信息</td>
        </tr>
        <tr>
            <td width="80" align="right" valign="middle"><span class="wysty_line">真实姓名：</span></td>
            <td align="left"><INPUT class="form-control" type="text" tabIndex="5" id="trueName" name="trueName"
                                    maxlength="20"
                                    value="${consumer?.trueName}"></td>
        </tr>
        <tr>
            <td width="80" align="right" valign="middle"><span class="wysty_line">电子邮件：</span></td>
            <td align="left"><INPUT class="form-control" type="text" tabIndex="5" id="email" name="email" maxlength="50"
                                    value="${consumer?.email}"></td>
        </tr>
        <tr>
            <td width="80" align="right" valign="middle"><span class="wysty_line">联系电话：</span></td>
            <td align="left"><INPUT class="form-control" type="text" tabIndex="5" id="telephone" name="telephone"
                                    maxlength="20"
                                    value="${consumer?.telephone}"></td>
        </tr>
        <tr>
            <td width="80" align="right" valign="middle"><span class="wysty_line">身份证号：</span></td>
            <td align="left"><INPUT class="form-control" type="text" tabIndex="5" id="idCard" name="idCard"
                                    maxlength="18"
                                    value="${consumer?.idCard}"></td>
        </tr>
        <tr>
            <td colspan="2" valign="middle">学校信息</td>
        </tr>
        <tr>
            <td width="80" align="right" valign="middle"><span class="wysty_line">入学时间：</span></td>
            <td align="left"><INPUT class="form-control" style="width: 120px;" type="text" tabIndex="5" readonly
                                    id="dateEnterSchool"
                                    name="dateEnterSchool"
                                    maxlength="20"></td>
        </tr>
        <tr>
            <td width="80" align="right" valign="middle"><span class="wysty_line">所属院系：</span></td>
            <td align="left"><SELECT tabIndex="21" name="college" style="width: 200px; line-height: 40px;height: 30px"
                                     id="college" rel="select">
                <g:each in="${collegeList}" var="college">
                    <option value="${college.id}">${college.name}</option>
                </g:each>
            </SELECT></td>
        </tr>
        <tr width="80" align="right">
            <td width="80" align="right" valign="middle"><span class="wysty_line">主要专业：</span></td>
            <td align="left"><INPUT class="form-control" size="16" type="text" tabIndex="5" id="profession"
                                    name="profession"
                                    maxlength="20"
                                    value="${consumer?.profession}"></td>
        </tr>
        <tr>
            <td width="80" align="right" valign="middle"><span class="wysty_line">简要说明：</span></td>
            <td align="left"><INPUT class="form-control" rows="3" type="text" tabIndex="5" id="descriptions"
                                    name="descriptions"
                                    maxlength="100"
                                    value="${consumer?.descriptions}"></td>
        </tr>
        <tr>
            <td width="80" align="right" valign="middle"><span class="wysty_line">性别：</span></td>
            <td align="left"><input type="radio" name="gender" value="1" checked="checked">
                <span>男</span>
                <input type="radio" name="gender" value="0">
                <span>女</span></td>
        </tr>
        <tr>
            <td width="80" align="right" valign="middle"><span class="wysty_line">角色：</span></td>
            <td align="left"><input type="radio" name="role" value="2">
                <span>老师</span>
                <input type="radio" name="role" value="3" checked="checked">
                <span>学生</span></td>
        </tr>
        <tr>
            <td width="80" align="right" valign="middle"><span class="wysty_line">学历：</span></td>
            <td align="left"><input type="radio" name="userEducation" value="0">
                <span>专科</span>
                <input type="radio" name="userEducation" value="1" checked>
                <span>本科</span>
                <input type="radio" name="userEducation" value="2">
                <span>硕士</span>
                <input type="radio" name="userEducation" value="3">
                <span>博士</span>
                <input type="radio" name="userEducation" value="4">
                <span>博士后</span>
                <input type="radio" name="userEducation" value="5">
                <span>其他</span></td>
        </tr>
        <tr>
            <td width="80" align="right" valign="middle"><span class="wysty_line">身份：</span></td>
            <td align="left"><INPUT tabIndex="13" type="checkbox" name="Jobs" value="1" runant="server">
                <span>老师</span>
                <INPUT tabIndex="13" type="checkbox" name="Jobs" value="2" runant="server">
                <span>科研人员</span>
                <INPUT tabIndex="13" type="checkbox" name="Jobs" value="4" runant="server">
                <span>行政管理人员</span>
                <INPUT tabIndex="13" type="checkbox" name="Jobs" value="8" runant="server">
                <span>教辅管理人员</span>
                <INPUT tabIndex="13" type="checkbox" name="Jobs" value="16" checked runant="server">
                <span>学生</span>
                <INPUT tabIndex="13" type="checkbox" name="Jobs" value="32" runant="server">
                <span>其他</span></td>
        </tr>
        <tr>
            <td width="80" align="right" valign="middle"><span class="wysty_line">职称：</span></td>
            <td align="left" class="zy_style"><INPUT tabIndex="13" type="checkbox" name="zc" value="1" runant="server">
                <span>助教</span>
                <INPUT tabIndex="13" type="checkbox" name="zc" value="2" runant="server">
                <span>讲师</span>
                <INPUT tabIndex="13" type="checkbox" name="zc" value="4" runant="server">
                <span>副教授</span>
                <INPUT tabIndex="13" type="checkbox" name="zc" value="8" runant="server">
                <span>教授</span>
                <INPUT tabIndex="13" type="checkbox" name="zc" value="16" runant="server">
                <span>硕士生导师</span>
                <INPUT tabIndex="13" type="checkbox" name="zc" value="32" runant="server">
                <span>博士生导师</span>
                <INPUT tabIndex="13" type="checkbox" name="zc" value="64" runant="server">
                <span>其他</span></td>
        </tr>
    </table>
</div>

    <div style="display: block; overflow: hidden"><table class="table" style="width:460px;float: right;">
    <tr>
        <td colspan="2"><div style="display:block; width:150px;*width:100px; height:30px;float: left;"></div><button
                onclick="submitForm();" class="btn btn-success" type="button">同意以下协议并提交</button></td>
    </tr>
    <tr>
        <td><textarea name="" class="form-control" rows="5">用户须知
        1.通过本注册向导，您能向本系统申请一个用户名。

        2.你申请的用户帐号必须由管理员审批登记以后才能使用本系统，也就是说，用户在此仅仅是做出申请，申请后的帐号只有等待管理员确认以后才能有效。

        3.用户必须如实地提供自己的注册信息，管理员将仅在本系统内使用您的注册信息，如涉及隐私，本系统不承担任何责任。

        4.用户进入本系统前，用有效帐号登录。用户应该对自己的帐号保密，如果因为用户原因导致帐号泄漏，由此而导致的帐号被非法盗用，本系统概不负责。

        5.如果不再使用本系统，用户应该直接向管理员申请注销帐号。
        </textarea></td>
    </tr>

</table>
    </div>
%{--<ul class="rolinList" id="rolin">--}%
%{--<li>--}%
%{--<dd style=" text-align:center;">--}%
%{--<button class="btn btn-primary" id="message_show" type="button">填写更多详细信息 >>(也可以在后台个人空间中补充)</button>--}%
%{--</dd>--}%

%{--<div class="q76content q76content1" >--}%
%{--<table class="q76content2">--}%

%{----}%
%{--</table>--}%
%{--</div>--}%
%{--</li></ul>--}%

%{--</dl>--}%


%{--</div>--}%
%{--</div>--}%
<input type="hidden" id="dateValid" name="dateValid" value="2030-12-31">
<input type="hidden" id="jobName" name="jobName" value="0">
<input type="hidden" id="userJob" name="userJob" value="0">
</g:form>
</div>
</body>
</html>
