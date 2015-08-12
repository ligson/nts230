<%@ page import="nts.utils.CTools" %>


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'userActivity.label', default: 'nts.activity.domain.UserActivity')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'userActivity.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="name" title="${message(code: 'userActivity.name.label', default: 'Name')}" />
                        
                            <g:sortableColumn property="shortName" title="${message(code: 'userActivity.shortName.label', default: 'Short Name')}" />
                        
                            <g:sortableColumn property="description" title="${message(code: 'userActivity.description.label', default: 'Description')}" />
                        
                            <g:sortableColumn property="startTime" title="${message(code: 'userActivity.startTime.label', default: 'Start Time')}" />
                        
                            <g:sortableColumn property="endTime" title="${message(code: 'userActivity.endTime.label', default: 'End Time')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${userActivityInstanceList}" status="i" var="userActivityInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${userActivityInstance.id}">${fieldValue(bean: userActivityInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: userActivityInstance, field: "name")}</td>
                        
                            <td>${fieldValue(bean: userActivityInstance, field: "shortName")}</td>
                        
                            <td>${CTools.htmlToBlank(fieldValue(bean: userActivityInstance, field: "description"))}</td>
                        
                            <td>${fieldValue(bean: userActivityInstance, field: "startTime")}</td>
                        
                            <td>${fieldValue(bean: userActivityInstance, field: "endTime")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${userActivityInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
