<HTML>
<HEAD>
    <TITLE>个人信息修改</TITLE>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'zxm.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript">
        function apply() {
            var checkBoxs = document.getElementsByName("jobs");
            var userJob = 0;
            var jobName = 0
            //--选择用户身份
            for (var i = 0; i < checkBoxs.length; i++) {
                if (checkBoxs[i].checked) {
                    userJob = userJob | checkBoxs[i].value;
                }
            }
            appForm.userJob.value = userJob;
            //--选择用户职称
            checkBoxs = document.getElementsByName("zc");
            for (var i = 0; i < checkBoxs.length; i++) {
                if (checkBoxs[i].checked) {
                    jobName = jobName | checkBoxs[i].value;
                }
            }
            appForm.jobName.value = jobName;

            if (appForm.nickname.value == "") {
                msg("昵称", appForm.nickname);
                return false;
            }
            if (appForm.trueName.value == "") {
                msg("姓名", appForm.trueName);
                return false;
            }
            if (appForm.applyCollege.value == "") {
                msg("所属院系", appForm.applyCollege);
                return false;
            }
            if (appForm.telephone.value == "") {
                msg("联系电话", appForm.telephone);
                return false;
            }
            if (appForm.email.value == "") {
                msg("Email地址", appForm.email);
                return false;
            }
            if (appForm.userJob.value == 0) {
                alert("身份为必添项目");
                return false;
            }
            if (appForm.jobName.value == 0) {
                alert("职称为必添项目");
                return false;
            }

            appForm.action = "apply";
            appForm.submit()
        }
        function msg(title, obj) {
            alert(title + "为必添项目");
            obj.focus();
        }
    </script>
</HEAD>

<BODY style="background:#fff;">
<div class="x_daohang">
    <p>当前位置：<a href="${createLink(controller: 'my', action: 'myInfo')}">个人空间</a>>><a href="/my/uploadApply.gsp">上传申请</a>>> 申请表</p>
</div>

