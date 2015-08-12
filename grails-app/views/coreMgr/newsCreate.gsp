<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午5:24
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>添加公告</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
    <ckeditor:resources/>

    <style type="text/css">
    .voice_add_title {
        height: 10px;
    }

    .f_size {
        font-size: 12px;
        color: #7a7a7a;
    }

    .add_title {
        display: block;
        overflow: hidden;
    }

    .h_size {
        font-size: 16px;
        color: #333;
        font-weight: bold;
        height: 40px;
        line-height: 20px;
        margin: 0;
        background: #FFF;
        padding: 10px 0 10px 10px;
    }
    </style>
</head>

<body>
<div id="main"><!-- InstanceBeginEditable name="main" -->
    <DIV class="programMgrMain">
        <FORM id="newsForm" name="newsForm" method="post">
            <INPUT type="hidden" value="0"
                   name="offset">
            <INPUT type="hidden" value="submitTime" name="sort">
            <INPUT type="hidden"
                   value="desc" name="order">
            <INPUT type="hidden" value="10" name="max">

            <div class="add_title" >
                <h1 class="h_size" style="text-align: center">添加公告</h1>
            </div>
            <TABLE width="100%">
                <TBODY>
                <TR>
                    <TD><div id="tblist2">
                        <table width="100%">
                            <tr><td class="voice_add_title"></td></tr>
                            <tr>
                                <td width="80%"><input type="text" class="form-control  f_size" style="width:100%"
                                                       value=""
                                                       maxlength="100" name="title" id="name" size="90"/></td>
                            </tr>
                            <tr><td class="voice_add_title"></td></tr>
                            <tr>
                                <td>
                                    <ckeditor:config var="toolbar_bar01">
                                        [
                                           ['Source'],
                                           ['Bold','Italic','Underline','Strike'],
                                           ['Format'],
                                           ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
                                           ['Link','Unlink','Anchor'],
                                           ['Image','Flash','Table','Smiley','PageBreak']
                                       ]
                                    </ckeditor:config>
                                    <ckeditor:editor name="content" height="300px" width="100%" id="content2" toolbar="bar01" >
                                    </ckeditor:editor>

                                </td>
                            </tr>
                            <tr>
                                <td height="35" colspan="2" align="center"><input onclick="addNews();"
                                                                                  class="btn btn-primary"
                                                                                  type="button" value=" 确定 "/>
                                    <input onclick="backList();" class="btn btn-primary" type="button" value=" 返回 "/>
                                </td>
                            </tr>
                        </table>
                    </div></TD>
                </TR>
                </TBODY>
            </TABLE>
        </FORM>
        <SCRIPT language=JavaScript>
            //changePageImg(10);
        </SCRIPT>
        <script type="text/javascript">
            $(function(){
               /* CKEDITOR.replace("tblist2", {
                    toolbar: [
                        ['Bold','Italic','Underline','Strike'], ['Cut','Copy','Paste'],
                        ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
                        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock']
                    ]
                })*/;

            })
            function addNews() {

                if (newsForm.title.value == "") {
                    alert("输入标题");
                    newsForm.title.focus();
                    return false;
                }
                /*
                var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
                if (patrn.test(newsForm.title.value) == false) {
                    alert("标题含有特殊字符!");
                    return false;
                }*/
                if (newsForm.title.value.length > 100) {
                    alert("标题长度不大于100字符！");
                    newsForm.title.focus();
                    return false;
                }
                if (newsForm.content.value == "") {
                    alert("输入内容");
                    //editor.focus();
                    return false;
                }
                if (newsForm.content.value.length > 20000) {
                    alert("回复内容过长");
                    //editor.focus();
                    return false;
                }

                newsForm.action = "newsSave";
                newsForm.submit();
            }
            function backList() {
                newsForm.action = "newsList";
                newsForm.submit();
            }
        </script>
    </DIV>
</div>

</body>
</html>