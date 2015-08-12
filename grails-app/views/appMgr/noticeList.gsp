

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <g:set var="entityName" value="${message(code: 'dvbforeNotice.label', default: 'nts.broadcast.domain.DvbforeNotice')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'dvbforeNotice.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="dvbTitle" title="${message(code: 'dvbforeNotice.dvbTitle.label', default: 'Dvb Title')}" />
                        
                            <g:sortableColumn property="dateCreated" title="${message(code: 'dvbforeNotice.dateCreated.label', default: 'Date Created')}" />
                        
                            <g:sortableColumn property="dateModified" title="${message(code: 'dvbforeNotice.dateModified.label', default: 'Date Modified')}" />
                        
                            <g:sortableColumn property="limitTime" title="${message(code: 'dvbforeNotice.limitTime.label', default: 'Limit Time')}" />
                        
                            <g:sortableColumn property="descriptions" title="${message(code: 'dvbforeNotice.descriptions.label', default: 'Descriptions')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${dvbforeNoticeList}" status="i" var="dvbforeNotice">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${dvbforeNotice.id}">${fieldValue(bean: dvbforeNotice, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: dvbforeNotice, field: "dvbTitle")}</td>
                        
                            <td><g:formatDate date="${dvbforeNotice.dateCreated}" /></td>
                        
                            <td><g:formatDate date="${dvbforeNotice.dateModified}" /></td>
                        
                            <td><g:formatDate date="${dvbforeNotice.limitTime}" /></td>
                        
                            <td>${fieldValue(bean: dvbforeNotice, field: "descriptions")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${dvbforeNoticeTotal}" />
            </div>
        </div>
    </body>
</html>
