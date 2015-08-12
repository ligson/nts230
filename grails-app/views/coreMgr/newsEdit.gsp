<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/后台单页.dwt" codeOutsideHTMLIsLocked="false" -->

<head>
    <title>修改公告</title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_new_edit.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}"> l
<ckeditor:resources/>
    <script language="javaScript" type="text/javascript">
        $(pageInit);
        var editor;
        function pageInit() {
            //editor=$('#content2').xheditor(true,{tools:'GStart,Cut,Copy,Paste'});
        }

        function addNews() {
            if (consumerForm.title.value == "") {
                alert("输入标题");
                consumerForm.title.focus();
                return false;
            }
            /*var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
            if (patrn.test(consumerForm.title.value) == false) {
                alert("标题含有特殊字符!");
                return false;
            }*/
            if (consumerForm.title.value.length > 100) {
                alert("标题长度不大于100字符！");
                consumerForm.title.focus();
                return false;
            }
            if (consumerForm.content.value == "") {
                alert("输入内容");
                editor.focus();
                return false;
            }
            if (consumerForm.content.value.length > 20000) {
                alert("回复内容过长");
                editor.focus();
                return false;
            }
            consumerForm.action = "${createLink(action:'newsUpdate')}";
            consumerForm.submit();
        }
        function backList() {
            history.back(-1);
        }
    </script>
</head>

<body>
<div id="contanier">
    <!--===主界面开始===-->
    <div id="subpage">
        <!-- InstanceBeginEditable name="main" -->
        <div id="single_s">
            <div class="programMgrMain">
                <form method="post" name="consumerForm">
                    <input type="hidden" name="offset" value="${params.offset}"/>
                    <input type="hidden" name="sort" value="${params.sort}"/>
                    <input type="hidden" name="order" value="${params.order}"/>
                    <input type="hidden" name="max" value="${params.max}"/>

                    <input type="hidden" name="newsId" value="${params.newsId}"/>
                    <input type="hidden" name="searchTitle" value="${params.searchTitle}"/>
                    <input type="hidden" name="searchContent" value="${params.searchContent}"/>
                    <input type="hidden" name="searchPublisher" value="${params.searchPublisher}"/>
                    <input type="hidden" name="searchDate" value="${params.searchDate}"/>
                    <table width="100%">
                        <tr>
                            <td>
                                <div id="tblist2">
                                    <table border="0">
                                        <tr>
                                            <td height="35" colspan="2" class="infor_fix">修改公告</td>
                                        </tr>
                                        <tr>
                                            <td width="10%" class="infor_fix_title">公告标题</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <label>
                                                    <input name="title" type="text" class="form-control" id="name"
                                                           value="${news.title.encodeAsHTML()}" size="90"
                                                           maxlength="100"/>
                                                </label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="infor_fix_title">公告内容</td>
                                        <tr>
                                            <td>
                                                <label>
                                                    <ckeditor:editor name="content" height="400px" width="80%"
                                                                     id="content2">
                                                        ${news.content}
                                                    </ckeditor:editor>

                                                </label></td>
                                        </tr>
                                        <tr>
                                            <td height="35" colspan="2" align="center"><input
                                                    class="admin_default_but_blue"
                                                    type="button" value=" 保存 "
                                                    onClick="addNews()"/>
                                                <input class="admin_default_but_blue" type="button" value=" 关闭 "
                                                       onClick="backList()"/></td>
                                        </tr>
                                    </table>
                                </div></td>
                        </tr>
                        <tr>
                        </tr>
                    </table>
                </form>
            </div>
        </div>
        <!-- InstanceEndEditable --></div>
    <!--===主界面结束===-->
</div>
</body>
<!-- InstanceEnd --></html>
