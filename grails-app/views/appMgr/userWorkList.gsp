<%@ page import="nts.utils.CTools" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>作品管理</title>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" rel="stylesheet" type="text/css">
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
        padding-left: 2px;
    }

    </style>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <script type="text/javascript">
        //设置查询参数
        function setParams() {
            document.userWorkForm.name.value = "${params.name}";
            document.userWorkForm.approval.value = "${params.approval}";
        }
        //搜索
        function search() {
            if (!widthCheck($('#name').val().trim(), 50)) {
                alert('搜索名称不能大于50个字符');
                $('name').select();
                return;
            }
            document.userWorkForm.action = "userWorkList";
            document.userWorkForm.submit();
        }
        //删除作品
        function deleteUserWork(id) {
            setParams();
            document.userWorkForm.action = baseUrl + "appMgr/deleteUserWork?id=" + id + "&toPage=userWorkList";
            document.userWorkForm.submit();
        }
        //批量删除作品
        function deleteUserWorkList() {
            if (!confirm('确定删除选中的作品吗?')) return false;

            setParams();
            document.userWorkForm.action = baseUrl + "appMgr/deleteUserWorkList?toPage=userWorkList";
            document.userWorkForm.submit();
        }
        //批量通过和禁用作品
        function isApprovalUserWorkList(schApproval) {
            if (schApproval == 3 && !confirm('确定通过选中的作品吗?')) return false;
            if (schApproval == 1 && !confirm('确定禁用选中的作品吗?')) return false;

            setParams();
            document.userWorkForm.action = baseUrl + "appMgr/isApprovalUserWorkList?schApproval=" + schApproval;
            document.userWorkForm.submit();
        }
        //每页显示多少条
        function maxShow(max) {
            document.userWorkForm.max.value = max;
            document.userWorkForm.offset.value = 0;
            document.userWorkForm.submit();
        }
    </script>
</head>

<body>
<div class="x_daohang">
    <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>>作品管理
</div>

<form name="userWorkForm" method="post" action="${createLink(controller: 'appMgr', action: 'userWorkList')}">

    <table width="98%" border="0" cellspacing="0" cellpadding="0" class="biaoge-hui"
           style="margin:10px 0 10px 10px;">
        <tr>
            <td>&nbsp;状态:&nbsp;<select style="border:1px solid #dddddd;" name="approval">
                <option value="">--请选择--</option>
                <option value="2" <g:if test="${params.approval == '2'}">selected</g:if>>审核中</option>
                <option value="3" <g:if test="${params.approval == '3'}">selected</g:if>>通过</option>
                <option value="1" <g:if test="${params.approval == '1'}">selected</g:if>>未通过</option>
            </select>
            </td>
            <td align="left">检索名称:&nbsp;<input name="name" id="name" value="${params.name}" style="width:200px;"></td>
            <td width="40%" align="left"><img src="${resource(dir: 'images/skin', file: 'search.gif')}" style="cursor:pointer;"
                                              onclick="search();" border="0"></td>
        </tr>
    </table>

    <table width="98%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF" id="progListTab"
           style="margin-left:10px ;border: #e2e2e2 1px solid">
        <tr>
            <td width="5%" align="left" bgcolor="#BDEDFB" class="STYLE5 th">选择</td>
            <td width="28%" align="left" bgcolor="#BDEDFB" class="STYLE5 th">作品名称</td>
            <td width="28%" align="center" bgcolor="#BDEDFB" class="STYLE5 th">活动名称</td>
            <td width="10%" align="center" bgcolor="#BDEDFB" class="STYLE5 th">投票数</td>
            <td width="10%" align="center" bgcolor="#BDEDFB" class="STYLE5 th">创建时间</td>
            <td width="7%" align="center" bgcolor="#BDEDFB" class="STYLE5 th">审批状态</td>
            <td width="7%" align="center" bgcolor="#BDEDFB" class="STYLE5 th">修改</td>
            <td width="7%" align="center" bgcolor="#BDEDFB" class="STYLE5 th">删除</td>
        </tr>
        <g:each in="${userWorkList}" status="i" var="userWork">
            <tr class="${(i % 2) == 0 ? 'even' : 'odd'}" >
                <td align="left"><input type="checkbox" name="idList" value="${userWork.id}"
                                        onclick="unCheckAll('selall');" id="idList"/></td>
                <td align="left"><a href="${createLink(controller: 'appMgr', action: 'showUserWork', params: [id: userWork.id])}"
                                    title="${userWork.name}">${CTools.cutString(fieldValue(bean: userWork, field: 'name'), 16)}</a>
                </td>
                <td align="left"><a href="${createLink(controller: 'appMgr', action: 'showUserActivity', params: [id: userWork.userActivity.id])}"
                                    title="${userWork.userActivity.name}">${CTools.cutString(fieldValue(bean: userWork.userActivity, field: 'name'), 16)}</a>
                </td>
                <td align="center" class="STYLE5">${userWork.voteNum}</td>
                <td align="center"><g:formatDate date="${userWork.dateCreated}" format="yyyy-MM-dd"/></td>
                <td align="center">${userWork.approval == 1 ? "未通过" : userWork.approval == 2 ? "未审核" : "通过"}</td>
                <td align="center"><a href="${createLink(controller: 'appMgr', action: 'editUserWork', params: [id: userWork.id, toPage: 'userWorkList'])}"><img
                        src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="修改" border="0"></a></td>
                <td align="center"><a href="javascript: void(0);" onclick="deleteUserWork(${userWork.id})"><img
                        src="${resource(dir: 'images/skin', file: 'delete.gif')}" alt="删除" border="0"></a></td>
            </tr>
        </g:each>
    </table>

    <div id="progDeal" style="margin: 10px 0 10px 10px; width: 98%;">
        <input id="selall" name="selall" onclick="checkAll(this, 'idList')" type="checkbox">全选
        <input class="subbtn" type="button" value="删除" onClick="deleteUserWorkList();"/>
        <input class="subbtn" type="button" value="通过" onClick="isApprovalUserWorkList(3);"/>
        <input class="subbtn" type="button" value="禁用" onClick="isApprovalUserWorkList(1);"/>
    </div>

    <table width="98%"  style="margin-left: 10px;" border="0" cellpadding="1" cellspacing="1" bgcolor="#E9E8E7">
        <tr>
            <td width="300" height="16">
                &nbsp;总共：${total} 条记录&nbsp;|&nbsp;每页${params.max}条
                <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                     onclick="maxShow(10)">
                <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0"
                     onclick="maxShow(50)">
                <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0"
                     onclick="maxShow(100)">
                <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0"
                     onclick="maxShow(200)">
            </td>
            <td align="right"><g:paginate controller="userWork" action="listManager" total="${total}"
                                          params="${params}"/></td>
        </tr>
    </table>

    <input type="hidden" name="max" value="${params.max}">
    <input type="hidden" name="offset" value="${params.offset}">
</form>
<script Language="JavaScript">
    changePageImg(${params.max});
</script>
</body>
</html>
