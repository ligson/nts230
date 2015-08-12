<%@ page import="nts.utils.CTools" %>


<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>

    <title>节目预告</title>
    <style type="text/css">
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

    .td14 {
        background-color: #FFFFFF;
        height: 30px;
        line-height: 20px;
    }

    .tt002 {
        font: 12px;
        color: #1A496C;
        font-weight: bold;
    }
    </style>
    <script LANGUAGE="javascript">


        function onPageNumPer(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;
            document.form1.submit();
        }

        function init() {

            changePageImg(${CTools.nullToOne(params.max)});

        }

        window.onload = init;
    </script>

</head>

<body>
<div align="center">
    <form method="post" name="form1" action="/index/showChannel" id="form1">
        <input type="hidden" name="offset" value="${params.offset}"/>
        <input type="hidden" name="sort" value="${params.sort}"/>
        <input type="hidden" name="order" value="${params.order}"/>
        <input type="hidden" name="max" value="${params.max}"/>
        <input type="hidden" name="id" value="${params.id}"/>
        <table width="595" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="4"><img src="${resource(dir: 'images/skin', file: 'index_70.gif')}" height="28"></td>
                <td width="350" background="${resource(dir: 'images/skin', file: 'index_71.gif')}">　</td>
                <td width="241"><img src="${resource(dir: 'images/skin', file: 'index_72.gif')}" height="28"></td>
            </tr>

        </table>
</div>
<table width="595" border="1" align="center" cellspacing="3" style="border-collapse:collapse" bordercolor="#7C8BA7">
    <tr>
        <td bgcolor="#FFFFFF">
            <table width="100%" border="1" cellpadding="1" cellspacing="1" style="border-collapse:collapse">
                <tr>
                    <td height="25" colspan="2" align="center" bgcolor="#CFE1F7"
                        class="tt002">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <b align="center">${fieldValue(bean: channel, field: 'channelName')}节目预告</b>
                    </td>
                </tr>

                <tr style="font-weight: bold">
                    <td width="69%" align="center" bgcolor="#D9EBFD" style="text-align:center;font-size:14px"
                        height="22">节目名称</td>
                    <td width="31%" align="center" bgcolor="#D9EBFD" style="text-align:center;font-size:14px"
                        height="20">开播时间</td>
                </tr>

                <g:each in="${dvbforeNoticeList}" status="i" var="dvbforeNotice">
                    <tr>
                        <td height="20" bgcolor="#ECF5FE"><img src="${resource(dir: 'images/skin', file: 'index_200.gif')}" width="5"
                                                               height="5">&nbsp;${fieldValue(bean: dvbforeNotice, field: 'dvbTitle')}
                        </td>
                        <td align="center" bgcolor="#ECF5FE" style="text-align:center">&nbsp;<g:formatDate
                                format="yyyy-MM-dd HH:mm:ss" date="${dvbforeNotice?.datePlayed}"/></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="padding:4px;" class="td14"><strong>节目介绍</strong>：
                            <g:if test="${dvbforeNotice.descriptions}">${fieldValue(bean: dvbforeNotice, field: 'descriptions')}</g:if>
                            <g:else>
                                <p style="color:#ff0000">本频道暂无节目预告</p>
                            </g:else>
                        </td>
                    </tr>
                </g:each>
            </table>
        </td>
    </tr>
</table>
<table width="595" align="center" style="border: 0px;" style="border-collapse:collapse" height="16" border="0"
       cellpadding="0" cellspacing="0" bgcolor="#E9E8E7">
    <tr>
        <td height="16" align="center">
            &nbsp;&nbsp;&nbsp;&nbsp;总共：${total}个资源&nbsp;&nbsp;
            <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                 onclick="onPageNumPer(10)">&nbsp;
            <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0"
                 onclick="onPageNumPer(50)">&nbsp;
            <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0"
                 onclick="onPageNumPer(100)">&nbsp;
            <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0"
                 onclick="onPageNumPer(200)">&nbsp;
        </td>

        <td align="right"><div class="paginateButtons"><g:paginate controller="index" action="showChannel"
                                                                   total="${total}" params="${params}"/></div></td>
    </tr>
</table>
</form>







<table width="100" border="0" align="center" cellpadding="0" cellspacing="3">
    <tr>
        <td align="center"><img src="${resource(dir: 'images/skin', file: 'closebtn.gif')}" width="50" style="cursor:pointer"
                                onclick="window.close();" height="18"></td>
    </tr>
</table>
</body>
</html>
