<%@ page import="nts.system.domain.SysConfig; nts.utils.CTools" %>
<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午6:07
  To change this template use File | Settings | File Templates.
--%>

<html>
<head>
    <title>系统设置</title>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/isNum2.js')}"></script>

    <script Language="JavaScript" type="text/javascript">
        function sysSet() {
            var configForm = document.getElementById("configForm");
            if (configForm.UploadRootPath.value == "") {
                alert("上传资源根目录不能为空");
                configForm.UploadRootPath.focus();
                return false;
            }
            if (configForm.UploadRootPath.value.length > 100) {
                alert("上传资源根目录输入不大于100个字符");
                configForm.UploadRootPath.focus();
                return false;
            }
            if (configForm.VideoSevr.value.length > 200) {
                alert("服务器IP地址输入不大于200个字符");
                configForm.VideoSevr.focus();
                return false;
            }
            if (!isNum2(configForm.AbbrImgSize.value)) {
                alert("请在缩略图大小框中输入数字");
                configForm.AbbrImgSize.focus();
                return false;
            }
            if (!isNum2(configForm.AbbrImgRowPerNum.value)) {
                alert("请在每行缩略图数目框中输入数字");
                configForm.AbbrImgRowPerNum.focus();
                return false;
            }
            /*
            <g:if test="${application.distributeModState == 1}">
             if (!isNum2(configForm.ProvinceWebPort.value)) {
             alert("请在省中心web服务器端口框中输入数字");
             configForm.ProvinceWebPort.focus();
             return false;
             }
            </g:if>*/
            if (!isNum2(configForm.LocalWebPort.value)) {
                alert("请在本地web服务器端口框中输入数字");
                configForm.LocalWebPort.focus();
                return false;
            }
            strReplace();                   //替换所有"\"
            if (!configForm.AbbrImgSize.value) {
                configForm.AbbrImgSize.value = "100"
            }
            if (!configForm.AbbrImgRowPerNum.value) {
                configForm.AbbrImgRowPerNum.value = "6"
            }

            /*
            <g:if test="${application.distributeModState == 1}">
             if (!configForm.ProvinceWebPort.value) {
             configForm.ProvinceWebPort.value = "80"
             }
            </g:if>*/

            if (!configForm.LocalWebPort.value) {
                configForm.LocalWebPort.value = "80"
            }

            if (!configForm.applicationName.value) {
                alert("应用程序名不能为空");
                configForm.applicationName.focus();
                return false;
            }

            if (!configForm.applicationBottom.value) {
                alert("页脚不能为空");
                configForm.applicationBottom.focus();
                return false;
            }

            //transcodingIp 转码服务器IP地址
            //transcodingPort 转码服务器端口
            //transcodingPath 转码保存路径
            if (configForm.transcodingIp.value.length > 200) {
                alert("转码服务器IP地址输入不大于200个字符");
                configForm.transcodingIp.focus();
                return false;
            }
            if (!isNum2(configForm.transcodingPort.value)) {
                alert("请在转码服务器端口框中输入数字");
                configForm.transcodingPort.focus();
                return false;
            }
            if (!configForm.transcodingPath.value) {
                alert("转码保存路径不能为空");
                configForm.transcodingPath.focus();
                return false;
            }
            if (configForm.transcodingPath.value.length > 100) {
                alert("转码保存路径输入不大于100个字符");
                configForm.transcodingPath.focus();
                return false;
            }

            //海报尺寸验证
            if (!isNum2(configForm.thumbnailSize1.value)) {
                alert("请在海报尺寸大小框中输入数字");
                configForm.thumbnailSize1.focus();
                return false;
            }
            if (!isNum2(configForm.thumbnailSize2.value)) {
                alert("请在海报尺寸大小框中输入数字");
                configForm.thumbnailSize2.focus();
                return false;
            }
            if (!isNum2(configForm.thumbnailPos.value)) {
                alert("请在截取时间点框中输入数字");
                configForm.thumbnailPos.focus();
                return false;
            }
            transcodingPathReplace();

            //1.EmailRootDir email保存路径
            if (!configForm.emailRootDir.value) {
                alert("email保存路径不能为空");
                configForm.emailRootDir.focus();
                return false;
            }
            //2.Email email 地址
            if (!configForm.email.value) {
                alert("email地址不能为空");
                configForm.email.focus();
                return false;
            }
            //3.EmailPop3 Email Pop3地址
            if (!configForm.emailPop3.value) {
                alert("Email Pop3地址不能为空");
                configForm.emailPop3.focus();
                return false;
            }
            //4.EmailSmtp Email smtp地址
            if (!configForm.emailSmtp.value) {
                alert("Email smtp地址不能为空");
                configForm.emailSmtp.focus();
                return false;
            }
            //5.EmailUserName Email用户名
            if (!configForm.emailUserName.value) {
                alert("Email用户名不能为空");
                configForm.emailUserName.focus();
                return false;
            }
            //6.EmailPassword Email 用户名密码
            if (!configForm.emailPassword.value) {
                alert("Email 用户名密码不能为空");
                configForm.emailPassword.focus();
                return false;
            }
            if (!isNum2(configForm.autoPlayTime.value)) {
                alert("请在自动播放计数时间框中输入数字");
                configForm.autoPlayTime.focus();
                return false;
            }

            configForm.action = "systemSet";
            configForm.submit();
        }

        //转码保存路径'\'替换成'/'
        function transcodingPathReplace() {
            var str = configForm.transcodingPath.value;
            configForm.transcodingPath.value = str.replace(/\\/g, "/");
        }

        function strReplace() {
            var str = configForm.UploadRootPath.value;
            configForm.UploadRootPath.value = str.replace(/\\/g, "/");
        }

    </script>
