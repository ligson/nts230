<%@ page import="nts.commity.domain.StudyCommunity" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <title>主题列表</title>
    <link href="${createLinkTo(dir: 'css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script language="javaScript">
        function maxShow(max) {
            //调用setParams()对查询参数进行负值
            setParams();
            communityForm.max.value = max;
            communityForm.offset.value = 0;
            communityForm.action = "communityList";
            communityForm.submit();
        }
        function deleteCommunity(communityId) {
            if (confirm("确定删除该学习社区吗？")) {
                setParams();
                communityForm.action = baseUrl + "appMgr/deleteCommunity?delId=" + communityId;
                communityForm.submit();
            }
        }
        function editCommunity(communityId) {
            communityForm.action = "edit?communityId=" + communityId;
            communityForm.submit();
        }
        function userList(communityId) {
            communityForm.action = "userList?communityId=" + communityId + "&listType=all";
            communityForm.submit();
        }
        function communitySearch() {
            communityForm.action = "communityList";
            communityForm.submit();
        }
        function setParams() {
            communityForm.name.value = "${params.name}";
            communityForm.state.value = "${params.state}";
        }

        function orderBy(sort) {
            //调用setParams()对查询参数进行负值
            setParams();
            communityForm.sort.value = sort;
            if (communityForm.order.value == "desc") {
                communityForm.order.value = "asc";
            }
            else {
                communityForm.order.value = "desc";
            }
            communityForm.action = "communityList";
            communityForm.submit();
        }
        function deleteCommunityList() {
            setParams();
            communityForm.action = "deleteCommunityList";
            communityForm.submit();
        }
        function communityExamine(communityId, state) {
            setParams();
            communityForm.action = baseUrl + "appMgr/communityExamine?id=" + communityId + "&communityState=" + state;
            communityForm.submit();
        }
        function communityRecommend(communityId, isRecommend) {
            setParams();
            communityForm.action = baseUrl + "appMgr/communityRecommend?id=" + communityId + "&isRecommend=" + isRecommend;
            communityForm.submit();
        }
    </script>
</head>

<body leftmargin="0" topmargin="5" marginwidth="0" marginheight="0">
<div class="x_daohang"><span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>>社区管理</div>

