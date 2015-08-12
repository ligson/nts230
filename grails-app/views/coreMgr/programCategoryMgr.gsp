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
    <r:require modules="zTree"/>
    <link rel="stylesheet" type="text/css"  href="${resource(dir: 'skin/blue/pc/front/css', file: 'programCategoryMgr.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/commonLib', file: 'string.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/coreMgr/programCategoryMgr.js')}"></script>
</head>

<body>


<div class="tree_main">
    <div class="tree_left">
        <div id="zTree" class="ztree">
        </div>
    </div>

    <div class="tree_content">
        %{--<input type="button" value="创建根分类" id="createProgramCategory">--}%
        <input class="boful_tree_content_but" type="button" value="清除选择" id="clearSelect">
        <input class="boful_tree_content_but" type="button" value="删除分类" id="removeProgramType">
        <input class="boful_tree_content_but" type="button" value="定位选择的分类" id="expandProgramType">
        <input class="boful_tree_content_but" type="button" value="创建子分类" id="createSubProgramCategory">
        <br/>
        <input type="hidden" value="" id="selectProgramTypeId">

        <div style="margin-top: 10px;">
            <label style="line-height: 46px; width: 65px;">分类名称&nbsp;&nbsp;&nbsp;</label><input type="text" value=""
                                                                               id="programTypeName"
                                                                               style="width: 300px;">  <br>
            <label style="margin-top: 10px;"> 资源类别&nbsp;&nbsp;</label>
                <select name="mediaType">
                    <g:each in="${ProgramCategory.mediaTypeCn}" var="media">
                        <option value="${media.key}">${media.value}</option>
                    </g:each>
                </select>
            <br>
            <label style="line-height: 120px;float: left; margin-top: 20px">分类描述&nbsp;&nbsp;&nbsp;</label><textarea id="programTypeDesc"></textarea>
        </div>
        <input class="boful_tree_content_but2"  type="button" style="margin-top: 10px; width: 80px;" value="修改" id="modifyProgramType">

        <br/>
    </div>
</div>


<div id="createRootProgramDialog" style="display:none;">
    <g:form controller="coreMgr" action="createProgramCategory" name="createProgramCategoryForm">
        <div class="ui-dialog-content ui-widget-content">
            分类名称&nbsp;&nbsp;&nbsp;<br><input type="text" value="" name="categoryName"/> <br>
            资源类别&nbsp;&nbsp;
            <select   name="mediaType">
                <g:each in="${ProgramCategory.mediaTypeCn}" var="media">
                    <option value="${media.key}">${media.value}</option>
                </g:each>
            </select><br>
            分类描述&nbsp;&nbsp;&nbsp;<br><textarea  name="description"></textarea>
        </div>
    </g:form>
</div>

<div id="createSubProgramDialog" style="display:none;">
    分类名称&nbsp;&nbsp;&nbsp;<br><input type="text" value="" name="categoryName"/><br>
    资源类别&nbsp;&nbsp;&nbsp;
    <select name="mediaType">
        <g:each in="${ProgramCategory.mediaTypeCn}" var="media">
            <option value="${media.key}">${media.value}</option>
        </g:each>
    </select>
    <br>
    分类描述&nbsp;&nbsp;&nbsp;<br><textarea  name="description"></textarea>
</div>
</body>
</html>