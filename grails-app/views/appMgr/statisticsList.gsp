<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>统计</title>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <style>


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
        line-height: 28px;
    }

    .STYLE9 {
        color: #990000;
        font-weight: bold;
        font-size: 12px;
    }

    </style>

    <SCRIPT LANGUAGE="JavaScript">
        function submitSch() {
            document.form1.action = baseUrl + "appMgr/statisticsList"
            document.form1.submit();
        }

        function onPageNumPer(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;

            submitSch();
        }
    </SCRIPT>
</head>

<body>
<div class="x_daohang">
    <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>><a
        href="${createLink(controller: 'appMgr', action: 'qnaireList')}">调查问卷</a>>> 统计
</div>

<div style="margin-left: 15px; width: 98%; margin-bottom: 0; overflow: hidden; ">
    <form name="form1" method="post" style="width:99%">
        <input type="hidden" name="max" value="${params.max}">
        <input type="hidden" name="offset" value="${params.offset}">

        <table width="100%" style="border: 0px; margin-top: 15px;" border="1" cellspacing="0" cellpadding="0"
               bordercolor="#FFFFFF" id="progListTab">
            <tr>
                <g:sortableColumn property="name" title="${message(code: 'qnaire.name.label', default: '问卷名称')}"/>
                <g:sortableColumn width="80" property="surveyNum"
                                  title="${message(code: 'qnaire.surveyNum.label', default: '调查人次')}"/>
                <g:sortableColumn property="dateCreated"
                                  title="${message(code: 'qnaire.datePublished.label', default: '发布时间')}"/>
                <td width="80" align="center" style="font-weight:normal;">查看</td>
            </tr>
            <g:each in="${qnaireList}" status="i" var="qnaire">
                <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                    <td>
                        <g:link action="showStatistics" id="${qnaire.id}">
                            ${fieldValue(bean: qnaire, field: "name")}
                        </g:link>
                    </td>
                    <td align="center">${fieldValue(bean: qnaire, field: 'surveyNum')}</td>
                    <td align="center"><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${qnaire.datePublished}"/></td>
                    <td align="center">
                        <g:link action="showStatistics" id="${qnaire.id}">
                            <img src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" width="14" height="14" border="0">
                        </g:link>
                    </td>
                </tr>
            </g:each>
        </table>
        <table width="100%" style="border: 0px; margin-top: 10px;" height="16" border="0" cellpadding="1"
               cellspacing="1" bgcolor="#E9E8E7">
            <tr>
                <td width="600" height="16" style="cursor:hand">
                    &nbsp;总共：${qnaireTotal} 条记录&nbsp;|&nbsp;每页${params.max}条&nbsp;|&nbsp;每页显示:
                    <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                         onclick="onPageNumPer(10)">&nbsp;<img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}"
                                                               alt="每页显示50条" border="0"
                                                               onclick="onPageNumPer(50)">&nbsp;<img id="Img100"
                                                                                                     src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}"
                                                                                                     alt="每页显示100条"
                                                                                                     border="0"
                                                                                                     onclick="onPageNumPer(100)">&nbsp;<img
                        id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0"
                        onclick="onPageNumPer(200)">&nbsp;
                </td>
                <td height="16" align="right" style="cursor:hand">
                    <div class="paginateButtons"><g:paginate total="${qnaireTotal}" params="${params}"/></div>
                </td>
            </tr>
        </table>
    </form>
</div>
<script Language="JavaScript">
    changePageImg(${params.max});
</script>
</body>
</html>