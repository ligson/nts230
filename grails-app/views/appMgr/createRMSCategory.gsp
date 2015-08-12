<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title></title>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'zxm.css')}" rel="stylesheet" type="text/css">
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
</head>

<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a>
    </span>
    <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label"
                                                                           args="[entityName]"/></g:link></span>
</div>

<div class="body">
    <h1><g:message code="default.create.label" args="[entityName]"/></h1>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${RMSCategoryInstance}">
        <div class="errors">
            <g:renderErrors bean="${RMSCategoryInstance}" as="list"/>
        </div>
    </g:hasErrors>
    <g:form action="save">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="name"><g:message code="RMSCategory.name.label" default="Name"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: RMSCategoryInstance, field: 'name', 'errors')}">
                        <g:textField name="name" maxlength="50" value="${RMSCategoryInstance?.name}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="parentid"><g:message code="RMSCategory.parentid.label" default="Parentid"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: RMSCategoryInstance, field: 'parentid', 'errors')}">
                        <g:textField name="parentid"
                                     value="${fieldValue(bean: RMSCategoryInstance, field: 'parentid')}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="type"><g:message code="RMSCategory.type.label" default="Type"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: RMSCategoryInstance, field: 'type', 'errors')}">
                        <g:textField name="type" value="${fieldValue(bean: RMSCategoryInstance, field: 'type')}"/>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>

        <div class="buttons">
            <span class="button"><g:submitButton name="create" class="save"
                                                 value="${message(code: 'default.button.create.label', default: 'Create')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
