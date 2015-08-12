<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>用户列表</title>

    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" type="text/css"
          rel=stylesheet>

    <style type="text/css" rel="stylesheet">
    </style>

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/prototype.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <script type="text/javascript">
        function toParent(id, name) {
            //window.parent.document.form1.receiverId.value += id+';' ;
            window.parent.document.form1.receiveName.value += name + ';';
        }
    </script>
</head>

<body>
<div class="qsx">
    <table cellpadding="0" cellspacing="0" border="0" width="580">
        <g:if test="${consumerList != null && consumerList.size() > 0}">
            <tr>
            <g:each in="${consumerList}" status="i" var="consumer">
                <g:if test="${i % 5 == 4}">
                    </tr>
                    <tr>
                </g:if>
                <g:else>
                    <td class="pl10 lh24 lh24">
                        <A class="gblue" href="javascript:void(0)"
                           onclick="toParent('${consumer.id}', '${consumer.name.encodeAsHTML()}')">&gt;&nbsp;${consumer.name.encodeAsHTML()}</A>
                    </td>
                </g:else>
            </g:each>
            </tr>
        </g:if>
        <g:else>
            <tr><td colspan="5" class="pl10 pr10 lh24">该院系下空……</td></tr>
        </g:else>
    </table>

    <div class="cl"></div>
    <g:if test="${consumerList != null && consumerList.size() > 0}">
        <table width="90%" style="border: 0px;" height="16" border="0" cellpadding="1" cellspacing="1"
               style="float:left">
            <tr>
                <td align="center">
                    <div class="paginateButtons">
                        <g:paginate controller="my" action="consumerList" total="${consumerTotal}" params="${params}"/>
                    </div>
                </td>
            </tr>
        </table>
    </g:if>
</div>
</body>
</html>
