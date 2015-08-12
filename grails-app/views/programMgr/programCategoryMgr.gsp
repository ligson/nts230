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

    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'programCategoryMgr.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <r:require modules="swfupload"/>
    <script type="text/javascript"
            src="${resource(dir: 'js/boful/programMgr', file: 'programCategoryMgr.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'boful/programMgr/bfUploadDefaultProgramPoster.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
</head>

<body>

<div class="tree_main">
    <div class="tree_left">
        <div id="zTree" class="ztree">
        </div>

    </div>

    <div class="tree_content">
        %{--<input type="button" value="创建根分类" id="createProgramCategory">--}%
        <input class="admin_default_but_green" type="button" value="清除选择" id="clearSelect" style="width:90px">
        <input class="admin_default_but_green" type="button" value="定位选择" id="expandProgramType"
               style="width: 90px">
        <input class="admin_default_but_green" type="button" value="创建资源库" id="createProgramCategory"
               style="width: 100px">
        <input class="admin_default_but_green" type="button" value="创建子分类" id="createSubProgramCategory"
               style="width: 100px">
        <input class="admin_default_but_green" type="button" value="同步资源库" id="synProgramCategory"
               style="width: 100px">
        <input class="admin_default_but_green" type="button" value="删除资源库/分类" id="removeProgramType"
               style="width: 130px">

        <br/>
        <br/>
        <g:uploadForm name="updateProgramCategoryForm" controller="programMgr" action="modifyProgramType"
                      enctype="multipart/form-data">
            <input type="hidden" value="" id="selectProgramTypeId" name="updateId">
            <input type="hidden" value="" id="selectProgramDisplayType" name="updateIsDisplay"/>

            <div style="margin-top: 10px;">
                <table class="table">
                    <tbody>
                    <tr>
                        <td width="350" align="right"><span>名&nbsp;&nbsp;称:&nbsp;&nbsp;</span></td>
                        <td>
                            <input type="text" value="" id="programTypeName" name="updatePCategoryName"
                                   class="admin_default_inp" maxlength="9">
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><span>资源类别:&nbsp;&nbsp;</span></td>
                        <td>
                            <select class="form-control" name="updateMediaType" style="width: 260px">
                                <g:each in="${ProgramCategory.mediaTypeCn}" var="media">
                                    <option value="${media.key}">${media.value}</option>
                                </g:each>
                            </select>
                        </td>
                    </tr>

                    <tr id="directoryTr">
                        <td align="right">元数据标准:&nbsp;&nbsp;</td>
                        <td>
                            <label>
                                <select class="form-control crea_inp" id="updateDirectoryId" name='updateDirectoryId'
                                        style="width: 260px
                                        ">
                                    <option value="-1">--请选择--</option>
                                    <g:each in="${directoryList}" var="updateDirectory">
                                        <option value="${updateDirectory.id}">${updateDirectory.name}</option>
                                    </g:each>
                                </select>
                            </label>
                        </td>
                    </tr>
                    <tr id="uploadTr">
                        <td width="120" align="right">上传路径 :&nbsp;&nbsp;</td>
                        <td>
                            <input id="updateUploadPath" name="updateUploadPath" value=""
                                   type="text" style="width: 360px"
                                   class="form-control"/>
                            <span style="margin-left: 15px; font-size: 12px; color: #ff3300">[提示:上传路径为服务器的绝对路径,不设置则传到默认路径下]</span>
                        </td>
                    </tr>
                    <tr id="imgTr">
                        <td align="right">图&nbsp;&nbsp;片 :&nbsp;&nbsp;</td>
                        <td id="imgTd">
                            <img style="display: none" src="" width="40" height="40"/>
                            <input name='updateImg' id='updateImg' type='file' size='30'>
                            <span style="margin-left: 15px; font-size: 12px; color: #ff3300">[提示:图片尺寸为220*385;支持格式:jpg,png,gif]</span>
                        </td>
                    </tr>
                    <tr id="posterTr">
                        <td align="right">资源默认海报 :&nbsp;&nbsp;</td>
                        <td id="posterTd">
                            <input type="hidden" name="defaultProgramPosterHash" id="defaultProgramPosterHash" value="">
                            <input type="hidden" name="defaultProgramPosterPath" id="defaultProgramPosterPath" value="">
                            <img style="display: none" src="" width="40" height="40"/>
                            <input type="button" id="programPoster" value="上传海报">
                            <span id="showDefaultPosterName"></span>
                            <span style="margin-left: 15px; font-size: 12px; color: #ff3300">[提示:该分类库下的资源没有设置海报时使用此海报]</span>
                        </td>
                    </tr>
                    <tr id="posterFormatTr" style="display: none;">
                        <td align="right">海报版式 :&nbsp;&nbsp;</td>
                        <td><input type="radio" value="0" name="posterFormat"/>横版&nbsp;&nbsp;
                            <input type="radio" value="1" name="posterFormat"/>竖版
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><span>分类描述:&nbsp;&nbsp;</span></td>
                        <td>
                            <textarea class="form-control" id="programTypeDesc" name="updateDesc"
                                      style="width: 360px"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <label>
                                <input class="btn btn-primary" type="button" style="margin-top: 10px; width: 80px;"
                                       value="修改"
                                       id="modifyProgramType">

                            </label>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </g:uploadForm>
        <br/>
    </div>
