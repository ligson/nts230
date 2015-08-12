<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />		
        <title>nts.program.domain.Program List</title>
    </head>
    <body>
        
		<div id="search" >
			<g:form action="searchProgram" method="get" name="search">
           标签：
		    <input type="hidden" name="elementId" value="-2">
		   <input name="keyword" value="${keyword}">&nbsp;<input type="image" style="width:83px;height:27px;border:0px;" align="absmiddle" src="${createLinkTo(dir:'images/skin',file:'ssuo.gif')}" border="0">
		   </g:form>
        </div>		
        <div class="body">				
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
			<g:render template="programList" model="[programList:programList]"/>
        </div>
    </body>
</html>
