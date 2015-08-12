
global=new globalVars();
var bShowPx=false;//是否已显示了排序提示
var gDateId=0;//排序日期元素ID

var SHOW_OPT_SIMPLE = 0;	//globalVars.showOpt=0;//编目项显示" 0 简单 1缺省 2所有
var SHOW_OPT_DEFAULT = 1;
var SHOW_OPT_ALL = 2;

var UPLOAD_TYPE_SUBTITLE = 1000;	//globalVars.uploadType=-1;
var UPLOAD_TYPE_FCK = 2000;
var UPLOAD_TYPE_SERIAL_PHOTO = 3000;

var imgDialog = null;//富文本图片对话框对象
var metaList = new  Array();//当前类


function init()
{	
	UPLoginDirect(global.usename,global.pwd);
	setUpLoadArgs();
	setCurMetaList(global.classId,-1,-1);//显示当前类下所有元数据
	showAllTr();
	//alert(wtab.innerHTML);
}

function globalVars()
{
	this.programId = 0;
	this.classId = 1;
	this.metaList = new  Array();
	this.tdNum = 3;
	this.disciplineId=0;
	this.firstTitleId=0;//名称元素的第一个显示修饰词ID，用作路径
	this.title="";//资源名称的值
	this.titleId=0;//名称元素ID
	this.metaCreatorId=0;//创建者元素ID
	this.videoSevr="";//视频服务器
	this.videoPort="";//视频端口
	this.uploadPath="";//上传路径
	this.transcodingIp="";//转码服务器IP
	this.transcodingPort="";//转码端口
	this.transcodingPort="";//转码端口
	this.transcodingPath="";//转码路径
	this.curUploadPath="";//当前上传路径
	this.tagName="标签";//标签名称
	this.resDescription="描述";//资源描述名称
	this.showOpt=0;//编目项显示" 0 简单 1缺省 2所有
	this.usename="test";//显示所有编目项
	this.pwd="testpwd";//显示所有编目项
	this.uploadType=-1;//字幕上传1000,富文本上传2000,子目上传3000
	//urlType记得与 truevod.js中的同步
	this.urlType={
		"VIDEO":0,
		"COURSE":1,
		"IMAGE":2,
		"POSTER":3,
		"DOCUMENT":4,
		"MIDDLE_CONTROL":5,
		"ONLINE_COURSE":6,
		"TRURAN_COURSE":7,
		"LINK":8,
		"MOBILE":9,
		"TABLET":10,
		"TEXT_LIBRARY":11,
		"EMBED_PC":12
		};
		//显示类型:详细，2摘要，4浏览类别(目录树中有显示),8编目缺省显示，16可导出，32唯一性
		this.showType={
		"DETAIL":1,
		"ABSTRACT":2,
		"TREE":4,
		"DEFAULT":8,
		"EXPORT":16,
		"UNIQUE":32
		};
}

/////////元数据开始
//修饰词变化时
function onDecoChange(theSelObj)//theSelObj是修饰词下拉框//vInd是metaList数组的下标
{
	var vStr,vValue,vField;
	var vId=theSelObj.value;
	var isFirstTitle=false;
	var useMetaobj=getMetaFromId(vId);
	var metaObj=null;	
	var vBlur="";

	if(useMetaobj != null)
	{			
		metaObj=getMetaFromId(useMetaobj.parentId);	
		vField=theSelObj.parentElement.nextSibling.firstChild;
		vValue=vField.value;
		if(vValue == null || vValue == "")
			vValue=useMetaobj.defaultValue;

		/*if(useMetaobj.parentId==global.titleId && isFirstTitle)
		{
			isFirstTitle=(vField.onblur) != null;
			if(isFirstTitle)
			{
				global.firstTitleId=vId;
				//vBlur='onBlur="setUpSubPath();"';
			}
		}*/

		if(useMetaobj.dataType == "enumeration")
		{
			vStr = '<select name="id_'+useMetaobj.selfId+'">\n';
			vStr += '<option value="-1">-请选择-</option>\n';
			for (ij=0;ij<useMetaobj.arrEnum.length;ij++)
			{
				vStr += '<option value="'+useMetaobj.arrEnum[ij].id+'" '+(useMetaobj.defaultValue==useMetaobj.arrEnum[ij].id?'selected':'')+'>'+useMetaobj.arrEnum[ij].name+'</option>\n';
			}
			vStr += '</select>\n';
		}
		else if(useMetaobj.dataType == "textarea")
		{
			vStr = '<TEXTAREA class="text-input datepicker" name="id_'+useMetaobj.selfId+'">'+vValue+'</TEXTAREA>';
		}
		else  if(useMetaobj.dataType == "number")
		{
			vStr = '<input class="text-input datepicker" name="id_'+useMetaobj.selfId+'" type="text" maxlength="18" value="'+vValue+'">';
		}
		else  if(useMetaobj.dataType == "link")
		{
			vStr = '<input class="text-input datepicker" name="id_'+useMetaobj.selfId+'" type="hidden" value="'+useMetaobj.defaultValue+'">';
			vStr += '链接地址<input type="text" style="width:180;" name="lkaddr_'+useMetaobj.selfId+'" onBlur="setLink(this,'+useMetaobj.selfId+')">';
			vStr += '&nbsp;链接显示<input type="text" style="width:130;" name="lkshow_'+useMetaobj.selfId+'" value="" onBlur="setLink(this,'+useMetaobj.selfId+')">';
		}	
		else  if(useMetaobj.dataType == "date")
		{
			if(vField.id && vField.id == "px")
				vStr = '<input id="px" style="width:120px;" name="id_'+useMetaobj.selfId+'" type="text" maxlength="'+Math.floor(useMetaobj.maxLen/2)+'" value="'+useMetaobj.defaultValue+'" onClick="return Calendar(\'px\');">(日期格式:2005-01-01)';
			else
				vStr = '<input style="width:120px;" id="id_'+useMetaobj.selfId+'" name="id_'+useMetaobj.selfId+'" type="text" maxlength="'+Math.floor(useMetaobj.maxLen/2)+'" value="'+useMetaobj.defaultValue+'" onClick="return Calendar(\'id_'+useMetaobj.selfId+'\');"><img src="images/space.gif" width="2">(日期格式:2005-01-01)';
		}
		else
		{
			vStr = '<input class="text-input datepicker" name="id_'+useMetaobj.selfId+'" type="text" maxlength="'+Math.floor(useMetaobj.maxLen/2)+'" value="'+vValue+'" '+vBlur+'>';
		}

		if(metaObj.repeatNum == 0)
			vStr += '&nbsp;&nbsp;<input type="button" class="button" style="width:40px;" value="增加" onclick="addTr('+metaObj.index+')">';
		else
		{
			if(theSelObj == eval("form1.id_"+useMetaobj.parentId+"[0]"))
				vStr += '&nbsp;&nbsp;<input type="button" class="button" style="width:40px;" value="增加" onclick="addTr('+metaObj.index+')">';
			else
				vStr += '&nbsp;&nbsp;<input type="button" class="button" style="width:40px;" value="删除" onclick="delTr(this)">';
		}
		
		theSelObj.parentElement.nextSibling.innerHTML=vStr;

		//修饰词中是否有必选项，如果有，须显示此行且第一列加*号
		//alert(theSelObj.parentNode.parentNode.firstChild.innerHTML);		
		theSelObj.parentNode.parentNode.firstChild.innerHTML = "<label>"+((useMetaobj.isNecessary==1 || useMetaobj.dataType == "enumeration")?"<font color=red>*</font>":"")+metaObj.cnName+':</label>';
	}
}

