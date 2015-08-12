<%@ page import="nts.program.domain.Serial; nts.program.domain.Program" %>
<html>
<head>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>节目制作</title>
    <link href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}" rel="stylesheet" type="text/css">
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/prototype.js')}"></script>
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

    <!--upload code start -->
    <SCRIPT for="UpLoad1" event="OnOpenFile(name,size)" LANGUAGE="JavaScript">
        form1.showPath.value = "您选择了" + size + "个文件";
        form1.upbtn.disabled = false;
    </SCRIPT>
    <SCRIPT for="UpLoad1" event="OnUpFinished()" LANGUAGE="JavaScript">
        //序号*文件名*文件路径*格式类型*时长*码率
        var fileInfo = form1.UpLoad1.DstFileName;
        var urlType = form1.urlType.value;
        if (urlType == 3) fileInfo = "1*海报*" + fileInfo + "*0*0*0|";//海报控件只返回：f:/pub/master/lib1/d456.jpg

        new Ajax.Updater({success: 'serialList', failure: 'error'}, '<g:createLink controller="program" action="dealUpload" />', {asynchronous: true, evalScripts: true, parameters: 'program.id=0&urlType=' + urlType + '&filePath=' + encodeURIComponent(fileInfo)});
        document.getElementById("serialsTR").style.display = "block";
    </SCRIPT>
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

        function openFile(urlType) {
            //form1.UpLoad1.IsMultiFile="0";
            //gCurUrlType=urlType;
            var uploadPath = global.uploadPath.replace(/\/\//g, '/');
            var urlType = document.form1.urlType.value;
            //urlType == 3是海报图片
            form1.UpLoad1.IsMultiFile = urlType == 3 ? 0 : 1;
            if (urlType == 2 || urlType == 3)
                form1.UpLoad1.LimitFileExt = "jpg|gif|PNG|JPEG|TIFF|";
            else
                form1.UpLoad1.LimitFileExt = ""

            form1.UpLoad1.SavePath = uploadPath;
            form1.UpLoad1.OpenFile();
        }

        function uploadFiles(urlType) {

            form1.UpLoad1.UploadFiles();

            return true;
        }

        function deleteSerial() {
            if (!hasChecked('idList')) {
                alert("请至少选择一条记录。");
                return;
            }
            var idList = getListStr("idList");
            new Ajax.Updater({success: 'serialList', failure: 'error'}, '<g:createLink action="deleteSerial" />', {asynchronous: true, evalScripts: true, parameters: 'program.id=0&idList=' + idList});
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
            self.location.href = "create?classLib.id=" + theObj.value;
        }

        function onUrlTypeChange(theObj) {
            //urlType==6 是链接类型
            if (theObj.value == 6) {
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
            if (link.length < 10) {
                alert("请正确输入链接地址。");
                form1.linkRes.focus();
                return;
            }

            //序号*文件名*文件路径*格式类型*时长*码率
            var fileInfo = "1*链接*" + link + "*0*0*0|";

            new Ajax.Updater({success: 'serialList', failure: 'error'}, '<g:createLink controller="program" action="dealUpload" />', {asynchronous: true, evalScripts: true, parameters: 'program.id=0&urlType=' + form1.urlType.value + '&filePath=' + encodeURIComponent(fileInfo)});
            document.getElementById("serialsTR").style.display = "block";
            //hideWnd('linkDiv');
        }


        //-->
    </SCRIPT>
</head>

<body>

<div class="body">
    <g:form action="save" method="post" name="form1" onsubmit="return check();">
        <input type="hidden" name="svrAddress"
               value="${application.videoSevr == '' ? request.serverName : application.videoSevr}">
        <input type="hidden" name="canPlay" value="true">
        <input type="hidden" name="canAllPlay" value="true">
        <input type="hidden" name="canAllDownload" value="true">

        <h1>选择类库：<g:select id="classLib.id" name='classLib.id' value="${classLibId}" noSelection="${['0': '--请选择类库--']}"
                           from='${directoryList}' optionKey="id" optionValue="name"
                           onChange="onClassChange(this);"></g:select>&nbsp;(必须先选择类库后，方能上传)</h1>
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
                <table id="progEdit">
                    <tbody>

                    <tr class="prop">
                        <td class="name" colspan="2" style="padding-left:0px;">
                            <table id="wtab" style="border:0px;padding-left:0px;" width="760" border="0">
                            </table>
                        </td>
                    </tr>


                    <tr class="prop">
                        <td class="name">
                            <label for="programTags">${Program.cnField.programTags}:</label>
                        </td>
                        <td>
                            <input class="tag" type="text" maxlength="100" id="programTag" name="programTag" value=""/>
                            <input class="tag" type="text" maxlength="100" id="programTag" name="programTag" value=""/>
                            <input class="tag" type="text" maxlength="100" id="programTag" name="programTag" value=""/>
                            <input class="tag" type="text" maxlength="100" id="programTag" name="programTag" value=""/>
                            <input class="tag" type="text" maxlength="100" id="programTag" name="programTag" value=""/>
                        </td>
                    </tr>

                    <tr class="prop">
                        <td class="name">
                            <label for="description">${Program.cnField.description}:</label>
                        </td>
                        <td class="value ${hasErrors(bean: program, field: 'description', 'errors')}">
                            <textarea style="width:600px;height:100px;" name="description"
                                      onclick="cleanPreDesc(this);"></textarea>
                        </td>
                    </tr>

                    <tr class="prop">
                        <td class="name">
                            <label for="directory">上传文件:</label>
                        </td>
                        <td>
                            <input type="text" maxlength="100" id="showPath" name="showPath" value=""/>
                            <g:select from="${Serial.urlTypeName}" name="urlType" value="" optionKey="key"
                                      optionValue="value" onchange="onUrlTypeChange(this)"></g:select>
                            <input type="button" value="浏览" name="b4" style="width:40px;" onClick="openFile(-1);">
                            <input type="button" name="upbtn" onClick="uploadFiles(-1);" disabled style="width:40px;"
                                   value="上传">
                            <br>

                            <DIV id="linkDiv" class="bg" style="width:600px;display:none;margin:-130px 0px 0px 0px;">

                                <DIV class="rg1"></DIV>

                                <DIV class="rg2"></DIV>

                                <DIV class="t1">链接</DIV>

                                <DIV class="bc">

                                    <div>请输入链接地址：<input type="text" style="width:320px;" maxlength="300" id="linkRes"
                                                        name="linkRes" value="http://"/>(请以http或其它协议头开始)</div>

                                    <div align="center" style="margin-top:7px;">
                                        <input type="buttom" onclick="submitLink();" style="cursor:pointer;width:40px;"
                                               value="确定">&nbsp;<input type="buttom" onclick="hideWnd('linkDiv');"
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
                                ${Program.cnField.name}:<input type="text" maxlength="50" name="keyword1"
                                                               style="width:100px;" value="">&nbsp;
                                <input type="button" value="搜索" style="width:40px;"
                                       onClick="showWnd('searchMaterialProgramList');${remoteFunction(action: 'searchMaterialProgram', update: [success: 'searchMaterialProgramList', failure: 'ohno'], params: '\'keyword=\'+this.form.keyword1.value')}">&nbsp;<input
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
                        <td style="padding-top:11px;"
                            class="value ${hasErrors(bean: program, field: 'description', 'errors')}">
                            <input type="hidden" id="relation" name="relation" value=""/>
                            <input type="text" style="width:300px;" maxlength="400" id="showRelation" readonly
                                   name="showRelation" value=""/>
                            <input type="button" value="设置" name="b4" style="width:40px;"
                                   onClick="$(relationSearch).style.display = 'block';"><br>

                            <div id="relationSearch" style="display:none">
                                ${Program.cnField.name}:<input type="text" maxlength="50" name="keyword" value="">&nbsp;
                                <input type="button" value="搜索" name="b4" style="width:40px;"
                                       onClick="showWnd('searchRelationProgramList');${remoteFunction(action: 'searchRelationProgram', update: [success: 'searchRelationProgramList', failure: 'ohno'], params: '\'keyword=\'+this.form.keyword.value')}">&nbsp;<input
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
                        <td class="value ${hasErrors(bean: program, field: 'canDownload', 'errors')}"><input
                                type="radio" name="canDownload" value="true" checked>允许下载&nbsp;<input type="radio"
                                                                                                      name="canDownload"
                                                                                                      value="false">禁止下载&nbsp;
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
                <param name="ServIPAddr"
                       value="${application.videoSevr == '' ? request.serverName : application.videoSevr}">
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
</div>
</body>
</html>
