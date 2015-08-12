<%@ page import="nts.utils.CTools" %>
<html>
<head>
    <title>我的活动管理</title>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
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
            document.userActivityForm.action = "myUserActivityManager";
            document.userActivityForm.submit();
        }

        //排序
        function orderBy(orderName) {
            window.location.href = baseUrl + "my/myUserActivityManager?orderName=" + orderName;
        }

        function createUserWork(id, isOpen, startTime, endTime) {
            if (new Date(Date.parse(startTime)) > new Date()) {
                alert("对不起，活动尚未开始！");
                return;
            } else if (new Date(Date.parse(endTime.replace(/-/g, "/"))) - new Date() < -24 * 60 * 60 * 1000) {
                alert("对不起，活动已经结束！");
                return;
            }

            if (!isOpen || isOpen == 'false') {
                alert("对不起，活动已关闭！");
                return;
            }
            window.open(baseUrl + 'userActivity/show?id=' + id, "_blank");
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
    <a href="">当前位置：${message(code: 'my.joining.name')}${message(code: 'my.activities.name')}</a>
</div>

<div class="space_line"></div>

<div id="main-content">

    <div class="content-box-header">
        <ul class="content-box-tabs">

            <li><a href="${createLink(controller: 'my', action: 'myUserActivityManager')}"
                   class="default-tab current">${message(code: 'my.joining.name')}${message(code: 'my.activities.name')}</a>
            </li>
            <li><a href="${createLink(controller: 'my', action: 'myUserWorkList')}">${message(code: 'my.mined.name')}${message(code: 'my.activities.name')}${message(code: 'my.works.name')}</a>
            </li>

        </ul>

        <div class="clear"></div>
    </div>
    <g:form style="padding: 0 10px;" name="userActivityForm" method="post" controller="my"
            action="myUserActivityManager">
        <table style="width: 735px; margin: 8px 0;">
            <tr>
                <td style="width: 45px; text-align: left"><span>状态:</span></td>
                <td style="width:160px;"><select class="" style="width: 120px;" name="state">
                    <option value="">--请选择--</option>
                    <option value="1" <g:if test="${params.state == '1'}">selected</g:if>>未开始</option>
                    <option value="2" <g:if test="${params.state == '2'}">selected</g:if>>正在进行</option>
                    <option value="3" <g:if test="${params.state == '3'}">selected</g:if>>已结束</option>
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
                <th width="30%">活动名称</th>
                <th><span style="cursor: pointer" onclick="orderBy('startTime')">活动时间</span></th>
                <th><span style="cursor: pointer" onclick="orderBy('endTime')">结束时间</span></th>
                <th><span style="cursor: pointer" onclick="orderBy('workNum')">作品数</span></th>
                <th><span style="cursor: pointer" onclick="orderBy('voteNum')">投票数</span></th>
                <th>状态</th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${userActivityList}" status="i" var="userActivity">
                <tr>
                    <td align="left">${userActivity.id}</td>
                    <td align="left"><a
                            onclick="createUserWork('${userActivity.id}', '${userActivity.isOpen}', '${userActivity.startTime}', '${userActivity.endTime}');
                            return false;"
                            href="javascript:void(0);" title="${userActivity.name}"
                            target="blank">${CTools.cutString(fieldValue(bean: userActivity, field: 'name'), 16)}</a>
                    </td>
                    <td align="left">${userActivity.startTime}</td>
                    <td align="left">${userActivity.endTime}</td>
                    <td align="left">${userActivity.workNum}</td>
                    <td align="left">${userActivity.voteNum}</td>
                    <td align="left">${userActivity.isOpen ? "开启" : "关闭"}</td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </g:form>

    <div class="page wrap" style="text-align: left">
        <g:paginate controller="my" action="myUserActivityManager" total="${total}"/>
    </div>
</div>
</body>
</html>
