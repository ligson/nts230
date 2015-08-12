<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>我订阅的学习圈</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'reset.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'style_my.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'invalid.css')}" type="text/css"/>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" rel="stylesheet" type="text/css">

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <script type="text/javascript">
        //搜索
        function submitSch() {
            if (!widthCheck($F('schName').trim(), 100)) {
                alert('搜索名称不能大于100个字符');
                $('schName').select();
                return;
            }

            document.form1.submit();
        }

        //操作
        function operate(controller, action, operation) {
            if (hasChecked("idList") == false) {
                alert("请至少选择一条记录！");
                return false;
            }
            if (action == 'cancelCooperation') {
                if (confirm("确实要取消协作吗？") == false) return;
            }
            else if (action == 'quitStudyCircle') {
                if (confirm("确实要退出学习圈吗？") == false) return;
            }
            document.form1.action = baseUrl + controller + "/" + action;
            document.form1.submit();
        }

        //每页显示多少条
        function maxShow(max) {
            //document.form1.max.value=max;
            //document.form1.offset.value=0;
            document.getElementById('maxValue').value = max;
            document.getElementById('offsetValue').value = 0;
            document.form1.submit();
        }

        function showStudyCircle(id) {
            window.top.mainFrame.location.href = baseUrl + 'studyCircle/show?id=' + id;
        }
    </script>
</head>

<body>
<div style="margin-top:5px"></div>

<div id="body-wrapper">
    <g:render template="myLeft"/>
    <div id="main-content">
        <div class="content-box">
            <div class="content-box-header">
                <ul class="content-box-tabs">
                    <li><a href="${createLink(controller: 'my', action: 'myCreatedStudyCircle')}">我创建的学习圈</a></li>
                    <li><a href="${createLink(controller: 'my', action: 'mySynergicStudyCircle')}">我协作的学习圈</a></li>
                    <li><a href="${createLink(controller: 'my', action: 'mySubscriptionStudyCircle')}" class="default-tab current">我订阅的学习圈</a></li>
                </ul>

                <div class="clear"></div>
            </div>

            <div class="content-box-content">
                <div class="tab-content default-tab">
                    <form name="form1" method="post" action="/my/mySubscriptionStudyCircle">
                        <table style="border:none">
                            <tfoot>
                            <tr>
                                <td style="border:none; padding:0">
                                    <div class="bulk-actions align-left">
                                        <form action="#" method="post">
                                            <fieldset style="width:770px">
                                                检索名称：<input class="text-input small-input clear mr10" type="text"
                                                            name="schName" id="schName" value="${params.schName}"/>
                                                <a class="button" href="javascript:void(0);"
                                                   onclick="javascript:submitSch();
                                                   return false;">检索</a>
                                            </fieldset>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            </tfoot>
                        </table>

                        <table cellpadding="0" cellspacing="0" width="782">
                            <thead>
                            <tr>
                                <th width="20" align="center"><input type="checkbox" id="selall" name="selall"
                                                                     onclick="checkAll(this, 'idList')"/></th>
                                <th width="240">学习圈名称</th>
                                <th width="90">创建者</th>
                                <th width="140">创建时间</th>
                                <th width="80">分类</th>
                                <th width="70">退出学习圈</th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${studyCircleList}" status="i" var="studyCircle">
                                <tr class="${(i % 2) == 0 ? 'alt-row' : ''}">
                                    <td align="center"><input type="checkbox" name="idList" value="${studyCircle.id}"
                                                              onclick="unCheckAll('selall');" id="idList"/></td>
                                    <td align="center"><a href="${createLink(controller: 'studyCircle', action: 'show', params: [id: studyCircle.id])}"
                                                          target="_blank">${studyCircle?.name.encodeAsHTML()}</a></td>
                                    <td align="center">${studyCircle.createConsumer.name.encodeAsHTML()}</td>
                                    <td align="center" class="STYLE5"><g:formatDate format="yyyy-MM-dd HH:mm:ss"
                                                                                    date="${studyCircle?.dateCreated}"/></td>
                                    <td align="center"><g:if
                                            test="${studyCircle.circleCategory != null}">${studyCircle?.circleCategory?.name.encodeAsHTML()}</g:if><g:else>无</g:else></td>
                                    <td align="center">
                                        <a href="${createLink(controller: 'my', action: 'quitStudyCircle', params: [idList: studyCircle.id, type: 2])}"
                                           onclick="return confirm('确实要退出该学习圈吗？');"><img
                                                src="${resource(dir: 'images/skin', file: 'delete.gif')}" alt="取消协作" border="0"></a>
                                    </td>
                                </tr>
                            </g:each>
                            </tbody>
                        </table>

                        <div class="l pt10 pb10">
                            <input class="qqbut" type="button" value="退出学习圈"
                                   onClick="operate('my', 'quitStudyCircle', '');"/>
                        </div>

                        <div class="qfy mt5 mb10">
                            <g:if test="${studyCircleList != null && studyCircleList.size() > 0}">
                                <g:paginate controller="my" action="mySubscriptionStudyCircle"
                                            total="${studyCircleTotal}" params="${params}" maxsteps="5"/>
                            </g:if>
                        </div>

                        <table width="96%" style="border:0px;margin:0px" height="16" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="300" height="16" align="left" style="border:none">
                                    学习圈数：${studyCircleTotal}&nbsp; 每页显示:
                                    <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                                         onclick="maxShow(10)">&nbsp;
                                    <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0"
                                         onclick="maxShow(50)">&nbsp;
                                    <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条"
                                         border="0" onclick="maxShow(100)">&nbsp;
                                    <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条"
                                         border="0" onclick="maxShow(200)">
                                </td>
                            </tr>
                        </table>
                        <input type="hidden" name="type" value="2">
                        <input type="hidden" name="max" id="maxValue" value="${params.max}">
                        <input type="hidden" name="offset" id="offsetValue" value="${params.offset}">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
