<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="my"/>
    <title>我创建的学习圈</title>

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <script type="text/javascript">
        //----------begin-------------
        //设置查询参数
        function setParams() {
            document.userActivityForm.name.value = "${params.name}";
            document.userActivityForm.state.value = "${params.state}";
        }
        //搜索
        function search() {
            if (!widthCheck($F('name').trim(), 50)) {
                alert('搜索名称不能大于50个字符');
                $('name').select();
                return;
            }
            document.userActivityForm.action = "myJoinList";
            document.userActivityForm.submit();
        }
        //删除活动
        function deleteUserActivity(id) {
            setParams();
            document.userActivityForm.action = baseUrl + "userActivity/delete?id=" + id;
            document.userActivityForm.submit();
        }
        //批量删除活动
        function deleteUserActivityList() {
            if (!confirm('确定删除选中的活动吗?')) return false;

            setParams();
            document.userActivityForm.action = "deleteUserActivityList";
            document.userActivityForm.submit();
        }
        //创建活动
        function createUserActivity() {
            document.userActivityForm.action = "create";
            document.userActivityForm.submit();
        }
        //每页显示多少条
        function maxShow(max) {
            document.userActivityForm.max.value = max;
            document.userActivityForm.offset.value = 0;
            document.userActivityForm.submit();
        }
        //----------end-------------
    </script>
</head>

<body>
<div id="main-content"><!-- Main Content Section with everything -->
    <div class="content-box"><!-- Start Content Box -->
        <div class="content-box-header">
            <ul class="content-box-tabs">
                <li><a href="${createLink(controller: 'userActivity', action: 'myJoinList')}" class="default-tab current">我参与的活动</a></li>
                <g:if test="${session.consumer?.role != null && session.consumer?.role != 3}">
                    <li><a href="${createLink(controller: 'userActivity', action: 'myList')}">我发起的活动</a></li>
                </g:if>
                <li><a href="${createLink(controller: 'userWork', action: 'myList')}">我提交的作品</a></li>
            </ul>

            <div class="clear"></div>
        </div> <!-- End .content-box-header -->
        <div class="content-box-content">
            <div class="tab-content default-tab" id="tab1">
                <form name="userActivityForm" method="post" action="myList">
                    <input type="hidden" name="max" value="${params.max}">
                    <input type="hidden" name="offset" value="${params.offset}">
                    <table width="96%" border="0" cellspacing="0" cellpadding="0" class="borbt" bordercolor="#FFFFFF"
                           id="progListTab"
                           style="margin-left:0px; margin-right:0px;margin-top:10px;margin-bottom:10px;">
                        <tr>
                            <td>状态：&nbsp;<select style="border:1px solid #dddddd;" name="state">
                                <option value="">--请选择--</option>
                                <option value="1" <g:if test="${params.state == '1'}">selected</g:if>>未开始</option>
                                <option value="2" <g:if test="${params.state == '2'}">selected</g:if>>正在进行</option>
                                <option value="3" <g:if test="${params.state == '3'}">selected</g:if>>已结束</option>
                            </select>&nbsp;&nbsp;&nbsp;&nbsp;检索名称：&nbsp;<input name="name" id="name"
                                                                               value="${params.name}"
                                                                               style="width:200px;">&nbsp;&nbsp;<a
                                    href="javascript: search();" class="button">检索</a>
                            </td>
                        </tr>
                    </table>

                    <table width="96%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF" id="progListTab"
                           style="margin:0px">
                        <tr>
                            <td width="35%" align="center" bgcolor="#BDEDFB" class="STYLE5">活动名称</td>
                            <td width="8%" align="center" bgcolor="#BDEDFB" class="STYLE5">发起者</td>
                            <td width="10%" align="center" bgcolor="#BDEDFB" class="STYLE5">开始时间</td>
                            <td width="10%" align="center" bgcolor="#BDEDFB" class="STYLE5">结束时间</td>
                            <td width="8%" align="center" bgcolor="#BDEDFB" class="STYLE5">作品数</td>
                            <td width="8%" align="center" bgcolor="#BDEDFB" class="STYLE5">投票数</td>
                            <td width="8%" align="center" bgcolor="#BDEDFB" class="STYLE5">进行状态</td>
                        </tr>
                        <g:each in="${userActivityList}" status="i" var="userActivity">
                            <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                                <td align="center"><a href="${createLink(controller: 'userActivity', action: 'show' , params: [id: userActivity.id])}"
                                                      title="${userActivity.name}"
                                                      target="blank">${CTools.cutString(fieldValue(bean: userActivity, field: 'name'), 25)}</a>
                                </td>
                                <td align="center">${userActivity.consumer.name}</td>
                                <td align="center" class="STYLE5">${userActivity.startTime}</td>
                                <td align="center">${userActivity.endTime}</td>
                                <td align="center">${userActivity.workNum}</td>
                                <td align="center">${userActivity.voteNum}</td>
                                <td align="center">${userActivity.isOpen ? "开启" : "关闭"}</td>
                            </tr>
                        </g:each>
                    </table>
                    <br/>

                    <table width="96%" style="border:0px;margin:0px" height="16" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="300" height="16" align="left" style="border:none">
                                活动数：${total}&nbsp;&nbsp; 每页显示:
                                <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                                     onclick="maxShow(10)">&nbsp;
                                <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0"
                                     onclick="maxShow(50)">&nbsp;
                                <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0"
                                     onclick="maxShow(100)">&nbsp;
                                <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0"
                                     onclick="maxShow(200)">
                            </td>
                            <td align="right" style="border:none">
                                <div class="paginateButtons">
                                    <g:paginate controller="userActivity" action="myJoinList" total="${total}"
                                                params="${params}" maxsteps="5"/>
                                </div>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
