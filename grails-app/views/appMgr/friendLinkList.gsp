<%@ page import="nts.utils.CTools" %>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <link href="${createLinkTo(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>

    <title>类库列表</title>
    <style type="text/css">
    <!--
    .STYLE1 {
        color: #8B0D11;
        font-weight: bold;
        font-size: 12px;
    }

    .STYLE4 {
        font-family: "宋体";
        font-size: 12px;
    }

    .STYLE5 {
        font-size: 12px
    }

    .STYLE6 {
        color: #990000;
        font-weight: bold;
    }

    .STYLE8 {
        font-size: 12px;
    }

    .STYLE9 {
        color: #990000;
        font-weight: bold;
        font-size: 12px;
    }

    -->
    </style>

    <script LANGUAGE="javascript">

        function editNews(newsId) {
            newsForm.action = "editFriendLink?id=" + newsId + "";
            newsForm.submit();
        }

        function newsUpdate() {
            if (newsForm.updateTitle.value == "") {
                alert("请输入公告标题");
                newsForm.updateTitle.focus();
                return false;
            }
            if (newsForm.updateContent.value == "") {
                alert("请输入公告内容");
                newsForm.updateContent.focus();
                return false;
            }
            newsForm.action = "updateFriendLink";
            newsForm.submit();
        }

        function maxShow(max) {
            newsForm.max.value = max;
            newsForm.offset.value = 0;
            newsForm.action = "friendLinkList";
            newsForm.submit();
        }


        function deleteNews() {
            newsForm.action = "deleteFriendLink";
            newsForm.submit();
        }
    </script>

</head>

<body leftmargin="5">
<div class="x_daohang">
    <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>> 外部资源
</div

<form method="post" name="newsForm" id="newsForm">

    <input type="hidden" name="offset" value="${params.offset}"/>
    <input type="hidden" name="sort" value="${params.sort}"/>
    <input type="hidden" name="order" value="${params.order}"/>
    <input type="hidden" name="max" value="${params.max}"/>

    <table width="99%" style="margin: 10px 0 0 10px; border-top:1px #e2e3e4 solid;">
        <tr>
            <td><table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
                <tr bgcolor="#BDEDFB">
                    <td width="8%" height="28" align="center" class="STYLE5 th">选择</td>
                    <td width="22%" height="28" align="center" class="STYLE5 th">链接名称</td>
                    <td width="50%" align="center" class="STYLE5 th">链接url</td>

                    <td width="10%" align="center" class="STYLE5 th">修改</td>
                    <td width="10%" align="center" class="STYLE5 th">删除</td>
                </tr>
                <g:each in="${friendLinkList}" status="i" var="friendLink">
                    <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                        <td>&nbsp;&nbsp;<g:checkBox name="idList" value="${friendLink.id}" checked=""
                                                    onclick="unCheckAll('selall');"/></td>
                        <td height="23" nowrap="nowrap"
                            class="STYLE5">&nbsp;${CTools.cutString(fieldValue(bean: friendLink, field: 'name'), 30)}</td>
                        <td class="STYLE5"><a target="_blank"
                                              href="${fieldValue(bean: friendLink, field: 'url')}">${fieldValue(bean: friendLink, field: 'url')}</a>
                        </td>

                        <td align="center" class="STYLE5">
                            <a href="#ED" onClick="editNews(${friendLink.id});
                            return false;"><img src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" width="14" height="14"
                                                border="0"></a>
                        </td>
                        <td align="center" class="STYLE5">
                            <g:link action="deleteFriendLink" params="[idList: friendLink.id]"
                                    onclick="return confirm('确定删除?');"><img src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0"
                                                                            width="11" height="13"/></g:link>
                        </td>
                    </tr>
                </g:each>
            </table>
                <table width="93%" height="15" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td align="left" width="10%"></td>
                    </tr>
                </table>
                <input id="selall" name="selall" onclick="checkAll(this, 'idList')" type="checkbox">全选&nbsp;
                <input class="subbtn" type="button" value="删除所选" onClick="deleteNews()"/>
                <input class="subbtn" type="button" value="添加链接" onClick="self.location.href = 'createFriendLink'"/>

    </table>
    <table width="93%" height="20" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td align="left" width="10%">&nbsp;</td>
            <td align="right">&nbsp;</td>
        </tr>
    </table>

    <table width="100%" height="16" border="0" cellpadding="1" cellspacing="1" bgcolor="#E9E8E7">
        <tbody>
        <tr>
            <td height="16" align="left">
                &nbsp;总共：${friendLinkTotal} 条记录&nbsp;|&nbsp;每页${params.max}条&nbsp;|&nbsp;每页显示:
                <img onClick="maxShow(10)" id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" border="0"
                     class="STYLE8" title="每页显示10条"/>
                <img onClick="maxShow(50)" id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" border="0"
                     class="STYLE8" title="每页显示50条"/>
                <img onClick="maxShow(100)" id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" border="0"
                     class="STYLE8" title="每页显示100条"/>
                <img onClick="maxShow(200)" id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" border="0"
                     class="STYLE8" title="每页显示200条"/></td>
            <td width="125" align="right"><g:paginate total="${friendLinkTotal}" offset="${params.offset}" action="list"
                                                      params="${params}"/>&nbsp;&nbsp;</td>
        </tr>
        </tbody>
    </table>

    <p>&nbsp;</p>

    <p><br/>
    </p>

</form>
<script Language="JavaScript">
    changePageImg(${params.max});
</script>
</body>
</html>

