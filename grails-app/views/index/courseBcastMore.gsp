<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <link href="${resource(dir: 'css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/community/select2css.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/truevod.js')}"></script>
    <title>直播课堂列表</title>
    <style type="text/css">

    .explain {
        background: #f3f8fc url(../images/skin/blue21_next.gif) 8px 8px no-repeat;
        border: 1px solid #b2d1ff;
        color: #006dba;
        margin: 10px 0 5px 0;
        padding: 5px 5px 5px 30px
    }

    .STYLE5 {
        font-size: 14px
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

        function play(id) {
            var Url = baseUrl + "courseBcast/liveInfo?id=" + id;
            if (document.playWnd) {
                if (document.playWnd.closed == false)
                    document.playWnd.close();
            }

            document.playWnd = OpenWindowEx(Url, screen.height, screen.width, "频道信息");

        }
        function onPageNumPer(max) {
            document.form1.max.value = max;
            document.form1.offset.value = 0;
            document.form1.submit();
        }

        function init() {

            changePageImg(${params.max});
        }
        function courseBcastSearch() {
            form1.action = "courseBcastMore";
            form1.submit()
        }

        function detail(id) {
            var Url;
            Url = "showCourseBcast?id=" + id;
            if (document.InfoWndAdd) {
                if (document.InfoWndAdd.closed == false)
                    document.InfoWndAdd.close();
            }

            document.InfoWndAdd = OpenWindowEx(Url, 480, 480, "频道信息");
            return true;
        }
        function detail(id) {
            var Url;
            Url = "showCourseBcast?id=" + id;
            if (document.InfoWndAdd) {
                if (document.InfoWndAdd.closed == false)
                    document.InfoWndAdd.close();
            }

            document.InfoWndAdd = OpenWindowEx(Url, 480, 480, "频道信息");
            return true;
        }

        //window.onload = init;
    </script>

</head>

<body>
<div class="mainCon">
    <form method="post" name="form1" action="/index/courseBcastMore" id="form1">
        <input type="hidden" name="offset" value="${params.offset}"/>
        <input type="hidden" name="sort" value="${params.sort}"/>
        <input type="hidden" name="order" value="${params.order}"/>
        <input type="hidden" name="max" value="${params.max}"/>

        <div class="explain">直播课堂列表</div>

        <div class="tv">
            <table width="60%" border="0" style="margin-top:10px" cellpadding="0" cellspacing="0" bordercolor="#66ccff">
                <tr height="50px" style="font-size:16px">
                    <td width="5%" style="font-size:16px">&nbsp;&nbsp;&nbsp;&nbsp;频道:</td>
                    <td width="5%"><input type="text" class="newsinput1" name="channel" value=""
                                          style="font-size:16px"/></td>
                    <td width="5%" style="font-size:16px">&nbsp;&nbsp;&nbsp;&nbsp;主题:</td>
                    <td width="5%"><input type="text" class="newsinput1" name="title" value="" style="font-size:16px"/>
                    </td>
                    <td width="5%" style="font-size:16px">&nbsp;&nbsp;&nbsp;&nbsp;主讲:</td>
                    <td width="5%"><input type="text" class="newsinput1" name="author" value="" style="font-size:16px"/>
                    </td>
                    <td width="5%" style="font-size:16px">&nbsp;&nbsp;&nbsp;&nbsp;<a href="#"
                                                                                     onClick="courseBcastSearch()"><img
                                border="0" src="${resource(dir: 'images/skin', file: 'x_searchB.jpg')}"></a></td>
                </tr>
            </table>

            <div class="tv_title"></div>
            <table width="643px" border="1px" cellpadding="0" cellspacing="0" color="#d3d3d3">
                <tr style="text-align:center">
                    <td style="text-align:center" class="STYLE5">频道名称</td>
                    <td style="text-align:center" class="STYLE5">主题</td>
                    <td style="text-align:center" class="STYLE5">主讲</td>
                    <td style="text-align:center" class="STYLE5">开始时间</td>
                    <td style="text-align:center" class="STYLE5">频道介绍</td>
                    <td style="text-align:center" class="STYLE5">接收</td>
                </tr>
                <g:each in="${courseBcastList}" status="i" var="courseBcast">
                    <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                        <g:if test="${flash.message}">
                            <div class="message">${flash.message}</div>
                        </g:if>
                        <td align="center" class="STYLE5">${fieldValue(bean: courseBcast, field: 'channel')}</a></td>
                        <td align="center" class="STYLE5">${fieldValue(bean: courseBcast, field: 'title')}</td>
                        <td align="center" class="STYLE5">${fieldValue(bean: courseBcast, field: 'author')}</td>
                        <td style="text-align:center" class="STYLE5"><g:formatDate format="yyyy-MM-dd HH:mm:ss"
                                                                                   date="${courseBcast?.datePlayed}"/></td>
                        <td style="text-align:center" class="STYLE5"><a href="#"
                                                                        onclick="detail(${courseBcast?.id})">内容</a></td>
                        <td style="text-align:center" class="STYLE5"><a href="#" onclick="play(this.value);"
                                                                        onfocus="this.blur()"
                                                                        value="${courseBcast?.id}"><img
                                    src="${resource(dir: 'images/skin', file: 'play1.jpg')}" border="0"></a></td>
                    </tr>
                </g:each>
            </table>
        </div>
        <table width="80%" style="border: 0px;" height="16" border="0" cellpadding="1" cellspacing="1"
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
                <td align="right"><div class="paginateButtons"><g:paginate total="${total}" params="${params}"
                                                                           maxsteps="5"/></div></td>
            </tr>
        </table>
    </form>
</div>
</body>
</html>

