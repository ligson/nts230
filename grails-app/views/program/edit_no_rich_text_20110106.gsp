<%@ page import="nts.program.domain.Serial; nts.program.domain.Program; nts.meta.domain.MetaContent" %>
<html>
<head>

<title>Edit nts.program.domain.Program</title>
<link href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}" rel="stylesheet" type="text/css">
<link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" rel="stylesheet" type="text/css">

<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/prototype.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/truevod.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/isNum2.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/userspace/progedit.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/meta.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/metalist.js')}"></script>

<SCRIPT for="UpLoad1" event="OnOpenFile(name,size)" LANGUAGE="JavaScript">
    var isSubtitle = document.form1.isSubtitleUpload.value == 1;
    if (isSubtitle) {
        //form1.showPath.value="您选择了"+size+"个文件";
        document.editSubtitleForm.upbtn.disabled = false;
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

    if (isSubtitle) {
        document.editSubtitleForm.filePath.value = fileInfo;
        //alert("字幕已上传到:"+fileInfo);
    }
    else if (urlType == global.urlType.POSTER) {
        fileInfo = "1*海报*" + fileInfo + "*0*0*0|";
    }
    else if (uploadType == 'dir') {
        fileInfo = "1*课件*" + fileInfo + "/" + form1.UpLoad1.SetupFile + "*0*0*0|";
    }

    if (!isSubtitle) new Ajax.Updater({success: 'serialList', failure: 'error'}, '<g:createLink controller="program" action="dealUpload" />', {asynchronous: true, evalScripts: true, parameters: 'program.id=' + global.programId + '&urlType=' + urlType + '&filePath=' + encodeURIComponent(fileInfo)});
    document.getElementById("serialsTR").style.display = "block";
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
    <!--
    //全局变量
    global.programId = ${program.id};
    global.classId = ${classLibId};

    global.uploadPath = "${application.uploadRootPath}/${session.consumer.name}/lib${classLibId}/";//路径：根路径/username/lib1/

    global.videoSevr = "${application.videoSevr==''?request.serverName:application.videoSevr}";
    global.videoPort = "${application.videoPort}";
    global.tagName = "${Program.cnField.programTags}";
    global.resDescription = "${Program.cnField.description}";

    var metaList = new Array();//当前类
    var contentList = new Array();
    //初始化
    window.onload = init;
    function init() {
        setCurMetaList(global.classId, -1, -1);//显示当前类下所有元数据
        showAllTr();
    }


    function getArrCont(vMetaId, bDeco) {
        var vArr = new Array();
        var i, j, id;
        j = 0;
        if (bDeco) {
            for (i = 0; i < contentList.length; i++) {
                if (contentList[i].metaParentId == vMetaId) {
                    vArr[j] = contentList[i];
                    j++;
                }
            }
        }
        else {
            for (i = 0; i < contentList.length; i++) {
                if (contentList[i].metaId == vMetaId) {
                    vArr[j] = contentList[i];
                    j++;
                }
            }
        }

        return vArr;
    }

    //初始化时显示所有元素列表，重复条目下拉框，设置行数下拉框
    function showAllTr() {
        var i, j, k, ii, iRow, iRow2;
        var theMetaOjb, theTrObj;
        var vArr, bDeco;
        var vCell3;//列3
        iRow = 0;

        for (i = 0; i < metaList.length; i++) {

            theMetaOjb = metaList[i];
            if (theMetaOjb.parentId == 0) {

                bDeco = theMetaOjb.dataType == "decorate";
                vArr = getArrCont(theMetaOjb.selfId, bDeco);

                if (vArr != null && vArr.length > 0) {
                    for (ii = 0; ii < vArr.length; ii++) {

                        if (showTr(iRow, theMetaOjb.index) == false) continue;
                        if (bDeco) {
                            wtab.rows[iRow].cells[1].firstChild.value = vArr[ii].metaId;
                            onDecoChange(wtab.rows[iRow].cells[1].firstChild);
                            wtab.rows[iRow].cells[2].firstChild.value = vArr[ii].dataType == 1 ? vArr[ii].numContent : Jtrim(vArr[ii].strContent);
                        }
                        else {
                            wtab.rows[iRow].cells[2].firstChild.value = vArr[ii].dataType == 1 ? vArr[ii].numContent : Jtrim(vArr[ii].strContent);
                            if (theMetaOjb.dataType == "img" && Jtrim(vArr[ii].strContent) != "") {
                                var showImg = wtab.rows[iRow].cells[2].childNodes[10];
                                showImg.style.display = "inline";
                            }
                            else if (theMetaOjb.dataType == "link" && Jtrim(vArr[ii].strContent) != "") {
                                var arrLink = getArrLink(vArr[ii].strContent);
                                wtab.rows[iRow].cells[2].childNodes[2].value = arrLink[0];
                                wtab.rows[iRow].cells[2].childNodes[4].value = arrLink[1];
                            }
                        }
                        //theMetaOjb.repeatNum++;
                        iRow++;
                    }
                    theMetaOjb.repeatNum = vArr.length - 1;
                }
                else {
                    if (showTr(iRow, theMetaOjb.index) == false) continue;
                    iRow++;

                }
            }
        }

    }

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
            form1.UpLoad1.OpenFile();
            return;
        }
        document.form1.isSubtitleUpload.value = 0;//非字幕上传重置，以免上传完事件中误用类型处理。

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

    function deleteSubtitle(serialId, subtitleId) {
        new Ajax.Updater({success: 'subtitleList', failure: 'error'}, '<g:createLink action="deleteSubtitle" />', {asynchronous: true, evalScripts: true, parameters: 'serialId=' + serialId + '&subtitleId=' + subtitleId});
    }

    function deleteRelationProgram(rid) {
        var url = '<g:createLink action="deleteRelationProgram" />';
        var update = 'relationProgramList';//template
        var params = '?id=${program?.id}&rid=' + rid;
        new Ajax.Updater({success: update, failure: 'error'}, url, {asynchronous: true, evalScripts: true, parameters: params});
    }

    //设置相关节目 与节目添加页面不同，此处是远程更改模板
    function setRelationProgram(rid, name) {
        var url = '<g:createLink action="saveRelationProgram" />';
        var update = 'relationProgramList';//template
        var params = '?id=${program?.id}&rid=' + rid;

        new Ajax.Updater({success: update, failure: 'error'}, url, {asynchronous: true, evalScripts: true, parameters: params});
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

    <g:each in="${program.metaContents}" status="i" var="metaContent">
    contentList[${i}] = new CContentTypeObj(${metaContent.id}, ${metaContent.metaDefine.id}, ${metaContent.metaDefine.parentId}, ${MetaContent.numDataTypes.contains(metaContent.metaDefine.dataType)?1:2}, ${metaContent.numContent}, '${metaContent?.strContent?.encodeAsJavaScript()}');
    </g:each>

    //-->
</SCRIPT>
</head>

<body>
<br>
<g:if test="${params?.fromModel == 'programMgr'}">
    <div class="x_daohang">
        <p>当前位置：<a href="${createLink(controller: 'my', action: 'manageProgram', params: [fromModel: programMgr])}">资源管理</a>>> <a
                href="${createLink(controller: 'my', action: 'manageProgram', params: [fromModel: programMgr])}">资源列表</a>>> 编辑资源</p>
    </div>
</g:if>
<g:else>
    <div class="x_daohang">
        <p>当前位置：<a href="${createLink(controller: 'my', action: 'myInfo')}">个人空间</a>>><a href="${createLink(controller: 'my', action: 'manageProgram')}">我的资源</a>>> <a
                href="${createLink(controller: 'my', action: 'manageProgram')}">资源管理</a> >> 编辑资源</p>
    </div>
</g:else>
<br>

<div class="body">
<h1>编辑${Program.cnTableName}</h1>
<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>
<g:hasErrors bean="${program}">
    <div class="errors">
        <g:renderErrors bean="${program}" as="list"/>
    </div>
</g:hasErrors>
<g:form name="form1" action="update" method="post" onsubmit="return check();">
    <input type="hidden" name="id" value="${program?.id}"/>

    <!-- 返回到列表页面用 -->
    <input type="hidden" name="schState" value="${params?.schState}"/>
    <input type="hidden" name="schType" value="${params?.schType}"/>
    <input type="hidden" name="schWord" value="${params?.schWord}"/>
    <input type="hidden" name="max" value="${params?.max}"/>
    <input type="hidden" name="offset" value="${params?.offset}"/>
    <input type="hidden" name="sort" value="${params?.sort}"/>
    <input type="hidden" name="order" value="${params?.order}"/>
    <input type="hidden" name="fromModel" value="${params?.fromModel}"/>
    <input type="hidden" name="directoryId" value="${params?.directoryId}"/>
    <input type="hidden" name="isSubtitleUpload" value="0"/>

    <div class="dialog">
        <table id="progEdit">
            <tbody>

            <tr class="prop">
                <td class="name" colspan="2" style="padding-left:0px;">
                    <table id="wtab" style="border:0px;padding-left:0px;" width="700" border="0">
                    </table>
                </td>
            </tr>

            <tr class="prop">
                <td class="name">
                    <label for="serials">${Program.cnField.programTags}:</label>
                </td>
                <td valign="top" class="value ${hasErrors(bean: program, field: 'programTags', 'errors')}">
                    <input class="tag" type="text" maxlength="100" id="programTag" name="programTag"
                           value="${program?.programTags?.name[0]}"/>
                    <input class="tag" type="text" maxlength="100" id="programTag" name="programTag"
                           value="${program?.programTags?.name[1]}"/>
                    <input class="tag" type="text" maxlength="100" id="programTag" name="programTag"
                           value="${program?.programTags?.name[2]}"/>
                    <input class="tag" type="text" maxlength="100" id="programTag" name="programTag"
                           value="${program?.programTags?.name[3]}"/>
                    <input class="tag" type="text" maxlength="100" id="programTag" name="programTag"
                           value="${program?.programTags?.name[4]}"/>
                </td>
            </tr>

            <tr class="prop">
                <td valign="top" class="name">
                    <label for="description">${Program.cnField.description}:</label>
                </td>
                <td valign="top" class="value ${hasErrors(bean: program, field: 'description', 'errors')}">
                    <textarea name="description">${fieldValue(bean: program, field: 'description')}</textarea>
                </td>
            </tr>

            <tr class="prop">
                <td class="name">
                    <label for="directory">上传文件:</label>
                </td>
                <td>
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
                    &nbsp;&nbsp;消息：<input type="text" style="width:120px;" maxlength="100" id="showPath" name="showPath"
                                          value=""/>
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
                <td style="padding-top:3px;">
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

            <tr class="prop" id="serialsTR">
                <td valign="top" class="name">
                    <label for="serials">${Program.cnField.serials}:</label>
                </td>
                <td valign="top" class="value ${hasErrors(bean: program, field: 'serials', 'errors')}">
                    <g:render template="serialList" model="[program: program]"/>
                </td>
            </tr>

            <tr class="prop">
                <td valign="top" style="padding-top:18px;" class="name">
                    <label for="description">相关${Program.cnTableName}:</label>
                </td>
                <td style="padding-top:11px;" class="value ${hasErrors(bean: program, field: 'description', 'errors')}">
                    <g:render template="relationProgramList"
                              model="[relationProgramList: program.relationPrograms, total: total, keyword: keyword]"/>
                    <div id="relationSearch" style="display:block">
                        ${Program.cnField.name}:<input type="text" maxlength="50" name="keyword2" style="width:100px;"
                                                       value="">&nbsp;
                        <input type="button" value="搜索" name="b4" style="width:40px;"
                               onClick="showWnd('searchRelationProgramList');${remoteFunction(action: 'searchRelationProgram', update: [success: 'searchRelationProgramList', failure: 'ohno'], params: '\'keyword=\'+encodeURIComponent(this.form.keyword2.value)')}">&nbsp;<input
                            type="button" value="隐藏" name="b4" style="width:40px;"
                            onClick="hideWnd('searchRelationProgramList');">&nbsp;(先搜索，从搜索结果中设置相关节目)<br>
                        <g:render template="searchRelationProgramList"
                                  model="[programList: programList, total: total, keyword: keyword]"/>
                    </div>
                </td>
            </tr>

            <tr class="prop">
                <td class="name">
                    <label for="description">是否允许下载:</label>
                </td>
                <td class="value ${hasErrors(bean: program, field: 'canDownload', 'errors')}"><input type="radio"
                                                                                                     name="canDownload"
                                                                                                     value="true" ${program.canDownload ? "checked" : ""}>允许下载&nbsp;<input
                        type="radio" name="canDownload" value="false" ${program.canDownload ? "" : "checked"}>禁止下载&nbsp;
                </td>
            </tr>

            <g:if test="${program.state >= Program.CLOSE_STATE}">
                <tr class="prop">
                    <td class="name">
                        <label for="description">是否发布:</label>
                    </td>
                    <td class="value ${hasErrors(bean: program, field: 'canDownload', 'errors')}"><input type="radio"
                                                                                                         name="state"
                                                                                                         value="${Program.CLOSE_STATE}" ${(program.state == Program.CLOSE_STATE) ? "checked" : ""}>不发布&nbsp;<input
                            type="radio" name="state"
                            value="${Program.PUBLIC_STATE}" ${(program.state == Program.PUBLIC_STATE) ? "checked" : ""}>发布&nbsp;
                    </td>
                </tr>
            </g:if>

            <tr class="prop">
                <td class="name" colspan="2" style="height:25px;">
                    <label for="description">${Program.cnField.consumer}:${program.consumer.name}&nbsp;&nbsp;${Program.cnField.dateCreated}:<g:formatDate
                            format="yyyy-MM-dd"
                            date="${program?.dateCreated}"/>&nbsp;&nbsp;${Program.cnField.dateModified}:<g:formatDate
                            format="yyyy-MM-dd" date="${program?.dateModified}"/></label>
                </td>

            </tr>

            </tbody>
        </table>
    </div>

    <div class="buttons">
        <span class="button"><input class="save" type="submit" value="保存"/></span>
        <span class="button"><input class="return" type="button" onclick="history.back();" value="取消"/></span>
    </div>
    <object classid="clsid:FDE4893B-A43E-4ec4-9119-1C214BF69E51" CODEBASE="upload.CAB#version=3,1,0,0" id="UpLoad1"
            width="0" height="0">
        <param name="Port" value="${application.uploadPort}">
        <param name="ServIPAddr" value="${application.videoSevr == '' ? request.serverName : application.videoSevr}">
        <param name="SrcFileName" value="">
        <param name="DstFileName" value="">
        <param name="IsMultiFile" value="1">
        <param name="SavePath" value="">
        <param name="SaveType" value="800">
    </object>
</g:form>
</div>

<g:render template="editSerial" model="[serial: serial]"/>
<g:render template="editMaterial" model="[program: null]"/>
<g:render template="subtitleList" model="[serial: serial]"/>
<g:render template="editSubtitle" model="[serial: serial]"/>

<div id="error"></div>
</body>
</html>
