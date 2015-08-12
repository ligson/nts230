<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午6:02
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>修改用户</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script Language="JavaScript">

        %{--function checkIdList(opt) {--}%
            %{--var action = "${createLink(action:'consumerLoadGroup')}";--}%
            %{--if (opt == 'load' || opt == 'unload') {--}%
                %{--if (hasChecked("groupIdList") == false) {--}%
                    %{--alert("请至少选择一个组！");--}%
                    %{--return false;--}%
                %{--}--}%
            %{--}--}%
            %{--consumerEditForm.inout.value = opt;--}%
            %{--consumerEditForm.action = action;--}%
            %{--consumerEditForm.submit()--}%
        %{--}--}%

        function showGroupList(opt) {
            document.getElementById('divGroupList').style.display = "";
            hideDirList();
            if (opt == 'load') {
                document.getElementById('_loadGroupload').style.display = "";
                document.getElementById('_loadAllGroupload').style.display = "";
                document.getElementById('_unLoadGroupload').style.display = "none";
            }
            if (opt == 'unload') {
                document.getElementById('_loadGroupload').style.display = "none";
                document.getElementById('_loadAllGroupload').style.display = "none";
                document.getElementById('_unLoadGroupload').style.display = "";
            }
        }
        function hideGroupList() {
            document.getElementById('divGroupList').style.display = "none";
        }


        function showDirectoryList(opt) {
            if(opt == 'in') {
                $("#outDirectory").hide() ;
                $("#inDirectory").show() ;
            }
            else if(opt == 'out') {
                $("#inDirectory").hide() ;
                $("#outDirectory").show() ;
            }
            $( "#divDirectoryList" ).dialog();

            //divDirectoryList.style.visibility = 'visible';
//	img1.style.visibility='visible';
            /* if (opt == 'in') {
             document.getElementById('inDirectory').style.display = "";
             document.getElementById('outDirectory').style.display = "none";
             }
             if (opt == 'out') {
             document.getElementById('inDirectory').style.display = "none";
             document.getElementById('outDirectory').style.display = "";
             }*/
        }

        function hideDirList() {
            //document.getElementById('divDirectoryList').style.display = "none";
            //divDirectoryList.style.visibility = 'hidden';
            $("#divDirectoryList").dialog("close");
        }

        function loadDirectory(opt) {
            if (hasChecked("classList") == false) {
                alert("请至少选择一个组！");
                return false;
            } else {
                dirForm.inout.value = opt;
                dirForm.submit()
            }
        }

        function update() {
            var checkBoxs = document.getElementsByName("jobs");
            var userJob = 0;
            var jobName = 0
            //--选择用户身份
            for (var i = 0; i < checkBoxs.length; i++) {
                if (checkBoxs[i].checked) {
                    userJob = userJob | checkBoxs[i].value;
                }
            }
            consumerEditForm.userJob.value = userJob;
            //--选择用户职称
            checkBoxs = document.getElementsByName("zc");
            for (var i = 0; i < checkBoxs.length; i++) {
                if (checkBoxs[i].checked) {
                    jobName = jobName | checkBoxs[i].value;
                }
            }
            consumerEditForm.jobName.value = jobName;

            //---验证用户真实姓名
            if (!checkLength(consumerEditForm.trueName, 20)) {
                alert("真实姓名长度应在20个字符以内");
                consumerEditForm.trueName.focus();
                return false;
            }
            if (consumerEditForm.nickname.value == "") {
                alert("用户昵称不能为空");
                consumerEditForm.nickname.focus();
                return false;
            }
            //---验证用户邮件
            if (!checkLength(consumerEditForm.email, 100)) {
                alert("邮件长度应在100个字符以内");
                consumerEditForm.email.focus();
                return false;
            }

            //--验证邮件格式
            if(!checkEmail(consumerEditForm.email.value))
            {
                alert("邮箱格式不正确");
                consumerEditForm.email.focus();
                return false;
            }

            //---验证用户密码
            if (consumerEditForm.modPassword.value != "") {
                if (consumerEditForm.modPassword.value.length < 6 || consumerEditForm.modPassword.value.length > 20) {
                    alert("密码长度应该在6~20之间");
                    return false;
                }
                /*
                else if (consumerEditForm.modPassword.value != consumerEditForm.chkPassword.value) {
                    alert("密码不一致，请检查！");
                    return false;
                }*/
            }
            //---验证电话号码长度
            if (!checkLength(consumerEditForm.telephone, 20)) {
                alert("电话号码长度应在20个字符以内");
                consumerEditForm.telephone.focus();
                return false;
            }
            //---验证身份证长度
            if (!checkLength(consumerEditForm.idCard, 18)) {
                alert("身份证号长度应在18个字符以内");
                consumerEditForm.idCard.focus();
                return false;
            }
            //---验证专业长度
            if (!checkLength(consumerEditForm.profession, 50)) {
                alert("专业长度应在50个字符以内");
                consumerEditForm.profession.focus();
                return false;
            }
            //---验证空间大小
            if (consumerEditForm.spaceSize.value == "") {
                alert("空间大小不能为空");
                consumerEditForm.spaceSize.focus();
                return false;
            }
            if (isNaN(consumerEditForm.spaceSize.value)) {
                alert("空间大小必须为数字");
                consumerEditForm.spaceSize.focus();
                return false;
            }
            //---验证描述信息长度
            if (!checkLength(consumerEditForm.descriptions, 100)) {
                alert("专业长度应在100个字符以内");
                consumerEditForm.descriptions.focus();
                return false;
            }

            var action = "${createLink(action:'userUpdate')}";
            consumerEditForm.action = action;
            consumerEditForm.submit()
        }
        function del() {
            var action = "${createLink(action:'delete')}";
            if (!confirm('确定删除?')) {
                return false;
            }
            consumerEditForm.action = action;
            consumerEditForm.submit();
        }
        function backList() {
            var action = "${createLink(controller: 'userMgr', action:'userList')}";
            window.location.href = action;
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
            $("#UdateValid").datepicker();
            document.getElementById('divDirectoryList').style.display = "none";
            //divDirectoryList.style.visibility = 'hidden';
        });
    </script>

