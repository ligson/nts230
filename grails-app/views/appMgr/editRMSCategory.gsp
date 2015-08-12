


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>修改学习圈(学习社区)类别</title>
		<script type="text/javascript" src="${createLinkTo(dir: 'editor', file: 'xheditor.js')}"></script>
		<style type="text/css">
			<!--
			.STYLE1 {
				font-size: 12px;
				font-weight: bold;
			}
			.STYLE2 {font-size: 12px}
			.STYLE3 {
				color: #FF0000;
				font-weight: bold;
			}
			.STYLE6 {font-size: 14px}
			.STYLE7 {font-size: 14px; font-weight: bold; }
			-->
		</style>
		<script type="text/javascript">
			function editCategory()
			{
				document.form1.submit() ;
			}
		</script>
    </head>
    <body leftmargin="10" topmargin="5" marginwidth="0" marginheight="0">
        <div class="x_daohang">
            <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'RMSCategory', action: 'list')}">学习圈(学习社区)类别管理</a> >> 修改类别
		</div>
		<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        <g:hasErrors bean="${RMSCategoryInstance}">
			<div class="errors">
				<g:renderErrors bean="${RMSCategoryInstance}" as="list" />
			</div>
		</g:hasErrors>
		<form name="form1" method="post" action="/appMgr/updateRMSCategory">
			<input type="hidden" name="type" value="${RMSCategoryInstance?.type}">
			<input type="hidden" name="id" value="${RMSCategoryInstance?.id}">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td width="2%">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr align="left" valign="top" >
						  <td height="14" valign="middle" ></td>
						  <td width="20%" valign="middle"  ><p align="right">类别名称：<span class="STYLE3">*</span></p></td>
						  <td colspan="2" valign="middle" > <input  type="text" maxLength="100" name="name" id="name" size="90" value="${RMSCategoryInstance?.name}" /></td>
						  <td width="3%" valign="middle">&nbsp;</td>
						  <td width="16%" valign="middle">&nbsp;</td>
						  <td width="8%" valign="middle">&nbsp;</td>
						</tr>
						<tr align="left" valign="top">
						  <td valign="middle"></td>
						  <td valign="middle">&nbsp;</td>
						  <td colspan="2" valign="middle">&nbsp;</td>
						  <td valign="middle">&nbsp;</td>
						  <td valign="middle">&nbsp;</td>
						  <td valign="middle">&nbsp;</td>
						</tr>
						<tr align="left" valign="top" >
						  <td height="14" valign="middle" ></td>
						  <td valign="middle" ><div align="right">上级类别：<span class="STYLE3">*</span></div></td>
						  <td colspan="4" valign="middle" >
							<select name="parent" id="parent">
								<option value="0,无">无</option>
								<g:each in="${categoryList?}" status="i" var="category">
									<option value="${category?.id},${category?.name}" <g:if test="${RMSCategoryInstance.parentid == category?.id}">selected</g:if>>${category?.name}</option>
								</g:each>
							</select>
						  </td>
						  <td valign="middle">&nbsp;</td>
						</tr>
						<tr align="left" valign="top">
						  <td valign="middle"></td>
						  <td valign="middle">&nbsp;</td>
						  <td colspan="2" valign="middle">&nbsp;</td>
						  <td valign="middle">&nbsp;</td>
						  <td valign="middle">&nbsp;</td>
						  <td valign="middle">&nbsp;</td>
						</tr>
						<tr align="left" valign="top">
						  <td valign="middle"></td>
						  <td valign="middle">&nbsp;</td>
						  <td colspan="2" valign="middle">&nbsp;</td>
						  <td valign="middle">&nbsp;</td>
						  <td valign="middle">&nbsp;</td>
						  <td valign="middle">&nbsp;</td>
						</tr>
						<tr align="left" valign="top">
						  <td valign="middle"></td>
						  <td valign="middle">&nbsp;</td>
						  <td width="28%" valign="middle" align="right">
							  <a href="#dwd" ><img src="${resource(dir: 'images/skin', file: 'ok.gif')}"  border="0" onClick="editCategory();return false;" /></a>
							  <a href="#sd" ><img src="${resource(dir: 'images/skin', file: 'back.gif')}"  border="0" onClick="history.go(-1)" /></a></td>
						  <td width="24%" valign="middle">&nbsp;</td>
						  <td valign="middle">&nbsp;</td>
						  <td valign="middle">&nbsp;</td>
						  <td valign="middle">&nbsp;</td>
						</tr>
					</table>
				</td>
			  </tr>
			</table>
		</form>
    </body>
</html>