function setLink(theSelObj,vMID)
{
	var vLinkField=theSelObj.parentElement.childNodes[0];
	var sLkAddr=theSelObj.parentElement.childNodes[2].value;
	var sLkShow=theSelObj.parentElement.childNodes[4].value;

	if(sLkAddr != null && sLkAddr != "" && sLkShow != null && sLkShow != "")
	{
		if(sLkAddr.indexOf("://")<1) sLkAddr="http://"+sLkAddr;
		vLinkField.value='<a href="'+sLkAddr+'" target="_blank">'+sLkShow+'</a>';
	}
	//alert(vLinkField.value);
}

function addTr(vInd)
{
	var iRow;
	if(vInd >= 0)
	{
		iRow=getDecoLastRow(vInd)+1;
	}
	else
	{
		alert("行参数错误！");
	}

	metaList[vInd].repeatNum++;
	showTr(iRow,vInd);
}

//得到修饰词最后一行的索行引
function getDecoLastRow(vInd)
{
	var i,iRow;
	var rowsLen=wtab.rows.length;	
	for (i=0;i<rowsLen ;i++ )
	{
		if(wtab.rows[i].id == ("ind_"+vInd))
			iRow=i;
	}
	return iRow;
}

function delTr(theDelbtn)
{
	var i,iRow;

	var theDelTr=theDelbtn.parentElement.parentElement;
	for (i=0;i<wtab.rows.length ;i++ )
	{
		if(wtab.rows[i] == theDelTr)
		{
			iRow=i;
			break;
		}
	}
	
	
	var vTrID=wtab.rows[iRow].id;//形如：ind_2
	var vInd=vTrID.substring(4,vTrID.length);

	metaList[vInd].repeatNum--;
	wtab.deleteRow(iRow);
}

//获取元素是否显示
function getMetaDisplay(metaObj)
{
	var bDisplay = false;

	if(global.showOpt == SHOW_OPT_SIMPLE)
	{
		if(metaObj.selfId == global.titleId || metaObj.selfId == global.metaCreatorId || metaObj.dataType == "enumeration") bDisplay = true;
	}
	else if(global.showOpt == SHOW_OPT_DEFAULT)
	{
		if(metaObj.isNecessary == 1 || metaObj.dataType == "enumeration" || ((metaObj.showType & global.showType.DEFAULT) == global.showType.DEFAULT)) bDisplay = true;
	}
	else
	{
		bDisplay = true;
	}
	
	//修饰词中是否有必选项或者有枚举类型，如果有，须显示
	if(!bDisplay)
	{
		if(metaObj.dataType == "decorate")
		{
			for (var k=0;k<metaList.length;k++)
			{
				if(metaList[k].parentId == metaObj.selfId )
				{
					if((global.showOpt == SHOW_OPT_SIMPLE && metaList[k].dataType == "enumeration") || (global.showOpt == SHOW_OPT_DEFAULT && (metaList[k].isNecessary == 1 || metaList[k].dataType == "enumeration")))
					{
						bDisplay = true;
						break;
					}
				}
			}
		}
	}

	return bDisplay;
}

