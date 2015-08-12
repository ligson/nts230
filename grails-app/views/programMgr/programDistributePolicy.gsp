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
    <r:require modules="zTree,jquery-ui"/>
    <script type="text/javascript"
            src="${resource(dir: "js/boful/appMgr/serverNode", file: "distributePolicyTree.js")}"></script>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'ProgramServerNode.css')}">
    <style type="text/css">
        .trewidth{
            width: 95px;
        }
    </style>
</head>

<body>
<div class="ztree_box" style="width: 20%; min-width: 210px">
    <div class="ztree_title">节点树:</div>

    <div id="zTree" class="ztree"></div>
</div>

<div class="ztree_box_intu" style="width: 75%;">
    <input type="button" class="btn btn-default" style="margin: 10px 10px; float: left" value="分发、收割策略增加" id="addDistributeBtn"/>

    <div id="addDistributeDiadog" title="分发、收割策略增加">
        <g:form name="addDistribute" controller="programMgr" action="saveDistributePolicy">
            <input type="hidden" id="serverNodeId" name="serverNodeId"/>
            <table class="table ">
                <tr>
                    <td height="30" class="trewidth">最新</td>
                    <td><input type="text" style="width: 40px; height: 26px;" name="latest" value="0" size="2"/>条</td>
                </tr>
                <tr>
                    <td height="30" class="trewidth">最热</td>
                    <td><input type="text" style="width: 40px; height: 26px;" name="hot" value="0" size="2"/>条</td>
                </tr>
                <tr>
                    <td height="30" class="trewidth">发送原始文件</td>
                    <td><input type="radio" name="isSendObject" value="true" checked/>是<input type="radio"
                                                                                              name="isSendObject"
                                                                                              value="false"/>否</td>
                </tr>
                <tr>
                    <td height="30" class="trewidth">发送策略</td>
                    <td><input type="radio" name="toGrade" value="3"/>发送到下级<input type="radio" name="toGrade" value="4"
                                                                                  checked/>发送到联盟</td>
                </tr>
                <tr>
                    <th height="30" class="trewidth" style="width: 80px; height: 36px; padding: 5px;">类库</th>
                    <td>
                        <select name="directory">
                            <option value="-1">----无----</option>
                            <g:each in="${directoryList}" var="directory">
                                <option value="${directory?.id}">${directory?.name}</option>
                            </g:each>
                        </select>
                    </td>
                </tr>
            </table>
        </g:form>
    </div>

    <div class="zTree_local_infor">
        <table class="table"  width="600">

            <tr>
                <th>节点名</th>
                <th>最新</th>
                <th>最热</th>
                <th>发送原始文件</th>
                <th width="80">发送策略</th>
                <th width="80">发送到类库</th>
                <th width="100">操作</th>
            </tr>

            <tbody>
            <g:each in="${distributePolicyList}" var="policy">
                <tr>
                    <td>${policy?.serverNodes[0]?.name}</td>
                    <td>${policy?.latest}条</td>
                    <td>${policy?.hot}条</td>
                    <td>${policy?.isSendObject==false?'否':'是'}</td>
                    <td>${policy?.toGrade==3?'分发到下级':'分发到联盟'}</td>
                    <td>${policy?.directory!=null?policy?.directory?.name:'无'}</td>
                    <td>
                        <g:if test="${policy?.timePlan!=null}">
                            <a class="btn btn-link btn-xs" href="${createLink(controller: 'programMgr',action: 'editTimePlan',params: [id:policy?.id])}">编辑时间计划</a>
                        </g:if>

                        <a class="btn btn-link btn-xs" style="cursor: pointer" onclick="deletePolicy(${policy?.id})">删除</a>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>

        <g:paginate controller="programMgr" action="programDistributePolicy" total="${total}"></g:paginate>
    </div>
</div>
</body>
</html>