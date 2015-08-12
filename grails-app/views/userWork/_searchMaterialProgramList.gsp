<%@ page import="nts.utils.CTools; nts.program.domain.Program" %>
<div id="searchMaterialProgramList" style="display:${(programList == null && CTools.nullToBlank(keyword) == '')?'none':'block'};margin:8px 0px 10px 0px;">
	<g:if test="${flash.message}">
	<div class="message">${flash.message}</div>
	</g:if>
	<table style="width:90%;margin-left:12px;line-height:10px;" border="0" cellpadding="0" cellspacing="1">	
	<tr>
		<th align="center" style="line-height:10px;height:10px;">${Program.cnField.name}</td>
		<th align="center" style="line-height:10px;height:10px;">${Program.cnField.actor}</td>
		<th align="center" style="line-height:10px;height:10px;">操作</td>
	</tr>
	<g:if test="${programList}">
		<g:each in="${programList?}" status="i" var="program">
		<tr id="serial${program?.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
		  <td style="line-height:10px;height:10px;" title="${fieldValue(bean:program, field:'name')}">${CTools.cutString(fieldValue(bean:program, field:'name'),20)}</td>
		  <td style="line-height:10px;height:10px;">${program?.actor}</td>
		  <td style="line-height:10px;height:10px;" width="60" align="center">		
		  <a href="#ZM" onclick="${remoteFunction(action:'editMaterial',update:'editMaterial',onComplete:'editMaterial('+program?.id+')',params:'\'program.id='+program?.id+'\'')};" >提取</a>
		  </td>
		</tr>
		</g:each>
	</g:if>
	<g:elseif test="${keyword}">
		<tr class="odd">
		  <td style="line-height:10px;height:10px;" colspan="3" align="center">没有搜索到满足条件的记录</td>
		</tr>
	</g:elseif>
	</table> 
	<div class="jumpB clear">
		<div class="xb_pages" align="center" style="height: 40px;">
		  	 <g:guiPaginateTemplate action="searchMaterialProgram" node="searchMaterialProgramList" total="${total?total:0}" params="${params}" />
		</div>
	</div>
</div>