</head>

<body>

<form name="consumerEditForm" method="post" action="">
<input type="hidden" name="id" value="${consumer?.id}"/>
<input type="hidden" name="max" value="${params.max}"/>
<input type="hidden" name="offset" value="${params.offset}"/>
<input type="hidden" name="sort" value="${params.sort}"/>
<input type="hidden" name="order" value="${params.order}"/>
<input type="hidden" name="userRole2" value="${params.userRole}"/>
<input type="hidden" name="roleList" value="${params.roleList}"/>
<input type="hidden" name="searchName" value="${params.searchName}"/>
<input type="hidden" name="searchNickName" value="${params.searchNickName}"/>
<input type="hidden" name="searchTrueName" value="${params.searchTrueName}"/>
<input type="hidden" name="searchCollege" value="${params.searchCollege}"/>
<input type="hidden" name="userJob" value="0"/>
<input type="hidden" name="jobName" value="0"/>
<input type="hidden" name="profession" value=""/>
<input type="hidden" name="Jobs" value="0">
<input type="hidden" name="zc" value="0">
<input type="hidden" name="editPage" value="${editPage}">

<span style="color: red;">${flash.message}</span>

<table width="100%">
<tr>
<td><div id="tblist2">
<table width="790" cellspacing="2" cellpadding="2">
    <tr>
        <td height="26"><span class="tips">注：带&quot;</span><span class="tipsred">*</span><span
                class="tips">&quot;号为必填内容</span></td>
    </tr>
