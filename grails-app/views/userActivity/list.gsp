<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>我创建的学习圈</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'style_my.css')}" type="text/css"
          media="screen"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'invalid.css')}" type="text/css"
          media="screen"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'reset.css')}" type="text/css"
          media="screen"/>

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <script type="text/javascript">
        //----------begin-------------
        function setParams() {
            communityForm.wyName.value = "${params.wyName}";
            communityForm.state.value = "${params.state}";
        }
        //搜索
        function communtiySearch() {
            if (!widthCheck($F('wyName').trim(), 100)) {
                alert('搜索名称不能大于100个字符');
                $('wyName').select();
                return;
            }
            communityForm.action = "myCommunity";
            communityForm.submit();
        }
        //操作
        function operate(controller, action, operation) {
            if (hasChecked("idList") == false) {
                alert("请至少选择一条记录！");
                return false;
            }
            if (action == 'deleteCommuntiyList') {
                if (confirm("你确实要删除这些社区吗？") == false) return;
            }
            else if (action == 'dismissCommunityList') {
                if (confirm("你确实要解散这些社区吗？") == false) return;
            }
            setParams();
            document.communityForm.action = baseUrl + controller + "/" + action + operation;
            document.communityForm.submit();
        }
        //每页显示多少条
        function maxShow(max) {
            document.communityForm.max.value = max;
            document.communityForm.offset.value = 0;
            document.communityForm.submit();
        }
        function joinCommunity(communityId) {
            document.location.href = baseUrl + "community/communityLeft?communityId=" + communityId;
        }
        function editCommunity(id) {
            document.location.href = baseUrl + "my/editCommunity?id=" + id;
        }
        //----------end-------------
    </script>
</head>

<body>
<div style="margin-top:5px"></div>

<div id="body-wrapper">
    <g:render template="/my/myLeft"/>
    <div id="main-content"><!-- Main Content Section with everything -->
        <div class="content-box"><!-- Start Content Box -->
            <div class="content-box-header">
                <ul class="content-box-tabs">
                    <li><a href="${createLink(controller: 'userActivity', action: 'myCommunity' , params: [communityType: 'my'])}" class="default-tab current">我发起的活动</a>
                    </li>
                    <li><a href="${createLink(controller: 'userActivity', action: 'myJoinCommunity' , params: [communityType: 'join'])}">我参与的活动</a></li>
                    <li><a href="${createLink(controller: 'userActivity', action: 'myJoinCommunity' , params: [communityType: 'join'])}">我提交的作品</a></li>
                </ul>

                <div class="clear"></div>
            </div> <!-- End .content-box-header -->
            <div class="content-box-content">
                <div class="tab-content default-tab" id="tab1">
                    <form name="communityForm" method="post" action="">
                        <table width="96%" border="0" cellspacing="0" cellpadding="0" class="borbt"
                               bordercolor="#FFFFFF" id="progListTab"
                               style="margin-left:0px; margin-right:0px;margin-top:10px;margin-bottom:10px;">
                            <tr>
                                <td align="center">状态：&nbsp;<select style="border:1px solid #dddddd;" name="state">
                                    <option value="">--请选择--</option>
                                    <option value="1" <g:if test="${params.state == '1'}">selected</g:if>>正在进行</option>
                                    <option value="2" <g:if test="${params.state == '2'}">selected</g:if>>已结束</option>

                                </select>&nbsp;&nbsp;&nbsp;&nbsp;检索名称：&nbsp;<input name="wyName" id="wyName"
                                                                                   value="${params.wyName}"
                                                                                   style="width:200px;">&nbsp;&nbsp;<a
                                        href="javascript: communtiySearch();" class="button">检索</a></td>
                                <td>
                            </tr>
                        </table>

                        <table width="96%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF"
                               id="progListTab" style="margin:0px">
                            <tr>
                                <td width="5%" align="center" bgcolor="#BDEDFB" class="STYLE5">选择</td>
                                <td width="40%" align="center" bgcolor="#BDEDFB" class="STYLE5">社区名称</td>
                                <td width="15%" align="center" bgcolor="#BDEDFB" class="STYLE5">创建时间</td>
                                <td width="10%" align="center" bgcolor="#BDEDFB" class="STYLE5">分类</td>
                                <td width="10%" align="center" bgcolor="#BDEDFB" class="STYLE5">状态</td>
                                <td width="10%" align="center" bgcolor="#BDEDFB" class="STYLE5">修改</td>
                                <td width="10%" align="center" bgcolor="#BDEDFB" class="STYLE5">解散</td>
                            </tr>
                            <g:each in="${userActivityList}" status="i" var="userActivity">
                                <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                                    <td align="center"><input type="checkbox" name="idList" value="${userActivity.id}"
                                                              onclick="unCheckAll('selall');" id="idList"/></td>
                                    <td align="center"><a
                                            href="${createLink(controller: 'community', action: 'communityLeft' , params: [communityId: userActivity.id])}"
                                            title="${userActivity.name}"
                                            target="blank">${CTools.cutString(fieldValue(bean: studyCommunity, field: 'name'), 24)}</a>
                                    </td>
                                    <td align="center" class="STYLE5"><g:formatDate format="yyyy-MM-dd HH:mm:ss"
                                                                                    date="${userActivity.dateCreated}"/></td>
                                    <td align="center"></td>
                                    <td align="center">
                                        已通过
                                    </td>
                                    <td align="center">
                                        <a href="javascript:editCommunity(${userActivity.id})"><img
                                                src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="编辑" border="0"></a>
                                    </td>
                                    <td align="center">
                                        <a href="${createLink(controller: 'my', action: 'dismissCommunity' , params: [id: userActivity.id])}"
                                           onclick="return confirm('确实要解散该社区吗？');"><img
                                                src="${resource(dir: 'images/skin', file: 'delete.gif')}" alt="解散" border="0"></a>
                                    </td>
                                </tr>
                            </g:each>
                        </table>
                        <br/>

                        <div id="progDeal">
                            <input class="qqbut" type="button" value="全选" onclick="checkAllByButton(true, 'idList')">
                            <input class="qqbut" type="button" value="反选" onclick="checkAllByButton(false, 'idList')">

                            <input class="qqbut" type="button" value="发起"
                                   onClick="operate('my', 'dismissCommunityList', '');"/>
                            <input class="qqbut" type="button" value="删除"
                                   onClick="operate('my', 'deleteCommuntiyList', '');"/>
                        </div>

                        <table width="96%" style="border:0px;margin:0px" height="16" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="300" height="16" align="left" style="border:none">
                                    学习圈数：${studyCommunityTotal}&nbsp; 每页显示:
                                    <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                                         onclick="maxShow(10)">&nbsp;
                                    <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0"
                                         onclick="maxShow(50)">&nbsp;
                                    <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条"
                                         border="0" onclick="maxShow(100)">&nbsp;
                                    <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条"
                                         border="0" onclick="maxShow(200)">
                                </td>
                                <g:if test="${userActivityList != null && userActivityList.size() > 0}">
                                    <td align="right" style="border:none">
                                        <div class="paginateButtons">
                                            <g:paginate controller="my" action="myCommunity" total="${total}"
                                                        params="${params}" maxsteps="5"/>
                                        </div>
                                    </td>
                                </g:if>
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