<DIV align=center>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${consumer}">
        <div class="errors">
            <g:renderErrors bean="${consumer}" as="list"/>
        </div>
    </g:hasErrors>
    <form name="appForm" method="post" action="">
        <input type="hidden" name="userJob" value="0"/>
        <input type="hidden" name="jobName" value="0"/>
        <TABLE class=tbottomline2 height=365 cellSpacing=0 cellPadding=0 width=100% border=0>

            <TBODY>
            <TR>
                <TD vAlign=top align=left width=18>&nbsp;</TD>
                <TD width="1185" align=middle vAlign=top><TABLE width="660" border=0 align="center" cellPadding=0
                                                                cellSpacing=0>
                    <TBODY>
                    <TR>
                        <TD height=137 background="${resource(dir: 'images/skin', file: 'grkj_sqbtitle.gif')}">
                            <table width="102%" height="135" border="0" cellpadding="2" cellspacing="2">
                                <tr>
                                    <td width="68%" height="91">&nbsp;</td>
                                    <td colspan="2">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td height="38">&nbsp;</td>
                                    <td width="4%"><img src="${resource(dir: 'images/skin', file: 'HaoSc21_905_200525101619580.gif')}"
                                                        width="20" height="20"></td>
                                    <td width="28%"><a href="/downdir/grkj_sqb.doc" target="_blank"
                                                       class="STYLE4">下载申请表</a></td>
                                </tr>
                            </table></TD>
                    </TR></TBODY></TABLE>
                    <TABLE width=659 border=0 align="center" cellPadding=0 cellSpacing=0>
                        <TBODY>
                        <TR>
                            <TD height=8></TD>
                        </TR>
                        <TR>
                            <TD class=table_tr>&nbsp;注：带<FONT color=red>*</FONT>号为必填项。</TD>
                        </TR>
                        <TR>
                            <TD vAlign=top>
                                <TABLE cellSpacing=1 cellPadding=0 width="100%" bgColor=#999999 border=0>
                                    <TBODY>
                                    <TR class=table_tr>
                                        <TD width="11%" height="37" align=middle><div align="left">&nbsp;用户UID<FONT
                                                color=red>*</FONT></div></TD>
                                        <TD width="35%"
                                            align=left>&nbsp; ${fieldValue(bean: consumer, field: 'name')}</TD>
                                        <TD align=left><div align="left">&nbsp;昵&nbsp;&nbsp;&nbsp;&nbsp;称<FONT
                                                color=red>*</FONT></div></TD>
                                        <TD width="35%" align=left>&nbsp;&nbsp;<input type="text" maxlength="40"
                                                                                      id="nickname" name="nickname"
                                                                                      value="${fieldValue(bean: consumer, field: 'nickname')}"/>
                                        </TD>
                                    </TR>
                                    <TR class=table_tr>
                                        <TD width="11%" height="31" align=middle><div
                                                align="left">&nbsp;姓&nbsp;&nbsp;&nbsp;&nbsp;名<FONT color=red>*</FONT>
                                        </div></TD>
                                        <TD align=left>&nbsp; <input type="text" id="trueName" name="trueName"
                                                                     value="${fieldValue(bean: consumer, field: 'trueName')}"/>
                                        </TD>
                                        <TD width="19%" align=middle><div align="left">&nbsp;主要专业</div></TD>
                                        <TD align=left>&nbsp;<input type="text" id="profession" name="profession"
                                                                    value="${fieldValue(bean: consumer, field: 'profession')}"/>
                                        </TD>
                                    </TR>
                                    <TR class=table_tr>
                                        <TD height="29" align=left>&nbsp;身&nbsp;&nbsp;&nbsp;&nbsp;份<FONT
                                                color=red>*</FONT></TD>
                                        <TD colspan="3" align=left>
                                            <label><input type="checkbox" name="Jobs"
                                                          value="1" ${consumer.userJob & 1 ? 'checked' : ' '}>
                                            </label>  教师
                                            <label><input type="checkbox" name="Jobs"
                                                          value="2" ${consumer.userJob & 2 ? 'checked' : ' '}>
                                            </label>  科研人员
                                            <label><input type="checkbox" name="Jobs"
                                                          value="4" ${consumer.userJob & 4 ? 'checked' : ' '}>
                                            </label> 行政管理人员
                                            <label><input type="checkbox" name="Jobs"
                                                          value="8" ${consumer.userJob & 8 ? 'checked' : ' '}>
                                            </label>教辅管理人员
                                            <label><input type="checkbox" name="Jobs"
                                                          value="16" ${consumer.userJob & 16 ? 'checked' : ' '}>
                                            </label>学生
                                            <label><input type="checkbox" name="Jobs"
                                                          value="32" ${consumer.userJob & 32 ? 'checked' : ' '}>
                                            </label>其他
                                        </TD>
                                    </TR>
                                    <TR class=table_tr>
                                        <TD height="29" align=left>&nbsp;学&nbsp;&nbsp;&nbsp;&nbsp;历<FONT
                                                color=red>*</FONT></TD>
                                        <TD colspan="3" align=left><label></label>
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
                                        </TD>
                                    </TR>
                                    <TR class=table_tr>
                                        <TD height="29" align=left>&nbsp;职&nbsp;&nbsp;&nbsp;&nbsp;称<FONT
                                                color=red>*</FONT></TD>
                                        <TD colspan="3" align=left>
                                            <label><input type="checkbox" name="zc"
                                                          value="1" ${consumer.jobName & 1 ? 'checked' : ' '}>
                                            </label> 助教
                                            <label><input type="checkbox" name="zc"
                                                          value="2" ${consumer.jobName & 2 ? 'checked' : ' '}></label>讲师
                                            <label><input type="checkbox" name="zc"
                                                          value="4" ${consumer.jobName & 4 ? 'checked' : ' '}>
                                            </label>副教授
                                            <label><input type="checkbox" name="zc"
                                                          value="8" ${consumer.jobName & 8 ? 'checked' : ' '}></label>教授
                                            <label><input type="checkbox" name="zc"
                                                          value="16" ${consumer.jobName & 16 ? 'checked' : ' '}>
                                            </label> 硕士生导师
                                            <label><input type="checkbox" name="zc"
                                                          value="32" ${consumer.jobName & 32 ? 'checked' : ' '}>
                                            </label>博士生导师
                                            <label><input type="checkbox" name="zc"
                                                          value="64" ${consumer.jobName & 64 ? 'checked' : ' '}>
                                            </label>其他
                                        </TD>
                                    </TR>
                                    <TR class=table_tr>
                                        <TD height="31" align=middle><div align="left">&nbsp;所在院系<FONT
                                                color=red>*</FONT></div></TD>
                                        <TD colspan="3" align=left>&nbsp;
                                            <select name="applyCollege" id="applyCollege">
                                                <option value="${fieldValue(bean: consumer, field: 'college.id')}">${fieldValue(bean: consumer, field: 'college.name')}</option>
                                                <g:each in="${collegeList}" var="college">
                                                    <option value="${college.id}">${college.name}</option>
                                                </g:each>
                                            </select>
                                        </TD>
                                    </TR>
                                    <TR class=table_tr>
                                        <TD align=middle><div align="left">&nbsp;联系电话<FONT color=red>*</FONT></div></TD>
                                        <TD align=left>&nbsp; <input type="text" maxlength="40" id="telephone"
                                                                     name="telephone"
                                                                     value="${fieldValue(bean: consumer, field: 'telephone')}"/>
                                        </TD>
                                        <TD align=middle><div align="left">&nbsp;Email地址<FONT color=red>*</FONT></div>
                                        </TD>
                                        <TD align=left>&nbsp; <input type="text" id="email" name="email"
                                                                     value="${fieldValue(bean: consumer, field: 'email')}"/>
                                        </TD>
                                    </TR></TBODY></TABLE></TD></TR>
                        <TR>
                            <TD height=22></TD>
                        </TR>
                        <TR>
                            <TD align=middle></TD></TR>
                        <TR>
                            <TD height=12><div align="center">
                                <g:if test="${consumer.uploadState == 0}">
                                    <INPUT class="button_input" type="button" value="申    请" name="app"
                                           onClick="apply()">
                                </g:if>
                                <g:else>
                                    <INPUT class="button_input" type="button" value="己申请" name="app">
                                </g:else>
                            </div></TD>
                        </TR></TBODY></TABLE>
                </TD></TR></TBODY></TABLE></form>
</DIV>
</BODY></HTML>
