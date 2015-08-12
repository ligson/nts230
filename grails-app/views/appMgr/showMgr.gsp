<%@ page import="nts.utils.CTools" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
<title>大家好，测试下2</title>
<link href="${resource(dir: 'css', file: 'bbs.css')}" rel="stylesheet" type="text/css">
<SCRIPT language=JavaScript src="${createLinkTo(dir: 'js', file: 'boful/common/Jtrim.js')}"></SCRIPT>

<SCRIPT language=JavaScript>
<!--
function check()
{
	if (Jtrim(form1.content.value).length==0)
	{
		alert("请输入回复内容。");
		form1.content.focus();
		return false;
	}

	if (form1.content.value.length>1000)
	{
		alert("回复内容不能超过1000字。");
		form1.content.focus();
		return false;
	}

	return true;
}
//-->
</SCRIPT>
</head>

<body>
<div class="x_daohang">
	<p>当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a href="${createLink(controller: 'bbsTopic', action: 'topicMgr')}">留言管理</a>>><a href="${createLink(controller: 'bbsTopic', action: 'topicMgr')}">主题管理</a>>>帖子信息</p>
</div>
	
<table width="700" border="0" align="center" cellpadding="0" cellspacing="1">
  <tr>
    <td><img src="${resource(dir: 'images/skin', file: 'huif.gif')}" width="129" height="44"></td>
  </tr>
</table>
<table width="700" border="0" align="center" cellpadding="0" cellspacing="1" class="tb01">
  <tr>
    <td bordercolor="#616D78" class="tb2"><table width="700" border="0" cellpadding="0" cellspacing="0">
      <tr bgcolor="#F5F5F5">
        <td width="22" align="center"><img src="${resource(dir: 'images/skin', file: 'index_68.gif')}" width="10" height="10"></td>
        <td width="80">${fieldValue(bean: bbsTopic, field: "username")}</td>
        <td style="text-align:right;padding-right:50px;"><g:formatDate format="yyyy-MM-dd" date="${bbsTopic.dateLastReply}"/></td>
        </tr>
    </table></td>
  </tr>
  <tr>
    <td class="td14" style="text-align:center"><strong>${fieldValue(bean: bbsTopic, field: "name")}</strong></td>
  </tr>
  <tr>
    <td class="td14" style="padding-left:5px;padding-right:4px;">${CTools.codeToHtml(bbsTopic?.content)}</td>
  </tr>
  <tr>
    <td class="td14" style="padding-left:5px;padding-right:4px;background:#F5F5F5;">发贴人备注信息：${fieldValue(bean: bbsTopic, field: "memo")}</td>
  </tr>

  <tr>
    <td class="td10"><table width="160" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="15" align="center"><img src="${resource(dir: 'images/skin', file: 'index_45.gif')}" width="7" height="7"></td>
        <td width="145">回复列表</td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="1" class="td14">
	<g:each in="${bbsReplyList}" var="b">
      <tr bgcolor="#F5F5F5">
        <td width="3%" align="center"><img src="${resource(dir: 'images/skin', file: 'index_69.gif')}" width="11" height="10"></td>
        <td width="25%">回复人:${b?.username}</td>
		<td width="40%">回复人IP:${b?.fromIp}</td>
        <td width="31%" align="center">回复日期:<g:formatDate format="yyyy-MM-dd" date="${b?.dateCreated}"/></td>
      </tr>
      <tr>
        <td colspan="3" style="padding:4px 4px 4px 4px;border-bottom:1px solid #E4E4E4;">${CTools.codeToHtml(b?.content)}</td>
      </tr>
    </g:each> 
      
    </table></td>
  </tr>

  <tr>
    <td align="center"><img src="${resource(dir: 'images/skin', file: 'sptg_bbs.gif')}" onclick="self.location.href=baseUrl + 'bbsTopic/applyTopic?idList=${bbsTopic?.id}'">&nbsp;&nbsp;
      <img src="${resource(dir: 'images/skin', file: 'sc_bbs.gif')}" onclick="self.location.href=baseUrl + 'bbsTopic/delete?idList=${bbsTopic?.id}'"></td>
  </tr>
  

</table>
</body>
</html>