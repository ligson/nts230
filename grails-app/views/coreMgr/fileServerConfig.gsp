<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-4-1
  Time: 上午11:08
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>文件服务器配置</title>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/isNum2.js')}"></script>

    <script Language="JavaScript" type="text/javascript">
        function localWebServerConfigSet() {
            var configForm = document.getElementById("configForm");
            if(configForm.VideoSevr.value == "") {
                alert("视频服务器IP地址不能为空!");
                configForm.VideoSevr.focus();
                return false;
            }
            if(configForm.videoPort.value == "") {
                alert("视频服务器端口不能为空!");
                configForm.videoPort.focus();
                return false;
            }
            if(configForm.uploadPort.value == "") {
                alert("上传服务器端口不能为空!");
                configForm.uploadPort.focus();
                return false;
            }
            if (!configForm.VideoSevr.value.isIPv4() && !configForm.VideoSevr.value.isIPv6() && !configForm.VideoSevr.value.isDomainName()) {
                alert("请输入正确IP地址！！");
                configForm.VideoSevr.focus();
                return false;
            }
            if (!isNum2(configForm.videoPort.value, 1, 65535)) {
                alert("请输入正确视频服务端口");
                configForm.videoPort.focus();
                return false;
            }
            if (!isNum2(configForm.uploadPort.value, 1, 65535)) {
                alert("请输入正确上传服务端口");
                configForm.uploadPort.focus();
                return false;
            }
            configForm.action = "fileServerConfigSet";
            configForm.submit();
        }
    </script>
    <style type="text/css">
        tr{border-top: 1px solid #F4F4F4}
    </style>
</head>

<body>
<g:uploadForm name="configForm" action="" enctype="multipart/form-data">

    <div style="overflow-y:scroll; overflow-x:hidden;height:480px;width:100%;">
        <table width="99%">
            <tr>
                <td><div id="tblist2">
                    <table width="99%" border="0" cellpadding="0" cellspacing="1" bgcolor="#e8e8e8" >
                        <tr>
                            <th width="15%" align="center" style="height: 50px">属性名称</th>
                            <th width="38%" align="center">属性值</th>
                            <th align="middle">说明</th>
                        </tr>
                        <tr>
                            <td style="height: 50px">视频服务器IP地址</td >
                            <td><input type="text" class="admin_default_inp" maxlength="200" name="VideoSevr"
                                       value="${VideoSevr?.configValue}" size="30"/>
                            </td>
                            <td class="tips">(视频服务器IP地址,默认为web服务器IP地址)</td>
                        </tr>
                        <tr>
                            <td style="height: 50px">视频服务器端口</td>
                            <td><input type="text" class="admin_default_inp" maxlength="200" name="videoPort"
                                       value="${videoPort?.configValue}" size="30"/>
                            </td>
                            <td class="tips">(视频服务器端口与web服务端口,例如80)</td>
                        </tr>
                        <tr>
                            <td style="height: 50px">上传服务器端口</td>
                            <td><input type="text" class="admin_default_inp" maxlength="200" name="uploadPort"
                                       value="${uploadPort?.configValue}"
                                       size="30"/></td>
                            <td class="tips">(上传服务器端口与web服务端口,例如80)</td>
                        </tr>
                        <tr>
                            <td style="height: 50px">分发收割端口</td>
                            <td><input type="text" class="admin_default_inp" maxlength="200" name="serverNodePort"
                                       value="${serverNodePort?.configValue}"
                                       size="30"/></td>
                            <td class="tips">(分发收割端口,系统默认端口例如1681)</td>
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