<%--
  Created by IntelliJ IDEA.
  User: lvyangtao
  Date: 14-3-15
  Time: 上午10:01
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="index">
    <r:require modules="swfupload"/>
    <title>上传共享</title>
    <link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'creat_sharing.css')}">

    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/bfUploadShare.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/useractivity.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/community', file: 'communityValidate.js')}"></script>
</head>

<body>
<g:form controller="community" action="saveSharing" method="post" name="saveHeadSharingForm"
        enctype="multipart/form-data">
    <input type="hidden" id="communityId" name="communityId" value="${studyCommunity?.id}">
    <input type="hidden" id="userId" name="userId" value="${session.consumer.id}">
    <input type="hidden" id="fileHash" name="fileHash">
    <input type="hidden" id="fileType" name="fileType">
    <input type="hidden" id="uploadPath" name="uploadPath">
    <input type="hidden" id="url" name="url">

    <div class="main top">
        <div class="commend mt1">
            <DIV id=con>
                <div class="tbox light2 tit_sh">
                    <div class="wrap">
                        <h1 class="light">上传共享</h1>
                    </div>
                </div>

                <DIV id=tagContent class="wrap s_order">
                    <DIV class="tagContent selectTag" id=tagContent0>
                        <form action="save" method="post" enctype="multipart/form-data" name="createForm"
                              id="createForm">
                            <table class="table" border="0" cellspacing="0" cellpadding="0">

                                <tr>
                                    <td width="120px" style="font-size: 14px">*标题</td>
                                    <td>
                                        <input name="name" id="headAddName" type="text" class="form-control"
                                               value="标题必填，不得多于50个字。"
                                               onfocus="javascript:nameFocus('headAddName');"
                                               onblur="javascript:nameBlur('headAddName');"/></td>
                                    <td width="200"><div id="headAddNamePrompt"></div></td>
                                </tr>
                                <tr>
                                    <td style="font-size: 14px;padding: 5px;">上传文件</td>
                                    <td style="height: 50px"><div>
                                        <input type="button" value=" 上 传 " class="qtdbbut mb5" id="uploadShareBtn"/>
                                        <input name="saveFilePath" id="headAddFilePath" type="hidden" readonly
                                               class="qtdscgx" style="width: 200px;">
                                    </div>

                                        <div style="height: 25px;width: 500px;">
                                            <div style="height: 25px;float: left;line-height: 25px;"><span
                                                    id="uploadSuccess"></span></div>

                                            <div style="height: 25px;background: #39a53e;display: none"
                                                 id="uploadSpeed"></div>
                                        </div>
                                    </td>
                                    <td><div id="headAddFilePathPrompt"></div></td>
                                    <input type="text" id="fileName" name="fileName" style="border: 0">
                                </tr>
                                <tr>
                                    <td style="font-size: 14px">内容</td>
                                    <td><textarea name="description" id="headAddDescription" class="form-control"
                                                  rows="3"></textarea></td>
                                    <td><div id="headAddDescriptionPrompt"></div></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <input onclick="saveHeadSharing()" type="button" value=" 提 交 "
                                               class="btn btn-success"/>&nbsp;&nbsp;&nbsp;&nbsp;<input name=""
                                                                                                       onclick="document.getElementById('qscgx').style.display = 'none';
                                                                                                       document.getElementById('qscgxb').style.display = 'none'"
                                                                                                       type="button"
                                                                                                       value=" 取 消 "
                                                                                                       class="btn btn-warning"/>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </DIV>
                </DIV>
            </DIV>
        </div>
    </div>

</g:form>

</div>
<script type="text/javascript">
    function saveHeadSharing() {

        $('#headAddFilePathPrompt').html('<span class="p_sent_w" >上传文件(不能上传可执行文件和web程序文件)</span>');
        if (checkCommunity("headAddName", "headAddDescription") == false) return;
        if ($("#headAddFilePath").val() == '') {
            $("#headAddFilePathPrompt").html('<span class="p_sent_w" >你还未上传共享!</span>');
            $("#headAddFilePath").focus();
            $("#headAddFilePath").select();
            return;
        }
        saveHeadSharingForm.submit();
    }
</script>
</body>
</html>