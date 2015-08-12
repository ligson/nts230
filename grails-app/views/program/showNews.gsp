<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'zxm.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'editor/jquery/jquery-1.3.2.min.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'editor/xheditor.js')}"></script>
    <title>新闻公告</title>
    <style type="text/css">
    <!--
    body {
        margin-top: 0px;
    }

    -->
    </style>
</head>

<body>
<div align="center">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="267" align="left" valign="top" background="${resource(dir: 'images/skin', file: 'zyk_2_02.jpg')}"><img
                    src="${resource(dir: 'images/skin', file: 'zyk_2_01.jpg')}" width="267" height="123"></td>
            <td align="left" valign="top" background="${resource(dir: 'images/skin', file: 'zyk_2_02.jpg')}"><div align="right"><img
                    src="${resource(dir: 'images/skin', file: 'zyk_2_03.jpg')}" width="628" height="123"></div></td>
        </tr>
    </table>
    <table width="95%" style="border: 1px solid #ccc;">
        <tbody>
        <tr class="prop">
            <td height="26" colspan="2" valign="top" class="name"><div
                    align="center"><b>${fieldValue(bean: news, field: 'title')}</b></div></td>
        </tr>
        <tr>
            <td width="50%" height="26" align="right" valign="top"
                class="name">发布人:${fieldValue(bean: news, field: 'publisher')}&nbsp;&nbsp;</td>
            <td width="50%" align="left" valign="top" class="value">&nbsp;&nbsp;发布时间: <g:formatDate format="yyyy-MM-dd"
                                                                                                    date="${news.submitTime}"/></td>
        </tr>
        <tr>&nbsp;&nbsp;
            <td height="500" colspan="2" valign="top" class="TD1" align="left"
                style="word-wrap:break-word">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${news.content}</td>
        </tr>
        <tr class="prop">
            <td colspan="2" valign="top" class="name" align="center"><input type="button" class="save" value="关闭"
                                                                            onClick="window.close()"/></td>
        </tr>
        </tbody>
    </table>
</div>

<div class="buttons">
    <g:form>
        <span class="button"></span>
    </g:form>

</div>
</div>
</body>
</html>
