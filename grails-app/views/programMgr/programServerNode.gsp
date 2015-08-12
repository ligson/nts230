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
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <r:require modules="zTree,jqGrid"/>
    <script type="text/javascript"
            src="${resource(dir: "js/boful/appMgr/serverNode", file: "serverNodeTree1.js")}"></script>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'ProgramServerNode.css')}">
</head>

<body>
<div class="ztree_box" style="width: 20%; min-width: 210px">
    <div class="ztree_title">资源节点:</div>

    <div id="zTree" class="ztree"></div>
</div>

<div class="ztree_box_intu" style="width: 75%;">

    <div class="ztree_input" style=" height: 50px; overflow: hidden">
        <span style="float: left">IP&nbsp;&nbsp;</span>
        <label style="float: left">
            <input class="admin_default_inp " style="height: 30px; width: 180px;" type="text" value="" name="ip"
                   id="ip" disabled>
        </label>
        <span style="float: left">端口&nbsp;&nbsp;</span>
        <label style="float: left">
            <input class="admin_default_inp" type="text" style="height: 30px; width: 180px;" value="" name="port"
                   id="port" disabled>
        </label>
    </div>
    <input type="hidden" value="" id="selectServerNodeTypeId">
    <input type="hidden" value="" id="isLocalNode">
    <input type="hidden" value="${params.max}" id="max" name="max">
    <input type="hidden" value="${params.offset}" id="offset" name="offset">

    <div id="error_div"></div>

    <div class="zTree_local_infor">
        <table id="programGrid"></table>

        <div id="GridPaper"></div>
    </div>

</div>
</body>
</html>