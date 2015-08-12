<%@ page import="nts.utils.CTools" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <title>回复列表</title>
    <script language="javaScript">
        function remarkDelete() {
            var sumT = confirm('确定删除?');
            if (!sumT) {
                return false;
            }
            setParams();
            remarkForm.action = "deleteRemark";
            remarkForm.submit();
            return true;
        }
        function showInfo(id, title) {

            var content = eval("remarkForm.bz" + id + ".value");
            img1.style.visibility = 'visible';

            remarkForm.updateId.value = id;
            remarkForm.updateTitle.value = title;
            remarkForm.updateContent.value = content;

        }

        function deleteRemark() {
            var sumT = confirm('确定删除?');
            if (!sumT) {
                return false;
            }

            if (hasChecked("idList") == false) {
                alert("请至少选择一条错误！");
                return false;
            }
            setParams();
            remarkForm.action = "deleteRemark";
            remarkForm.submit();
            return true;
        }
        function setParams() {
            remarkForm.searchTitle.value = "${params.searchTitle}";
            remarkForm.searchContent.value = "${params.searchContent}";
            remarkForm.searchProgram.value = "${params.searchProgram}";
            remarkForm.searchConsumer.value = "${params.searchConsumer}";
        }

        function maxShow(max) {
            //调用setParams()对查询参数进行负值
            setParams();
            remarkForm.max.value = max;
            remarkForm.offset.value = 0;
            remarkForm.action = "remarkList";
            remarkForm.submit();
        }

        function orderBy(sort) {
            //调用setParams()对查询参数进行负值
            setParams();
            remarkForm.sort.value = sort;
            if (remarkForm.order.value == "desc") {
                remarkForm.order.value = "asc";
            }
            else {
                remarkForm.order.value = "desc";
            }
            remarkForm.action = "remarkList";
            remarkForm.submit();
        }
        function remarkSearch() {
            remarkForm.action = "remarkList";
            remarkForm.submit()
        }
        function show(remarkId) {
            setParams();
            remarkForm.action = "showRemark?id=" + remarkId + "";
            remarkForm.submit();
        }
        function isPassRemarkList(sIsPass) {
            if (sIsPass == "1" && !confirm('通过评论?'))
                return false;
            if (sIsPass == "0" && !confirm('评论不通过?'))
                return false;

            if (hasChecked("idList") == false) {
                alert("请至少选择一条评论！");
                return false;
            }
            setParams();
            remarkForm.action = baseUrl + "appMgr/isPassRemarkList?sIsPass=" + sIsPass;
            remarkForm.submit();
            return true;
        }
    </script>
</head>

<body>

<div class="x_daohang">
    <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>&gt;&gt;<a
        href="${createLink(controller: 'appMgr', action: 'remarkList')}">评论管理</a>&gt;&gt; 评论列表
</div>

<div class="body">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>

    <g:form method="post" name="remarkForm" id="remarkForm">

        <input type="hidden" name="offset" value="${params.offset}"/>
        <input type="hidden" name="sort" value="${params.sort}"/>
        <input type="hidden" name="order" value="${params.order}"/>
        <input type="hidden" name="max" value="${params.max}"/>
        <div style="margin: 10px 0 0 10px; height: 30px;">
        <table width="98%" border="0" cellpadding="0" cellspacing="0" bordercolor="#E9E8E7">
            <tr>
                <td  width="5%" align="center">评论标题:</td>
                <td  width="10%" align="left"><input type="text" class="newsinput1" name="searchTitle" value=""/></td>
                <td  width="5%" align="center">评论内容:</td>
                <td  width="10%" align="left"><input type="text" class="newsinput1" name="searchContent" value=""/></td>
                <td  width="5%" align="center">节目名称:</td>
                <td  width="10%" align="left"><input type="text" class="newsinput1" name="searchProgram" value=""/></td>
                <td  width="5%" align="center">评论人:</td>
                <td width="10%" align="left"><input type="text" class="newsinput1" name="searchConsumer" value=""/></td>
                <td width="5%" align="center"><input name="search" type="button" class="button" onClick="remarkSearch()"
                                                     value="查询"/></td>
            </tr>
        </table>
        </div>
    </g:form>
