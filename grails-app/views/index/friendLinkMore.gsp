<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>

    <title>外部资源列表</title>
    <style type="text/css">
    <!--
    .STYLE1 {
        color: #8B0D11;
        font-weight: bold;
        font-size: 12px;
    }

    .STYLE4 {
        font-family: "宋体";
        font-size: 12px;
    }

    .STYLE5 {
        font-size: 12px
    }

    .STYLE6 {
        color: #990000;
        font-weight: bold;
    }

    .STYLE8 {
        font-size: 12
    }

    .STYLE9 {
        color: #990000;
        font-weight: bold;
        font-size: 12px;
    }

    body {
        margin-top: 0px;
    }

    .newsinput1 {

        border: 1px solid #000000;
        font-family: "宋体";
        font-size: 12px;
        color: #000000 !important;
        letter-spacing: 1px;
        width: 100px;
    }

    .newsinput2 {
        height: 60px;
        border: 1px solid #000000;
        font-family: "宋体";
        font-size: 12px;
        color: #000000;
        letter-spacing: 1px;
    }

    -->
    </style>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>

</head>

<body>
<div class="mainCon">

    <form method="post" name="newsForm" id="newsForm">
        <input type="hidden" name="offset" value="${params.offset}"/>
        <input type="hidden" name="sort" value="${params.sort}"/>
        <input type="hidden" name="order" value="${params.order}"/>
        <input type="hidden" name="max" value="${params.max}"/>





        <table width="98%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
            <tr bgcolor="#BDEDFB">
                <td width="4%" height="28" align="center" class="STYLE5"><a href="#" onClick="orderBy('title')">外部资源</a>
                </td>

            </tr>
            <g:each in="${friendLinkList}" status="i" var="friendLink">
                <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                    <td height="23" align="left" nowrap="nowrap" class="STYLE5"><a
                            href="${fieldValue(bean: friendLink, field: 'url')}"
                            target="_blank">&nbsp;${fieldValue(bean: friendLink, field: 'name')}</a></td>

                </tr>
            </g:each>
        </table>

    </form>

    <div style="height:10px;"></div>

</div>
</body>
</html>

