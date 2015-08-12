<%@ page import="nts.utils.CTools; nts.program.domain.Program" %>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>nts</title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" type=text/css
          rel=stylesheet>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}" type=text/css
          rel=stylesheet>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" rel="stylesheet" type="text/css">
    <style>
    table {
        border: 0px solid #ccc;
        margin-left: 20px;
        margin-right: 20px;
    }

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
        line-height: 18px;
    }

    </style>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/prototype.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <SCRIPT LANGUAGE="JavaScript">
        <!--
        function setGroupListDiv() {
            var editDiv = document.getElementById("groupList");
            editDiv.style.display = "block";
            setDivPos(editDiv, 400, editDiv.offsetWidth);
            document.getElementById("applyToLib").style.display = "none";//同时只有一个层显示
        }

        function setApplyToLibDiv() {
            var editDiv = document.getElementById("applyToLib");
            editDiv.style.display = "block";
            setDivPos(editDiv, 400, editDiv.offsetWidth);
            document.getElementById("groupList").style.display = "none";//同时只有一个层显示
        }

        function checkGroup(theForm) {
            return true;
        }

        function onOperateSuccess(divId) {
            hideWnd(divId);
            alert("操作成功！");
        }

        function onOperateFailure(divId) {
            alert("操作失败！");
            //hideWnd(divId);
        }

        function onCanAll(theObj) {
            var divObj = document.getElementById("groupListTab");
            if (divObj) divObj.style.display = theObj.value == 1 ? "none" : "block";
        }

        function submitSch() {
            //self.location.href = baseUrl + "my/manageProgram?state="+theForm.state.value+"&max="+theForm.max.value;
            //self.location.href = "";
            document.form1.submit();
        }

        function onPageNumPer(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;
            submitSch();
        }

        function onApplyOperateSuccess(divId) {
            //hideWnd(divId);
            //alert("操作成功！");
            document.form1.submit();
        }

        function init() {
            form1.state.value = "${CTools.nullToZero(params.state)}";
            changePageImg(${CTools.nullToOne(params.max)});
        }

        //-->
    </SCRIPT>
