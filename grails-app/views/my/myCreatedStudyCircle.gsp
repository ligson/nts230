<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>我创建的学习圈</title>
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

        //级联查询二级类别
        function showToLower(obj) {
            var request_url = baseUrl + "studyCircle/toLower"; // 需要获取内容的url
            var request_pars = "categoryID=" + obj.value;//请求参数

            var myAjax = new Ajax.Updater('categoryLower', request_url, { // 将request_url返回内容绑定到id为result的容器中
                method: 'post', //HTTP请求的方法,get or post
                parameters: request_pars, //请求参数
                onFailure: reportError, //失败的时候调用 reportError 函数
                onLoading: loading, //正在获得内容的时候
                onComplete: done() //内容获取完毕的时候
            });
        }

        function loading() {
        }

        function done() {
        }

        function reportError(request) {
            alert(request);
        }

        //操作
        function operate(controller, action, operation) {
            if (hasChecked("idList") == false) {
                alert("请至少选择一条记录！");
                return false;
            }
            if (action == 'deleteStudyCircle') {
                if (confirm("确实要删除该学习圈吗？") == false) return;
            }
            else if (action == 'dismissStudyCircle') {
                if (confirm("确实要解散该学习圈吗？") == false) return;
            }
            document.form1.action = baseUrl + controller + "/" + action;
            document.form1.submit();
        }

        //每页显示多少条
        function maxShow(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;
            document.form1.submit();
        }

        function showStudyCircle(id) {
            //window.top.mainFrame.location.href = baseUrl + 'studyCircle/show?id='+id ;
            //location.href = 'baseUrl + 'studyCircle/show?id='+id ;
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
                    <li><a href="${createLink(controller: 'my', action: 'myCreatedStudyCircle')}" class="default-tab current">我创建的学习圈</a></li>
                    <li><a href="${createLink(controller: 'my', action: 'mySynergicStudyCircle')}">我协作的学习圈</a></li>
                    <li><a href="${createLink(controller: 'my', action: 'mySubscriptionStudyCircle')}">我订阅的学习圈</a></li>
                </ul>

                <div class="clear"></div>
            </div>

            <div class="content-box-content">
                <div class="tab-content default-tab">
                    <form name="form1" method="post" action="/my/myCreatedStudyCircle">
                        <table style="border:none">
                            <tfoot>
                            <tr>
                                <td style="border:none; padding:0">
                                    <div class="align-left pb10">
                                        <fieldset style="width:780px">
                                            状态：<select name="state">
                                            <option value="1"
                                                    <g:if test="${params.state == '1'}">selected</g:if>>已通过</option>
                                            <option value="2"
                                                    <g:if test="${params.state == '2'}">selected</g:if>>审核中</option>
                                            <option value="0"
                                                    <g:if test="${params.state == '0'}">selected</g:if>>已禁用</option>
                                        </select>
                                            检索名称：<input class="text-input small-input clear mr10" type="text"
                                                        name="schName" id="schName" value="${params.schName}"/>
                                            <a class="button" href="javascript:void(0);"
                                               onclick="javascript:submitSch();
                                               return false;">检索</a>
                                        </fieldset>
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
                                <th width="100">创建时间</th>
                                <th width="160">分类</th>
                                <th width="80">状态</th>
                                <th width="30">修改</th>
                                <th width="30">解散</th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${studyCircleList}" status="i" var="studyCircle">
                                <tr class="${(i % 2) == 0 ? 'alt-row' : ''}">
                                    <td align="center"><input type="checkbox" name="idList" value="${studyCircle.id}"
                                                              onclick="unCheckAll('selall');" id="idList"/></td>
                                    <td align="center"><a href="${createLink(controller: 'studyCircle', action: 'show', params: [id: studyCircle.id])}"
                                                          target="_blank">${studyCircle?.name.encodeAsHTML()}</a></td>
                                    <td align="center" class="STYLE5"><g:formatDate format="yyyy-MM-dd HH:mm:ss"
                                                                                    date="${studyCircle?.dateCreated}"/></td>
                                    <td align="center"><g:if
                                            test="${studyCircle.circleCategory != null}">${studyCircle?.circleCategory?.name.encodeAsHTML()}</g:if><g:else>无</g:else></td>
                                    <td align="center">
                                        <g:if test="${studyCircle.state == 1}">已通过</g:if>
                                        <g:if test="${studyCircle.state == 2}">审核中</g:if>
                                        <g:if test="${studyCircle.state == 0}">已禁用</g:if>
                                    </td>
                                    <td align="center">
                                        <a href="${createLink(controller: 'studyCircle', action: 'edit', params: [id: studyCircle.id])}"><img
                                                src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="编辑" border="0"></a>
                                    </td>
                                    <td align="center">
                                        <a href="${createLink(controller: 'my', action: 'dismissStudyCircle', params: [idList: studyCircle.id])}"
                                           onclick="return confirm('确实要解散该学习圈吗？');"><img
                                                src="${resource(dir: 'images/skin', file: 'delete.gif')}" alt="解散" border="0"></a>
                                    </td>
                                </tr>
                            </g:each>
                            </tbody>
                        </table>

                        <div class="l pt10 pb10">
                            <input class="qqbut" type="button" value="删除"
                                   onClick="operate('my', 'deleteStudyCircle', '');"/>
                            <input class="qqbut" type="button" value="解散"
                                   onClick="operate('my', 'dismissStudyCircle', '');"/>
                        </div>

                        <div class="qfy mt5 mb10">
                            <g:if test="${studyCircleList != null && studyCircleList.size() > 0}">
                                <g:paginate controller="my" action="myCreatedStudyCircle" total="${studyCircleTotal}"
                                            params="${params}" maxsteps="5"/>
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

                        <input type="hidden" name="max" value="${params.max}">
                        <input type="hidden" name="offset" value="${params.offset}">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
