<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 14-2-25
  Time: 下午8:53
--%>

<%@ page import="nts.program.domain.Program" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
    <r:require modules="zTree"></r:require>
    <script type="text/javascript" src="${resource(dir: "js/boful/appMgr/serverNode", file: "serverNodeTree1.js")}"></script>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/css', file: 'ProgramServerNode.css')}">
</head>

<body>
<!---------当前位置----->
<div class="x_daohang">
    <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>>作品管理
</div>

<div class="ztree_box">
    <div class="ztree_title">节点树:</div>

    <div id="zTree" class="ztree"></div>
</div>

<div class="ztree_box_intu">

    <div class="ztree_input">
        IP&nbsp;&nbsp;<input type="text" value="" name="ip" id="ip">
        端口&nbsp;&nbsp;<input type="text" value="" name="port" id="port">
    </div>
    <input type="hidden" value="" id="selectServerNodeTypeId">
    <input type="hidden" value="${params.max}" id="max" name="max">
    <input type="hidden" value="${params.offset}" id="offset" name="offset">

    <div id="error_div"><g:if test="${errors.size() > 0}">
        <h3 style="color: red">错误原因:</h3>
        <g:each in="${errors}" var="error">
            <div>"IP:"${error.key}"异常:"${error.value}</div><br>
        </g:each>
    </g:if></div>

    <div class="zTree_local_infor">
        <table border="0" width="100%" id="tab">
            <tbody>
            <tr class="tree_list">
                <td width="10%">选择</td>
                <td width="20%">ID</td>
                <td width="50%">资源名称</td>
                <td width="20%">操作</td>
            </tr>
            <g:each in="${programList}" var="program" status="sta">
                <tr   <g:if test="${sta % 2 == 0}">class="tr_list1"</g:if>
                      <g:else>class="tr_list2"</g:else>>
                    <td><input type="checkbox" name="id" value="${program?.id}"></td>
                    <td>${program?.id}</td>
                    <td>${program?.name}</td>
                    <td>
                        <g:if test="${!Program.findByName(program?.name)}">
                        <button class="zTree_send" onclick="resources_btn('${program?.id}')">收割资源</button></g:if>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>

    <div class="tree_page" id="page_div">
        <g:paginate offset="${params.offset}" max="${params.max}" total="${total}" action="programServerNode"/>
    </div>
</div>
<script type="text/javascript">
    function resources_btn(tag) {
        var selectServerNodeTypeId = document.getElementById("selectServerNodeTypeId").value;
        if (selectServerNodeTypeId == "") {
            alert("请先选择树节点!")
        } else {
            var url = "${createLink(action: 'resourceProgram',controller: 'distributeApply')}";
            var pars = {serverNodeId: selectServerNodeTypeId, programId: tag};
            $.ajax({
                url: url,
                data: pars,
                success: function (data) {
                    alert(data)
                }
            })
        }
    }
</script>
</body>
</html>