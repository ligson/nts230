<%@ page import="nts.utils.CTools" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <link href="${createLinkTo(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script src="${createLinkTo(dir: 'js', file: 'boful/appMgr/excanvas.js')}" type="text/javascript"></script>
    <script src="${createLinkTo(dir: 'js', file: 'boful/appMgr/plotr.js')}" type="text/javascript"></script>
    <title>信息统计</title>
    <style type="text/css">
    .Tab {
        border-collapse: collapse;
        width: 97%;
        height: 270px;
    }

    .Tab1 {
        border-collapse: collapse;
        width: 180px;
        height: 270px;
    }

    .Tab2 {
        border-collapse: collapse;
        width: 95%;
        height: 270px;
    }

    .Tab5 {
        border-collapse: collapse;
        width: 410px;
        height: 120px;
    }

    .Tab_td {
        border: solid 1px #DDDDDD
    }
    </style>
</head>

<body>
<div class="x_daohang"><span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>><a
        href="${createLink(controller: 'appMgr', action: 'statistics')}">信息统计</a>>>排行</div>

<div style="margin-left: 15px; margin-top: 15px; width: 98%; margin-bottom: 0; overflow-y:scroll;height:490px; ">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
                <tr>

                    <td width="50%"><table align="center" width="100%" cellspacing="0" class="Tab">
                        <tr>
                            <td height="25" class="Tab_td">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="10%">&nbsp;<img src="${resource(dir: 'images/skin', file: 'statistics.gif')}"></td>
                                        <td width="42%"><B><FONT COLOR="1B3D6A">资源下载排行</FONT></B></td>
                                        <td width="38%"><a class="button" href='programDownloadRanking'>导出EXCEL</a></td>
                                        <td width="10%" style="padding:4px 2px 0px 2px;"><a
                                                href="${createLink(controller: 'statistics', action: 'moreStatistics', params: [statType: 1])}"><img border="0"
                                                                                                      src="${resource(dir: 'images/skin', file: 'more.gif')}">
                                        </a></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" class="Tab_td"><table width="100%" border="1" cellpadding="0"
                                                                   cellspacing="0" bordercolor="#FFFFFF"
                                                                   class="table_1">
                                <tr bgcolor="#EAF4FC">
                                    <td width="42%" height="25" align="left">&nbsp;&nbsp;<b>资源名称</b></td>
                                    <td width="20%" align="center"><b>所属类库</b></td>
                                    <td width="19%" align="center"><b>上传时间</b></td>
                                    <td width="19%" align="center"><b>下载次数</b></td>
                                </tr>
                                <g:each in="${donwProSta}" status="i" var="donwProSta">
                                    <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#EAF4FC'}" align="center">
                                        <td align="left" height="23"
                                            title="${fieldValue(bean: donwProSta, field: 'name')}">&nbsp;&nbsp;${CTools.cutString(fieldValue(bean: donwProSta, field: 'name'), 10)}</td>
                                        <td>&nbsp;${fieldValue(bean: donwProSta, field: 'directory.name')}</td>
                                        <td><g:formatDate format="yyyy-MM-dd" date="${donwProSta.dateCreated}"/></td>
                                        <td><FONT
                                                COLOR="red">${fieldValue(bean: donwProSta, field: 'downloadNum')}</FONT>
                                        </td>
                                    </tr>
                                </g:each>
                            </table></td>
                        </tr>

                    </table></td>
                    <td width="7">&nbsp;</td>
                    <td width="50%"><table align="center" width="100%" cellspacing="0" class="Tab">
                        <tr>
                            <td height="25" class="Tab_td"><table width="100%" border="0" cellpadding="0"
                                                                  cellspacing="0">
                                <tr>
                                    <td width="7%">&nbsp;<img src="${resource(dir: 'images/skin', file: 'statistics.gif')}"></td>
                                    <td width="40%"><B><FONT COLOR="1B3D6A">资源浏览排行</FONT></B></td>
                                    <td width="38%"><a class="button" href='programViewRanking'>导出EXCEL</a></td>
                                    <td width="10%" style="padding:4px 2px 0px 2px;"><a
                                            href="${createLink(controller: 'statistics', action: 'moreStatistics', params: [statType: 2])}"><img border="0"
                                                                                                  src="${resource(dir: 'images/skin', file: 'more.gif')}">
                                    </a></td>
                                </tr>
                            </table></td>
                        </tr>
                        <tr>
                            <td valign="top" class="Tab_td"><table width="100%" border="1" cellpadding="0"
                                                                   cellspacing="0" bordercolor="#FFFFFF"
                                                                   class="table_1">
                                <tr bgcolor="#EAF4FC">
                                    <td width="42%" height="25" align="left">&nbsp;&nbsp;<b>资源名称</b></td>
                                    <td width="20%" align="center"><b>所属类库</b></td>
                                    <td width="17%" align="center"><b>上传时间</b></td>
                                    <td width="21%" align="center"><b>浏览次数</b></td>
                                </tr>
                                <g:each in="${viewProSta}" status="i" var="viewProSta">
                                    <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#EAF4FC'}" align="center">
                                        <td align="left" height="23"
                                            title="${fieldValue(bean: viewProSta, field: 'name')}">&nbsp;&nbsp;${CTools.cutString(fieldValue(bean: viewProSta, field: 'name'), 10)}</td>
                                        <td>${fieldValue(bean: viewProSta, field: 'directory.name')}</td>
                                        <td><g:formatDate format="yyyy-MM-dd" date="${viewProSta.dateCreated}"/></td>
                                        <td><FONT COLOR="red">${fieldValue(bean: viewProSta, field: 'frequency')}</FONT>
                                        </td>
                                    </tr>
                                </g:each>
                            </table></td>
                        </tr>
                    </table></td>

                </tr>
            </table>
        </td>
    </tr>
