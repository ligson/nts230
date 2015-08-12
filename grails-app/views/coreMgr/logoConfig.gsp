<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-4-1
  Time: 上午11:51
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
    <script Language="JavaScript" type="text/javascript">
        function logoConfigSet() {
            var configForm = document.getElementById("configForm");
            configForm.action = "logoConfigSet";
            configForm.submit();
        }

    </script>
</head>

<body>
<style type="text/css">
#tblist2 h1 {
    font-size: 18px;
    margin: 10px 0;
    font-weight: normal;
    color: #333;
}

.boful_logo_small {
    width: 240px;
    height: 40px;
    padding: 10px 0;
    background: #22272E;
    border: 2px solid #B4BAC7;
    float: left;
}

.boful_logo_small a {
    width: 240px;
    height: 40px;
    border: 0;
    display: block;
    overflow: hidden;
}

.boful_logo_infor {
    float: left;
    height: 30px;
    margin-left: 10px;
    margin-top: 34px;
    display: block;
    overflow: hidden;
}

.tipsa {
    color: rgba(212, 0, 0, 0.76);
    font-size: 14px;
}
</style>
<g:uploadForm name="configForm" controller="coreMgr" action="" enctype="multipart/form-data">

    <div style="overflow-y:scroll; overflow-x:hidden;height:480px;width:100%;">
        <table width="99%">
            <tr>
                <td>
                    <div id="tblist2">
                        <h1>网站LOGO&nbsp;&nbsp;&nbsp;<span class="tipsa">尺寸:240*40;支持格式:jpg,png,gif， 设置后请刷新页面;但页面可能设置了缓存不能及时刷新</span></h1>

                        <div class="boful_logo_small">
                            <a href="${createLink(controller: 'index', action: 'index')}"><img
                                    src="${webLogeUrl(filePath: 'upload/Logo')}"/></a>
                        </div>

                        <div class="boful_logo_infor">

                            <label>
                                <input name="fileLOGO" id="file2" type="file" size="20"/>
                            </label>
                            <label>
                                <input class="admin_default_but_blue" type="button" value=" 替换 "
                                       onclick="logoConfigSet()"/>
                            </label>

                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</g:uploadForm>
</body>
</html>