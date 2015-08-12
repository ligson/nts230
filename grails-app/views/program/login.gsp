

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>用户登录</title> 
		<script language ="javascript" src ="${createLinkTo(dir:'js',file:'boful/common/truevod.js')}"></script>
<style type="text/css">
<!--
body,td,th {
	font-size: 12px;
	color: #1D5CA3;
	line-height: 2.5;
}
body {
	margin-top: 138px;
}
.input{
BORDER: #A8C0D5 1px solid;
size:23;
height:20;

}
a:link {
	color: #3A89C8;
	text-decoration: none;
}
a:visited {
	text-decoration: none;
	color: #999999;
}
a:hover {
	text-decoration: underline;
	color: #5283B9;
}
a:active {
	text-decoration: none;
}
-->
</style>
<script Language="JavaScript">
<!--
<!--
if (self==top)
{
	var winobj=self.opener;
	if(winobj)
	{
		winobj.top.location.href="login.gsp";
		window.close();
	}
	
}
else
	self.top.location.href="login.gsp";

function UsrLoginFrm_Validator(theForm)
{

 if (theForm.name.value == "")
  {
    alert("请在帐号输入框中输入值。");
    theForm.name.focus();
    return (false);
  }
   if (theForm.password.value == "")
  {
    alert("请在密码框中输入值。");
    theForm.password.focus();
    return (false);
  }

  if (theForm.name.value.length < 1)
  {
    alert("在帐号输入框中，请至少输入 1 个字符。");
    theForm.name.focus();
    return (false);
  }

  if (theForm.name.value.length > 60)
  {
    alert("在帐号输入框中，请最多输入 60 个字符。");
    theForm.name.focus();
    return (false);
  }
  
   if (theForm.password.value.length >30)
  {
    alert("在密码输入框中，请最多输入 30 个字符。");
    theForm.password.focus();
    return (false);
  }

  var	vUser=theForm.name.value;
  var	vPwd =theForm.password.value;
  return true;
  //return UPLoginDirect(vUser,vPwd);
}
//
function UsrLoginEvnt(theForm)
{
	if (typeof(theForm)!="string") 
		return false;
	var	frmObj=document.forms(theForm);
	if (frmObj==null) 
		return false;
	if (UsrLoginFrm_Validator(frmObj)==false)
		return false;
	var	vUser=frmObj.name.value;
	var	vPwd =frmObj.password.value;
	
	frmObj.submit();
	return true;
}
function init()
{
	UsrLoginFrm.name.focus();
}
function login()
{
	if(UsrLoginFrm_Validator(UsrLoginFrm)==true)
	{
		UsrLoginFrm.action="login";
		UsrLoginFrm.submit();
	}
}
function cancel()
{
  UsrLoginFrm.reset();
  UsrLoginFrm.name.focus();
}
function password_keyPress()
{
 if(event.keyCode==13)
 {   
  login();
 }
}
//--></script>

    </head>
    <body topmargin="110" onLoad="init();" background="${createLinkTo(dir:'images',file:'bg.gif')}">
 <g:form name="UsrLoginFrm" action="login" method="post" onSubmit="return UsrLoginFrm_Validator(this);">
  <table width="614" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="3"><img src="${createLinkTo(dir:'images',file:'titleclient.gif')}" width="614" height="96"></td>
  </tr>
  <tr>
    <td width="179" height="129" background="${createLinkTo(dir:'images',file:'left.gif')}"></td>
    <td width="276" background="${createLinkTo(dir:'images',file:'bai.gif')}"><table width="87%" border="0" align="center" cellpadding="0" cellspacing="0">
      <g:if test="${message}">
       <tr><td style="color:#FF6600" colspan="2" align="center">${message}</td></tr>
      </g:if>
	  <tr>
        <td width="28%" align="right"><strong>用户名：</strong></td>
        <td width="72%"><input name="name" type="text" maxlength="60" class="input"></td>
      </tr>
      <tr>
        <td align="right"><strong>密&nbsp; 码：</strong></td>
        <td><input type="password" name="password" size="21"  maxlength="60" class="input"  onKeyPress="password_keyPress()"></td>
      </tr>
      <tr>
        <td colspan="2" align="center" valign="middle"><table width="87%" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td align="center" height="35"><a href="#"><img src="${createLinkTo(dir:'images',file:'enter.gif')}" border="0" onClick="login()" value="提交"></a></td>
            <td align="center"><a href="#"><img src="${createLinkTo(dir:'images',file:'can.gif')}" border="0" onClick="cancel()" value="取消"></a></td>
          </tr>
        </table></td>
      </tr>
    </table></td>
    <td width="159" height="129" background="${createLinkTo(dir:'images',file:'right.gif')}"></td>
  </tr>
  <tr>
    <td width="614" height="66" colspan="3" background="${createLinkTo(dir:'images',file:'bootte.gif')}"><table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td align="center">北京邦丰网络通信技术有限公司 <a href="http://www.boful.com" target="_blank">http://www.boful.com</a></td>
        </tr>
    </table></td>
  </tr>
</table>
</g:form>
<OBJECT ID="upload" 
    CLASSID="CLSID:FDE4893B-A43E-4ec4-9119-1C214BF69E51" 
     height="0" width="0"> 
      <param name="SaveType" value="1">
</object>
</body>
</html>
