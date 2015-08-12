<%@ page import="nts.utils.CTools" %>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <!-- saved from url=(0048)http://www.supermap.com.cn/gb/solutions/emap.htm -->
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'zxm.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <link href="${resource(dir: 'skin/blue/pc/admin/css', file: 'style_my.css')}">
    <title>无标题文档</title>
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

    -->

    </style>

    <script LANGUAGE="javascript">
        function openwin() {
            window.open("grkj_um_modify.html", "newwindow", "height=100,width=700,top=600,left=300,toolbar=no,menubar=no,scrollbars=auto,resizable=no, location=no,status=no")
        }

        function myGroupAdd() {
            if (myGroupForm.name.value == "") {
                alert("组名不能为空");
                myGroupForm.name.focus();
                return false;
            }
            if (myGroupForm.name.value.length > 20) {
                alert("组名不超过20个字符");
                myGroupForm.name.focus();
                return false;
            }
            if (myGroupForm.description.value.length > 100) {
                alert("备注不超过100个字符");
                myGroupForm.description.focus();
                return false;
            }

            myGroupForm.action = "myGroupSave";
            myGroupForm.submit();
        }
        function showInfo(id, name, description) {

            img1.style.visibility = 'visible';
            addTab.style.visibility = "hidden";
            $("#addTab").css("height", "0");
            $("#img1").css("height", "100");
            myGroupForm.updateId.value = id;
            myGroupForm.updateName.value = name;
            myGroupForm.updateDescription.value = description;

        }

        function myGroupUpdate() {
            if (myGroupForm.updateName.value == "") {
                alert("组名不能为空");
                myGroupForm.updateName.focus();
                return false;
            }
            if (myGroupForm.updateName.value.length > 20) {
                alert("组名不超过20个字符");
                myGroupForm.updateName.focus();
                return false;
            }
            if (myGroupForm.updateDescription.value.length > 100) {
                alert("备注不超过100个字符");
                myGroupForm.updateDescription.focus();
                return false;
            }

            myGroupForm.action = "myGroupUpdate";
            myGroupForm.submit();
        }

    </script>

</head>