</div>

<div id="createSubProgramDialog" style="display:none;">
    <g:uploadForm name="createProgramCategoryForm" controller="programMgr" action="createProgramCategory"
                  enctype="multipart/form-data" onsubmit="return checkSubCategoryValue();">
        <input type="hidden" value="" name="pid" id="selectProgramCategoryTypeId">
        <input type="hidden" value="" name="isDisplay" id="selectProgramCategoryDisplayType"/>
        <table>
            <tbody>
            <tr>
                <td width="80" align="right">分类名称:&nbsp;&nbsp;</td>
                <td><label><input type="text" value="" name="categoryName" class="crea_inp" maxlength="9"/></label></td>
            </tr>
            <tr>
                <td align="right">资源类别:&nbsp;&nbsp;</td>
                <td><label><select name="mediaType" class="crea_inp">
                    <g:each in="${ProgramCategory.mediaTypeCn}" var="media">
                        <option value="${media.key}">${media.value}</option>
                    </g:each>
                </select></label></td>
            </tr>
            <tr>
                <td width="80" align="right">海报版式:&nbsp;&nbsp;</td>
                <td><input type="radio" value="0" name="posterFormat" checked="true"/>横版&nbsp;&nbsp;
                    <input type="radio" value="1" name="posterFormat"/>竖版</td>
            </tr>
            %{--<tr>
                <td align="right">元数据标准:&nbsp;&nbsp;</td>
                <td>
                    <label>
                        <select class="crea_inp" id="directoryId" name='directoryId'>
                            <g:each in="${directoryList}" var="directory">
                                <option value="${directory.id}">${directory.name}</option>
                            </g:each>
                        </select>
                        --}%%{--<input type="hidden" id="directoryId" name="directoryId" value=""/>--}%%{--
                    </label>
                </td>
            <tr>
            <tr>
                <td width="120" align="right">上传目录:&nbsp;&nbsp;</td>
                <td>
                    <label>
                        <input id="uploadPath" name="uploadPath" value="" maxLength="20"
                               type="text" style="width: 360px"
                               class="crea_inp" size="52"/>
                    </label>
                </td>
            </tr>
            <tr>
                <td align="right">图片:&nbsp;&nbsp;</td>
                <td>
                    <label>
                        <input name="saveImg" id="saveImg" type="file" size="30">
                    </label>
                </td>
            </tr>--}%
            <tr>
                <td align="right">分类描述:&nbsp;&nbsp;</td>
                <td><label><textarea name="description" class="crea_inp"></textarea></label></td>
            </tr>
            </tbody>
        </table>
    </g:uploadForm>
</div>

