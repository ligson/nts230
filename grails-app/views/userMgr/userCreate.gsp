<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    %{--<link href="${resource(dir: 'css', file: 'zhigaiban.css')}" rel="stylesheet" type="text/css">--}%
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <title>创建用户</title>
    <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
        function check() {

            var checkBoxs = document.getElementsByName("jobs");
            var userJob = 0;
            var jobName = 0
            //--选择用户身份
            for (var i = 0; i < checkBoxs.length; i++) {
                if (checkBoxs[i].checked) {
                    userJob = userJob | checkBoxs[i].value;
                }
            }
            createForm.userJob.value = userJob;
            //--选择用户职称
            checkBoxs = document.getElementsByName("zc");
            for (var i = 0; i < checkBoxs.length; i++) {
                if (checkBoxs[i].checked) {
                    jobName = jobName | checkBoxs[i].value;
                }
            }
            createForm.jobName.value = jobName;

            //---验证用户帐号
            if (createForm.name.value == "") {
                alert("用户帐号不能为空");
                createForm.name.focus();
                return false;
            }
            if (createForm.nickname.value == "") {
                alert("用户昵称不能为空");
                createForm.nickname.focus();
                return false;
            }
            if (createForm.name.value.length < 4 || createForm.name.value.length > 20) {
                alert("用户帐号应在4~20个字符之间");
                createForm.name.focus();
                return false;
            }
            //---验证用户昵称
            if (createForm.nickname.value != "") {
                if (createForm.nickname.value.length < 2 || createForm.nickname.value.length > 20) {
                    alert("用户用户昵称应该在2~20之间");
                    return false;
                }
            }
            //---验证用户真实姓名
            if (!checkLength(createForm.trueName, 20)) {
                alert("真实姓名长度应在20个字符以内");
                createForm.trueName.focus();
                return false;
            }
            //---验证用户邮件
            if (!checkLength(createForm.email, 100)) {
                alert("邮件长度应在100个字符以内");
                createForm.email.focus();
                return false;
            }
            //---验证用户密码
            if (createForm.password.value == "") {
                alert("用户密码不能为空");
                createForm.password.focus();
                return false;
            }
            else if (createForm.password.value != "") {
                if (createForm.password.value.length < 6 || createForm.password.value.length > 20) {
                    alert("密码长度应该在6~20之间");
                    return false;
                }
                else if (createForm.password.value != createForm.chkPassword.value) {
                    alert("密码不一致，请检查！");
                    return false;
                }
            }

            //---验证电话号码长度
            if (!checkLength(createForm.telephone, 20)) {
                alert("电话号码长度应在20个字符以内");
                createForm.telephone.focus();
                return false;
            }
            //---验证身份证长度
            if (!checkLength(createForm.idCard, 18)) {
                alert("身份证号长度应在18个字符以内");
                createForm.idCard.focus();
                return false;
            }

            //---验证专业长度
            if (!checkLength(createForm.profession, 50)) {
                alert("专业长度应在50个字符以内");
                createForm.profession.focus();
                return false;
            }
            //---验证描述信息长度
            if (!checkLength(createForm.descriptions, 100)) {
                alert("专业长度应在100个字符以内");
                createForm.descriptions.focus();
                return false;
            }
            createForm.submit();
        }
        function backList() {
            createForm.action = "userList";
            createForm.submit();
        }
        //---2009-8-19用来验证输入字串长度是否超长，被截断。
        function checkLength(obj, maxSize) {
            var n = 0;					//定义变量n，初始值为0
            var str = obj.value;
            for (i = 0; i < str.length; i++)		//应用for循环语句，获取表单提交用户名字符串的长度
            {
                var leg = str.charCodeAt(i);     //获取字符的ASCII码值
                if (leg > 255)				//判断如果长度大于255
                {
                    n += 2;				//则表示是汉字为两个字节
                }
                else {
                    n += 1;				//否则表示是英文字符，为一个字节
                }
            }

            if (n > maxSize) {
                //判断用户名的总长度如果超过指定长度，则返回true
                return false;
            }
            else {
                return true;       //如果用户名的总长度不超过指定长度，则返回false
            }
        }
        $(function () {
            $("#dateValid").datepicker();

            // 根据选择角色设置默认空间大小
            $("input[name='role']").click(function(){
                // 资源管理员1000G
                if($(this).val() == "1") {
                    $("#spaceSize").val("1000");
                    $("#spaceSizeUnit").val("3");

                    // 高级用户50G
                } else if($(this).val() == "2") {
                    $("#spaceSize").val("50");
                    $("#spaceSizeUnit").val("3");
                } else {
                    // 普通用户2G
                    $("#spaceSize").val("2");
                    $("#spaceSizeUnit").val("3");
                }
            });

            // 根据初始角色设置默认空间大小
            var initRole = $("input[name='role']:checked").val();
            // 资源管理员1000G
            if(initRole == "1") {
                $("#spaceSize").val("1000");
                $("#spaceSizeUnit").val("3");

                // 高级用户50G
            } else if(initRole == "2") {
                $("#spaceSize").val("50");
                $("#spaceSizeUnit").val("3");
            } else {
                // 普通用户2G
                $("#spaceSize").val("2");
                $("#spaceSizeUnit").val("3");
            }
        });
    </SCRIPT>
