<%--
  Created by IntelliJ IDEA.
  User: boful
  Date: 14-12-15
  Time: 下午1:06
--%>

<%@ page import="com.boful.common.file.utils.FileType; java.text.SimpleDateFormat; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.mined.name')}${message(code: 'my.album.name')}</title>
    <r:require modules="zTree"></r:require>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'myAlbumResourceRelease.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'string.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/userspace', file: 'myAlbumResourceRelease.js')}"></script>
    <style type="text/css">
    .ui-widget-content {
        z-index: 110;
    }
    </style>
</head>

<body>

<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.releaseProgram.name')}</a>
</div>

<g:form controller="my" action="myAlbumResourceReleaseProgramSave" name="releaseForm" method="post">
    <!--  专辑ID  -->
    <input type="hidden" name="specialId" value="${userSpecial?.id}" />
    <!--  元数据标准  -->
    <input type="hidden" id="classLibId" name="classLibId" value=""/>
    <div class="myAlbumResourceRelease">
        <table class="table resources_upload_infor">
            <tbody>
            <tr>
                <th style="width: 120px">专辑名称</th>
                <th style="text-align: left;">${userSpecial?.name}
                <input type="hidden" value="${userSpecial?.name}" name="specialName" />
                </th>
            </tr>
            <tr>
                <th style="width: 120px"><span class="name_warning">*&nbsp;</span>资源名称</th>
                <td><input type="text" id="programName" name="programName" class="form-control" value="${userSpecial?.name}" /></td>
            </tr>
            <tr>
                <th style="width: 120px"><span class="name_warning">*&nbsp;</span>选择类别</th>
                <td><input type="button" id="selectCategoryBtn" class="btn btn-success btn-sm" value="选择分类">
                    <input type="button" id="clearCategoryBtn" class="btn btn-success btn-sm" value="清除所选分类">
                </td>
            </tr>
            <tr>
                <th style="width: 120px">已选分类</th>
                <td>
                    <input type="hidden" name="categoryId" id="categoryId"  autocomplete="off">
                    <span id="categoryName" name="categoryName"></span>
                </td>
            </tr>
            <tr id="factedTr" style="display: none">
                <th style="width: 120px">选择分面</th>
                <td style="text-align: left;">
                    <table id="factedTb" cellpadding="0" cellspacing="0"></table>
                </td>
            </tr>
            <tr>
                <th style="width: 120px">是否公开</th>
                <td>
                    <g:radio name="canPublic" value="true"/>是&nbsp;
                    <g:radio name="canPublic" value="false" checked="true"/>否
                </td>
            </tr>
            <tr>
                <th style="width: 120px">浏览方式</th>
                <td>
                    <g:select id="otherOption" name="otherOption" class="se_mgr"
                              from="${[0: '视频', 1: '音频', 8: '纯文档(文库)', 16: '纯图片', 128: '课程', 6: 'flash动画']}"
                              optionKey="key" optionValue="value"/>
                </td>
            </tr>
            <tr>
                <th style="width: 120px">标  签</th>
                <td>
                    <input type="text" id="programTagInput" class="form-control">
                    <input type="hidden" id="programTag" name="programTag" value=""/>(多标签逗号区分)
                </td>
            </tr>
            <tr>
                <th style="width: 120px"></th>
                <td id="tagShow" colspan="2">
                </td>
            </tr>
            <tr>
                <th style="width: 120px">资源描述</th>
                <td>
                    <textarea type="text" name="description" id="description"
                              class="form-control"
                              rows="3"></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="right">
                    <input type="submit" id="releaseBtn" class="btn btn-success btn-sm"  value="发布资源">
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="myAlbum_chose_list">
        <h1>${message(code: 'my.album.name')}${message(code: 'my.files.name')}</h1>
        <table class=" table table-hover">
            <tbody>
            <tr>
                <th width="80" align="center">媒体类型</th>
                <th align="center">文件名</th>
                <th width="100" align="center">大小</th>
                <th width="100" align="center">创建日期</th>
            </tr>
            <g:each in="${specialFileList}" var="specialFile">
                <tr>
                    <td align="center">
                        <g:if test="${FileType.isVideo(specialFile?.userFile?.filePath)}">
                            <span class="tab_math_icon"></span>
                        </g:if>
                        <g:elseif test="${FileType.isImage(specialFile?.userFile?.filePath)}">
                            <span class="tab_math_image_icon"></span>
                        </g:elseif>
                        <g:elseif test="${FileType.isDocument(specialFile?.userFile?.filePath) || specialFile?.userFile?.filePath.endsWith("pdf") || specialFile?.userFile?.filePath.endsWith("PDF")}">
                            <span class="tab_math_doc_icon"></span>
                        </g:elseif>
                        <g:elseif test="${FileType.isAudio(specialFile?.userFile?.filePath)}">
                            <span class="tab_math_audio_icon"></span>
                        </g:elseif>
                        <g:elseif test="${specialFile?.userFile?.filePath.endsWith("swf") || specialFile?.userFile?.filePath.endsWith("SWF")}">
                            <span class="tab_math_icon"></span>
                        </g:elseif>
                        <g:else>
                            <span class="tab_math_other_icon"></span>
                        </g:else>

                    </td>
                    <td>${specialFile?.name}</td>
                    <td>${convertHumanUnit(fileSize: specialFile?.userFile.fileSize)}</td>
                    <td>${new SimpleDateFormat('yyyy-MM-dd').format(specialFile?.createdDate)}</td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
</g:form>

<div id="selectCategoryDialog" class="bg" title="选择分类">
    <div>
        <input type="hidden" id="selectedCategoryId" value="" autocomplete="off"/>
        <input type="hidden" id="selectedCategoryName" value=""  autocomplete="off"/>
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