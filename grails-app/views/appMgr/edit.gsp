<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/后台单页.dwt" codeOutsideHTMLIsLocked="false" -->

<head>
    <style type="text/css">
        textarea{
            vertical-align: top;
            width: 400px;
            height: 150px;
            margin: 1px 0;
            padding: 1px 2px;
        }
    </style>
    <ckeditor:resources/>
    <script language="javaScript" type="text/javascript">
        $(pageInit);
        var editor;
        function pageInit()
        {
            //editor=$('#content2').xheditor(true,{tools:'GStart,Cut,Copy,Paste'});
        }

        function addNews()
        {
            if (consumerForm.title.value=="")
            {
                alert("输入标题");
                consumerForm.title.focus();
                return false;
            }
            if (consumerForm.title.value.length >100)
            {
                alert("标题长度不大于100字符！");
                consumerForm.title.focus();
                return false;
            }
            if (consumerForm.content.value=="")
            {
                alert("输入内容");
                editor.focus();
                return false;
            }
            if (consumerForm.content.value.length > 20000)
            {
                alert("回复内容过长");
                editor.focus();
                return false;
            }

            consumerForm.action="${createLink(action:'update')}";
            consumerForm.submit();
        }
        function backList()
        {
            consumerForm.action="list";
            consumerForm.submit();
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
                <form method="post" name="consumerForm" >
                    <input type="hidden" name="offset" value="${params.offset}" />
                    <input type="hidden" name="sort" value="${params.sort}" />
                    <input type="hidden" name="order" value="${params.order}" />
                    <input type="hidden" name="max" value="${params.max}" />

                    <input type="hidden" name="newsId" value="${params.newsId}" />
                    <input type="hidden" name="searchTitle" value="${params.searchTitle}" />
                    <input type="hidden" name="searchContent" value="${params.searchContent}" />
                    <input type="hidden" name="searchPublisher" value="${params.searchPublisher}" />
                    <input type="hidden" name="searchDate" value="${params.searchDate}" />
                    <div class="daohangsin" > <span class="dangqian">当前位置：</span><A
                            href="#">应用管理</A>&gt;&gt;<a href="${createLink(controller: 'appMgr', action: 'index')}">公告管理</a>&gt;&gt; 修改公告</div>
                    <table width="100%">
                        <tr>
                            <td><div id="tblist2">
                                <table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#e8e8e8"  >
                                    <tr>
                                        <th height="35" colspan="2">修改公告</th>
                                    </tr>
                                    <tr>
                                        <td width="10%" style="font-weight: bold">公告标题</td>
                                        <td width="90%" ><div align="left" >
                                            <input name="title" type="text" class="tbinpr2" id="name" value="${news.title.encodeAsHTML()}" size="90" maxlength="100" />
                                        </div></td>
                                    </tr>
                                    <tr>
                                        <td style="font-weight: bold">公告内容</td>
                                        <td>
                                            <label>
                                                <ckeditor:editor name="content" height="400px" width="80%" id="content2">
                                                    ${news.content}
                                                </ckeditor:editor>

                                            </label></td>
                                    </tr>
                                    <tr>
                                        <td height="35" colspan="2" align="center"><input class="subbtn" type="button" value=" 保存 " onClick="addNews()"/>
                                            <input class="subbtn" type="button" value=" 关闭 "  onClick="backList()"/></td>
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
