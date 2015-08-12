<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 13-12-11
  Time: 下午5:24
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="nts.program.domain.ProgramTopic" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>专题管理</title>
    <script type="text/javascript" src="${resource(dir: 'js',file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js',file:'boful/common/allselect.js')}"></script>
</head>
<body>
<div id="main"><!-- InstanceBeginEditable name="main" -->
    <DIV class="programMgrMain" >
        <FORM id="newsForm" name="newsForm" method="post">
            <input type="hidden" name="max" value="${params.max}">
            <input type="hidden" name="offset" value="${params.offset}">
            <input type="hidden" name="newState" value="1">
            <DIV class="x_daohang" > <span class="dangqian">当前位置：</span><A
                    href="#">应用管理</A>&gt;&gt; 专题管理</DIV>
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
                            <th height=28><a href="${createLink(controller: 'programTopic', action: 'list', params: [sort:'name', max: 10, order: 'asc'])}">专题名称</a><A
                                    onclick="orderBy('title');return false;"
                                    href="http://42.62.52.40/nts/news/list#"></A></th>
                            <th width="10%"><a
                                    onclick="orderBy('publisher');return false;"
                                    href="http://42.62.52.40/nts/news/list#">创建者</a></th>
                            <th width="7%"><A
                                    onclick="orderBy('publisher');return false;"
                                    href="http://42.62.52.40/nts/news/list#"></A><a href="${createLink(controller: 'programTopic', action: 'list', params: [sort:'state', max: 10, order: 'asc'])}">状态</a></th>
                            <th width="18%"><a href="${createLink(controller: 'programTopic', action: 'list', params: [sort:'dateCreated', max: 10, order: 'asc'])}">发布日期</a><a
                                    onclick="orderBy('submitTime');return false;"
                                    href="http://42.62.52.40/nts/news/list#"></a></th>
                            <th width="18%"><a href="${createLink(controller: 'programTopic', action: 'list', params: [sort:'dateClosed', max: 10, order: 'asc'])}">关闭日期</a><A
                                    onclick="orderBy('submitTime');return false;"
                                    href="http://42.62.52.40/nts/news/list#"></A></th>
                            <th width="7%">修改</th>
                        </TR>
                        <g:each in="${programTopicList}" status="i" var="programTopic">
                            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                                <td align="center"><input type="checkbox" name="idList" value="${programTopic.id}" onclick="unCheckAll('selall');" id="idList"/></td>
                                <td><g:link action="show" id="${programTopic.id}">${fieldValue(bean: programTopic, field: "name")}</g:link></td>
                                <td align="center">${fieldValue(bean: programTopic?.consumer, field: "nickname")}</td>
                                <td align="center">${ProgramTopic.cnState[programTopic.state]}</td>
                                <td align="center"><g:formatDate date="${programTopic.dateCreated}" /></td>
                                <td align="center"><g:formatDate date="${programTopic.dateClosed}" /></td>
                                <td align="center"><a href="editProgramTopic?id=${programTopic.id}"><img src="${resource(dir: 'skin/default/pc/images', file: 'ico_edit.gif')}" alt="" width="14" height="14" border="0" ></a></td>
                            </tr>
                        </g:each>
                        </TBODY>
                    </TABLE>
                </div>
                    <div id="progdeal">
                        <input id="selall2" onclick="checkAll(this, 'idList')"
                               type="checkbox" name="selall2" />
                        全选 <span style="height:30px;padding-top:10px;">
                        <input class="subbtn" type="button" value="添加专题"  onclick="self.location.href='createProgramTopic';" />
                        <input class="subbtn" type="button" value="删除所选"  onclick="del();" />
                        <input class="subbtn" type="button" value="发布所选"  onclick="setState(1);" />
                        <input class="subbtn" type="button" value="关闭所选"  onclick="setState(2);" />
                    </span></div></TD>
            </TR>
            </TBODY>
        </TABLE>
        <div class="page">
            <table cellspacing="1" cellpadding="1" width="100%" border="0">
                <tbody>
                <tr>
                    <td width="230" >总共：6 条记录 | 每页10条 | 每页显示:</td>
                    <td width="152" align="right"><div align="left"><img
                            src="${resource(dir: 'skin/default/pc/images', file: '10.gif')}" alt="每页显示10条" name="Img10" border="0" id="Img10"
                            onclick="onPageNumPer(10)" />&nbsp; <img id="Img50"
                                                                     onclick="onPageNumPer(50)" alt="每页显示50条"
                                                                     src="${resource(dir: 'skin/default/pc/images', file: '50.gif')}" border="0" />&nbsp; <img id="Img100"
                                                                                                                                     onclick="onPageNumPer(100)" alt="每页显示100条"
                                                                                                                                     src="${resource(dir: 'skin/default/pc/images', file: '100.gif')}" border="0" />&nbsp; <img id="Img200"
                                                                                                                                                                                                      onclick="onPageNumPer(200)" alt="每页显示200条"
                                                                                                                                                                                                      src="${resource(dir: 'skin/default/pc/images', file: '200.gif')}" border="0" /></div></td>
                    <td align="right"><div align="right"></div></td>
                </tr>
                </tbody>
            </table>
        </div>

        </FORM>
<SCRIPT language=JavaScript>
    changePageImg(10);
</SCRIPT>
<script type="text/javascript">
    function onPageNumPer(max)
    {
        newsForm.max.value=max;
        newsForm.offset.value=0;
        newsForm.action="programTopicList";
        newsForm.submit();
    }
    function del()
    {
        if (hasChecked("idList")==false)
        {
            alert("请至少选择一条记录！");
            return false;
        }
        if(confirm("确实要删除所选专题吗？"))
        {
            newsForm.action = baseUrl + "appMgr/deleteProgramTopic";
            newsForm.submit();
        }
    }

    function setState(newState)
    {
        if (hasChecked("idList")==false)
        {
            alert("请至少选择一条记录！");
            return false;
        }

        newsForm.newState.value = newState;
        newsForm.action = baseUrl + "appMgr/setStateProgramTopic";
        newsForm.submit();
    }
</script>
    </DIV>
</div>

</body>
</html>