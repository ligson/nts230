<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-2-20
  Time: 上午11:44
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>上传成功</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_space_upload.css')}"/>
</head>

<body>
<div class="my_space_upload_success">
    <p>资源上传成功!</p>

    <div class="my_space_upload_success_infor">
        <div class="my_space_upload_success_good">
            恭喜！你的资源成功保存.
        </div>

        <div class="my_space_upload_success_continus">
            <span class="my_space_upload_success_continu"><a
                    href="${createLink(controller: 'programMgr', action: 'programCreate')}">继续上传</a></span>
            <span class="my_space_upload_success_continu_view">
                <a href="${createLink(controller: 'programMgr', action: 'programList')}">
                    查看已上传内容</a></span>
        </div>
    </div>
</div>

<div style="height: 200px; width: 1920px"></div>

</body>
</html>