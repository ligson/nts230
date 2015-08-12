<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 14-3-12
  Time: 下午2:27
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.edit.name')}${message(code: 'my.group.name')}</title>
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'fromBordCreate.css')}">
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
</head>

<body>
<div class="community_form_content">
    <div class="community_form_content_creat">
        <h1>${message(code: 'my.edit.name')}${message(code: 'my.group.name')}</h1>

        <div class="form_creat_title">
            <label>
                <input class="form-control" type="text" value="请输入小组标题">
            </label>
        </div>

        <div class="form_creat_img">
            <label>
                <input class="form-control" type="button" value="上传小组图片">
            </label>

            <p>[上传小组海报图片]</p>
        </div>

        <div class="form_creat_describe">
            <label>
                <textarea class="form-control">请填写小组描述</textarea>
            </label>
        </div>
    </div>
</div>
</div>
</body>
</html>