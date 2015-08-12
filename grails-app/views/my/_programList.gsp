<%@ page import="nts.utils.CTools; nts.program.domain.Program" %>
<div id="programList">
 <g:each in="${programList?}" status="i" var="program">
	<table width="96%"  border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
		  <td width="140"  rowspan="8" valign="middle" style="">			
			<g:link action="showProgram" id="${program?.id}" target="blank"><img src="${posterLink(serials:program?.serials)}" style="border:1px solid #ccc;padding:4px;" width="120" height="90"></g:link>			
		  </td>
		</tr>
		<tr>
		  <td><g:link action="directoryView" params="[directoryId:program?.directory?.id]">[${program?.directory?.name.encodeAsHTML()}]</g:link>&nbsp;<g:link action="showProgram" id="${program?.id}" target="_blank">${program.name.encodeAsHTML()}</g:link></td>
		</tr>
		<tr>
		  <td><font class="key">${Program.cnField.actor}：</font>${program?.actor.encodeAsHTML()}</td>
		</tr>
		<tr>
		  <td>&nbsp;&nbsp;&nbsp;&nbsp;
			${CTools.cutString(program?.description.encodeAsHTML(),60)}
		  </td>
		</tr>
		<tr>
		  <td><font class="key">${Program.cnField.consumer}：</font><a href="">${program?.consumer?.name.encodeAsHTML()}</a>&nbsp;<font class="key">时间：</font><g:formatDate format="yyyy-MM-dd" date="${program?.dateCreated}"/>&nbsp;<font class="key">播放：</font>${program?.frequency}</td>
		</tr>
		<tr>
		  <td height="1"></td>
		</tr>
	</table>
	<div style="position:relative;height:8px;margin-top:6px;" valign="center"><div class="line"></div></div>
 </g:each>
 <g:if test="${total > 0}">
 <div class="paginateButtons">${Program.cnTableName}数：${total}&nbsp;&nbsp;&nbsp;页码：
	<g:if test="${paginateTemplate}">
		<g:paginateTemplate node="${node?node:actionName}" total="${total}" params="${params}" />
	</g:if>
	<g:else>
		<g:paginate total="${total}" params="${params}" />
	</g:else>
 </div>
</g:if>
<g:else>
 <div class="noProg">${Program.cnTableName}数：0</div>
</g:else>
</div>
