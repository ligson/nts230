<%@ page import="nts.system.domain.Directory" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <link href="${createLinkTo(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>

    <title>类库列表</title>
    <style type="text/css">
    <!--
    .STYLE1 {
        color: #8B0D11;
        font-weight: bold;
        font-size: 12px;
    }

    .STYLE4 {
        font-family: "宋体", serif;
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

    .button {
        color: #2e5b88;
        background: url("${resource(dir: 'skin/blue/pc/images',file: 'but_3.png')}") repeat-x;
        padding: 3px 15px;
        border: 1px solid #8fb2da;
        border-radius: 3px;
        height: 20px;
        overflow: visible;
        cursor: pointer;
    }

    .button:hover {
        background: url("${resource(dir: 'skin/blue/pc/images',file:'but_4.png')}") repeat-x;
        padding: 3px 15px;
        cursor: pointer;
    }

    .list_bg {
        border-top: #e2e2e2 1px solid;;
    }

    .list_bg td {
        background: url("${resource(dir: 'skin/blue/pc/images',file: 'th_bg.png')}") repeat-x;
        border-right: #e2e2e2 1px solid;
        border-bottom: #e2e2e2 1px solid;
        font-size: 14px;
        text-indent: 2em;
        text-align: left;
    }

    .add_list tr {

        height: 20px;
        line-height: 25px;
    }

    .add_list td {
        margin-top: 10px;
        font-size: 14px;
    }

    .alert_infor {
        color: #e74f04;
        font-size: 14px;
        height: 20px;
        line-height: 20px;
        background: #f4f4f4;
        padding: 10px 0 0 0;
        font-weight: bold
    }

    -->
    </style>

    <script LANGUAGE="javascript">

        function myGroupAdd() {

            if (directoryForm.name.value == "") {
                alert("请输入类库名称");
                directoryForm.name.focus();
                return false;
            }
            if (directoryForm.name.value.length > 20) {
                alert("类库名称不大于20字符");
                directoryForm.name.focus();
                return false;
            }
            if (directoryForm.showOrder.value == "") {
                alert("请输入排列序号");
                directoryForm.showOrder.focus();
                return false;
            }
            if (directoryForm.description.value.length > 200) {
                alert("备注不大于200个字符");
                directoryForm.description.focus();
                return false;
            }

            directoryForm.action = "directorySave";
            directoryForm.submit();
        }
        function showInfo(id, name, showOrder) {
            var description = eval("directoryForm.bz" + id + ".value");
            img1.style.visibility = 'visible';
            img1.style.height = 300;
            addTable.style.visibility = 'hidden';
            addTable.style.height = 0;
            directoryForm.updateId.value = id;
            directoryForm.updateName.value = name;
            directoryForm.updateShowOrder.value = showOrder;
            directoryForm.updateDescription.value = description;
            img1.style.display = 'block';
            addTable.style.display = 'none';
        }

        function myGroupUpdate() {
            if (directoryForm.updateName.value == "") {
                alert("请输入类库名称");
                directoryForm.updateName.focus();
                return false;
            }
            if (directoryForm.updateName.value.length > 20) {
                alert("类库名称不大于20字符");
                directoryForm.updateName.focus();
                return false;
            }
            if (directoryForm.updateShowOrder.value == "") {
                alert("请输入排列序号");
                directoryForm.updateShowOrder.focus();
                return false;
            }
            if (directoryForm.updateDescription.value.length > 200) {
                alert("备注不大于200个字符");
                directoryForm.updateDescription.focus();
                return false;
            }

            directoryForm.action = "directoryUpdate";
            directoryForm.submit();
        }
        function showinfo() {
            alert("无权操作");
        }

        function onlyNum() {
            if (event.keyCode > 57 || event.keyCode < 48 && event.keyCode != 46)
                return false;
            return true;
        }


    </script>

</head>

<body>

<form method="post" name="directoryForm" id="directoryForm" enctype="multipart/form-data">
<input type="hidden" name="offset" value="${params.offset}"/>
<input type="hidden" name="sort" value="${params.sort}"/>
<input type="hidden" name="order" value="${params.order}"/>
<input type="hidden" name="max" value="${params.max}"/>


<div class="alert_infor"><span style="margin-left: 15px;">请不要轻易删除类库,删除类库后,类库下所有资源均被删除！</span></div>
<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>
<g:hasErrors bean="${directory}">
    <div class="errors">
        <g:renderErrors bean="${directory}" as="list"/>
    </div>
</g:hasErrors>
<div id="addTable">
    <div style="width:98%; margin-left: 15px;overflow: hidden;">
        <table width="98%" border="0" cellspacing="0">
            <tr>
                <td align="left"><span style="margin-left: 10px; font-weight: bold; color: #000;">添加类库</span></td>
            </tr>
        </table>
        <table width="96%" border="1" cellpadding="0" cellspacing="0" bordercolor="#E9E8E7" class="add_list">

            <tr>
                <td width="10%" height="15" rowspan="2" align="center">类库名称 :</td>
            </tr>
            <tr>
                <td colspan="3"><input id="name" name="name" maxLength="20" type="text" class="input1" size="52"/></td>
            </tr>
            <tr>
                <td width="10%" height="15" rowspan="2" align="center">排列序号 :</td>
            </tr>
            <tr>
                <td colspan="3">
                    <input type="text" id="showOrder" maxLength="5" name="showOrder" class="input1" size="52" value=""
                           onkeyup="this.value = this.value.replace(/\D/g, '')"
                           onafterpaste="this.value = this.value.replace(/\D/g, '')"/>(序号小的排前面，序号为0时不显示)
                </td>
            </tr>
            <tr>
                <td width="10%" height="15" rowspan="2" align="center">图片 :</td>
            </tr>
            <tr>
                <td colspan="3"><input name="saveImg" id="saveImg" type="file" size="30"></td>
            </tr>
            <tr>
                <td align="center">备注:</td>
                <td width="76%"><textarea id="description" name="description" cols="50" rows="2"></textarea>
                </td>
                <td width="5%" align="center">
                    <g:if test="${session.consumer.role == 0}">
                        <input name="groupAdd" type="button" class="button" onClick="myGroupAdd()" value="添加"/>
                    </g:if>
                    <g:else>
                        <input name="groupAdd" type="button" class="button" onClick="showinfo()" value="添加"/>
                    </g:else>
                </td>
            </tr>
        </table>
    </div>
</div>

<div style="margin-left: 15px; width: 96%; margin-bottom: 0; overflow: hidden; ">
    <table width="96%" border="0" style="margin-top: 15px;" cellspacing="0">
        <tr>
            <td align="left"><span class="zi-cu">已有类库</span></td>
        </tr>
    </table>
    <table width="96%" border="0" style="margin-top: 15px;">
        <tr>
            <td><table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                <tr bgcolor="#BDEDFB" class="list_bg">
                    <td width="5%" height="28" align="center" class="STYLE5">${Directory.cnTableName}名称</td>
                    <td width="2%" align="center" class="STYLE5">${Directory.cnTableName}ID</td>
                    <td width="2%" align="center" class="STYLE5">序号</td>
                    <td width="7%" align="center" class="STYLE5">备注</td>
                    <td width="3%" align="center" class="STYLE5">创建时间</td>
                    <td width="2%" align="center" class="STYLE5">修改</td>
                    <td width="2%" align="center" class="STYLE5">删除</td>
                </tr>
                <g:each in="${directoryList}" status="i" var="directory">
                    <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                        <td height="23" align="center" nowrap="nowrap"
                            class="STYLE5">${fieldValue(bean: directory, field: 'name')}</td>
                        <td align="center" nowrap="nowrap"
                            class="STYLE5">${fieldValue(bean: directory, field: 'id')}</td>
                        <td align="center" nowrap="nowrap"
                            class="STYLE5">${fieldValue(bean: directory, field: 'showOrder')}</td>
                        <td align="center" class="STYLE5">${fieldValue(bean: directory, field: 'description')}</td>
                        <td align="center" class="STYLE5"><g:formatDate format="yyyy-MM-dd"
                                                                        date="${directory.dateCreated}"/></td>
                        <td align="center" class="STYLE5">
                            <g:if test="${session.consumer.role == 0}">
                                <a href="javascript:void(0)"
                                   onClick="showInfo('${directory.id}', '${directory.name}', '${directory.showOrder}')"><img
                                        src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" width="14" height="14" border="0"></a>
                            </g:if>
                            <g:else>
                                <a href="javascript:void(0)" onClick='showinfo()'><img src="${resource(dir: 'images/skin', file: 'modi.gif')}"
                                                                                       border="0" width="11"
                                                                                       height="13"/></a>
                            </g:else>
                        </td>
                        <td align="center" class="STYLE5">
                            <g:if test="${session.consumer.role == 0}">
                                <g:link action="directoryDelete" id="${directory.id}"
                                        onclick="return confirm('确定删除${fieldValue(bean: directory, field: 'name')}资源库吗?删除类库后，类库下所有资源均被删除！');"
                                        params="${[sort: params.sort, max: params.max, order: params.order, offset: params.offset]}"><img
                                        src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0" width="11" height="13"/></g:link>
                            </g:if>
                            <g:else>
                                <a href="javascript:void(0)" onClick='showinfo()'><img src="${resource(dir: 'images/skin', file: 'delete.gif')}"
                                                                                       border="0" width="11"
                                                                                       height="13"/></a>
                            </g:else>
                        </td>
                    </tr>
                    <input type="hidden" name="bz${directory.id}" value="${directory.description}"/>
                </g:each>

            </table>
                <table width="93%" height="35" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td align="left" width="10%">&nbsp;</td>
                        <td align="right">&nbsp;</td>
                    </tr>
                </table>
                <TABLE width="100%" height="16"
                       border=0 cellPadding=1 cellSpacing=1 bgcolor="#E9E8E7">
                    <TBODY>
                    <TR>
                        <TD width="693" height="16" align="center"><div align="left">
                            <g:link action="directoryList" params="${[max: 10]}"><IMG id="Img10"
                                                                                      src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}"
                                                                                      alt="每页显示10条" width=19 height=16
                                                                                      border=0
                                                                                      class="STYLE8"
                                                                                      title="每页显示10条"></g:link>&nbsp;
                            <g:link action="directoryList" params="${[max: 50]}"><IMG id="Img50"
                                                                                      src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}"
                                                                                      alt="每页显示50条" width=20 height=15
                                                                                      border=0
                                                                                      class="STYLE8"
                                                                                      title="每页显示50条"></g:link>&nbsp;
                            <g:link action="directoryList" params="${[max: 100]}"><IMG id="Img100"
                                                                                       src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}"
                                                                                       alt="每页显示100条" width="27"
                                                                                       height="16"
                                                                                       border=0 class="STYLE8"
                                                                                       title="每页显示100条"></g:link>
                            <g:link action="directoryList" params="${[max: 200]}"><IMG id="Img200"
                                                                                       src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}"
                                                                                       alt="每页显示200条" width="28"
                                                                                       height="16"
                                                                                       border=0 class="STYLE8"
                                                                                       title="每页显示200条"></g:link></div>
                        </TD>
                        <TD width=11>&nbsp;</TD>
                        <TD width="425" align=right><div class="STYLE8">
                            <g:paginate total="${total}" offset="${params.offset}" action="directoryList"
                                        params="${[sort: params.sort, max: params.max, order: params.order, offset: params.offset]}"/>&nbsp;&nbsp;
                        </TD>
                    </TR>
                    </TBODY>
                </TABLE>
    </table>
