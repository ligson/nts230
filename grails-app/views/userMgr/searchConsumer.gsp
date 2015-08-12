<%@ page import="nts.utils.CTools" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <title>用户列表</title>
    <script Language="JavaScript">
        function searchDelete() {
            if (hasChecked("idList") == false) {
                alert("请至少选择一个用户！");
                return false;
            }
            consumerListForm.action = "searchDelete";
            consumerListForm.submit();
        }

        function searchUpload(opt) {
            if (hasChecked("idList") == false) {
                alert("请至少选择一个用户！");
                return false;
            }
            consumerListForm.action = "searchUpload?uploadTag=" + opt;
            consumerListForm.submit();
        }
        function hideGroupList() {
            document.getElementById('divGroupList').style.display = "none";
        }

        function lockConsumer(opt) {
            if (hasChecked("idList") == false) {
                alert("请至少选择一个要锁定的用户！");
                return false;
            }
            consumerListForm.action = "searchLockConsumer?lockTag=" + opt;
            consumerListForm.submit()
        }
        function searchDownload(opt) {
            if (hasChecked("idList") == false) {
                alert("请至少选择一个用户！");
                return false;
            }
            consumerListForm.action = "searchDownload?downloadTag=" + opt;
            consumerListForm.submit();
        }
        function searchExamine(opt) {
            if (hasChecked("idList") == false) {
                alert("请至少选择一个用户！");
                return false;
            }
            consumerListForm.action = "searchExamine?examineTag=" + opt;
            consumerListForm.submit();
        }

        function searchComment(opt) {
            if (hasChecked("idList") == false) {
                alert("请至少选择一个用户！");
                return false;
            }
            consumerListForm.action = "searchComment?commentTag=" + opt;
            consumerListForm.submit();
        }

        function userSet(ctrl, opt) {

            if (hasChecked("idList") == false) {
                alert("请至少选择一个用户！");
                return false;
            }
            switch (ctrl) {

                case "delete":
                    consumerListForm.action = "searchDelete";
                    break;
                case "upload":
                    consumerListForm.action = "searchUpload?uploadTag=" + opt;
                    break;
                case "comment":
                    consumerListForm.action = "searchComment?commentTag=" + opt;
                    break;
                case "download":
                    consumerListForm.action = "searchDownload?downloadTag=" + opt;
                    break;
                case "examine":
                    consumerListForm.action = "searchExamine?examineTag=" + opt;
                    break;
                case "lock":
                    consumerListForm.action = "searchLockConsumer?lockTag=" + opt;
                    break;
                case "isRegister":
                    consumerListForm.action = "userRegister?registerTag=" + opt;
                    break;
            }
            consumerListForm.submit()
        }

        function exportExecl() {
            consumerListForm.action = "exportExecl";
            consumerListForm.submit();
        }

        function setParams() {
            consumerListForm.searchName.value = "${params.searchName}";
            consumerListForm.searchNickName.value = "${params.searchNickName}";
            consumerListForm.searchTrueName.value = "${params.searchTrueName}";
            ;
            consumerListForm.searchCollege.value = "${params.searchCollege}";
        }

        function maxShow(max) {
            //调用setParams()对查询参数进行负值
            consumerListForm.max.value = max;
            consumerListForm.offset.value = 0;
            consumerListForm.action = "searchConsumer";
            consumerListForm.submit();
        }
        function orderBy(sort) {
            //调用setParams()对查询参数进行负值
            consumerListForm.sort.value = sort;
            if (consumerListForm.order.value == "desc") {
                consumerListForm.order.value = "asc";
            }
            else {
                consumerListForm.order.value = "desc";
            }
            consumerListForm.action = "searchConsumer";
            consumerListForm.submit();
        }
        function showUpdate(id) {
            consumerListForm.action = "${createLink(controller:'userMgr',action:'searchEdit')}?id=" + id;
            consumerListForm.submit();
        }

        function setPro(id, opt, tag) {
            consumerListForm.action = "sreachChangeState?changeId=" + id + "&changeTag=" + tag + "&changeOpt=" + opt + "";
            consumerListForm.submit()
        }
    </script>
</head>

