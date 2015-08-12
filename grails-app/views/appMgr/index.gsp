<%@ page import="nts.utils.CTools" %>
<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午5:24
  To change this template use File | Settings | File Templates.
--%>
<html>
<head>
    <title>公告管理</title>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
</head>

<body>
<DIV class="x_daohang"><span class="dangqian">当前位置：</span><A
        href="#">应用管理</A>&gt;&gt; 公告管理</DIV>

<DIV class="programMgrMain">
    <FORM id="newsForm" name="newsForm" method="post">
        <INPUT type="hidden" value="0"
               name="offset">
        <INPUT type="hidden" value="submitTime" name="sort">
        <INPUT type="hidden"
               value="desc" name="order">
        <INPUT type="hidden" value="10" name="max">



        <div class="tbsearch" style="margin: 10px 0 10px 5px;">
            <TABLE cellSpacing=3 cellPadding=3>
                <TBODY>
                <TR>
                    <TD align=middle>公告名称:</TD>
                    <TD align=left><INPUT class=searchl name=searchTitle></TD>
                    <TD align=middle>发布人:</TD>
                    <TD align=left><INPUT class=searchs name=searchPublisher></TD>
                    <TD align=middle>发布时间:</TD>
                    <TD align=left><input type="text" id="date-input" class="searchm " name="searchm"/></TD>
                    <TD align=middle><INPUT class=searchbtn onclick=newsSearch() type=button value=查询 name=search></TD>
                </TR>
                </TBODY>
            </TABLE>
        </div>

        <div></div>
        <TABLE width="100%">
            <TBODY>
            <TR>
                <TD><div id="tblist">
                    <font color="red">${flash.message}</font>
                    <TABLE width="100%"
                           border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff">
                        <TBODY>
                        <TR class="th">
                            <th width="7%">选择</th>
                            <th height=28><A
                                    onclick="orderBy('title');
                                    return false;"
                                    href="http://42.62.52.40/nts/news/list#">公告标题</A></th>
                            <th width="10%"><A
                                    onclick="orderBy('publisher');
                                    return false;"
                                    href="http://42.62.52.40/nts/news/list#">发布人</A></th>
                            <th width="13%"><A
                                    onclick="orderBy('submitTime');
                                    return false;"
                                    href="http://42.62.52.40/nts/news/list#">发布时间</A></th>
                            <th width="5%">修改</th>
                            <th class=STYLE5 align=middle width="5%">删除</th>
                        </TR>
                        <g:each in="${newsList}" status="i" var="news">
                            <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                                <td>&nbsp;&nbsp;<g:checkBox name="idList" value="${news.id}" checked=""
                                                            onclick="unCheckAll('selall');"/></td>
                                <td height="23" nowrap="nowrap"
                                    class="STYLE5">&nbsp;${CTools.cutString(fieldValue(bean: news, field: 'title'), 30)}</td>
                                <td align="center"
                                    class="STYLE5">${fieldValue(bean: news, field: 'publisher.nickname')}</td>
                                <td align="center" class="STYLE5"><g:formatDate format="yyyy-MM-dd"
                                                                                date="${news.submitTime}"/></td>
                                <td align="center" class="STYLE5">
                                    <a href="#ED" onClick="editNews(${news.id});
                                    return false;"><img src="${resource(dir: 'skin/blue/pc/admin/images', file: 'ico_edit.gif')}" alt="" width="14"
                                                        height="14" border="0"></a>
                                </td>
                                <td align="center" class="STYLE5">
                                    <g:link action="delete" id="${news.id}" onclick="return confirm('确定删除?');"
                                            params="${[offset: params.offset, sort: params.sort, order: params.order, max: params.max, searchTitle: params.searchTitle, searchContent: params.searchContent, searchPublisher: params.searchPublisher, searchDate: params.searchDate]}"><img
                                            src="${resource(dir: 'skin/blue/pc/admin/images', file: 'ico_del.gif')}" border="0" width="11"
                                            height="13"/></g:link>
                                </td>
                            </tr>
                        </g:each>

                        </TBODY>
                    </TABLE>
                </div>

                    <div id="progdeal">
                        <input id="selall2" onclick="checkAll(this, 'idList')"
                               type="checkbox" name="selall2"/>
                        全选
                        <input class="subbtn" onclick="deleteNews()" type="button" value="删除所选"/>
                        <input class="subbtn" onclick="self.location.href = 'create'" type="button" value="添加公告"/>
                    </div></TD>
            </TR>
            </TBODY>
        </TABLE>

        <div class="page">
            <table cellspacing="1" cellpadding="1" width="100%" border="0">
                <tbody>
                <tr>
                    <td width="230">总共：${total}条记录 | 每页${params.max}条 | 每页显示:</td>
                    <td width="152" align="right"><div align="left"><img
                            src="${resource(dir: 'skin/blue/pc/admin/images', file: '10.gif')}" alt="每页显示10条" name="Img10" border="0" id="Img10"
                            onclick="onPageNumPer(10)"/>&nbsp; <img id="Img50"
                                                                    onclick="onPageNumPer(50)" alt="每页显示50条"
                                                                    src="${resource(dir: 'skin/blue/pc/admin/images', file: '50.gif')}"
                                                                    border="0"/>&nbsp; <img id="Img100"
                                                                                            onclick="onPageNumPer(100)"
                                                                                            alt="每页显示100条"
                                                                                            src="${resource(dir: 'skin/blue/pc/admin/images', file: '100.gif')}"
                                                                                            border="0"/>&nbsp; <img
                            id="Img200"
                            onclick="onPageNumPer(200)" alt="每页显示200条"
                            src="${resource(dir: 'skin/blue/pc/admin/images', file: '200.gif')}" border="0"/></div></td>
                    <td align="right"><div align="right">
                        <g:paginate total="${total}" offset="${params.offset}" action="list"
                                    params="${[offset: params.offset, sort: params.sort, order: params.order, max: params.max, searchTitle: params.searchTitle, searchContent: params.searchContent, searchPublisher: params.searchPublisher, searchDate: params.searchDate]}"/>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </FORM>
    <SCRIPT language=JavaScript>
        changePageImg(10);
        $(function () {
            $("#date-input").datepicker();
        })
    </SCRIPT>
    <script type="text/javascript">
        function setParams() {
            newsForm.searchTitle.value = "${params.searchTitle}";
            newsForm.searchPublisher.value = "${params.searchPublisher}";
            newsForm.searchm.value = "${params.searchm}";
        }
        function onPageNumPer(max) {
            //调用setParams()对查询参数进行负值
            setParams();
            newsForm.max.value = max;
            newsForm.offset.value = 0;
            newsForm.action = "list";
            newsForm.submit();
        }
        function newsSearch() {
            newsForm.action = "list";
            newsForm.submit()
        }
        function deleteNews() {
            setParams();
            newsForm.action = "deleteList";
            newsForm.submit();
        }

        function editNews(newsId) {
            setParams();
            newsForm.action = "edit?newsId=" + newsId + "";
            newsForm.submit();
        }
    </script>
</DIV>
</body>
</html>