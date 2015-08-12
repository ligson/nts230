<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>In Place Editor</title>
<g:javascript library="prototype" />
<g:javascript library="scriptaculous" />
<script type="text/javascript">
function init()
{
	var oEditor=new  Ajax.InPlaceEditor("editor",baseUrl + "program/inPlaceEditor?id=1",
		{
			okText:"确认",
			cancelText:"取消",
			savingText:"正在提交...",
			externalControl:"externalControl",
			clickToEditText:"点击即可编辑",
			rows:1,
			cols:20,
			loadTextURL:"",
			submitOnBlur:true
		}
	);
	var oEditor2=new  Ajax.InPlaceEditor("editor2",baseUrl + "program/inPlaceEditor?id=2",
		{
			okText:"确认",
			cancelText:"取消",
			savingText:"正在提交...",
			externalControl:"externalControl",
			clickToEditText:"点击即可编辑",
			rows:1,
			cols:20,
			loadTextURL:"",
			submitOnBlur:true
		}
	);
}
Event.observe(window,'load',init);
</script>
</head>

<body>
<h2>In Palce Editor</h2>
<div id="editor">
Click to Edit
</div>

<div id="editor2">
Click to Edit2
</div>
<a id="externalControl" href="">I am a Href,Click to Edit</a>
</body>
</html>
