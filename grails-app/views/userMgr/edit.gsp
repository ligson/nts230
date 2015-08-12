<%@ page import="nts.user.domain.Consumer" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>

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

-->
</style>
<title>编辑用户</title>
<script Language="JavaScript">

    function checkIdList(opt) {
        var action = "${createLink(action:'consumerLoadGroup')}";
        if (opt == 'load' || opt == 'unload') {
            if (hasChecked("groupIdList") == false) {
                alert("请至少选择一个组！");
                return false;
            }
        }
        consumerEditForm.inout.value = opt;
        consumerEditForm.action = action;
        consumerEditForm.submit()
    }

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
        divDirectoryList.style.visibility = 'visible';
//	img1.style.visibility='visible';
        if (opt == 'in') {
            document.getElementById('inDirectory').style.display = "";
            document.getElementById('outDirectory').style.display = "none";
        }
        if (opt == 'out') {
            document.getElementById('inDirectory').style.display = "none";
            document.getElementById('outDirectory').style.display = "";
        }
    }

    function hideDirList() {
        //document.getElementById('divDirectoryList').style.display = "none";
        divDirectoryList.style.visibility = 'hidden';
    }

    function loadDirectory(opt) {
        var action = "${createLink(action:'consumerInDirectory')}";

        if (hasChecked("classList") == false) {
            alert("请至少选择一个组！");
            return false;
        }
        consumerEditForm.inout.value = opt;
        consumerEditForm.action = action;
        consumerEditForm.submit()
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
        //---验证用户邮件
        if (!checkLength(consumerEditForm.email, 100)) {
            alert("邮件长度应在100个字符以内");
            consumerEditForm.email.focus();
            return false;
        }

        //---验证用户密码
        if (consumerEditForm.modPassword.value != "") {
            if (consumerEditForm.modPassword.value.length < 6 || consumerEditForm.modPassword.value.length > 20) {
                alert("密码长度应该在6~20之间");
                return false;
            }
            else if (consumerEditForm.modPassword.value != consumerEditForm.chkPassword.value) {
                alert("密码不一致，请检查！");
                return false;
            }
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
        //---验证描述信息长度
        if (!checkLength(consumerEditForm.descriptions, 100)) {
            alert("专业长度应在100个字符以内");
            consumerEditForm.descriptions.focus();
            return false;
        }

        var action = "${createLink(action:'update')}";
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
        var action = "${createLink(action:'list')}";
        consumerEditForm.action = action;
        consumerEditForm.submit();
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
    });
</script>

</head>

<body style="background:#fff;">

<div>
<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>
<g:hasErrors bean="${consumer}">
    <div class="errors">
        <g:renderErrors bean="${consumer}" as="list"/>
    </div>
</g:hasErrors>
<g:form name="consumerEditForm" method="post">
<input type="hidden" name="id" value="${consumer?.id}"/>
<input type="hidden" name="inout" value=""/>
<input type="hidden" name="max" value="${params.max}"/>
<input type="hidden" name="offset" value="${params.offset}"/>
<input type="hidden" name="sort" value="${params.sort}"/>
<input type="hidden" name="order" value="${params.order}"/>
<input type="hidden" name="userRole" value="${params.userRole}"/>
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

<DIV align=center style="background:#FFF;">
<TABLE class="tbottomline2" height="365" cellSpacing="0" cellPadding="0" border="0">
<TBODY>
<TR>
<TD vAlign="top" align="left" width="18">&nbsp;</TD>
<TD align="left" vAlign="top">

<TABLE border=0 align="center" cellPadding=0 cellSpacing=0>
    <TBODY>
    <TR>
        <TD background="${resource(dir: 'images/skin', file: 'text_title_grxx.gif')} " height=60>&nbsp;</TD>
    </TR>
    </TBODY>
