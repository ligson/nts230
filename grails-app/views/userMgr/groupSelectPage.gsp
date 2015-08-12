<html>
<head>
    <link href="${createLinkTo(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" rel="stylesheet"
          type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>

    <title>条件选择页面</title>
    <script Language="JavaScript">

        function search() {
            if (searchForm.numBegin.value != "" || searchForm.numEnd.value != "") {
                if (searchForm.numBegin.value == "" || searchForm.numEnd.value == "") {
                    alert("请给定要查找的学号范围！");
                    return false;
                }
            }

            searchForm.action = "groupSelectList";
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
    <input type="hidden" name="submitTag" value="${params.submitTag}">
    <input type="hidden" name="roleList" value="">

    <div>

        <TABLE width="630" border=0 align="center" cellPadding=0 cellSpacing=0>
            <TR>
                <TD><p style="font-size: 16px;margin: 10px 0">查询条件</p></TD>
            </TR>
        </TABLE>

        <table class="table">
            <tr class=table_tr>
                <td align="right" width="150">按基本信息查询</TD>
                <TD align="left" width="300"><input type="text" name="row" value="20" class="form-control"
                                                    style="width:60px" size="2"/></TD>
                <TD align="left"><span style="float: left">每页显示数量</span></TD>
            </TR>

            <TR class=table_tr>
                <TD align="right">用户帐号</TD>
                <TD align=left><input type="text" class="form-control" style="width: 200px" name="searchName" value=""/>
                </TD>
                <TD align="left" colspan="3">&nbsp;<input name="searchType" type="radio" value="2"
                                                          checked="true"/>模糊查询   <input name="searchType"
                                                                                        type="radio"
                                                                                        value="1"/>全字匹配</TD>
            </TR>

            <TR class=table_tr>
                <TD align="right">&nbsp;用户昵称</TD>
                <TD align=left><input type="text" class="form-control" style="width: 200px" name="searchNickname"
                                      value=""/></TD>
                <TD align="left" colspan="3">&nbsp;<input name="searchNNType" type="radio" value="2"
                                                          checked="true"/>模糊查询   <input name="searchNNType"
                                                                                        type="radio"
                                                                                        value="1"/>全字匹配</TD>
            </TR>
            <TR class=table_tr>
                <TD height="29" align="right">&nbsp;用户姓名</TD>
                <TD align=left><input type="text" class="form-control" style="width: 200px" name="searchTrueName"
                                      value=""/></TD>
                <TD align="left" colspan="3">&nbsp;</TD>
            </TR>

            <TR class=table_tr>
                <TD height="29" align="right">&nbsp;所属院系&nbsp;</TD>
                <TD colspan="4" align=left>
                    <select name="searchCollege" class="form-control" style="width: 100px" id="searchCollege">
                        <option value="">--选择院系--</option>
                        <g:each in="${collegeList}" var="college">
                            <option value="${college.id}">${college.name}</option>
                        </g:each>
                    </select>
                </TD>
            </TR>

            <TR class=table_tr>
                <TD height="29" align="right">&nbsp;创建时间&nbsp;</TD>
                <TD colspan="4" align=left>
                    <input name="dateBegin" id="dateBegin" readonly="" type="text" value="">
                    <span>&nbsp;&nbsp;至&nbsp;&nbsp;</span>
                    <input name="dateEnd" id="dateEnd" readonly="" type="text" value="">
                </TD>
            </TR>
            <TR class=table_tr>
                <TD height="29" align="right">&nbsp;学号范围&nbsp;</TD>
                <TD colspan="4" align=left>
                    <input name="numBegin" id="numBegin" type="text" value="" class="admin_default_inp"
                           style="width: 80px; float: left">
                    <span style="float: left">&nbsp;&nbsp;至&nbsp;&nbsp;</span>
                    &nbsp;<input name="numEnd" id="numEnd" type="text" value="" class="admin_default_inp"
                                 style="width: 80px; float: left">
                </TD>
            </TR>
            <tr>
                <td></td>
                <td>
                    <div class="buttons" align="left">
                        <input class="btn btn-primary" type="button" value="查 询" onClick="search()"/>
                    </div>
                </td>
            </tr>
        </TABLE>
    </div>
    <input type="hidden" name="groupId" value="${params.groupId}"/>
</g:form>
</body>
</html>
