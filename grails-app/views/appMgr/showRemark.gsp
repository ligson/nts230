<html>
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>评论详细信息</title>
	<script language="JavaScript">
		function isPassRemark(sIsPass)
		{
			form1.action=baseUrl + "appMgr/isPassRemark?sIsPass=" + sIsPass;
			form1.submit();
		}
	</script>
  </head>
  <body>
	<div class="x_daohang">
        <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'remark', action: 'list')}">评论管理</a>>> 评论
	</div>
	<g:if test="${flash.message}">
	  <div class="message">${flash.message}</div>
	</g:if>
	<br>
	<div id="tblist">
	   <table width="100%"
              border=0 cellPadding=0 cellSpacing=1 bgcolor="#ffffff">
			<tbody>
				<tr bgcolor="#FFFFFF">
					<td width="94" height="29" valign="top" >评论标题:</td>
					<td width="381" valign="top" >${fieldValue(bean:remark, field:'topic')}</td>
				</tr>
				<tr bgcolor="#FFFFFF">
					<td width="94" height="29" valign="top" >评论节目:</td>
					<td width="381" valign="top" >${fieldValue(bean:remark, field:'program.name')}</td>
				</tr>
				<tr bgcolor="#FFFFFF">
					<td height="29" valign="top" >评论人:</td>
					<td valign="top" >${fieldValue(bean:remark, field:'consumer.nickname')}</td>
				</tr>
				<tr bgcolor="#FFFFFF">
					<td height="29" valign="top" >评论时间:</td>
					<td valign="top" ><g:formatDate format="yyyy-MM-dd" date="${remark.dateCreated}"/></td>
				</tr>
				<tr bgcolor="#FFFFFF">
					<td height="29" valign="top" >状态:</td>
					<td valign="top">${remark?.isPass?"通过":"不通过"}</td>
				</tr>
				<tr bgcolor="#FFFFFF">
					<td height="93" valign="top" >评论内容:</td>
					<td valign="top" >${fieldValue(bean:remark, field:'content')}</td>
				</tr>
			</tbody>
		</table>
	
		<g:form name="form1">
			<input type="hidden" name="id" value="${remark?.id}" />
			<input type="hidden" name="offset" value="${params.offset}" />
			<input type="hidden" name="sort" value="${params.sort}" />
			<input type="hidden" name="order" value="${params.order}" />
			<input type="hidden" name="searchTitle" value="${params.searchTitle}" />
			<input type="hidden" name="searchContent" value="${params.searchContent}" />
			<input type="hidden" name="searchProgram" value="${params.searchProgram}" />
			<input type="hidden" name="searchConsumer"  value="${params.searchConsumer}" />

			<g:actionSubmit class="subbtn" action="deleteRemark1"  onclick="return confirm('确定删除?');" value="删除" />
			<input class="subbtn" type="button" onclick="isPassRemark(1)" value="通过">
			<input class="subbtn" type="button" onclick="isPassRemark(0)" value="不通过">
			<g:actionSubmit class="subbtn" action ="remarkList"  value="返回" />
		</g:form>
	</div>
  </body>
</html>
