<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>nts</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'reset.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'style_my.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'invalid.css')}" type="text/css"/>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/prototype.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/truevod.js')}"></script>

    <SCRIPT LANGUAGE="JavaScript">
        function submitSch() {
            form1.action = "myQnaireList";
            document.form1.submit();
        }

        function onPageNumPer(max) {
            document.form1.max.value = max;
            submitSch();
        }
    </SCRIPT>
</head>

<body>
<div style="margin-top:5px"></div>

<div id="body-wrapper">
    <g:render template="myLeft"/>
    <div id="main-content">
        <div class="content-box">
            <div class="content-box-header">
                <ul class="content-box-tabs">
                    <li><a href="${createLink(controller: 'my', action: 'myQnaireList')}" class="default-tab current">问卷列表</a></li>
                </ul>

                <div class="clear"></div>
            </div>

            <div class="content-box-content">
                <div class="tab-content default-tab">
                    <form name="form1">
                        <input type="hidden" name="max" value="${params.max}">
                        <table cellpadding="0" cellspacing="0" width="782">
                            <thead>
                            <tr>
                                <th width="180">问卷名称</th>
                                <th width="82">调查人次</th>
                                <th width="144">发布时间</th>
                                <th width="72">查看</th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${qnaireList}" status="i" var="qnaire">
                                <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                                    <td><a href="${createLink(controller: 'my', action: 'qnairePage', params: [id: qnaire?.id])}">
                                        ${qnaire.name.encodeAsHTML()}</a>
                                    </td>
                                    <td align="center">${qnaire.surveyNum}</td>
                                    <td align="center"><g:formatDate format="yyyy-MM-dd HH:mm:ss"
                                                                     date="${qnaire.datePublished}"/></td>
                                    <td align="center">
                                        <a href="${createLink(controller: 'my', action: 'qnairePage', params: [id: qnaire?.id])}">查看</a>
                                    </td>
                                </tr>
                            </g:each>
                            </tbody>
                        </table>
                        <table width="96%" style="border:0px;margin:0px" height="16" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="350" height="16" align="left" style="border:none">
                                    &nbsp;总共：${qnaireTotal}条记录&nbsp;每页${params.max}条&nbsp;每页显示:
                                    <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                                         onclick="onPageNumPer(10)">&nbsp;
                                    <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0"
                                         onclick="onPageNumPer(50)">&nbsp;
                                    <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条"
                                         border="0" onclick="onPageNumPer(100)">&nbsp;
                                    <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条"
                                         border="0" onclick="onPageNumPer(200)">&nbsp;
                                </td>
                                <td align="right" style="border:none">
                                    <div class="paginateButtons"><g:paginate total="${qnaireTotal}"
                                                                             params="${params}"/></div>
                                </td>
                            </tr>
                        </table>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>