// iRow是在第几行显示 vInd是metaList数组的下标 
function showTr(iRow,vInd) 
{
	var vStr,metaObj,vStar,vClassid,firstDecoObj,creatorObj,vBlur;
	vClassid=global.classId;
	metaObj=metaList[vInd];
	wtab.insertRow(iRow);
	wtab.rows[iRow].id="ind_"+vInd;
	var bDisplay = getMetaDisplay(metaObj);

	wtab.rows[iRow].style.display = bDisplay?"block":"none";
	
	var j,k,m,ij;
	for(j=0;j<global.tdNum;j++)
	{
		wtab.rows[iRow].insertCell(j);
		if(j==0)
		{
			wtab.rows[iRow].cells[j].width="140";
			wtab.rows[iRow].cells[j].className="nobor";
			vStr = '<label>';
			vStr += (metaObj.isNecessary==1?"<font color=red>*</font>":"")+metaObj.cnName+':</label>';			
			wtab.rows[iRow].cells[j].innerHTML=vStr;
		}
		else if(j==1)
		{
			wtab.rows[iRow].cells[j].width="160";
			//wtab.rows[iRow].cells[j].align="center";
			vStr="&nbsp;";
			FirstDecoObj=null;
			
			if(metaObj.dataType == "decorate")
			{		
				vStr = '<select name="id_'+metaObj.selfId+'" onchange="onDecoChange(this);">\n';
				for (k=0;k<metaList.length;k++)
				{
					if(metaList[k].parentId == metaObj.selfId )
					{
						vStr += '<option value="'+metaList[k].selfId+'">'+metaList[k].cnName+'</option>\n';

						if(firstDecoObj == null)
						{
							firstDecoObj = metaList[k];//用于设置后面一列是文本框，大文本框或是下拉框
						}
						
						//修饰词中是否有必选项，如果有，须显示此行且第一列加*号
						if(global.showOpt != SHOW_OPT_SIMPLE && metaList[k].isNecessary == 1 )
						{		
							wtab.rows[iRow].style.display = "block";
							if(firstDecoObj.isNecessary == 1 || firstDecoObj.dataType == "enumeration") wtab.rows[iRow].cells[0].innerHTML="<label><font color=red>*</font>"+metaObj.cnName+':</label>';
						}
					}									
				}

				if(firstDecoObj == null)
				{
					wtab.deleteRow(iRow);
					return false;
				}
				wtab.rows[iRow].cells[j].className="nobor";
				vStr += '</select>\n';
		
			}
			wtab.rows[iRow].cells[j].innerHTML=vStr;
		}
		else if(j==2)
		{
			vStr="";
			//如果是修饰词，第四列表单元素的类型是第一个修饰词的类型，否则由第二列元素的类型
			var useMetaobj=metaObj.dataType == "decorate"?firstDecoObj:metaObj;

			if(useMetaobj == null)
				return;	

			//修改时不用缺省值，主要是导入数据时有的没值
			defaultValue = global.programId<1?useMetaobj.defaultValue:"";

				if(useMetaobj.dataType == "enumeration")
				{
					vStr = '<select name="id_'+useMetaobj.selfId+'">\n';
					vStr += '<option value="-1">-请选择-</option>\n';
					for (ij=0;ij<useMetaobj.arrEnum.length;ij++)
					{
						vStr += '<option value="'+useMetaobj.arrEnum[ij].id+'" '+(defaultValue==useMetaobj.arrEnum[ij].id?'selected':'')+'>'+useMetaobj.arrEnum[ij].name+'</option>\n';
					}
					vStr += '</select>\n';

					//如果是枚举类型，须显示此行							
					wtab.rows[iRow].style.display = "block";
					wtab.rows[iRow].cells[0].innerHTML="<label><font color=red>*</font>"+metaObj.cnName+':<label>';
						
				}
				else if(useMetaobj.dataType == "textarea")
				{
					vStr = '<TEXTAREA class="text-input datepicker" name="id_'+useMetaobj.selfId+'" rows="3">'+defaultValue+'</TEXTAREA>';
				}
				else  if(useMetaobj.dataType == "number")
				{
					vStr = '<input class="text-input datepicker" name="id_'+useMetaobj.selfId+'" type="text" maxlength="16" value="'+defaultValue+'">';
				}
				else  if(useMetaobj.dataType == "link")
				{
					vStr = '<input class="text-input datepicker" name="id_'+useMetaobj.selfId+'" type="hidden" value="'+defaultValue+'">';
					vStr += '链接地址<input style="width:180;" name="lkaddr_'+useMetaobj.selfId+'" type="text" onBlur="setLink(this,'+useMetaobj.selfId+')">';
					vStr += '&nbsp;链接显示<input type="text" style="width:130;" name="lkshow_'+useMetaobj.selfId+'" value="" onBlur="setLink(this,'+useMetaobj.selfId+')">';
				}
				else  if(useMetaobj.dataType == "date")
				{
					vStr = '<input class="text-input datepicker" id="'+(bShowPx?useMetaobj.selfId:'px')+'" style="width:120px;" name="id_'+useMetaobj.selfId+'" type="text" maxlength="'+Math.floor(useMetaobj.maxLen/2)+'" value="'+defaultValue+'" onClick="return Calendar(\''+(bShowPx?('id_'+useMetaobj.selfId):'px')+'\');">(日期格式:2005-01-01)';
					if(useMetaobj.parentId == gDateId && bShowPx == false)
						bShowPx = true;
				}
				else
				{
					vBlur="";
					/*if(global.firstTitleId<1 && useMetaobj.parentId==global.titleId) 
					{
						global.firstTitleId=useMetaobj.selfId;
						//vBlur='onBlur="setUpSubPath();"';
					}*/
					vStr = '<input class="text-input datepicker" name="id_'+useMetaobj.selfId+'" type="text" maxlength="'+Math.floor(useMetaobj.maxLen/2)+'" value="'+defaultValue+'" '+vBlur+'>';
				}

				if(metaObj.dataType == "decorate" || useMetaobj.selfId == global.disciplineId || metaObj.dataType == "link" || metaObj.dataType == "enumeration")
				{
					if(metaObj.repeatNum == 0)
						vStr += '&nbsp;&nbsp;<input type="button" class="button" style="width:40px;" value="增加" onclick="addTr('+vInd+')">';
					else
						vStr += '&nbsp;&nbsp;<input type="button" class="button" style="width:40px;" value="删除" onclick="delTr(this)">';
				}

				wtab.rows[iRow].cells[j].className="nobor";
					
				wtab.rows[iRow].cells[j].innerHTML=vStr;
		}
	}
	//alert(wtab.rows[iRow].cells[0].innerHTML);
	return true;
}