</head>

<body style="background:#fff;">

<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>
<g:hasErrors bean="${consumer}">
    <div class="errors">
        <g:renderErrors bean="${consumer}" as="list"/>
    </div>
</g:hasErrors>
<g:form name="createForm" action="userSave" method="post">
<input type="hidden" name="max" value="${params.max}"/>
<input type="hidden" name="offset" value="${params.offset}"/>
<input type="hidden" name="sort" value="${params.sort}"/>
<input type="hidden" name="order" value="${params.order}"/>
<input type="hidden" name="userRole" value="${params.userRole}"/>
<input type="hidden" name="roleList" value="${params.roleList}"/>
<input type="hidden" name="userJob" value="0"/>
<input type="hidden" name="jobName" value="0"/>
<input type="hidden" name="profession" value=""/>
<input type="hidden" name="Jobs" value="0">
<input type="hidden" name="zc" value="0">

<DIV>

    <table width="100%">
        <tbody>
        <tr>
            <td style="font-size: 18px; color: #333; padding: 10px 0;">注：带<FONT color=red>*</FONT>号为必填内容。</td>
        </tr>
        <tr>
            <td>
                <table class="table">
                    <tbody>
                    <tr>
                        <td width="120" align="right">用户帐号<FONT color=red>*</FONT></td>
                        <td>
                            <label>
                                <input class="form-control" type="text" id="name" name="name" style="width: 200px"
                                       value="${fieldValue(bean: consumer, field: 'name')}"/>
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">用户昵称<FONT color=red>*</FONT></td>
                        <td><label>
                            <input class="form-control" type="text" id="nickname" name="nickname" style="width: 200px"
                                   value="${fieldValue(bean: consumer, field: 'nickname')}"/></label></td>
                    </tr>
                    <tr>
                        <td align="right">真实姓名</td>
                        <td><label>
                            <input class="form-control" type="text" id="trueName" name="trueName" style="width: 200px"
                                   value="${fieldValue(bean: consumer, field: 'trueName')}"/></label></td>
                    </tr>
                    <tr>
                        <td align="right">电子邮件</td>
                        <td><label><input class="form-control" type="text" id="email" name="email" style="width: 200px"
                                          value="${fieldValue(bean: consumer, field: 'email')}"/></label>
                        </td>
                    </tr>

                    <tr>
                        <td align="right">用户密码</td>
                        <td>
                            <label><input class="form-control" type="password" id="password" name="password"
                                          style="width: 200px"
                                          value=""/></label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">核对密码</td>
                        <td>
                            <label><input class="form-control" type="password" id="chkPassword" name="chkPassword"
                                          style="width: 200px"
                                          value=""/></label></td>
                    </tr>
                    <tr>
                        <td align="right">性&nbsp;&nbsp;&nbsp;&nbsp;别</td>
                        <td>
                            <g:radio name="gender" value="1" checked="true"/> 男
                            <g:radio name="gender" value="0"/> 女
                        </td>
                    </tr>
                    <tr>
                        <td align="right">角&nbsp;&nbsp;&nbsp;&nbsp;色</td>
                        <td>
                            <g:if test="${params.userRole == 'user'}">
                                <g:radio name="role" value="1"/> 资源管理员
                                <g:radio name="role" value="2"/> 高级用户
                                <g:radio name="role" value="3" checked="true"/> 普通用户
                            </g:if>
                            <g:else>
                                <g:radio name="role" value="1" checked="true"/> 资源管理员
                                <g:radio name="role" value="2"/> 高级用户
                                <g:radio name="role" value="3"/> 普通用户
                            </g:else>

                        </td>
                    </tr>

                    <tr>
                        <td align="right">联系电话</td>
                        <td>
                            <label>
                                <input class="form-control" type="text" id="telephone" name="telephone"
                                       style="width: 200px"
                                       value="${fieldValue(bean: consumer, field: 'telephone')}"/>
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">身份证号</td>
                        <td><label>
                            <input class="form-control" type="text" id="idCard" name="idCard" style="width: 200px"
                                   value="${fieldValue(bean: consumer, field: 'idCard')}"/>
                        </label>
                        </td>
                    </tr>

                    <tr>
                        <td align="right">有效时间</td>
                        <td>
                            <label>
                                <input class="form-control" name="dateValid" id="dateValid" readonly="" type="text"
                                       style="width: 200px"
                                       value="">
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;历</td>
                        <td><label></label>
                            <label><input type="radio" name="userEducation" value="0"></label> 专科
                            <label><input type="radio" name="userEducation" value="1" checked></label>本科
                            <label><input type="radio" name="userEducation" value="2"></label> 硕士
                            <label><input type="radio" name="userEducation" value="3"></label>博士
                            <label><input type="radio" name="userEducation" value="4"></label>博士后
                            <label><input type="radio" name="userEducation" value="5"></label> 其他
                        </td>
                    </tr>

                    <tr>
                        <td align="right">所属部门</td>
                        <td><label>
                            <select class="form-control" name="college" style="width: 200px" id="groupList">
                                <g:each in="${collegeList}" var="college">
                                    <option value="${college.id}">${college.name}</option>
                                </g:each>
                            </select>
                        </label>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </td>
        </tr>
        </tbody>
    </table>