</table>

<table width="100%" style="margin-top: 15px;" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="33%"><table width="100%" align="center" cellspacing="0" class="Tab2">
                        <tr>
                            <td width="100%" height="25" class="Tab_td"><table width="100%" border="0" cellpadding="0"
                                                                               cellspacing="0">
                                <tr>
                                    <td width="14%">&nbsp;<img src="${resource(dir: 'images/skin', file: 'statistics.gif')}"></td>
                                    <td width="38%"><B><FONT COLOR="1B3D6A">用户访问排行</FONT></B></td>
                                    <td width="38%"><a class="button" href='userVisitRanking'>导出EXCEL</a></td>
                                    <td width="10%" style="padding:4px 2px 0px 2px;"><a
                                            href="${createLink(controller: 'statistics', action: 'moreStatistics', params: [statType: 3])}"><img border="0"
                                                                                                  src="${resource(dir: 'images/skin', file: 'more.gif')}">
                                    </a></td>
                                </tr>
                            </table></td>
                        </tr>
                        <tr>
                            <td valign="top" class="Tab_td" height="11"><table width="100%" border="1" cellpadding="0"
                                                                               cellspacing="0" bordercolor="#FFFFFF"
                                                                               class="table_1">
                                <tr bgcolor="#EAF4FC">
                                    <td width="36%" height="25" align="left">&nbsp;&nbsp;<b>用户帐号</b></td>
                                    <td width="37%" height="25" align="center">&nbsp;&nbsp;<b>姓名</b></td>
                                    <td width="27%" align="center"><b>访问数</b></td>
                                </tr>
                                <g:each in="${loginCmrSta}" status="i" var="consumer">
                                    <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#EAF4FC'}" align="center">
                                        <td align="left"
                                            height="23">&nbsp;&nbsp;${fieldValue(bean: consumer, field: 'name')}</td>
                                        <td>&nbsp;&nbsp;${fieldValue(bean: consumer, field: 'trueName')}</td>
                                        <td><FONT COLOR="red">${fieldValue(bean: consumer, field: 'loginNum')}</FONT>
                                        </td>
                                    </tr>
                                </g:each>
                            </table></td>
                        </tr>
                    </table></td>
                    <td width="10">&nbsp;</td>
                    <td width="33%"><table width="100%" align="center" cellspacing="0" class="Tab2">
                        <tr>
                            <td width="100%" height="25" class="Tab_td"><table width="100%" border="0" cellpadding="0"
                                                                               cellspacing="0">
                                <tr>
                                    <td width="14%">&nbsp;<img src="${resource(dir: 'images/skin', file: 'statistics.gif')}"></td>
                                    <td width="38%"><B><FONT COLOR="1B3D6A">用户浏览排行</FONT></B></td>
                                    <td width="38%"><a class="button" href='userViewRanking'>导出EXCEL</a></td>
                                    <td width="10%" style="padding:4px 2px 0px 2px;"><a
                                            href="${createLink(controller: 'statistics', action: 'moreStatistics', params: [statType: 4])}"><img border="0"
                                                                                                  src="${resource(dir: 'images/skin', file: 'more.gif')}">
                                    </a></td>
                                </tr>
                            </table></td>
                        </tr>
                        <tr>
                            <td valign="top" class="Tab_td" height="11"><table width="100%" border="1" cellpadding="0"
                                                                               cellspacing="0" bordercolor="#FFFFFF"
                                                                               class="table_1">
                                <tr bgcolor="#EAF4FC">
                                    <td width="36%" height="25" align="left">&nbsp;&nbsp;<b>用户帐号</b></td>
                                    <td width="37%" height="25" align="center">&nbsp;&nbsp;<b>姓名</b></td>
                                    <td width="27%" align="center"><b>浏览数</b></td>
                                </tr>
                                <g:each in="${viewCmrSta}" status="i" var="consumer">
                                    <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#EAF4FC'}" align="center">
                                        <td align="left"
                                            height="23">&nbsp;&nbsp;${fieldValue(bean: consumer, field: 'name')}</td>
                                        <td>&nbsp;&nbsp;${fieldValue(bean: consumer, field: 'trueName')}</td>
                                        <td><FONT COLOR="red">${fieldValue(bean: consumer, field: 'viewNum')}</FONT>
                                        </td>
                                    </tr>
                                </g:each>
                            </table></td>
                        </tr>
                    </table></td>
                    <td width="15"></td>
                    <td width="33%"><table width="100%" align="center" cellspacing="0" class="Tab2">
                        <tr>
                            <td width="100%" height="25" class="Tab_td"><table width="100%" border="0" cellpadding="0"
                                                                               cellspacing="0">
                                <tr>
                                    <td width="14%">&nbsp;<img src="${resource(dir: 'images/skin', file: 'statistics.gif')}"></td>
                                    <td width="38%"><B><FONT COLOR="1B3D6A">用户下载排行</FONT></B></td>
                                    <td width="38%"><a class="button" href='userDownloadRanking'>导出EXCEL</a></td>
                                    <td width="10%" style="padding:4px 2px 0px 2px;"><a
                                            href="${createLink(controller: 'statistics', action: 'moreStatistics', params: [statType: 5])}"><img border="0"
                                                                                                  src="${resource(dir: 'images/skin', file: 'more.gif')}">
                                    </a></td>
                                </tr>
                            </table></td>
                        </tr>
                        <tr>
                            <td valign="top" class="Tab_td" height="11"><table width="100%" border="1" cellpadding="0"
                                                                               cellspacing="0" bordercolor="#FFFFFF"
                                                                               class="table_1">
                                <tr bgcolor="#EAF4FC">
                                    <td width="36%" height="25" align="left">&nbsp;&nbsp;<b>用户帐号</b></td>
                                    <td width="37%" height="25" align="center">&nbsp;&nbsp;<b>姓名</b></td>
                                    <td width="27%" align="center"><b>下载数</b></td>
                                </tr>
                                <g:each in="${donwCmrSta}" status="i" var="consumer">
                                    <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#EAF4FC'}" align="center">
                                        <td align="left"
                                            height="23">&nbsp;&nbsp;${fieldValue(bean: consumer, field: 'name')}</td>
                                        <td>&nbsp;&nbsp;${fieldValue(bean: consumer, field: 'trueName')}</td>
                                        <td><FONT COLOR="red">${fieldValue(bean: consumer, field: 'downloadNum')}</FONT>
                                        </td>
                                    </tr>
                                </g:each>
                            </table></td>
                        </tr>
                    </table></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<table width="100%" style="margin-top: 15px; margin-bottom: 15px;" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="33%"><table width="100%" align="center" cellspacing="0" class="Tab2">
                        <tr>
                            <td width="100%" height="25" class="Tab_td"><table width="100%" border="0" cellpadding="0"
                                                                               cellspacing="0">
                                <tr>
                                    <td width="14%">&nbsp;<img src="${resource(dir: 'images/skin', file: 'statistics.gif')}"></td>
                                    <td width="38%"><B><FONT COLOR="1B3D6A">用户上传排行</FONT></B></td>
                                    <td width="38%"><a class="button" href='userUploadRanking'>导出EXCEL</a></td>
                                    <td width="10%" style="padding:4px 2px 0px 2px;"><a
                                            href="${createLink(controller: 'statistics', action: 'moreStatistics', params: [statType: 6])}"><img border="0"
                                                                                                  src="${resource(dir: 'images/skin', file: 'more.gif')}">
                                    </a></td>
                                </tr>
                            </table></td>
                        </tr>
                        <tr>
                            <td valign="top" class="Tab_td" height="11"><table width="100%" border="1" cellpadding="0"
                                                                               cellspacing="0" bordercolor="#FFFFFF"
                                                                               class="table_1">
                                <tr bgcolor="#EAF4FC">
                                    <td width="36%" height="25" align="left">&nbsp;&nbsp;<b>用户帐号</b></td>
                                    <td width="37%" height="25" align="left">&nbsp;&nbsp;<b>姓名</b></td>
                                    <td width="27%" align="center"><b>上传数</b></td>
                                </tr>
                                <g:each in="${uploadCmrSta}" status="i" var="consumer">
                                    <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#EAF4FC'}" align="center">
                                        <td align="left"
                                            height="23">&nbsp;&nbsp;${fieldValue(bean: consumer, field: 'name')}</td>
                                        <td>&nbsp;&nbsp;${fieldValue(bean: consumer, field: 'trueName')}</td>
                                        <td><FONT COLOR="red">${fieldValue(bean: consumer, field: 'uploadNum')}</FONT>
                                        </td>
                                    </tr>
                                </g:each>
                            </table></td>
                        </tr>
                    </table></td>
                    <td width="10">&nbsp;</td>
                    <td width="33%"><table width="100%" align="center" cellspacing="0" class="Tab2">
                        <tr>
                            <td width="100%" height="25" class="Tab_td"><table width="100%" border="0" cellpadding="0"
                                                                               cellspacing="0">
                                <tr>
                                    <td width="14%">&nbsp;<img src="${resource(dir: 'images/skin', file: 'statistics.gif')}"></td>
                                    <td width="38%"><B><FONT COLOR="1B3D6A">用户收藏排行</FONT></B></td>
                                    <td width="38%"><a class="button" href='userCollectionRanking'>导出EXCEL</a></td>
                                    <td width="10%" style="padding:4px 2px 0px 2px;"><a
                                            href="${createLink(controller: 'statistics', action: 'moreStatistics', params: [statType: 7])}"><img border="0"
                                                                                                  src="${resource(dir: 'images/skin', file: 'more.gif')}">
                                    </a></td>
                                </tr>
                            </table></td>
                        </tr>
                        <tr>
                            <td valign="top" class="Tab_td" height="11"><table width="100%" border="1" cellpadding="0"
                                                                               cellspacing="0" bordercolor="#FFFFFF"
                                                                               class="table_1">
                                <tr bgcolor="#EAF4FC">
                                    <td width="36%" height="25" align="left">&nbsp;&nbsp;<b>用户帐号</b></td>
                                    <td width="37%" height="25" align="center">&nbsp;&nbsp;<b>姓名</b></td>
                                    <td width="27%" align="center"><b>收藏数</b></td>
                                </tr>
                                <g:each in="${collectCmrSta}" status="i" var="consumer">
                                    <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#EAF4FC'}" align="center">
                                        <td align="left"
                                            height="23">&nbsp;&nbsp;${fieldValue(bean: consumer, field: 'name')}</td>
                                        <td>&nbsp;&nbsp;${fieldValue(bean: consumer, field: 'trueName')}</td>
                                        <td><FONT COLOR="red">${fieldValue(bean: consumer, field: 'collectNum')}</FONT>
                                        </td>
                                    </tr>
                                </g:each>
                            </table></td>
                        </tr>
                    </table></td>
                    <td width="15"></td>
                    <td width="33%"><table width="100%" align="center" cellspacing="0" class="Tab2">
                        <tr>
                            <td width="100%" height="25" class="Tab_td"><table width="100%" border="0" cellpadding="0"
                                                                               cellspacing="0">
                                <tr>
                                    <td width="14%">&nbsp;<img src="${resource(dir: 'images/skin', file: 'statistics.gif')}"></td>
                                    <td width="42%"><B><FONT COLOR="1B3D6A">用户最后登陆排行</FONT></B></td>
                                    <td width="34%"><a class="button" href='userLastloginRanking'>导出EXCEL</a></td>
                                    <td width="10%" style="padding:4px 2px 0px 2px;"><a
                                            href="${createLink(controller: 'statistics', action: 'moreStatistics', params: [statType: 8])}"><img border="0"
                                                                                                  src="${resource(dir: 'images/skin', file: 'more.gif')}">
                                    </a></td>
                                </tr>
                            </table></td>
                        </tr>
                        <tr>
                            <td valign="top" class="Tab_td" height="11"><table width="100%" border="1" cellpadding="0"
                                                                               cellspacing="0" bordercolor="#FFFFFF"
                                                                               class="table_1">
                                <tr bgcolor="#EAF4FC">
                                    <td width="36%" height="25" align="left">&nbsp;&nbsp;<b>用户帐号</b></td>
                                    <td width="37%" height="25" align="center">&nbsp;&nbsp;<b>姓名</b></td>
                                    <td width="27%" align="center"><b>登陆时间</b></td>
                                </tr>
                                <g:each in="${lastLoginCmrSta}" status="i" var="consumer">
                                    <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#EAF4FC'}" align="center">
                                        <td align="left"
                                            height="23">&nbsp;&nbsp;${fieldValue(bean: consumer, field: 'name')}</td>
                                        <td>&nbsp;&nbsp;${fieldValue(bean: consumer, field: 'trueName')}</td>
                                        <td title="${lastLoginCmrSta.dateLastLogin}"><g:formatDate format="yyyy-MM-dd"
                                                                                                   date="${consumer.dateLastLogin}"/></td>
                                    </tr>
                                </g:each>
                            </table></td>
                        </tr>
                    </table></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</div>
</body>
</html>