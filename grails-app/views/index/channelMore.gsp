<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <link href="${createLinkTo(dir: 'skin/blue/pc/admin/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/truevod.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/admin/Base64.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <title>网络电视列表</title>
    <style type="text/css">

    .explain {
        background: #f3f8fc url(../images/skin/blue21_next.gif) 8px 8px no-repeat;
        border: 1px solid #b2d1ff;
        color: #006dba;
        margin: 10px 0 5px 0;
        padding: 5px 5px 5px 30px
    }

    .STYLE5 {
        font-size: 12px
    }

    body {
        margin-top: 0px;
    }

    .tv {
        width: 643px;
        float: left;
        margin: 6px 0px 6px 130px !important;
        margin: 6px 0px 6px 10px;
        overflow: hidden;
    }

    .tv_title {
        width: 643px;
        height: 30px;
        float: center;
        background: url(/images/skin/x_caseTitleT.png) no-repeat left top;
    }

    </style>


    <script LANGUAGE="javascript">


        function onPageNumPer(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;
            document.form1.submit();
        }


        function showDesc(desc) {
            alert(desc)
            if (desc == null) {
                return false
            }
            return true
        }
        function init() {
            changePageImg(${params.max});
        }
        window.onload = init;
    </script>

</head>

<body>
<div class="mainCon">

    <form method="post" name="form1" action="/index/channelMore" id="form1">
        <input type="hidden" name="offset" value="${params.offset}"/>
        <input type="hidden" name="sort" value="${params.sort}"/>
        <input type="hidden" name="order" value="${params.order}"/>
        <input type="hidden" name="max" value="${params.max}"/>

        <div class="explain">网络电视列表
        </div>


        <div class="tv">
            <div class="tv_title"></div>
            <table border="1px" width="643px" color="#d3d3d3" style="border-collapse:collapse">
                <tr>
                    <td align="center" class="STYLE5" width="15%" height="40px"
                        style="text-align:center;font-size:14px">频道图标</td>
                    <td align="center" class="STYLE5" width="15%" height="20px"
                        style="text-align:center;font-size:14px">频道查看</td>
                    <td align="center" class="STYLE5" width="15%" height="20px"
                        style="text-align:center;font-size:14px">频道接收</td>
                    <td align="center" class="STYLE5" width="15%" height="20px"
                        style="text-align:center;font-size:14px">频道名称</td>
                    <td align="center" class="STYLE5" width="15%" height="20px"
                        style="text-align:center;font-size:14px">频道类别</td>
                    <td align="center" class="STYLE5" width="40%" height="20px"
                        style="text-align:center;font-size:14px">频道介绍</td>
                </tr>
                <g:each in="${channelList}" status="i" var="channel">
                    <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#F3F8FC'}">
                        <td align="center" class="STYLE5" style="padding:0 0 0 20px"><img
                                src="${resource(dir: 'images/skin', file: 'index_46.gif')}" border="0"/></td>
                        <g:if test="${flash.message}">
                            <div class="message">${flash.message}</div>
                        </g:if>
                        <td align="center" class="STYLE5" width="15%"><a href="showChannel?id=${channel?.id}"
                                                                         onfocus="this.blur()" target="_blank"><img
                                    src="${resource(dir: 'images/skin', file: 'look.gif')}" border="0"/></a></td>
                        <td align="center" class="STYLE5" width="15%"><a
                                href="javascript:NetPlay('${channel.channelName.encodeAsJavaScript()}','${channel.bcastAddr.encodeAsJavaScript()}');"
                                onfocus="this.blur()"><img src="${resource(dir: 'images/skin', file: 'incept.gif')}"/></a></td>
                        <td align="center" class="STYLE5"
                            width="15%">&nbsp;${fieldValue(bean: channel, field: 'channelName')}</td>
                        <g:if test="${channel.bcastType == 0}">
                            <td align="center" class="STYLE5" width="15%" style="text-align:center">直播</td>
                        </g:if>
                        <g:elseif test="${channel.bcastType == 1}">
                            <td align="center" class="STYLE5" width="15%" style="text-align:center">广播</td>
                        </g:elseif>
                        <g:else>
                            <td align="center" class="STYLE5" width="15%" style="text-align:center">转播</td>
                        </g:else>
                        <td align="center" class="STYLE5" width="40%"><br/>
                            <g:if test="${channel.channelDesc}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${channel.channelDesc}</g:if>
                            <g:else>
                                <p style="color:#ff0000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;暂无频道介绍</p>
                            </g:else></td>
                    </tr>
                </g:each>
            </table>
        </div>
        <table width="90%" style="border: 0px;" height="16" border="0" cellpadding="1" cellspacing="1"
               bgcolor="#E9E8E7">
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
                <td align="right"><div class="paginateButtons"><g:paginate controller="index" action="channelMore"
                                                                           total="${total}" params="${params}"/></div>
                </td>
            </tr>
        </table>
    </form>
</div>
</body>
</html>

