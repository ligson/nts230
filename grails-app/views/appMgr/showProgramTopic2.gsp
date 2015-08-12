<%@ page import="nts.utils.CTools; nts.program.domain.ProgramTopic; nts.program.domain.Program" %>


<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

    <g:set var="entityName" value="${message(code: 'programTopic.label', default: 'nts.program.domain.ProgramTopic')}" />
    <title><g:message code="default.show.label" args="[entityName]" /></title>
    %{--<link href="${resource(dir: 'skin/default/pc/css', file: 'uniform.default.css')}" rel="stylesheet"/>--}%
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_common.css')}"/>
    %{--<Link media="screen" href="${resource(dir:'css',file:'main.css')}" type=text/css rel=stylesheet>--}%
    <style type="text/css">

        /* DIALOG */
.dialog {
    margin: 0 0 20px 0;
    padding: 10px;

}
.body h1 { font-size: 16px; text-align: center; line-height: 22px;padding: 10px; font-weight: bold;border-bottom: 1px dotted #CBCBCB;}

    .dialog table {
        padding: 5px 0;
        width: 100%;
    }

.dialog table td {
    padding: 8px;
}

    .prop {
        padding: 5px;
    }
    .prop .name {
        text-align: right;
        white-space: nowrap;
        font-weight: bold;
        font-size: 14px;
    }
    .prop .value {
        text-align: left;
        font-size: 14px;
    }

    .x_daohang{margin:2px 2px 2px 20px;}
    .x_daohang a:link, .x_daohang a:visited{ color:#333 !important;font-weight:normal !important;margin-left:2px;margin-right:2px;text-decoration: none;}
    .x_daohang a:hover{color:blue !important;text-decoration: underline;}
    </style>
</head>
<body>
<div class="x_daohang" style="background:#FFF;width:100%;text-align:left;">
    %{--<p>当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'programTopic', action: 'list')}">专题管理</a>>> 专题</p>--}%
</div>
<div class="body" style="background:#FFF;width:100%;">
    <h1>详细页面</h1>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>



            <tr class="prop">
                <td valign="top" class="name"><g:message code="programTopic.name.label" default="名称" />：</td>

                <td valign="top" class="value">${fieldValue(bean: programTopic, field: "name")}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:message code="programTopic.description.label" default="描述" />：</td>

                <td valign="top" class="value">${fieldValue(bean: programTopic, field: "description")}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:message code="programTopic.consumer.label" default="创建者" />：</td>

                <td valign="top" class="value">${programTopic?.consumer?.nickname?.encodeAsHTML()}</td>

            </tr>


            <tr class="prop">
                <td valign="top" class="name"><g:message code="programTopic.dateCreated.label" default="创建日期" />：</td>

                <td valign="top" class="value"><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${programTopic?.dateCreated}" /></td>

            </tr>


            <tr class="prop">
                <td valign="top" class="name"><g:message code="programTopic.state.label" default="状态" />：</td>

                <td valign="top" class="value">${ProgramTopic.cnState[programTopic.state]}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:message code="programTopic.programs.label" default="资源列表" />：</td>

                <td valign="top" style="text-align: left;" class="value">
                    <div style="padding:0 10px 20px 10px; margin-bottom:20px;border-bottom: 5px solid #CBCBCB;">专题资源数：${CTools.nullToZero(programTopic?.programs?.size())}</div>
                    <table width="96%"  border="1"  align="center" cellpadding="0" cellspacing="1">
                        <tr style="height: 30px; font-size: 14px; font-weight: bold">

                            <th  align="center">${Program.cnField.name}</th>
                            <th align="center">${Program.cnField.actor}</th>
                            <th align="center">${Program.cnField.dateCreated}</th>
                        </tr>
                        <g:if test="${programTopic?.programs}">
                            <g:each in="${programTopic?.programs}" status="i" var="program">
                                <tr id="serial${program?.id}" class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                    <td><a href="${createLink(controller: 'appMgr', action: 'showProgram', params:[id: program?.id])}" style="font-weight:normal;" target="_blank">${program?.name.encodeAsHTML()}</td>
                                    <td>${program?.actor.encodeAsHTML()}</td>
                                    <td align="center"><g:formatDate format="yyyy-MM-dd" date="${program?.dateCreated}"/></td>
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
            <g:hiddenField name="id" value="${programTopic?.id}" />
            %{--<span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: '编辑')}" /></span>--}%
            <span class="button" ><g:actionSubmit class="delete btn btn-primary"   style="width: 50px; height: 30px; margin-bottom: 10px;" action="delete" value="${message(code: 'default.button.delete.label', default: '删除')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: '确实要删除吗?')}');" /></span>
        </g:form>
    </div>
</div>
</body>
</html>