<body>
<form name="consumerListForm" method="POST" action="">

    <input type="hidden" name="sort" value="${params.sort}"/>
    <input type="hidden" name="offset" value="${params.offset}"/>
    <input type="hidden" name="order" value="${params.order}"/>
    <input type="hidden" name="max" value="${params.max}"/>
    <input type="hidden" name="row" value="${params.row}"/>
    <input type="hidden" name="searchState" value="${params.searchState}"/>
    <input type="hidden" name="searchCollege" value="${params.searchCollege}"/>
    <input type="hidden" name="dateEnd" value="${params.dateEnd}"/>
    <input type="hidden" name="dateBegin" value="${params.dateBegin}"/>
    <input type="hidden" name="searchType" value="${params.searchType}"/>
    <input type="hidden" name="searchUpload" value="${params.searchUpload}"/>
    <input type="hidden" name="roleList" value="${params.roleList}"/>
    <input type="hidden" name="searchName" value="${params.searchName}"/>
    <input type="hidden" name="searchTrueName" value="${params.searchTrueName}"/>
    <input type="hidden" name="selectState" value="${params.selectState}"/>
    <input type="hidden" name="selectUpload" value="${params.selectUpload}"/>
    <input type="hidden" name="selectDownload" value="${params.selectDownload}"/>
    <input type="hidden" name="searchDownload" value="${params.searchDownload}"/>
    <input type="hidden" name="selectExamine" value="${params.selectExamine}"/>
    <input type="hidden" name="searchExamine" value="${params.searchExamine}"/>



    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <table width="100%" border="0" cellspacing="0">
        <tr>
            <td align="left"><font><span class="zi-cu">查询结果</span></font></td>
        </tr>
    </table>
    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
        <tr bgcolor="#BDEDFB">
            <td width="4%" height="28" align="center" class="STYLE5">选择</td>
            <td width="12%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('name')">用户帐号</a></td>
            <td width="12%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('nickname')">用户昵称</a></td>
            <td width="11%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('trueName')">真实姓名</a></td>

            <td width="9%" align="center" class="STYLE5">上传范围</td>
            <td width="5%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('role')">角色</a></td>
            <td width="5%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('userState')">状态</a></td>
            <td width="5%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('uploadState')">上传</a></td>
            <td width="5%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('canDownload')">下载</a></td>
            <td width="5%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('canComment')">评论</a></td>
            <td width="8%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('isRegister')"
                                                            title="将注册用户审批为正式用户">用户审核</a></td>
            <td width="8%" align="center" class="STYLE5">创建时间</td>
            <td width="5%" align="center" class="STYLE5">修改</td>
        </tr>
        <g:each in="${searchList}" status="i" var="consumer">
            <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}" align="center" class="STYLE5">
                <td><g:checkBox name="idList" value="${consumer.id}" checked="" onclick="unCheckAll('selall');"/></td>
                <td align="left">
                    <a href="#d" onClick="showUpdate(${consumer.id})">
                        <g:if test="${consumer.gender == 1}">
                            <img align="center"
                                 src="${createLinkTo(dir: 'skin/blue/pc/front/images', file: 'ico_usermen.gif')}"
                                 border="0">
                        </g:if>
                        <g:if test="${consumer.gender == 0}">
                            <img src="${createLinkTo(dir: 'skin/blue/pc/front/images', file: 'ico_userwm.gif')}"
                                 border="0">
                        </g:if>
                        ${fieldValue(bean: consumer, field: 'name')}</a>
                </td>
                <td>${fieldValue(bean: consumer, field: 'nickname')}</td>
                <td>${fieldValue(bean: consumer, field: 'trueName')}</td>

                <td title="${fieldValue(bean: consumer, field: 'directorys.name')}">
                    <g:if test="${consumer.directorys.name}">
                        ${CTools.cutString(consumer?.directorys.name.toString(), 6)}
                    </g:if>
                </td>
                <td>
                    <g:if test="${consumer.role == 1}">管理员</g:if>
                    <g:if test="${consumer.role == 2}">老师</g:if>
                    <g:if test="${consumer.role == 3}">学生</g:if>
                </td>
                <td align="center">
                    <g:if test="${consumer.userState}">
                        <a href="#d" onClick="setPro(${consumer.id}, 'state', ${consumer.userState})" title="正常">正常</a>
                    </g:if>
                    <g:if test="${!consumer.userState}">
                        <a href="#d" onClick="setPro(${consumer.id}, 'state', ${consumer.userState})" title="锁定"><font
                                color="red">锁定</font></a>
                    </g:if>
                </td>

                <td>
                    <g:if test="${consumer.uploadState == 1}">
                        <img align="center" src="${createLinkTo(dir: 'skin/blue/pc/front/images', file: 'ico_accept.gif')}"
                             onClick="setPro(${consumer.id}, 'upload', ${consumer.uploadState})" title="更改上传状态">
                    </g:if>
                    <g:if test="${consumer.uploadState == 0}">
                        <img src="${createLinkTo(dir: 'skin/blue/pc/front/images', file: 'ico_stop.gif')}"
                             onClick="setPro(${consumer.id}, 'upload', ${consumer.uploadState})" title="更改上传状态">
                    </g:if>
                    <g:if test="${consumer.uploadState == 2}">
                        <img src="${createLinkTo(dir: 'skin/blue/pc/front/images', file: 'ico_accept.gif')}"
                             onClick="setPro(${consumer.id}, 'upload', ${consumer.uploadState})" title="更改上传状态">
                    </g:if>
                </td>

                <td>
                    <g:if test="${consumer.canDownload}">
                        <img align="center" src="${createLinkTo(dir: 'skin/blue/pc/front/images', file: 'ico_accept.gif')}"
                             onClick="setPro(${consumer.id}, 'download', ${consumer.canDownload})" title="更改下载状态">
                    </g:if>
                    <g:if test="${!consumer.canDownload}">
                        <img src="${createLinkTo(dir: 'skin/blue/pc/front/images', file: 'ico_stop.gif')}"
                             onClick="setPro(${consumer.id}, 'download', ${consumer.canDownload})" title="更改下载状态">
                    </g:if>
                </td>
                <td>
                    <g:if test="${consumer.canComment}">
                        <img align="center" src="${createLinkTo(dir: 'skin/blue/pc/front/images', file: 'ico_accept.gif')}"
                             onClick="setPro(${consumer.id}, 'comment', ${consumer.canComment})" title="更改评论状态">
                    </g:if>
                    <g:if test="${!consumer.canComment}">
                        <img src="${createLinkTo(dir: 'skin/blue/pc/front/images', file: 'ico_stop.gif')}"
                             onClick="setPro(${consumer.id}, 'comment', ${consumer.canComment})" title="更改评论状态">
                    </g:if>
                </td>

                <td>
                    <g:if test="${consumer.isRegister}">
                        <a href="#d" onClick="setPro(${consumer.id}, 'isRegister', ${consumer.isRegister})"
                           title="点击审核，注册用户审批为正式用户"><font color="red">审核</font></a>
                    </g:if>
                    <g:if test="${!consumer.isRegister}">
                        已审核
                    </g:if>
                </td>

                <td><g:formatDate format="yyyy-MM-dd" date="${consumer.dateCreated}"/></td>
                <td>
                    <a href="#d" onClick="showUpdate(${consumer.id})"><img src="${resource(dir: 'images/skin', file: 'modi.gif')}" border="0">
                    </a>
                </td>
            </tr>
        </g:each>
    </table>

    <br>

    <div class="operation">
        <input id="selall" name="selall" onclick="checkAll(this, 'idList')" type="checkbox">全选&nbsp;
        <input type="button" class="button" value="删除" onClick="userSet('delete', 0)"/>
        &nbsp;<input type="button" class="button" value="允许上传" onClick="userSet('upload', 1)"/>
        &nbsp;<input type="button" class="button" value="禁止上传" onClick="userSet('upload', 0)"/>
        &nbsp;<input type="button" class="button" value="允许下载" onClick="userSet('download', '1')"/>
        &nbsp;<input type="button" class="button" value="禁止下载" onClick="userSet('download', '0')"/>
        &nbsp;<input type="button" class="button" value="锁定" onClick="userSet('lock', '0') "/>
        &nbsp;<input type="button" class="button" value="解锁" onClick="userSet('lock', '1')"/>
        &nbsp;<input type="button" class="button" value="审核" onClick="userSet('isRegister', '0') "/>
        &nbsp;<input type="button" class="button" value="允许评论" onClick="userSet('comment', '1')"/>
        &nbsp;<input type="button" class="button" value="禁止评论" onClick="userSet('comment', '0')"/>
        &nbsp;<!--input  type="button" class="button" value="导出Execl"  onClick="exportExecl()" /-->
        <a class="button"
           href='exportExecl?searchTrueName=${CTools.toUTF8(params.searchTrueName)}&searchState=${params.searchState}&searchCollege=${params.searchCollege}&dateEnd=${params.dateEnd}&dateBegin=${params.dateBegin}&searchType=${params.searchType}&searchUpload=${params.searchUpload}&row=${params.row}&roleList=${params.roleList}&order=${params.order}&searchName=${params.searchName}&selectState=${params.selectState}&selectUpload=${params.selectUpload}&selectDownload=${params.selectDownload}&searchDownload=${params.searchDownload}&selectExamine=${params.selectExamine}&searchExamine=${params.searchExamine}'>导出EXECL</a>
    </div>
    <TABLE width="100%" height="16" border=0 cellPadding=1 cellSpacing=1 bgcolor="#E9E8E7">
        <TBODY>
        <TR>
            <TD width="693" height="16" align="center"><div align="left">

                <a href="#d" onClick="maxShow(10)">
                    <IMG id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" border=0 class="STYLE8" title="每页显示10条">
                </a>&nbsp;
                <a href="#d" onClick="maxShow(50)">
                    <IMG id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" border=0 class="STYLE8" title="每页显示50条">
                </a>&nbsp;
                <a href="#d" onClick="maxShow(100)">
                    <IMG id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" width="27" height="16"
                         border=0 class="STYLE8" title="每页显示100条">
                </a>
                <a href="#d" onClick="maxShow(200)">
                    <IMG id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" width="28" height="16"
                         border=0 class="STYLE8" title="每页显示200条">
                </a>
            </div></TD>
            <TD width=11>&nbsp;</TD>
            <TD width="425" align=right><div class="STYLE8">
                <g:paginate total="${total}" offset="${params.offset}" action="searchConsumer"
                            params="${params}"/>&nbsp;&nbsp;</TD>
        </TR>
        </TBODY>
    </TABLE>
</form>
<script Language="JavaScript">
    changePageImg(${params.max});
</script>
</body>
</html>
