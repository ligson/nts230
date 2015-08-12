<html>
<head>
    <!-- saved from url=(0048)http://www.supermap.com.cn/gb/solutions/emap.htm -->
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/time.js')}"></script>
    <title>工具列表</title>
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

    -->
    </style>
    <script LANGUAGE="javascript">

        function maxShow(max) {
            //调用setParams()对查询参数进行负值
            newsForm.max.value = max;
            newsForm.offset.value = 0;
            newsForm.action = "toolsMore";
            newsForm.submit();
        }

        function orderBy(sort) {
            //调用setParams()对查询参数进行负值
            newsForm.sort.value = sort;
            if (newsForm.order.value == "desc") {
                newsForm.order.value = "asc";
            }
            else {
                newsForm.order.value = "desc";
            }
            newsForm.action = "toolsMore";
            newsForm.submit();
        }
        function newsSearch() {
            newsForm.action = "newsMore";
            newsForm.submit()
        }

    </script>
</head>

<body>
<div class="mainCon" style="width:970px;text-align:center;margin:0 auto;">

    <form method="post" name="newsForm" id="newsForm">
        <input type="hidden" name="offset" value="${params.offset}"/>
        <input type="hidden" name="sort" value="${params.sort}"/>
        <input type="hidden" name="order" value="${params.order}"/>
        <input type="hidden" name="max" value="${params.max}"/>

        <table style="width:970px">
            <tr>
                <td>
                    <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                        <tr bgcolor="#BDEDFB">
                            <td width="60%" height="28" align="center" class="STYLE5"><a href="#"
                                                                                         onClick="orderBy('name')">工具名称</a>
                            </td>
                            <td width="10%" align="center" class="STYLE5"><a href="#"
                                                                             onClick="orderBy('consumer')">上传者</a></td>
                            <td width="10%" align="center" class="STYLE5"><a href="#"
                                                                             onClick="orderBy('consumer')">上传时间</a></td>
                        </tr>
                    <!--  '#ffffff' : '#e9e8e7'  -->
                        <g:each in="${toolsList}" status="i" var="tools">
                            <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                                <td height="23" align="left" nowrap="nowrap" class="STYLE5"><a
                                        href="${resource(dir: 'downdir', file: tools.dirName)}" class="link2">&nbsp;&nbsp;${tools.name}</a>
                                </td>
                                <td align="center" class="STYLE5">${tools.consumer}</td>
                                <td align="center" class="STYLE5"><g:formatDate format="yyyy-MM-dd"
                                                                                date="${tools.dateCreated}"/></td>
                            </tr>
                        </g:each>

                    </table>
                </td>
            </tr>
        </table>
        <TABLE width="100%" height="16" border=0 cellPadding=1 cellSpacing=1 bgcolor="#E9E8E7">
            <TBODY>
            <TR>
                <TD width="693" height="16" align="center"><div align="left">
                    <a href="#" onClick="maxShow(10)">
                        <IMG id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" width=19 height=16
                             border=0 class="STYLE8" title="每页显示10条">
                    </a>&nbsp;
                    <a href="#" onClick="maxShow(50)">
                        <IMG id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" width=20 height=15
                             border=0 class="STYLE8" title="每页显示50条">
                    </a>&nbsp;
                    <a href="#" onClick="maxShow(100)">
                        <IMG id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" width="27"
                             height="16" border=0 class="STYLE8" title="每页显示100条">
                    </a>
                    <a href="#" onClick="maxShow(200)">
                        <IMG id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" width="28"
                             height="16" border=0 class="STYLE8" title="每页显示200条">
                    </a>
                </div></TD>
                <TD width=11>&nbsp;</TD>
                <TD width="425" align=right><div class="STYLE8">
                    <g:paginate total="${total}" offset="${params.offset}" action="toolsMore"
                                params="${[offset: params.offset, sort: params.sort, order: params.order, max: params.max]}"/>&nbsp;&nbsp;
                </TD>
            </TR>
            </TBODY>
        </TABLE>
    </form>
    <script Language="JavaScript">
        changePageImg(${params.max});
    </script>
</form>
</div>
</body>
</html>