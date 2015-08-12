<%@ page import="nts.system.domain.Directory; nts.program.domain.Program; nts.utils.CTools" %>
<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午4:22
  To change this template use File | Settings | File Templates.
--%>

<html xmlns="http://www.w3.org/1999/html">
<head>
    <title>资源列表</title>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}"
          media="all">
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>

    <!--[if lte IE 6]>
  <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style-ie6.css')}" type=text/css rel=stylesheet>
  <![endif]-->


    <!--jqGrid-->
    <r:require modules="jqGrid"/>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/selectCategoryDialog2.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/programMgr', file: 'index.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'dropdown.js')}"></script>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'manager_resource_list.css')}"/>
    %{--<link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">--}%
</head>

<body>
<div id="searchToolBar">
    <div class="search-ToolBar">
        <div class="admin_content_nav">
            <div class="admin_nav_title fix_admin_tit">
                <span>资源名称：</span>
                <label><input class="admin_default_inp admin_default_inp_size2" type="text" name="name"
                              style="max-width: 150px"
                              style="font-size: 12px; height: 30px; line-height: 30px">
                </label>
                <span>元数据标准：</span>
                <label>
                    <g:select class="admin_default_inp admin_default_inp_size2" name="directoryId"
                              style="max-width: 80px"
                              from="${(Directory.list() +
                                      [id  : "-1",
                                       name: "全部"]
                              )}" optionKey="id" optionValue="name"
                              value="-1"/>
                </label>

                <span>类别：</span>
                <label>
                    <g:select class="admin_default_inp admin_default_inp_size2" name="otherOption"
                              style="max-width: 80px"
                              from="${["-1": "全部", 0: "视频", 1: '音频', 16: "图片", 8: "文档", 128: "课程", 6: "flash动画"]}"
                              optionKey="key"
                              optionValue="value"
                              value="${params.otherOption}"/>
                </label>

                <span>转码状态：</span>
                <label>
                    <g:select class="admin_default_inp admin_default_inp_size2" name="transcodeState"
                              style="max-width: 80px"
                              from="${["-1": "全部", 1: "正在转码", 2: "转码成功", 3: "转码失败"]}" optionKey="key"
                              optionValue="value"
                              value="${params.transcodeState}"/>
                </label>
            </div>
        </div>

        <div class="admin_content_nav">
            <div class="admin_nav_title fix_admin_tit">
                <span>状态：</span>
                <label>
                    <g:select class="admin_default_inp admin_default_inp_size2" style="max-width: 80px" name="state"
                              from="${["-1": "全部"] + Program.cnState}"
                              optionKey="key" optionValue="value"/>
                </label>
                <span>下载：</span>
                <label>
                    %{--<g:select class="admin_default_inp admin_default_inp_size2" name="canDownload" style="max-width: 80px"--}%
                    %{--from="${["-1": "全部", 0: "禁止下载", 1: "允许下载", 2: "禁止所有组或用户下载", 3: "允许所有组或用户下载"]}" optionKey="key"--}%
                    %{--optionValue="value"--}%
                    %{--value="${params.canDownload}"/>--}%
                    <g:select class="admin_default_inp admin_default_inp_size2" name="canDownload"
                              style="max-width: 80px"
                              from="${["-1": "全部", 0: "禁止下载", 1: "允许下载", 2: "禁止所有用户组下载", 3: "允许所有用户组下载"]}"
                              optionKey="key"
                              optionValue="value"
                              value="${params.canDownload}"/>
                </label>
                <span>点播：</span>
                <label>
                    %{--<g:select class="admin_default_inp admin_default_inp_size2" name="canPlay" style="max-width: 80px"--}%
                    %{--from="${["-1": "全部", 0: "禁止点播", 1: "允许点播", 2: "禁止所有组或用户点播", 3: "允许所有组或用户点播"]}" optionKey="key"--}%
                    %{--optionValue="value"--}%
                    %{--value="${params.canPlay}"/>--}%
                    <g:select class="admin_default_inp admin_default_inp_size2" name="canPlay" style="max-width: 80px"
                              from="${["-1": "全部", 0: "禁止点播", 1: "允许点播", 2: "禁止所有用户组点播", 3: "允许所有用户组点播"]}"
                              optionKey="key"
                              optionValue="value"
                              value="${params.canPlay}"/>
                </label>
                <span>公开：</span>
                <label>
                    <g:select class="admin_default_inp admin_default_inp_size2" name="canPublic" style="max-width: 80px"
                              from="${["-1": "全部", 0: "否", 1: "是"]}" optionKey="key"
                              optionValue="value"
                              value="${params.canPublic}"/>
                </label>
                <label style="width: 50px;">
                    <input class="admin_default_but_yellow" type="button" value="搜索" id="searchBtn">
                </label>
            </div>
        </div>
    </div>
</div>