</head>

<body>

<g:uploadForm name="configForm" action="" enctype="multipart/form-data">

<table width="99%">
<tr>
<td><div id="tblist2">
<table width="99%" border="0" cellpadding="0" cellspacing="1" bgcolor="#e8e8e8">
<tr>
    <th width="15%" align="center">属性名称</th>
    <th width="38%" align="center">属性值</th>
    <th align="middle">说明</th>
</tr>
<tr>
    <td>上传资源根路径</td>
    <td><input name="UploadRootPath" type="text" class="tbinp" value="${UploadRootPath?.configValue}" size="30"
               maxlength="100"/></td>
    <td align="left"></td>
</tr>
<tr>
    <td>视频服务器IP地址</td>
    <td><input type="text" class="tbinp" maxlength="200" name="VideoSevr" value="${VideoSevr?.configValue}" size="30"/>
    </td>
    <td class="tips">(为空则默认为web服务器IP地址)</td>
</tr>
<tr>
    <td>视频服务端口</td>
    <td><input type="text" class="tbinp" maxlength="200" name="videoPort" value="${videoPort?.configValue}" size="30"/>
    </td>
    <td class="tips">(为空则默认为1680)</td>
</tr>
<tr>
    <td>上传服务端口</td>
    <td><input type="text" class="tbinp" maxlength="200" name="uploadPort" value="${uploadPort?.configValue}"
               size="30"/></td>
    <td class="tips">(为空则默认为1670)</td>
</tr>
<tr>
    <td>缩略图大小</td>
    <td><input type="text" class="tbinp" maxlength="200" name="AbbrImgSize" value="${AbbrImgSize?.configValue}"
               size="30"/></td>
    <td class="tips">(单位像素，默认100像素)</td>
</tr>
<tr>
    <td>每行缩略图数目</td>
    <td><input type="text" class="tbinp" maxlength="200" name="AbbrImgRowPerNum"
               value="${AbbrImgRowPerNum?.configValue}" size="30"/>
    </td>
    <td class="tips">(指点播页面中缩略图每行排列的数目，默认6)</td>