//验证输入
function check()
{
	var i,j,repeatNum,theSelObj,theInput,curDecoObj;
	var formName="form1";
	var objTr = null;

	try
	{	
		for (i=0;i<metaList.length;i++)
		{
			objTr = document.getElementById("ind_"+i);
			if(objTr == null)
				continue;

			repeatNum=metaList[i].repeatNum;
		
			for (j=0;j <= repeatNum ;j++ )
			{
				if(metaList[i].dataType == "decorate")
				{
					if(j == 0 && repeatNum == 0)
						theSelObj=eval(formName+".id_"+metaList[i].selfId);
					else
						theSelObj=eval(formName+".id_"+metaList[i].selfId+"["+j+"]");

					if(theSelObj == null)
						continue;
					theInput=theSelObj.parentElement.nextSibling.firstChild;
					curDecoObj=getMetaFromId(theSelObj.value);
				}
				else if(metaList[i].parentId == 0 && metaList[i].dataType != "decorate")
				{
					//alert(metaList[i].cnName);
					if(j == 0 && repeatNum == 0)
						theInput=eval(formName+".id_"+metaList[i].selfId);
					else
						theInput=eval(formName+".id_"+metaList[i].selfId+"["+j+"]");

					curDecoObj=metaList[i];
				}
				else
				{
					continue;
				}

				if(curDecoObj == null || theInput == null)
					continue;


				if(objTr.style.display != "none" && curDecoObj.isNecessary == 1)
				{
					if(Jtrim(theInput.value) == "")
					{
						alert("请在"+curDecoObj.cnName+"中输入值。");
						theInput.value=Jtrim(theInput.value);
						if(theInput.type != "hidden") inputFocus(theInput);
						return false;
					}
				}
				
				//枚举类型必须选择一个值,不管是否必须
				if(curDecoObj.dataType == "enumeration")
				{
					if(theInput.value == -1)
					{
						alert("请选择"+curDecoObj.cnName+"。");
						inputFocus(theInput);
						return false;
					}
				}

				if(curDecoObj.dataType == "number")
				{
					if(isNaN(theInput.value))
					{
						alert("请在"+curDecoObj.cnName+"中输入数字值。");
						inputFocus(theInput);
						return false;
					}
				}

				if(curDecoObj.dataType == "date")
				{
					if(Jtrim(theInput.value).length >0 && !isValidDate(Jtrim(theInput.value)))
					{
						alert("请在"+curDecoObj.cnName+"中按格式:2005-01-01输入或选择日期。");
						inputFocus(theInput);
						return false;
					}
				}

				if(curDecoObj.dataType == "time")
				{
					if(Jtrim(theInput.value).length >0 && !isValidTime(Jtrim(theInput.value)))
					{
						alert("请在"+curDecoObj.cnName+"中按格式:01:01正确输入时间。");
						inputFocus(theInput);
						return false;
					}
				}

				var isUniqueExist = false;
				if((curDecoObj.showType & global.showType.UNIQUE) == global.showType.UNIQUE)
				{				
					if(Jtrim(theInput.value) != "")
					{
						var checkUrl = baseUrl + 'program/checkMetaUnique?programId='+global.programId+'&metaId='+curDecoObj.selfId+'&value='+encodeURIComponent(Jtrim(theInput.value));
						new Ajax.Request(checkUrl,{
							asynchronous: false,
							onComplete: function(transport){
									//alert(transport.responseText);
									if(transport.responseText != "ok")
									{
										if(transport.responseText == "exist")	
											alert(curDecoObj.cnName+"不允许重复，请重新输入值。");
										else
											alert(curDecoObj.cnName+"检查重复性时出错，请重新提交。");
										
										try
										{
											inputFocus(theInput);
										}
										catch (err)
										{
											//ddd
										}
										
										isUniqueExist = true;

									}
								}
							}
						); 	
						
						if(isUniqueExist) return false;
					}
				}

				if(curDecoObj.dataType == "textarea")
				{
					if((theInput.value).length > Math.floor(curDecoObj.MaxLen/2))
					{
						alert("在"+curDecoObj.cnName+"中最多能输入"+Math.floor(curDecoObj.MaxLen/2)+"个字。");
						inputFocus(theInput);
						return false;
					}
				}

			}
		}
		
		/*if(!isInputTag())
		{
			alert("请至少输入一个"+global.tagName+"。");
			form1.programTag[0].focus();
			return false;
		}

		if(Jtrim(document.form1.description.value) == "" || document.form1.description.value == '有关资源内容的自由文本描述 ，包括文摘、目次')
		{
			alert("请在"+global.resDescription+"中输入值。");
			form1.description.focus();
			return false;
		}*/

		/*if(!document.form1.idList)
		{
			alert("请上传或提取资源。");
			form1.showPath.focus();
			return false;
		}*/
	}
	catch (e)
	{
		alert('错误号:'+i+" "+metaList[i].name+e.message);
		return false;
	}

	return true;
}
/////////元数据结束



//将复选框中的所有值转换成1,2,3,5的字符串值
function getListStr(checkBoxName)
{
	var listStr="";
	var checkBoxs = document.getElementsByName(checkBoxName);
	for (var i = 0; i < checkBoxs.length; i++)
	{
		if(checkBoxs[i].checked) 
		{
			listStr += ","+checkBoxs[i].value;
		}
	}
	if(listStr != "") listStr = listStr.substring(1);
	return listStr;
}

//子目序列号serialNo是否存在
function serialNoExist(serialNo,urlType)
{
	var arr;
	var checkBoxs = document.getElementsByName("idList");
	
	for (var i = 0; i < checkBoxs.length; i++)
	{
		arr = (checkBoxs[i].value).split("-");
		if(arr[0] == serialNo && arr[1] == urlType) return true;
	}

	return false;
}

//素材数据模板生成后，显示模板，并给表单元素赋值
function editMaterial(id,bEdit)
{
	try
	{
		//var theObj = document.getElementById("serial"+id);
		var serialsTR=document.getElementById("serialsTR");
		serialsTR.style.display = "block";

		var editDiv=document.getElementById("editMaterial");
		editDiv.style.display = "block";
		//setDivPos(editDiv,400,editDiv.offsetWidth);
		setDivCenter(editDiv);
		var editTit = document.getElementById("serialTitle");
		if(global.programId>0)
		{
			editMaterialForm.operation.value="edit";
			editMaterialForm.programId.value = global.programId;
		}
		else
		{
			editMaterialForm.operation.value="add";
		}

		onSelectSerial(editMaterialForm.selectSerial);
	}
	catch(e) 
	{	
		alert(e.name + ": " + e.message);
	}
}

function onSelectSerial(theObj)
{
	var theForm = theObj.form;
	var info = theObj.value;
	if(info != null && info != "")
	{
		var arrInfo = info.split("*");
		if(arrInfo.length > 3)
		{
			theForm.name.value=theObj.options[theObj.selectedIndex].text;
			theForm.urlType.value=arrInfo[0];
			theForm.progType.value=arrInfo[1];
			theForm.svrAddress.value=arrInfo[2];
			theForm.filePath.value=arrInfo[3];
			theForm.selSerialId.value=arrInfo[4];//选中的serialId
		}
		else
		{
			alert("该子目信息不完整");
		}
	}
	else
	{
		alert("该资源格式不能被提取，请关闭本窗口，另选其它资源。");
	}
}

function editSerial(id,bEdit)
{
	var theObj = document.getElementById("serial"+id);
	var editDiv=document.getElementById("editSerial");
	editDiv.style.display = "block";
	//setDivPos(editDiv,600,editDiv.offsetWidth);
	setDivCenter(editDiv);
	var editTit = document.getElementById("serialTitle");
	editTit.innerHTML = bEdit?"编辑子目":"添加子目";

	if(bEdit)
	{
		editSerialForm.operation.value = "edit";
	}
	else
	{
		editSerialForm.operation.value = "add";
		editSerialForm.serialNo.value = "";
	}

	onSerialUrlTypeChange();
}

function onSerialUrlTypeChange()
{
	var urlType = editSerialForm.urlType.value;
	var curDivObj = null;

	for (var i=0;i<14 ;i++ )
	{
		curDivObj = document.getElementById("tranStateDiv"+i);
		if(curDivObj)
		{
			curDivObj.style.display = i == urlType?"inline":"none";
		}
	}
}

//字符串左边补0，字符串位数charNum不大于10;
function padLeftZero(str,charNum)
{
	if(str == null || str == "") return "00";

	var s = "0000000000"+str;
	s = s.substring(s.length-charNum);
	return s;
}

