<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 13-12-21
  Time: 下午12:33
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>资源上传</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'createProgram.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <r:require modules="swfupload"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/my_createProgram.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/bfUploadProgram.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/fileType.js')}"></script>
    %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/progedit.js')}"></script>--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/bfUploadProgramPoster.js')}"></script>
</head>

<body>

<input type="hidden" id="uId" value="${session?.consumer?.id}">
<input type="hidden" id="uName" value="${session?.consumer?.name}">
<input type="hidden" id="jId" value="${session?.id}">
<input type="hidden" id="dirId" value="">
<input type="hidden" id="role" value="${session?.consumer?.role}">
<!--  上传路径  -->
<input type="hidden" name="uploadPath" id="uploadPath" value=""/>
<g:form controller="programMgr" action="programSave"  name="formPro" method="post">
    <input id="maxSpaceSize" value="${session?.consumer.maxSpaceSize}" type="hidden"/>
    <input id="useSpaceSize" name="useSpaceSize" value="${session?.consumer.useSpaceSize}" type="hidden"/>
    <!--文件个数-->
    <input type="hidden" name="fileCount" value=""/>
    <!--确认资源是否上传完成-->
    <input type="hidden" id="isFlag" value="1">
    <!--  元数据标准  -->
    <input type="hidden" id="classLibId" name="classLibId" value=""/>
    ${flash.saveMes}
    <table id="tb" class="table table-h resources_upload_infor" width="100%" cellpadding="0" cellspacing="0">
        <tbody>
        <tr>
            <th style="width: 120px"><span class="name_warning">*&nbsp;</span>资源名称</th>
            <td>
                <label>
                    <input maxlength="400" id="name" name="name" type="text"
                           class="resources_upload_title widt admin_default_inp"
                           value="${params.program?.name}"/>
                </label>

            </td>
            <td><span class="name_warning re-dis warning_size">&nbsp;[可输入200字]</span></td>
        </tr>
        %{--<tr><th style="width: 120px"><span class="name_warning">*&nbsp;</span>选择类库</th>
            <td><label>
                <select class="resources_upload_chose" id="classLib.id" name='classLibId' onchange="queryuploadPath()">
                    <g:each in="${directoryList}" var="directory">
                        <option value="${directory.id}">${directory.name}</option>
                    </g:each>
                </select>
                <div style="display: none">
                    <g:each in="${directoryList}" var="directory">
                        <div id="directory_${directory.id}">${directory?.uploadPath}</div>
                    </g:each>
                </div>
            </label></td>
        </tr>--}%
        <tr>
            <th style="width: 120px"><span class="name_warning">*&nbsp;</span>选择类别</th>
            <td>
                <input type="button" id="selectCategoryBtn" class="resources_upload_chose_but" value="选择分类">
                <input type="button" id="clearCategoryBtn" class="resources_upload_chose_but" value="清除所选分类">

            </td>
            <td><span class="name_warning warning_size">&nbsp;[点击选择分类,&nbsp;可多选;&nbsp;&nbsp;默认分类中资源前台不显示]</span></td>

        </tr>
        <tr>
            <th></th>
            <td>
                <input type="hidden" name="categoryId" id="categoryId" autocomplete="off">
                <span id="categoryName" name="categoryName"></span>
            </td>
        </tr>

        <tr id="factedTr" style="display: none">
            <th style="width: 120px">选择分面</th>
            <td>
                <table id="factedTb" class="resources_upload_infor" width="100%" cellpadding="0"
                       cellspacing="0"></table>
            </td>
        </tr>
        <tr>
            <th style="width: 120px"><span class="name_warning">*&nbsp;</span>是否公开</th>
            <td>
                <g:radio name="canPublic" value="true"/>是&nbsp;
                <g:radio name="canPublic" value="false" checked="true"/>否
            </td>
        </tr>
        <tr>
            <th style="width: 120px"><span class="name_warning">*&nbsp;</span>浏览方式</th>
            <td>
                <g:select name="otherOption" class="se_mgr"
                          from="${[0: '视频', 1: '音频', 8: '纯文档(文库)', 16: '纯图片', 128: '课程', 6: 'flash动画']}"
                          optionKey="key" optionValue="value" onchange="queryMediaType()"/>
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
                <span style="margin-left: 20px; font-size: 12px; color: #E35804">格式类型</span>
            </td>
        </tr>
        <tr>
            <th style="width: 90px; text-align: right">推荐数</th>
            <td colspan="2">
                <input type="text" id="recommendNumId" class="form-control" style="width: 100px;"
                       name="recommendNum" />
            </td>
        </tr>
        <tr>
            <th style="width: 90px; text-align: right">海报截图</th>
            <td colspan="2">
                <input type="hidden" name="posterHash" id="posterHash" value="">
                <input type="hidden" name="posterPath" id="posterPath" value="">
                <input type="hidden" name="posterName" id="posterName" value="">
                <input type="button" id="replacePoster" class="resources_upload_chose_but" value="上传横版海报">
                <span id="showPosterName"></span>
            </td>
        </tr>
        <tr>
            <th style="width: 90px; text-align: right"></th>
            <td colspan="2">
                <input type="hidden" name="verticalPosterHash" id="verticalPosterHash" value="">
                <input type="hidden" name="verticalPosterPath" id="verticalPosterPath" value="">
                <input type="hidden" name="verticalPosterName" id="verticalPosterName" value="">
                <input type="button" id="replaceVerticalPoster" class="resources_upload_chose_but" value="上传竖版海报">
                <span id="showVerticalPosterName"></span>
            </td>
        </tr>
        <tr>
            <th style="width: 120px">标&nbsp;&nbsp;签</th>
            <td>
                <label>
                    <input type="text" id="programTagInput" class="resources_upload_key widt admin_default_inp">
                </label>
                <input type="hidden" name="programTag" value=""/>

            </td>
            <td><span class="name_warning warning_size">&nbsp;[多标签，请用逗号隔开]</span></td>
        </tr>
        <tr>
            <th></th>
            <td id="tagShow">
            </td>
        </tr>
        <tr>
            <th style="width: 120px">资源描述</th>
            <td><label>
                <textarea type="text" name="description" id="description"
                          class="resources_describe widt hidt admin_default_inp"
                          rows="3"></textarea>
            </label>
        </tr>
        <tr>
            <th style="width: 120px">上传资源</th>
            <td><input class="resources_upload_buttom" type="button" id="bfSelectFileBtn" value="上传资源"></td>
        </tr>
        <tr id="maxSizeTr" style="display: none;">
            <th style="width: 120px">空间容量</th>
            <td id="maxSizeTd"></td>
        </tr>
        <tr id="useSizeTr" style="display: none;">
            <th style="width: 120px">已用空间</th>
            <td id="useSizeTd"></td>
        </tr>
        </tbody>
    </table>

    <div class="resources_upload_lists">
        <input type="button" class="resources_upload_save" id="saveBtn" style="margin-left: 40%;" value="保存">
    </div>


</g:form>
<div id="selectCategoryDialog" class="bg" style="display:none;" title="选择分类">
    <div>
        <input type="hidden" id="selectedCategoryId" value="" autocomplete="off"/>
        <input type="hidden" id="selectedCategoryName" value="" autocomplete="off"/>
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