<p></p>
    <div class="list" style="width: 98%; margin-left: 10px; border-top:#e2e3e4 1px solid" >
        <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
            <tr>
                <td class="th" width="4%" height="28" align="center" class="STYLE5">选择</td>
                <td class="th" width="20%" height="28" align="center" class="STYLE5"><a href="#" onClick="orderBy('topic');
                return false;">评论标题</a></td>
                <td class="th" width="33%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('content');
                return false;">评论内容</a></td>
                <td class="th" width="11%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('program');
                return false;">节目名称</a></td>
                <td class="th" width="9%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('consumer');
                return false;">评论人</a></td>
                <td class="th" width="8%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('dateCreated');
                return false;">评论时间</a></td>
                <td class="th" width="8%" align="center" class="STYLE5"><a href="#d" onClick="orderBy('dateCreated');
                return false;">审核状态</a></td>
                <td class="th" width="8%" align="center" class="STYLE5">查看</td>
            </tr>
            <g:each in="${remarkList}" status="i" var="remark">
                <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                    <td><g:checkBox name="idList" value="${fieldValue(bean: remark, field: 'id')}"
                                    onclick="unCheckAll('selall');"/></td>
                    <td><a href="#d" onClick="show('${remark.id}')"
                           title="${remark.topic}">${CTools.cutString(fieldValue(bean: remark, field: 'topic'), 10)}</a>
                    </td>
                    <td title="${remark.content}">${CTools.cutString(fieldValue(bean: remark, field: 'content'), 20)}</td>
                    <td title="${remark.program.name}">${CTools.cutString(fieldValue(bean: remark, field: 'program.name'), 6)}</td>
                    <td>${fieldValue(bean: remark, field: 'consumer.nickname')}</td>
                    <td><g:formatDate format="yyyy-MM-dd" date="${remark.dateCreated}"/></td>
                    <td align="center">
                        ${remark?.isPass ? "通过" : "不通过"}
                    </td>
                    <td align="center" class="STYLE5">
                        <a href="#d" onClick="show('${remark.id}')"><img src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt=""
                                                                         width="14" height="14" border="0"></a>
                    </td>
                </tr>
            </g:each>
        </table>
    </div>
    <br>
    &nbsp;&nbsp;
    <input id="selall" name="selall" onclick="checkAll(this, 'idList')" type="checkbox">全选&nbsp;
    <input class="subbtn" type="button" value="删除评论" onClick="deleteRemark()"/>&nbsp;
    <g:if test="${application?.remarkAuthOpt == 1}">
        <input class="subbtn" type="button" value="通过" onClick="isPassRemarkList(1)"/>&nbsp;
        <input class="subbtn" type="button" value="不通过" onClick="isPassRemarkList(0)"/>
    </g:if>

    <TABLE width="100%" height="16" border=0 cellPadding=1 cellSpacing=1 bgcolor="#E9E8E7">
        <TBODY>
        <TR>
            <TD width="693" height="16">
                &nbsp;总共：${total} 条记录&nbsp;|&nbsp;每页${params.max}条&nbsp;|&nbsp;每页显示:
                <IMG onClick="maxShow(10)" id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" border=0
                     class="STYLE8" title="每页显示10条">
                <IMG onClick="maxShow(50)" id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" border=0
                     class="STYLE8" title="每页显示50条">
                <IMG onClick="maxShow(100)" id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" border=0
                     class="STYLE8" title="每页显示100条">
                <IMG onClick="maxShow(200)" id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" border=0
                     class="STYLE8" title="每页显示200条">
            </TD>

            <TD width=11>&nbsp;
            </TD>
            <TD width="425" align=right>
                <div class="STYLE8">
                    <g:paginate total="${total}" offset="${params.offset}" action="remarkList"
                                params="${[sort: params.sort, max: params.max, order: params.order, offset: params.offset, searchTitle: params.searchTitle, searchContent: params.searchContent, searchConsumer: params.searchConsumer, searchProgram: params.searchProgram]}"/>&nbsp;&nbsp;
                </div>
            </TD>
        </TR>
        </TBODY>
    </TABLE>

    %{--<div align="left" name="img1" id="img1"
         style="position:absolute; width:400; height:375; left:450px; top:260px; z-index:100;display:none;">
        <input type="hidden" name="updateId" value=""/>
        <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF" bgcolor="#ECF0ED">
            <tr>
                <td width="15%" height="15" rowspan="2" align="center">评论标题</td>
            </tr>
            <tr>
                <td colspan="3"><input name="updateTitle" type="text" size="42" class="newsinput1"/></td>
            </tr>
            <tr>
                <td width="10%" align="center">评论内容</td>
                <td><textarea name="updateContent" cols="40" rows="10" class="newsinput2"/></td>
            </tr>

            <tr>
                <td width="10%" align="center">
                    <input name="update_enter" type="button" class="button" onClick="remarkDelete()" value="删除"/>
                </td>
                <td align="left">
                    <input name="update_cancel" type="button" class="button"
                           onClick="img1.style.visibility = 'hidden'" value="取消"/></td>
            </tr>
        </table>
    </div>--}%
</div>

<script lang="JavaScript" type="text/javascript">
    changePageImg(${params.max});
</script>
</body>
</html>
