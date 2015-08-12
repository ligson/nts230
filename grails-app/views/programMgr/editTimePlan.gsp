<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-6-11
  Time: 下午4:13
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <r:require modules="jquery-ui"></r:require>
    <script type="text/javascript">
        $(function () {
            $("input[name=startTime]").datepicker();
            $("input[name=endTime]").datepicker();
        })
        function checkTimePlan() {
            var name = $("#addTimePlan input[name=name]").val();
            if (name == '') {
                alert("时间计划名称不能为空");
                return false;
            } else {
                return true;
            }

        }
    </script>
    <style type="text/css">
    .tablewidth {
        width: 90px;
        line-height: 26px;
    }
    </style>
</head>

<body>
${ flash.message }
<g:form controller="programMgr" name="addTimePlan" action="saveTimePlan" onsubmit="return checkTimePlan()">
    <input type="hidden" name="id" value="${timePlan?.id}"/>
    <table class="table" width="600">
        <tr>
            <td height="30" class="tablewidth">时间计划名称</td>
            <td><input class="form-control" style="width:200px; height: 26px;" name="name" value="${timePlan?.name}"/>
            </td>
        </tr>
        <tr>
            <td height="30" class="tablewidth">策略选择</td>
            <td>
                <select name="disId" style="width:200px; height: 150px; padding: 5px; line-height: 28px;" multiple="multiple" size="5">
                    <g:each in="${distributePolicyList}" var="policy">
                        <g:if test="${timePlan.distributePolicys.contains(policy)}">
                            <option value="${policy?.id}" selected>${policy?.serverNodes[0].name}</option>
                        </g:if>
                        <g:else>
                            <option value="${policy?.id}">${policy?.serverNodes[0].name}</option>
                        </g:else>

                    </g:each>
                </select>
            </td>
        </tr>
        <tr>
            <td height="30" class="tablewidth">时间计划</td>
            <td><input type="text" name="expression" value="${timePlan.expression}"></td>
        </tr>
        <tr>
            <td height="30" class="tablewidth">时间策略</td>
            <td><input name="category" value="0" type="radio" ${timePlan?.category == 0 ? 'checked' : ''}/>分发<input
                    name="category" value="1" type="radio" ${timePlan?.category == 1 ? 'checked' : ''}/>收割</td>
        </tr>
        <tr>
            <td height="30" class="tablewidth">是否启用</td>
            <td><input name="isActive" value="true" type="radio" ${timePlan?.isActive == true ? 'checked' : ''}/>是<input
                    name="isActive" value="false" type="radio" ${timePlan?.isActive == false ? 'checked' : ''}/>否</td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit" class="btn btn-primary" value="设置"/></td>
        </tr>
    </table>
</g:form>
</body>
</html>