</TABLE>
<TABLE border=0 align="center" cellPadding=0 cellSpacing=0>
<TBODY>
<TR>
    <TD class=table_tr colspan="2">&nbsp;注：带<FONT color=red>*</FONT>号为必填内容。</TD>
</TR>
<TR>
    <td vAlign=top colspan="2">
        <TABLE cellSpacing=1 cellPadding=0 width="100%"
               border=0><!---  Table Rows   --->
            <TBODY>
            <TR class=table_tr>
                <TD width="17%" height="32" align=middle>&nbsp;用户帐号<FONT color=red>*</FONT></TD>
                <TD align=left>&nbsp; ${fieldValue(bean: consumer, field: 'name')}</TD>
                <TD width="16%" align=middle>&nbsp;用户昵称<FONT color=red>*</FONT></TD>
                <TD width="41%" align=left>&nbsp;
                    <input type="text" maxlength="40" id="nickname"
                           name="nickname"
                           value="${fieldValue(bean: consumer, field: 'nickname')}"/>
                </TD>
            </TR>
            <TR class=table_tr>
                <TD width="17%" height="32" align=middle>&nbsp;真实姓名</TD>
                <TD align=left width="26%">&nbsp; <input type="text" id="trueName" name="trueName"
                                                         value="${fieldValue(bean: consumer, field: 'trueName')}"/>
                </TD>
                <TD width="16%" align=middle>&nbsp;电子邮件</TD>
                <TD width="41%" align=left>&nbsp;  <input type="text" id="email" name="email"
                                                          value="${fieldValue(bean: consumer, field: 'email')}"/>
                </TD>
            </TR>

            <TR class=table_tr>
                <TD width="17%" height="32" align=middle>&nbsp;更新密码</TD>
                <TD align=left width="26%">&nbsp; <input type="password" id="modPassword"
                                                         name="modPassword" value=""/></TD>
                <TD width="16%" align=middle>&nbsp;核对密码</TD>
                <TD width="41%" align=left>&nbsp; <input type="password" id="chkPassword"
                                                         name="chkPassword" value=""/></TD>
            </TR>
            <TR class=table_tr>
                <TD height="32" align=middle>&nbsp;性&nbsp;&nbsp;&nbsp; 别&nbsp;</TD>
                <TD align="left">&nbsp;
                <g:if test="${consumer.gender == 1}">
                    男 <g:radio name="gender" value="1" checked="true"/>
                    女 <g:radio name="gender" value="0"/>
                </g:if>
                <g:else>
                    男 <g:radio name="gender" value="1"/>
                    女 <g:radio name="gender" value="0" checked="true"/>
                </g:else>
                </TD>
                <TD align=middle>&nbsp;角&nbsp;&nbsp;&nbsp;色</TD>
                <TD align=left>&nbsp;
                    <input type="radio" name="role"
                           value="1" ${consumer.role == 1 ? 'checked' : ''}> 资源管理员
                    <input type="radio" name="role"
                           value="2" ${consumer.role == 2 ? 'checked' : ''}/> 高级用户
                    <input type="radio" name="role"
                           value="3" ${consumer.role == 3 ? 'checked' : ''}/> 普通用户
                </TD>
            </TR>

            <TR class=table_tr>
                <TD width="17%" height="32" align=middle>&nbsp;联系电话</TD>
                <TD align=left width="26%">&nbsp; <input type="text" maxlength="20" id="telephone"
                                                         name="telephone"
                                                         value="${fieldValue(bean: consumer, field: 'telephone')}"/>
                </TD>
                <TD width="16%" align=middle>&nbsp;身份证号</TD>
                <TD width="41%" align=left>&nbsp;  <input type="text" maxlength="18" id="idCard"
                                                          name="idCard"
                                                          value="${fieldValue(bean: consumer, field: 'idCard')}"/>
                </TD>
            </TR>

            <TR class=table_tr>

                <TD width="16%" align=middle>&nbsp;有效时间</TD>
                <TD width="41%" align=left colspan="3">&nbsp;
                    <input name="UdateValid" id="UdateValid" readonly="" type="text"
                           value="<g:formatDate format="yyyy-MM-dd" date="${consumer.dateValid}"/>">
                </TD>
            </TR>
            </tbody>
        </table>
    </td>
