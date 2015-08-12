<!DOCTYPE html>
<html>
<head>
    <title>没有权限！</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'ouknow_error.css')}">
</head>

<body>
<div class="error_body">
    <div class="error_box">
        <div class="error_icon">
            <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'error.png')}"/>
        </div>

        <div class="error_infor">
            <h1>没有权限！</h1>

            <p class="">${errorMsg} <a href="/admin/">返回登陆</a></p>
        </div>
    </div>
</div>
</body>
</html>