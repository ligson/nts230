<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>修改链接</title>

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

<script language="javaScript">


function addNews()
{

	if (createForm.name.value.length < 1)
	{
		alert("请输入链接名称");
		createForm.name.focus();
		return false;
	}
	
	if (createForm.url.value.length < 10)
	{
		alert("请输入链接url");
		createForm.url.focus();
		return false;
	}
	

	createForm.action="updateFriendLink";
	createForm.submit();
}
function backList()
{
	createForm.action="friendLinkList";
	createForm.submit();
}
</script>

</head>

<body leftmargin="10" topmargin="5" marginwidth="0" marginheight="0">
<form  method="post"  name="createForm">
<input type="hidden" name="id" value="${friendLink.id}">
<div class="x_daohang">
    <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'index')}">应用管理</a> >> <a href="${createLink(controller: 'appMgr', action: 'friendLinkList')}">外部资源</a> >> 编辑
</div
<g:if test="${flash.message}">
<div class="message">${flash.message}</div>
 </g:if>
<g:hasErrors bean="${friendLink}">
<div class="errors">
<g:renderErrors bean="${friendLink}"  as="list" />
 </div>
</g:hasErrors>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="2%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">

          <td colspan="10" height="1" >&nbsp;</td>
        </tr>
        <tr align="left" valign="top" >
          
          <td width="11%">链接名称：<span class="STYLE3">*</span></td>
          <td > <input  type="text" maxLength="40" name="name" id="name" size="20" value="${friendLink.name}" /></td>
          <td width="3%">&nbsp;</td>
          <td width="16%">&nbsp;</td>
          <td width="8%">&nbsp;</td>
        </tr>
        <tr align="left" valign="top" >      
          <td>链接url：<span class="STYLE3">*</span></td>
          <td> <input  type="text" maxLength="250" name="url" id="url" size="60" value="${friendLink.url}" />(请以http://开头)</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        
        <tr align="left" valign="top">
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr align="left" valign="top">
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr align="left" valign="top">
         
          <td colspan="5" valign="middle" align="center">
	  <a href="#dwd" ><input class="subbtn" type="button" value="修改" onClick="addNews();return false;" /></a>
	  <a href="#sd" ><input class="subbtn" type="button" value="返回" onClick="backList();return false;" /></a></td>
          
        </tr>
      </table></td>
  </tr>
</table>
</form>
</body>
</html>
