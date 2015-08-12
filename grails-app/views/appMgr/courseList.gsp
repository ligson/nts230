

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <g:set var="entityName" value="${message(code: 'courseBcast.label', default: 'nts.broadcast.domain.CourseBcast')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'courseBcast.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="notes" title="${message(code: 'courseBcast.notes.label', default: 'Notes')}" />
                        
                            <g:sortableColumn property="multcastIP" title="${message(code: 'courseBcast.multcastIP.label', default: 'Multcast IP')}" />
                        
                            <g:sortableColumn property="mediaSource" title="${message(code: 'courseBcast.mediaSource.label', default: 'Media Source')}" />
                        
                            <g:sortableColumn property="screenSource" title="${message(code: 'courseBcast.screenSource.label', default: 'Screen Source')}" />
                        
                            <g:sortableColumn property="mediaPushIP" title="${message(code: 'courseBcast.mediaPushIP.label', default: 'Media Push IP')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${courseBcastList}" status="i" var="courseBcast">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${courseBcast.id}">${fieldValue(bean: courseBcast, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: courseBcast, field: "notes")}</td>
                        
                            <td>${fieldValue(bean: courseBcast, field: "multcastIP")}</td>
                        
                            <td>${fieldValue(bean: courseBcast, field: "mediaSource")}</td>
                        
                            <td>${fieldValue(bean: courseBcast, field: "screenSource")}</td>
                        
                            <td>${fieldValue(bean: courseBcast, field: "mediaPushIP")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${courseBcastTotal}" />
            </div>
        </div>
    </body>
</html>
