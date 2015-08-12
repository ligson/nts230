<HTML xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <title><g:message code="application.name" default="确然多媒体资源应用系统"/></title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'regedit.css')}"/>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'list_style.css')}"/>

    <script LANGUAGE="JavaScript">
        function toLogin() {
            document.location.href = baseUrl + "index/login";
        }
    </script>
</head>

<body>
<!-- 板块1开始段落 -->
<div id="contentA" class="area areabg1" style="height: 81%;">
    <div class="ban_x bcorlor1" style=" text-align:left"><span>新用户注册</span></div>

    <div class="regedit center" style=" width:510px; border-bottom:none;text-align:left;">
        <DIV id=regist class=w>
            <DIV class=mc>
                <DIV class=form style="margin-left:100px;font-size: 15px;margin-top:40px;">
                    <g:if test="${isOK}">
                        <p class="ftx04" style="height:25px;font-size:16px;color:#4db652;">创建成功！</p>

                        <p style="height:25px;">用户${name}创建成功，请等候管理员的审批。</p>
                    </g:if>
                    <g:else>
                        <g:hasErrors bean="${consumer}">
                            <div class="errors">
                                <g:renderErrors bean="${consumer}" as="list"/>
                            </div>
                        </g:hasErrors>
                        <p class="ftx04" style="height:25px;font-size:16px; color:red;">创建失败！</p>

                        <p style="height:25px;">用户${name}创建失败，请稍后再试。</p>
                    </g:else>
                    <A href="${createLink(controller: 'index', action: 'index')}" style="color:#2F8DD5;font-size:12px;height:20px;">点击此处返回首页&gt;&gt;</A>
                </DIV>
            </DIV>
        </DIV>
        <dd style=" text-align:center;margin-bottom:30px;margin-top:20px; margin-left: 10px">
            <button onclick="toLogin();" class="btn btn-primary"
                    style="background-color: #4db652;
                    border:1px solid #2ca031;
                    padding: 6px 20px;
                    color: #FFF;
                    margin-left:-240px;"
                    type="button">登录账号</button>
        </dd>
    </div>
</div>
<!-- 板块1结束段落 -->
</body>
</html>
