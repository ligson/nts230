<%@ page import="nts.utils.CTools; nts.program.domain.Program" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <title>专题</title>
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
        function onPageNumPer(max) {
            document.form1.max.value = max;
            //document.form1.offset.value = 0;
            document.form1.submit();
        }
        /*
         function init()
         {
         changePageImg(${CTools.nullToOne(params.max)});
         }
         window.onload = init;
         */
    </script>

</head>

<body>
<div class="mainCon">

    <form method="post" action="/index/showProgramTopic" name="form1" id="form1">
        <input type="hidden" name="id" value="${programTopic?.id}"/>
        <input type="hidden" name="sort" value="${params.sort}"/>
        <input type="hidden" name="order" value="${params.order}"/>
        <input type="hidden" name="max" value="${params.max}"/>

        <br>
        <table width="98%" border="1" cellpadding="2" cellspacing="0" bordercolor="#E9E8E7">
            <tr style="line-height:25px;padding:2px;">
                <td width="60">专题名称:</td>
                <td>${fieldValue(bean: programTopic, field: 'name')}</td>
            </tr>
            <tr style="line-height:25px;padding:2px;">
                <td width="60">专题简介:</td>
                <td>${CTools.codeToHtml(programTopic?.description)}</td>
            </tr>
        </table>

        <table width="98%">
            <tr>
                <td>
                    <table width="98%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                        <tr bgcolor="#BDEDFB">
                            <g:sortableColumn property="name" style="height:25px;" title="${Program.cnField['name']}"
                                              params="${params}"/>
                            <td align="center" class="STYLE5">${Program.cnField["actor"]}</td>
                            <td align="center" class="STYLE5">${Program.cnField["consumer"]}</td>
                            <g:sortableColumn property="frequency" title="${Program.cnField['frequency']}"
                                              params="${params}"/>
                            <g:sortableColumn property="downloadNum" title="${Program.cnField['downloadNum']}"
                                              params="${params}"/>
                            <g:sortableColumn property="id" title="${Program.cnField['dateCreated']}"
                                              params="${params}"/>
                        </tr>
                        <g:each in="${programList}" status="i" var="program">
                            <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                                <td height="23" align="left" nowrap="nowrap" class="STYLE5"><g:link controller="program"
                                                                                                    title="${fieldValue(bean: program, field: 'name')}"
                                                                                                    action="showProgram"
                                                                                                    target="_blank"
                                                                                                    id="${program.id}"
                                                                                                    class="link1">&nbsp;${fieldValue(bean: program, field: 'name')}</g:link></td>
                                <td align="left" nowrap="nowrap"
                                    class="STYLE5">&nbsp;${fieldValue(bean: program, field: 'actor')}</td>
                                <td align="center"
                                    class="STYLE5">${fieldValue(bean: program, field: 'consumer.name')}</td>
                                <td align="center" class="STYLE5">${fieldValue(bean: program, field: 'frequency')}</td>
                                <td align="center"
                                    class="STYLE5">${fieldValue(bean: program, field: 'downloadNum')}</td>
                                <td style="text-align:center;" class="STYLE5"><g:formatDate format="yyyy-MM-dd"
                                                                                            date="${program.dateCreated}"/></td>
                            </tr>
                        </g:each>
                    </TABLE>
                <td>
            </tr>
        </table>

        <table width="99%" style="border: 0px;" height="16" border="0" cellpadding="1" cellspacing="1"
               bgcolor="#E9E8E7">
            <tr>
                <td height="16" align="center">
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

                <td align="right"><div class="paginateButtons"><g:paginate total="${total}" params="${params}"/></div>
                </td>
            </tr>
        </table>

    </form>
</div>
</body>
</html>

