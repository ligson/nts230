<%@ page import="nts.utils.CTools" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <!-- saved from url=(0048)http://www.supermap.com.cn/gb/solutions/emap.htm -->
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>

    <title>个人空间组管理</title>
    <style type="text/css">
    <!--
    .STYLE1 {
        color: #8B0D11;
        font-weight: bold;
        font-size: 12px;
    }

    .STYLE4 {
        font-family: "宋体";
        font-size: 12px;
    }

    .STYLE5 {
        font-size: 12px
    }

    .STYLE6 {
        color: #990000;
        font-weight: bold;
    }

    .STYLE8 {
        font-size: 12
    }

    .STYLE9 {
        color: #990000;
        font-weight: bold;
        font-size: 12px;

    }

    .list_bg {
        border-top: #e2e2e2 1px solid;

    }

    .list_bg td {
        background: url("${resource(dir: 'skin/blue/pc/images',file: 'th_bg.png')}") repeat-x;
        border-right: #e2e2e2 1px solid;
        border-bottom: #e2e2e2 1px solid;
        height: 25px;
        font-size: 12px;
        text-align: center;
        line-height: 30px;
    }

    .button {
        color: #2e5b88;
        background: url("${resource(dir: 'skin/blue/pc/images',file: 'but_3.png')}") repeat-x;
        padding: 3px 15px;
        border: 1px solid #8fb2da;
        border-radius: 3px;
        height: 25px;
        overflow: visible;
        cursor: pointer;
    }

    .button:hover {
        background: url("${resource(dir: 'skin/blue/pc/images',file:'but_4.png')}") repeat-x;
        padding: 3px 15px;
        cursor: pointer;
    }

    .add_group {
        padding-left: 30px;
    }

    #addTable {
        padding: 0;
    }

    -->
    </style>

    <script LANGUAGE="javascript">

        function GroupAdd() {
            if (GroupForm.name.value == "") {
                alert("组名不能为空");
                GroupForm.name.focus();
                return false;
            }
            if (GroupForm.name.value.length > 20) {
                alert("组名长度不大于20");
                GroupForm.name.focus();
                return false;
            }
            if (GroupForm.description.value.length > 50) {
                alert("备注不大于50个字符");
                GroupForm.description.focus();
                return false;
            }

            GroupForm.action = "userGroupSave";
            GroupForm.submit();
        }

    </script>

</head>

<body>
<form method="post" name="GroupForm" id="myGroupForm">
<div class="programMgrMain" style="width: 98%; margin: 10px 0 0 10px;>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${userGroup}">
        <div class="errors">
            <g:renderErrors bean="${userGroup}" as="list"/>
        </div>
    </g:hasErrors>
    <div id="addTable">
        <table width="100%" border="0" cellspacing="0">
            <tr>
                <td height="26" align="left" valign="middle" class="zi-cu"
                    style="font-size: 14px; font-weight:bold ">添加用户组</td>
            </tr>
        </table>
        <table width="100%" class="table">

            <tr>
                <td width="110" align="right">组名:</td>
                <td><input id="name" name="name" maxLength="20" type="text" class="form-control" style="width: 200px"/>
                </td>
            </tr>
            <tr>
                <td align="right">备注:</td>
                <td><textarea id="description" style="font-size: 12px;" name="description" cols="50"
                              class="form-control"
                              rows="3"></textarea></td>
            </tr>
            <tr>
                <td></td>
                <td align="left"><input name="groupAdd" type="button" class="btn btn-primary"
                                        onClick="GroupAdd()"
                                        value="添加"/>
                </td>
            </tr>

        </table>
    </div>
</div>
</form>
</body>
</html>

