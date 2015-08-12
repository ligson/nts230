<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-4-1
  Time: 上午10:13
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>本地web服务器配置</title>
    %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css',file: 'unknow_style.css')}">--}%
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'localWebServerConfig.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/isNum2.js')}"></script>

    <script Language="JavaScript" type="text/javascript">
        function isNum(a)
        {
            var reg =/^[0-9]*|^[0-9]+(.[0-9]{1,3})?$ /
            return reg.test(a);
        }

        function localWebServerConfigSet() {
            var configForm = document.getElementById("configForm");
            if (!isNum2(configForm.LocalWebPort.value, 1, 65535)) {
                alert("请在本地web服务器端口框中输入正确数字");
                configForm.LocalWebPort.focus();
                return false;
            }
            if (configForm.LocalWebIp.value=='') {
                alert("请在本地web服务器IP框中输入正确数字");
                configForm.LocalWebPort.focus();
                return false;
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

            if(!configForm.fileSizeLimit.value) {
                configForm.fileSizeLimit.value = '0';
            }

            if (!isNum(configForm.fileSizeLimit.value)) {
                $("#fileSizeLimit_span").html('请输入正确容量数!');
                configForm.fileSizeLimit.focus();
                return false;
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
            configForm.action = "localWebServerConfigSet";
            configForm.submit();
        }

    </script>
</head>

<body>
<g:uploadForm name="configForm" action="" enctype="multipart/form-data">

    <div class="local_box">
        <table width="100%">
            <tr>
                <td>
                    <div id="tblist2">
                        <table class="table table-hover" width="100%">
                            <tr>
                                <th width="160" align="center">属性名称</th>
                                <th width="300" align="center">属性值</th>
                                <th align="middle">说明</th>
                            </tr>
                            <tr>
                                <td>本地WEB服务器IP</td>
                                <td><input type="text" maxlength="15" name="LocalWebIp" class="admin_default_inp"
                                           value="${localWebIp?.configValue}"
                                           size="30"/></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>本地WEB服务器端口</td>
                                <td><input type="text" maxlength="12" name="LocalWebPort" class="admin_default_inp"
                                           value="${localWebPort?.configValue}"
                                           size="30"/></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>上传文件的大小限制(MB)</td>
                                <td><input type="text" class="admin_default_inp" maxlength="200" name="fileSizeLimit"
                                           value="${fileSizeLimit?.configValue}" size="30"/></td>
                                <td><span class="tips">(默认为0,0表示不限制文件大小)</span></td>
                            </tr>
                            <tr>
                                <td>应用程序名</td>
                                <td><input type="text" name="applicationName" value="${applicationName}"
                                           class="admin_default_inp"
                                           size="30"/></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>页脚</td>
                                <td><input type="text" name="applicationBottom" value="${applicationBottom}"
                                           class="admin_default_inp"
                                           size="70"/></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>系统版本号</td>
                                <td><input type="text" name="rmsversion" value="${rmsversion ? rmsversion : 313}"
                                           class="admin_default_inp"
                                           size="20"/></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>系统主题</td>
                                <td>
                                    <g:select name="theme" from="${skins}" optionKey="name" optionValue="name" value="${theme}"/>
                                </td>
                                <td>&nbsp;</td>
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
                                <td>高级搜索是否启用</td>
                                <td>
                                    <input type="radio"
                                           name="seniorSearchOpt" ${seniorSearchOpt && Boolean.parseBoolean(seniorSearchOpt?.configValue) ? "checked" : ""}
                                           value="true">是&nbsp;&nbsp;
                                    <input type="radio"
                                           name="seniorSearchOpt" ${!seniorSearchOpt?.configValue || !Boolean.parseBoolean(seniorSearchOpt?.configValue) ? "checked" : ""}
                                           value="false">否
                                </td>
                                <td align="left"><span class="tips">(设置为启用时，需要在系统设置中进行高级搜索配置)</span></td>
                            </tr>
                            <tr>
                                <td height="35" colspan="3" align="center"><input class="admin_default_but_blue"
                                                                                  type="button" value=" 设置 "
                                                                                  onclick="localWebServerConfigSet()"/>
                                </td>
                            </tr>
                        </table>
                    </div></td>
            </tr>
        </table>
    </div>
</g:uploadForm>
</body>
</html>