<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <!-- saved from url=(0048)http://www.supermap.com.cn/gb/solutions/emap.htm -->
    <title>订阅列表</title>

    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'myManagerProgram.css')}">
    %{--<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'truevod.js')}"></script>--}%
    <script language="javascript">
        function myTagAdd() {
            document.myTagForm.action = "subScriptionTag";
            document.myTagForm.submit();

        }
        function addHotTag(id) {
            document.myTagForm.action = "addHotTag?id=" + id;
            document.myTagForm.submit();
        }
    </script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_userspace_index.css')}">
</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">当前位置：我的订阅</a>
</div>

<div id="main-content">

    <div class="content-box-header">
        <ul class="content-box-tabs">
            <li><a href="${createLink(controller: 'my', action: 'myManageProgram')}">我的资源</a></li>
            <li><a href="${createLink(controller: 'my', action: 'myRecommendProgramList')}">我的推荐</a></li>
            <li><a href="${createLink(controller: 'my', action: 'myProgramList')}" class="default-tab current">我的订阅</a></li>
            <li><a href="${createLink(controller: 'my', action: 'myCollectProgramList')}">我的收藏</a></li>

        </ul>

        <div class="clear"></div>
    </div>

    <div class="content-box-content">
        <div class="tab-content default-tab">
            <form name="form1" id="form1" method="post">
                <input type="hidden" name="max" value="">
                <input type="hidden" name="offset" value="">
                <input type="hidden" name="sort" value="">
                <input type="hidden" name="order" value="">
                <input type="hidden" name="tag" value="">

                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th width="20" align="left"><input type="checkbox" id="selall" name="selall"/></th>
                        <th align="left">资源名称</th>
                        <th width="140" align="left">收藏时间</th>
                        <th width="100" align="left">主要责任者</th>
                        <th width="64" align="left">编辑者</th>
                        <th width="70" align="left">点播次数</th>
                        <th width="70" align="left">下载次数</th>
                        <th width="70" align="left">收藏次数</th>
                        <th width="120" align="left">操作</th>
                    </tr>
                    </thead>
                    <tbody>

                    <tr>
                        <td height="23" align="left" class="STYLE5"></td>
                        <td align="left"></a>
                        </td>
                        <td align="left"></td>
                        <td align="left"></td>
                        <td align="left"></td>
                        <td align="left"></td>
                        <td align="left"></td>
                        <td align="left"></td>
                        <td align="left"></td>
                    </tr>

                    </tbody>
                </table>

                <table class="table">
                    <tr>
                        <td align="left">
                            <a href="#" class="btn btn-default" style="font-size: 12px;" id="sel" name="selall">全选</a>

                            <input class="btn btn-default" type="button" value="删除所选订阅"/>
                        </td>

                    </tr>

                </table>

            </form>
        </div>
    </div>
</div>

<script Language="JavaScript" type="text/javascript">
    changePageImg(${params.max});
</script>
</body>
</html>

