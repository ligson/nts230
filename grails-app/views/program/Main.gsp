
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>教学资源库</title>
<SCRIPT LANGUAGE="JavaScript">
<!--
function MyLoadPage()
	{		
		mainFrame.location.href="${createLink(controller: 'my',action: 'myIndex')}";
	}	
//-->
</SCRIPT>
</head>


<frameset rows="148,*,15" frameborder="no" border="0" framespacing="0" onLoad="MyLoadPage();">
   <frame src="${createLink(controller: 'shared',action: 'ntsHead')}" name="topFrame" scrolling="No" noresize="noresize" id="topFrame" title="topFrame" />
<frame name="mainFrame" id="mainFrame" title="mainFrame" />
 <frame src="${createLink(controller: 'shared',action: 'ntsBottom')}" name="bottomFrame" scrolling="No" noresize="noresize" id="bottomFrame" title="bottomFrame" />
</frameset>
<noframes><body>
</body>
</noframes>