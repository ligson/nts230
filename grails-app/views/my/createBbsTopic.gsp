<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>网络教学资源发布系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}"/>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" type=text/css
          rel=stylesheet>

    <style type="text/css">
    .questionTab {
        width: 700px;
        margin: 10px;
    }

    .button {
        padding: 2px 4px 2px 4px;
        cursor: hand
    }

    td {
        text-align: left;
    }
    </style>

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
    <script LANGUAGE="javascript">
        function check() {
            if (Jtrim(form1.name.value) == "") {
                alert("主题不能为空，请重新输入。");
                form1.name.focus();
                return false;
            }

            if (Jtrim(form1.content.value) == "") {
                alert("内容不能为空，请重新输入。");
                form1.content.focus();
                return false;
            }

            return true;
        }

    </script>

</head>

<body>
<div class="x_daohang">
    <p>当前位置：<a href="${createLink(controller: 'my', action: 'myInfo')}">个人空间</a>>><a href="${createLink(controller: 'my', action: 'bbsList')}">用户留言</a>>>发帖</p>
</div>

<div class="body" style="width:95%">
    <form action="/my/saveBbsTopic" method="post" id="form1" name="form1" onsubmit="return check();">
        <input type="hidden" name="maxQuestionIndex" id="maxQuestionIndex" value="1">
        <input type="hidden" name="maxOptionIndex" id="maxOptionIndex" value="1">

        <div class="dialog" id="QuestionDiv">
            <table class="questionTab" style=" border: 0px solid #ccc;" id="QuestionTable0">
                <tr>
                    <td>发帖人：</td>
                    <td>
                        <input type="text" name="consumer.name" style="width:100px;" readonly
                               value="${session.consumer.name}">
                    </td>
                </tr>

                <tr>
                    <td>主&nbsp;&nbsp;题：</td>
                    <td>
                        <input type="text" name="name" style="width:600px;" value="">
                    </td>
                </tr>

                <tr>
                    <td>内&nbsp;&nbsp;容：</td>
                    <td>
                        <textarea name="content" style="width:600px;height:300px;"></textarea>
                    </td>
                </tr>
            </table>
        </div>

        <div class="buttons" style="padding-bottom:5px; padding-right:20px;">
            <input type="submit" class="save" value="提交"/>
        </div>
    </form>
</div>
</body>
</html>