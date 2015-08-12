<%@ page import="nts.utils.CTools; nts.program.domain.Program" %>
<div id="searchMaterialProgramList"
     style="display:${(programList == null && CTools.nullToBlank(keyword) == "") ? "none" : "block"};margin:8px 0px 10px 0px;">
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="1">
        <tr>
            <th align="center">${Program.cnField.name}</th>
            <th align="center">${Program.cnField.actor}</th>
            <th align="center">操作</th>
        </tr>
        <g:if test="${programList}">
            <g:each in="${programList ?}" status="i" var="program">
                <tr id="serial${program?.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                    <td title="${program?.name}">${CTools.cutString(program?.name, 20)}</td>
                    <td title="${program?.actor}">${CTools.cutString(program?.actor, 15)}</td>
                    <td width="60" align="center">
                        <a href="#ZM"
                           onclick="${remoteFunction(action:'editMaterial',update:'editMaterial',onComplete:'editMaterial('+program?.id+')',params:'\'program.id='+program?.id+'\'')};">提取</a>
                    </td>
                </tr>
            </g:each>
        </g:if>
        <g:elseif test="${keyword}">
            <tr class="odd">
                <td colspan="3" align="center">没有搜索到满足条件的记录</td>
            </tr>
        </g:elseif>
    </table>

    <div class="paginateButtons"><g:paginateTemplate action="searchMaterialProgram" node="searchMaterialProgramList"
                                                     total="${total ? total : 0}" params="${params}"/></div>
</div>
