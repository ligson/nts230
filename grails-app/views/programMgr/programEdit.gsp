<%@ page import="nts.utils.CTools; nts.program.domain.Serial; nts.program.domain.Program" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>资源编辑</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'reset.css')}" type="text/css"
          media="screen"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'style_my.css')}" type="text/css"
          media="screen"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'proedit.css')}" type="text/css"
          media="screen"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" type="text/css"
          media="screen"/>

    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/isNum2.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/progedit.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/ckeditor', file: 'ckeditor.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/admin/Base64.js')}"></script>

    <r:require modules="swfupload,zTree,string"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/selectCategoryDialog.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/programMgr/bfUploadPoster.js')}"></script>
    <script type="text/javascript">
        //全局变量
        global.programId = ${program.id};
        global.classId = ${classLibId};
        global.usename = "${session?.consumer?.name?.encodeAsJavaScript()}";
        global.pwd = "${(application.authPrefix+session?.consumer?.name+application.authPostfix).encodeAsMD5().encodeAsJavaScript()}";

        global.uploadPath = "${application.uploadRootPath}/${session.consumer.name}/lib${classLibId}/";//路径：根路径/username/lib1/
        global.posterPath = "${application.uploadRootPath}/${session.consumer.name}/Img${classLibId}/";//海报路径
        global.videoSevr = "${application.videoSevr==''?request.serverName:application.videoSevr}";
        global.videoPort = "${application.videoPort}";
        global.uploadPort = "${application.uploadPort}";
        global.curUploadPath = global.uploadPath;//默认为不转码时路径

        global.transcodingPath = "${application.transcodingPath}/${session.consumer.name}/lib${classLibId}/";//路径：根路径/username/lib1/
        global.transcodingIp = "${application.transcodingIp==''?request.serverName:application.transcodingIp}";
        global.transcodingPort = "${application.transcodingPort}";


        global.tagName = "${Program.cnField.programTags}";
        global.resDescription = "${Program.cnField.description}";
        global.titleId = "${application.metaTitleId}";
        global.metaCreatorId = "${application.metaCreatorId}";

        var contentList = [];



    </script>
    <!--upload code end -->
    <style type="text/css">
    label {
        float: left;
    }

    select {
        width: 100px;
    }
    </style>
    <script src="${resource(dir: 'js', file: 'boful/programMgr/bfUploadEdit.js')}" type="text/javascript"></script>
    <script type="text/javascript">
        var uploadServerRootUrl = "http://" + global.videoSevr + ":" + global.videoPort + "/bmc";
        var uploadUrl = "http://" + global.videoSevr + ":" + global.videoPort + "/bmc/upload/uploadFile";
        var uploadPath = global.uploadPath;
        var posterPath = global.posterPath;
        $(function () {

            var pars = {uploadPath: posterPath};
            initbfUploadPoster(uploadServerRootUrl, uploadUrl, pars);

            $("#startUploadBtn").click(function () {
                bfUploadObject.startUpload();
            });

            var uploadDialog = $("#uploadDialog");
            uploadDialog.dialog({
                autoOpen: false,
                width: 500,
                height: 400,
                resizable: false,
                modal: true
            });
            var isInit = true;

            $("#showUploadDialogBtn").click(function () {
                uploadDialog.dialog("open");
            });

            $("#openUploadDialogBtn").click(function () {
                var pName = $("input[name=name]").val().trim();
                if (pName.isEmpty()) {
                    alert("名称不能为空！");
                    return false;
                }
                uploadDialog.dialog("open");
                if (isInit) {
                    var uId = "${session.consumer.id}";
                    var uName = "${session.consumer.name}";
                    var jId = "${session.id}";
                    var dirId = "${classLibId}";
                    var params = {uId: uId, uName: uName, jId: jId, dirId: dirId, pName: pName, uploadPath: uploadPath};
                    initBfUpload(uploadServerRootUrl, uploadUrl, params, null, null);
                    isInit = false;
                }
                return true;

            });

            var uploadDescDiv = $("#uploadDescDiv");
            uploadDescDiv.dialog({
                autoOpen: false,
                width: 500,
                height: 480,
                resizable: false,
                modal: true,
                buttons: {
                    "关闭": function () {
                        $(this).dialog("close");
                    }
                }
            });

        });
        function showWnd2(id) {
            $("#" + id).dialog("open");
        }
    </script>
</head>

<body>

