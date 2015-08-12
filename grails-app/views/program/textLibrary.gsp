<%@ page import="nts.program.domain.Serial; nts.program.domain.Program" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="index"/>
    <title><g:message code="application.name" default="确然多媒体资源应用系统"/></title>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'wk.css')}"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/flexpaper_flash.js')}"></script>

</head>

<body>
<!------------------文库内容开始-------------------------->
<div class="main" style="margin-bottom:10px;width:970px;">
    <div class="position">
        <p><span style="font-weight: bold;">当前位置：</span><a
                href="${createLink(controller: 'index', action: 'index')}">首页</a>&nbsp;&gt;&nbsp;<span>文库</span></p>
    </div>

    <div class="hr4"></div>

    <div class="mconl left" style="width:663px;">
        <div id="libDiv" style="height:100%;">
            <a id="viewerPlaceHolder" style=""></a>
            <script type="text/javascript">
                var hash = ['${serial?.fileHash}'];
                $.post(baseUrl + "webMethod/proxy2", {url: '${playUrl}', data: "hash=" + hash}, function (data) {
                    if (data.success) {
                        //alert(data.playList[0].url);
                        startFlexPaer(data.playList[0].url);
                    }
                }, "json");

                function startFlexPaer(swfUrl) {
                    var fp = new FlexPaperViewer(
                                    baseUrl + 'images/FlexPaperViewer',
                            'viewerPlaceHolder', { config: {
                                SwfFile: swfUrl,
                                Scale: 0.6, //初始化缩放比例，参数值应该是大于零的整数
                                ZoomTransition: 'easeOut', //Flexpaper中缩放样式，它使用和Tweener一样的样式，默认参数值为easeOut.其他可选值包括: easenone, easeout, linear, easeoutquad
                                ZoomTime: 0.5, //从一个缩放比例变为另外一个缩放比例需要花费的时间，该参数值应该为0或更大。
                                ZoomInterval: 0.2, //缩放比例之间间隔，默认值为0.1，该值为正数。
                                FitPageOnLoad: true, //初始化得时候自适应页面，与使用工具栏上的适应页面按钮同样的效果。
                                FitWidthOnLoad: true, //初始化的时候自适应页面宽度，与工具栏上的适应宽度按钮同样的效果。
                                FullScreenAsMaxWindow: false, //当设置为true的时候，单击全屏按钮会打开一个flexpaper最大化的新窗口而不是全屏，当由于flash播放器因为安全而禁止全屏，而使用flexpaper作为独立的flash播放器的时候设置为true是个优先选择。
                                ProgressiveLoading: true, //当设置为true的时候，展示文档时不会加载完整个文档，而是逐步加载，但是需要将文档转化为9以上的flash版本（使用pdf2swf的时候使用-T 9 标签）。
                                MinZoomSize: 0.2, //最小的缩放比例。
                                MaxZoomSize: 5, //设置最大的缩放比例。
                                SearchMatchAll: true, //设置为true的时候，单击搜索所有符合条件的地方高亮显示。
                                InitViewMode: 'Portrait', //设置启动模式如"Portrait" or "TwoPage".
                                ViewModeToolsVisible: true, //工具栏上是否显示样式选择框。
                                ZoomToolsVisible: true, //工具栏上是否显示缩放工具。
                                NavToolsVisible: true, //工具栏上是否显示导航工具。
                                CursorToolsVisible: true, //工具栏上是否显示光标工具。
                                SearchToolsVisible: true, //工具栏上是否显示搜索。
                                localeChain: 'zh_CN', //设置地区语言
                                StartAtPage: 1 //返回参数startPage，表示默认从第几页开始显示
                            }});
                }

            </script>
        </div>

    </div>

    <div class="mconr left">
        <dl class="zyxx">
            <dt>资源信息</dt>
            <dd>
                <table border="0" cellpadding="" cellspacing="0">
                    <tr valign="top">
                        <td width="100">${Program.cnField["name"]}：</td><td
                            style="word-break:break-all;">${fieldValue(bean: program, field: 'name')}</td>
                    </tr>
                    <tr valign="top">
                        <td>${Program.cnField["actor"]}：</td><td>${fieldValue(bean: program, field: 'actor')}</td>
                    </tr>
                    <tr valign="top">
                        <td>${Program.cnField["director"]}：</td><td>${fieldValue(bean: program, field: 'director')}</td>
                    </tr>
                    <tr valign="top">
                        <td>${Program.cnField["frequency"]}：</td><td>${fieldValue(bean: program, field: 'frequency')}</td>
                    </tr>
                    <tr valign="top">
                        <td>${Program.cnField["downloadNum"]}：</td><td>${fieldValue(bean: program, field: 'downloadNum')}</td>
                    </tr>

                    <tr valign="top">
                        <td>${Program.cnField["recommendNum"]}：</td><td>${fieldValue(bean: program, field: 'recommendNum')}</td>
                    </tr>

                    <tr valign="top">
                        <td>${Program.cnField["dateCreated"]}：</td><td><g:formatDate format="yyyy-MM-dd"
                                                                                     date="${program.dateCreated}"/></td>
                    </tr>

                    <tr valign="top">
                        <td>${Program.cnField.programTags}：</td><td><g:each in="${program?.programTags}" status="i"
                                                                            var="tag">
                        <g:link action="linkView"
                                params="[type: 2, keyword: tag.id, cnName: tag?.name]">${tag?.name?.encodeAsHTML()}</g:link>
                    </g:each></td>
                    </tr>

                    <tr valign="bottom" height="30">
                        <td colspan="2" style="padding:0 0 2px 2px;">
                            <a href="${downUrl}" class="button1"><img
                                    src="${resource(dir: 'images/skin', file: 'down3.gif')}" border="0" alt="下载"></a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <g:if test="${program.serials.size() > 0}">
                                <span style="width:100%;height:25px;background-color:#E0DFE3;display:block;">&nbsp;&nbsp;资源列表</span>
                                <ul style="width:90%;height:100px;overflow:auto;line-height:20px;margin-left: 0;">
                                    <g:each in="${program.serials}" var="serial">
                                        <g:if test="${serial.urlType == Serial.URL_TYPE_DOCUMENT}">
                                            <li><a href="${createLink(controller: 'program', action: 'textLibrary', params: [programId: program.id, serialId: serial.id])}">${serial.name}</a>
                                            </li>
                                        </g:if>
                                    </g:each>
                                </ul>
                                <br/>
                            </g:if>

                        </td>
                    </tr>
                </table>

            </dd>
        </dl></div>
</div>
<!------------------文库内容结束-------------------------->

</body>

</html>