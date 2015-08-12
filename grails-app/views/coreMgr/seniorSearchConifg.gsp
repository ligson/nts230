<%--
  Created by IntelliJ IDEA.
  User: boful
  Date: 14-12-2
  Time: 下午1:22
--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>高级搜索配置</title>

    <script Language="JavaScript" type="text/javascript">
        function seniorSearchConfigSet() {
            var configForm = document.getElementById("configForm");
            if (configForm.solrProgramUrl.value == "") {
                alert("资源搜索地址不能为空!");
                configForm.solrProgramUrl.focus();
                return false;
            }
            if (configForm.solrSerialUrl.value == "") {
                alert("子资源搜索地址不能为空!");
                configForm.solrSerialUrl.focus();
                return false;
            }
            if (configForm.cronExpression.value == "") {
                alert("数据同步表达式不能为空!");
                configForm.cronExpression.focus();
                return false;
            }
            configForm.action = "seniorSearchConfigSet";
            configForm.submit();
        }
    </script>
    <style type="text/css">
    tr {
        border-top: 1px solid #F4F4F4
    }
    </style>
</head>

<body>
<g:uploadForm name="configForm" action="" enctype="multipart/form-data">

    <div style="overflow-y:scroll; overflow-x:hidden;height:480px;width:100%;">
        <table width="99%">
            <tr>
                <td><div id="tblist2">
                    <table width="99%" border="0" cellpadding="0" cellspacing="1" bgcolor="#e8e8e8">
                        <tr>
                            <th width="15%" align="center" style="height: 50px">属性名称</th>
                            <th width="38%" align="center">属性值</th>
                            <th align="middle">说明</th>
                        </tr>
                        <tr>
                            <td style="height: 50px">资源搜索地址</td>
                            <td><input type="text" class="admin_default_inp" maxlength="200" name="solrProgramUrl"
                                       value="${solrProgramUrl}" size="60"/>
                            </td>
                            <td class="tips">(资源搜索地址)</td>
                        </tr>
                        <tr>
                            <td style="height: 50px">子资源搜索地址</td>
                            <td><input type="text" class="admin_default_inp" maxlength="200" name="solrSerialUrl"
                                       value="${solrSerialUrl}" size="60"/>
                            </td>
                            <td class="tips">(子资源搜索地址)</td>
                        </tr>
                        <tr>
                            <td style="height: 50px">数据同步表达式</td>
                            <td><input type="text" class="admin_default_inp" maxlength="200" name="cronExpression"
                                       value="${cronExpression}"
                                       size="30"/></td>
                            <td class="tips">(数据同步表达式,默认为0 0 0 * * ?)</td>
                        </tr>
                        <tr>
                            <td height="35" colspan="3" align="center"><input class="admin_default_but_blue"
                                                                              type="button" value=" 设置 "
                                                                              onclick="seniorSearchConfigSet()"/>
                            </td>
                        </tr>
                    </table>
                </div></td>
            </tr>
        </table>
    </div>
</g:uploadForm>
</body>
</html>