<div id="createProgramCategoryDialog" style="display:none;">
    <g:uploadForm name="createProgramCategoryLibraryForm" controller="programMgr" action="createProgramCategoryLibrary"
                  enctype="multipart/form-data" onSubmit="return checkCategoryValue();">
        <table>
            <tbody>
            <tr>
                <td width="80" align="right">资源库名称:&nbsp;&nbsp;</td>
                <td><label><input type="text" value="" name="categoryLibraryName" class="crea_inp" maxlength="9"/>
                </label></td>
            </tr>
            <tr>
                <td align="right">资源类别:&nbsp;&nbsp;</td>
                <td><label><select name="libraryMediaType" class="crea_inp">
                    <g:each in="${ProgramCategory.mediaTypeCn}" var="media">
                        <option value="${media.key}">${media.value}</option>
                    </g:each>
                </select></label></td>
            </tr>
            <tr>
                <td align="right">元数据标准:&nbsp;&nbsp;</td>
                <td>
                    <label>
                        <select class="crea_inp" id="libraryDirectoryId" name='libraryDirectoryId'>
                            <option value="-1">--请选择--</option>
                            <g:each in="${directoryList}" var="directory">
                                <option value="${directory.id}">${directory.name}</option>
                            </g:each>
                        </select>
                        %{--<input type="hidden" id="directoryId" name="directoryId" value=""/>--}%
                    </label>
                </td>
            <tr>
            <tr>
                <td width="120" align="right">上传路径:&nbsp;&nbsp;</td>
                <td>
                    <label>
                        <input id="libraryUploadPath" name="libraryUploadPath" value="" type="text" style="width: 360px"
                               class="crea_inp"/>

                    </label>

                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <span style="margin-left: 15px; font-size: 12px; color: #ff3300">[提示:上传路径为服务器的绝对路径,不设置则传到默认路径下]</span>
                </td>
            </tr>
            <tr>
                <td align="right">图&nbsp;&nbsp;片:&nbsp;&nbsp;</td>
                <td>
                    <input name="saveLibraryImg" id="saveLibraryImg" type="file" size="30">
                    <span style="margin-left: 15px; font-size: 12px; color: #ff3300">[提示:图片尺寸为220*385;支持格式:jpg,png,gif]</span>
                </td>
            </tr>
            <tr>
                <td align="right">资源默认海报 :&nbsp;&nbsp;</td>
                <td>
                    <input type="hidden" name="defaultProgramPosterHashCreate" id="defaultProgramPosterHashCreate"
                           value="">
                    <input type="hidden" name="defaultProgramPosterPathCreate" id="defaultProgramPosterPathCreate"
                           value="">
                    <img style="display: none" src="" width="40" height="40"/>
                    <input type="button" id="programPosterCreate" value="上传海报">
                    <span id="showDefaultPosterNameCreate"></span>
                    <span style="margin-left: 15px; font-size: 12px; color: #ff3300">[提示:该分类库下的资源没有设置海报时使用此海报]</span>
                </td>
            </tr>
            <tr>
                <td align="right">描&nbsp;&nbsp;述:&nbsp;&nbsp;</td>
                <td><label><textarea name="libraryDesc" class="crea_inp"></textarea></label></td>
            </tr>
            </tbody>
        </table>
    </g:uploadForm>
</div>

%{--<div id="createRootProgramDialog" style="display:none;">
    <g:form controller="programMgr" action="createProgramCategory" name="createProgramCategoryForm">
        <div class="ui-dialog-content ui-widget-content crea_win">
            <table>
                <tbody>
                <tr>
                    <td width="80" align="center">分类名称</td>
                    <td><label><input class="crea_inp" type="text" value="" name="categoryName"/></label></td>
                </tr>
                <tr>
                    <td align="center">资源类别</td>
                    <td><label>
                        <select name="mediaType" class="crea_inp">
                            <g:each in="${ProgramCategory.mediaTypeCn}" var="media">
                                <option value="${media.key}">${media.value}</option>
                            </g:each>
                        </select></label></td>
                </tr>
                <tr>
                    <td align="center">分类描述</td>
                    <td><label><textarea name="description" class="crea_inp"></textarea></label></td>
                </tr>
                </tbody>
            </table>

        </div>
    </g:form>
</div>--}%
</body>
</html>