<body style="background:#fff;overflow-x: hidden; ">
<form method="post" name="myGroupForm" id="myGroupForm">

    <input type="hidden" name="offset" value="${params.offset}"/>
    <input type="hidden" name="sort" value="${params.sort}"/>
    <input type="hidden" name="order" value="${params.order}"/>
    <input type="hidden" name="max" value="${params.max}"/>

    <div id="main-content">
        <div class="content-box">
            <div class="x_daohang">
                <p>当前位置：<a href="${createLink(controller: 'my', action: 'myInfo')}">个人空间</a>>><a href="${createLink(controller: 'my', action: 'myGroupList')}">用户管理</a>>> 用户组管理</p>
            </div>
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${userGroup}">
                <div class="errors">
                    <g:renderErrors bean="${userGroup}" as="list"/>
                </div>
            </g:hasErrors>

            <table width="95%" border="0" cellspacing="0">
                <tr>
                    <td align="left"><font><span class="zi-cu">添加用户组</span></font></td>
                </tr>
            </table>

            <div id="addTab">
                <table width="95%" border="1" cellpadding="0" cellspacing="0" bordercolor="#E9E8E7">

                    <tr>
                        <td width="10%" height="15" rowspan="2" align="center">组名:</td>
                    </tr>
                    <tr>
                        <td colspan="3"><input id="name" maxLength="20" name="name" type="text" class="input"/></td>
                    </tr>
                    <tr>
                        <td align="center">备注:</td>
                        <td width="76%"><textarea id="description" name="description" cols="50" rows="2"
                                                  class="input"></textarea></td>
                        <td width="5%" align="center"><input name="groupAdd" type="button" class="button"
                                                             onClick="myGroupAdd()" value="添加"/>
                        </td>
                    </tr>

                </table>
            </div>


            <div align="left" name="img1" id="img1"
                 style="width:400; height:0; left:450px; top:260px; z-index:1;visibility: hidden">
                <input type="hidden" name="updateId" value=""/>
                <table width="95%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF" bgcolor="#ECF0ED">
                    <tr>
                        <td width="10%" height="15" rowspan="2" align="center">组名</td>
                    </tr>
                    <tr>
                        <td colspan="3"><input name="updateName" maxLength="20" type="text" class="input"/></td>
                    </tr>
                    <tr>
                        <td width="10%" align="center">备注</td>
                        <td><textarea name="updateDescription" cols="40" rows="10" class="input"></textarea></td>
                    </tr>

                    <tr>
                        <td width="10%" align="center">
                            <input name="update_enter" type="button" class="button" onClick="myGroupUpdate()"
                                   value="确定"/></td>
                        <td align="left">
                            <input name="update_cancel" type="button" class="button"
                                   onClick="img1.style.visibility = 'hidden'" value="取消"/></td>
                    </tr>
                </table>
            </div>

            <br>
            <table width="95%" border="0" cellspacing="0">
                <tr>
                    <td align="left"><font><span class="zi-cu">已有用户组</span></font></td>
                </tr>
            </table>
            <table width="95%">
                <tr>
                    <td><table width="95%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                        <tr bgcolor="#BDEDFB">
                            <td width="9%" height="28" align="center" class="STYLE5">组名</td>
                            <td width="12%" align="center" class="STYLE5">备注</td>
                            <td width="5%" align="center" class="STYLE5">修改组名和备注</td>
                            <td width="4%" align="center" class="STYLE5">导入组成员</td>
                            <td width="4%" align="center" class="STYLE5">管理组成员</td>
                            <td width="3%" align="center" class="STYLE5">删除</td>
                        </tr>
                        <g:each in="${userGroupList}" status="i" var="userGroup">
                            <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                                <td height="23" align="center" nowrap="nowrap"
                                    class="STYLE5">${CTools.cutString(fieldValue(bean: userGroup, field: 'name'), 10)}</td>
                                <td align="center" nowrap="nowrap"
                                    class="STYLE5">${CTools.cutString(CTools.htmlToBlank(fieldValue(bean: userGroup, field: 'description')), 20)}</td>
                                <td align="center" class="STYLE5"><a href="javascript:void(0)"
                                                                     onClick="showInfo('${userGroup.id}', '${userGroup.name}', '${userGroup.description}')"><img
                                            src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" width="14" height="14" border="0">
                                </a></td>
                                <td align="center" class="STYLE5"><g:link action="groupSelectPage" controller="my"
                                                                          params="${[groupId: userGroup.id, submitTag: 'clint']}"><img
                                            src="${resource(dir: 'images/skin', file: 'downs.jpg')}" title="导入" width="13" height="11"
                                            border="0"></g:link></td>
                                <td align="center" class="STYLE5"><g:link action="myGroupConsumerList"
                                                                          params="${[groupId: userGroup.id]}"><img
                                            src="${resource(dir: 'images/skin', file: 'xianshi.gif')}" alt="" width="14" height="16"
                                            border="0"/></g:link></td>
                                <td align="center" class="STYLE5"><g:link action="myGroupDelete" id="${userGroup.id}"
                                                                          onclick="return confirm('确定删除?');"
                                                                          params="${[sort: params.sort, max: params.max, order: params.order, offset: params.offset]}"><img
                                            src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0" width="11"
                                            height="13"/></g:link></td>
                            </tr>
                        </g:each>

                    </table>
                        <table width="93%" height="35" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td align="left" width="10%">&nbsp;</td>
                                <td align="right">&nbsp;</td>
                            </tr>
                        </table>
                        <TABLE width="95%" height="16"
                               border=0 cellPadding=1 cellSpacing=1 bgcolor="#E9E8E7">
                            <TBODY>
                            <TR>
                                <TD height="16" align="center"><div align="left"><span class="STYLE5">总共：<span
                                        class="STYLE6">${total}</span>个用户组&nbsp;&nbsp;&nbsp;每页显示:</span>
                                    <g:link action="myGroupList" params="${[max: 10]}"><IMG id="Img10"
                                                                                            src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}"
                                                                                            border=0 class="STYLE8"
                                                                                            title="每页显示10条"></g:link>&nbsp;
                                    <g:link action="myGroupList" params="${[max: 50]}"><IMG id="Img50"
                                                                                            src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}"
                                                                                            border=0 class="STYLE8"
                                                                                            title="每页显示50条"></g:link>&nbsp;
                                    <g:link action="myGroupList" params="${[max: 100]}"><IMG id="Img100"
                                                                                             src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}"
                                                                                             border=0 class="STYLE8"
                                                                                             title="每页显示100条"></g:link>
                                    <g:link action="myGroupList" params="${[max: 200]}"><IMG id="Img200"
                                                                                             src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}"
                                                                                             border=0 class="STYLE8"
                                                                                             title="每页显示200条"></g:link>
                                </div></TD>

                                <TD align=right><div class="STYLE8">
                                    <g:paginate total="${total}" offset="${params.offset}" action="myGroupList"
                                                params="${[sort: params.sort, max: params.max, order: params.order, offset: params.offset]}"/>&nbsp;&nbsp;
                                </TD>
                            </TR>
                            </TBODY>
                        </TABLE>

                        <p>&nbsp;</p>

                        <p><br/>
                        </p>

            </table>

        </div>
    </div>
</form>

<script Language="JavaScript">
    changePageImg(${params.max});
</script>
</body>
</html>