<div class="admin_recommend">
    <div class="searchTool_up_res">
        <a class="admin_default_but_yellow ser_a" style="color: #FFF" href="javascript:void(0);"
           onclick="moreSyncBtn()">同步资源</a>
        <g:if test="${userResourceView(controllerName: 'programMgr', actionName: 'programCreate') == 'true'}">
            <a class="admin_default_but_yellow ser_a" style="color: #FFF"
               href="${createLink(controller: 'programMgr', action: 'programCreate')}">上传资源</a>
        </g:if>
    </div>

    <div class="btn-group rec_mr">
        <button type="button" class="btn  btn-default  dropdown-toggle rec_wid"
                style="font-size: 12px; padding: 5px 10px;" data-toggle="dropdown">
            资源状态设置<span class="caret" style="margin-left:5px"></span>
        </button>
        <ul class="dropdown-menu" role="menu">
            <li>
                <a href="javascript:void(0);" class="rec_mr_inp"
                   onclick=" operate('programMgr', 'programStateSet', 'apply');"/>申请入库</a>
            </li>
            <li>
                <a href="javascript:void(0);" class="rec_mr_inp"
                   onclick=" operate('programMgr', 'programStateSet', 'pass');"/>审批通过</a>
            </li>
            <li>
                <a href="javascript:void(0);" class="rec_mr_inp res_dieer"
                   onclick="operate('programMgr', 'programStateSet', 'noPass');">审批退回</a></li>
            <li>
                <a href="javascript:void(0);" class="rec_mr_inp"
                   onclick="operate('programMgr', 'programStateSet', 'public');">发布</a>
            </li>

            <li>
                <a href="javascript:void(0);" class="rec_mr_inp res_dieer"
                   onclick="operate('programMgr', 'programStateSet', 'close');">取消发布</a></li>
            <li>
                <a href="javascript:void(0);" class="rec_mr_inp"
                   onclick="changePublics('programMgr', 'changePublicStata', 'changePublic');">公开</a>
            </li>
            <li>
                <a href="javascript:void(0);" class="rec_mr_inp"
                   onclick="changePublics('programMgr', 'changePublicStata', 'changeNotPublic');">不公开</a>
            </li>

        </ul>
    </div>
    <!----点播权限--->
    <div class="btn-group rec_mr">
        <button type="button" class="btn  btn-default  dropdown-toggle rec_wid"
                style="font-size: 12px; padding: 5px 10px;" data-toggle="dropdown">
            点播权限设置<span class="caret" style="margin-left:5px"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="javascript:void(0);" class="rec_mr_inp"
                   onclick="operate2('programMgr', 'programCanOperationSet', 'canPlay', '1');">允许点播</a></li>
            <li><a href="javascript:void(0);" class="rec_mr_inp  res_dieer"
                   onclick="operate2('programMgr', 'programCanOperationSet', 'canPlay', '0');">禁止点播</a></li>
            %{--<li><a href="javascript:void(0);" class="rec_mr_inp res_dieer"--}%
            %{--onclick="operate2('programMgr', 'programCanOperationSet', 'canPlay', '0');">禁止点播</a></li>--}%
            <li><a href="javascript:void(0);" class="rec_mr_inp"
                   onclick="operate2('programMgr', 'programCanOperationSet', 'canAllPlay', '1');">允许所有用户组点播</a></li>
            <li><a href="javascript:void(0);" class="rec_mr_inp"
                   onclick="operate2('programMgr', 'programCanOperationSet', 'canAllPlay', '0');">禁止所有用户组点播</a></li>
        </ul>
    </div>
    <!----下载权限--->
    <div class="btn-group rec_mr">
        <button type="button" class="btn  btn-default  dropdown-toggle rec_wid"
                style="font-size: 12px; padding: 5px 10px;" data-toggle="dropdown">
            下载权限设置<span class="caret" style="margin-left:5px"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="javascript:void(0);" class="rec_mr_inp"
                   onclick="operate2('programMgr', 'programCanOperationSet', 'canDownload', '1');">允许下载</a></li>
            <li><a href="javascript:void(0);" class="rec_mr_inp res_dieer"
                   onclick="operate2('programMgr', 'programCanOperationSet', 'canDownload', '0');">禁止下载</a></li>
            %{--<li><a href="javascript:void(0);" class="rec_mr_inp res_dieer res_dieer"--}%
            %{--onclick="operate2('programMgr', 'programCanOperationSet', 'canDownload', '0');">禁止下载</a></li>--}%
            <li><a href="javascript:void(0);" class="rec_mr_inp"
                   onclick="operate2('programMgr', 'programCanOperationSet', 'canAllDownload', '1');">允许所有用户组下载</a>
            </li>
            <li><a href="javascript:void(0);" class="rec_mr_inp"
                   onclick="operate2('programMgr', 'programCanOperationSet', 'canAllDownload', '0');">禁止所有用户组下载</a>
            </li>
        </ul>
    </div>
    <!----更多操作--->
    <div class="btn-group rec_mr">
        <button type="button" class="btn  btn-default dropdown-toggle rec_wid"
                style="font-size: 12px; padding: 5px 10px;" data-toggle="dropdown">
            更多设置<span class="caret" style="margin-left:5px"></span>
        </button>
        <ul class="dropdown-menu">
            <li><a href="javascript:void(0);" class="rec_mr_inp res_dieer"
                   onclick="operate('programMgr', 'userGroupList', 'userRight');">设置访问组</a></li>
            <li><a href="javascript:void(0);" class="rec_mr_inp" id="selectCategoryBtn">设置分类</a></li>
        </ul>
    </div>

    <div class="btn-group rec_mr" onclick="moreDelBtn()">
        <button type="button" class="btn  btn-default dropdown-toggle rec_wid"
                style="font-size: 12px; padding: 5px 10px;">
            批量删除
        </button>
    </div>
    <div class="btn-group rec_mr" onclick="syncProgramBtn()">
        <button type="button" class="btn  btn-default dropdown-toggle rec_wid"
                style="font-size: 12px; padding: 5px 10px;">
            搜索同步
        </button>
    </div>
