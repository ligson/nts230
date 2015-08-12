<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-4-1
  Time: 上午11:08
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>上传文件大小配置</title>

    <script Language="JavaScript" type="text/javascript">
        function isNum(a)
        {
            var reg =/^[0-9]*|^[0-9]+(.[0-9]{1,3})?$ /
            return reg.test(a);
        }

        function fileSizeLimitConfigSet() {
            $("#fileSizeLimit_span").val('');
            var configForm = document.getElementById("configForm");
            if(configForm.fileSizeLimit.value == "") {
                $("#fileSizeLimit_span").html('上传文件的最大容量不能为空!');
                configForm.fileSizeLimit.focus();
                return false;
            }

            if (!isNum(configForm.fileSizeLimit.value)) {
                $("#fileSizeLimit_span").html('请输入正确容量数!');
                configForm.fileSizeLimit.focus();
                return false;
            }
            configForm.action = "fileSizeLimitConfigSet";
            configForm.submit();
        }
    </script>
    <style type="text/css">
        tr{border-top: 1px solid #F4F4F4}
        .boful_fileSizeLimit_infor {
            float: left;
            height: 30px;
            margin-left: 10px;
            margin-top: 34px;
            display: block;
            overflow: hidden;
        }
    </style>
</head>

<body>
<g:uploadForm name="configForm" action="" enctype="multipart/form-data">

    <div style="overflow-y:scroll; overflow-x:hidden;height:480px;width:100%;">
        <table width="99%">
            <tr>
                <td>
                    <div id="tblist2">
                        <div class="boful_fileSizeLimit_infor">
                            <label>上传文件的最大容量</label>
                            <label>
                                <input type="text" class="fileSizeLimit_inp" maxlength="200" name="fileSizeLimit"
                                       value="${fileSizeLimit?.configValue}" size="5"/>MB
                            </label>
                            <label>
                                <input class="admin_default_but_blue"
                                       type="button" value=" 设置 "
                                       onclick="fileSizeLimitConfigSet()"/>
                                <span id="fileSizeLimit_span" style="color: red"></span>
                            </label>

                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <h1><span class="tips">(文件的容量单位为MB,文件的最小容量默认为0,0表示不限制文件大小)</span></h1>
    </div>

    %{--<div style="overflow-y:scroll; overflow-x:hidden;height:480px;width:100%;">
        <table width="99%">
            <tr>
                <td><div id="tblist2">
                    <table width="99%" border="0" cellpadding="0" cellspacing="1" bgcolor="#e8e8e8" >
                        <tr>
                            <td style="height: 50px">上传文件的最大容量</td >
                            <td><input type="text" class="fileSizeLimit_inp" maxlength="200" name="fileSizeLimit"
                                       value="${fileSizeLimit?.configValue}" size="5"/>MB

                            </td>
                            <td height="35" align="center"><input class="admin_default_but_blue"
                                                                              type="button" value=" 设置 "
                                                                              onclick="fileSizeLimitConfigSet()"/>
                            </td>

                        </tr>
                        <tr>
                            <td class="tips" colspan="3">(文件的容量单位为MB,文件的最小容量默认为0)</td>
                        </tr>
                    </table>
                </div></td>
            </tr>
        </table>
    </div>--}%
</g:uploadForm>
</body>
</html>