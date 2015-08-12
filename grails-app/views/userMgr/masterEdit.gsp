<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <title>Master管理</title>
    <script Language="JavaScript">





        function update() {

            //---验证用户昵称是否为空
            if (masterEditForm.nickname.value == "") {
                alert("昵称不能为空");
                return false;
            }
            //---验证用户昵称长度
            if (masterEditForm.nickname.value.length < 2 || masterEditForm.nickname.value.length > 20) {
                alert("昵称长度应该在2~20之间");
                return false;
            }

            //---验证用户真实姓名
            if(masterEditForm.trueName.value != "") {
                if (!checkLength(masterEditForm.trueName, 20)) {
                    alert("真实姓名长度应在20个字符以内");
                    masterEditForm.trueName.focus();
                    return false;
                }
            }
            //---验证用户密码
            if (masterEditForm.modPassword.value != "") {
                if (masterEditForm.modPassword.value.length < 6 || masterEditForm.modPassword.value.length > 20) {
                    alert("密码长度应该在6~20之间");
                    return false;
                }
                else if (masterEditForm.modPassword.value != masterEditForm.chkPassword.value) {
                    alert("密码不一致，请检查！");
                    return false;
                }
            }

            var action = "${createLink(action:'masterUpdate')}";
            masterEditForm.action = action;
            masterEditForm.submit()
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
    </script>

</head>

<body style="background:#fff;">

<div>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${master}">
        <div class="errors">
            <g:renderErrors bean="${master}" as="list"/>
        </div>
    </g:hasErrors>
    <g:form name="masterEditForm" method="post">
        <input type="hidden" name="id" value="${master?.id}"/>

        <DIV>
            <TABLE cellPadding=0 cellSpacing=0 width="100%">

                <TR>
                    <TD style="padding: 10px 0;font-size: 16px">&nbsp;个人信息</TD>
                </TR>
                <TR>
                    <TD style="padding: 10px 0;font-size: 14px">&nbsp;注：带<FONT color=red>*</FONT>号为必填内容。</TD>
                </TR>
                <TR>
                    <TD>
                        <TABLE class="table"><!---  Table Rows   --->
                            <TR>
                                <TD width="120" align="right">用户帐号：
                                </TD>
                                <TD>${fieldValue(bean: master, field: 'name')}</TD>
                            </TR>
                            <TR>
                                <TD align="right">用户角色：</TD>
                                <TD>超级管理员</TD>
                            </TR>
                            <TR>
                                <TD align="right"><font color=red>*</font>用户昵称：
                                </TD>
                                <TD>
                                    <input class="form-control" type="text" maxlength="40" id="nickname" name="nickname"
                                           style="width: 220px"
                                           value="${fieldValue(bean: master, field: 'nickname')}"/></TD>
                            </TR>

                            <TR>
                                <TD align="right">真实姓名：</TD>
                                <TD>
                                    <label style="width: 220px">
                                        <input class="form-control" type="text" id="trueName" name="trueName"
                                               value="${fieldValue(bean: master, field: 'trueName')}"/>
                                    </label>
                                </TD>

                            </TR>
                            <TR>
                                <TD align="right">更新密码：</TD>
                                <TD><label><input class="form-control" type="password" id="modPassword" style="width: 220px"
                                                  name="modPassword" value=""/></label></TD>
                            </TR>

                            <TR>
                                <TD align="right">核对密码：</TD>
                                <TD><input class="form-control" type="password" id="chkPassword" style="width: 220px"
                                           name="chkPassword" value=""/></TD>
                            </TR>
                            %{--<TR>
                                <TD align="right">性别：</TD>
                                <TD>
                                    <g:if test="${master.gender == 1}">
                                        男 <g:radio name="gender" value="1" checked="true"/>
                                        女 <g:radio name="gender" value="0"/>
                                    </g:if>
                                    <g:else>
                                        男 <g:radio name="gender" value="1"/>
                                        女 <g:radio name="gender" value="0" checked="true"/>
                                    </g:else>
                                </TD>
                            </TR>
                            <TR>

                                <td align="right">上传设置：</td>
                                <td><input type="radio"
                                           name="uploadState"
                                           value="1"
                                           checked="checked"/>
                                    允许</td>
                            </TR>
                            <tr>
                                <td align="right">下载设置：</td>
                                <td><input type="radio" name="canDownload"
                                           value="1" checked="checked"/>
                                    允许下载</td>
                            </tr>
                            <tr>

                                <td align="right">评论设置：</td>
                                <td><input type="radio" name="canComment"
                                           value="1" checked="checked"/>
                                    允许评论</td>

                            </tr>
                            <tr>
                                <td align="right">用户状态：</td>
                                <td><input type="radio" name="userState"
                                           value="1" checked="checked"/>
                                    当前启用</td>

                            </tr>
                            <tr>
                                <td align="right">审核状态：</td>
                                <td><input type="radio" name="notExamine" value="1" checked="checked"/>
                                    免审</td>
                            </tr> --}%
                            <tr>
                                <td></td>
                                <TD>

                                    <label>
                                        <input type="button" class="btn btn-primary" value="修改"
                                               onClick="update()"></label>
                                   %{--<label>
                                        <input type="button" class="btn btn-primary" onclick="backList()"
                                               value="返回"/>
                                    </label>--}%

                                </TD>
                            </tr>
                        </table>
                    </TD>
                </TR>
            </TABLE>

        </DIV>


    %{-- <div name="divDirectoryList" id="divDirectoryList"
          style="position:absolute; width:300; height:375; left:350px; top:60px; z-index:1; visibility: hidden;"
          align="center">
         <div style="border:#000000 1px solid; width:150px; height:52px;vertical-align:center; line-height:52px">

             <table width="180" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF" bgcolor="#ECF0ED">
                 <g:each in="${dirlist}" status="i" var="dir">
                     <tr>
                         <td align="center"><input type="checkBox" name="classList"
                                                   value="${dir.id}" ${master.directorys.contains(dir) ? 'checked' : ' '}>
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
                         <input type="button" class="button_input" style="display:none" name="outDirectory"
                                value="撤消" onclick="loadDirectory('out')">
                         <input type="button" class="button_input" name="_canel" value="取消" onclick="hideDirList()">
                     </td>
                 </tr>
             </table>

         </div>
     </div>--}%

    </g:form>
</div>
</body>
</html>
