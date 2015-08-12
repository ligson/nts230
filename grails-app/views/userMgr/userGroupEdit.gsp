<%@ page import="nts.utils.CTools" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <!-- saved from url=(0048)http://www.supermap.com.cn/gb/solutions/emap.htm -->
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'userGroupEdit.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>

    <title>个人空间组管理</title>

    <script LANGUAGE="javascript">

        function myGroupUpdate() {

            if (GroupForm.updateName.value == "") {
                alert("组名不能为空");
                GroupForm.updateName.focus();
                return false;
            }
            if (GroupForm.updateName.value.length > 20) {
                alert("组名长度不大于20");
                GroupForm.updateName.focus();
                return false;
            }
            if (GroupForm.updateDescription.value.length > 50) {
                alert("备注不大于50个字符");
                GroupForm.updateDescription.focus();
                return false;
            }

            GroupForm.action = "userGroupUpdate";
            GroupForm.submit();
        }

    </script>

</head>

<body>
<form method="post" name="GroupForm" id="myGroupForm">
    <div class="programMgrMain" style="width: 98%; margin: 10px 0 0 10px;>
    <div id=" addTable">
    <table width="100%" border="0" cellspacing="0">
        <tr>
            <td height="26" align="left" valign="middle" class="zi-cu">修改用户组</td>
        </tr>
    </table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">

        <tr>
            <td width="130" height="15" rowspan="2" align="center">组名:</td>
        </tr>
        <tr>
            <td colspan="3"><input id="updateName" name="updateName" maxLength="20" type="text" class="form-control"
                                   value="${userGroupInstance.name}"/></td>
        </tr>
        <tr>
            <td align="center">备注:</td>
            <td><textarea class="form-control" id="updateDescription" style="font-size: 12px;" name="updateDescription"
                          cols="50"
                          rows="3">${CTools.htmlToBlank(userGroupInstance.description)}</textarea></td>

        </tr>
        <tr>
            <td></td>
            <td align="left" valign="bottom"><input name="groupAdd" type="button" class="btn btn-primary"
                                                    onClick="myGroupUpdate()"
                                                    value="修改"/>
            </td>
        </tr>

    </table>
</div>
</div>
    <input type="hidden" name="updateId" value="${groupId}">
    <input type="hidden" name="editPage" value="${editPage}">
</form>
</body>
</html>