<!-- Wrapper for the radial gradient background -->


<g:uploadForm controller="programMgr" action="programUpdate" name="form1" onsubmit="return check();">
<input type="hidden" name="svrAddress"
       value="${application.videoSevr == '' ? request.serverName : application.videoSevr}">
<input type="hidden" name="id" value="${program?.id}"/>
<input type="hidden" name="ddddid" value="${program?.id}"/>
<input type="hidden" name="schState" value="${params?.schState}"/>
<input type="hidden" name="schType" value="${params?.schType}"/>
<input type="hidden" name="schWord" value="${params?.schWord}"/>
<input type="hidden" name="max" value="${params?.max}"/>
<input type="hidden" name="offset" value="${params?.offset}"/>
<input type="hidden" name="sort" value="${params?.sort}"/>
<input type="hidden" name="order" value="${params?.order}"/>
<input type="hidden" name="fromModel" value="${params?.fromModel}"/>
<input type="hidden" name="oldClassLibId" value="${program.classLib.id}"/>

<div id="main-content"><!-- Main Content Section with everything -->
<div class="content-box"><!-- Start Content Box -->

<div class="content-box-header">

</div> <!-- End .content-box-header -->

<div class="content-box-content">

<div class="tab-content default-tab"
     id="tab11"><!-- This is the target div. id must match the href of this div's tab -->

<g:if test="${flash.message}">
    <div class="gblue gn pr30">${flash.message}</div>
</g:if>
<g:hasErrors bean="${program}">
    <div class="gblue gn pr30">
        <g:renderErrors bean="${program}" as="list"/>
    </div>
</g:hasErrors>

<table class="chose_class1">
    <tr style="border:none;">
        <td style="border:none; display: block;line-height: 33px;width: 140px;margin: 0; overflow: hidden; padding: 0">
            <label style="width:140px"><span style="color: red; ">*</span>选择类库：</label>
        </td>
        <td style="border:none; margin: 0">
            <g:select id="classLibId" name='classLibId' class="small-input" value="${program?.directory?.id}"
                      noSelection="${['0': '--请选择类库--']}" from='${directoryList}' optionKey="id" optionValue="name"
                      onChange="onClassChangeEdit(this);"/>
            <span style="color: red; margin-left: 20px">(轻易不要更改类库，可能会有数据丢失)</span></td>
    </tr>
</table>

<table class="chose_class1" id="wtab" style="border:none" cellpadding="0" cellspacing="0">
    <tr style="display:block;">
        <td width="140px;"><label for="name"><span style="color:#FF0000;font-weight:bold;">*</span>名称</label></td>
        <td><input class="text-input datepicker" name="name" type="text" maxlength="100" value="${program.name}"
                   id="name"></td>
        <td></td>
    </tr>
    <tr style="display:block;">
        <td width="140px;"><label for="name">资源分类</label></td>
        <td>
            <g:if test="${program?.programCategories && program?.programCategories.size() > 0}">
                <g:set var="categoryIds" value=""/>
                <g:set var="categoryNames" value=""/>
                <g:each var="programCategory" in="${program?.programCategories.toList()}">
                    <g:set var="categoryIds" value="${categoryIds + "," + programCategory?.id}"></g:set>
                    <g:set var="categoryNames" value="${categoryNames + "," + programCategory?.name}"></g:set>
                </g:each>
            </g:if>
            <input type="hidden" value="${categoryIds}" id="categoryId"
                   name="categoryId"/>
            <span id="categoryName">${categoryNames != "" ? categoryNames : '默认分类'}</span>
            <input type="button" value="选择分类" id="selectCategoryBtn"/>
        </td>
        <td></td>
    </tr>
</table>
<table class="chose_class2" id="wtab2" style="border:none" cellpadding="0" cellspacing="0">
<tr style="border:none; display: block ;height: 10px;"></tr>
<tr style="border:none; display: block; ">
    <td style="border:none; width: 100px;">
        <label>关键词/标签：</label>
    </td>
    <td style="border:none" colspan="2">
        <g:each in="${program.programTags}" var="tag" status="st">
            <label class="key_word1">
                <input class="text-input datepicker" type="text" maxlength="100" id="programTag${st}" name="programTag"
                       value="${tag.name}" style="width:70px;"/>
            </label>
        </g:each>
        <g:set var="i" value="0"/>
        <g:while test="${i.toInteger() < (8 - program?.programTags?.size())}">
            <label class="key_word1"><input class="text-input datepicker" type="text" maxlength="100"
                                            id="programTag${(i++) * 10}"
                                            name="programTag"
                                            value="" style="width:70px;"/>
            </label>
        </g:while>
    </td></tr>
