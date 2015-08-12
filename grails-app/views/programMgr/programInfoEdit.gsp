<%@ page import="nts.utils.CTools; nts.system.domain.Directory" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>我的资源</title>
    <r:require modules="swfupload,jquery-ui,zTree,string,jquery-cookie"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'program_editProgram.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/fileType.js')}"></script>
    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/bfUploadMy.js')}"></script>--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/bfUploadMyPoster.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/program_editProgram.js')}"></script>
</head>

<body>

<div class="content-box-content" style="overflow: hidden; width: 760px; padding-top: 30px">
    <g:if test="${flash.msg}">
        <div class="upload_succes_word"><span class="upload_succes">${flash.msg}</span></div>
    </g:if>
    <g:form action="updateProgram" name="editProgramForm">
        <input type="hidden" name="programId" id="programId" value="${program.id}">
        <table class="table" width="760">
            <tr>
                <th style="width: 90px; text-align: right">资源名称</th>
                <td colspan="2">
                    <label>
                        <input class="form-control" style="width: 400px;" type="text" name="name"
                               value="${program?.name}" id="programName">
                    </label>
                    <span
                            style="margin-left: 15px; font-size: 12px; color: #ff3300">[可输入200字]</span>
                </td>
            </tr>

            %{--<tr>
                <th>元数据标准</th>
                <td>
                    <select name="dirId" from="" optionKey="id" style="padding:5px;width: 100px" optionValue="name"
                            value="">
                        <g:each in="${Directory.list()}" var="directory">
                            <g:if test="${program?.directory?.id == directory?.id}">
                                <option value="${directory?.id}" selected>${directory?.name}</option>
                            </g:if>
                            <g:else>
                                <option value="${directory?.id}">${directory?.name}</option>
                            </g:else>
                        </g:each>
                    </select>
                </td>
                <td></td>
            </tr>--}%

            <tr>
                <th style="width: 90px; text-align: right">浏览方式</th>
                <td>
                    <g:select name="otherOption" class="se_mgr"
                              from="${[0: '视频', 1: '音频', 8: '纯文档(文库)', 16: '纯图片', 128: '课程', 6: 'flash动画']}"
                              optionKey="key" optionValue="value" value="${program?.otherOption}"/>
                    %{--<select name="otherOption" style="padding: 5px;width: 100px;">
                        <g:if test="${program?.programCategory?.mediaType == 5}">
                            <option value="5" selected>课程</option>
                        </g:if>
                        <g:else>
                            <option value="0">视音频</option>
                            <option value="8">纯文档(文库)</option>
                            <option value="16">纯图片</option>
                        </g:else>
                    </select>--}%
                    <span style="margin-left: 20px; font-size: 12px; color: #ff3300">[格式类型]</span>
                </td>
            </tr>
            <tr>
                <th style="width: 90px; text-align: right">是否公开</th>
                <td>
                    <g:radio name="canPublic" value="true" checked="${program.canPublic == true ? 'true' : ''}"/>是&nbsp;
                    <g:radio name="canPublic" value="false" checked="${program.canPublic == false ? 'true' : ''}"/>否
                </td>
            </tr>
            <tr>
                <th style="width: 90px; text-align: right">选择分类</th>
                <td>
                    <input type="button" id="selectCategoryBtn" class="resources_upload_chose_but"
                           value="选择分类">
                    &nbsp; <input type="button" id="clearCategoryBtn" class="resources_upload_chose_but"
                                  value="清除所选分类">
                    <span  style="font-size: 12px; color: #ff3300">&nbsp;[点击选择分类,&nbsp;可多选;&nbsp;&nbsp;分类重新选择后,分面也需重新设值;&nbsp;&nbsp;默认分类中资源前台不显示]</span>
                </td>
            </tr>
            <tr>
                <th style="width: 90px; text-align: right">已选分类</th>
                <td>
                    <input type="hidden" name="categoryId" id="categoryId" value="${categoryId}">
                    <span id="categoryName" name="categoryName">${categoryName? categoryName: '无'}</span>
                </td>
            </tr>
            <tr id="factedTr" style="${(factedList && factedList.size() > 0) ? '' : 'display: none'}">
                <th style="width: 90px; text-align: right">分&nbsp;&nbsp;面</th>
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
                <th style="width: 90px; text-align: right">推荐数</th>
                <td>
                    <input type="text" id="recommendNumId" class="form-control" style="width: 100px;"
                           name="recommendNum"
                           value="${program.recommendNum}"/>
                </td>
            </tr>
            <tr>
                <th style="width: 90px; text-align: right">海报截图</th>
                <td colspan="2">
                    <input type="hidden" name="posertHash" value="">
                    <input type="hidden" name="posertPath" value="">
                    <a class="content-box-content_fix" href="${posterLinkNew(program: program, size: '200x200')}"
                       target="_blank">查看横版</a>
                    <a class="content-box-content_fix" id="replacePoster">替换</a>
                </td>
            </tr>
            <tr>
                <th style="width: 90px; text-align: right"></th>
                <td colspan="2">
                    <a class="content-box-content_fix" href="${verticalPosterLinkNew(program: program, size: '200x200')}"
                       target="_blank">查看竖版</a>
                    <a class="content-box-content_fix" id="replaceVerticalPoster">替换</a>
                </td>
            </tr>
            <tr>
                <th style="width: 90px; text-align: right">描&nbsp;&nbsp;述</th>
                <td colspan="2">
                    <textarea class="form-control" style="width:400px;" rows="4" cols="10" id="programDesc"
                              name="description">${CTools.htmlToBlank(program?.description)}</textarea>
                </td>
                <td></td>
            </tr>
            <tr>
                <th style="width: 90px; text-align: right">标&nbsp;&nbsp;签</th>
                <td>
                    <g:set var="tagValues" value=""/>
                    <g:if test="${program?.programTags?.size() > 0}">
                        <g:each in="${program?.programTags}" var="tag1">
                            <g:set var="tagValues" value="${tagValues + tag1.name + ","}"/>
                        </g:each>
                    </g:if>
                    <input type="hidden" name="programTag"
                           value="${tagValues.length() > 1 ? tagValues.substring(0, tagValues.length() - 1) : tagValues}"/>
                    <label>
                        <input class="form-control" style="width: 400px;" type="text"
                               value="${tagValues.length() > 1 ? tagValues.substring(0, tagValues.length() - 1) : tagValues}"
                               id="tagsInput">
                    </label>

                    <span style="margin-left: 15px; font-size: 12px; color: #ff3300">&nbsp;[多标签，请用逗号隔开]</span>
                </td>
            </tr>
            <tr>
                <th style="width: 90px"></th>
                <td colspan="2">
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
                <td><input id="updateProgramId" class="content-box-content_fixup_submit1"
                           style="margin-right:160px; padding-left: 0;"
                           type="button" value="提交"></td>
            </tr>
            </tbody>
        </table>
    </g:form>

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
