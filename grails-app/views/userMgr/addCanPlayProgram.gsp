<%@ page import="nts.program.domain.Program; nts.utils.CTools" %>
<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午4:22
  To change this template use File | Settings | File Templates.
--%>

<html>
<head>
    <title>资源列表</title>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}"
          media="all">
    <!--jqGrid-->
    <r:require modules="jqGrid"/>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/userMgr', file: 'selectCategoryDialog.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/userMgr', file: 'programList.js')}"></script>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'manager_resource_list.css')}"/>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_index_main.css')}">
</head>

<body>
<div id="searchToolBar" class="admin_content_nav">
    <div class="admin_nav_title">
        <span>资源名称:</span>
        <label><input class="admin_default_inp admin_default_inp_size1" type="text" name="name"></label>
        <span>分类：</span>
        <label><input class="admin_default_inp admin_default_inp_size1" type="text" name="categoryName" id="categoryName" readonly></label>
        <label>
            <input class="admin_default_but_yellow" type="button" value="搜索" id="searchBtn">
        </label>
    </div>
    <input type="hidden" name="categoryId" id="categoryId">
</div>
<table id="programGrid"></table>

<div id="GridPaper"></div>

<div class="admin_default_but_box">
    <input class="admin_default_but_blue" title="为用户组添加可点播资源"
           onclick="operate('userMgr', 'playProgramAdd', '${groupId}');"
           type="button"
           value="添加"/>
    <input class="admin_default_but_blue" title="返回"
           onclick="javascript:location.href=baseUrl + 'userMgr/userGroupList?editPage=${editPage}';"
           type="button"
           value="返回"/>

</div>


<div id="selectCategoryDialog" class="bg" style="display:none;" title="选择分类">
    <div>
        <input type="hidden" id="selectedCategoryId" value=""/>
        <input type="hidden" id="selectedCategoryName" value="" />
        <table>
            <tr>
                <td>
                    选择的分类：
                </td>
                <td>
                    <div id="categoryNameDiv" style="height:15px;line-height:15px;text-align: center;"><span>未选择</span></div>
                </td>
            </tr>
        </table>
    </div>

    <div id="zTree" class="ztree">
    </div>
</div>
</body>
</html>