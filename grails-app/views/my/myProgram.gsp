<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />		
        <title>nts.program.domain.Program List</title>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/userspace/updateTemplate.js')}"></script>
    </head>
    <body>

	<table border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
		 <td class="viewLeftTD">
			<div class="myLeft" id="myLeft">
				<ul>
				<li><a href="">我的信息</a></li>
				<li><g:link controller="program" action="myProgram" params="[type:3]">我制作n的</g:link></li>
				<li><g:link controller="program" action="myProgram" params="[type:0]">我收藏的</g:link></li>
				<li><g:link controller="program" action="myProgram" params="[type:1]">我点播过的</g:link></li>
				<li><g:link controller="program" action="myProgram" params="[type:2]">我浏览过的</g:link></li>
				</ul>
			</div>
		</td>
		 <td class="viewRightTD">
			
			<div class="body">
				<g:if test="${flash.message}">
				<div class="message">${flash.message}</div>
				</g:if>
				<g:render template="programList" model="[programList:programList]"/>
			</div>
		  </td>
		 </tr>
      </table>
        
    </body>
</html>