</div>


<div align="left" name="img1" id="img1"
     style="display: none">
    <input type="hidden" name="updateId" value=""/>

    <div style="margin-left: 15px;  width: 96%; margin-bottom: 0; overflow: hidden; ">
        <table width="96%" border="0" cellspacing="0">
            <tr>
                <td align="left"><span class="zi-cu">修改类库</span></td>
            </tr>
        </table>

        <table width="96%" border="1" cellspacing="0" style="margin-bottom: 5px;" cellpadding="0" bordercolor="#ECF0ED"
               bgcolor="#ffffff">
            <tr>
                <td width="15%" height="15" rowspan="2" align="center">类库名称</td>
            </tr>
            <tr>
                <td colspan="3"><input name="updateName" maxLength="20" type="text" class="input1"
                                       size="42"/></td>
            </tr>
            <tr>
                <td width="10%" height="15" rowspan="2" align="center">排列序号</td>
            </tr>
            <tr>
                <td colspan="3"><input name="updateShowOrder" maxLength="5" type="text" class="input1"
                                       size="10" onKeyUp="this.value = this.value.replace(/\D/g, '')"
                                       onafterpaste="this.value = this.value.replace(/\D/g, '')"/>
                    (序号小的排前面，序号为0时不显示)</td>
            </tr>
            <tr>
                <td width="10%" height="15" rowspan="2" align="center">图片</td>
            </tr>
            <tr>
                <td colspan="3"><input name="updateImg" id="updateImg" type="file" size="30"></td>
            </tr>
            <tr>
                <td width="10%" align="center">备注</td>
                <td><textarea name="updateDescription" cols="40" rows="2"></textarea></td>
            </tr>
            <tr>
                <td width="10%" height="37" align="center"><input name="update_enter" type="button" class="button"
                                                                  onClick="myGroupUpdate()"
                                                                  value="确定"/></td>
                <td align="left"><input name="update_cancel" type="button" class="button"
                                        onClick="img1.style.visibility = 'hidden'" value="取消"/></td>
            </tr>
        </table>

    </div>
</div>

</form>
<script Language="JavaScript">
    changePageImg(${params.max});
</script>
</body>
</html>

