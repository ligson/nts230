<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-18
  Time: 上午10:32
--%>

<%@ page import="nts.program.category.domain.ProgramCategory" contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>分类管理</title>
    <r:require modules="jqGrid"/>
<link rel="stylesheet" type="text/css"  href="${resource(dir: 'skin/blue/pc/front/css', file: 'programCategoryMgr.css')}">
<link rel="stylesheet" type="text/css"  href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
<script type="text/javascript"  src="${resource(dir: 'js/boful/programMgr', file: 'categoryFactedMgr.js')}"></script>
</head>

<body>

<div class="tree_main">
    <div class="tree_left">
        <div id="zTree" class="ztree">
        </div>

    </div>

    <div class="tree_content">
        <input class="admin_default_but_green" type="button" value="添加分面" id="createCategoryFatcted" style="width: 100px">
        <div style="margin-top: 10px;">
            <table class="table" id="categoryFactedGrid"></table>
            <div id="GridPaper"></div>
        </div>
    </div>
</div>
<div id="createCategoryFatctedDialog" style="display:none;">
    <input type="hidden" value="" id="selectProgramCategoryId" name = "selectProgramCategoryId"/>
    <input type="hidden" value="" id="selectProgramCategoryName" name = "selectProgramCategoryName">
    <input type="hidden" value="" id="level" name = "level"/>
    <div class="ui-dialog-content ui-widget-content crea_win">
        <table>
            <tbody>
            <tr>
                <td width="80" align="center">分类名称</td>
                <td><label><input class="crea_inp" type="text" value="" name="categoryName" disabled/></label></td>
            </tr>
            <tr>
                <td align="center">分面名称</td>
                <td><label><input class="crea_inp" type="text" value="" name="categoryFactedName"/></label></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
<div id="modifyCategoryFatctedDialog" style="display:none;">
    <input type="hidden" value="" id="programCategoryId" name = "programCategoryId"/>
    <input type="hidden" value="" id="factedId" name = "factedId"/>
    <input type="hidden" value="" id="parent" name = "parent"/>
    <input type="hidden" value="" id="opt" name = "opt"/>
    <div class="ui-dialog-content ui-widget-content crea_win">
        <table>
            <tbody>
            <tr>
                <td align="center">分面名称/值</td>
                <td><label><input class="crea_inp" type="text" value="" name="factedName"/></label></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>