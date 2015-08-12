<%@ page import="nts.program.domain.Serial; nts.program.domain.Program" %>
<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta name="layout" content="main"/>
<title>节目制作</title>
<link href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}" rel="stylesheet" type="text/css">
<link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/truevod.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/isNum2.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/userspace/progedit.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/meta.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/metalist.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'ckeditor.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/admin/Base64.js')}"></script>


<SCRIPT LANGUAGE="JavaScript">
    <!--
    //全局变量
    global.programId = 0;
    global.classId = ${classLibId};

    global.uploadPath = "${application.uploadRootPath}/${session.consumer.name}/lib${classLibId}/";//路径：根路径/username/lib1/

    global.videoSevr = "${application.videoSevr==''?request.serverName:application.videoSevr}";
    global.videoPort = "${application.videoPort}";
    global.tagName = "${Program.cnField.programTags}";
    global.resDescription = "${Program.cnField.description}";

    var imgDialog = null;//富文本图片对话框对象
    var metaList = new Array();//当前类
    //初始化
    window.onload = init;
    function init() {
        setCurMetaList(global.classId, -1, -1);
        showAllTr();

    }

    //初始化时显示所有元素列表，重复条目下拉框，设置行数下拉框
    function showAllTr() {
        var i, iRow, iRow2;
        var curClassid = global.classId;
        iRow = 0;
        iRow2 = 0;

        for (i = 0; i < metaList.length; i++) {
            if (metaList[i].parentId == 0) {
                if (showTr(iRow, i) == false)
                    continue;
                iRow++;
            }
        }
    }


    //对象URL类型数（当前只有视音频0，课件1，图片2 在线课件4）海报图片 3

    UPLoginDirect('${session?.consumer?.name?.encodeAsJavaScript()}', '${(application.authPrefix+session?.consumer?.name+application.authPostfix).encodeAsMD5().encodeAsJavaScript()}');

    function openFile(type) {
        var uploadTypeObj = document.form1.uploadType;
        var uploadType = uploadTypeObj.value;
        var urlTypeObj = document.form1.urlType;
        var uploadPath = global.uploadPath.replace(/\/\//g, '/');

        //字幕上传1000
        if (type == 1000) {
            form1.UpLoad1.IsMultiFile = 0;
            form1.UpLoad1.SavePath = uploadPath;
            document.form1.isSubtitleUpload.value = 1;
            document.form1.isRichTextUpload.value = 0;
            form1.UpLoad1.OpenFile();
            return;
        }
        //富文本上传2000
        else if (type == 2000) {
            form1.UpLoad1.IsMultiFile = 0;
            form1.UpLoad1.SavePath = uploadPath;
            document.form1.isSubtitleUpload.value = 0;
            document.form1.isRichTextUpload.value = 1;
            form1.UpLoad1.OpenAndUpload();
            return;
        }

        document.form1.isSubtitleUpload.value = 0;//非字幕上传重置，以免上传完事件中误用类型处理。
        document.form1.isRichTextUpload.value = 0;//非字幕上传重置，以免上传完事件中误用类型处理。

        if (urlTypeObj.value == -1) {
            alert("请选择正确的浏览方式或查看上传说明。");
            return;
        }

        //链接
        if (urlTypeObj.value == global.urlType.LINK) {
            onUrlTypeChange(urlTypeObj);
            return;
        }

        if (uploadType == 'file') {
            //海报
            if (urlTypeObj.value == global.urlType.POSTER)
                form1.UpLoad1.IsMultiFile = 0;
            else
                form1.UpLoad1.IsMultiFile = 1;
        }
        else if (uploadType == 'dir') {
            form1.UpLoad1.IsMultiFile = 2;
        }
        else if (uploadType == 'disk') {
            form1.UpLoad1.IsMultiFile = 300;
        }
        else {
            return;
        }

        form1.UpLoad1.SavePath = uploadPath;
        form1.UpLoad1.OpenFile();
    }

    function uploadFiles(uploadType) {
        var uploadTypeObj = document.form1.uploadType;
        var uploadType = uploadTypeObj.value;

        if (uploadType == 'disk') {
            form1.UpLoad1.IsMultiFile = 1;
        }

        form1.UpLoad1.UploadFiles2();

        return true;
    }

    function deleteSerial() {
        if (!hasChecked('idList')) {
            alert("请至少选择一条记录。");
            return;
        }
        var idList = getListStr("idList");
        new Ajax.Updater({success: 'serialList', failure: 'error'}, '<g:createLink action="deleteSerial" />', {asynchronous: true, evalScripts: true, parameters: 'program.id=' + global.programId + '&idList=' + idList});
    }

    //设置相关节目,与edit页面不同，不是远程设置
    function setRelationProgram(id, name) {
        if (form1.relation.value == "") {
            form1.relation.value = id;
            form1.showRelation.value = name;
        }
        else {
            form1.relation.value += ',' + id;
            form1.showRelation.value += ',' + name;
        }
    }

    function onClassChange(theObj) {
        if (theObj.value < 1) {
            alert("请选择类库");
            document.getElementById("mainDiv").style.display = "none";
            return;
        }
        self.location.href = "create2?classLib.id=" + theObj.value;
    }

    function onUploadTypeChange(theObj) {
        //链接类型
        if (theObj.value == 'link') {
            showWnd('linkDiv');
            form1.linkRes.focus();

            //焦点移到文本后面
            var linkObj = document.getElementById('linkRes');
            var range = linkObj.createTextRange(); //建立文本选区
            range.moveStart('character', linkObj.value.length); //选区的起点移到最后去
            range.collapse(true);
            range.select();
        }
        else {
            hideWnd('linkDiv');
        }
    }

    function onUrlTypeChange(theObj) {
        //链接类型
        if (theObj.value == global.urlType.LINK) {
            showWnd('linkDiv');
            form1.linkRes.focus();

            //焦点移到文本后面
            var linkObj = document.getElementById('linkRes');
            var range = linkObj.createTextRange(); //建立文本选区
            range.moveStart('character', linkObj.value.length); //选区的起点移到最后去
            range.collapse(true);
            range.select();
        }
        else {
            hideWnd('linkDiv');
        }
    }

    function submitLink() {
        var link = Jtrim(form1.linkRes.value);
        var title = Jtrim(form1.linkTitle.value);
        if (link.length < 10) {
            alert("请正确输入链接地址。");
            form1.linkRes.focus();
            return;
        }

        if (title.length < 1) {
            alert("请输入链接名称。");
            form1.linkTitle.focus();
            return;
        }

        //序号*文件名*文件路径*格式类型*时长*码率
        var fileInfo = "1*" + title + "*" + link + "*0*0*0|";

        new Ajax.Updater({success: 'serialList', failure: 'error'}, '<g:createLink controller="program" action="dealUpload" />', {asynchronous: true, evalScripts: true, parameters: 'program.id=' + global.programId + '&urlType=' + form1.urlType.value + '&filePath=' + encodeURIComponent(fileInfo)});
        document.getElementById("serialsTR").style.display = "block";
        //hideWnd('linkDiv');
    }


    //-->
</SCRIPT>

<!--upload code start -->
<SCRIPT for="UpLoad1" event="OnOpenFile(name,size)" LANGUAGE="JavaScript">
    var isSubtitle = document.form1.isSubtitleUpload.value == 1;
    var isRichText = document.form1.isRichTextUpload.value == 1;

    if (isSubtitle) {
        //form1.showPath.value="您选择了"+size+"个文件";
        document.editSubtitleForm.upbtn.disabled = false;
    }
    else if (isRichText) {
        //不用处理
    }
    else {
        form1.showPath.value = "您选择了" + size + "个文件";
        form1.upbtn.disabled = false;
    }
</SCRIPT>
<SCRIPT for="UpLoad1" event="OnUpFinished()" LANGUAGE="JavaScript">
    //序号*文件名*文件路径*格式类型*时长*码率
    var fileInfo = form1.UpLoad1.DstFileName;
    var urlType = form1.urlType.value;
    var uploadType = document.form1.uploadType.value;
    var isSubtitle = document.form1.isSubtitleUpload.value == 1;
    var isRichText = document.form1.isRichTextUpload.value == 1;

    if (isSubtitle) {
        document.editSubtitleForm.filePath.value = fileInfo;
        //alert("字幕已上传到:"+fileInfo);
    }
    else if (isRichText) {
        var txtUrlCont = imgDialog.getContentElement('info', 'txtUrl');
        var txtUrlId = txtUrlCont.getInputElement().$.id;
        ;
        var txtUrlObj = document.getElementById(txtUrlId);

        txtUrlObj.value = getImgAddr(fileInfo);
        txtUrlObj.fireEvent("onchange"); //触发url文本框的onchange事件，以便预览图片
    }
    else if (urlType == global.urlType.POSTER) {
        fileInfo = "1*海报*" + fileInfo + "*0*0*0|";
    }
    else if (uploadType == 'dir') {
        fileInfo = "1*课件*" + fileInfo + "/" + form1.UpLoad1.SetupFile + "*0*0*0|";
    }

    if (!isSubtitle && !isRichText) new Ajax.Updater({success: 'serialList', failure: 'error'}, '<g:createLink controller="program" action="dealUpload" />', {asynchronous: true, evalScripts: true, parameters: 'program.id=' + global.programId + '&urlType=' + urlType + '&filePath=' + encodeURIComponent(fileInfo)});
    document.getElementById("serialsTR").style.display = "block";
</SCRIPT>
<!--upload code end -->

</head>

<body>

<div class="body2" id="bodyDiv2">
<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>

<div class="addClip">资源上传</div>

<div class="message">说明：如果要管理资源,管理员请到后台管理->资源管理中进行;普通用户请到个人空间->我的资源->资源管理中进行。已审核通过的资源只有管理员才能管理。</div>
<g:form action="save" method="post" name="form1" onsubmit="return check();">
<input type="hidden" name="svrAddress"
       value="${application.videoSevr == '' ? request.serverName : application.videoSevr}">
<input type="hidden" name="canPlay" value="true">
<input type="hidden" name="canAllPlay" value="true">
<input type="hidden" name="canAllDownload" value="true">
<input type="hidden" name="isSubtitleUpload" value="0"/>
<input type="hidden" name="isRichTextUpload" value="0"/>
<input type="hidden" name="fromWeb" value="create2"/>

<div id="selLib">选择类库：<g:select id="classLib.id" name='classLib.id' value="${classLibId}"
                                noSelection="${['0': '--请选择类库--']}" from='${directoryList}' optionKey="id"
                                optionValue="name" onChange="onClassChange(this);"></g:select>&nbsp;(必须先选择类库后，方能上传)
    <span style="width:80px;"></span>
    显示：<input type="radio" onclick="setShowType(0);" id="showOpt_0" name="showOpt" value="0" checked>显示缺省
    <input type="radio" onclick="setShowType(1);" id="showOpt_1" name="showOpt" value="1">显示所有
</div>
<g:if test="${flash.saveMessage}">
    <div class="message">${flash.saveMessage}</div>
</g:if>
<g:hasErrors bean="${program}">
    <div class="errors">
        <g:renderErrors bean="${program}" as="list"/>
    </div>
</g:hasErrors>
<div id="mainDiv" style="display:${classLibId > 0 ? 'block' : 'none'}">
    <div class="dialog">
        <table id="clipEdit2">
            <tbody>

            <tr class="prop">
                <td class="name" colspan="2" style="padding-left:0px;">
                    <table id="wtab" style="border:0px;padding-left:0px;" border="0">
                    </table>
                </td>
            </tr>


            <tr class="prop">
                <td class="name">
                    <label for="programTags">${Program.cnField.programTags}:</label>
                </td>
                <td class="value">
                    <input class="tag" type="text" maxlength="100" id="programTag" name="programTag" value=""/>
                    <input class="tag" type="text" maxlength="100" id="programTag" name="programTag" value=""/>
                    <input class="tag" type="text" maxlength="100" id="programTag" name="programTag" value=""/>
                    <input class="tag" type="text" maxlength="100" id="programTag" name="programTag" value=""/>
                    <input class="tag" type="text" maxlength="100" id="programTag" name="programTag" value=""/>
                </td>
            </tr>

            <tr class="prop">
                <td class="name">
                    <label for="directory">上传文件:</label>
                </td>
                <td class="value2">
                    上传方式：
                    <select name="uploadType" onchange="onUploadTypeChange(this)">
                        <option value="file">文件</option>
                        <option value="dir">目录</option>
                        <option value="disk">光盘</option>
                    </select>
                    浏览方式：<g:select from="${Serial.urlTypeName}" noSelection="${['-1': '-请选择-']}"
                                   name="urlType" value="" onchange="onUrlTypeChange(this)" optionKey="key"
                                   optionValue="value"></g:select>
                    <input type="button" value="浏览" name="b4" style="width:40px;" onClick="openFile(-1);">
                    <input type="button" name="upbtn" onClick="uploadFiles(-1);" disabled style="width:40px;"
                           value="上传">
                    <input type="button" name="updescbtn" onClick="showWnd('uploadDescDiv');"
                           style="width:70px;cursor:pointer;" value="上传说明">
                    &nbsp;消息：<input type="text" maxlength="100" id="showPath" name="showPath" value=""/>
                    <br>

                    <DIV id="linkDiv" class="bg" style="width:600px;display:none;margin:-130px 0px 0px 0px;">

                        <DIV class="rg1"></DIV>

                        <DIV class="rg2"></DIV>

                        <DIV class="t1">链接</DIV>

                        <DIV class="bc">
                            <div>请输入链接地址：<input type="text" style="width:320px;" maxlength="300" id="linkRes"
                                                name="linkRes" value="http://"/>(请以http或其它协议头开始)</div>

                            <div>请输入链接名称：<input type="text" style="width:100px;" maxlength="300" id="linkTitle"
                                                name="linkTitle" value=""/></div>

                            <div align="center" style="margin-top:7px;">
                                <input type="buttom" onclick="submitLink();" style="cursor:pointer;width:40px;"
                                       value="确定">&nbsp;<input type="buttom" onclick="hideWnd('linkDiv');"
                                                               style="cursor:pointer;width:40px;" value="关闭">
                            </div>
                        </DIV>

                        <DIV class="rg3"></DIV>

                        <DIV class="rg4"></DIV>
                    </DIV>

                    <br>

                    <DIV id="uploadDescDiv" class="bg" style="width:500px;display:none;margin:-180px 0px 0px 0px;">

                        <DIV class="rg1"></DIV>

                        <DIV class="rg2"></DIV>

                        <DIV class="t1">上传说明</DIV>

                        <DIV class="bc">
                            <div>
                                <div style="line-height:18px;">
                                    <b>一.上传方式说明：</b><br>
                                    &nbsp;1.文件：适用于各种视音频文件(ASF,WMV,RM,MP3等)、文档(WORD,PPT,EXCEL,PDF等),图<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;片(jpg,gif,png等)、课件(rar,exe等,但不包括三分屏);<br>
                                    &nbsp;2.目录：适用于可以用浏览器打开的在线课件，如三分屏等;<br>
                                    &nbsp;3.光盘：适用于光盘,如果是视音频文件，浏览方式请选择在线点播；如果是ISO文件等<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;格式，浏览方式请选择下载;<br>
                                </div>

                                <div style="line-height:18px;">
                                    <b>二.浏览方式说明：</b><br>
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

                            <div align="center" style="margin-top:7px;">
                                <input type="buttom" onclick="hideWnd('uploadDescDiv');"
                                       style="cursor:pointer;width:40px;" value="关闭">
                            </div>
                        </DIV>

                        <DIV class="rg3"></DIV>

                        <DIV class="rg4"></DIV>
                    </DIV>

                </td>
            </tr>

            <tr class="prop">
                <td class="fromMaterial">
                    <label for="directory">从现有资源提取:</label>
                </td>
                <td class="value3">
                    <div id="materialSearch">
                        ${Program.cnField.name}:<input type="text" maxlength="50" name="keyword1" style="width:100px;"
                                                       value="">&nbsp;
                        <input type="button" value="搜索" style="width:40px;"
                               onClick="showWnd('searchMaterialProgramList');${remoteFunction(action: 'searchMaterialProgram', update: [success: 'searchMaterialProgramList', failure: 'ohno'], params: '\'keyword=\'+encodeURIComponent(this.form.keyword1.value)')}">&nbsp;<input
                            type="button" value="隐藏" name="b4" style="width:40px;"
                            onClick="hideWnd('searchMaterialProgramList');">&nbsp;(先搜索，从搜索结果中选)<br>
                        <g:render template="searchMaterialProgramList"
                                  model="[programList: programList, total: total, keyword: keyword]"/>
                    </div>

                </td>
            </tr>

            <tr class="prop" id="serialsTR" style="display:none">
                <td valign="top" class="name">
                    <label for="serials">${Program.cnField.serials}:</label>
                </td>
                <td valign="top">
                    <g:render template="serialList" model="[program: program]"/>
                </td>
            </tr>

            <tr class="prop">
                <td valign="top" style="padding-top:18px;" class="name">
                    <label for="description">相关${Program.cnTableName}:</label>
                </td>
                <td style="padding-top:11px;" class="value ${hasErrors(bean: program, field: 'description', 'errors')}">
                    <input type="hidden" id="relation" name="relation" value=""/>
                    <input type="text" style="width:300px;" maxlength="400" id="showRelation" readonly
                           name="showRelation" value=""/>
                    <input type="button" value="设置" name="b4" style="width:40px;"
                           onClick="$(relationSearch).style.display = 'block';"><br>

                    <div id="relationSearch" style="display:none">
                        ${Program.cnField.name}:<input type="text" maxlength="50" name="keyword" value="">&nbsp;
                        <input type="button" value="搜索" name="b4" style="width:40px;"
                               onClick="showWnd('searchRelationProgramList');${remoteFunction(action: 'searchRelationProgram', update: [success: 'searchRelationProgramList', failure: 'ohno'], params: '\'keyword=\'+encodeURIComponent(this.form.keyword.value)')}">&nbsp;<input
                            type="button" value="隐藏" name="b4" style="width:40px;"
                            onClick="hideWnd('searchRelationProgramList');">&nbsp;(先搜索，从搜索结果中设置相关节目)<br>
                        <g:render template="searchRelationProgramList"
                                  model="[programList: programList, total: total, keyword: keyword]"/>
                    </div>
                </td>
            </tr>

            <tr class="prop">
                <td class="name">
                    <label for="description">是否允许:</label>
                </td>
                <td class="value ${hasErrors(bean: program, field: 'canDownload', 'errors')}">
                    <input type="checkbox" name="canDownload" value="true" checked>允许下载&nbsp;
                    <g:if test="${application.distributeModState == 1}">
                        <input type="checkbox" name="canDistribute" value="true" checked>允许分发&nbsp;
                        <input type="checkbox" name="otherOptionList" value="${Program.REAP_OBJ_OPTION}">允许收割对象&nbsp;
                    </g:if>
                </td>
            </tr>

            <tr class="prop">
                <td colspan="2">
                    <label for="description">${Program.cnField.description}:</label>
                </td>
            </tr>
            <tr class="prop">
                <td colspan="2">
                    <textarea cols="80" id="description" name="description" rows="10"></textarea>
                    <script type="text/javascript">
                        //<![CDATA[
                        CKEDITOR.replace('description');
                        //]]>
                    </script>
                </td>
            </tr>

            </tbody>
        </table>

    </div>

    <div class="buttons">
        <span class="button"><input class="save" type="submit" value="保存"/></span>
    </div>
    <object classid="clsid:FDE4893B-A43E-4ec4-9119-1C214BF69E51" id="UpLoad1" width="0" height="0">
        <param name="Port" value="${application.uploadPort}">
        <param name="ServIPAddr" value="${application.videoSevr == '' ? request.serverName : application.videoSevr}">
        <param name="SrcFileName" value="">
        <param name="DstFileName" value="">
        <param name="IsMultiFile" value="1">
        <param name="SavePath" value=''>
        <param name="LimitFileExt" value=''>
        <param name="SaveType" value="800">
    </object>
</div>
</g:form>
<g:render template="editSerial" model="[serial: null]"/>
<g:render template="editMaterial" model="[program: program]"/>
<g:render template="subtitleList" model="[serial: serial]"/>
<g:render template="editSubtitle" model="[serial: serial]"/>

</div>
</body>
</html>