</tr>
<tr>
    <td>流媒体核心版本</td>
    <td>
        <select name="VodCoreVer">
            <option value="BMTP" ${vodCoreVer?.configValue == 'BMTP' ? 'selected' : ''}>版本6</option>
            <option value="BMSP" ${vodCoreVer?.configValue == 'BMSP' ? 'selected' : ''}>版本7</option>
        </select>
    </td>
    <td></td>
</tr>
<tr>
    <td>本地WEB服务器端口</td>
    <td><input type="text" class="tbinp" maxlength="12" name="LocalWebPort" value="${localWebPort?.configValue}"
               size="30"/></td>
    <td></td>
</tr>
<tr>
    <td>应用程序名</td>
    <td><input type="text" class="tbinp" name="applicationName" value="${applicationName}" size="30"/></td>
    <td></td>
</tr>
<tr>
    <td>页脚</td>
    <td><input type="text" class="tbinp" name="applicationBottom" value="${applicationBottom}" size="70"/></td>
    <td>&nbsp;</td>
</tr>
<tr>
    <td>网站 LOGO</td>
    <td><input name="fileLOGO" id="file2" type="file" size="20"/></td>
    <td class="tips">尺寸:100*40;支持格式:jpg,png,gif， 设置后请刷新页面</td>
</tr>
%{--<tr>
    <td>网站顶层背景图片</td>
    <td><input name="filePath1" id="file1" type="file" size="20"/></td>
    <td class="tips">尺寸:952*159;支持格式:jpg,png,gif， 设置后请刷新页面</td>
</tr>
<tr>
    <td>网站底层背景图片</td>
    <td><input name="filePath2" id="file2" type="file" size="20"/></td>
    <td class="tips">尺寸:952*159;支持格式:jpg,png,gif， 设置后请刷新页面</td>
</tr>--}%
<tr>
    <td>转码服务器IP地址</td>
    <td><input type="text" class="tbinp" maxlength="200" name="transcodingIp" value="${transcodingIp?.configValue}"
               size="30"/></td>
    <td></td>
</tr>
<tr>
    <td>转码服务器端口</td>
    <td><input type="text" class="tbinp" maxlength="12" name="transcodingPort" value="${transcodingPort?.configValue}"
               size="30"/></td>
    <td></td>
</tr>
<tr>
    <td>转码保存路径</td>
    <td><input type="text" class="tbinp" maxlength="100" name="transcodingPath" value="${transcodingPath?.configValue}"
               size="30"/>
    </td>
    <td align="left"></td>
</tr>
<tr>
    <td height="22">转码文件格式支持</td>
    <td>
        <input type="checkbox"
               name="transcodeFormat" ${transcodeFormat && (CTools.strToInt(transcodeFormat?.configValue) & 8) == 8 ? "checked" : ""}
               value="8">标清&nbsp;&nbsp;
        <input type="checkbox"
               name="transcodeFormat" ${transcodeFormat && (CTools.strToInt(transcodeFormat?.configValue) & 16) == 16 ? "checked" : ""}
               value="16">高清&nbsp;&nbsp;
        <input type="checkbox"
               name="transcodeFormat" ${transcodeFormat && (CTools.strToInt(transcodeFormat?.configValue) & 32) == 32 ? "checked" : ""}
               value="32">超清&nbsp;&nbsp;
    </td>
    <td></td>