</DIV>

<div style="font-size: 18px; color: #333; margin: 10px 0;">权限控制<span style="color: red">*</span></div>
<table width="100%">
    <tbody>
    <tr>
        <td>
            <table class="table" width="100%">
                <tr>
                    <td width="120" align="right">上传设置：</td>
                    <td>
                        <g:if test="${params.userRole == 'user'}">
                            <g:radio name="uploadState" value="0"
                                     checked="true"/> 禁止
                            <g:radio name="uploadState" value="2"/> 申请
                            <g:radio name="uploadState" value="1"/> 允许
                        </g:if>
                        <g:else>
                            <g:radio name="uploadState" value="0"/> 禁止
                            <g:radio name="uploadState" value="2"/> 申请
                            <g:radio name="uploadState" value="1"
                                     checked="true"/> 允许
                        </g:else>
                    </td>
                </tr>
                <tr>
                    <td align="right">下载设置：</td>
                    <td>
                        <g:radio name="canDownload" value="0"/> 禁止下载
                        <g:radio name="canDownload" value="1" checked="true"/> 允许下载
                    </td>
                </tr>
                <tr>
                    <td align="right">评论设置：</td>
                    <td>
                        <g:radio name="canComment" value="0"/> 禁止评论
                        <g:radio name="canComment" value="1" checked="true"/> 允许评论
                    </td>
                </tr>
                <tr>
                    <td align="right">用户状态：</td>
                    <td>
                        <g:radio name="userState" value="0"/> 当前禁用
                        <g:radio name="userState" value="1" checked="true"/> 当前启用
                    </td>
                </tr>
                <tr>
                    <td align="right">审核状态：</td>
                    <td>
                        <g:if test="${params.userRole == 'user'}">
                            <g:radio name="notExamine" value="0" checked="true"/> 审核
                            <g:radio name="notExamine" value="1"/> 免核
                        </g:if>
                        <g:else>
                            <g:radio name="notExamine" value="0"/> 审核
                            <g:radio name="notExamine" value="1" checked="true"/> 免核
                        </g:else>
                    </td>
                </tr>
                <tr>
                    <td align="right">空间大小：</td>
                    <td>
                        <table>
                            <tr>
                                <td><input class="form-control" rows="3" type="text" id="spaceSize" name="spaceSize"
                                           style="width: 100px" maxlength="4"
                                           value="${fieldValue(bean: consumer, field: 'spaceSize')}"/>
                                </td>
                                <td><g:select name="spaceSizeUnit" id="spaceSizeUnit" class="form-control" style="width:80px"
                                              from="${[1: 'KB', 2: 'MB', 3: 'GB']}"
                                              optionKey="key" optionValue="value"/></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right">描述信息：</td>
                    <td>
                        <label>
                            <input class="form-control" rows="3" type="text" id="descriptions" name="descriptions"
                                   style="width: 400px"
                                   value="${fieldValue(bean: consumer, field: 'descriptions')}"/>

                        </label>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <div>
                            <span><input class=" btn btn-primary" type="button" value="保存"
                                         onClick="check()"/></span>&nbsp;
                            <span><input class=" btn btn-primary" type="button" value="返回"
                                         onClick="backList()"/></span>
                            <!--<span class="button"><input class="button_input"   type="button" value="测试" onClick="setdate()" /></span>-->
                        </div>
                    </td>
                </tr>
            </table>
        </td>
    </TR>

    </TBODY>
</TABLE>

</g:form>

</body>
</html>

