<%@ page import="nts.utils.CTools" %>
<html>
<head>
    <title>我的活动作品</title>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <script type="text/javascript">
        var localObj = window.location;
        var contextPath = localObj.pathname.split("/")[1];
        var baseUrl = '';
        if ('nts' != contextPath) {
            baseUrl = localObj.protocol + "//" + localObj.host + "/";
        } else {
            baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
        }

        //搜索
        function search() {
            if (!widthCheck($('#name').val().trim(), 50)) {
                alert('搜索名称不能大于50个字符');
                $('#name').select();
                return;
            }
            document.userWorkForm.action = "myUserWorkList";
            document.userWorkForm.submit();
        }

        //排序
        function orderBy(orderName) {
            window.location.href = baseUrl + "my/myUserWorkList?orderName=" + orderName;
        }
    </script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <!--[if lte IE 6]>
<Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style-ie6.css')}" type=text/css rel=stylesheet>
<![endif]-->
    <script type="text/javascript" src="${createLinkTo(dir: 'js/jquery', file: 'dropdown.js')}"></script>
</head>

<body>
<div class="userspace_title">
    <a href="">当前位置：${message(code: 'my.mined.name')}${message(code: 'my.activities.name')}${message(code: 'my.works.name')}</a>
</div>

<div class="space_line"></div>

<div id="main-content">

    <div class="content-box-header">
        <ul class="content-box-tabs">

            <li><a href="${createLink(controller: 'my', action: 'myUserActivityManager')}">${message(code: 'my.joining.name')}${message(code: 'my.activities.name')}</a>
            </li>
            <li><a class="default-tab current"
                   href="${createLink(controller: 'my', action: 'myUserWorkList')}">${message(code: 'my.mined.name')}${message(code: 'my.activities.name')}${message(code: 'my.works.name')}</a>
            </li>

        </ul>

        <div class="clear"></div>
    </div>
    <g:form style="padding: 0 10px;" name="userWorkForm" method="post" controller="my" action="myUserWorkList">
        <table style="width: 735px; margin: 8px 0;">
            <tr>
                <td style="width: 45px; text-align: left"><span>状态:</span></td>
                <td style="width:160px;"><select class="" style="width: 120px;" name="approval">
                    <option value="">--请选择--</option>
                    <option value="1" <g:if test="${params.approval == '1'}">selected</g:if>>审批未通过</option>
                    <option value="2" <g:if test="${params.approval == '2'}">selected</g:if>>待审批</option>
                    <option value="3" <g:if test="${params.approval == '3'}">selected</g:if>>审批通过</option>
                </select></td>
                <td style="width: 65px;text-align: left;"><span>检索名称:</span></td>
                <td style="width: 230px; height:25px; text-align: left;"><input style="width: 220px; height: 26px;"
                                                                                name="name" id="name"
                                                                                value="${params.name}"></td>
                <td><input class="admin_default_but_green" style="float: right" onclick="search();" value="检索"></td>
            </tr>

        </table>

        <table class="table table-striped" style="background: #FFF">
            <thead>
            <tr>
                <th>ID</th>
                <th>作品名称</th>
                <th>活动名称</th>
                <th>投票数</th>
                <th>转码状态</th>
                <th>审批状态</th>
                <th>创建时间</th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${userWorkList}" status="i" var="userWork">
                <tr>
                    <td align="left">${userWork.id}</td>
                    <td align="left"><a
                            href="${createLink(controller: 'userWork', action: 'show', params: [id: userWork.id])}"
                            title="${userWork.name}"
                            target="blank">${CTools.cutString(fieldValue(bean: userWork, field: 'name'), 16)}</a>
                    </td>
                    <td align="left"><a
                            href="${createLink(controller: 'userActivity', action: 'show', params: [id: userWork?.userActivity?.id])}"
                            title="${userWork?.userActivity?.name}"
                            target="blank">${CTools.cutString(fieldValue(bean: userWork?.userActivity, field: 'name'), 16)}</a>
                    </td>
                    <td align="left">${userWork.voteNum}</td>
                    <td align="left">${userWork.transcodeState == 0 ? "不转码" : userWork.transcodeState == 1 ? "待转码" : userWork.transcodeState == 2 ? "正在转码" : userWork.transcodeState == 3 ? "已转码" : "转码失败"}</td>
                    <td align="left">${userWork.approval == 1 ? "审批未通过" : userWork.approval == 2 ? "待审批" : "审批通过"}</td>
                    <td align="left"><g:formatDate date="${userWork.dateCreated}" format="yyyy-MM-dd"/></td>
                </tr>
            </g:each>

            </tbody>
        </table>
    </g:form>
    <div class="page wrap" style="text-align: left">
        <g:paginate controller="my" action="myUserWorkList" total="${total}"/>
    </div>
</div>
</body>
</html>
