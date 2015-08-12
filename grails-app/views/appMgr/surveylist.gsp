<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>答卷管理</title>
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
        line-height: 18px;
    }

    .STYLE9 {
        color: #990000;
        font-weight: bold;
        font-size: 12px;
    }
    </style>

    <SCRIPT LANGUAGE="JavaScript">
        function submitSch() {
            document.form1.action = baseUrl + "appMgr/surveylist"
            document.form1.submit();
        }

        function onPageNumPer(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;

            submitSch();
        }

        function deleteLog() {
            if (hasChecked("idList") == false) {
                alert("请至少选择一条问题！");
                return false;
            }

            form1.action = baseUrl + "appMgr/surveyDelete"
            form1.submit()
        }
    </SCRIPT>
</head>

<body>
<div class="x_daohang">
    <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>><a
        href="${createLink(controller: 'appMgr', action: 'surveylist')}">调查问卷</a>>> 答卷管理
</div>
<div style="margin-left: 15px; width: 98%; margin-bottom: 0; overflow: hidden; ">
    <form name="form1" method="post" style="width:100%">
        <input type="hidden" name="max" value="${params.max}">
        <input type="hidden" name="offset" value="${params.offset}">


        <table width="100%" style="border:0; margin-top: 10px;"  border="1" cellspacing="0" cellpadding="0" bordercolor="#e2e3e4"
               id="progListTab">
            <tr>
                <th width="50" align="center" style="font-weight:normal;">选择</td>
                <th align="center" style="font-weight:normal;">问卷名称</td>
                <th width="50" align="center" style="font-weight:normal;">答卷人</td>
                    <g:sortableColumn property="dateCreated"
                                      title="${message(code: 'qnaire.dateCreated.label', default: '回答时间')}"/>
                <th width="80" align="center" style="font-weight:normal;">查看</td>
            </tr>
            <g:each in="${surveyList}" status="i" var="survey">
                <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                    <td align="center">
                        <g:checkBox name="idList" value="${survey.id}" checked="" onclick="unCheckAll('selall');"/>
                    </td>
                    <td align="left">${survey.qnaire.name}</td>
                    <td align="center" width="120">
                        <g:link action="surveyShow" id="${survey.id}">
                            ${survey.consumer.nickname}
                        </g:link>
                    </td>
                    <td align="center" width="160"><g:formatDate format="yyyy-MM-dd HH:mm:ss"
                                                                 date="${survey.dateCreated}"/></td>
                    <td align="center">
                        <g:link action="showSurvey" id="${survey.id}">
                            <img src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" width="14" height="14" border="0">
                        </g:link>
                    </td>
                </tr>
            </g:each>
        </table>
        <table width="100%">
            <tr>
                <td>
                    <input id="selall" name="selall" onclick="checkAll(this, 'idList')" type="checkbox">&nbsp;全选&nbsp;
                    <input class="button" type="button" value="删除所选" onClick="deleteLog()"/>&nbsp;
                </td>
            </tr>
        </table>
        <table width="100%" style="border: 0px;" height="16" border="0" cellpadding="1" cellspacing="1"
               bgcolor="#E9E8E7">
            <tr>
                <td width="600" height="16" style="cursor:hand">
                    &nbsp;总共：${surveyTotal} 条记录&nbsp;|&nbsp;每页${params.max}条&nbsp;|&nbsp;每页显示:
                    <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                         onclick="onPageNumPer(10)">
                    <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0"
                         onclick="onPageNumPer(50)">
                    <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0"
                         onclick="onPageNumPer(100)">
                    <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0"
                         onclick="onPageNumPer(200)">
                </td>
                <td width="600" height="16" align="right" style="cursor:hand">
                    <div class="paginateButtons"><g:paginate total="${surveyTotal}" params="${params}"/></div>
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
