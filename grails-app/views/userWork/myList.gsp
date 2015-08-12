<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="my"/>
    <title>我创建的学习圈</title>

    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/commonLib', file: 'string.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript">
        //----------begin-------------
        //设置查询参数
        function setParams() {
            document.userWorkForm.name.value = "${params.name}";
            document.userWorkForm.approval.value = "${params.approval}";
        }
        //搜索
        function search() {
            if (!widthCheck($('#name').val().trim(), 50)) {
                alert('搜索名称不能大于50个字符');
                $('#name').select();
                return;
            }
            document.userWorkForm.action = "myList";
            document.userWorkForm.submit();
        }
        //删除活动
        function deleteUserWork(id) {
            setParams();
            document.userWorkForm.action = baseUrl + "userWork/delete?id=" + id;
            document.userWorkForm.submit();
        }
        //批量删除活动
        function deleteUserWorkList() {
            if (!confirm('确定删除选中的活动吗?')) return false;

            setParams();
            document.userWorkForm.action = "deleteUserWorkList";
            document.userWorkForm.submit();
        }
        //批量开启和关闭活动
        function isOpenUserWorkList(isOpens) {
            if (isOpens && !confirm('确定开启选中的活动吗?')) return false;
            if (!isOpens && !confirm('确定关闭选中的活动吗?')) return false;

            setParams();
            document.userWorkForm.action = baseUrl + "userWork/isOpenUserWorkList?isOpens=" + isOpens;
            document.userWorkForm.submit();
        }
        //每页显示多少条
        function maxShow(max) {
            document.userWorkForm.max.value = max;
            document.userWorkForm.offset.value = 0;
            document.userWorkForm.submit();
        }
        //----------end-------------
    </script>
</head>

<body>
<div id="main-content"><!-- Main Content Section with everything -->
    <div class="content-box"><!-- Start Content Box -->
        <div class="content-box-header">
            <ul class="content-box-tabs">
                <li><a href="${createLink(controller: 'userActivity', action: 'myJoinList')}">我参与的活动</a></li>
                <li><a href="${createLink(controller: 'userActivity', action: 'myList')}">我发起的活动</a></li>
                <li><a href="${createLink(controller: 'userWork', action: 'myList')}" class="default-tab current">我提交的作品</a></li>
            </ul>

            <div class="clear"></div>
        </div> <!-- End .content-box-header -->
        <div class="content-box-content">
            <div class="tab-content default-tab" id="tab1">
                <form name="userWorkForm" method="post" action="myList">
                    <input type="hidden" name="max" value="${params.max}">
                    <input type="hidden" name="offset" value="${params.offset}">
                    <table width="96%" border="0" cellspacing="0" cellpadding="0" class="borbt" bordercolor="#FFFFFF"
                           id="progListTab1"
                           style="margin-left:0px; margin-right:0px;margin-top:10px;margin-bottom:10px;">
                        <tr>
                            <td>状态：&nbsp;<select style="border:1px solid #dddddd;" name="approval">
                                <option value="">--请选择--</option>
                                <option value="2" <g:if test="${params.approval == '2'}">selected</g:if>>审核中</option>
                                <option value="3" <g:if test="${params.approval == '3'}">selected</g:if>>通过</option>
                                <option value="1" <g:if test="${params.approval == '1'}">selected</g:if>>未通过</option>
                            </select>&nbsp;&nbsp;&nbsp;&nbsp;检索名称：&nbsp;<input name="name" id="name"
                                                                               value="${params.name}"
                                                                               style="width:200px;">&nbsp;&nbsp;<a
                                    href="javascript: search();" class="button">检索</a>
                            </td>
                        </tr>
                    </table>

                    <table width="96%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF"
                           id="progListTab2" style="margin:0px">
                        <tr>
                            <td width="4%" align="center" bgcolor="#BDEDFB" class="STYLE5">选择</td>
                            <td width="25%" align="center" bgcolor="#BDEDFB" class="STYLE5">作品名称</td>
                            <td width="25%" align="center" bgcolor="#BDEDFB" class="STYLE5">活动名称</td>
                            <td width="7%" align="center" bgcolor="#BDEDFB" class="STYLE5">投票数</td>
                            <td width="8%" align="center" bgcolor="#BDEDFB" class="STYLE5">创建时间</td>
                            <td width="7%" align="center" bgcolor="#BDEDFB" class="STYLE5">审批状态</td>
                            <td width="8%" align="center" bgcolor="#BDEDFB" class="STYLE5">修改</td>
                            <td width="8%" align="center" bgcolor="#BDEDFB" class="STYLE5">删除</td>
                        </tr>
                        <g:each in="${userWorkList}" status="i" var="userWork">
                            <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                                <td align="center"><input type="checkbox" name="idList" value="${userWork.id}"
                                                          onclick="unCheckAll('selall');" id="idList"/></td>
                                <td align="center"><a href="${createLink(controller: 'userWork', action: 'show' , params: [id: userWork.id])}"
                                                      title="${userWork.name}"
                                                      target="blank">${CTools.cutString(fieldValue(bean: userWork, field: 'name'), 16)}</a>
                                </td>
                                <td align="center" class="STYLE5"><a
                                        href="${createLink(controller: 'userActivity', action: 'show' , params: [id: userWork.userActivity.id])}"
                                        title="${userWork.userActivity.name}"
                                        target="blank">${CTools.cutString(fieldValue(bean: userWork.userActivity, field: 'name'), 16)}</a>
                                </td>
                                <td align="center">${userWork.voteNum}</td>
                                <td align="center"><g:formatDate date="${userWork.dateCreated}"
                                                                 format="yyyy-MM-dd"/></td>
                                <td align="center">${userWork.approval == 1 ? "未通过" : userWork.approval == 2 ? "审核中" : "通过"}</td>
                                <td align="center">
                                    <a href="${createLink(controller: 'userWork', action: 'edit' , params: [id: userWork.id])}"><img src="${resource(dir: 'images/skin', file: 'modi.gif')}"
                                                                                        alt="编辑" border="0"></a>
                                </td>
                                <td align="center">
                                    <a href="javascript: void(0);" onclick="if (confirm('确实要删除该活动吗？')) {
                                        deleteUserWork(${userWork.id});
                                    }"><img src="${resource(dir: 'images/skin', file: 'delete.gif')}" alt="解散" border="0"></a>
                                </td>
                            </tr>
                        </g:each>
                    </table>
                    <br/>

                    <div id="progDeal">
                        <input class="qqbut" type="button" value="全选" onclick="checkAllByButton(true, 'idList')">
                        <input class="qqbut" type="button" value="反选" onclick="checkAllByButton(false, 'idList')">
                        <input class="qqbut" type="button" value="删除" onClick="deleteUserWorkList();"/>
                    </div>

                    <table width="96%" style="border:0px;margin:0px" height="16" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="300" height="16" align="left" style="border:none">
                                作品数：${total}&nbsp;&nbsp; ${studyCommunityTotal}&nbsp; 每页显示:
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
                                    <g:paginate controller="userWork" action="myList" total="${total}"
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
