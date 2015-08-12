<!DOCTYPE html>
<html>
<head>
    <title>没有权限！</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'ouknow_error.css')}">
    <script type="text/javascript" src="${createLinkTo(dir:'js',file:'jquery/jquery-1.11.1.min.js')}"></script>
    <script type="text/javascript">
        $(function(){
            var back = document.createElement("a");
            back.innerText = "返回首页";
            back.href = "/";
            $("p").append(back);
        });
    </script>
</head>

<body>
<div class="error_body">
    <div class="error_box">
        <div class="error_icon">
            <img src="${resource(dir: 'skin/blue/pc/front/images', file: 'error.png')}"/>
        </div>

        <div class="error_infor">
            <h1>没有权限！</h1>

            <p class="">${errorMsg}</p>
        </div>
    </div>
</div>
</body>
</html>