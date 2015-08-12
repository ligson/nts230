<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <link href="${createLinkTo(dir: 'css', file: 'zhigaiban.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_base_second.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_base_userspace.css')}">
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
        function selectGroup() {
            consumerForm.groupId.value = consumerForm.groupList.value;
            consumerForm.action = "myGroupConsumerList";
            consumerForm.submit();
        }
        function cleard() {
            consumerForm.consumerId.value = "";
        }
        function addConsumer() {

            if (consumerForm.groupId.value == "") {
                alert("请选择用户组");
                return false;
            }
            consumerForm.groupId.value = consumerForm.groupList.value;
            consumerForm.action = "myGroupAddConsumerOne";
            consumerForm.submit();
        }
        /*
         function getKeyCode()
         {
         if (event.keyCode==13)
         {
         addConsumer();
         }
         }
         */
    </script>
</head>

<body style="background:#fff;">
<div id="main-content">
    <div class="content-box">
        <div class="x_daohang">
            <p>当前位置：<a href="${createLink(controller: 'my', action: 'myInfo')}">个人空间</a>>><a href="${createLink(controller: 'my', action: 'myGroupList')}">用户管理</a>>> 组成员管理</p>
        </div>
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        <g:hasErrors bean="${userGroup}">
            <div class="errors">
                <g:renderErrors bean="${userGroup}" as="list"/>
            </div>
        </g:hasErrors>

        <form method="post" name="consumerForm">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="biaoge-hui">
                <tr>
                    <td width="20%" align="center" class="STYLE5">请选择用户组</span>：</td>
                    <td width="20%">

                        <select name="groupList" onChange="selectGroup()" id="groupList">
                            <option value="${groupId}">${groupName}</option>
                            <g:each in="${userGroupList}" var="groupList">
                                <option value="${groupList.id}">${groupList.name}</option>
                            </g:each>
                        </select>

                    </td>
                    <td width="10%" align="center">&nbsp;</td>
                    <td width="20%" align="center" class="STYLE5">添加用户</td>
                    <td width="30%">
                        <input name="consumerId" type="text" class="input" onfocus="cleard()" value="请输入用户ID" size="30">
                    </td>
                    <td width="10%" align="center"><span class="biaoge-hui-br">
                        <input name="add" type="button" onClick="addConsumer()" value="添加"/>
                    </span></td>
                </tr>

            </table>

            <table width="100%">
                <tr>
                    <td><table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                        <tr>
                            <td width="7%" align="center" height="22" bgcolor="#BDEDFB" class="STYLE5">学号</td>
                            <td width="7%" align="center" bgcolor="#BDEDFB" class="STYLE5">姓名</td>
                            <td width="9%" align="center" bgcolor="#BDEDFB" class="STYLE5">所属院系</td>
                            <td width="9%" align="center" bgcolor="#BDEDFB" class="STYLE5">删除</td>
                        </tr>
                        <g:each in="${userGroupConsumerList}" status="i" var="consumer">
                            <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                                <td height="23" align="center"
                                    class="STYLE5">${fieldValue(bean: consumer, field: 'name')}</td>
                                <td align="center" class="STYLE5">${fieldValue(bean: consumer, field: 'nickname')}</td>
                                <td align="center"
                                    class="STYLE5">${fieldValue(bean: consumer, field: 'college.name')}</td>
                                <td align="center" class="STYLE5"><g:link action="myGroupDeleteConsumerOne"
                                                                          id="${consumer.id}"
                                                                          onclick="return confirm('确定删除用户?');"
                                                                          params="${[groupId: consumer.userGroups.id, sort: params.sort, max: params.max, order: params.order, offset: params.offset]}"><img
                                            src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0" width="11"
                                            height="13"/></g:link></td>
                            </tr>
                        </g:each>
                    </table>

                        <table width="100%" height="35" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td align="left" width="10%">&nbsp;</td>
                                <td align="right">&nbsp;</td>
                            </tr>
                        </table>
                        <TABLE width="100%" height="16"
                               border=0 cellPadding=1 cellSpacing=1 bgcolor="#E9E8E7">
                            <TBODY>
                            <TR>
                                <TD width="693" height="16" align="center"><div align="left"><span
                                        class="STYLE5">&nbsp;&nbsp;&nbsp;&nbsp;总共：<span
                                            class="STYLE6">${total}</span>个用户&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当前显示：${pageNow}/${pageCount}页 每页${params.max}条 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;每页显示:
                                </span>
                                    <g:link action="myGroupConsumerList" params="${[max: 10, groupId: groupId]}"><IMG
                                            id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt=每页显示10条 width=19
                                            height=16 border=0 class="STYLE8" title=每页显示10条></g:link>&nbsp;
                                    <g:link action="myGroupConsumerList" params="${[max: 50, groupId: groupId]}"><IMG
                                            id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt=每页显示50条 width=20
                                            height=15 border=0 class="STYLE8" title=每页显示50条></g:link>&nbsp;
                                    <g:link action="myGroupConsumerList" params="${[max: 100, groupId: groupId]}"><IMG
                                            id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt=每页显示100条
                                            width="27" height="16" border=0 class="STYLE8" title=每页显示100条></g:link>
                                    <g:link action="myGroupConsumerList" params="${[max: 200, groupId: groupId]}"><IMG
                                            id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt=每页显示200条
                                            width="28" height="16" border=0 class="STYLE8" title=每页显示200条></g:link>
                                </div></TD>
                                <TD width=11>&nbsp;</TD>
                                <TD width="425" align=right><div class="STYLE8">
                                    <g:paginate total="${total}" offset="${params.offset}" action="myGroupConsumerList"
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
            </table></form>
        <script Language="JavaScript">
            changePageImg(${params.max});
        </script>
    </div>
</div>
</body>
</html>