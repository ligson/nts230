<%@ page import="nts.utils.CTools" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>问题反馈</title>
<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/dateSelectBox.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/common.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/allselect.js')}"></script>
<style>


a:link,a:visited {
    font-weight:normal;
}

a:hover {
	color: #FF6600;
	font-weight:normal;
}

#catetab .curLink{color:#f60;}
#progListTab td{line-height:18px;}
.STYLE9 {color: #990000; font-weight: bold; font-size: 12px; }
</style>


<SCRIPT LANGUAGE="JavaScript">
<!--

function submitSch()
{
	document.form1.action = "questionList"
	document.form1.submit();
}

function onPageNumPer(max)
{
	setParams();
	document.form1.max.value = max;
	document.form1.offset.value = 0;

	submitSch();
}


function init()
{
	changePageImg(${CTools.nullToOne(params.max)});
}

function questionSearch()
{
	form1.action="questionList";
	form1.submit();
}

function setParams()
{
	 form1.searchName.value = "${params.searchName }";
	 form1.searchType.value = "${params.searchType}";
	 form1.searchDate.value = "${params.searchDate}"; 
}

function deleteLog()
{
	if (hasChecked("idList")==false)
	{
		alert("请至少选择一条问题！");
		return false;
	}

	setParams();
	form1.action = "deleteQuestion";
	form1.submit();
}
function editQuestion(questionId)
{
	setParams();
	form1.action="editQuestion?questionId="+questionId+"";
	form1.submit();
}
$(function(){
    $("#searchDate").datepicker();
})
//-->
</SCRIPT>
</head>

<body leftmargin="18" onload="init();">
	<form name="form1" method="post" >
		<input type="hidden" name="max" value="${params.max}">
		<input type="hidden" name="offset" value="${params.offset}">
		<input type="hidden" name="sort" value="${params.sort}">
		<input type="hidden" name="order" value="${params.order}">
<div class="x_daohang">
    <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>> 问题反馈
</div>
<table width="95%" style="margin:10px 0 10px 0; " border="0" cellpadding="0" cellspacing="0" bordercolor="#E9E8E7">
  <tr>
    <td width="5%" align="center" >标题内容:</td>
    <td width="10%" align="left" ><input type="text" class="newsinput1" name="searchName" value="" /></td>
    <td width="5%" align="center" >问题类型:</td>
    <td width="10%" align="left" >
    <select  name="searchType" >
    <option value="" >--问题类型--</option>
	<option value="1" >已回答</option>
	<option value="0" >未回答</option>
 </select>
    </td>
    <td width="5%" align="center" >提问时间:</td>
    <td width="10%" align="left" >
    <input name="searchDate" id="searchDate" readonly=""  type="text" class="newsinput1"  value="">
    </td>
    <td width="5%" align="center" ><input name="search" type="button" class="button" onClick="questionSearch()"  value="查询" /></td>
  </tr>
</table>
        <div id="tblist">
		<table width="100%"
               border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff" id="progListTab">
			<tr class="th">
				 <td width="30"  align="center">选择</td>
				<g:sortableColumn align="center" property="name" title="问题" params="${params}"/>
				<g:sortableColumn align="center" property="consumer" title="提问人" params="${params}"/>
				<g:sortableColumn align="center" property="questionState" title="问题状态" params="${params}"/>
				<g:sortableColumn align="center" property="dateCreated" title="提问时间" params="${params}"/>
				<td width="35"  align="center">查看</td>
			</tr>
		<g:each in="${questionList}" status="i" var="question">
			<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
			  <td align="center"><g:checkBox name="idList" value="${question.id}" checked="" onclick="unCheckAll('selall');" /></td>
			  <td align="left">&nbsp;${CTools.cutString(question.name,20).encodeAsHTML()} </td>
			  <td align="center">${question.consumer}</td>
			  <td align="center">${question.questionState  ? '已回答':'未回答' }</td>
			  <td align="center"><g:formatDate format="yyyy-MM-dd" date="${question.dateCreated}"/></td>
			  <td align="center">
			  <a href="#vv"  onClick="editQuestion(${question.id})">
				 <img src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="" width="14" height="14" border="0" >
			  </a>
			  </td>
			</tr>
		</g:each>
		</table>

		    <table width="100%" >
		    <tr>
			<td>
				 <input  id="selall"  name="selall" onclick="checkAll(this,'idList')" type="checkbox">&nbsp;全选&nbsp;
				 <input class="button"  type="button" value="删除所选"  onClick="deleteLog()" />&nbsp;
			</td>
		    </tr>
		    
		     </table>

		<table width="100%" style="border: 0px;" height="16" border="0" cellpadding="1" cellspacing="1" bgcolor="#E9E8E7">
			  <tr>
				<td width="600" height="16">
					&nbsp;总共：${total} 条记录&nbsp;|&nbsp;每页${params.max}条&nbsp;|&nbsp;每页显示:
					<img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0" onclick="onPageNumPer(10)">
					<img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0" onclick="onPageNumPer(50)">
					<img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0" onclick="onPageNumPer(100)">
					<img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0" onclick="onPageNumPer(200)">
				</td>
				<td width="11">&nbsp;</td>
				<td width="450" align="right" ><div class="paginateButtons"><g:paginate total="${total}" params="${params}" /></div></td>
			  </tr>
		</table>
            </div>
	</form>
</body>
</html>

