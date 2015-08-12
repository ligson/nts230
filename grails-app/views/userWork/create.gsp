<%@ page import="nts.program.domain.Serial" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="index"/>
    <title>${message(code: 'my.addto.name')}${message(code: 'my.works.name')}</title>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'xindex.css')}"
          media="all">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type="text/css"
          media="screen"/>
    <r:require modules="swfupload,string"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/useractivity.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/admin/Base64.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/bfUploadWork.js')}"></script>


    <SCRIPT type=text/javascript>
        //全局变量
        global.usename = "${session?.consumer?.name?.encodeAsJavaScript()}";
        global.pwd = "${(application.authPrefix+session?.consumer?.name+application.authPostfix).encodeAsMD5().encodeAsJavaScript()}";
        global.videoSevr = "${application.videoSevr==''?request.serverName:application.videoSevr}";
        global.videoPort = "${application.videoPort}";
        global.uploadPath = "${application.uploadRootPath}/${session.consumer.name}/userWork${classLibId}/";
        global.fileSizeLimit = "${application.fileSizeLimit}";

        function selectTag(showContent, selfObj) {
            // 操作标签
            var tag = document.getElementById("tags").getElementsByTagName("li");
            var taglength = tag.length;
            for (var i = 0; taglength > i; i++) {
                tag[i].className = "";
            }
            selfObj.parentNode.className = "selectTag";
            // 操作内容
            for (i = 0; j = document.getElementById("tagContent" + i); i++) {
                j.style.display = "none";
            }
            document.getElementById(showContent).style.display = "block";
        }
        function showToLower(obj) {
            var request_url = baseUrl + "community/getCategoryTwo"; // 需要获取内容的url
            var request_pars = "category1=" + obj.value;//请求参数

            $.ajax({
                type: "post",
                url: request_url,
                data: request_pars,
                success: function (data) {
                    $("#category2").empty().append(data);
                }
            });
        }

        function loading() {
        }

        function done() {
        }

        function reportError(request) {
            alert(request);
        }

        window.onload = init;
    </SCRIPT>
    <script type="text/javascript">
        $(function () {
            var uploadServerUrl = "http://" + global.videoSevr + ":" + global.videoPort + "/bmc";
            var uploadUrl = "http://" + global.videoSevr + ":" + global.videoPort + "/bmc/upload/uploadFile";
            var uploadPath = global.uploadPath;
            var fieSizeLimit = global.fileSizeLimit * 1024;
            var params = {userId: -1, uploadPath: uploadPath};
            initWorkUpload(uploadServerUrl, uploadUrl, fieSizeLimit, params);
        });
    </script>
</head>

<body style="background:none;">
<div id="serialsTR"></div>
<!----首页正文开始---->
<div class="creat_community_works">
    <h1 class="wrap"><span>+</span>${message(code: 'my.addto.name')}${message(code: 'my.works.name')}</h1>
</div>

<div class="main top">
    <div class="commend mt1">
        <DIV id=con>
            %{-- <dl class="tbox light2">
                 <dt class="light"><strong class="icos3"style="font-size: 16px; color: #333333" >添加作品</strong></dt>
             </dl>--}%

            <DIV id=tagContent>

                <DIV class="tagContent  c_r" id=tagContent0>
                    <g:form controller="userWork" action="save" method="post" enctype="multipart/form-data" name="form1"
                            id="form1">
                        <input type="hidden" name="userId" value="${session.consumer?.id}">
                        <input type="hidden" name="avtivityId" value="${params.id}">
                        <input type="hidden" name="serialId" value="0">
                        <input type="hidden" name="svrAddress"
                               value="${application.videoSevr == '' ? request.serverName : application.videoSevr}">
                        <input type="hidden" name="url" id="url" value=""/>
                        <input type="hidden" name="fileHash" id="fileHash" value=""/>
                        <input type="hidden" name="fileType" id="fileType" value=""/>
                        <input type="hidden" name="uploadPath"
                               value="${application.uploadRootPath}/${session.consumer.name}/userWork${classLibId}/">
                        <table class="table" border="0">
                            <tr>
                                <td width="120"
                                    align="right"><span style="color: red;">*</span>${message(code: 'my.works.name')}${message(code: 'my.title.name')}</td>
                                <td><input type="text" name="name" id="name" class="form-control" style="width: 220px"/>
                                </td>
                                <td width="300" align="left"><span id="namePrompt"></span></td>
                            </tr>
                            <tr>
                                <td align="right"><span style="color: red;">*</span>${message(code: 'my.works.name')}${message(code: 'my.sort.name')}</td>
                                <td>
                                    <select name="urlType" id="urlType" class="form-control" style="width: 220px">
                                        <option value="">--请选择--</option>
                                        <option value="${Serial.URL_TYPE_VIDEO}">视频</option>
                                        <option value="${Serial.URL_TYPE_IMAGE}">图片</option>
                                    </select>
                                    <span style="color: red;">(请选择正确的作品类型，错误的作品类型会导致作品无法正常浏览或播放！)</span>
                                </td>
                                <td width="120" align="left"><span id="urlTypePrompt"></span></td>
                            </tr>
                            <tr>
                                <td align="right">${message(code: 'my.upload.name')}${message(code: 'my.files.name')}</td>
                                <td><span id="successSpeed"></span>

                                    <input type="button" value=" 上 传 " class="qtdbbut mb5" style="background:orange"
                                           id="uploadUserActivityBtn"/>
                                </td>

                                <input name="filePath" id="filePath" type="hidden" readonly class="qtdscgx">
                                <td></td>

                            </tr>
                            <tr>
                                <td align="right">${message(code: 'my.works.name')}${message(code: 'my.introduction.name')}</td>
                                <td>
                                    <textarea name="description" id="description" cols="100" rows="3"
                                              class="form-control"></textarea>
                                </td>
                                <td width="120" align="left"><span id="descriptionPrompt"></span></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td><input type="button" onclick="saveUserWork()"
                                           name="button" class="btn btn-success" id="button"
                                           value="保存"/>
                                    %{--<input type="button" class="btn btn-success" id="button2" value="关闭"
                                           onclick="window.close();"/>--}%
                            </tr>
                        </table>
                    </g:form>

                    <DIV id="editMaterial">
                        <g:render template="editMaterial" model="[program: program]"/>
                    </DIV>
                </DIV>
            </DIV>
        </DIV>
    </div>
</div>

<!--首页正文部分结束---->
<div class="hr5"></div>


<div id="qfbxtb" class="black_overlay928"></div>
</body>
</html>
