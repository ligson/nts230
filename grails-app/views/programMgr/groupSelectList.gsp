<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <title>用户列表</title>
    <script Language="JavaScript">

        var addAction;
        var backAction;
        function setAction() {
            var tag = '${params.submitTag}';
            if (tag) {
                addAction = "${createLink(controller:'my',action:'myGroupAddConsumer')}";
                backAction = "${createLink(controller:'my',action:'myGroupList')}";
            }
            else {
                addAction = "groupAddConsumer";
                backAction = "list";
            }
        }
        function addGroup() {

            if (hasChecked("idList") == false) {
                alert("请至少选择一个用户！");
                return false;
            }
            setAction();
            consumerListForm.action = addAction;
            consumerListForm.submit();
        }
        function backList() {
            setAction();
            consumerListForm.action = backAction;
            consumerListForm.submit();
        }
        function maxShow(max) {
            //调用setParams()对查询参数进行负值
            //setParams();
            consumerListForm.max.value = max;
            consumerListForm.offset.value = 0;
            consumerListForm.action = "groupSelectList";
            consumerListForm.submit();
        }
    </script>
</head>

<body>
<g:form name="consumerListForm" method="post" action="">
    <input type="hidden" name="max" value="${params.max}">
    <input type="hidden" name="sort" value="${params.sort}">
    <input type="hidden" name="order" value="${params.order}">
    <input type="hidden" name="offset" value="${params.offset}">
    <input type="hidden" name="searchName" value="${params.searchName}">
    <input type="hidden" name="searchNickname" value="${params.searchNickname}">
    <input type="hidden" name="searchNNType" value="${params.searchNNType}">
    <input type="hidden" name="row" value="${params.row}">
    <input type="hidden" name="searchTrueName" value="${params.searchTrueName}">
    <input type="hidden" name="searchCollege" value="${params.searchCollege}">
    <input type="hidden" name="searchType" value="${params.searchType}">
    <input type="hidden" name="groupId" value="${params.groupId}">
    <input type="hidden" name="dateEnd" value="${params.dateEnd}">
    <input type="hidden" name="dateBegin" value="${params.dateBegin}">
    <input type="hidden" name="submitTag" value="${params.submitTag}">
    <input type="hidden" name="numBegin" value="${params.numBegin}">
    <input type="hidden" name="numEnd" value="${params.numEnd}">

    <div>
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
                <td width="3%" height="28" align="center" class="STYLE5">选择</td>
                <td width="12%" align="center" class="STYLE5">用户帐号</td>
                <td width="12%" align="center" class="STYLE5">用户昵称</td>
                <td width="17%" align="center" class="STYLE5">真实姓名</td>
                <td width="9%" align="center" class="STYLE5">所属院系</td>
                <td width="10%" align="center" class="STYLE5">角色</td>
                <td width="4%" align="center" class="STYLE5">状态</td>
                <td width="5%" align="center" class="STYLE5">上传</td>
                <td width="4%" align="center" class="STYLE5">下载</td>
                <td width="4%" align="center" class="STYLE5">评论</td>
                <td width="4%" align="center" class="STYLE5">审核</td>
                <td width="7%" align="center" class="STYLE5">创建时间</td>
            </tr>
            <g:each in="${searchList}" status="i" var="consumer">
                <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}" align="center" class="STYLE5">
                    <td><g:checkBox name="idList" value="${fieldValue(bean: consumer, field: 'id')}" checked=""
                                    onclick="unCheckAll('selall');"/></td>
                    <td align="left">
                        <g:if test="${consumer.gender == 1}">
                            <img align="center" src="${createLinkTo(dir: 'images/skin', file: 'consumer_man.gif')}">
                        </g:if>
                        <g:if test="${consumer.gender == 0}">
                            <img src="${createLinkTo(dir: 'images/skin', file: 'consumer_woman.gif')}">
                        </g:if>
                        ${fieldValue(bean: consumer, field: 'name')}
                    </td>
                    <td>${fieldValue(bean: consumer, field: 'nickname')}</td>
                    <td>${fieldValue(bean: consumer, field: 'trueName')}</td>

                    <td>${fieldValue(bean: consumer, field: 'college.name')}</td>
                    <td>
                        <g:if test="${consumer.role == 1}">资源管理员</g:if>
                        <g:if test="${consumer.role == 2}">老师</g:if>
                        <g:if test="${consumer.role == 3}">学生</g:if>
                    </td>
                    <td align="center">
                        <g:if test="${consumer.userState}">正常</g:if>
                        <g:if test="${!consumer.userState}"><font color="red">锁定</font></g:if>
                    </td>

                    <td>
                        <g:if test="${consumer.uploadState == 1}">
                            <img align="center" src="${createLinkTo(dir: 'images/skin', file: 'consumer_upload.gif')}">
                        </g:if>
                        <g:if test="${consumer.uploadState == 0}">
                            <img src="${createLinkTo(dir: 'images/skin', file: 'consumer_nodownload.gif')}">
                        </g:if>
                        <g:if test="${consumer.uploadState == 2}">
                            <img src="${createLinkTo(dir: 'images/skin', file: 'consumer_apply.gif')}">
                        </g:if>
                    </td>

                    <td>
                        <g:if test="${consumer.canDownload}">
                            <img align="center"
                                 src="${createLinkTo(dir: 'images/skin', file: 'consumer_download.gif')}">
                        </g:if>
                        <g:if test="${!consumer.canDownload}">
                            <img src="${createLinkTo(dir: 'images/skin', file: 'consumer_nodownload.gif')}">
                        </g:if>
                    </td>
                    <td>
                        <g:if test="${consumer.canComment}">
                            <img align="center" src="${createLinkTo(dir: 'images/skin', file: 'consumer_commnet.gif')}">
                        </g:if>
                        <g:if test="${!consumer.canComment}">
                            <img src="${createLinkTo(dir: 'images/skin', file: 'consumer_nocommnet.gif')}">
                        </g:if>
                    </td>
                    <td>${consumer.notExamine ? '免审' : '审核'}</td>
                    <td><g:formatDate format="yyyy-MM-dd" date="${consumer.dateCreated}"/></td>
                </tr>
            </g:each>
        </table>
        <br>

        <div class="operation">
            <input id="selall" name="selall" onclick="checkAll(this, 'idList')" type="checkbox">全选&nbsp;
            <input type="button" class="button" value="添加到组" onClick="addGroup()"/>
            <input type="button" class="button" value="返回组列表" onClick="backList()"/>
        </div>

        <TABLE width="100%" height="16" border=0 cellPadding=1 cellSpacing=1 bgcolor="#E9E8E7">
            <TBODY>
            <TR>
                <TD width="693" height="16" align="center">
                    <div align="left">
                        <a href="#" onClick="maxShow(10)">
                            <IMG id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" width=19 height=16
                                 border=0 class="STYLE8" title="每页显示10条">
                        </a>&nbsp;
                        <a href="#" onClick="maxShow(50)">
                            <IMG id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" width=20 height=15
                                 border=0 class="STYLE8" title="每页显示50条">
                        </a>&nbsp;
                        <a href="#" onClick="maxShow(100)">
                            <IMG id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" width="27"
                                 height="16" border=0 class="STYLE8" title="每页显示100条">
                        </a>
                        <a href="#" onClick="maxShow(200)">
                            <IMG id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" width="28"
                                 height="16" border=0 class="STYLE8" title="每页显示200条">
                        </a>
                    </div>
    </div>
    </TD>
    <TD width=11>&nbsp;</TD>
    <TD width="425" align=right><div class="STYLE8">
        <g:paginate total="${total}" offset="${params.offset}" action="groupSelectList" params="${params}"/>&nbsp;&nbsp;
    </TD>
    </TR>
  </TBODY>
</TABLE>
</g:form>
<script Language="JavaScript">
    changePageImg(${params.max});
</script>
</body>

</html>
