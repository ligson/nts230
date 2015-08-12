<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午5:24
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>纠错管理</title>
    <script type="text/javascript" src="${resource(dir: 'js',file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'boful/common/allselect.js')}"></script>
</head>
<body>
<DIV class="programMgrMain" >
    <FORM id="errorForm" name="errorForm" method="post">
        <INPUT type="hidden" value="0"
               name="offset">
        <INPUT type="hidden" value="submitTime" name="sort">
        <INPUT type="hidden"
               value="desc" name="order">
        <INPUT type="hidden" value="10" name="max">
        <DIV class="x_daohang" > <span class="dangqian">当前位置：</span><A
                href="#">应用管理</A>&gt;&gt;纠错管理 </DIV>
        <div class="tbsearch">
            <TABLE cellSpacing=3 cellPadding=3>
                <TBODY>
                <TR>
                    <TD align=middle>公告名称:</TD>
                    <TD align=left><INPUT class=searchl name=searchTitle></TD>
                    <TD align=middle>发布人:</TD>
                    <TD align=left><INPUT class=searchs name=searchPublisher></TD>
                    <TD align=middle>发布时间:</TD>
                    <TD align=left><input type="text" id="date-input" class="searchm " name="searchm"/></TD>
                    <TD align=middle>状态:</TD>
                    <td width="10%" align="left">
                        <select name="searchState">
                            <option value="">-选择-</option>
                            <option value="0">未解决</option>
                            <option value="1">己解决</option>
                        </select>
                    </td>
                    <TD align=middle><INPUT class=searchbtn onclick="errorSearch()" type=button value=查询 name=search></TD>
                </TR>
                </TBODY>
            </TABLE>

        </div>
        <div> </div>
        <TABLE width="100%">
            <TBODY>
            <TR>
                <TD><div id="tblist">
                    <TABLE width="100%"
                           border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff">
                        <TBODY>
                        <TR class="th">
                            <th width="7%">选择</th>
                            <th height=28><A
                                    onClick="orderBy('errorTitle')">错误标题</A></th>
                            <th width="10%"><A
                                    onClick="orderBy('errorContent')">错误内容</A></th>
                            <th width="13%"><A
                                    onClick="orderBy('publisher')">提交人</A></th>
                            <th width="13%"><A
                                    onClick="orderBy('submitTime')">提交时间</A></th>
                            <th width="13%"><A
                                    onClick="orderBy('errorState')">错误状态</A></th>
                            <th class=STYLE5 align=middle width="5%">查看</th>
                        </TR>
                        <g:each in="${errorsList}" status="i" var="errors">
                            <tr bgcolor="${(i % 2) == 0 ? '#ffffff' : '#e9e8e7'}">
                                <td>&nbsp;&nbsp;<g:checkBox name="idList" value="${fieldValue(bean: errors, field: 'id')}"
                                                            checked="" onclick="unCheckAll('selall');"/></td>
                                <td height="23" nowrap="nowrap" class="STYLE5"><a href="#rh"
                                                                                  onClick="show('${errors.id}')">${CTools.cutString(fieldValue(bean: errors, field: 'errorTitle'), 13)}</a>
                                </td>
                                <td align="center" nowrap="nowrap"
                                    class="STYLE5">${CTools.cutString(fieldValue(bean: errors, field: 'errorContent'), 18)}</td>
                                <td align="center"
                                    class="STYLE5">${fieldValue(bean: errors, field: 'publisher.nickname')}</td>
                                <td align="center" class="STYLE5"><g:formatDate format="yyyy-MM-dd"
                                                                                date="${errors.submitTime}"/></td>
                                <td align="center" class="STYLE5">${errors.errorState == 0 ? '未解决' : '已解决'}</td>
                                <td align="center" class="STYLE5">
                                    <a href="#fg" onClick="show('${errors.id}')"><img src="${resource(dir: 'skin/default/pc/images', file: 'ico_edit.gif')}" alt=""
                                                                                      width="14" height="14" border="0"></a>
                                </td>
                            </tr>
                        </g:each>

                        </TBODY>
                    </TABLE>
                </div>
                    <div id="progdeal">
                        <input id="selall2" onclick="checkAll(this, 'idList')"
                               type="checkbox" name="selall2" />
                        全选
                        <input class="subbtn" onclick="deleteErrors()" type="button" value="删除信息" />
                        <input class="subbtn" onclick="errorSet(1)" type="button" value="已解决" />
                        <input class="subbtn" onclick="errorSet(0)" type="button" value="未解决" />
                    </div></TD>
            </TR>
            </TBODY>
        </TABLE>
        <div class="page">
            <table cellspacing="1" cellpadding="1" width="100%" border="0">
                <tbody>
                <tr>
                    <td width="230" >总共：6 条记录 | 每页10条 | 每页显示:</td>
                    <td width="152" align="right"><div align="left"><img
                            src="${resource(dir: 'skin/default/pc/images', file: '10.gif')}" alt="每页显示10条" name="Img10" border="0" id="Img10"
                            onclick="onPageNumPer(10)" />&nbsp; <img id="Img50"
                                                                     onclick="onPageNumPer(50)" alt="每页显示50条"
                                                                     src="${resource(dir: 'skin/default/pc/images', file: '50.gif')}" border="0" />&nbsp; <img id="Img100"
                                                                                                                                       onclick="onPageNumPer(100)" alt="每页显示100条"
                                                                                                                                       src="${resource(dir: 'skin/default/pc/images', file: '100.gif')}" border="0" />&nbsp; <img id="Img200"
                                                                                                                                                                                                          onclick="onPageNumPer(200)" alt="每页显示200条"
                                                                                                                                                                                                          src="${resource(dir: 'skin/default/pc/images', file: '200.gif')}" border="0" /></div></td>
                    <td align="right"><div align="right">
                        <g:paginate total="${total}" offset="${params.offset}" action="list"  params="${[offset:params.offset,sort:params.sort,order:params.order,max:params.max,searchTitle:params.searchTitle,searchContent:params.searchContent,searchPublisher:params.searchPublisher,searchDate:params.searchDate]}"  />
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </FORM>
    <SCRIPT language=JavaScript>
        changePageImg(10);
        $(function(){
            $("#date-input").datepicker();
        })
    </SCRIPT>
    <script type="text/javascript">
        function deleteErrors() {
            var sumT = confirm('确定删除?');
            if (!sumT) {
                return false;
            }

            if (hasChecked("idList") == false) {
                alert("请至少选择一条错误！");
                return false;
            }
            setParams();
            errorForm.action = "deleteErrors";
            errorForm.submit();
        }

        function showInfo(id, title) {

            var content = eval("errorForm.bz" + id + ".value");
            img1.style.visibility = 'visible';

            errorForm.updateId.value = id;
            errorForm.updateTitle.value = title;
            errorForm.updateContent.value = content;

        }

        function errorsDelete() {
            setParams();
            errorForm.action = "delete";
            errorForm.submit();
        }
        function showinfo() {
            alert("无权操作");
        }
        function errorSet(opt) {
            if (hasChecked("idList") == false) {
                alert("请至少选择一条错误！");
                return false;
            }
            setParams();
            errorForm.action = "errorMark?markTag=" + opt;
            errorForm.submit();
        }
        function setParams() {
            errorForm.searchTitle.value = "${params.searchTitle}";
            errorForm.searchPublisher.value = "${params.searchPublisher}";
            errorForm.searchm.value = "${params.searchm}";
            errorForm.searchState.value = "${params.searchState}";
        }

        function maxShow(max) {
            //调用setParams()对查询参数进行负值
            setParams();
            errorForm.max.value = max;
            errorForm.offset.value = 0;
            errorForm.action = "list";
            errorForm.submit();
        }

        function orderBy(sort) {
            //调用setParams()对查询参数进行负值
            setParams();
            errorForm.sort.value = sort;
            if (errorForm.order.value == "desc") {
                errorForm.order.value = "asc";
            }
            else {
                errorForm.order.value = "desc";
            }
            errorForm.action = "list";
            errorForm.submit();
        }
        function errorSearch() {
            errorForm.action = "errorList";
            errorForm.submit();
        }
        function show(errorId) {
            setParams();
            errorForm.action = "showError?id=" + errorId + "";
            errorForm.submit();
        }
    </script>
</DIV>
</body>
</html>