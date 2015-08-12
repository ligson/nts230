<html>
<head>

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>

    <title>条件选择页面</title>
    <script Language="JavaScript">
        function search() {
            var _role = "5";
            var _tag = "";
            var checkBoxs = document.getElementsByName("searchRole");
            for (var i = 0; i < checkBoxs.length; i++) {
                if (checkBoxs[i].checked) {
                    _role = _role + ',' + checkBoxs[i].value;
                    _tag = checkBoxs[i].value;
                }
            }

            if (_tag != false) {
                searchForm.roleList.value = _role;
            }

            if (searchForm.selectState.checked) {
                searchForm.selectState.value = true;
            }

            if (searchForm.selectUpload.checked) {
                searchForm.selectUpload.value = true;
            }
            if (searchForm.selectDownload.checked) {
                searchForm.selectDownload.value = true;
            }
            if (searchForm.selectExamine.checked) {
                searchForm.selectExamine.value = true;
            }

            searchForm.action = "searchConsumer";
            searchForm.submit();
        }
        $(function () {
            $("#dateBegin").datepicker();
            $("#dateEnd").datepicker();
        })
    </script>
</head>

<body style="background:#fff;">
<g:form name="searchForm" method="post" action="">
    <input type="hidden" name="roleList" value="">



    <div align="center">

        <TABLE width="630" border=0 align="center" cellPadding=0 cellSpacing=0>
            <TR>
                <TD background="${resource(dir: 'images/skin', file: 'text_title_search.gif')} " height=60>&nbsp;</TD>
            </TR>
        </TABLE>

        <TABLE cellSpacing=1 cellPadding=0 width="630" border=0>
            <TR class=table_tr>
                <TD width="25%" height="29" align=middle>按基本信息查询</TD>
                <TD align="left" width="30%">&nbsp;  每页显示<input type="text" name="row" value="20" size="2"/>行</TD>
                <TD width="45%" align=middle colspan="3"></TD>
            </TR>

            <TR class=table_tr>
                <TD width="7%" height="29" align=middle>&nbsp;用户帐号</TD>
                <TD align=left width="15%">&nbsp; <input type="text" name="searchName" value=""/></TD>
                <TD width="7%" align="left" colspan="3">&nbsp;<input name="searchType" type="radio" value="2"
                                                                     checked="true"/>模糊查询   <input name="searchType"
                                                                                                   type="radio"
                                                                                                   value="1"/>全字匹配</TD>
            </TR>

            <TR class=table_tr>
                <TD width="7%" height="29" align=middle>&nbsp;用户姓名</TD>
                <TD align=left width="15%">&nbsp; <input type="text" name="searchTrueName" value=""/></TD>
                <TD width="7%" align="left" colspan="3">&nbsp;</TD>
            </TR>

            <TR class=table_tr>
                <TD height="29" align=middle>&nbsp;按角色查询</TD>
                <TD colspan="4" align=left>
                    <label><input name="searchRole" type="checkbox" value="1">  资源管理员
                        <label><input name="searchRole" type="checkbox" value="2"> 老师
                            <label><input name="searchRole" type="checkbox" value="3"> 学生
                </TD>
            </TR>

            <TR class=table_tr>
                <TD height="29" align=middle>&nbsp;创建时间&nbsp;</TD>
                <TD colspan="4" align=left>&nbsp;
                    <input name="dateBegin" id="dateBegin" readonly="" type="text" value="">&nbsp;至
                &nbsp;<input name="dateEnd" id="dateEnd" readonly="" type="text" value="">
                </TD>
            </TR>

            <TR class=table_tr>
                <TD height="29" align=middle>&nbsp;所属院系&nbsp;</TD>
                <TD colspan="4" align=left>&nbsp;
                    <select name="searchCollege" id="searchCollege">
                        <option value="">--选择院系--</option>
                        <g:each in="${collegeList}" var="college">
                            <option value="${college.id}">${college.name}</option>
                        </g:each>
                    </select>
                </TD>
            </TR>

            <TR class=table_tr>
                <TD height="29" align=middle>&nbsp;选择权限&nbsp;</TD>
                <TD colspan="4" align=left>
                    <table width="80%" border="0" align="left" cellpadding="2" cellspacing="2">
                        <tr>
                            <td class="table_tr"><input name="selectUpload" type="checkbox" value="">&nbsp;上传状态</td>
                            <td class="table_tr">
                                <input name="searchUpload" type="radio" value="1" checked="true">&nbsp;允许
                                <input name="searchUpload" type="radio" value="2">&nbsp;申请
                                <input name="searchUpload" type="radio" value="0">&nbsp;禁止
                        </tr>
                        <tr>
                            <td class="table_tr"><input name="selectDownload" type="checkbox" value="">&nbsp;下载状态</td>
                            <td class="table_tr">
                                <input name="searchDownload" type="radio" value="1">&nbsp;启用
                                <input name="searchDownload" type="radio" value="0" checked="true">&nbsp;禁止
                            </td>
                        </tr>
                        <tr>
                            <td class="table_tr"><input name="selectState" type="checkbox" value="">&nbsp;锁定状态</td>
                            <td class="table_tr">
                                <input name="searchState" type="radio" value="1" checked="true">&nbsp;启用
                                <input name="searchState" type="radio" value="0">&nbsp;锁定
                            </td>
                        </tr><tr>
                        <td class="table_tr"><input name="selectExamine" type="checkbox" value="">&nbsp;审核状态</td>
                        <td class="table_tr">
                            <input name="searchExamine" type="radio" value="0">&nbsp;审核
                            <input name="searchExamine" type="radio" value="1" checked="true">&nbsp;免审
                        </td>
                    </tr>

                    </table>
                </TD>
            </TR>
        </TR>
        </TABLE>
        <br>

        <div class="buttons" align="center">
            <span class="button"><input class="button_input" type="button" value="查 询" onClick="search()"/></span>&nbsp;
        </div>
    </div>
</g:form>
</body>
</html>
