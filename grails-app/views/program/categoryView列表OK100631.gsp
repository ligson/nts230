<%@ page import="nts.utils.CTools; nts.program.domain.Program" %>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>nts</title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" type=text/css
          rel=stylesheet>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}" type=text/css
          rel=stylesheet>
    <style>
    table {
        border: 0px solid #ccc;
        margin-left: 20px;
        margin-right: 20px;
        word-break: break-all;
    }

    a:link, a:visited {
        font-weight: normal;
    }

    a:hover {
        color: #FF6600;
        font-weight: normal;
    }

    #catetab .curLink {
        color: #f60;
    }

    #progListTab td {
        line-height: 18px;
        padding-left: 2px;
    }

    </style>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/prototype.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/truevod.js')}"></script>

    <SCRIPT LANGUAGE="JavaScript">
        <!--

        function submitSch() {
            document.form1.offset.value = 0;
            document.form1.submit();
        }

        function onPageNumPer(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;
            submitSch();
        }

        //如果右边页面用类库(目录) 则metaId2是目录ID，enumId2为0 名称后缀2表示是右边的类别,如此设计是为了用户如果...
        function categorySch(metaId2, enumId2) {
            document.form1.metaId2.value = metaId2;
            document.form1.keyword.value = "";//点击时不使用搜索条件
            submitSch();
        }

        function init() {
            document.form1.type.value = "${CTools.nullToOne(params.type)}";
            changePageImg(${CTools.nullToOne(params.max)});
        }

        //-->
    </SCRIPT>
</head>

<body leftmargin="18" onload="init();">
<form name="form1" action="categoryView">
    <input type="hidden" name="max" value="${params.max}">
    <input type="hidden" name="offset" value="${params.offset}">

    <input type="hidden" name="category" value="${params.category}">
    <input type="hidden" name="metaId" value="${params.metaId}">
    <input type="hidden" name="enumId" value="${params.enumId}">
    <input type="hidden" name="isAll" value="${params.isAll}">

    <input type="hidden" name="metaId2" value="${params.metaId2}">
    <input type="hidden" name="enumId2" value="${params.enumId2}">

    <table width="97%" style="margin-top:5px;" height="60" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td width="7" align="right" valign="top"><img src="${resource(dir: 'images/skin', file: 'box_left.gif')}" width="6" height="50"/>
            </td>
            <td style="background-position:7px 1px;" background="${resource(dir: 'images/skin', file: 'box_center.gif')}">
                <table id="catetab" width="600" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="70" style="padding-bottom:7px;">资源分类：</td>
                        <td style="padding-bottom:7px;">
                            <a href="#" class="${CTools.nullToZero(params.metaId2) == 0 ? 'curLink' : ''}"
                               onclick="categorySch(0, 0);
                               return false;">全部</a>
                            <g:each in="${directoryList}" status="i" var="directory">
                                <a href="#" class="${directory.id == CTools.strToInt(params.metaId2) ? 'curLink' : ''}"
                                   onclick="categorySch(${directory.id});
                                   return false;">${directory.name}</a>
                            </g:each>
                        </td>
                    </tr>
                </table>
            </td>
            <td width="3%" align="left" valign="top"><img src="${resource(dir: 'images/skin', file: 'box_right.gif')}" width="6" height="50"/>
            </td>
        </tr>
    </table>

    <table width="600" style="border: 0px;margin-bottom:5px;" align="center" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="60" valign="middle">快速查询：</td>
            <td width="80" valign="middle">
                <select name="type">
                    <option value="1">${Program.cnField.name}</option>
                    <option value="2">${Program.cnField.actor}</option>
                    <option value="3">${Program.cnField.consumer}</option>
                    <option value="4">${Program.cnField.programTags}</option>
                </select>
            </td>
            <td width="120" valign="middle">
                <input name="keyword" type="text" size="40" value="${params.keyword}">
            </td>
            <td valign="middle">
                <img src="${resource(dir: 'images/skin', file: 'ssuo.gif')}" border="0" style="cursor:pointer;" onclick="submitSch();"></td>
        </td>
        </tr>
    </table>

    <table width="96%" style="border: 0px;" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF"
           id="progListTab">
        <tr>
            <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB;" property="name"
                              title="${Program.cnField.name}" params="${params}"/>
            <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB;;width:7%;"
                              property="datePassed" title="${Program.cnField.datePassed}" params="${params}"/>
            <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB;" property="actor"
                              title="${Program.cnField.actor}" params="${params}"/>
            <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB;width:6%;" property="consumer"
                              title="${Program.cnField.consumer}" params="${params}"/>
            <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB;width:7%;"
                              property="frequency" title="${Program.cnField.frequency}" params="${params}"/>
            <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB;width:7%;"
                              property="downloadNum" title="下载次数" params="${params}"/>
            <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB;width:7%;"
                              property="collectNum" title="收藏次数" params="${params}"/>

            <th width="6%" align="center" style="font-weight:normal;background:#BDEDFB" class="sortable">点播</td>
            <th width="6%" align="center" style="font-weight:normal;background:#BDEDFB" class="sortable">下载</td>
        </tr>
        <g:each in="${programList ?}" status="i" var="program">
            <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                <td><a href="showProgram?id=${program.id}" title="${program?.name.encodeAsHTML()}"
                       target="_blank">${CTools.cutString(program?.name, 20).encodeAsHTML()}</a></td>
                <td align="center"><g:formatDate format="yyyy-MM-dd" date="${program?.datePassed}"/></td>
                <td>${program?.actor.encodeAsHTML()}</td>
                <td align="center">${program?.consumer.nickname.encodeAsHTML()}</td>
                <td align="center">${program?.frequency}</td>
                <td align="center">${program?.downloadNum}</td>
                <td align="center">${program?.collectNum}</td>
                <td align="center"><img src="${resource(dir: 'images/skin', file: 'play.gif')}" style="cursor:pointer;"
                                        onclick="playProgram(1, ${program?.id}, 0, ${program?.serialNum});" alt="点击播放">
                </td>
                <td align="center"><g:if test="${program?.canDownload}"><img src="${resource(dir: 'images/skin', file: 'save.gif')}"
                                                                             style="cursor:pointer;"
                                                                             onclick="playProgram(0, ${program?.id}, 0, ${program?.serialNum});"
                                                                             alt="点击下载"></g:if><g:else><img
                        src="${resource(dir: 'images/skin', file: 'save_1.gif')}" alt="本资源不能下载"></g:else></td>
            </tr>
        </g:each>
    </table>

    <div style="height:20px;"></div>

    <table width="96%" style="border: 0px;" height="16" border="0" cellpadding="1" cellspacing="1" bgcolor="#E9E8E7">
        <tr>
            <td width="340" height="16" align="center">
                总共：${total}个资源&nbsp;&nbsp;每页显示:
                <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                     onclick="onPageNumPer(10)">&nbsp;
                <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0"
                     onclick="onPageNumPer(50)">&nbsp;
                <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0"
                     onclick="onPageNumPer(100)">&nbsp;
                <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0"
                     onclick="onPageNumPer(200)">&nbsp;
            </td>

            <td align="right"><div class="paginateButtons"><g:paginate total="${total}" params="${params}"/></div></td>
        </tr>
    </table>

</form>
</body>
</html>

