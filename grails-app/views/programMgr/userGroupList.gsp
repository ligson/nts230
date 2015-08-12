<%@ page import="nts.utils.CTools" %>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <!-- saved from url=(0048)http://www.supermap.com.cn/gb/solutions/emap.htm -->
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>

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

    .flzhu {
        width: 100%;
        overflow: auto
    }

    .flzhu ul {
        margin: 5px;
        list-style: none;
    }

    .flzhu ul li {
        float: left;
        margin-right: 10px;
        line-height: 28px;
    }

    -->
    </style>

    <script LANGUAGE="javascript">

        function setProgramGroup(action) {
            var msg = '';
            if (action == 'setProgramGroup') {
                msg = '加入到';
            }
            else if (action == 'programGroupDel') {
                msg = '取消';
            }

            if (!confirm('确定' + msg + '该组?')) {
                return false;
            }
            if (hasChecked("idList") == false) {
                alert("请至少选择一个用户组！");
                return false;
            }

            GroupForm.action = "/programMgr/" + action;
            GroupForm.submit();
        }

    </script>

</head>

<body>
<form method="post" name="GroupForm" id="myGroupForm">
    <input type="hidden" name="offset" value="${params.offset}"/>
    <input type="hidden" name="sort" value="${params.sort}"/>
    <input type="hidden" name="order" value="${params.order}"/>
    <input type="hidden" name="max" value="${params.max}"/>


    <g:if test="${flag == 2}">
        <table width="95%" border="0" cellspacing="0">
            <tr>
                <td align="left"><font><span class="zi-cu">已选用户组</span></font></td>
            </tr>
        </table>

        <div class="flzhu">
            <ul>
                <g:each in="${selectedUserGroups}" status="i" var="userGroup">
                    <li><a>${userGroup.name}</a></li>
                </g:each>
            </ul>
        </div>
    </g:if>
    <table width="95%" border="0" cellspacing="0">
        <tr>
            <td align="left"><font><span class="zi-cu">待选用户组列表</span></font></td>
        </tr>
    </table>
    <table width="95%">
        <tr>
            <td>
                <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                    <tr bgcolor="#BDEDFB">
                        <td width="1%" height="28" align="center" class="STYLE5">选择</td>
                        <td width="6%" height="28" align="center" class="STYLE5">组名</td>
                        <td width="6%" align="center" class="STYLE5">备注</td>
                        <td width="2%" align="center" class="STYLE5">创建者</td>
                        <td width="2%" align="center" class="STYLE5">创建时间</td>
                        <td width="3%" align="center" class="STYLE5">查看组成员</td>
                    </tr>
                    <g:each in="${userGroupList}" status="i" var="userGroup">
                        <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                            <td><input type="checkbox" name="idList" value="${userGroup.id}"
                                       onclick="unCheckAll('selall');"/></td>
                            <td height="23" align="left" nowrap="nowrap"
                                class="STYLE5">&nbsp;&nbsp;${CTools.cutString(fieldValue(bean: userGroup, field: 'name'), 10)}</td>
                            <td align="center" nowrap="nowrap"
                                class="STYLE5">${CTools.cutString(CTools.htmlToBlank(fieldValue(bean: userGroup, field: 'description')), 20)}</td>
                            <td align="center" nowrap="nowrap"
                                class="STYLE5">${fieldValue(bean: userGroup, field: 'creator')}</td>
                            <td align="center" nowrap="nowrap" class="STYLE5"><g:formatDate format="yyyy-MM-dd"
                                                                                            date="${userGroup.dateCreated}"/></td>
                            <td align="center" class="STYLE5"><g:link controller="programMgr" action="groupConsumerList"
                                                                      params="${[groupId: userGroup.id]}"><img
                                        src="${resource(dir: 'images/skin', file: 'xianshi.gif')}" alt="" width="14" height="16"
                                        border="0"/></g:link></td>
                        </tr>
                    </g:each>
                </table>
                <table width="93%" height="35" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td align="left" width="10%">&nbsp;</td>
                        <td align="right">&nbsp;</td>
                    </tr>
                </table>

                <div>
                    <input id="selall" name="selall" onclick="checkAll(this, 'idList')" type="checkbox">全选&nbsp;
                    <input type="button" class="button" value="添加" onClick="setProgramGroup('setProgramGroup')"/>

                    <input type="button" class="button" value="取消组权限" onClick="setProgramGroup('programGroupDel')"/>

                </div>
                <TABLE width="95%" height="16" border=0 cellPadding=1 cellSpacing=1 bgcolor="#E9E8E7">
                    <TBODY>
                    <TR>
                        <TD height="16" align="center">
                            <div align="left">
                                <span class="STYLE5">&nbsp;记录数：
                                    <span class="STYLE6">${total}</span>
                                    &nbsp; &nbsp;每页显示:
                                </span>
                                <g:link action="userGroupList" params="${[max: 10, idList: programIdList]}"><IMG
                                        id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" width=19
                                        height=16 border=0 class="STYLE8" title="每页显示10条"></g:link>&nbsp;
                                <g:link action="userGroupList" params="${[max: 50, idList: programIdList]}"><IMG
                                        id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" width=20
                                        height=15 border=0 class="STYLE8" title="每页显示50条"></g:link>&nbsp;
                                <g:link action="userGroupList" params="${[max: 100, idList: programIdList]}"><IMG
                                        id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" width="27"
                                        height="16" border=0 class="STYLE8" title="每页显示100条"></g:link>
                                <g:link action="userGroupList" params="${[max: 200, idList: programIdList]}"><IMG
                                        id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" width="28"
                                        height="16" border=0 class="STYLE8" title="每页显示200条"></g:link>
                            </div>
                        </TD>
                        <TD align=right>
                            <div class="STYLE8">
                                <g:paginate total="${total}" offset="${params.offset}" action="userGroupList"
                                            params="${[sort: params.sort, max: params.max, order: params.order, offset: params.offset, idList: programIdList]}"/>&nbsp;&nbsp;
                            </div>
                        </TD>
                    </TR>
                    </TBODY>
                </TABLE>
            </td>
        </tr>
    </table>
</form>
<script Language="JavaScript" type="text/javascript">
    changePageImg(${params.max});
</script>
</body>
</html>