<tr style="border:none; display: block; ">
    <td style="border:none; width: 100px;">
        <label>上传海报</label>
    </td>
    <td style="border:none" colspan="2">
        <span id="bfSelectPosterBtn" style="display: inline-block;float: left;"></span>
        <input type="" name="posterFile" id="posterFile">
    </td>
</tr>
<tr style="border:none; width:100%">
    <td colspan="2">
        <table>
            <tr>
                <td><label>上传文件：</label></td>
                <td>

                    浏览方式:<g:select from="${Serial.urlTypeName}" name="urlType" value=""
                                   onchange="onUrlTypeChange(this)" optionKey="key"
                                   optionValue="value"/>


                    <span id="imgOptSpan" style="display: none;">&nbsp;&nbsp;&nbsp;&nbsp;选项:
                        <label for="codeStateList1">选项:</label><input type="checkbox" id="codeStateList1"
                                                                      name="codeStateList"
                                                                      value="${Serial.OPT_IMG_POSTER}">海报
                    </span>

                    <span id="docOptSpan" style="display: none;">&nbsp;&nbsp;&nbsp;&nbsp;
                        <label for="codeStateList2">选项:</label><input type="checkbox" id="codeStateList2"
                                                                      name="codeStateList"
                                                                      value="${Serial.OPT_DOC_LIB}">文库
                    </span>

                    <span id="courseOptSpan" style="display: none;">&nbsp;&nbsp;&nbsp;&nbsp;
                        <label for="codeStateList3">选项:</label><input type="checkbox" id="codeStateList3"
                                                                      name="codeStateList"
                                                                      value="${Serial.OPT_ISO_VIRTUAL}">虚拟光驱
                    </span>

                    <input class="upload_but2" type="button" id="openUploadDialogBtn" value="上传文件">
                    <input class="upload_but2" type="button" id="showUploadDialogBtn" value="显示上传进度">

                    <input class="upload_but2" type="button" name="updescbtn" onClick="showWnd2('uploadDescDiv');"
                           style="padding:2px 4px !important"
                           value="上传说明">
                    <br>

                    <DIV id="linkDiv" class="bg" style="width:600px;display:none;margin:-130px 0 0 0;">
                        <DIV class="rg1"></DIV>

                        <DIV class="rg2"></DIV>

                        <DIV class="t1">链接</DIV>

                        <DIV class="bc">
                            <div><label for="linkRes">请输入链接地址：</label><input type="text" style="width:320px;"
                                                                             maxlength="300"
                                                                             id="linkRes" name="linkRes"
                                                                             value="http://"/>(请以http或其它协议头开始)</div>

                            <div><label for="linkTitle">请输入链接名称：</label><input type="text" style="width:100px;"
                                                                               maxlength="300"
                                                                               id="linkTitle" name="linkTitle"
                                                                               value=""/></div>

                            <div align="center" style="margin-top:7px;">
                                <input type="button" onclick="submitLink();" class="buttons"
                                       style="cursor:pointer;width:35px;"
                                       value="确定">&nbsp;
                                <input type="button" onclick="hideWnd('linkDiv');" class="buttons"
                                       style="cursor:pointer;width:40px;" value="关闭">
                            </div>
                        </DIV>

                        <DIV class="rg3"></DIV>

                        <DIV class="rg4"></DIV>
                    </DIV>

                </td>
            </tr>
        </table>
    </td>
</tr>
<tr style="border:none; display: block;height: 10px"></tr>
<tr style="border:none; display: block" class="prop">
    <td style="border:none" valign="top" width="100px">
        <label>从现有资源提取:</label>
    </td>
    <td style="border:none">
        <div id="materialSearch">
            ${Program.cnField.name}:<label>
            <input class="re_name2" type="text" maxlength="50" name="keyword1" style="width:100px;"
                   value="">
        </label>&nbsp;
            <input class="upload_but3" type="button" value="搜索"
                   onClick="showWnd('searchMaterialProgramList');${remoteFunction(action: 'searchMaterialProgram', update: [success: 'searchMaterialProgramList', failure: 'ohno'], params: '\'keyword=\'+encodeURIComponent(this.form.keyword1.value)')}">&nbsp;<input
                class="upload_but3" type="button" value="隐藏" name="b4"
                onClick="hideWnd('searchMaterialProgramList');">&nbsp;(先搜索，从搜索结果中选)<br>
            <g:render template="searchMaterialProgramList"
                      model="[programList: programList, total: total, keyword: keyword]"/>
        </div>

    </td>