function checkSerial(theForm)
{
	var operation = theForm.operation.value;
	var serialNo = theForm.serialNo.value;
	if(Jtrim(serialNo) == "")
	{
		alert("序号不能为空。");
		theForm.serialNo.focus();
		return false;
	}

	if(!isNum2(serialNo,1,1000))
	{
		alert("序号请输入1-1000数字");
		theForm.serialNo.focus();
		return false;
	}
	
	if(operation == "add" || serialNo != theForm.oldSerialNo.value)
	{
		var exsit = serialNoExist(theForm.serialNo.value,theForm.urlType.value);
		if(exsit)
		{
			alert("当前类型该序号已存在，请重新输入。");
			theForm.serialNo.focus();
			return false;
		}
		
	}

	if(Jtrim(theForm.name.value) == "")
	{
		alert("子目名称不能为空。");
		theForm.name.focus();
		return false;
	}

	if(Jtrim(theForm.filePath.value) == "")
	{
		alert("文件路径不能为空。");
		theForm.filePath.focus();
		return false;
	}

	var starttmH = theForm.starttmH.value;
	var starttmM = theForm.starttmM.value;
	var starttmS = theForm.starttmS.value;
	theForm.startTime.value = padLeftZero(starttmH,2)+":"+padLeftZero(starttmM,2)+":"+padLeftZero(starttmS,2);

	var endtmH = theForm.endtmH.value;
	var endtmM = theForm.endtmM.value;
	var endtmS = theForm.endtmS.value;
	theForm.endTime.value = padLeftZero(endtmH,2)+":"+padLeftZero(endtmM,2)+":"+padLeftZero(endtmS,2);

	if(theForm.startTime.value != "00:00:00" && theForm.startTime.value >= theForm.endTime.value)
	{
		alert("起始时间必须小于结束时间。");
		theForm.endtmH.focus();
		return false;
	}

	var transcodeState=0;
	var checkBoxs = theForm.transcodeStateList;
	if(checkBoxs){
		for (var i = 0; i < checkBoxs.length; i++)
		{
			if(checkBoxs[i].checked) 
			{
				transcodeState += parseInt(checkBoxs[i].value);
			}
		}
	}
	theForm.transcodeState.value = transcodeState;

	return true;
}

function playLink(theForm)
{
	var starttmH = theForm.starttmH.value;
	var starttmM = theForm.starttmM.value;
	var starttmS = theForm.starttmS.value;
	theForm.startTime.value = padLeftZero(starttmH,2)+":"+padLeftZero(starttmM,2)+":"+padLeftZero(starttmS,2);

	var endtmH = theForm.endtmH.value;
	var endtmM = theForm.endtmM.value;
	var endtmS = theForm.endtmS.value;
	theForm.endTime.value = padLeftZero(endtmH,2)+":"+padLeftZero(endtmM,2)+":"+padLeftZero(endtmS,2);

	if(theForm.startTime.value != "00:00:00" && theForm.startTime.value >= theForm.endTime.value)
	{
		alert("起始时间必须小于结束时间。");
		theForm.endtmH.focus();
		return false;
	}

	var strServer = global.videoSevr+':'+global.videoPort;
	var strUrl = theForm.filePath.value;
	var strProgName = theForm.name.value;
	var webHost = window.location.hostname+':'+global.videoPort;
	
	//BMTPPlayEx(strServer,strUrl,strProgName,'','',theForm.startTime.value,theForm.endTime.value);
	var url = "BMSP://ADDR="+strServer+";UID="+global.usename+";PWD="+global.pwd+";FILE="+theForm.filePath.value+";SUB1=;SUB2=;STM="+theForm.startTime.value+";ETM="+theForm.endTime.value+";PFG=2;"
	var playUrl = "bfp://"+webHost+"/pfg=p&enc=b&url="+Base64.encode(url);

	var iframeObj = document.getElementById("playFrame");
	if(!iframeObj) iframeObj = createIframe("playFrame");
	iframeObj.src = playUrl;

	return true;
}

//yyyy-mm-dd格式
function isValidDate(vDate)
{
	if(vDate==null || vDate=="")
		return false;
	var arrDate=vDate.split("-");
	if(arrDate.length!=3)
		return false;
	if(arrDate[0].length!=4 || !isNum2(arrDate[0],1000))
		return false;
	if(arrDate[1].length!=2 || !isNum2(arrDate[1],1,12))
		return false;
	if(arrDate[2].length!=2 || !isNum2(arrDate[2],1,31))
		return false;
	if ((arrDate[1] == 4 || arrDate[1] == 6 || arrDate[1] == 9 || arrDate[1] == 11) && (arrDate[2] == 31)) 
         return false;
	if (arrDate[1] == 2) 
	{
		var leap = (arrDate[0] % 4 == 0 &&(arrDate[0] % 100 != 0 || arrDate[0] % 400 == 0));
        if (arrDate[2]>29 || (arrDate[2] == 29 && !leap)) 
		{
            return false;
        }
    }

	return true;
}

//是否输入了标签
function isInputTag()
{
	for(var k=0;k<document.form1.programTag.length;k++)
	{
		if(Jtrim(document.form1.programTag[k].value) != "") return true;
	}

	return false;
}

//清除 描述中预先说明
function cleanPreDesc(theObj)
{
	if(theObj.value == '有关资源内容的自由文本描述 ，包括文摘、目次') theObj.value='';
}

function setUpSubPath()
{
	
}

function subtitleList(id)
{

	var theObj = document.getElementById("serial"+id);
	var editDiv=document.getElementById("subtitleList");
	editDiv.style.display = "block";
	//setDivPos(editDiv,500,editDiv.offsetWidth);
	setDivCenter(editDiv);
}

function editSubtitle(id,bEdit)
{

	var theObj = document.getElementById("serial"+id);
	var editDiv=document.getElementById("editSubtitle");
	editDiv.style.display = "block";
	//setDivPos(editDiv,400,editDiv.offsetWidth);
	setDivCenter(editDiv);
	var editTit = document.getElementById("subtitleTitle");
	editTit.innerHTML = bEdit?"编辑字幕":"添加字幕";

	if(bEdit)
	{
		editSerialForm.operation.value = "edit";
	}
	else
	{
		editSerialForm.operation.value = "add";
		editSerialForm.serialNo.value = "";
	}
}

function checkSubtitle(theForm)
{
	var operation = theForm.operation.value;
	var serialNo = theForm.serialNo.value;
	if(Jtrim(serialNo) == "")
	{
		alert("序号不能为空。");
		theForm.serialNo.focus();
		return false;
	}

	if(!isNum2(serialNo,1,1000))
	{
		alert("序号请输入1-1000数字");
		theForm.serialNo.focus();
		return false;
	}

	var isEdit = theForm.id.value > 0;
	
	var exsit = subtitleNoExist(theForm.serialNo.value);
	if(!isEdit && exsit)
	{
		alert("该序号已存在，请重新输入。");
		theForm.serialNo.focus();
		return false;
	}
	
	if(Jtrim(theForm.filePath.value) == "")
	{
		alert("文件路径不能为空。");
		theForm.filePath.focus();
		return false;
	}

	

	return true;
}

