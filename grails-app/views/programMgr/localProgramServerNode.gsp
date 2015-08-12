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
    <r:require modules="zTree,jqGrid"/>
    <title>资源管理</title>
    <script type="text/javascript"
            src="${resource(dir: "js/boful/appMgr/serverNode", file: "serverNodeTree.js")}"></script>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'ProgramServerNode.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}">
</head>

<body>

<div>
    <div class="ztree_box" style="width: 20%; min-width: 210px">
        <div class="ztree_title">节点树:</div>

        <div id="serverNodeTree" class="ztree"></div>
    </div>

    <div class="ztree_box_intu" style="width: 75%;">
        <div>
            <div class="ztree_input">
                <input type="hidden" name="localNodeIp" value="${localNode.ip}"/>
                <input type="hidden" name="localNodePort" value="${localNode.port}"/>
                <input type="hidden" name="localNodeId" value="${localNode.id}"/>
                <span>I&nbsp;P</span><input class="admin_default_inp admin_default_inp_size1" type="text" value=""
                                            name="ip" id="ip">
                <span>上传端口</span><input class="admin_default_inp admin_default_inp_size1" type="text" value=""
                                        name="port" id="port">
            </div>
        </div>
        <div id="errors" style="color: red"></div>
        <div class="zTree_local_tab">
            <h3 class="zTree_local_title">本地资源列表:</h3>
            <input type="hidden" value="" id="selectServerNodeTypeId">

            <div class="zTree_local_infor">

                <table id="programGrid"></table>

                <div id="GridPaper"></div>
            </div>
        </div>


    </div>
</div>
</body>
</html>