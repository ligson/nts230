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

    <script type="text/javascript" src="${createLinkTo(dir: 'js/jquery/jquery-ui-1.10.3/js', file: 'jquery.ui.core.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js/jquery/jquery-ui-1.10.3/js', file: 'jquery.ui.widget.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js/jquery/jquery-ui-1.10.3/js', file: 'jquery.ui.progressbar.js')}"></script>
    <link href="${createLinkTo(dir: 'js/jquery/jquery-ui-1.10.3/css/ui-lightness', file: 'jquery-ui-1.10.3.custom.css')}" rel="stylesheet" type="text/css">

    <script type="text/javascript">
        $(function(){
            $("#progressbar").progressbar(
                    {
                        value:60
                    }
            );
        })
    </script>

    <style type="text/css">
    .progressbar{height:8px;}
    </style>
</head>

<body>

<DIV class="programMgrMain" >
    <form name="form1" >
        <input type="hidden" name="max">
        <input type="hidden" name="offset" >
        <input type="hidden" name="sort" >
        <input type="hidden" name="order" >
        <div class="x_daohang">
            <p style="font-size:12px" >当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'appMgr', action: 'transcodeStatstic')}">转码管理</a>>>某某资源转码列表</p>
        </div>
        <br>

        <div id="tblist">
            <table width="100%"
                   border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff" id="progListTab">
                <thead>
                <tr class="th">

                    <td align="center" width="33">选择</td>
                    <th width="628" align="center" class="sortable"><a href="">名称</a></th>
                    <th width="104" align="center" class="sortable sorted asc" style="font-weight:normal;"><a href="">状态</a></th>
                    <th width="391" align="center" class="sortable" style="font-weight:normal;"><a href="">进度</a></th>
                </tr>
                </thead>
                <tr class="even" >
                    <td align="center"><input   type="checkbox"></td>
                    <td align="center"><a href="">马航：飞机失联超30小时 请家属做好心理准备</a></td>
                    <td align="center">已完成</td>
                    <td align="center"><div id="progressbar" class="progressbar"></div></td>
                </tr>
                <tr >
                    <td align="center"><input  type="checkbox"></td>
                    <td align="center"><a href="">马航：飞机失联超30小时 请家属做好心理准备</a></td>
                    <td align="center">未完成</td>
                    <td align="center"></td>
                </tr>
                <tr class="even" >
                    <td align="center"><input    type="checkbox"></td>
                    <td align="center"><a href="">马航：飞机失联超30小时 请家属做好心理准备</a></td>
                    <td align="center">已完成</td>
                    <td align="center"></td>
                </tr>
                <tr >
                    <td align="center"><input    type="checkbox"></td>
                    <td align="center"><a href="">马航：飞机失联超30小时 请家属做好心理准备</a></td>
                    <td align="center">已完成</td>
                    <td align="center"></td>
                </tr>
            </table>

            <table width="100%"
                   border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff" >
                <tr>
                    <td><input  id="selall"  name="selall"  type="checkbox">
                        &nbsp;全选&nbsp;
                        <input class="button"  type="button" value="删除所选"  />
                        &nbsp;
                        <input  type="button"  class="button"  value="删除全部"  />
                    </td>
                </tr>
            </table>

            <table width="100%"
                   border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff">
                <tr>
                    <td height="16">&nbsp;总共：22条记录</td>
                </tr>
            </table>
        </div>
    </form>
</DIV>


</body>
</html>