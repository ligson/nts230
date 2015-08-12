<%@ page import="nts.utils.CTools; nts.system.domain.Directory" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>我的资源</title>
    <r:require modules="swfupload,jquery-ui,zTree,string,jquery-cookie"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/css', file: 'my_editProgram.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/bfUploadMy.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/bfUploadMyPoster.js')}"></script>
</head>

<body>

<div id="main-content">
    <div class="content-box-content">
        <g:form action="updateProgram" name="editProgramForm">
            <input type="hidden" name="programId" id="programId" value="${program.id}">
            <table cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <th>资源名称</th>
                    <td colspan="2"><input style="padding: 5px;width: 300px; " type="text" name="name"
                                           value="${program.name}" id="programName"><span
                            style="margin-left: 15px; font-size: 12px; color: #ff3300">[可输入200字]</span></td>
                </tr>
                <tr>
                    <th>描述</th>
                    <td colspan="2">
                        <textarea style="width: 600px;height: 100px;padding: 5px" rows="10" cols="10" id="programDesc"
                                  name="description">${CTools.htmlToBlank(program.description)}</textarea>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <th>类库</th>
                    <td>
                        <g:select name="dirId" from="${Directory.list()}" optionKey="id"
                                  style="padding:5px;width: 100px" optionValue="name"
                                  value="${program?.directory?.id}"/>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <th>分类</th>
                    <td>
                        <g:if test="${program.programCategories && program.programCategories.size() > 0}">
                            <g:set var="categoryIds" value=""/>
                            <g:set var="categoryNames" value=""/>
                            <g:each var="programCategory" in="${program.programCategories.toList()}">
                                <g:set var="categoryIds" value="${categoryIds + "," + programCategory.id}"></g:set>
                                <g:set var="categoryNames"
                                       value="${categoryNames + "," + programCategory.name}"></g:set>
                            </g:each>
                        </g:if>
                        <input type="hidden" id="categoryId" name="categoryId" value="${categoryIds}">
                        <span id="categoryName">${categoryNames != "" ? categoryNames : '未选择'}</span>
                        <input class="content-box-content_fixup" type="button" value="修改"
                               id="selectCategoryBtn"></td>
                    <td></td>
                </tr>
                <tr>
                    <th>浏览方式</th>
                    <td><g:if test="${program?.otherOption == nts.program.domain.Program.ONLY_LESSION_OPTION}">
                        <select name="otherOption" style="padding: 5px;width: 100px;"><option value="5"
                                                                                              selected>课程</option>
                        </select>
                    </g:if><g:else>
                        <select name="otherOption" style="padding: 5px;width: 100px;">
                            <option value="0" ${(program.otherOption & 0) == 0 ? "selected" : ""}>视音频</option>
                            <option value="8" ${(program.otherOption & 8) == 8 ? "selected" : ""}>纯文档(文库)</option>
                            <option value="16" ${(program.otherOption & 16) == 16 ? "selected" : ""}>纯图片</option>
                            <option value="6" ${(program.otherOption & 6) == 6 ? "selected" : ""}>flash动画</option>
                        </select>
                        <span style="margin-left: 20px; font-size: 12px; color: #ff3300">格式类型</span></g:else>
                    </td>
                </tr>
                <tr>
                    <th>是否公开:</th>
                    <td>
                        <label>
                            公开
                            <input type="radio" name="canPublic" ${program.canPublic ? 'checked' : ''} value="true">
                        </label>
                        <label>
                            不公开
                            <input type="radio" name="canPublic" ${program.canPublic ? '' : 'checked'} value="false">
                        </label>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <th>海报截图：</th>
                    <td colspan="2">
                        <input type="hidden" name="posertHash" value="">
                        <input type="hidden" name="posertPath" value="">
                        <a class="content-box-content_fix"
                           href="${posterLinkNew(program: program, size: '200x200')}"
                           target="_blank">查看</a><a class="content-box-content_fix" id="replacePoster">替换</a>
                    </td>

                </tr>
                <tr>
                    <g:set var="tagValues" value=""/>
                    <g:each in="${program.programTags}" var="tag2">
                        <g:set var="tagValues" value="${tagValues + " " + tag2}"/>
                    </g:each>
                    <th>标签：</th>
                    <td>
                        <input type="hidden" name="programTag" value="${tagValues?.replaceAll(" ", ";")}"/>
                        <input style="padding: 5px; width: 600px" type="text" value="${tagValues}" id="tagsInput">
                    </td>
                <tr>
                    <th></th>
                    <td colspan="2">
                        <p id="tagShow">
                            <g:each in="${program.programTags}" var="tag">
                                <span class="boful_program_tag">${tag.name}</span>
                            </g:each>
                        </p>
                    </td>
                </tr>
                <tr>
                    <th colspan="3">
                        文件列表：
                    </th>
                </tr>
                <tr>
                    <td colspan="3">
                        <table>
                            <tr>
                                <td style="border: 0">名称</td>
                                <td style="border: 0">文件序号</td>
                                <td style="border: 0">操作</td>
                            </tr>
                            <g:each in="${program.serials}" var="serail">
                                <tr id="serial_${serail.id}">
                                    <td style="border: 0">${serail.name}</td>
                                    <td style="border: 0">${serail.serialNo}</td>
                                    <td style="border: 0">
                                        <a class="boful_program_tag_name_edite"
                                           href="${createLink(controller: 'my', action: 'editSerial', params: [id: serail.id])}">编辑</a>
                                        <span class="boful_program_tag_name_delete"
                                              onclick="removeSerial('${createLink(controller: 'my', action: 'removeSerial')}', ${serail.id}, 'serial_${serail.id}')">删除</span>
                                    </td>
                                </tr>
                            </g:each>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="3"><input class="content-box-content_fixup_submit" type="button" value="继续上传"
                                           id="bfUploadFileBtn"/></td>
                </tr>
                <tr>
                    <td colspan="3">
                        <input type="hidden" value="0" name="fileCount" id="fileCount">
                        上传文件个数：<span id="fileCountShow">0</span>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <div class="upload_list">

                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <input class="content-box-content_fixup_submit1" type="submit" value="提交">
                    </td>
                </tr>
            </table>
        </g:form>

    </div>
</div>

<div id="selectCategoryDialog" class="bg" style="display:none;" title="选择分类">
    <div>
        <input type="hidden" id="selectedCategoryId" value=""/>
        选择的分类：<span id="selectedCategoryName">未选择</span>
    </div>

    <div id="zTree" class="ztree">
    </div>
</div>

</body>
</html>
