<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" rel="stylesheet" type="text/css">
    <link href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}" rel="stylesheet" type="text/css">
    <title>查看组员信息</title>
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
        font-size: 12px;
    }

    .admin_nav_title span, .admin_nav_title label, .admin_nav_title select {
        float: left;
        margin-right: 15px;
    }

    .admin_nav_title {
        margin-top: 10px;
        margin-bottom: 10px;
    }

    .STYLE9 {
        color: #990000;
        font-weight: bold;
        font-size: 12px;
    }

    -->
    </style>
    <script LANGUAGE="javascript">
        function selectGroup() {
            consumerForm.groupId.value = consumerForm.groupList.value;
            consumerForm.action = "groupConsumerList";
            consumerForm.submit();
        }
        function cleard() {
            consumerForm.consumerId.value = "";
        }
        function addConsumer() {
            if (consumerForm.consumerId.value == '' || consumerForm.consumerId.value == '请输入用户ID') {
                alert("请输入用户ID");
                return false;
            }

            if (isNaN(consumerForm.consumerId.value)) {
                alert("请输入正确的用户ID");
                return false;
            }

            if (consumerForm.groupId.value == "") {
                alert("请选择用户组");
                return false;
            }
            consumerForm.groupId.value = consumerForm.groupList.value;
            consumerForm.action = "groupAddConsumerOne";
            consumerForm.submit();
        }
        function getKeyCode() {
            if (event.keyCode == 13) {
                addConsumer();
            }
        }

    </script>
</head>

<body>
<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>
<g:hasErrors bean="${userGroup}">
    <div class="errors">
        <g:renderErrors bean="${userGroup}" as="list"/>
    </div>
</g:hasErrors>

<form method="post" name="consumerForm">

    <div class="admin_nav_title">
        <span>请选择用户组</span>
        <label>
            <select name="groupList" class="admin_default_inp admin_default_inp_size2" onChange="selectGroup()"
                    id="groupList">
                <g:each in="${userGroupList}" var="groupList">
                    <option value="${groupList.id}"
                            <g:if test="${groupList.id == Integer.parseInt(groupId)}">selected</g:if>>${groupList.name}</option>
                </g:each>
            </select>
        </label>
        <span>添加用户</span>
        <label>
            <input name="consumerId" type="text" class="form-control" style="width: 120px"
                   onkeypress="getKeyCode()" onfocus="cleard()"
                   value="请输入用户ID" size="30">
        </label>
        <label>
            <input name="add" type="button" class="admin_default_but_yellow" onClick="addConsumer()" value="添加"/>
        </label>
    </div>
    <table class="table table-hover" width="90%" style="background: #FFF;float:left;">
        <tr>
            <th width="120" align="left">学号</th>
            <th width="150" align="left">姓名</th>
            <th align="left">所属院系</th>
            <th width="150" align="left">操作</th>
        </tr>
        <g:each in="${userGroupConsumerList}" status="i" var="consumer">
            <tr>
                <td align="left">${fieldValue(bean: consumer, field: 'name')}</td>
                <td align="left">${fieldValue(bean: consumer, field: 'nickname')}</td>
                <td align="left">${fieldValue(bean: consumer, field: 'college.name')}</td>
                <td align="left">
                    <g:link action="groupDeleteConsumerOne" id="${consumer.id}"
                            onclick="return confirm('确定删除用户?');"
                            params="${[groupId: groupId, sort: params.sort, max: params.max, order: params.order, offset: params.offset]}"><img
                            src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0" width="11" height="13"/></g:link></td>
            </tr>
        </g:each>
    </table>
    <table width="100%" style="float: left;">
        <tr>
            <td>

                <TABLE>
                    <TBODY>
                    <TR>
                        <TD width="693" height="16" align="center"><div align="left"><span
                                class="STYLE5"><input class="admin_default_but_blue" title="返回"
                                                      onclick="javascript:location.href = baseUrl + 'userMgr/userGroupList?editPage=${editPage}';"
                                                      type="button"
                                                      value="返回"/>&nbsp;&nbsp;&nbsp;&nbsp;总共：<span
                                    class="STYLE6">${total}</span>个用户&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当前显示：${pageNow}/${pageCount}页 每页${params.max}条 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;每页显示:
                        </span>
                            <g:link action="groupConsumerList" params="${[max: 10, groupId: groupId]}"><IMG id="Img10"
                                                                                                            src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}"
                                                                                                            alt=每页显示10条
                                                                                                            width=19
                                                                                                            height=16
                                                                                                            border=0
                                                                                                            class="STYLE8"
                                                                                                            title=每页显示10条></g:link>&nbsp;
                            <g:link action="groupConsumerList" params="${[max: 50, groupId: groupId]}"><IMG id="Img50"
                                                                                                            src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}"
                                                                                                            alt=每页显示50条
                                                                                                            width=20
                                                                                                            height=15
                                                                                                            border=0
                                                                                                            class="STYLE8"
                                                                                                            title=每页显示50条></g:link>&nbsp;
                            <g:link action="groupConsumerList" params="${[max: 100, groupId: groupId]}"><IMG id="Img100"
                                                                                                             src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}"
                                                                                                             alt=每页显示100条
                                                                                                             width="27"
                                                                                                             height="16"
                                                                                                             border=0
                                                                                                             class="STYLE8"
                                                                                                             title=每页显示100条></g:link>
                            <g:link action="groupConsumerList" params="${[max: 200, groupId: groupId]}"><IMG id="Img200"
                                                                                                             src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}"
                                                                                                             alt=每页显示200条
                                                                                                             width="28"
                                                                                                             height="16"
                                                                                                             border=0
                                                                                                             class="STYLE8"
                                                                                                             title=每页显示200条></g:link>
                        </div></TD>
                        <TD width=11>&nbsp;</TD>
                        <TD width="425" align=right><div class="STYLE8">
                            <g:guiPaginate total="${total}" offset="${params.offset}" action="groupConsumerList"
                                           params="${[groupId: groupId, sort: params.sort, max: params.max, order: params.order, offset: params.offset]}"/>&nbsp;&nbsp;
                        </TD>
                    </TR>
                    </TBODY>
                </TABLE><br>

                <p>&nbsp;</p>

                <p>&nbsp;</p>

                <p><br/>
                </p>
                <input type="hidden" name="groupId" value="${groupId}"/>
                <input type="hidden" name="offset" value="${params.offset}"/>
                <input type="hidden" name="sort" value="${params.sort}"/>
                <input type="hidden" name="order" value="${params.order}"/>
                <input type="hidden" name="max" value="${params.max}"/>
    </table>
</form>
<script Language="JavaScript">
    changePageImg(${params.max});
</script>
</body>
</html>