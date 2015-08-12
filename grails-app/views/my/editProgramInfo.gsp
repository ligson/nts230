<%@ page import="nts.utils.CTools; nts.system.domain.Directory" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>我的资源</title>
    <r:require modules="swfupload,jquery-ui,zTree,string,jquery-cookie"/>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_editProgram.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/editProgramInfo.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/bfUploadMyPoster.js')}"></script>
    <style type="text/css">
    .ui-widget-content {
        z-index: 110;
    }
    </style>
</head>

<body>

<g:if test="${flash.msg}">
    <div class="upload_succes_word"><span class="upload_succes">${flash.msg}</span></div>
</g:if>
<div class="content-box-content" style="overflow: hidden; width: 760px;">
    <g:form action="updateProgram" name="editProgramForm">
        <input type="hidden" name="programId" id="programId" value="${program.id}">
        <table class="table" width="760">
            <tr>
                <th>专辑名称</th>
                <td>${program?.specialName}</td>
            </tr>
            <tr>
                <th>资源名称</th>
                <td><input style="padding: 5px;width: 300px; " type="text" name="name"
                                       value="${program?.name}" id="programName"><span
                        style="margin-left: 15px; font-size: 12px; color: #ff3300">[可输入200字]</span></td>
            </tr>
            <tr>
                <th>描述</th>
                <td>
                    <textarea class="form-control" style="width:600px;" rows="10" cols="10" id="programDesc"
                              name="description">${CTools.htmlToBlank(program?.description)}</textarea>
                </td>
                <td></td>
            </tr>
            <tr>
                <th>选择类别</th>
                <td>
                    <input type="button" id="selectCategoryBtn" class="content-box-content_fix" value="选择分类">
                    <input type="button" id="clearCategoryBtn" class="content-box-content_fix" value="清除所选分类">
                </td>
            </tr>
            <tr>
                <th>已选分类</th>
                <td>
                    <input type="hidden" name="categoryId" id="categoryId"  autocomplete="off" value="${categoryId}">
                    <span id="categoryName" name="categoryName">${categoryName? categoryName: '无'}</span>
                </td>
            </tr>
            <tr id="factedTr" style="${(factedList && factedList.size() > 0) ? '' : 'display: none'}">
                <th>分&nbsp;&nbsp;面</th>
                <td>
                    <table id="factedTb" class="resources_upload_infor" width="100%">
                        <g:if test="${factedList && factedList.size() > 0}">
                            <g:each in="${factedList}" var="facted" status="i">
                                <tr>
                                    <th align="left">${facted?.factedName}</th>
                                    <td>
                                        <g:each in="${facted.values}" var="factedValue">
                                            <input type='checkbox' name='factedValue'
                                                   value='${factedValue.valId}' ${factedValue.checked == '1' ? 'checked' : ''}/>${factedValue.valName}&nbsp;
                                        </g:each>
                                    </td>
                                </tr>
                            </g:each>
                        </g:if>
                    </table>
                </td>
            </tr>
            <tr>
                <th>浏览方式</th>
                <td>
                    <g:select name="otherOption" class="se_mgr"  style="padding: 5px;"
                              from="${[0: '视频', 1: '音频', 8: '纯文档(文库)', 16: '纯图片', 128: '课程', 6: 'flash动画']}"
                              optionKey="key" optionValue="value" value="${program?.otherOption}"/>
                    <span style="margin-left: 20px; font-size: 12px; color: #ff3300">格式类型</span>
                </td>
            </tr>
            <tr>
                <th>是否公开</th>
                <td>
                    <g:radio name="canPublic" value="true" checked="${program.canPublic == true ? 'true' : ''}"/>是&nbsp;
                    <g:radio name="canPublic" value="false" checked="${program.canPublic == false ? 'true' : ''}"/>否
                </td>
            </tr>
            <tr>
                <th>海报截图：</th>
                <td>
                    <input type="hidden" name="posertHash" value="">
                    <input type="hidden" name="posertPath" value="">
                    <a class="content-box-content_fix" href="${posterLinkNew(program: program, size: '200x200')}"
                       target="_blank">查看横版</a>
                    <a class="content-box-content_fix" id="replacePoster">替换</a>
                </td>
            </tr>
            <tr>
                <th></th>
                <td>
                    <a class="content-box-content_fix" href="${verticalPosterLinkNew(program: program, size: '200x200')}"
                       target="_blank">查看竖版</a>
                    <a class="content-box-content_fix" id="replaceVerticalPoster">替换</a>
                </td>
            </tr>
            <tr>
                <th>标签：</th>
                <td>
                    <g:set var="tagValues" value=""/>
                    <g:if test="${program?.programTags?.size() > 0}">
                        <g:each in="${program?.programTags}" var="tag1">
                            <g:set var="tagValues" value="${tagValues + tag1.name + ","}"/>
                        </g:each>
                    </g:if>
                    <input type="hidden" name="programTag" id="programTag"
                           value="${tagValues.length() > 1 ? tagValues.substring(0, tagValues.length() - 1) : tagValues}"/>
                    <input style="padding: 5px; width: 600px" type="text" value="${tagValues.length() > 1 ? tagValues.substring(0, tagValues.length() - 1) : tagValues}" id="programTagInput">

                    <span style="margin-left: 15px; font-size: 12px; color: #ff3300">&nbsp;[多标签，请用逗号隔开]</span>
                </td>
            <tr>
                <th></th>
                <td>
                    <p id="tagShow">
                        <g:if test="${program?.programTags?.size() > 0}">
                            <g:each in="${program?.programTags}" var="tag">
                                <span class="boful_program_tag">${tag?.name}</span>
                            </g:each>
                        </g:if>
                    </p>
                </td>
            </tr>
        </table>
        <table class="table" style="width: 760px; overflow:hidden">
            <tbody>
            %{--<tr>
                <td width="320px" align="right"><input type="hidden" value="0" name="fileCount" id="fileCount">
                    <span style="margin-left: 20px;">上传文件个数：<span id="fileCountShow">0</span></span></td>
                <td width="80" align="left"><input class="content-box-content_fixup_submit" style="margin-left: 20px;"
                                                   type="button" value="继续上传"
                                                   id="bfUploadFileBtn"/></td>
            </tr>
            <tr>
                <td><div class="upload_list"></div></td>
            </tr>--}%
            <tr>
                <td><input class="content-box-content_fixup_submit1" style="margin-right:160px; padding-left: 0;"
                           type="submit" value="提交"></td>
            </tr>
            </tbody>
        </table>
    </g:form>

</div>

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