</table>
<table width="790" class="table" border="0">
    <tr>
        <th colspan="4"><div align="center">修改用户信息</div></th>
    </tr>
    <tr>
        <td width="110" align="right">用户帐号 <span class="tipsred">*</span></td>
        <td>&nbsp; ${fieldValue(bean: consumer, field: 'name')}</td>
    </tr>
    <tr>
        <td align="right">用户昵称 <span class="tipsred">*</span></td>
        <td><input class="form-control" style="width: 200px" type="text" maxlength="40" id="nickname"
                   name="nickname" class="tbinp"
                   value="${fieldValue(bean: consumer, field: 'nickname')}"/>
        </td>
    </tr>
    <tr>
        <td align="right">真实姓名</td>
        <td><input class="form-control" style="width: 200px" type="text" id="trueName" name="trueName" maxlength="200"
                   value="${fieldValue(bean: consumer, field: 'trueName')}" class="tbinp"/></td>
    </tr>
    <tr>
        <td align="right">电子邮件<span class="tipsred">*</span></td>
        <td><input class="form-control" style="width: 200px" type="text" id="email" name="email" maxlength="200"
                   value="${fieldValue(bean: consumer, field: 'email')}" class="tbinp"/></td>
    </tr>
    <tr>
        <td align="right">用户密码</td>
        <td><input class="form-control" style="width: 200px" type="password" id="modPassword"
                   name="modPassword" maxlength="200" value="" class="tbinp" value="${fieldValue(bean: consumer, field: 'password')}"/></td>
    </tr>
    %{-- <tr>
         <td align="right">核对密码</td>
         <td><input class="form-control" style="width: 200px" type="password" id="chkPassword"
                    name="chkPassword" maxlength="200" value="" class="tbinp"/></td>
     </tr>--}%
    <tr>
        <td align="right">性    别</td>
        <td>
            <g:if test="${consumer.gender == 1}">
                男 <g:radio name="gender" value="1" checked="true"/>
                女 <g:radio name="gender" value="0"/>
            </g:if>
            <g:else>
                男 <g:radio name="gender" value="1"/>
                女 <g:radio name="gender" value="0" checked="true"/>
            </g:else>
        </td>
    </tr>
    <tr>
        <td align="right">角   色</td>
        <td>
            <input type="radio" name="role"
                   value="1" ${consumer.role == 1 ? 'checked' : ''}> 资源管理员
            <input type="radio" name="role"
                   value="2" ${consumer.role == 2 ? 'checked' : ''}/> 高级用户
            <input type="radio" name="role"
                   value="3" ${consumer.role == 3 ? 'checked' : ''}/> 普通用户
        </td>
    </tr>
    <tr>
        <td align="right">联系电话</td>
        <td><input class="form-control" style="width: 200px" type="text" id="telephone"
                   name="telephone" maxlength="200"
                   value="${fieldValue(bean: consumer, field: 'telephone')}" class="tbinp"/></td>
    </tr>
    <tr>
        <td align="right">身份证号</td>
        <td><input class="form-control" style="width: 200px" type="text" id="idCard"
                   name="idCard" maxlength="200" value="${fieldValue(bean: consumer, field: 'idCard')}"
                   class="tbinp"/></td>
    </tr>
    <tr>
        <td align="right">有效时间</td>
        <td colspan="3">
            <input type="text" class="form-control" style="width: 200px" name="UdateValid" id="UdateValid"
                   maxlength="200"
                   value="<g:formatDate format="yyyy-MM-dd" date="${consumer.dateValid}"/>"
                   class="tbinp"/></td>
    </tr>
    <tr>
        <td align="right">学    历</td>
        <td colspan="3">
            <label><input type="radio" name="userEducation"
                          value="0" ${consumer.userEducation == 0 ? 'checked' : ' '}>
            </label> 专科
            <label><input type="radio" name="userEducation"
                          value="1" ${consumer.userEducation == 1 ? 'checked' : ' '}>
            </label>本科
            <label><input type="radio" name="userEducation"
                          value="2" ${consumer.userEducation == 2 ? 'checked' : ' '}>
            </label> 硕士
            <label><input type="radio" name="userEducation"
                          value="3" ${consumer.userEducation == 3 ? 'checked' : ' '}>
            </label>博士
            <label><input type="radio" name="userEducation"
                          value="4" ${consumer.userEducation == 4 ? 'checked' : ' '}>
            </label>博士后
            <label><input type="radio" name="userEducation"
                          value="5" ${consumer.userEducation == 5 ? 'checked' : ' '}>
            </label> 其他
        </td>
    </tr>
    <tr>
        <td align="right">所属部门</td>
        <td><select id="groupList" class="form-control" style="width: 200px" name="college.id" value="${consumer.college?.id}">
            <g:each in="${collegeList}" var="college">
                <option value="${college.id}" <g:if test="${college.id == consumer.college?.id}">selected="selected" </g:if>>${college.name}</option>
            </g:each>
        </select></td>
    </tr>

    <tr>
        <td align="right">空间大小<span class="tipsred">*</span></td>
        <td>
            <table>
                <tr>
                    <td style="padding-left: 0px;"><input class="form-control" type="text" id="spaceSize" name="spaceSize"
                               style="width: 100px" maxlength="4"
                               value="${consumer?.spaceSize}"/>
                    </td>
                    <td><g:select name="spaceSizeUnit" class="form-control" style="width:80px"
                                  from="${[1: 'KB', 2: 'MB', 3: 'GB']}"
                                  optionKey="key" optionValue="value" value="${consumer?.spaceSizeUnit}"/></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right">已使用空间</td>
        <td>${showUseSpace}</td>
    </tr>
    <tr>
        <td align="right">描述信息</td>
        <td><input type="text" maxlength="200" id="descriptions"
                   name="descriptions" value="${fieldValue(bean: consumer, field: 'descriptions')}"
                   class="form-control"/></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <tr>
        <td></td>
        <td height="35" colspan="4" align="left"><div>
            <div align="left">
                <input onclick="update()" type="button" value="保存" class="btn btn-primary"/>
                <input onclick="showDirectoryList('in')" type="button" value="选择上传库" class="btn btn-primary"/>
                <input onclick="showDirectoryList('out')" type="button" value="撤消上传库" class="btn btn-primary"/>
                <input onclick="backList()" type="button" value="关闭" class="btn btn-primary"/>
            </div>
        </div></td>
    </tr>
</table>
</div></td>
</tr>
<tr>

</tr>
</table>
</form>

<div name="divDirectoryList" id="divDirectoryList">
    <div>

        <g:form name="dirForm" action="consumerInDirectory" controller="userMgr">
            <input type="hidden" name="inout" value=""/>
            <input type="hidden" name="consumerId" value="${consumer?.id}"/>
            <table width="180" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF" bgcolor="#ECF0ED">
                <g:each in="${categories}" status="i" var="category">
                    <tr>
                        <td align="center"><input type="checkBox" name="classList"
                                                  value="${category.id}" ${consumer.programCategorys.contains(category) ? 'checked' : ' '}>
                        </td>
                        <td class="td1">${fieldValue(bean: category, field: 'name')}</td>
                    </tr>
                </g:each>
                <tr>
                    <td></td>
                    <td>
                        <input type="button" class="btn btn-primary" id="inDirectory" value="选择"
                               onclick="loadDirectory('in')">
                        <input type="button" class="btn btn-primary" id="outDirectory" value="撤消"
                               onclick="loadDirectory('out')">
                        <input type="button" class="btn btn-primary" name="_canel" value="取消" onclick="hideDirList()">
                    </td>
                </tr>
            </table>
        </g:form>


    </div>
</div>
</body>
</html>