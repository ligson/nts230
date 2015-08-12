<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 14-2-25
  Time: 下午2:01
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <r:require modules="zTree"></r:require>
    <title>资源管理</title>
    <script type="text/javascript" src="${resource(dir: "js/boful/appMgr/serverNode", file: "serverNodeTree.js")}"></script>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/css', file: 'ProgramServerNode.css')}">
</head>

<body>
<!---------当前位置----->
<div class="x_daohang">
    <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>>作品管理
</div>
<div>
<div class="ztree_box">
    <div class="ztree_title">节点树:</div>

    <div id="zTree" class="ztree"></div>
</div>

<div class="ztree_box_intu">
    <div>
        <div class="ztree_input">
            IP&nbsp;&nbsp;<input type="text" value="" name="ip" id="ip">
            端口&nbsp;&nbsp;<input type="text" value="" name="port" id="port">
        </div>
    </div>

    <div class="zTree_local_tab">
        <h3 class="zTree_local_title">本地资源列表:</h3>
        <input type="hidden" value="" id="selectServerNodeTypeId">

        <div class="zTree_local_infor">
            <table border="0" width="100%">
                <tbody>
                <tr class="tree_list">
                    <td width="10%">ID</td>
                    <td width="60%">资源名称</td>
                    <td width="30%">操作</td>
                </tr>
                <g:each in="${programList}" var="program" status="sta">
                    <tr
                        <g:if test="${sta % 2 == 0}">class="tr_list1"</g:if>
                        <g:else>class="tr_list2"</g:else>>
                        <td>${program?.id}</td>
                        <td><a href="${createLink(controller: 'program',action: 'showProgram',params: [id:program?.id])}" target="_blank">${program?.name}</a></td>
                        <td>
                            <button class="zTree_send" onclick="send_btn('${program?.id}')">分发</button>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>

    <div class="tree_page">
        <g:paginate offset="${params.offset}" max="${params.max}" total="${total}" action="localProgramServerNode"
                    params="${params}"/>
    </div>
</div>
</div>
<script type="text/javascript">
    function send_btn(tag) {
        var selectServerNodeTypeId = document.getElementById("selectServerNodeTypeId").value;
        if (selectServerNodeTypeId == "") {
            alert("请先选择树节点!")
        } else {
            var url = "${createLink(action: 'sendProgram',controller: 'distributeApply')}";
            var pars = {serverNodeId: selectServerNodeTypeId, programId: tag};
            $.ajax({
                url: url,
                data: pars,
                success: function (data) {
                    alert(data);
                }
            })
        }

    }
</script>
</body>
</html>