//设置显示缺省还是所有
function setShowType(n)
{
	global.showOpt = n;
	

	for (var i=0;i<3 ; i++)
	{
		curTabObj = document.getElementById("tab"+i);
		curTabObj.className = i == n?"efault-tab current":"efault-tab";
	}

	reShowAllTr();
	//setTimeout("parent.parent.setFrameHeight(parent.myMainFrame)", 10);
}

//设置行的显示或隐藏，用于显示缺省还是所有
function reShowAllTr()
{
	
	var metaObj = null;
	var vInd = 0;
	var bDisplay = true;

	for (var i=0;i<wtab.rows.length ;i++ )
	{
		var objTr = wtab.rows[i];
		if(objTr.id.indexOf('ind_') != -1)
		{
			vInd = parseInt(objTr.id.substring(4));
			metaObj = metaList[vInd];
			bDisplay = getMetaDisplay(metaObj);
			objTr.style.display = bDisplay?"block":"none";
		}
		
	}
}

//焦点移到输入框,因为输入框不可见时会出错
function inputFocus(theInput)
{
	try
	{
		theInput.focus();
	}
	catch (e)
	{
		$("showOpt_1").click();
		theInput.focus();
	}
}

//子目序列号serialNo是否存在
function subtitleNoExist(serialNo)
{	
	var tdObj = document.getElementById("subtitleSN"+serialNo);	
	
	if(tdObj)
		return true;
	else
		return false;
}

//通过绝对路径获取文件名称,hasExtName是否包括扩展名
function getFileName(sFilePath,hasExtName)
{
	if(sFilePath == null || sFilePath == "")
		return "";

	var sFileName="";
	var nTPos=0;
	sFilePath=sFilePath.replace("/\\/g","/");
	nTPos=sFilePath.lastIndexOf("/");
	if(nTPos>0)
	{
		sFileName=sFilePath.substring(nTPos+1);
		if(!hasExtName)
		{
			nTPos=sFileName.lastIndexOf(".");
			if(nTPos>0) sFileName=sFileName.substring(0,nTPos);
		}
	}

	return sFileName;
}

//通过绝对路径获取文件名称,最后以/号结尾
function getFileDir(sFilePath)
{
	if(sFilePath == null || sFilePath == "")
		return "";

	var sFileDir="";
	var nTPos=0;
	sFilePath=sFilePath.replace("/\\/g","/");
	nTPos=sFilePath.lastIndexOf("/");
	if(nTPos>0)
	{
		sFileDir=sFilePath.substring(0,nTPos+1);
	}

	return sFileDir;
}

//得到文件扩展名 
function getExtensionName (sFilePath) {
	if(sFilePath == null || sFilePath == "") return "";

	var sExtName="";
	var nTPos=sFilePath.lastIndexOf(".");
	if(nTPos>0) sExtName=sFilePath.substring(nTPos+1);

	return sExtName;
}

//获取图片地址：
function getImgAddr(filePath)
{
	var sImgAddr = 'http://'+global.videoSevr+':'+global.videoPort+'/course_def/res_url/'+Base64.encodeAsUtf8(getFileDir(filePath))+'@/'+getFileName(filePath,true);
	return sImgAddr;
}

function setUpLoadArgs()
{
	var state = form1.codeState.value;

	//如果是转码就保存到转码服务器
	//if(state == "${Serial.NO_CODE_STATE}")
	//都保存到视频服务器
	if(false)
	{
		form1.UpLoad1.ServIPAddr = global.transcodingIp;
		form1.UpLoad1.Port = global.transcodingPort;
		global.curUploadPath = global.transcodingPath;
	}
	else
	{
		form1.UpLoad1.ServIPAddr = global.videoSevr;
		form1.UpLoad1.Port = global.uploadPort;
		global.curUploadPath = global.uploadPath;
	}
}