</head>
<g:set var="isFromRecycler" value="${(params.fromModel == 'myRecycler' || params.fromModel == 'programMgrRecycler')}"/>
<body onload="init();">
<form name="form1" action="manageProgram">
    <input type="hidden" name="max" value="${params.max}">
    <input type="hidden" name="offset" value="${params.offset}">
    <input type="hidden" name="fromModel" value="${params.fromModel}">
    <table width="98%" border="0" cellspacing="0" cellpadding="0" class="biaoge-hui">
        <tr>
            <td align="center">类库:</td>
            <td>
                <g:select id="directoryId" name='directoryId' value="${params.directoryId}"
                          noSelection="${['0': '--请选择类库--']}" from='${directoryList}' optionKey="id"
                          optionValue="name"></g:select>
            </select>
            </td>
            <td align="center">${Program.cnField.state}:</td>
            <td>
                <select name="state" ${isFromRecycler ? 'disabled' : ''}>
                    <option value="0">全部</option>
                    <g:if test="${params.fromModel == 'programMgr'}">
                        <option value="${Program.APPLY_STATE}">${Program.cnState[Program.APPLY_STATE]}</option>
                        <option value="${Program.CLOSE_STATE}">${Program.cnState[Program.CLOSE_STATE]}</option>
                        <option value="${Program.PUBLIC_STATE}">${Program.cnState[Program.PUBLIC_STATE]}</option>
                    </g:if>
                    <g:else>
                        <option value="${Program.NO_APPLY_STATE}">${Program.cnState[Program.NO_APPLY_STATE]}</option>
                        <option value="${Program.NO_PASS_STATE}">${Program.cnState[Program.NO_PASS_STATE]}</option>
                        <option value="${Program.APPLY_STATE}">${Program.cnState[Program.APPLY_STATE]}</option>
                    </g:else>
                </select>
            </td>
            <td align="center">检索类型:</td>
            <td>
                <select name="schType">
                    <option value="name" ${params?.schType == 'name' ? 'selected' : ''}>${Program.cnField.name}</option>
                    <option value="actor" ${params?.schType == 'actor' ? 'selected' : ''}>${Program.cnField.actor}</option>
                    <g:if test="${params?.fromModel == 'programMgr'}">
                        <option value="consumer" ${params?.schType == 'consumer' ? 'selected' : ''}>${Program.cnField.consumer}</option>
                    </g:if>
                    <option value="programTags" ${params?.schType == 'programTags' ? 'selected' : ''}>${Program.cnField.programTags}</option>
                </select>
                <input name="schWord" value="${params?.schWord}" style="width:200px;">(对应检索类型的检索词)
            </td>
            <td></td>
            <td width="20%"><img src="${resource(dir: 'images/skin', file: 'search.gif')}" style="cursor:pointer;" onclick="submitSch();"
                                 border="0"></td>
        </tr>
    </table>

    <table width="98%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF" id="tb1">
        <tr>
            <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB" property="name"
                              title="${Program.cnField.name}" params="${params}"/>
            <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB" property="actor"
                              title="${Program.cnField.actor}" params="${params}"/>
            <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB" property="consumer"
                              title="${Program.cnField.consumer}" params="${params}"/>
            <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB" property="id"
                              title="${Program.cnField.dateCreated}" params="${params}"/>
            <g:if test="${isFromRecycler}">
                <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB" property="dateDeleted"
                                  title="${Program.cnField.dateDeleted}" params="${params}"/>
            </g:if>
            <g:else>
                <g:sortableColumn align="center" style="font-weight:normal;background:#BDEDFB" property="state"
                                  title="状态" params="${params}"/>
            </g:else>

            <g:if test="${params?.fromModel == 'programMgr'}">
                <td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5">审批</td>
                <td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5">发布</td>
                <td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5">修改</td>
                <td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5">删除</td>
            </g:if>
            <g:elseif test="${isFromRecycler}">
                <td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5">还原</td>
                <td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5">删除</td>
            </g:elseif>
            <g:else>
                <td width="9%" align="center" bgcolor="#BDEDFB" class="STYLE5">设置浏览权限</td>
                <td width="9%" align="center" bgcolor="#BDEDFB" class="STYLE5">设置下载权限</td>
                <td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5">申请入库</td>
                <td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5">修改</td>
                <td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5">删除</td>
            </g:else>
        </tr>
        <g:each in="${programList ?}" status="i" var="program">
            <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                <td align="center"><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program?.id])}"
                                      target="_blank">${program?.name.encodeAsHTML()}</a></td>
                <td align="center">${program?.actor.encodeAsHTML()}</td>
                <td align="center">${program?.consumer.nickname.encodeAsHTML()}</td>
                <td align="center" class="STYLE5"><g:formatDate format="yyyy-MM-dd"
                                                                date="${program?.dateCreated}"/></td>

                <g:if test="${isFromRecycler}">
                    <td align="center" nowrap="nowrap"><g:formatDate format="yyyy-MM-dd"
                                                                     date="${program?.dateDeleted}"/></td>
                </g:if>
                <g:else>
                    <td align="center" nowrap="nowrap">${Program.cnState[program?.state]}</td>
                </g:else>

                <g:if test="${params?.fromModel == 'programMgr'}">
                    <td align="center"><g:if test="${program.state == Program.APPLY_STATE}"><a
                            href="${createLink(controller: 'program', action: 'setProgramState', params: params.putAll([idList: program?.id, applyState: Program.PUBLIC_STATE]) ? params : params)}"><img
                                src="${resource(dir: 'images/skin', file: 'pass.gif')}" alt="通过" border="0"></a><a
                            href="${createLink(controller: 'program', action: 'setProgramState', params: params.putAll([idList: program?.id, applyState: Program.NO_PASS_STATE]) ? params : params)}"><img
                                src="${resource(dir: 'images/skin', file: 'nopass.gif')}" alt="退回" border="0"></a></g:if></td>
                    <td align="center"><g:if test="${program.state == Program.CLOSE_STATE}"><a
                            href="${createLink(controller: 'program', action: 'setProgramState', params: params.putAll([idList: program?.id, applyState: Program.PUBLIC_STATE]) ? params : params)}"><img
                                src="${resource(dir: 'images/skin', file: 'public.gif')}" alt="发布" border="0"></a></g:if><g:if
                            test="${program.state == Program.PUBLIC_STATE}"><a
                                href="${createLink(controller: 'program', action: 'setProgramState', params: params.putAll([idList: program?.id, applyState: Program.CLOSE_STATE]) ? params : params)}"><img
                                    src="${resource(dir: 'images/skin', file: 'close.gif')}" alt="关闭" border="0"></a></g:if></td>
                    <td align="center"><a
                            href="${createLink(controller: 'program', action: 'edit', id: program?.id, params: params)}"><img
                                src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="修改" border="0"></a></td>
                    <td align="center"><a
                            href="${createLink(controller: 'program', action: 'toRecycler', params: params.putAll([idList: program?.id]) ? params : params)}"
                            onclick="return confirm('确实要删除资源\'${program?.name.encodeAsJavaScript()}\'吗？');"><img
                                src="${resource(dir: 'images/skin', file: 'delete.gif')}" alt="删除" border="0"></a></td>
                </g:if>
                <g:elseif test="${isFromRecycler}">
                    <td align="center"><a
                            href="${createLink(controller: 'program', action: 'setProgramState', params: params.putAll([idList: program?.id, applyState: Math.abs(program?.state)]) ? params : params)}"><img
                                src="${resource(dir: 'images/skin', file: 'huanyuan.gif')}" alt="还原" border="0"></a></td>
                    <td align="center"><a
                            href="${createLink(controller: 'program', action: 'delete', params: params.putAll([idList: program?.id]) ? params : params)}"
                            onclick="return confirm('确实要删除该资源\'${program?.name.encodeAsJavaScript()}\'吗？删除后就不能再恢复了。');"><img
                                src="${resource(dir: 'images/skin', file: 'delete.gif')}" alt="" border="0"></a></td>
                </g:elseif>
                <g:else>
                    <td align="center"><img src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" border="0"
                                            onclick="${remoteFunction(action:'showMyGroup',update:'groupList',onComplete:'setGroupListDiv()',params:'\'priType=play&programId='+program?.id+'\'')};">
                    </td>
                    <td align="center"><img src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" border="0"
                                            onclick="${remoteFunction(action:'showMyGroup',update:'groupList',onComplete:'setGroupListDiv()',params:'\'priType=download&programId='+program?.id+'\'')};">
                    </td>
                    <td align="center"><g:if test="${program?.state != Program.APPLY_STATE}"><img
                            src="${resource(dir: 'images/skin', file: 'point.gif')}" alt="" border="0"
                            onclick="${remoteFunction(action:'showProg',update:'applyToLib',onComplete:'setApplyToLibDiv()',params:'\'programId='+program?.id+'\'')};"></g:if>
                    </td>
                    <td align="center"><a
                            href="${createLink(controller: 'program', action: 'edit', id: program?.id, params: params)}"><img
                                src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" border="0"></a></td>
                    <td align="center"><a
                            href="${createLink(controller: 'program', action: 'toRecycler', params: [idList: program?.id] + params)}"
                            onclick="return confirm('确实要删除该资源\'${program?.name.encodeAsJavaScript()}\'吗？');"><img
                                src="${resource(dir: 'images/skin', file: 'delete.gif')}" alt="" border="0"></a></td>
                </g:else>
            </tr>
        </g:each>
    </table>

    <div style="height:20px;"></div>

    <table width="98%" height="16" border="0" cellpadding="1" cellspacing="1" bgcolor="#E9E8E7">
        <tr>
            <td width="693" height="16" align="center">
                &nbsp;&nbsp;&nbsp;&nbsp;总共：${total}个资源&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 每页${params.max}条&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;每页显示:
                <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                     onclick="onPageNumPer(10)">&nbsp;
                <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0"
                     onclick="onPageNumPer(50)">&nbsp;
                <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0"
                     onclick="onPageNumPer(100)">&nbsp;
                <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0"
                     onclick="onPageNumPer(200)">&nbsp;
            </td>
            <td width="11">&nbsp;</td>
            <td width="425" align="right"><div class="paginateButtons"><g:paginate controller="my"
                                                                                   action="manageProgram"
                                                                                   total="${total}"
                                                                                   params="${params}"/></div></td>
        </tr>
    </table>
</form>

<g:render template="groupList" model="[groupList: null]"/>
<g:render template="applyToLib" model="[program: null]"/>
</body>
</html>

