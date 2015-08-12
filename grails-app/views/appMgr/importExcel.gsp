<%@ page import="nts.program.domain.Serial" %>
<html>
<head>
<title>Edit Program</title>
<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/Jtrim.js')}"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
function showLoading()
{
	var divObj=document.getElementById("loadingDiv");
	divObj.style.display="block";
}

function hiddenMsg()
{
	var divObj=document.getElementById("msgDiv");
	if(divObj) divObj.style.display="none";
}

function check()
{
	if (form1.directoryId.value == 0)
	{
		alert("请选择类库。");
		form1.directoryId.focus();
		return (false);
	}

	var extName = getExtName(Jtrim(form1.file1.value)).toLowerCase();
	if (extName != "xls" && extName != "xlsx")
	{
		alert("请选择Excel文件。");
		form1.file1.focus();
		return (false);
	}

	if(!confirm("确定excel文件，类库都选择正确吗?"))
	{
		return false;
	}

	hiddenMsg();
	showLoading();
	return true;
}

function getExtName(fileName)
{
	var extName = "";
	if (fileName == null || fileName == "") return "";
	var nPos = fileName.lastIndexOf(".");
	if(nPos > 0)
	{
		extName = fileName.substr(nPos+1);
	}

	return extName;
}
//-->
</SCRIPT>

</head>
    <body>
	<div class="x_daohang">
        <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>> 资源导入
	</div>
    <div class="tbsearch">
	   <h1>从Excel文件中导入资源</h1>
		<form name="form1" action="excelToDatabase" method="post" onsubmit="return check();" enctype="multipart/form-data">

			<table width="720">                        
				<tr style="height: 15px">
					<td colspan="2" style="padding-left:0px;">
						
					</td>
				</tr> 
			
				
				<tr style="height: 30px; margin: 5px 0" >
					<td style="width:70px;">Excel文件：</td>
					<td >
						 <input style="width:620px;" type="file" name="file1" value="">
					</td>
				</tr>

				<tr style="height: 30px; margin: 5px 0">
					<td style="width:90px;">导入到库：</td>
					<td >
						 <g:select from="${directoryList}" name="directoryId" value="${program?.directory?.id}" optionKey="id" optionValue="name" ></g:select>
						 资源类型:<g:select from="${Serial.urlTypeName}"  name="urlType" value="" optionKey="key" optionValue="value"></g:select>
					</td>
				</tr>

			</table>
			<div class="buttons" style="margin-top: 30px">
				<span class="button"><input class="subbtn" type="submit" value="开始导入" /></span>
				<span class="button"><input class="subbtn" type="button" onclick="form1.reset();" value="重设" /></span>
            </div>
		</form>
		<div style="display:none;position: absolute; top: 150px; left: 200px; font-size:12px;" id="loadingDiv"><img src="${resource(dir: 'images/skin', file: 'loading.gif')}">正在导入，请稍候......</div>
		<g:if test="${flash.message}"> 
			<div class="message" id="msgDiv" style="position: absolute; top: 220px; left: 200px; font-size:12px;" >${flash.message}</div>
		</g:if>
	</div>		
    </body>
</html>
