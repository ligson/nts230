<%@ page import="nts.system.domain.Qnaire" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>问卷管理</title>

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
    }

    .STYLE9 {
        color: #990000;
        font-weight: bold;
        font-size: 12px;
    }
    </style>

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>

    <SCRIPT LANGUAGE="JavaScript">
        function submitSch() {
            document.form1.action = baseUrl + "appMgr/qnaireList"
            document.form1.submit();
        }

        function onPageNumPer(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;

            submitSch();
        }

        function addQnaire() {
            self.location = baseUrl + 'appMgr/createQnaire';
        }

        function deleteLog() {
            if (hasChecked("idList") == false) {
                alert("请至少选择一条问题！");
                return false;
            }
            if (confirm("删除问卷则其答卷也将删除，确实要删除本问卷吗？")) {
                form1.action = baseUrl + "appMgr/deleteQnaire";
                form1.submit();
            }
        }



    </SCRIPT>
</head>

<body>
<div class="x_daohang">
    <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'appMgr', action: 'qnaireList')}">调查问卷</a>>> 问卷管理
</div>
<div style="margin-left: 15px; width: 98%; margin-bottom: 0; overflow: hidden; ">
<form name="form1" method="post" style="width:100%">
    <input type="hidden" name="max" value="${params.max}">
    <input type="hidden" name="offset" value="${params.offset}">


    <table width="100%" border="0" cellpadding="0" cellspacing="0" bordercolor="#E9E8E7">

        <tr>
            <td align="left" style="padding:5px 0px 8px 10px;"
                height="30"><strong>问卷状态说明：</strong><br>
                &nbsp;1.未发布状态：问卷尚未形成，不对外发布，此状态可编辑问卷；<br>
                &nbsp;2.发布状态：问卷已编辑无误，对外发布，用户填写问卷表，调查正在进行中，此状态不可编辑问卷；<br>
                &nbsp;3.关闭状态：调查已结束，不对外发布，此状态不可编辑问卷。
            </td>
        </tr>
    </table>
    <table width="100%" style="border: 0px;" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF"
           id="progListTab">

        <tr>
            <th width="50" align="center" style="font-weight:normal;">选择</th>
            <g:sortableColumn property="name" title="${message(code: 'qnaire.name.label', default: '问卷名称')}"/>
            <g:sortableColumn width="80" property="surveyNum"
                              title="${message(code: 'qnaire.surveyNum.label', default: '调查人次')}"/>
            <g:sortableColumn width="140" property="dateCreated"
                              title="${message(code: 'qnaire.dateCreated.label', default: '创建时间')}"/>
            <g:sortableColumn width="80" property="state"
                              title="${message(code: 'qnaire.state.label', default: '当前状态')}"/>
            <th align="center" width="80" style="font-weight:normal;" title="只有未发布的问卷才能编辑">编辑</th>
            <th align="center" width="80" style="font-weight:normal;">设置状态</th>
        </tr>
        <g:each in="${qnaireList}" status="i" var="qnaire">
            <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                <td align="center">
                    <g:checkBox name="idList" value="${qnaire.id}" checked="" onclick="unCheckAll('selall');"/>
                </td>
                <td>
                    <a href="${createLink(controller: 'appMgr', action: 'qnairePage', params: [id: qnaire?.id])}"
                       title="点击查看问卷信息">${fieldValue(bean: qnaire, field: "name")}</a>
                </td>
                <td align="center">${fieldValue(bean: qnaire, field: 'surveyNum')}</td>
                <td align="center"><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${qnaire.dateCreated}"/></td>
                <td align="center">${Qnaire.cnState[qnaire.state]}</td>
                <td align="center">
                    <g:if test="${qnaire.state == Qnaire.NO_PUBLIC_STATE}">
                        <a href="editQnaire?id=${qnaire.id}"><img src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" width="14"
                                                                  height="14" border="0"></a>
                    </g:if>
                </td>
                <td align="center">
                    <g:if test="${qnaire.state == Qnaire.NO_PUBLIC_STATE || qnaire.state == Qnaire.CLOSE_STATE}">
                        <a href="${createLink(controller: 'appMgr', action: 'setState', params: [id: qnaire.id, oldState: qnaire.state, newState: Qnaire.PUBLIC_STATE])}">发布</a>
                    </g:if>
                    <g:elseif test="${qnaire.state == Qnaire.PUBLIC_STATE}">
                        <a href="${createLink(controller: 'appMgr', action: 'setState', params: [id: qnaire.id, oldState: qnaire.state, newState: Qnaire.CLOSE_STATE])}">关闭</a>
                    </g:elseif>
                </td>
            </tr>
        </g:each>
    </table>
    <table width="100%">
        <tr>
            <td>
                <input id="selall" name="selall" onclick="checkAll(this, 'idList')" type="checkbox">&nbsp;全选&nbsp;
                <input class="subbtn" type="button" value="添加问卷" onClick="addQnaire()"/>&nbsp;
                <input class="subbtn" type="button" value="删除所选" onClick="deleteLog()"/>&nbsp;
            </td>
        </tr>
    </table>
    <table width="100%" style="border: 0px;" height="16" border="0" cellpadding="1" cellspacing="1" bgcolor="#E9E8E7">
        <tr>
            <td width="600" height="16" style="cursor:hand">
                &nbsp;总共：${qnaireInstanceTotal} 条记录&nbsp;|&nbsp;每页${params.max}条&nbsp;|&nbsp;每页显示:
                <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0" class="STYLE8"
                     onclick="onPageNumPer(10)">
                <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0" class="STYLE8"
                     onclick="onPageNumPer(50)">
                <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0" class="STYLE8"
                     onclick="onPageNumPer(100)">
                <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0" class="STYLE8"
                     onclick="onPageNumPer(200)">
            </td>
            <td width="600" height="16" align="right" style="cursor:hand">
                <div class="paginateButtons"><g:paginate total="${qnaireInstanceTotal}" params="${params}"/></div>
            </td>
        </tr>
    </table>
</form>
    </div>
<script Language="JavaScript">
    changePageImg(${params.max});
</script>
</body>
</html>