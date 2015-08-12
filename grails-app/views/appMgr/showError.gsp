<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>纠错详细信息</title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" type=text/css
          rel=stylesheet>

</head>

<body>
<div id="programMgrMain">
    <div class="x_daohang">
        <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'errors', action: 'list')}">纠错管理</a>>> 错误
    </div>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <br>

    <div id="tblist">
        <TABLE width="100%"
               border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff">
            <tbody>
            <tr bgcolor="#FFFFFF">
                <td width="94" height="29" valign="top">纠错标题:</td>

                <td width="381" valign="top">${fieldValue(bean: errors, field: 'errorTitle')}</td>

            </tr>


            <tr bgcolor="#FFFFFF">
                <td height="29" valign="top">提交人:</td>

                <td valign="top">${fieldValue(bean: errors, field: 'publisher')}</td>

            </tr>

            <tr bgcolor="#FFFFFF">
                <td height="29" valign="top">提交时间:</td>
                <td valign="top"><g:formatDate format="yyyy-MM-dd" date="${errors.submitTime}"/></td>
            </tr>

            <tr bgcolor="#FFFFFF">
                <td height="29" valign="top">所在资源:</td>
                <td valign="top">
                    <g:if test="${program}">
                        <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: program.id])}"
                           target="_blank">${fieldValue(bean: program, field: 'name')}</a>
                    </g:if>
                </td>
            </tr>

            <tr bgcolor="#FFFFFF">
                <td height="93" valign="top">纠错内容:</td>
                <td valign="top">${fieldValue(bean: errors, field: 'errorContent')}</td>
            </tr>

            </tbody>
        </table>

        <g:form>
            <input type="hidden" name="id" value="${errors?.id}"/>
            <input type="hidden" name="offset" value="${params.offset}"/>
            <input type="hidden" name="sort" value="${params.sort}"/>
            <input type="hidden" name="order" value="${params.order}"/>
            <input type="hidden" name="searchTitle" value="${params.searchTitle}"/>
            <input type="hidden" name="searchContent" value="${params.searchContent}"/>
            <input type="hidden" name="searchPublisher" value="${params.searchPublisher}"/>
            <input type="hidden" name="searchDate" value="${params.searchDate}"/>
            <input type="hidden" name="searchState" value="${params.searchState}"/>

            <g:actionSubmit class="button" action="deleteErrors" onclick="return confirm('确定删除?');" value="删除"/>
            <g:actionSubmit class="button" action="errorList" value="返回"/>
        </g:form>
    </div>
</div>
</body>
</html>
