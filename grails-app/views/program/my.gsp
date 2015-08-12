<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />		
        <title>nts.program.domain.Program List</title>
<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/appMgr/updateNode.js')}"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
var selectedLink = null;//当前选中的节点
function toViewAction (linkObj,action,type)
{
	if(!selectedLink) selectedLink = document.getElementById("defaultLink");
	if(selectedLink)selectedLink.className = "";
	linkObj.className = "curLink";
	selectedLink = linkObj;
	new Ajax.Updater({success:'mainBody',failure:'error'},action,{asynchronous:true,evalScripts:true,parameters:'type='+type});
}
//-->
</SCRIPT>
    </head>
    <body>
	  <table border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
		 <td class="myLeftTD">
			<div class="myLeft" id="myLeft">
				<ul>
				<li><a href="#" onclick="toViewAction(this,'myInfo',-1);return false;" id="defaultLink" class="curLink">我的信息</a></li>
				<li><a href="#" onclick="toViewAction(this,'myProgram',3);return false;">我制作的</a></li>
				<li><a href="#" onclick="toViewAction(this,'myProgram',0);return false;">我收藏的</a></li>
				<li><a href="#" onclick="toViewAction(this,'myProgram',1);return false;">我点播过的</a></li>
				<li><a href="#" onclick="toViewAction(this,'myProgram',2);return false;">我浏览过的</a></li>
				</ul>
			</div>
		 </td>
		 <td class="myRightTD">			
			<div id="mainBody" class="body">
				<g:if test="${flash.message}">
				<div class="message">${flash.message}</div>
				</g:if>
				<g:render template="myInfo" model="[consumer:consumer]"/>
			</div>
		  </td>
		 </tr>
      </table>      
    </body>
</html>
