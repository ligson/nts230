<%--
  Created by IntelliJ IDEA.
  User: boful
  Date: 14-12-16
  Time: 上午9:26
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>发布成功</title>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_space_upload.css')}"/>
</head>

<body>
<div class="my_space_upload_success">

    <div class="my_space_upload_success_infor">
        <div class="my_space_upload_success_good">
            恭喜！您的专辑已经成功发布.
        </div>

        <div class="my_space_upload_success_continus">
            <span class="my_space_upload_success_continu"><a
                    href="${createLink(controller: 'my', action: 'myEditMetaContent', params: [id: programId])}">编辑元数据</a>
            </span>
            <span class="my_space_upload_success_continu_view">
                <a href="${createLink(controller: 'my', action: 'myManageProgram')}">
                    查看我的资源</a></span>
        </div>
    </div>
</div>
</body>
</html>