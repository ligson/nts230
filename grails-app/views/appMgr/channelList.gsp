

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <g:set var="entityName" value="${message(code: 'channel.label', default: 'nts.broadcast.domain.Channel')}" />
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
                        
                            <g:sortableColumn property="id" title="${message(code: 'channel.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="channelName" title="${message(code: 'channel.channelName.label', default: 'nts.broadcast.domain.Channel Name')}" />
                        
                            <g:sortableColumn property="bcastAddr" title="${message(code: 'channel.bcastAddr.label', default: 'Bcast Addr')}" />
                        
                            <g:sortableColumn property="dateCreated" title="${message(code: 'channel.dateCreated.label', default: 'Date Created')}" />
                        
                            <g:sortableColumn property="dateModified" title="${message(code: 'channel.dateModified.label', default: 'Date Modified')}" />
                        
                            <g:sortableColumn property="channelDesc" title="${message(code: 'channel.channelDesc.label', default: 'nts.broadcast.domain.Channel Desc')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${channelList}" status="i" var="channel">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${channel.id}">${fieldValue(bean: channel, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: channel, field: "channelName")}</td>
                        
                            <td>${fieldValue(bean: channel, field: "bcastAddr")}</td>
                        
                            <td><g:formatDate date="${channel.dateCreated}" /></td>
                        
                            <td><g:formatDate date="${channel.dateModified}" /></td>
                        
                            <td>${fieldValue(bean: channel, field: "channelDesc")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${channelTotal}" />
            </div>
        </div>
    </body>
</html>
