<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>编辑公告</title>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'zxm.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'editor', file: 'jquery/jquery-1.3.2.min.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'editor', file: 'xheditor.js')}"></script>
    <style type="text/css">
    <!--
    .STYLE1 {
        font-size: 12px;
        font-weight: bold;
    }

    .STYLE2 {
        font-size: 12px
    }

    .STYLE3 {
        color: #FF0000;
        font-weight: bold;
    }

    .STYLE6 {
        font-size: 14px
    }

    .STYLE7 {
        font-size: 14px;
        font-weight: bold;
    }

    -->
    </style>

    <script language="javaScript">
        $(pageInit);
        var editor;
        function pageInit() {
            editor = $('#content').xheditor(true, {tools: 'GStart,Cut,Copy,Paste'});
        }

        function addAnswer() {

            if (createForm.name.value == "") {
                alert("输入问题");
                createForm.name.focus();
                return false;
            }
            if (createForm.name.value.length > 500) {
                alert("标题长度应在2~20之间");
                createForm.name.focus();
                return false;
            }
            if (createForm.content.value == "") {
                alert("输入内容");
                editor.focus();
                return false;
            }
            if (createForm.content.value.length > 1000) {
                alert("答案内容过长");
                editor.focus();
                return false;
            }

            var action = "${createLink(action:'addAnswer')}";
            createForm.action = action;
            createForm.submit();
        }
        function backList() {
            createForm.action = "questionList";
            createForm.submit();
        }
    </script>

</head>

<body leftmargin="10" topmargin="5" marginwidth="0" marginheight="0">
<form method="post" name="createForm">
    <input type="hidden" name="offset" value="${params.offset}"/>
    <input type="hidden" name="sort" value="${params.sort}"/>
    <input type="hidden" name="order" value="${params.order}"/>
    <input type="hidden" name="max" value="${params.max}"/>
    <input type="hidden" name="questionId" value="${params.questionId}"/>
    <input type="hidden" name="searchName" value="${params.searchName}">
    <input type="hidden" name="searchType" value="${params.searchType}">
    <input type="hidden" name="searchDate" value="${params.searchDate}">

    <div class="x_daohang">
        <p>当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'question', action: 'questionList')}">问题反馈</a>>> 回答问题</p>
    </div>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${question}">
        <div class="errors">
            <g:renderErrors bean="${question}" as="list"/>
        </div>
    </g:hasErrors>

    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td width="2%">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr align="left" valign="top">
                        <td width="1%" height="29" valign="middle"><div align="right"></div></td>
                    <tr>
                        <td colspan="10" height="1">&nbsp;</td>
                    </tr>
                    <tr align="left" valign="top">
                        <td height="14" valign="middle"><div align="right"><span class="STYLE6"><a
                                href="ztsq_detail_yx.html"></a></span></div></td>
                        <td width="30%" valign="middle"><p align="left"><span class="STYLE3">*</span>问题标题：</p></td>
                        <td colspan="2" valign="middle"><input type="text" name="name" id="name" size="87"
                                                               value="${question.name.encodeAsHTML()}"/></td>
                        <td width="3%" valign="middle">&nbsp;</td>
                        <td width="16%" valign="middle">&nbsp;</td>
                        <td width="8%" valign="middle">&nbsp;</td>
                    </tr>
                    <tr align="left" valign="top">
                        <td valign="middle"></td>
                        <td valign="middle">&nbsp;</td>
                        <td colspan="2" valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                    </tr>
                    <tr align="left" valign="top">
                        <td height="14" valign="middle"><div align="right"><span class="STYLE6"><a
                                href="ztsq_detail_yx.html"></a></span></div></td>
                        <td valign="middle"><div align="left"><span class="STYLE3">*</span>回答内容：</div></td>
                        <td colspan="4" valign="middle"><label>
                            <textarea id="content" name="content" rows="16" cols="80"
                                      style="width: 555">${question.answer}</textarea>
                        </label></td>
                        <td valign="middle">&nbsp;</td>
                    </tr>
                    <tr align="left" valign="top">
                        <td valign="middle"></td>
                        <td valign="middle">&nbsp;</td>
                        <td colspan="2" valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                    </tr>
                    <tr align="left" valign="top">
                        <td valign="middle"></td>
                        <td valign="middle">&nbsp;</td>
                        <td colspan="2" valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                    </tr>
                    <tr align="left" valign="top">
                        <td valign="middle"></td>
                        <td valign="middle">&nbsp;</td>
                        <td width="28%" valign="middle" align="right">
                            <a href="#"><img src="${resource(dir: 'images/skin', file: 'ok.gif')}" border="0" onClick="addAnswer();
                            return false;"/></a>
                            <a href="#"><img src="${resource(dir: 'images/skin', file: 'back.gif')}" border="0" onClick="backList();
                            return false;"/></a></td>
                        <td width="24%" valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                    </tr>
                </table></td>
        </tr>
    </table>
</form>
</body>
</html>