</tr>
<TR class=table_tr>
    <TD height="29" align=middle>&nbsp;学&nbsp;&nbsp;&nbsp;&nbsp;历&nbsp</TD>
    <TD align=left><label></label>
        <label><input type="radio" name="userEducation"
                      value="0" ${consumer.userEducation == 0 ? 'checked' : ' '}>
        </label> 专科&nbsp;&nbsp;&nbsp;
        <label><input type="radio" name="userEducation"
                      value="1" ${consumer.userEducation == 1 ? 'checked' : ' '}>
        </label>本科&nbsp;&nbsp;&nbsp;
        <label><input type="radio" name="userEducation"
                      value="2" ${consumer.userEducation == 2 ? 'checked' : ' '}>
        </label> 硕士&nbsp;&nbsp;&nbsp;
        <label><input type="radio" name="userEducation"
                      value="3" ${consumer.userEducation == 3 ? 'checked' : ' '}>
        </label>博士&nbsp;&nbsp;&nbsp;
        <label><input type="radio" name="userEducation"
                      value="4" ${consumer.userEducation == 4 ? 'checked' : ' '}>
        </label>博士后&nbsp;&nbsp;&nbsp;
        <label><input type="radio" name="userEducation"
                      value="5" ${consumer.userEducation == 5 ? 'checked' : ' '}>
        </label> 其他
    </TD>
</TR>

<TR class=table_tr>
    <TD height="32" align=middle>&nbsp;所属部门</TD>
    <TD align=left>&nbsp;
        <select name="updateCollege" id="college">
            <option value="${fieldValue(bean: consumer, field: 'college.id')}">${fieldValue(bean: consumer, field: 'college.name')}</option>
            <g:each in="${collegeList}" var="college">
                <option value="${college.id}">${college.name}</option>
            </g:each>
        </select>
    </TD>
</tr>
<tr>
    <TD align=middle>&nbsp;权限控制</TD>
    <TD align=left>
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="2">
            <tr>
                <td class="table_tr">上传设置：</td>
                <td class="table_tr">
                    <input type="radio" name="uploadState"
                           value="0" ${consumer.uploadState == 0 ? 'checked' : ' '}/> 禁止
                    <input type="radio" name="uploadState"
                           value="2" ${consumer.uploadState == 2 ? 'checked' : ' '}/> 申请
                    <input type="radio" name="uploadState"
                           value="1" ${consumer.uploadState == 1 ? 'checked' : ' '}/> 允许
            </tr>  <tr>
            <td class="table_tr">下载设置:：</td>
            <td class="table_tr">
                <g:if test="${consumer.canDownload}">
                    <g:radio name="canDownload" value="0"/> 禁止下载
                    <g:radio name="canDownload" value="1" checked="true"/> 允许下载
                </g:if>
                <g:else>
                    <g:radio name="canDownload" value="0" checked="true"/> 禁止下载
                    <g:radio name="canDownload" value="1"/> 允许下载
                </g:else>
            </td>
        </tr>  <tr>
            <td class="table_tr">评论设置:：</td>
            <td class="table_tr">
                <g:if test="${consumer.canComment}">
                    <g:radio name="canComment" value="0"/> 禁止评论
                    <g:radio name="canComment" value="1" checked="true"/> 允许评论
                </g:if>
                <g:else>
                    <g:radio name="canComment" value="0" checked="true"/> 禁止评论
                    <g:radio name="canComment" value="1"/> 允许评论
                </g:else>
            </td>
        </tr>
            <tr>
                <td class="table_tr">用户状态：</td>
                <td class="table_tr">
                    <g:if test="${consumer.userState}">
                        <g:radio name="userState" value="0"/> 当前禁用
                        <g:radio name="userState" value="1" checked="true"/> 当前启用
                    </g:if>
                    <g:else>
                        <g:radio name="userState" value="0" checked="true"/> 当前禁用
                        <g:radio name="userState" value="1"/> 当前启用
                    </g:else>
                </td>
            </tr><tr>
            <td class="table_tr">资源审核：</td>
            <td class="table_tr">
                <g:if test="${consumer.notExamine}">
                    <g:radio name="notExamine" value="0"/> 审核
                    <g:radio name="notExamine" value="1" checked="true"/> 免审
                </g:if>
                <g:else>
                    <g:radio name="notExamine" value="0" checked="true"/> 审核
                    <g:radio name="notExamine" value="1"/> 免审
                </g:else>
            </td>
        </tr>

            <tr>
                <td class="table_tr">用户类型：</td>
                <td class="table_tr">
                    <input type="radio" name="isRegister"
                           value="1" ${consumer.isRegister ? 'checked' : ''}>注册用户
                    <input type="radio" name="isRegister"
                           value="0" ${consumer.isRegister ? '' : 'checked'}>正式用户
                </td>
            </tr>

        </table>
    </TD>