</div>
<table id="programGrid"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">

    %{--<input class="admin_default_but_blue" title="只通过待审批的资源。"
           onclick=" operate('programMgr', 'programStateSet', 'pass');"
           type="button"
           value="审批通过"/>
    <input class="admin_default_but_blue" title="只退回待审批的资源。"
           onclick="operate('programMgr', 'programStateSet', 'noPass');"
           type="button"
           value="审批退回"/>
    <input class="admin_default_but_blue" title="只发布已入库的资源。"
           onclick="operate('programMgr', 'programStateSet', 'public');"
           type="button"
           value="发布"/>
    <input class="admin_default_but_blue" title="只取消已发布的资源。"
           onclick="operate('programMgr', 'programStateSet', 'close');"
           type="button"
           value="取消发布"/>
    <input class="admin_default_but_blue" title="公开资源。"
           onclick="changePublics('programMgr', 'changePublicStata', 'changePublic');"
           type="button"
           value="公开"/>
    <input class="admin_default_but_blue" title="不公开资源。"
           onclick="changePublics('programMgr', 'changePublicStata', 'changeNotPublic');"
           type="button"
           value="不公开"/>


    <input class="admin_default_but_blue" title="设置能访问资源的用户组"
           onclick="operate('programMgr', 'userGroupList', 'userRight');"
           type="button" value="设置访问组"/>
    <input class="admin_default_but_blue" title="设置能访问资源的用户组" type="button" value="设置分类" id="selectCategoryBtn"/>


    <input class="admin_default_but_blue" title="设置资源允许点播"
           onclick="operate2('programMgr', 'programCanOperationSet', 'canPlay', '1');"
           type="button"
           value="允许点播"/>
    <input class="admin_default_but_blue" title="设置资源禁止点播"
           onclick="operate2('programMgr', 'programCanOperationSet', 'canPlay', '0');"
           type="button"
           value="禁止点播"/>
    <input class="admin_default_but_blue" title="设置资源允许所有组或用户点播"
           onclick="operate2('programMgr', 'programCanOperationSet', 'canAllPlay', '1');"
           type="button"
           value="允许所有组或用户点播"/>
    <input class="admin_default_but_blue" title="设置资源禁止所有组或用户点播"
           onclick="operate2('programMgr', 'programCanOperationSet', 'canAllPlay', '0');"
           type="button"
           value="禁止所有组或用户点播"/>






    <input class="admin_default_but_blue" title="设置资源允许下载"
           onclick="operate2('programMgr', 'programCanOperationSet', 'canDownload', '1');"
           type="button"
           value="允许下载"/>
    <input class="admin_default_but_blue" title="设置资源禁止下载"
           onclick="operate2('programMgr', 'programCanOperationSet', 'canDownload', '0');"
           type="button"
           value="禁止下载"/>
    <input class="admin_default_but_blue" title="设置资源允许所有组或用户下载"
           onclick="operate2('programMgr', 'programCanOperationSet', 'canAllDownload', '1');"
           type="button"
           value="允许所有组或用户下载"/>
    <input class="admin_default_but_blue" title="设置资源禁止所有组或用户下载"
           onclick="operate2('programMgr', 'programCanOperationSet', 'canAllDownload', '0');"
           type="button"
           value="禁止所有组或用户下载"/>--}%
</div>


<div id="selectCategoryDialog" class="bg" style="display:none;" title="选择分类">
    <div>
        <input type="hidden" id="selectedCategoryId" value=""/>
        <input type="hidden" id="selectedCategoryName" value=""/>
        <table>
            <tr>
                <td>
                    选择的分类：
                </td>
                <td>
                    <div id="categoryNameDiv" style="height:15px;line-height:15px;text-align: center;"><span>未选择</span>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <div id="zTree" class="ztree">
    </div>
</div>

</body>
</html>