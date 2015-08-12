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
    <title>资讯管理</title>
    %{-- <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'newsList.css')}">--}%
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'admin_page.css')}">
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
</head>

<body>

<DIV class="programMgrMain">
    <FORM id="newsForm" name="newsForm" method="post">
        <INPUT type="hidden" value="0"
               name="offset">
        <INPUT type="hidden" value="submitTime" name="sort">
        <INPUT type="hidden"
               value="desc" name="order">
        <INPUT type="hidden" value="10" name="max">


        <div class="tbsearch" style="margin: 10px 0 10px 5px;">
            <div class="admin_content_nav">
                <span>资讯名称:</span>
                <label>
                    <INPUT class="searchm " style="width: 150px" name="searchTitle" id="searchTitle" value="${params.searchTitle}">
                </label>
                <span>发布人:</span>
                <label><INPUT name="searchPublisher" id="searchPublisher" class="searchm" value="${params.searchPublisher}"></label>
                <span>发布时间:</span>
                <label>
                    <input style="width: 150px" type="text" id="searchm" name="searchm" readonly  class="searchm" value="${params.searchm}"/>(年-月-日)</label>
                <label><INPUT class="admin_default_but_yellow " onclick="newsSearch()" type="button" value=查询
                              name="search"></label>
            </div>
        </div>

    <font color="red">${flash.message}</font>
        <div id="tblist">

            <table class="table table-hover">
                <tbody>
                <tr>
                    <th width="60"><a>选择</a></th>
                    <th><A>资讯标题</A></th>
                    <th width="120"><A>发布人</A></th>
                    <th width="120"><A>发布时间</A></th>
                    <th width="80"><a>修改</a></th>
                    <th width="80"><a>删除</a></th>
                </tr>
                <g:each in="${newsList}" status="i" var="news">
                    <tr>
                        <td align="center"><g:checkBox name="idList" value="${news.id}" checked=""
                                                       onclick="unCheckAll('selall');"/></td>
                        <td align="left">${CTools.cutString(fieldValue(bean: news, field: 'title'), 30)}</td>
                        <td align="center">${fieldValue(bean: news, field: 'publisher.nickname')}</td>
                        <td align="center"><g:formatDate format="yyyy-MM-dd"
                                                         date="${news.submitTime}"/></td>
                        <td align="center">
                            <a href="#ED" onClick="editNews(${news.id});return false;">
                                <img src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" width="14" height="14"border="0">
                            </a>
                        </td>
                        <td align="center">
                           %{-- <g:link action="newDelete" id="${news.id}" onclick="return confirm('确定删除?');"
                                    params="${[offset: params.offset, sort: params.sort, order: params.order, max: params.max, searchTitle: params.searchTitle, searchContent: params.searchContent, searchPublisher: params.searchPublisher, searchDate: params.searchDate]}">
                                <img src="${resource(dir: 'skin/blue/pc/admin/images', file: 'voice_list_delete.png')}"/></g:link>--}%
                            <div onclick="checkDeleteNews(${news?.id})"><img
                                    src="${resource(dir: 'images/skin', file: 'delete.gif')}" border="0" width="11"
                                    height="13"/></div>
                            %{-- <g:link action="newDelete" id="${news.id}" onclick="return confirm('确定删除?');"
                                     params="${[offset: params.offset, sort: params.sort, order: params.order, max: params.max, searchTitle: params.searchTitle, searchContent: params.searchContent, searchPublisher: params.searchPublisher, searchDate: params.searchDate]}"><img
                                     src="${resource(dir: 'skin/default/pc/images', file: 'ico_del.gif')}" border="0" width="11"
                                     height="13"/></g:link>--}%
                        </td>
                    </tr>
                </g:each>
                %{--<tr>
                    <td><input id="selall2" onclick="checkAll(this, 'idList')" type="checkbox" name="selall2"/> 全选</td>
                    <td></td>
                </tr>--}%
                <tr>
                    <td colspan="5">
                        <div id="progdeal">
                            <input id="selall2" onclick="checkAll(this, 'idList')"
                                   type="checkbox" name="selall2"/>
                            全选
                            <input class="btn btn-primary btn-sm" onclick="deleteNews()" type="button" value="删除所选"/>
                            <input class="btn btn-primary btn-sm" onclick="self.location.href = 'newsCreate'"
                                   type="button"
                                   value="添加资讯"/>
                        </div>
                    </td>
                    <td></td>
                </tr>
                </tbody>
            </table>
            <table width="100%"
                   border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff">
                <tr>
                    <td align="center"><div class="paginateButtons"><g:guiPaginate total="${total}"
                                                                                   params="${params}"/></div></td>
                </tr>
            </table>
        </div>
    </FORM>


        %{--<div id="progdeal">
            <input id="selall2" onclick="checkAll(this, 'idList')"
                   type="checkbox" name="selall2"/>
            全选
            <input class="btn btn-primary btn-sm" onclick="deleteNews()" type="button" value="删除所选"/>
            <input class="btn btn-primary btn-sm" onclick="self.location.href = 'newsCreate'" type="button"
                   value="添加公告"/>
        </div>--}%


        %{--    <div class="page">
                <table cellspacing="0" cellpadding="0" width="100%" border="0">
                    <tbody>
                    <tr>
                        <td width="230">总共：${total}条记录 | 每页${params.max}条 | 每页显示:</td>
                        <td width="152" align="right"><div align="left"><img
                                src="${resource(dir: 'skin/default/pc/images', file: '10.gif')}" alt="每页显示10条" name="Img10" border="0" id="Img10"
                                onclick="onPageNumPer(10)"/>&nbsp; <img id="Img50"
                                                                        onclick="onPageNumPer(50)" alt="每页显示50条"
                                                                        src="${resource(dir: 'skin/default/pc/images', file: '50.gif')}"
                                                                        border="0"/>&nbsp; <img id="Img100"
                                                                                                onclick="onPageNumPer(100)"
                                                                                                alt="每页显示100条"
                                                                                                src="${resource(dir: 'skin/default/pc/images', file: '100.gif')}"
                                                                                                border="0"/>&nbsp; <img
                                id="Img200"
                                onclick="onPageNumPer(200)" alt="每页显示200条"
                                src="${resource(dir: 'skin/default/pc/images', file: '200.gif')}" border="0"/></div></td>
                        <td align="right"><div align="right">
                            <g:paginate total="${total}" offset="${params.offset}" action="newsList"
                                        params="${[offset: params.offset, sort: params.sort, order: params.order, max: params.max, searchTitle: params.searchTitle, searchContent: params.searchContent, searchPublisher: params.searchPublisher, searchDate: params.searchDate]}"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>--}%


    <script type="text/javascript">
        var localObj = window.location;
        var contextPath = localObj.pathname.split("/")[1];
        var baseUrl = '';
        if('nts' != contextPath) {
            baseUrl = localObj.protocol + "//" + localObj.host + "/";
        } else {
            baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
        }
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
            newsForm.action = "newsList";
            newsForm.submit();
        }
        function newsSearch() {

            newsForm.action = "newsList";
            newsForm.submit()
        }
        function deleteNews() {
            setParams();
            newsForm.action = "newsDeleteList";
            newsForm.submit();
        }

        function editNews(newsId) {
            setParams();
            newsForm.offset.value = '${params.offset}';
            newsForm.action = "newsEdit?newsId=" + newsId;
            newsForm.submit();
        }
        function checkDeleteNews(tag) {
            myConfirmPars("确定删除吗?", "警告", newsDel, null, tag);
        }
        function newsDel(tag) {
            window.location.href = baseUrl + "coreMgr/newDelete?id=" + tag;
        }
    </script>
    <SCRIPT language=JavaScript>

        $(function() {
            $("#searchm").datepicker();
        })
        setParams();
        //changePageImg(10);
    </SCRIPT>
</DIV>
</body>
</html>