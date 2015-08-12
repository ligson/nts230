<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 14-2-25
  Time: 下午8:53
--%>

<%@ page import="nts.program.domain.Program" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>时间计划</title>
    <r:require modules="zTree"/>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <script type="text/javascript"
            src="${resource(dir: "js/boful/appMgr/serverNode", file: "timePlanTree.js")}"></script>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'ProgramServerNode.css')}">
    %{--    <style type="text/css">
            .table label{
                float: left;
                margin-right: 8px;
            line-height:18px;
                display: block;
                font-weight: normal;
            }
            .tretable{
                width: 95px;
                line-height: 32px;
            }
        </style>--}%
</head>

<body>
<div class="ztree_box_intu" style="width: 99%;">
    ${flash.message}
    <div class="ztree_input" style="height: 60px">
        <input type="button" class="btn btn-default" style="width: 110px;" value="添加时间计划" id="addTimePlanBtn"/>
    </div>

    %{--   <div class="zTree_local_infor" style="overflow: hidden; float: left; margin: 10px 0;">

       </div>--}%

    <div class="tree_page" style="margin: 10px 0; " id="page_div">
        <div id="timePlanDialog" title="添加时间计划">

            <g:form controller="programMgr" name="addTimePlan" action="saveTimePlan">
                <table class="table" width="400">
                    <tr>
                        <td class="tretable" width="100">时间计划名称</td>
                        <td><input type="text" class="form-control" style="width: 200px;" name="name"/></td>
                    </tr>
                    <tr>
                        <td height="30" class="tretable">策略选择</td>
                        <td>
                            <select class="form-control" style="width: 200px;" name="disId">
                                <option value="-1">----无----</option>
                                <g:each in="${distributePolicyList}" var="policy">
                                    <option value="${policy?.id}">${policy?.serverNodes[0].name}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td height="30" class="tretable">时间计划表达式(cron)</td>
                        <td>
                            <input type="text" class="form-control" name="expression" value=""/>
                        </td>
                    </tr>
                    <tr>
                        <td height="30" class="tretable">时间策略</td>
                        <td><label><input name="category" value="0" type="radio" checked/>分发</label><label><input name="category" value="1" type="radio"/>收割</label></td>
                    </tr>
                    <tr>
                        <td height="30" class="tretable">是否启用</td>
                        <td><label><input name="isActive" value="1" type="radio" checked/>是</label><label><input name="isActive" value="0" type="radio"/>否</label></td>
                    </tr>
                </table>
            </g:form>
        </div>
        <table class="table table-hover">
            <tr>
                <th class="text-left">时间计划名称</th>
                <th width="200">计划表达式</th>
                <th width="100">用途</th>
                <th width="100">状态</th>
                <th width="200">操作</th>
            </tr>
            <g:each in="${timePlanList}" var="timePlan">
                <tr>
                    <td class="text-left">${timePlan?.name}</td>
                    <td class="text-left">
                        ${timePlan?.expression}
                    </td>
                    <td class="text-left">${timePlan?.category == 0 ? '分发' : '收割'}</td>
                    <td class="text-left">${timePlan?.isActive == true ? '启用' : '禁止'}</td>
                    <td class="text-left">
                        <input type="button" class="btn btn-primary btn-xs" value="编辑" onclick="window.location.href='${createLink(controller: 'programMgr',action: 'editTimePlan2',params: [id:timePlan?.id])}'"/>
                        <input type="button" class="btn btn-primary btn-xs" value="删除" onclick="deleteTimePlan(${timePlan?.id})"/>
                    </td>
                </tr>
            </g:each>
        </table>
    </div>
</div>
<script type="text/javascript">

</script>
</body>
</html>