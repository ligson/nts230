<%@ page import="nts.utils.CTools" %>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <meta name="layout" content="communityMain"/>
    <title>主题列表</title>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'zxm.css')}" rel="stylesheet" type="text/css">
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>

</head>

<body leftmargin="0" topmargin="5" marginwidth="0" marginheight="0">
<form name="subjectForm" method="post" action="">
    <input type="hidden" name="subjectType" value="${params.subjectType}">
    <g:set var="typeName" value="${['my': '我创建的主题列表', 'join': '我加入的主题列表', 'all': '所有主题列表', 'mgr': '社区管理']}"/>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="1%" align="left" valign="top"><img src="${resource(dir: 'images/skin', file: 'left_line.gif')}" width="1" height="500"/>
            </td>
            <td width="98%" align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td colspan="10" align="left" valign="top">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">

                            <tr>
                                <td align="left" style="padding:6px 2px 8px 0px;">
                                    <g:if test="${params?.communityType == 'all'}">
                                        <div class="x_daohang">
                                            <p>当前位置：<a href="${createLink(controller: 'subjects', action: '')}">主题社区</a>>> ${typeName[params.subjectType]}
                                            </p>
                                        </div>
                                    </g:if>
                                    <g:if test="${params?.communityType == 'mgr'}">
                                        <div class="x_daohang">
                                            <p>当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>> ${typeName[params.subjectType]}
                                            </p>
                                        </div>
                                    </g:if>
                                    <g:if test="${params?.communityType != 'all' && params?.communityType != 'mgr'}">
                                        <div class="x_daohang">
                                            <p>当前位置：<a href="${createLink(controller: 'subjects', action: '')}">主题社区</a>>><a
                                                    href="${createLink(controller: 'subjects', action: 'list', params: [subjectType: 'my'])}">管理主题</a>>> ${typeName[params.subjectType]}
                                            </p>
                                        </div>
                                    </g:if>
                                </td>

                            </tr>

                        </table>
                    </td>
                </tr>
                <tr>
                    <td>

                        <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#E9E8E7">
                            <tr>
                                <td width="5%" align="center">主题名称:&nbsp;&nbsp;&nbsp;<input type="text"
                                                                                            class="newsinput1"
                                                                                            name="searchTitle"
                                                                                            value=""/></td>
                                <td width="5%" align="center"><input name="search" type="button" class="button"
                                                                     onClick="subjectSearch()" value="查询"/></td>
                            </tr>
                        </table>

                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="96%">
                                    <table width="100%" border="1" cellpadding="0" cellspacing="0"
                                           bordercolor="#FFFFFF">
                                        <tr align="left" valign="top">
                                            <td width="25%" align="center" valign="middle" bgcolor="#BDEDFB"><a
                                                    href="#">社区名称</a></td>
                                            <td width="8%" align="center" valign="middle" bgcolor="#BDEDFB"><a
                                                    href="#">学科</a></td>
                                            <td width="10%" align="center" valign="middle" bgcolor="#BDEDFB"><a
                                                    href="#">创建时间</a></td>
                                            <td width="10%" align="center" valign="middle" bgcolor="#BDEDFB"><a
                                                    href="#">创建者</a></td>
                                            <td width="6%" align="center" valign="middle" bgcolor="#BDEDFB"><a
                                                    href="#">成员人数</a></td>
                                            <td width="6%" align="center" valign="middle" bgcolor="#BDEDFB"><a
                                                    href="#">简介</a></td>
                                            <td width="6%" align="center" valign="middle" bgcolor="#BDEDFB"><a
                                                    href="#">浏览量</a></td>
                                        </tr>
                                        <g:each in="${studyCommunityList}" status="i" var="studyCommunity">
                                            <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}" align="center"
                                                valign="top">
                                                <td valign="middle" align="left">&nbsp;&nbsp;<g:link action="topicList"
                                                                                                     params="${[communityId: studyCommunity.id, communityType: params.communityType]}">${CTools.cutString(fieldValue(bean: studyCommunity, field: 'name'), 18)}</g:link></td>
                                                <td valign="middle">
                                                    ${CTools.cutString(fieldValue(bean: studyCommunity.communityCategory, field: 'name'), 18)}
                                                </td>
                                                <td valign="middle"><g:formatDate format="yyyy.M.d"
                                                                                  date="${studyCommunity.dateCreated}"/></td>
                                                <td valign="middle">${CTools.cutString(fieldValue(bean: studyCommunity, field: 'name'), 7)}</td>
                                                <td valign="middle">${fieldValue(bean: studyCommunity, field: 'membersCount')}</td>
                                                <g:if test="${params?.communityType == 'my'}">
                                                    <td valign="middle"><a href="#"><img
                                                            src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0" width="11"
                                                            height="13"/></a></td>
                                                    <td valign="middle"><a href="#"><img src="${resource(dir: 'images/skin', file: 'modi.gif')}"
                                                                                         border="0" width="11"
                                                                                         height="13"/></a></td>
                                                </g:if>
                                            </tr>
                                        </g:each>
                                    </table>

                                    <p>
                                    <table width="100%" height="16" border="0" cellpadding="1" cellspacing="1"
                                           bgcolor="#E9E8E7">
                                        <tbody>
                                        <tr>
                                            <td height="16" align="left"><span
                                                    class="STYLE5">&nbsp;&nbsp;&nbsp;&nbsp;总共：<span
                                                        class="STYLE8">${total}</span>个主题&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当前显示：${pageNow}/${pageCount}页 每页${params.max}条 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;每页显示:
                                            </span>
                                                <a href="#" onClick="maxShow(10)">
                                                    <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" border="0"
                                                         class="STYLE8" title="每页显示10条"/></a>&nbsp;
                                                <a href="#" onClick="maxShow(50)">
                                                    <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" border="0"
                                                         class="STYLE8" title="每页显示50条"/></a>&nbsp;
                                                <a href="#" onClick="maxShow(100)">
                                                    <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}"
                                                         border="0" class="STYLE8" title="每页显示100条"/></a>
                                                <a href="#" onClick="maxShow(200)">
                                                    <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}"
                                                         border="0" class="STYLE8" title="每页显示200条"/></a></td>
                                            <td width="125" align="right"><g:paginate total="${total}"
                                                                                      offset="${params.offset}"
                                                                                      action="list"
                                                                                      params="${params}"/>&nbsp;&nbsp;</td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </table>

                    </td>
                    <td width="2%">&nbsp;</td>
                </tr>

            </table></td>
        </tr>
    </table>
</td>
    <td width="1%">&nbsp;</td>
</tr>

</table>
</form>
<script Language="JavaScript">
    changePageImg(${params.max});
</script>
</body>
</html>
