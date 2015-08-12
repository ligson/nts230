<%@ page import="nts.program.domain.Program" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />		
        <title>Program List</title>
    </head>
    <body>
        
		<div id="search" >
			<g:form action="searchProgram" method="get" name="search">
           ${Program.cnTableName}搜索：
		   标签
		   <input type="hidden" name="elementId" value="-1">
		   <input type="text" name="keyword" value="">&nbsp;<input type="image" style="width:83px;height:27px;border:0px;" align="absmiddle" src="${createLinkTo(dir:'images/skin',file:'ssuo.gif')}" border="0">
		   </g:form>
        </div>

        <div class="body">
			<table class="tbo" id="tbo" cellSpacing="0" style="border: 0px solid #f60;" cellPadding="0" width="600" border="0" id="table7">
				<tr>
					<td vAlign="bottom">
					<div class="bTD_L"></div>
					</td>
					<td class="bTB" style="text-align:center" width="147">最热100签</td>
					<td vAlign="bottom"><div class="bTD_R"></div></td>
				</tr>
				<tr>
					<td class="bTD" colSpan="3" style="padding-top:20px;">
					<div align="center">
						<table class="tbi" cellSpacing="0" cellPadding="0" border="0">
						<g:programTagLinks programTagList="${hotTagList}" />
						</table>
					</div>
					
					</td>
				</tr>
			</table>
			<br>
			<table class="tbo" id="tbo" cellSpacing="0" style="border: 0px solid #f60;" cellPadding="0" width="600" border="0" id="table7">
				<tr>
					<td vAlign="bottom">
					<div class="bTD_L"></div>
					</td>
					<td class="bTB" style="text-align:center" width="147">最新100签</td>
					<td vAlign="bottom"><div class="bTD_R"></div></td>
				</tr>
				<tr>
					<td class="bTD" colSpan="3" style="padding-top:20px;">
					<div align="center">
						<table class="tbi" cellSpacing="0" cellPadding="0" border="0">
						<g:programTagLinks programTagList="${lastTagList}" />
						</table>
					</div>
					
					</td>
				</tr>
			</table>
			<br>
        </div>
    </body>
</html>