</TR>

<TR class=table_tr>
    <TD height="15" align=middle>&nbsp;上传类库</TD>
    <TD align=left>&nbsp; <g:if
            test="${consumer.directorys}">${fieldValue(bean: consumer, field: 'directorys')}</g:if></TD>
</TR>

<TR class=table_tr>
    <TD height="15" height="32" align=middle>&nbsp;描述信息</TD>
    <TD align=left>&nbsp; <input type="text" maxlength="200" id="descriptions"
                                 name="descriptions"
                                 value="${fieldValue(bean: consumer, field: 'descriptions')}"/>
    </TD>
</TR>

<tr>
    <td colspan="2">
        <div>
            <span class="button"><input type="button" class="button_input" value="修改"
                                        onClick="update()"></span>
            <span class="button"><input type="button" class="button_input" value="删除" onClick="del()"/>
            </span>
            <span class="button"><input type="button" class="button_input"
                                        onclick="showDirectoryList('in')" value="选择上传库"/></span>
            <span class="button"><input type="button" class="button_input"
                                        onclick="showDirectoryList('out')" value="撤消上传库"/></span>
            <span class="create"><input type="button" class="button_input" onclick="backList()"
                                        value="返回"/></span>
        </div>
    </td>
</tr>
</TBODY>
</TABLE>
</td>
</tr>
</tbody>
</table>
</DIV>


<div name="divDirectoryList" id="divDirectoryList"
     style="position:absolute; width:300; height:375; left:350px; top:60px; z-index:1; visibility: hidden;"
     align="center">
    <div style="border:#000000 1px solid; width:150px; height:52px;text-align:center; line-height:52px">

        <table width="180" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF" bgcolor="#ECF0ED">
            <g:each in="${dirlist}" status="i" var="dir">
                <tr>
                    <td align="center"><input type="checkBox" name="classList"
                                              value="${dir.id}" ${consumer.directorys.contains(dir) ? 'checked' : ' '}>
                    </td>
                    <td class="td1">${fieldValue(bean: dir, field: 'name')}</td>
                </tr>
            </g:each>
            <tr>
                <td>
                </td>
                <td>
                    <input type="button" class="button_input" style="display:none" name="inDirectory" value="选择"
                           onclick="loadDirectory('in')">
                    <input type="button" class="button_input" style="display:none" name="outDirectory" value="撤消"
                           onclick="loadDirectory('out')">
                    <input type="button" class="button_input" name="_canel" value="取消" onclick="hideDirList()">
                </td>
            </tr>
        </table>

    </div>
</div>

</g:form>
</div>
</body>
</html>
