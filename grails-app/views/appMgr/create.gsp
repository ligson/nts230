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
  <script type="text/javascript" src="${resource(dir: 'js',file: 'boful/common/common.js')}"></script>
    <ckeditor:resources/>
</head>
<body>
<div id="main"><!-- InstanceBeginEditable name="main" -->
    <DIV class="programMgrMain" >
        <FORM id="newsForm" name="newsForm" method="post">
            <INPUT type="hidden" value="0"
                   name="offset">
            <INPUT type="hidden" value="submitTime" name="sort">
            <INPUT type="hidden"
                   value="desc" name="order">
            <INPUT type="hidden" value="10" name="max">
            <DIV class="x_daohang" > <span class="dangqian">当前位置：</span><A
                    href="${createLink(controller:'appMgr',action:'index')}">应用管理</A>&gt;&gt;<a href="${createLink(controller:'appMgr',action:'index')}">公告管理</a> &gt;&gt; 添加公告</DIV>
            <div> </div>
            <TABLE width="100%">
                <TBODY>
                <TR>
                    <TD><div id="tblist2">
                        <table width="790" border="0" cellpadding="0" cellspacing="1" bgcolor="#e8e8e8"  >
                            <tr>
                                <th height="35" colspan="2">添加公告</th>
                            </tr>
                            <tr>
                                <td width="15%">公告标题</td>
                                <td width="80%"><input  type="text" class="tbinpr2" maxlength="100" name="title" id="name" size="90" /></td>
                            </tr>
                            <tr>
                                <td>公告内容</td>
                                <td>
                                    <ckeditor:editor name="content" height="400px" width="80%" id="content2">
                                    </ckeditor:editor>
                                </td>
                            </tr>
                            <tr>
                                <td height="35" colspan="2" align="center"><input onclick="addNews();" class="subbtn" type="button" value=" 确定 " />
                                    <input onclick="backList();" class="subbtn" type="button" value=" 返回 "  /></td>
                            </tr>
                        </table>
                    </div></TD>
                </TR>
                </TBODY>
            </TABLE>
        </FORM>
<SCRIPT language=JavaScript>
    changePageImg(10);
</SCRIPT>
<script type="text/javascript">
    function addNews() {

        if (newsForm.title.value == "") {
            alert("输入标题");
            newsForm.title.focus();
            return false;
        }
        var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
        if (patrn.test(newsForm.title.value) == false) {
            alert("标题含有特殊字符!");
            newsForm.title.focus();
            return false;
        }
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

        newsForm.action = "save";
        newsForm.submit();
    }
    function backList() {
        newsForm.action = "list";
        createForm.submit();
    }
</script>
</DIV>
</div>

</body>
</html>