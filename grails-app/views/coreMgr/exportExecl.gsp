<%@ page contentType="application/msexcel; charset=UTF-8" %>
<%@ page import="nts.system.domain.OperationEnum" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>   
        <title>Execl</title>
    </head>
    <body>
    <%
    response.setHeader("Content-disposition","attachment; filename=Excel.xls");
    %>
            <div class="list" id="consumer_list">
                <table border="1">
                    <thead>
                        <tr>
                   	        <td>操作表名</td>
				<td>操作表ID</td>
                   	        <td>操作人</td>
				<td>操作人ID</td>
                   	        <td>操作模块</td>
				<td>操作类型</td>
				<td>操作时间</td>
				<td>备注</td>
                        </tr>
                    <tbody>
                    <g:each in="${execlList}" status="i" var="execl">
                        <tr>
                            <td>${fieldValue(bean:execl, field:'tableName')} </td>
			    <td>${fieldValue(bean:execl, field:'tableId')} </td>
                            <td>${fieldValue(bean:execl, field:'operator')}</td>
			    <td>${fieldValue(bean:execl, field:'operatorId')}</td>
                            <td>${fieldValue(bean:execl, field:'modelName')}</td>
			    <td >${OperationEnum.cnType[execl.operation.id]}</td>
			    <td><g:formatDate format="yyyy-MM-dd hh:mm:ss" date="${execl.dateCreated}"/></td>
                            <td>${fieldValue(bean:execl, field:'brief')}</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
        </div>
    </body>
</html>
