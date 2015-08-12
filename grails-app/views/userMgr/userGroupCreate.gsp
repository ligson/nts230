<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="userMgrMain"/>
    <title>创建用户组</title>
</head>

<body>
<div>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${userGroup}">
        <div class="errors">
            <g:renderErrors bean="${userGroup}" as="list"/>
        </div>
    </g:hasErrors>
    <g:form controller="userMgr" action="saveUserGroup" method="post">
        <div class="dialog" id="consumer_list">
            <table>
                <tbody>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="name">用户组名称:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: userGroupInstance, field: 'name', 'errors')}">
                        <input type="text" maxlength="40" id="name" name="name"
                               value="${fieldValue(bean: userGroupInstance, field: 'name')}"/>
                    </td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="description">用户组描述:</label>
                    </td>
                    <td valign="top"
                        class="value ${hasErrors(bean: userGroupInstance, field: 'description', 'errors')}">
                        <input type="text" maxlength="250" id="description" name="description"
                               value="${fieldValue(bean: userGroupInstance, field: 'description')}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="active">用户组状态:</label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: userGroupInstance, field: 'active', 'errors')}">
                        停用 <g:radio name="active" value="0"/>
                        启用 <g:radio name="active" value="1" checked="true"/>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>

        <div class="buttons">
            <span class="button"><input class="save" action="create" type="submit" value="创建"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
