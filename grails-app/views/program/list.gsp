<%@ page import="nts.program.domain.Program" %>


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="programMgrMain" />
        <title>nts.program.domain.Program List</title>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/allselect.js')}"></script>
    </head>
    <body>
        <div class="nav">
           <span class="menuButton"><g:link class="list" action="list" params="[state:0]">未审批${Program.cnTableName}列表</g:link></span>
		   <span class="menuButton"><g:link class="list" action="list" params="[state:1]">已审批${Program.cnTableName}列表</g:link></span>
           <span class="menuButton"><g:link class="create" action="create">添加${Program.cnTableName}</g:link></span>
        </div>
        <div class="body">
		<g:form method="post" action="delete" >
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table id="listTab">
                    <thead>
                        <tr>
                        
                   			<td style="width:30px;" class="sortable">选择</td>                       
                   	        <g:sortableColumn style="width: 80px" property="name" title="${Program.cnField.name}"/>                     
							<g:sortableColumn property="actor" title="${Program.cnField.actor}" />
							<g:sortableColumn style="width: 60px" property="dateCreated" title="${Program.cnField.dateCreated}" />                  	       
							<td style="width:30px;" class="sortable">修改</td> 
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${programList}" status="i" var="program">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
							<td><g:checkBox name="idList" value="${program.id}" checked="" onclick="unCheckAll('selall');" /></td>
                            <td><g:link action="show" id="${program.id}">${fieldValue(bean:program, field:'name')}</g:link></td>                                            
                            <td>${fieldValue(bean:program, field:'actor')}</td>
			                <td><g:formatDate format="yyyy-MM-dd" date="${program?.dateCreated}"/></td>
							<td><g:link action="edit" id="${program.id}">修改</g:link></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
			<div class="operation"><input  id="selall" name="selall" onclick="checkAll(this,'idList')" type="checkbox">全选&nbsp;<input  type="submit" value="删除所选" /></div>
            <div class="paginateButtons">
                <g:paginate total="${total}" params="${params}" />
            </div>
		</g:form>
        </div>
		
    </body>
</html>
