<%@ page import="nts.program.domain.Program" %>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <link href="${createLinkTo(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <title>资源列表</title>


    <script LANGUAGE="javascript">
        function setParams() {
            newsForm.searchTitle.value = "${params.searchTitle}";
            newsForm.searchActor.value = "${params.searchActor}";
            //newsForm.searchDirector.value="
            ${params.searchDirector}";
            newsForm.searchDate.value = "${params.searchDate}";
        }

        function maxShow(max) {
            //调用setParams()对查询参数进行负值
            setParams();
            newsForm.max.value = max;
            newsForm.offset.value = 0;
            newsForm.action = "programMore";
            newsForm.submit();
        }

        function orderBy(sort) {
            //调用setParams()对查询参数进行负值
            setParams();
            newsForm.sort.value = sort;
            if (newsForm.order.value == "desc") {
                newsForm.order.value = "asc";
            }
            else {
                newsForm.order.value = "desc";
            }
            newsForm.action = "programMore";
            newsForm.submit();
        }
        function newsSearch() {
            newsForm.action = "programMore";
            newsForm.submit()
        }

    </script>

</head>

<body>
<div class="mainCon">
    <div style="height:5px;"></div>

    <form method="post" name="newsForm" id="newsForm">
        <input type="hidden" name="offset" value="${params.offset}"/>
        <input type="hidden" name="sort" value="${params.sort}"/>
        <input type="hidden" name="order" value="${params.order}"/>
        <input type="hidden" name="max" value="${params.max}"/>

        <table width="98%" border="1" cellpadding="0" cellspacing="0" bordercolor="#E9E8E7">
            <tr>
                <td width="5%" align="center">${Program.cnField["name"]}:</td>
                <td width="10%" align="left"><input type="text" class="newsinput1" name="searchTitle" value=""/></td>
                <td width="5%" align="center">${Program.cnField["actor"]}:</td>
                <td width="10%" align="left"><input type="text" class="newsinput1" name="searchActor" value=""/></td>
                <td width="5%" align="center">${Program.cnField["dateCreated"]}:</td>
                <td width="10%" align="left">
                    <input name="searchDate" id="searchDate" type="text" class="newsinput1" readOnly=""
                           value="${params.searchDate}" onClick="return Calendar('searchDate');">
                </td>
                <td width="5%" align="center"><input name="search" type="button" class="button" onClick="newsSearch()"
                                                     value="查询"/></td>
            </tr>
        </table>

        <table width="98%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
            <tr bgcolor="#BDEDFB">
                <td width="10%" height="28" align="center" class="STYLE5"><a href="#"
                                                                             onClick="orderBy('name')">${Program.cnField["name"]}</a>
                </td>
                <td width="2%" align="center" class="STYLE5"><a href="#"
                                                                onClick="orderBy('actor')">${Program.cnField["actor"]}</a>
                </td>
                <td width="2%" align="center" class="STYLE5"><a href="#"
                                                                onClick="orderBy('consumer')">${Program.cnField["consumer"]}</a>
                </td>
                <td width="2%" align="center" class="STYLE5"><a href="#"
                                                                onClick="orderBy('frequency')">${Program.cnField["frequency"]}</a>
                </td>
                <td width="2%" align="center" class="STYLE5"><a href="#"
                                                                onClick="orderBy('downloadNum')">${Program.cnField["downloadNum"]}</a>
                </td>
                <td width="2%" align="center" class="STYLE5"><a href="#"
                                                                onClick="orderBy('dateCreated')">${Program.cnField["dateCreated"]}</a>
                </td>
            </tr>
            <g:each in="${programList}" status="i" var="programs">
                <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                    <td height="23" align="left" nowrap="nowrap" class="STYLE5"><g:link controller="program"
                                                                                        title="${fieldValue(bean: programs, field: 'name')}"
                                                                                        action="showProgram"
                                                                                        target="_blank"
                                                                                        id="${programs.id}"
                                                                                        class="link1">&nbsp;${fieldValue(bean: programs, field: 'name')}</g:link></td>
                    <td align="left" nowrap="nowrap"
                        class="STYLE5">&nbsp;${fieldValue(bean: programs, field: 'actor')}</td>
                    <td align="center" class="STYLE5">${fieldValue(bean: programs, field: 'consumer.name')}</td>
                    <td align="center" class="STYLE5">${fieldValue(bean: programs, field: 'frequency')}</td>
                    <td align="center" class="STYLE5">${fieldValue(bean: programs, field: 'downloadNum')}</td>
                    <td align="center" class="STYLE5"><g:formatDate format="yyyy-MM-dd"
                                                                    date="${programs.dateCreated}"/></td>
                </tr>
            </g:each>
        </table>

        <TABLE width="98%" height="16" border=0 cellPadding=1 cellSpacing=1 bgcolor="#E9E8E7">
            <TBODY>
            <TR>
                <TD height="16" align="center"><div align="left">每页显示：
                    <a href="#" onClick="maxShow(10)">
                        <IMG id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" width=19 height=16
                             border=0 class="STYLE8" title="每页显示10条">
                    </a>&nbsp;
                    <a href="#" onClick="maxShow(50)">
                        <IMG id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" width=20 height=15
                             border=0 class="STYLE8" title="每页显示50条">
                    </a>&nbsp;
                    <a href="#" onClick="maxShow(100)">
                        <IMG id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" width="27"
                             height="16" border=0 class="STYLE8" title="每页显示100条">
                    </a>
                    <a href="#" onClick="maxShow(200)">
                        <IMG id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" width="28"
                             height="16" border=0 class="STYLE8" title="每页显示200条">
                    </a>
                </div></TD>

                <TD width="600" align="right" style="height:40px;">
                    <div class="paginateButtons"><g:paginate total="${total}" offset="${params.offset}"
                                                             action="programMore" params="${params}"/>&nbsp;&nbsp;</div>
                </TD>
            </TR>
            </TBODY>
        </TABLE>
    </form>
    <script Language="JavaScript">
        changePageImg(${params.max});
    </script>

    <div style="height:10px;"></div>
</div>
</body>
</html>

