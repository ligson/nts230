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
    <script type="text/javascript">
        function joinCommunity(communityId) {
            document.location.href = baseUrl + "community/communityLeft?communityId=" + communityId;
        }
    </script>
</head>

<body>
<div id="main-content">
    <div class="content-box">
        <div class="content-box-header">
            <ul class="content-box-tabs">
                <li><a href="${createLink(controller: 'my', action: 'myCommunity', params: [communityType: 'my'])}">我创建的社区</a></li>
                <li><a href="${createLink(controller: 'my', action: 'myJoinCommunity', params: [communityType: 'join'])}" class="default-tab current">我加入的社区</a></li>
            </ul>
        </div>

        <div class="content-box-content">
            <div class="tab-content default-tab">
                <form name="communityForm" method="post" action="">
                    <table width="96%" border="0" cellspacing="0" cellpadding="0" class="borbt" bordercolor="#FFFFFF"
                           id="progListTab1"
                           style="margin-left:0px; margin-right:0px;margin-top:10px;margin-bottom:10px;">
                        <tr>
                            <td align="center">检索名称：&nbsp;&nbsp;<input name="wyName" id="wyName"
                                                                       value="${params.wyName}"
                                                                       style="width:200px;">&nbsp;&nbsp;&nbsp;&nbsp;<a
                                    href="javascript: communtiySearch();" class="button">检索</a></td>
                        </tr>
                    </table>

                    <table width="96%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF"
                           id="progListTab2"
                           style="margin:0px">
                        <tr>
                            <td width="40%" align="center" bgcolor="#BDEDFB" class="STYLE5">社区名称</td>
                            <td width="15%" align="center" bgcolor="#BDEDFB" class="STYLE5">创建时间</td>
                            <td width="10%" align="center" bgcolor="#BDEDFB" class="STYLE5">分类</td>
                            <td width="10%" align="center" bgcolor="#BDEDFB" class="STYLE5">状态</td>
                        </tr>
                        <g:each in="${studyCommunityList}" status="i" var="studyCommunity">
                            <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                                <td align="center"><a
                                        href="${createLink(controller: 'community', action: 'communityLeft', params: [communityId: studyCommunity.id])}"
                                        title="${studyCommunity?.name}"
                                        target="blank">${CTools.cutString(fieldValue(bean: studyCommunity, field: 'name'), 30)}</a>
                                </td>
                                <td align="center" class="STYLE5"><g:formatDate format="yyyy-MM-dd HH:mm:ss"
                                                                                date="${studyCommunity?.dateCreated}"/></td>
                                <td align="center"><g:if
                                        test="${studyCommunity.communityCategory != null}">${studyCommunity?.communityCategory?.name.encodeAsHTML()}</g:if><g:else>无</g:else>
                                <td align="center">
                                    已加入
                                </td>
                            </tr>
                        </g:each>
                    </table>
                    <br/>
                    <table width="96%" style="border:0px;margin:0px" height="16" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="300" height="16" align="left" style="border:none">
                                学习圈数：${studyCommunityTotal}&nbsp; 每页显示:
                                <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                                     onclick="maxShow(10)">&nbsp;
                                <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0"
                                     onclick="maxShow(50)">&nbsp;
                                <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0"
                                     onclick="maxShow(100)">&nbsp;
                                <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0"
                                     onclick="maxShow(200)">
                            </td>
                            <g:if test="${studyCommunityList != null && studyCommunityList.size() > 0}">
                                <td align="right" style="border:none">
                                    <div class="paginateButtons">
                                        <g:paginate controller="my" action="myJoinCommunity" total="${total}"
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
</body>
</html>