</tr>
<tr style="border:none; display: block;height: 10px"></tr>
<tr style="border:none; display: block" class="prop ">
    <td style="border:none;width: 100px" valign="top"><label>资源类型：</label></td>
    <td style="border:none">
        <label class="tx_cor">
            <select name="otherOption">
                <option value="0" ${(program.otherOption & 0) == 0 ? "selected" : ""}>默认</option>
                <option value="8" ${(program.otherOption & 8) == 8 ? "selected" : ""}>纯文档(文库)</option>
                <option value="16" ${(program.otherOption & 16) == 16 ? "selected" : ""}>纯图片</option>
                <option value="32" ${(program.otherOption & 32) == 32 ? "selected" : ""}>纯链接</option>
                <option value="128" ${(program.otherOption & 128) == 128 ? "selected" : ""}>开放课程</option>
            </select>（如果是纯文档、纯图片、纯链接，请选择对应类型，以便直接到相关页面，否则要先到点播页面再点击打开。）
        </label>
    </td>
</tr>
<tr style="border:none; display: block; height: 10px"></tr>
<tr id="serialsTR" style="border:none; display: block">
    <td style="border:none; width: 100px" valign="top">
        <label>${Program.cnField.serials}:</label>
    </td>
    <td style="border:none">
        <g:render template="serialList" model="[program: program]"/>
    </td>
</tr>

<tr class="prop" style="border:none; display: block">
    <td style="border:none; width: 100px">
        <label>是否允许:</label>
    </td>
    <td style="border:none">
        <label>
            <input type="checkbox" name="canDownload" value="true" ${program.canDownload ? "checked" : ""}>
            允许下载&nbsp;
        </label>
        <g:if test="${application.distributeModState == 1}">
            <label>
                <input type="checkbox" name="otherOptionList"
                       value="${Program.REAP_OBJ_OPTION}" ${(program.otherOption & Program.REAP_OBJ_OPTION) == Program.REAP_OBJ_OPTION ? "checked" : ""}>
                允许收割对象&nbsp;
            </label>
        </g:if>
    </td>
</tr>
<tr class="prop" style="border:none; display: block">
    <td style="border:none">
        <label>设置推荐数目:</label>
    </td>
    <td style="border:none">
        <label class="tex_cor2">
            <input type="text" name="recommendNum" value="${program.recommendNum}">
            (数目越大按推荐排序可以排到前面，如首页图片滚动栏)&nbsp;
        </label>
    </td>
</tr>

<tr class="prop" style="border:none; display: block">
    <td style="border:none">
        <label>分发范围:</label>
    </td>
    <td style="border:none">
        %{--<label>
            <input type="checkbox" name="canDistribute"
                   value="true" ${program.canDistribute ? "checked" : ""}>
            分发到下级节点&nbsp;
        </label>
        <label>
            <input type="checkbox" name="canUnion" value="true" ${program.canUnion ? "checked" : ""}>
            分发到联盟节点&nbsp;
        </label>--}%
        <label>
            <input type="checkbox" name="canPublic" value="true" ${program.canPublic ? "checked" : ""}>
            公开&nbsp;
        </label>
    </td>
</tr>
<tr style="border:none; display: block;height: 10px"></tr>
<tr class="prop" style="border:none; display: block">
    <td colspan="2" style="border:none">
        <label>${Program.cnField.description}:<span style="padding-left:40px;font-weight:normal">
            <input type="radio" onclick="setDescType(0);" id="descOpt_0" name="descOpt"
                   value="0" ${isRichText ? "" : "checked"}>普通文本框&nbsp;
            <input type="radio" onclick="setDescType(1);" id="descOpt_1" name="descOpt"
                   value="1" ${isRichText ? "checked" : ""}>富文本编辑框(如果要设置字体大小或颜色等，请选择富文本编辑框)</span></label>
    </td>
