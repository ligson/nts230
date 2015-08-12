<%@ page import="nts.utils.CTools; nts.program.domain.ProgramTopic; nts.program.domain.Program" %>


<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <g:set var="entityName" value="${message(code: 'programTopic.label', default: 'nts.program.domain.ProgramTopic')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}" type=text/css
          rel=stylesheet>

</head>

<body>
<div class="x_daohang">
    <p>当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'programTopic', action: 'list')}">专题管理</a>>> 专题</p>
</div>

<div class="body">
    <h1>详细页面</h1>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <tr class="prop">
                <td valign="top" class="name"><g:message code="programTopic.name.label" default="名称"/>：</td>

                <td valign="top" class="value">${fieldValue(bean: programTopic, field: "name")}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:message code="programTopic.description.label" default="描述"/>：</td>

                <td valign="top" class="value">${fieldValue(bean: programTopic, field: "description")}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:message code="programTopic.consumer.label" default="创建者"/>：</td>

                <td valign="top" class="value">${programTopic?.consumer?.nickname?.encodeAsHTML()}</td>

            </tr>


            <tr class="prop">
                <td valign="top" class="name"><g:message code="programTopic.dateCreated.label" default="创建日期"/>：</td>

                <td valign="top" class="value"><g:formatDate format="yyyy-MM-dd HH:mm:ss"
                                                             date="${programTopic?.dateCreated}"/></td>

            </tr>


            <tr class="prop">
                <td valign="top" class="name"><g:message code="programTopic.state.label" default="状态"/>：</td>

                <td valign="top" class="value">${ProgramTopic.cnState[programTopic.state]}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:message code="programTopic.programs.label" default="资源列表"/>：</td>

                <td valign="top" style="text-align: left;" class="value">
                    <div style="margin-left:12px;margin-bottom:2px;">专题资源数：${CTools.nullToZero(programTopic?.programs?.size())}</div>
                    <table width="96%" border="0" align="center" cellpadding="0" cellspacing="1">
                        <tr>

                            <th align="center">${Program.cnField.name}</th>
                            <th align="center">${Program.cnField.actor}</th>
                            <th align="center">${Program.cnField.dateCreated}</th>
                        </tr>
                        <g:if test="${programTopic?.programs}">
                            <g:each in="${programTopic?.programs}" status="i" var="program">
                                <tr id="serial${program?.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                    <td><a href="${createLink(controller: 'appMgr', action: 'showProgram', params:[id: program?.id])}" style="font-weight:normal;"
                                           target="_blank">${program?.name.encodeAsHTML()}</a></td>
                                    <td>${program?.actor.encodeAsHTML()}</td>
                                    <td align="center"><g:formatDate format="yyyy-MM-dd"
                                                                     date="${program?.dateCreated}"/></td>
                                </tr>
                            </g:each>
                        </g:if>
                    </table>
                </td>

            </tr>

            </tbody>
        </table>
    </div>

    <div class="buttons">
        <g:form>
            <g:hiddenField name="id" value="${programTopic?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="editProgramTopic"
                                                 value="${message(code: 'default.button.edit.label', default: '编辑')}"/></span>
            <span class="button"><g:actionSubmit class="delete" action="deleteProgramTopic"
                                                 value="${message(code: 'default.button.delete.label', default: '删除')}"
                                                 onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: '确实要删除吗?')}');"/></span>
        </g:form>
    </div>
</div>
</body>
</html>
