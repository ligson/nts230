<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-3-8
  Time: 下午8:26
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>转码列表</title>

    <script type="text/javascript">
        $(function () {
            $("#progressbar").progressbar(
                    {
                        value: 60
                    }
            );
        });
    </script>

    <style type="text/css">
    .progressbar {
        height: 8px;
    }
    </style>
</head>

<body>
<div class="x_daohang">
    <p style="font-size:12px">当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a
            href="${createLink(controller: 'appMgr', action: 'transcodeStatstic')}">转码管理</a>>>转码列表</p>
</div>
<DIV class="programMgrMain">
    <form name="form1">
        <input type="hidden" name="max">
        <input type="hidden" name="offset">
        <input type="hidden" name="sort">
        <input type="hidden" name="order">

        <div class="tbsearch" style="margin:10px 0 10px 5px; ">
            <table cellSpacing=3 cellPadding=3>
                <tr>
                    <td align="center"><input name="endDate" id="endDate" readonly type="text" class="newsinput1"
                                              value=""><input name="search" type="button" class="button" value="查询"/>
                    </td>
                </tr>
            </table>
        </div>

        <div id="tblist">
            <table width="98%"
                   border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff" id="progListTab">
                <thead>
                <tr class="th">

                    <td align="center" width="30">选择</td>
                    <th width="516" align="center" class="sortable"><a href="">名称</a></th>
                    <th width="137" align="center" class="sortable sorted asc" style="font-weight:normal;"><a
                            href="">状态</a></th>
                    <th width="346" align="center" class="sortable" style="font-weight:normal;"><a href="">进度</a></th>
                    <th width="150" align="center" class="sortable" style="font-weight:normal;"><a href="">操作</a></th>
                </tr>
                </thead>
                <tr class="even">
                    <td align="center"><input type="checkbox"></td>
                    <td align="center"><a href="">马航：飞机失联超30小时 请家属做好心理准备</a></td>
                    <td align="center">已完成</td>
                    <td align="center"><div id="progressbar" class="progressbar"></div></td>
                    <td align="center"><a href="/appMgr/transcodelistsubclass.gsp">查看</a></td>
                </tr>
                <tr>
                    <td align="center"><input type="checkbox"></td>
                    <td align="center"><a href="">马航：飞机失联超30小时 请家属做好心理准备</a></td>
                    <td align="center">未完成</td>
                    <td align="center"></td>
                    <td align="center"><a href="">查看</a></td>
                </tr>
                <tr class="even">
                    <td align="center"><input type="checkbox"></td>
                    <td align="center"><a href="">马航：飞机失联超30小时 请家属做好心理准备</a></td>
                    <td align="center">已完成</td>
                    <td align="center"></td>
                    <td align="center"><a href="">查看</a></td>
                </tr>
                <tr>
                    <td align="center"><input type="checkbox"></td>
                    <td align="center"><a href="">马航：飞机失联超30小时 请家属做好心理准备</a></td>
                    <td align="center">已完成</td>
                    <td align="center"></td>
                    <td align="center"><a href="">查看</a></td>
                </tr>
            </table>

            <table width="100%"
                   border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff">
                <tr>
                    <td><input id="selall" name="selall" type="checkbox">
                        &nbsp;全选&nbsp;
                        <input class="button" type="button" value="删除所选"/>
                        &nbsp;
                        <input type="button" class="button" value="删除全部"/>
                    </td>
                </tr>
            </table>

            <table width="100%"
                   border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff">
                <tr>
                    <td height="16">&nbsp;总共：22条记录|每页10条|每页显示: <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}"
                                                                    alt="每页显示10条" border="0"> <img id="Img50"
                                                                                                   src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}"
                                                                                                   alt="每页显示50条"
                                                                                                   border="0"> <img
                            id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0"> <img
                            id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0"
                            onClick="onPageNumPer(200)"></td>
                    <td align="right"><div class="paginateButtons"><span class="currentStep">1</span><a href="=10"
                                                                                                        class="step">2</a><a
                            href="=20" class="step">3</a><a href="=30" class="step">4</a><a href="=40"
                                                                                            class="step">5</a><a
                            href="=50" class="step">6</a><a href="=60" class="step">7</a><a href="=70"
                                                                                            class="step">8</a><a
                            href="=80" class="step">9</a><a href="=90" class="step">10</a><span class="step">..</span><a
                            href="=520" class="step">53</a><a href="=10" class="nextLink">下页</a>

                        <input name="turnPage" id="turnPage" type="text">
                        /53
                        <input name="turnPageBtn" id="turnPageBtn" value="转页" type="button">
                    </div></td>
                </tr>
            </table>
        </div>
    </form>
</DIV>

</body>
</html>