</tr>
<tr>
    <td height="32">缺省播放格式</td>
    <td><input type="radio"
               name="defaultPlayFormat" ${defaultPlayFormat && CTools.strToInt(defaultPlayFormat?.configValue) == 0 ? "checked" : ""}
               value="0">原始文件&nbsp;&nbsp;
        <input type="radio"
               name="defaultPlayFormat" ${defaultPlayFormat && CTools.strToInt(defaultPlayFormat?.configValue) == 1 ? "checked" : ""}
               value="1">标清&nbsp;&nbsp;
        <input type="radio"
               name="defaultPlayFormat" ${defaultPlayFormat && CTools.strToInt(defaultPlayFormat?.configValue) == 2 ? "checked" : ""}
               value="2">高清&nbsp;&nbsp;
        <input type="radio"
               name="defaultPlayFormat" ${defaultPlayFormat && CTools.strToInt(defaultPlayFormat?.configValue) == 3 ? "checked" : ""}
               value="3">超清&nbsp;&nbsp;</td>
    <td align="left"></td>
</tr>
<tr>
    <td>海报尺寸</td>
    <td><input type="text" class="tbinps" maxlength="10" name="thumbnailSize1" value="${thumbnailSize1}" size="10"/>
        X
        <input type="text" class="tbinps" maxlength="10" name="thumbnailSize2" value="${thumbnailSize2}" size="10"/>
    </td>
    <td class="tips">(图片的宽、高，默认是：310x415)</td>
</tr>
<tr>
    <td>截取时间点</td>
    <td><input type="text" class="tbinp" maxlength="30" name="thumbnailPos" value="${thumbnailPos?.configValue}"
               size="30"/></td>
    <td class="tips">(截取时间点，单位秒，缺省300)</td>
</tr>
<tr>
    <td>email保存路径</td>
    <td><input type="text" class="tbinp" maxlength="100" name="emailRootDir" value="${emailRootDir?.configValue}"
               size="30"/></td>
    <td class="tips">路径规约: EmailRootDir/用户名/类库或者活动名/节目名或者活动标题/EmailRootDir/email_temp/保存邮件原始文件</td>
</tr>
<tr>
    <td>email地址</td>
    <td><input type="text" class="tbinp" maxlength="100" name="email" value="${email?.configValue}" size="30"/></td>
    <td align="left"></td>
</tr>
<tr>
    <td>Email Pop3地址</td>
    <td><input type="text" class="tbinp" maxlength="100" name="emailPop3" value="${emailPop3?.configValue}" size="30"/>
    </td>
    <td align="left"></td>
</tr>
<tr>
    <td>Email smtp地址</td>
    <td><input type="text" class="tbinp" maxlength="100" name="emailSmtp" value="${emailSmtp?.configValue}" size="30"/>
    </td>
    <td align="left"></td>
</tr>
<tr>
    <td>Email用户名</td>
    <td><input type="text" class="tbinp" maxlength="100" name="emailUserName" value="${emailUserName?.configValue}"
               size="30"/>
    </td>
    <td align="left"></td>
</tr>
<tr>
    <td>Email用户密码</td>
    <td><input type="text" class="tbinp" maxlength="100" name="emailPassword" value="${emailPassword?.configValue}"
               size="30"/></td>
    <td align="left"></td>
</tr>
<tr>
    <td>自动播放计数时间</td>
    <td><input type="text" class="tbinp" maxlength="30" name="autoPlayTime" value="${autoPlayTime?.configValue}"
               size="30"/></td>
    <td class="tips">(默认30秒)</td>
</tr>
<tr>
    <td>评论是否审核</td>
    <td>
        <input type="radio"
               name="remarkAuthOpt" ${remarkAuthOpt && CTools.strToInt(remarkAuthOpt?.configValue) == 1 ? "checked" : ""}
               value="1">是&nbsp;&nbsp;
        <input type="radio"
               name="remarkAuthOpt" ${!remarkAuthOpt?.configValue || CTools.strToInt(remarkAuthOpt?.configValue) == 0 ? "checked" : ""}
               value="0">否
    </td>
    <td align="left"></td>
