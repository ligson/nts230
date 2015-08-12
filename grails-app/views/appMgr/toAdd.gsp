


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>添加学习圈(学习社区)类别</title>
		<script type="text/javascript" src="${resource(dir:'js/boful/common',file:'common.js')}"></script>
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
			function addCategory()
			{
				//清空所有提示
				$('#labname').innerHTML = '' ;

				if($('#name').val().trim().length == 0) {
					$('#labname').innerHTML = '名称不能为空值' ;
					return ;
				}				
				else if(!widthCheck($('#name').val().trim(),50)) {
					$('#labname').innerHTML = '名称不能大于50个字符' ;
					$('#name').select() ;
					return ;
				}

				document.form1.submit() ;
			}
		</script>
    </head>
    <body style="background-color:#ffffff">
        <div class="x_daohang">
            <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'RMSCategory', action: 'list')}">学习圈(学习社区)类别管理</a> >> 添加类别
		</div>
		<div style="clear:both;"></div>
		<g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        <g:hasErrors bean="${RMSCategoryInstance}">
			<div class="errors">
				<g:renderErrors bean="${RMSCategoryInstance}" as="list" />
			</div>
		</g:hasErrors>
		<form name="form1" method="post" action="/appMgr/saveRMSCategory">
			<input type="hidden" name="type" value="${type}">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td width="2%">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr align="left" valign="top" >
						  <td height="14" valign="middle" ></td>
						  <td width="20%" valign="middle"  ><p align="right">类别名称：<span class="STYLE3">*</span></p></td>
						  <td colspan="2" valign="middle" > <input  type="text" maxLength="100" name="name" id="name" size="90" /></td>
						  <td width="3%" valign="middle">&nbsp;</td>
						  <td width="16%" valign="middle">&nbsp;</td>
						  <td width="8%" valign="middle">&nbsp;</td>
						</tr>
						<tr align="left" valign="top">
						  <td valign="middle"></td>
						  <td valign="middle">&nbsp;</td>
						  <td colspan="2" valign="middle"><label id="labname" style="color:red;"></label></td>
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
									<option value="${category?.id},${category?.name}">${category?.name}</option>
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
							  <a href="#dwd" ><input type="button" value="添加" class="subbtn" onClick="addCategory();return false;" /></a>
							  <a href="#sd" ><input type="button" class="subbtn" value="返回" onClick="history.go(-1)" /></a></td>
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