<form name="communityForm" method="post" action="">
    <input type="hidden" name="communityType" value="${params.communityType}">
    <input type="hidden" name="sort" value="${params.sort}">
    <input type="hidden" name="order" value="${params.order}">
    <input type="hidden" name="max" value="${params.max}">
    <input type="hidden" name="offset" value="${params.offset}">
    <g:set var="typeName" value="${['my': '我创建的主题列表', 'join': '我加入的主题列表', 'all': '所有主题列表', 'mgr': '社区管理']}"/>
    <table width="98%" style="margin-left: 10px; margin-top: 10px;" border="0" cellpadding="0" cellspacing="0"
           bordercolor="#E9E8E7">
        <tr>
            <td width="5%" align="center">主题名称:</td>
            <td width="10%" align="left"><input type="text" name="name"
                                                value=""/></td>
            <td width="5%" align="center">状态:</td>
            <td width="10%" align="left"><select id="htselect" name="state">
                <option value="">--请选择--</option>
                <option value="${StudyCommunity.STUDYCOMMUNITY_STATE_PASS}">${StudyCommunity.cnField[StudyCommunity.STUDYCOMMUNITY_STATE_PASS]}</option>
                <option value="${StudyCommunity.STUDYCOMMUNITY_STATE_EXAMINE}">${StudyCommunity.cnField[StudyCommunity.STUDYCOMMUNITY_STATE_EXAMINE]}</option>
                <option value="${StudyCommunity.STUDYCOMMUNITY_STATE_FORBIDDEN}">${StudyCommunity.cnField[StudyCommunity.STUDYCOMMUNITY_STATE_FORBIDDEN]}</option>
            </select></td>
            <td width="30%" align="center"><input name="search" type="button" class="subbtn"
                                                  onClick="communitySearch()" value="查询"/></td>
        </tr>
    </table>

    <table width="98%" style="margin-left:10px; margin-top: 10px;border: #e2e2e2 1px solid;  " border="1" cellpadding="0" cellspacing="0"
           bordercolor="#FFFFFF">
        <tr align="left" valign="top">
            <td class="th" width="5%" align="center" valign="middle" bgcolor="#BDEDFB">选择</td>
            <td class="th" width="24%" align="center" valign="middle" bgcolor="#BDEDFB"><a href="#"
                                                                                           onClick="orderBy('name');
                                                                                           return false;">社区名称</a></td>
            <td class="th" width="7%" align="center" valign="middle" bgcolor="#BDEDFB"><a href="#"
                                                                                          onClick="orderBy('communityCategory?.name');
                                                                                          return false;">社区类别</a></td>
            <td class="th" width="7%" align="center" valign="middle" bgcolor="#BDEDFB"><a href="#"
                                                                                          onClick="orderBy('dateCreated');
                                                                                          return false;">创建时间</a></td>
            <td class="th" width="10%" align="center" valign="middle" bgcolor="#BDEDFB"><a href="#"
                                                                                           onClick="orderBy('create_comsumer_id');
                                                                                           return false;">创建者</a></td>
            <td class="th" width="7%" align="center" valign="middle" bgcolor="#BDEDFB"><a
                    href="#">成员人数</a></td>
            <td class="th" width="5%" align="center" valign="middle" bgcolor="#BDEDFB"><a href="#"
                                                                                          onClick="orderBy('state');
                                                                                          return false;">状态</a></td>
            <td class="th" width="7%" align="center" valign="middle" bgcolor="#BDEDFB"><a href="#"
                                                                                          onClick="orderBy('isRecommend');
                                                                                          return false;">推荐状态</a></td>
            <td class="th" width="17%" align="center" valign="middle" bgcolor="#BDEDFB">操作</td>
        </tr>
        <g:each in="${communityList}" status="i" var="community">
            <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}" align="center"
                valign="top">
                <td>&nbsp;&nbsp;
                    <g:checkBox name="idList" value="${community.id}"
                                checked=""
                                onclick="unCheckAll('selall');"/></td>
                <td valign="middle" align="left">&nbsp;&nbsp;${community?.name}</td>
                <td valign="middle">${community.communityCategory?.name}</td>
                <td valign="middle"><g:formatDate format="yyyy-MM-dd"
                                                  date="${community.dateCreated}"/></td>
                <td valign="middle">${nameList[i]}</td>
                <td valign="middle">${community.members.size()}</td>
                <td valign="middle">${community.state == 0 ? "已禁用" : community.state == 1 ? "已通过" : "审核中"}</td>
                <td valign="middle">${community.isRecommend ? "已推荐" : "未推荐"}</td>
                <td valign="middle"><a href="#" onClick="deleteCommunity(${community.id})">删除</a>
                    <g:if test="${community.state == 1}"><a href="#"
                                                            onClick="communityExamine(${community.id}, 0)">禁用</a></g:if>
                    <g:else><a href="#"
                               onClick="communityExamine(${community.id}, 1)">通过</a></g:else>
                    <g:if test="${community.isRecommend == false}"><a href="#"
                                                                      onClick="communityRecommend(${community.id}, 'true')">推荐</a></g:if>
                    <g:else><a href="#"
                               onClick="communityRecommend(${community.id}, 'false')">取消推荐</a></g:else>
                    <a href="${createLink(controller: 'communityMgr', action: 'activityList', params: [comId: community.id])}">活动管理</a>
                </td>
            </tr>
        </g:each>
    </table>


    <table width="98%" style="margin-left:10px; " height="30" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td align="left" width="100%"></td>
        </tr>
        <tr>
            <td align="left"><input id="selall" name="selall"
                                    onclick="checkAll(this, 'idList')"
                                    type="checkbox">
                全选&nbsp;
                <input class="subbtn" type="button" value="删除所选"
                       onClick="deleteCommunityList()"/></td>
        </tr>
    </table>
    <table width="98%" style="margin-left:10px; "  border="0" cellpadding="1" cellspacing="1"
           bgcolor="#E9E8E7">
        <tbody>
        <tr>
            <td height="16" align="left">&nbsp;总共：${total} 条记录&nbsp;|&nbsp;每页${params.max}条&nbsp;|&nbsp;每页显示: <img
                    onClick="maxShow(10)" id="Img10"
                    src="${resource(dir: '/images/skin', file: 'grkj_amount_10.gif')}" border="0" class="STYLE8"
                    title="每页显示10条"/> <img onClick="maxShow(50)" id="Img50"
                                           src="${resource(dir: '/images/skin', file: 'grkj_amount_50.gif')}" border="0" class="STYLE8"
                                           title="每页显示50条"/> <img onClick="maxShow(100)" id="Img100"
                                                                  src="${resource(dir: '/images/skin', file: 'grkj_amount_100.gif')}" border="0"
                                                                  class="STYLE8" title="每页显示100条"/> <img
                    onClick="maxShow(200)" id="Img200"
                    src="${resource(dir: '/images/skin', file: 'grkj_amount_200.gif')}" border="0"
                    class="STYLE8" title="每页显示200条"/></td>
            <td><g:paginate total="${total}"
                            offset="${params.offset}"
                                                      action="communityList"
                                                      params="${params}"/>
            &nbsp;&nbsp;</td>
        </tr>
        </tbody>
    </table>
</form>
<script Language="JavaScript">
    changePageImg(${params.max});
</script>
</body>
</html>