</tr>
<tr>
    <td>点播日志是否记录</td>
    <td><input type="radio"
               name="playLogOpt" ${playLogOpt && CTools.strToInt(playLogOpt?.configValue) == 1 ? "checked" : ""}
               value="1">是&nbsp;&nbsp;
        <input type="radio"
               name="playLogOpt" ${!playLogOpt?.configValue || CTools.strToInt(playLogOpt?.configValue) == 0 ? "checked" : ""}
               value="0">否
    </td>
    <td align="left"></td>
</tr>
<tr>
    <td>浏览日志是否记录</td>
    <td><input type="radio"
               name="viewLogOpt" ${viewLogOpt && CTools.strToInt(viewLogOpt?.configValue) == 1 ? "checked" : ""}
               value="1">是&nbsp;&nbsp;
        <input type="radio"
               name="viewLogOpt" ${!viewLogOpt?.configValue || CTools.strToInt(viewLogOpt?.configValue) == 0 ? "checked" : ""}
               value="0">否
    </td>
    <td align="left"></td>
</tr>
<tr>
    <td>删除媒体文件设置</td>
    <td>
        <input type="radio"
               name="fileDelOpt" ${fileDelOpt && CTools.strToInt(fileDelOpt?.configValue) == 1 ? "checked" : ""}
               value="1">是&nbsp;&nbsp;
        <input type="radio"
               name="fileDelOpt" ${!fileDelOpt?.configValue || CTools.strToInt(fileDelOpt?.configValue) == 0 ? "checked" : ""}
               value="0">否
    </td>
    <td align="left"></td>
</tr>
<tr>
    <td>播放线路列表</td>
    <td><input type="text" class="tbinps" maxlength="100" name="lineList" value="${lineList?.configValue}" size="41"/>
    </td>
    <td class="tips">(格式：192.168.1.12,电信网;192.168.1.13,教育网)<br/>
        地址与名称之间用英文逗号隔开，线路之间用英文分号隔开</td>
</tr>
<tr>
    <td>前台模块显示设置</td>
    <td>
        <input type="checkbox"
               name="showModOpt" ${showModOpt && (CTools.strToInt(showModOpt?.configValue) & SysConfig.MOD_OPT_STUDY) == SysConfig.MOD_OPT_STUDY ? "checked" : ""}
               value="${SysConfig.MOD_OPT_STUDY}">学习圈&nbsp;&nbsp;
        <input type="checkbox"
               name="showModOpt" ${showModOpt && (CTools.strToInt(showModOpt?.configValue) & SysConfig.MOD_OPT_COMMUNITY) == SysConfig.MOD_OPT_COMMUNITY ? "checked" : ""}
               value="${SysConfig.MOD_OPT_COMMUNITY}">资源社区&nbsp;&nbsp;
        <input type="checkbox"
               name="showModOpt" ${showModOpt && (CTools.strToInt(showModOpt?.configValue) & SysConfig.MOD_OPT_ACTIVITY) == SysConfig.MOD_OPT_ACTIVITY ? "checked" : ""}
               value="${SysConfig.MOD_OPT_ACTIVITY}">活动&nbsp;&nbsp;
        <input type="checkbox"
               name="showModOpt" ${showModOpt && (CTools.strToInt(showModOpt?.configValue) & SysConfig.MOD_OPT_CLOUD) == SysConfig.MOD_OPT_CLOUD ? "checked" : ""}
               value="${SysConfig.MOD_OPT_CLOUD}">资源云
    </td>
    <td></td>
</tr>
<tr>
    <td>后台模块显示设置</td>
    <td><input type="checkbox"
               name="distributeModState" ${distributeModState && (CTools.strToInt(distributeModState?.configValue) & 1) == 1 ? "checked" : ""}
               value="1">资源分发&nbsp;&nbsp;</td>
    <td></td>
</tr>
<tr>
    <td height="35" colspan="3" align="center"><input class="subbtn" type="button" value=" 设置 " onclick="sysSet()"/>
    </td>
</tr>
</table>
</div></td>
</tr>
</table>
</g:uploadForm>
</body>
</html>