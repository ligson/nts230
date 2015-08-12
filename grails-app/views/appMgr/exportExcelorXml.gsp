<html>
<head>
<title>Edit Program</title>
<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/dateSelectBox.js')}"></script>
<SCRIPT LANGUAGE="JavaScript">

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
	if(form1.beginDate.value != '' && form1.endDate.value != '' && form1.beginDate.value > form1.endDate.value)
	{
		alert("开始日期不能大于结束日期！");
		//form1.beginDate.selected;
		return false;
	}
	if (form1.rootPath.value=="")
	{
		alert("请在保存路径输入框中输入值。");
		form1.rootPath.focus();
		return (false);
	}

	hiddenMsg();
	showLoading();
	return true;
}
   $(function(){
       $("#beginDate").datepicker();
       $("#endDate").datepicker();
   })
</SCRIPT>

</head>
    <body>
	<div class="x_daohang">
        <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'list')}">应用管理</a>>> 资源导出
	</div>
    <div class="derive1">
	   <h1>导出资源为excel或者xml</h1>
		<form name="form1" action="export" method="post" onsubmit="return check();" >

			<table width="720">                        
				<tr >
					<td colspan="2" style="padding-left:0px;">
						
					</td>
				</tr> 
			
				
				<tr>
					<td style="width:70px;">选择类库：</td>
					<td >
						 <g:select from="${directoryList}" name="directoryId" value="${directoryId}" optionKey="id" optionValue="name" ></g:select>
					</td>
				</tr>
				<tr>
					<td style="width:90px;">记录生成日期：</td>
					<td >
						 <input name="beginDate" id="beginDate" readonly=""  type="text" class="1"  value="${beginDate}"> 至 <input name="endDate" id="endDate" readonly=""  type="text" class="1"  value="${endDate}">
					</td>
				</tr>
				<tr>
					<td style="width:70px;">导出字段：</td>
					<td >
						<input type="radio"  name="exportType" value="0" checked="checked" ${exportType==0?'checked':''}>导出所有字段&nbsp;
						<input type="radio"  name="exportType" value="1" ${exportType==1?'checked':''} >导出元数据定义中要导出的字段 
					</td>
				</tr>
				<tr>
					<td style="width:70px;">导出简介：</td>
					<td >
						<input type="checkBox"  name="isDescription" value="0"  ${isDescription=='0'?'checked':''} >
					</td>
				</tr>
				<tr>
					<td style="width:70px;height: 30;margin: 5px">导出格式：</td>
					<td >
						 <input type="radio"  name="exportFormat" value="0" checked="checked" ${exportFormat==0?'checked':''} >xml文件&nbsp;
						<input type="radio"  name="exportFormat" value="1" ${exportFormat==1?'checked':''} >excel文件&nbsp;
						<input type="radio"  name="exportFormat" value="2" ${exportFormat==2?'checked':''} >OAI-PMH格式  
					</td>
				</tr>
				<tr>
					<td style="width:70px;height: 30;margin: 5px">保存路径：</td>
					<td >
						 <g:textField name="rootPath" value="" style="width:200px;" value="${rootPath}"/>(路径请以"/"结尾) 
					</td>
				</tr>

			</table>
			<div class="buttons3">
				<span class="button"><input class="subbtn" type="submit" value="开始导出" /></span>
				<span class="button"><input class="subbtn" type="button" onclick="form1.reset();" value="重设" /></span>
            </div>
		</form>
		<div style="display:none;position: absolute; top: 150px; left: 200px; font-size:12px;" id="loadingDiv"><img src="${resource(dir: 'images/skin', file: 'loading.gif')}">正在导出，请稍候......</div>
		<g:if test="${flash.message}"> 
			<div class="message" id="msgDiv" style="position: absolute; top: 220px; left: 200px; font-size:12px;" >${flash.message}</div>
		</g:if>
	</div>		
    </body>
</html>