//替换掉题名作为文件夹中特殊字符
function dirNameReplace(dirName)
{
	if(dirName == null || dirName == "") return ""; 
	dirName=dirName.replace(/[\ |\~|\`|\!|\@|\#|\$|\%|\^|\&|\*|\(|\)|\-|\_|\+|\=|\||\\|\[|\]|\{|\}|\;|\:|\"|\'|\,|\<|\.|\>|\/|\?]/g,""); 
	return dirName;
}

function onUploadTypeChange(theObj)
{
	//链接类型
	if(theObj.value == 'link')
	{
		showWnd('linkDiv');
		form1.linkRes.focus();

		//焦点移到文本后面
		var linkObj = document.getElementById('linkRes'); 
		var range = linkObj.createTextRange(); //建立文本选区  
		range.moveStart('character', linkObj.value.length); //选区的起点移到最后去 
		range.collapse(true);  
		range.select(); 
	}
	else
	{
		hideWnd('linkDiv');
	}
}



function onUrlTypeChange(theObj)
{
	//链接类型
	if(theObj.value == global.urlType.LINK)
	{
		showWnd('linkDiv');
		form1.linkRes.focus();

		//焦点移到文本后面
		var linkObj = document.getElementById('linkRes'); 
		var range = linkObj.createTextRange(); //建立文本选区  
		range.moveStart('character', linkObj.value.length); //选区的起点移到最后去 
		range.collapse(true);  
		range.select(); 
	}
	else
	{
		hideWnd('linkDiv');
	}

	if(theObj.value == global.urlType.VIDEO || theObj.value == global.urlType.MOBILE || theObj.value == global.urlType.TABLET || theObj.value == global.urlType.TEXT_LIBRARY || theObj.value == global.urlType.EMBED_PC)
	{	
		form1.codeState.disabled = false;
	}
	else
	{
		form1.codeState.value = "${Serial.NO_NEED_STATE}";
		setUpLoadArgs();
		form1.codeState.disabled = true;
	}

	//高清，标清显示隐藏
	var imgSpanObj = document.getElementById('imgOptSpan');
	var docSpanObj = document.getElementById('docOptSpan');
	var courseSpanObj = document.getElementById('courseOptSpan');
	if(imgSpanObj) imgSpanObj.style.display = (theObj.value == global.urlType.IMAGE)?"inline":"none";
	if(imgSpanObj) docSpanObj.style.display = (theObj.value == global.urlType.DOCUMENT)?"inline":"none";
	if(imgSpanObj) courseSpanObj.style.display = (theObj.value == global.urlType.COURSE)?"inline":"none";
}

//参数值没用了。
function uploadFiles(uploadType)
{
	/*var uploadTypeObj = document.form1.uploadType;
	var uploadType = uploadTypeObj.value;

	if(uploadType == 'disk') 
	{
		form1.UpLoad1.IsMultiFile = 1;
	}

	form1.UpLoad1.UploadFiles2();
*/
    var bfUpload = document.form1.bfUpload;
    bfUpload.upload();
	return true;
}

function setDescType(n)
{
	var descObj_0 = document.getElementById('descDiv0');
	var descObj_1 = document.getElementById('descDiv1');

	if(descObj_0) descObj_0.style.display = n == 0 ? "block":"none";
	if(descObj_1) descObj_1.style.display = n == 1 ? "block":"none";
}


function openFile(type)
{	
	var uploadTypeObj = document.form1.uploadType;
	var uploadType = uploadTypeObj.value;
	var urlTypeObj = document.form1.urlType;
	var uploadPath = global.curUploadPath.replace(/\/\//g,'/');
	global.uploadType = type;

	//////上传路径加上题名 star
	global.firstTitleId = getFirstTitleId();
	var title = "";
	var titleInput =  eval("document.form1.id_"+global.firstTitleId);
	if(titleInput) title = Jtrim(titleInput.value);
	
	title = dirNameReplace(title);
	if(title == "")
	{
		var titleObj = getMetaFromId(global.firstTitleId);
		alert("请输入"+titleObj.cnName+"后再上传。");
		titleInput.focus();
		return;
	}

	uploadPath += title + "/";
	//alert(uploadPath);
	//////上传路径加上题名 end
	
	//字幕上传1000
	if(type == UPLOAD_TYPE_SUBTITLE || type == UPLOAD_TYPE_FCK || type == UPLOAD_TYPE_SERIAL_PHOTO)
	{
		form1.UpLoad1.IsMultiFile = 0;
		form1.UpLoad1.SavePath = uploadPath;
		form1.UpLoad1.OpenFile();
		return;
	}
	
	
	if(urlTypeObj.value == -1)
	{
		alert("请选择正确的浏览方式或查看上传说明。");
		return;
	}
	
	//链接
	if(urlTypeObj.value == global.urlType.LINK)
	{
		onUrlTypeChange(urlTypeObj);
		return;
	}

	if(uploadType == 'file')
	{
		//海报
		if(urlTypeObj.value == global.urlType.POSTER)
			form1.UpLoad1.IsMultiFile = 0;
		else
			form1.UpLoad1.IsMultiFile = 1;
	}
	else if(uploadType == 'dir')
	{
		form1.UpLoad1.IsMultiFile = 2;
	}
	else if(uploadType == 'disk') 
	{
		form1.UpLoad1.IsMultiFile = 300;
	}
	else
	{
		return;
	}
//alert(uploadPath);
	form1.UpLoad1.SavePath = uploadPath;
	form1.UpLoad1.OpenFile();
}

function getArrCont(vMetaId,bDeco)
{
	var vArr = new  Array();
	var i,j,id;
	j=0;
	if(bDeco)
	{
		for (i=0;i<contentList.length;i++)
		{
			if(contentList[i].metaParentId == vMetaId)
			{
				vArr[j]=contentList[i];
				j++;
			}
		}
	}
	else
	{
		for (i=0;i<contentList.length;i++)
		{
			if(contentList[i].metaId == vMetaId)
			{
				vArr[j]=contentList[i];
				j++;
			}
		}
	}
	
	return vArr;
}


function OnOpenFile(name,size)
{
	if(global.uploadType == UPLOAD_TYPE_SUBTITLE) 
	{
		document.editSubtitleForm.upbtn.disabled=false;
	}
	else if(global.uploadType == UPLOAD_TYPE_FCK)
	{
		//不用处理
	}
	else if(global.uploadType == UPLOAD_TYPE_SERIAL_PHOTO) 
	{
		document.editSerialForm.upbtn.disabled=false;
	}
	else
	{
		form1.showPath.value="您选择了"+size+"个文件";
		form1.upbtn.disabled=false;
	}
}

function OnUpFinished()
{
	//序号*文件名*文件路径*格式类型*时长*码率
	var fileInfo = form1.UpLoad1.DstFileName;
	var urlType = form1.urlType.value;
	var uploadType = document.form1.uploadType.value;
	var transcodeState = 0;
	
	if(global.uploadType == UPLOAD_TYPE_SUBTITLE)
	{
		document.editSubtitleForm.filePath.value = fileInfo;
		//alert("字幕已上传到:"+fileInfo);
	}
	else if(global.uploadType == UPLOAD_TYPE_FCK)
	{
		var txtUrlCont = imgDialog.getContentElement('info', 'txtUrl');
		var txtUrlId = txtUrlCont.getInputElement().$.id;;
		var txtUrlObj = document.getElementById(txtUrlId);

		txtUrlObj.value = getImgAddr(fileInfo);
		txtUrlObj.fireEvent("onchange"); //触发url文本框的onchange事件，以便预览图片
	}
	else if(global.uploadType == UPLOAD_TYPE_SERIAL_PHOTO)
	{
		document.editSerialForm.photo.value = fileInfo;
		alert("photo已上传到:"+fileInfo);
	}
	else if(urlType == global.urlType.POSTER) 
	{
		fileInfo = "1*海报*"+fileInfo+"*0*0*0|";
	}
	else if(uploadType == 'dir') 
	{
		fileInfo = "1*课件*"+fileInfo+"/"+form1.UpLoad1.SetupFile+"*0*0*0|";
	}

	if(document.form1.codeStateList) 
	{
		
		//设置标清，高清等
		for (var i=0;i<document.form1.codeStateList.length ; i++)
		{
			var curTStateObj = document.form1.codeStateList[i];
			var isShow = curTStateObj.parentNode.style.display != "none";
			if(curTStateObj.checked && isShow) transcodeState += parseInt(curTStateObj.value);
		}
	
	}
	//alert(transcodeState);
	
	//不是字幕，富文本等
	if(global.uploadType < UPLOAD_TYPE_SUBTITLE) new Ajax.Updater({success:'serialList',failure:'error'},baseUrl + 'program/dealUpload',{asynchronous:true,evalScripts:true,parameters:'transcodeState='+transcodeState+'&program.id='+global.programId+'&urlType='+urlType+'&codeState='+form1.codeState.value+'&filePath='+encodeURIComponent(fileInfo)});
	document.getElementById("serialsTR").style.display = "block";
}


function submitLink()
{
	var link = Jtrim(form1.linkRes.value);
	var title = Jtrim(form1.linkTitle.value);
	if(link.length < 10)
	{
		alert("请正确输入链接地址。");
		form1.linkRes.focus();
		return;
	}
 
	if(title.length < 1)
	{
		alert("请输入链接名称。");
		form1.linkTitle.focus();
		return;
	}
 
	//序号*文件名*文件路径*格式类型*时长*码率
	var fileInfo = "1*"+title+"*"+link+"*0*0*0|";
 
	new Ajax.Updater({success:'serialList',failure:'error'},baseUrl + 'program/dealUpload',{asynchronous:true,evalScripts:true,parameters:'program.id='+global.programId+'&urlType='+form1.urlType.value+'&codeState='+form1.codeState.value+'&filePath='+encodeURIComponent(fileInfo)});
	document.getElementById("serialsTR").style.display = "block";
	//hideWnd('linkDiv');
}

function onClassChange(theObj)
{
	if(theObj.value < 1)
	{
		alert("请选择类库");
		document.getElementById("mainDiv").style.display="none";
		return;
	}
	self.location.href=baseUrl + "program/create?classLib.id="+theObj.value;
}


function deleteSerial()
{
	if(!hasChecked('idList')) 
	{
		alert("请至少选择一条记录。");
		return;
	}
	var idList=getListStr("idList");
	new Ajax.Updater({success:'serialList',failure:'error'},baseUrl + 'program/deleteSerial',{asynchronous:true,evalScripts:true,parameters:'program.id='+global.programId+'&idList='+idList});
}
 
function deleteSubtitle(serialId,subtitleId)
{
	new Ajax.Updater({success:'subtitleList',failure:'error'},baseUrl + 'program/deleteSubtitle',{asynchronous:true,evalScripts:true,parameters:'serialId='+serialId+'&subtitleId='+subtitleId});
}

function deleteRelationProgram(rid)
{
	var url = baseUrl + 'program/deleteRelationProgram';
	var update = 'relationProgramList';//template
	var params = 'id='+global.programId+'&rid='+rid;
	new Ajax.Updater({success:update,failure:'error'},url,{asynchronous:true,evalScripts:true,parameters:params});
}

//初始化时显示所有元素列表，重复条目下拉框，设置行数下拉框
function showAllTr()
{
	if(global.programId > 0) showAllTrEdit();
	else showAllTrAdd();
}

//初始化时显示所有元素列表，重复条目下拉框，设置行数下拉框
function showAllTrAdd()
{
	var i,iRow,iRow2;
	var curClassid=global.classId;
	iRow=0;
	iRow2=0;

	for (i=0;i<metaList.length;i++)
	{
		if(metaList[i].parentId == 0 )
		{
			if(showTr(iRow,i) == false)
				continue;
			iRow++;	
		}
	}

}

function showAllTrEdit()
{
	var i,j,k,ii,iRow,iRow2;
	var theMetaOjb,theTrObj;
	var vArr,bDeco;
	var vCell3;//列3
	iRow=0;

	for (i=0;i<metaList.length;i++)
	{

		theMetaOjb=metaList[i];
		if(theMetaOjb.parentId == 0)
		{

			bDeco=theMetaOjb.dataType == "decorate";
			vArr=getArrCont(theMetaOjb.selfId,bDeco);

			if(vArr != null && vArr.length>0)
			{				
				for (ii = 0; ii < vArr.length;ii++ )
				{
				
					if(showTr(iRow,theMetaOjb.index) == false) continue;
					if(bDeco)
					{
						wtab.rows[iRow].cells[1].firstChild.value=vArr[ii].metaId;
						onDecoChange(wtab.rows[iRow].cells[1].firstChild);
						wtab.rows[iRow].cells[2].firstChild.value=vArr[ii].dataType==1?vArr[ii].numContent:Jtrim(vArr[ii].strContent);						
					}
					else
					{
						wtab.rows[iRow].cells[2].firstChild.value=vArr[ii].dataType==1?vArr[ii].numContent:Jtrim(vArr[ii].strContent);
						if(theMetaOjb.dataType == "img" && Jtrim(vArr[ii].strContent) != "")
						{	
							var showImg=wtab.rows[iRow].cells[2].childNodes[10];
							showImg.style.display="inline";
						}
						else  if(theMetaOjb.dataType == "link" && Jtrim(vArr[ii].strContent) != "")
						{						
							var arrLink=getArrLink(vArr[ii].strContent);
							wtab.rows[iRow].cells[2].childNodes[2].value=arrLink[0];
							wtab.rows[iRow].cells[2].childNodes[4].value=arrLink[1];
						}
					}
					//theMetaOjb.repeatNum++;
					iRow++;
				}
				theMetaOjb.repeatNum = vArr.length-1;
			}
			else
			{			
				if(showTr(iRow,theMetaOjb.index) == false) continue;
				iRow++;
				
			}
		}
	}
	
}

//设置相关节目
function setRelationProgram()
{
	if(global.programId > 0) setRelationProgramEdit();
	else setRelationProgramAdd();
}

//设置相关节目 与节目添加页面不同，此处是远程更改模板
function setRelationProgramEdit(rid,name)
{
	var url = baseUrl + 'program/saveRelationProgram';
	var update = 'relationProgramList';//template
	var params = 'id='+global.programId+'&rid='+rid;
 
	new Ajax.Updater({success:update,failure:'error'},url,{asynchronous:true,evalScripts:true,parameters:params});
}

//设置相关节目,与edit页面不同，不是远程设置
function setRelationProgramAdd(id,name)
{
	if(form1.relation.value == "")
	{
		form1.relation.value = id;
		form1.showRelation.value = name;
	}
	else
	{
		form1.relation.value += ','+id;
		form1.showRelation.value += ','+name;
	}
}

//修改时更改类库
function onClassChangeEdit(theObj)
{
	if(theObj.value < 1)
	{
		alert("请选择类库");
		document.getElementById("mainDiv").style.display="none";
		return;
	}
	else if(theObj.value != theObj.form.oldClassLibId.value){
		self.location.href=baseUrl + "program/changeLib?programId="+global.programId+"&newClassLibId="+theObj.value+"&oldClassLibId="+theObj.form.oldClassLibId.value;
	}
	
}

//获得global.firstTitleId
function getFirstTitleId()
{
	var id = 0;
	var obj = document.form1.id_1;
	
	//考虑有多个题名
	id = typeof(obj.options) == "undefined"?obj[0].value:obj.value;

	return id;
}