</tr>
<tr style="border:none; display: block;height: 10px"></tr>
<tr class="prop">
    <td colspan="2" style="border:none">
        <div id="descDiv0" style="display: ${isRichText ? "none" : "block"}">
            <label>
                <textarea cols="80" id="description0" name="description0"
                          rows="10">${CTools.htmlToBlank(program?.description)}</textarea>
            </label>
        </div>

        <div id="descDiv1" style="display: ${isRichText ? "block" : "none"}">
            <label>
                <textarea cols="80" id="description1" name="description1" rows="10"
                          style="background:#FFF;">${CTools.htmlToBlank(program?.description)}</textarea>
            </label>
            <script type="text/javascript">
                //<![CDATA[
                CKEDITOR.replace('description1');
                //]]>
            </script>
        </div>
    </td>
</tr>
<tr style="border:none; display: block; height: 10px"></tr>
<tr class="prop" style="border:none; display: block">
    <td colspan="2" style="border:none">
        <label>${Program.cnField.consumer}:${program.consumer.name}&nbsp;&nbsp;${Program.cnField.dateCreated}:<g:formatDate
                format="yyyy-MM-dd"
                date="${program?.dateCreated}"/>&nbsp;&nbsp;${Program.cnField.dateModified}:<g:formatDate
                format="yyyy-MM-dd" date="${program?.dateModified}"/></label>
    </td>

</tr>
</table>

<div style="border:none; display: block; height: 31px; width:800px;overflow: hidden">
    <div style="border:none; height:31px;width:220px; display: block; float: right">
        <input style="float: left;" class="qqbut" type="submit" value="保存">
        <input style="float: left;" class="qqbut" type="button" value="关闭"
               onclick="window.opener = null;
               window.open('', '_self', '');
               window.close();">
    </div>
</div>

</div> <!-- End #tab1 -->
</div> <!-- End .content-box-content -->
</div> <!-- End .content-box -->
</div> <!-- End #main-content -->
</g:uploadForm>
<g:render template="editSerial" model="[serial: serial]"/>
<g:render template="editMaterial" model="[program: null]"/>
<g:render template="subtitleList" model="[serial: serial]"/>
<g:render template="editSubtitle" model="[serial: serial]"/>


<div id="uploadDialog" title="上传文件" style="display:none;">
    <p>
        <span id="bfSelectFileBtn" style="display: inline-block;float: left;"></span>
        <input type="button" id="startUploadBtn" value="开始上传" style="float: right;"/>
    </p>
    <table id="fileProgressMonitor" width="100%">
        <tr style="background:#c0c0c0;line-height:30px;text-align:center;">
            <td>标题</td><td>大小</td><td>状态</td><td>进度</td><td>操作</td>
        </tr>
    </table>
</div>


<DIV id="uploadDescDiv" class="bg" style="display:none;" title="上传说明">
    <div>
        <div style="line-height:18px;">
            <span style="font-weight: bold;">一.上传方式说明：</span><br>
            &nbsp;1.文件：适用于各种视音频文件(ASF,WMV,RM,MP3等)、文档(WORD,PPT,EXCEL,PDF等),图<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;片(jpg,gif,png等)、课件(rar,exe等,但不包括三分屏);<br>
            &nbsp;2.目录：适用于可以用浏览器打开的在线课件，如三分屏等;<br>
            &nbsp;3.光盘：适用于光盘,如果是视音频文件，浏览方式请选择在线点播；如果是ISO文件等<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;格式，浏览方式请选择下载;<br>
        </div>

        <div style="line-height:18px;">
            <span style="font-weight: bold;">二.浏览方式说明：</span><br>
            &nbsp;1.在线点播：适用于各种视音频文件，如ASF,WMV,RM,MP3等;<br>
            &nbsp;2.下载：下载到本地，如各种RAR，EXE，ISO文件等;ISO文件会自动加载到虚拟光驱进行<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;播放;<br>
            &nbsp;3.图片浏览：适用于各种图片，如JPG,GIF,PNG等;<br>
            &nbsp;4.海报图片：适用于用作海报的图片，如电影海报等;<br>
            &nbsp;5.文档：适用于各种文档，如WORD,PPT,EXCEL,PDF等;<br>
            &nbsp;6.在线课件：适用于可以用浏览器打开的课件，如三分屏等;<br>
            &nbsp;7.确然课件：适用于确然课件系统制作的课件，如确然的三分屏课件;<br>
            &nbsp;8.链接：适用于浏览器打开的各种链接，如http链接,不用上传,故上传方式任选都行;<br>
        </div>
    </div>
</DIV>

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
