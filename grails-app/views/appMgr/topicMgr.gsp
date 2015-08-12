<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>nts</title>
<link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}"  rel="stylesheet" type="text/css">
<style>


a:link,a:visited {
    font-weight:normal;
}

a:hover {
	color: #FF6600;
	font-weight:normal;
}

#catetab .curLink{color:#f60;}
#progListTab td{line-height:18px;padding-left:2px;}

</style>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/allselect.js')}"></script>

<SCRIPT LANGUAGE="JavaScript">
<!--


function submitSch()
{
	//self.location.href = baseUrl + "my/manageProgram?state="+theForm.state.value+"&max="+theForm.max.value;
	//self.location.href = "";
	document.form1.offset.value = 0;
	document.form1.submit();
}

function onPageNumPer(max)
{
	document.form1.max.value = max;
	submitSch();
}

function del()
{
	if (hasChecked("idList")==false)
	{
		alert("请至少选择一条记录！");
		return false;
	}

	if(confirm("确实要删除所选记录吗？"))
	{
		form1.action = baseUrl + "appMgr/deleteTopicMgr";
		form1.submit();
	}
}

function apply()
{
	if (hasChecked("idList")==false)
	{
		alert("请至少选择一条记录！");
		return false;
	}

	form1.action = baseUrl + "appMgr/applyTopic";
	form1.submit();
}

function init()
{
	//form1.schState.value="0";
	changePageImg(${params.max});
}

//-->
</SCRIPT>
</head>

<body onload="init();" style="overflow-x:hidden">
	<form name="form1" method="post" action="/appMgr/topicMgr">
		<input type="hidden" name="max" value="${params.max}">
		<input type="hidden" name="offset" value="0">
		
		<div class="x_daohang">
            <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'bbsTopic', action: 'topicMgr')}">留言管理</a>>>主题管理
		</div>
	
		<table width="95%" border="0" cellspacing="0" cellpadding="2" class="biaoge-hui" style="margin-top:10px;margin-bottom:10px;">
			<tr>
			<td>主题列表</td>			  
			  <td width="10%"></td>
		  </tr>
		</table>

		<table width="95%" border="1" cellspacing="0" cellpadding="0"  bordercolor="#FFFFFF" id="progListTab">
			<tr>			 
			  <td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5">选择</td>
			  <td align="center" bgcolor="#BDEDFB" class="STYLE5">主题</td>
			  <td width="12%" align="center" bgcolor="#BDEDFB"  class="STYLE5">发帖人</td>
			  <td width="8%" align="center" bgcolor="#BDEDFB"  class="STYLE5"><g:sortableHref property="isLocked" title="状态" params="${params}"/></td>
			  <td width="10%" align="center" bgcolor="#BDEDFB" class="STYLE5">回复数</td>
			  <td width="12%" align="center" bgcolor="#BDEDFB" class="STYLE5">最新回复</td>			  
			</tr>
		<g:each in="${bbsTopicList?}" status="i" var="bbsTopic">
			<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">	
			  <td align="center"><g:checkBox name="idList" value="${fieldValue(bean:bbsTopic, field:'id')}" checked="" onclick="unCheckAll('selall');" /></td>
			  <td><a href="showMgr?id=${bbsTopic.id}">${fieldValue(bean: bbsTopic, field: "name")}</a></td>
			  <td align="center">${fieldValue(bean: bbsTopic, field: "username")}</td>
			  <td align="center">${bbsTopic?.isLocked?"待审核":"已审核"}</td>
			  <td align="center">${fieldValue(bean: bbsTopic, field: "replyNum")}</td>
			  <td align="center"><g:formatDate format="yyyy-MM-dd" date="${bbsTopic.dateLastReply}"/></td>			
			</tr>
		</g:each>		
		</table>

		<table width="95%" >
			<tr>
				<td style="padding:10px 2px 2px 10px;">
					<input  id="selall"  name="selall" onclick="checkAll(this,'idList')" type="checkbox">&nbsp;全选&nbsp;
					<input class="button" type="button" value="审批通过"  onClick="apply()" />&nbsp;
					<input class="button" type="button" value="删除所选"  onClick="del()" />&nbsp;
				</td>
			</tr>
		</table>

		<table width="95%" style="border: 0px;" height="16" border="0" cellpadding="1" cellspacing="1" bgcolor="#E9E8E7">
			  <tr>
				<td width="300" height="16" align="left" >
					&nbsp;总共：${total} 条记录|每页${params.max}条
					<img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0" onclick="onPageNumPer(10)">
					<img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0" onclick="onPageNumPer(50)">
					<img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0" onclick="onPageNumPer(100)">
					<img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0" onclick="onPageNumPer(200)">
				</td>
				<td align="right" ><div class="paginateButtons"><g:paginate controller="appMgr" action="topicMgr" total="${total}" params="${params}" /></div></td>
			  </tr>
		</table>
	</form>

</body>
</html>

