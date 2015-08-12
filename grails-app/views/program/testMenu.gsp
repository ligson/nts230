<HTML>
 <HEAD>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <TITLE> New Document </TITLE>
 </HEAD>

 <BODY>
   <div><!--每个video都需要有一个单独的parentNode，即每个video外面都有个div或者p等等。为了兼容IE876-->
	<video controls="controls" width="640" height="352" poster="http://movie.doubanxia.com/files/2010_ruse_trailer_360p.jpg" autoplay="autoplay">
		<source src="${resource(dir: 'media', file: 'Aa2.mp4')}" type="video/mp4" />
	</video>
</div> 
 </BODY>
</HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>search</title>
<LINK href="${resource(dir: 'css', file: 'w_main.css')}" type=text/css rel=stylesheet>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/prototype.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'meta.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'metalist.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'dateSelectBox.js')}"></script>
 
<SCRIPT type=text/JavaScript> 
function onChangeState(id){
	//var qsliObj=document.getElementById("qsjs");
	//var gjliObj=document.getElementById("gjjs");
	var gjsearch=document.getElementById("gjsearch");
	var qksearch=document.getElementById("qksearch");
	var divObj1=document.getElementById("simpleSearch");
	var divObj2=document.getElementById("advSearch");
	if(id=="1"){	
		//qsliObj.className="ctr_01";
		//gjliObj.className="ctr_02";
		divObj1.style.display="";
		divObj2.style.display="none";
		gjsearch.style.color="#333333";
		qksearch.style.color="#999900";
	}
	if(id=="2"){	
		//qsliObj.className="ctr_02";
		//gjliObj.className="ctr_01";
		divObj1.style.display="none";
		divObj2.style.display="";
	
		gjsearch.style.color="#999900";
		qksearch.style.color="#333333";
	}
}
</SCRIPT>
<script language="javascript"> 
function show(as)
{
	var str = null;
	str = as.style.display;
	if(str== "block")
	{
		as.style.display="none";
		if(as==exp1)
		{
			document.all("btn1").src=baseUrl + "images/skin/exp_.gif";
		}
		
	}
	else
	{
		as.style.display="block";
		if(as==exp1)
		{
			document.all("btn1").src=baseUrl + "images/skin/exp.gif";
		}
		
	}
}
function submitSimpleSch()
{
	document.form2.submit();
}
</script>
 
 
<SCRIPT LANGUAGE="JavaScript"> 
<!--
////////////////////////////////////////////////////////////////////////////////
 
 
//////初始化资源类别
 
var wtab;
 
var metaList = new  Array();
var vArrEnumList = new  Array();
var gSchRowNum=1;
var gRecord_dateId=0;
 
 
var gTdNum=4;
//var wtab=;
 
function init()
{
	
 
	var classId=form1.classid.value;
	//setCurMetaList(classId,-1,1);
	metaList=allMetaList;
	wtab=document.getElementById("wtab")
	showAllTr();
 
	
 
}
 
function onClassChange()
{
	var rowsLen,i;
	rowsLen=wtab.rows.length;
	
	for (i=1;i<rowsLen ;i++ )
	{
		wtab.deleteRow(rowsLen-i);
	}
 
	showAllTr();
}
 
function showTr(iRow,vInd)
{
	var vStr,metaObj,EID,vClassid,firstDecoObj,creatorObj;
	vClassid=parseInt(document.form1.classid.value);
	metaObj=metaList[vInd];
	EID=metaObj.selfId;//元素ID
	wtab.insertRow(iRow);
	wtab.rows[iRow].className=(iRow%2==0)?"tr0":"tr1";
	wtab.rows[iRow].id="ind_"+vInd;
		
	var j,k,m,ij;
	for(j=0;j<gTdNum;j++)
	{
		wtab.rows[iRow].insertCell(j);
		if(j==0)
		{
			wtab.rows[iRow].cells[j].width="100";
			wtab.rows[iRow].cells[j].align="left";
			wtab.rows[iRow].cells[j].style.paddingLeft="4";
			vStr = '<input type="hidden" name="eid_'+EID+'" value="1">';
			
			vStr += metaObj.cnName;			
			wtab.rows[iRow].cells[j].innerHTML=vStr;
		}
		else if(j==1)
		{
			wtab.rows[iRow].cells[j].width="110";
			//wtab.rows[iRow].cells[j].align="center";
			vStr="&nbsp;";
			FirstDecoObj=null;
			
			if(metaObj.dataType == "decorate")
			{
				
				vStr = '<select name="deco_'+EID+'" onchange="onDecoChange(this);">\n';
				for (k=0;k<metaList.length;k++)
				{	
				
					if(metaList[k].parentId == metaObj.selfId && (metaList[k].directorys.size() == 0 || metaList[k].directorys.include(vClassid)))
					{
						vStr += '<option value="'+metaList[k].selfId+'">'+metaList[k].cnName+'</option>\n';
						if(firstDecoObj == null)
						{
							firstDecoObj = metaList[k];//用于设置后面一列是包含还是大于等
						}	
					}													
				}
				if(firstDecoObj == null)
				{
					wtab.deleteRow(iRow);
					return false;
				}
				vStr += '</select>\n';
	
			}
			wtab.rows[iRow].cells[j].innerHTML=vStr;
		}
		else if(j==2)
		{
			wtab.rows[iRow].cells[j].width="100";
			//wtab.rows[iRow].cells[j].align="center";
			vStr="";
			//如果是修饰词，第四列表单元素的类型是第一个修饰词的类型，否则由第二列元素的类型
			var useMetaobj=metaObj.dataType == "decorate"?firstDecoObj:metaObj;
 
			if(useMetaobj == null)
			{
				vStr="&nbsp;";
			}
			else if(useMetaobj.dataType == "enumeration")
			{
				vStr += '&nbsp;';
			}
			else if(useMetaobj.dataType == "date" || useMetaobj.selfId == gRecord_dateId)
			{
				vStr='<input type="hidden" name="comp_'+EID+'" value="300">&nbsp;';
			}
			else  if(useMetaobj.dataType == "number")
			{
				vStr = '<select style="width:74px;" name="comp_'+EID+'">';
				vStr += '<option value="-2">小于</option>';
				vStr += '<option value="0">等于</option>';
				vStr += '<option value="1">大于</option>';
				vStr += '</select>';
			}
			else
			{
				vStr = '<select name="comp_'+EID+'">';
				vStr += '<option value="50">前方一致</option>';
				vStr += '<option value="100" selected>模糊查询</option>';
				vStr += '<option value="200">完全匹配</option>';
				vStr += '</select>';
			}
				
			wtab.rows[iRow].cells[j].innerHTML=vStr;
		}
		else if(j==3)
		{
			wtab.rows[iRow].cells[j].width="340";
			//wtab.rows[iRow].cells[j].align="center";
			vStr="";
			//如果是修饰词，第四列表单元素的类型是第一个修饰词的类型，否则由第二列元素的类型
			var useMetaobj=metaObj.dataType == "decorate"?firstDecoObj:metaObj;
 
			if(useMetaobj == null)
			{
				vStr="&nbsp;";
			}
			else if(useMetaobj.dataType == "enumeration")
			{
				vStr = '<select name="key_'+EID+'">\n';
				vStr += '<option value="">--请选择--</option>';
				for (ij=0;ij<useMetaobj.arrEnum.length;ij++)
				{
					vStr += '<option value="'+useMetaobj.arrEnum[ij].id+'" '+(useMetaobj.defaultValue==useMetaobj.arrEnum[ij].id?'selected':'')+'>'+useMetaobj.arrEnum[ij].name+'</option>\n';
				}
				vStr += '</select>\n';
			}
			else if(useMetaobj.dataType == "date" || useMetaobj.selfId == gRecord_dateId)
			{
				vStr = '<input style="width:70px;" name="key_'+EID+'" type="text" maxlength="20" value="">';
				vStr += '<img src="images/space.gif" width="2"><img align="absmiddle" src="images/datetime.gif"  style="cursor:hand;" onclick="return showDateDialog(form1.key_'+EID+')">&nbsp;至&nbsp;<input style="width:70px;" name="key2_'+EID+'" type="text" maxlength="20" value=""><img src="images/space.gif" width="2"><img align="absmiddle" src="images/datetime.gif"  style="cursor:hand" onclick="return showDateDialog(form1.key2_'+EID+')">(格式:2005-01-01)';
			}
			else
			{
				vStr = '<input name="key_'+EID+'" type="text" maxlength="40" value="">';
			}
				
			wtab.rows[iRow].cells[j].innerHTML=vStr;
		}
		else if(j==4)
		{
			wtab.rows[iRow].cells[j].width="80";
			vStr = '&nbsp;<select style="width:60px;" name="andor_'+EID+'">';
			vStr += '<option value="0">并且</option>';
			vStr += '<option value="1">或者</option>';
			vStr += '</select>';
 
			wtab.rows[iRow].cells[j].innerHTML=vStr;
		}
	}
 
	return true;
}
 
//初始化时显示所有元素列表，重复条目下拉框，设置行数下拉框
function showAllTr()
{
	var rowsLen,j;
	rowsLen=wtab.rows.length;
 
	for (j=1;j<rowsLen ;j++ )
	{
		wtab.deleteRow(rowsLen-j);
	}
 
	var i,iRow,vClassid;
	iRow=1;
	vClassid=parseInt(document.form1.classid.value);
 
	gSchRowNum=metaList.length;
	for (i=0;i<gSchRowNum;i++)
	{
	
		if(metaList[i].parentId == 0 && (metaList[i].directorys.size() == 0 || metaList[i].directorys.include(vClassid)))
		{
		
			if(showTr(iRow,i) == false)
				continue;
			iRow++;
		}
	}
	//wtab.rows[iRow-1].cells[4].innerHTML="&nbsp;";
}
 
//设置添加和删除行的行数下拉列表,行序号
function setRowNum()
{
	var iRow=wtab.rows.length;
	document.form1.rowSel.length=0;
	document.form1.rowSelDel.length=0;
	var i;
	for (i=0;i<iRow ;i++ )
	{
		wtab.rows[i].cells[0].innerHTML=i+1;
		document.form1.rowSel.options[i]=new Option(i+1,i+1);
		document.form1.rowSelDel.options[i]=new Option(i+1,i); 
	}
}
 
//修饰词变化时
function onDecoChange(theSelObj)//(vInd,vRepeatNum)//vInd是metaList数组的下标
{
	var vStr;
	var vId=theSelObj.value;
	var EID=(theSelObj.name).substring(5);
	var useMetaobj=getMetaFromId(vId);
 
	if(useMetaobj != null)
	{
		if(useMetaobj.dataType == "enumeration")
		{
			vStr = '&nbsp;';
		}
		else if(useMetaobj.dataType == "date" || useMetaobj.selfId == gRecord_dateId)
		{
				vStr='<input type="hidden" name="comp_'+EID+'" value="300">&nbsp;';
		}
		else  if(useMetaobj.dataType == "number")
		{
			vStr = '<select style="width:74px;" name="comp_'+EID+'">';
			vStr += '<option value="-2">小于</option>';
			vStr += '<option value="0">等于</option>';
			vStr += '<option value="1">大于</option>';
			vStr += '</select>';
		}
		else
		{
			vStr = '<select name="comp_'+EID+'">';
			vStr += '<option value="50">前方一致</option>';
			vStr += '<option value="100" selected>模糊查询</option>';
			vStr += '<option value="200">完全匹配</option>';
			vStr += '</select>';
		}
 
		theSelObj.parentElement.nextSibling.innerHTML=vStr;
		if(useMetaobj.dataType == "enumeration")
		{
			vStr = '<select name="key_'+EID+'">\n';
				vStr += '<option value="">--请选择--</option>';
				for (ij=0;ij<useMetaobj.arrEnum.length;ij++)
				{
					vStr += '<option value="'+useMetaobj.arrEnum[ij].id+'" '+(useMetaobj.defaultValue==useMetaobj.arrEnum[ij].id?'selected':'')+'>'+useMetaobj.arrEnum[ij].name+'</option>\n';
				}
				vStr += '</select>\n';
			theSelObj.parentElement.nextSibling.nextSibling.innerHTML=vStr;
		}
		else if(useMetaobj.dataType == "date" || useMetaobj.selfId == gRecord_dateId)
		{
				vStr = '<input style="width:70px;" name="key_'+EID+'" type="text" maxlength="20" value="">';
				vStr += '<img src="images/space.gif" width="2"><img align="absmiddle" src="images/datetime.gif"  style="cursor:hand;" onclick="return showDateDialog(form1.key_'+EID+')">&nbsp;至&nbsp;<input style="width:70px;" name="key2_'+EID+'" type="text" maxlength="20" value=""><img src="images/space.gif" width="2"><img align="absmiddle" src="images/datetime.gif"  style="cursor:hand" onclick="return showDateDialog(form1.key2_'+EID+')">(格式:2005-01-01)';
		}
		else
		{
			vStr = '<input name="key_'+EID+'" type="text" maxlength="40" value="">';
		}
		theSelObj.parentElement.nextSibling.nextSibling.innerHTML=vStr;
	}
}
 
//验证输入
function check()
{
	var i,j,repeatNum,theSelObj,theInput,curDecoOjb;
	var formName="form1";
	var rowsLen=wtab.rows.length;
	try
	{	
		for (i=0;i<gSchRowNum;i++)
		{
			if(metaList[i].parentId == 0)
			{
				if(metaList[i].dataType == "decorate")
				{
					theInput=eval(formName+".deco_"+metaList[i].selfId);
					if(theInput && theInput.value > 0)
					{
						theSelObj=getMetaFromId(theInput.value);						
					}
				}
				else
				{
					theSelObj=metaList[i];					
				}
 
				if(theSelObj.dataType == "number" || theSelObj.dataType == "enumeration")
				{
					theInput=eval(formName+".key_"+metaList[i].selfId);
					if(theInput && theInput.value != "" && isNaN(theInput.value))
					{
						alert(theSelObj.cnName+"中请输入数字值。");
						theInput.focus();
						return false;
					}
				}
 
				if(theSelObj.dataType == "date" || theSelObj.selfId == gRecord_dateId)
				{
					theInput=eval(formName+".key_"+metaList[i].selfId);
					if(theInput && theInput.value != "" && !isValidDate(theInput.value))
					{
						alert(theSelObj.cnName+"中请按日期格式:2005-01-01输入。");
						theInput.focus();
						return false;
					}
 
					theInput=eval(formName+".key2_"+metaList[i].selfId);
					if(theInput && theInput.value != "" && !isValidDate(theInput.value))
					{
						alert(theSelObj.cnName+"中请按日期格式:2005-01-01输入。");
						theInput.focus();
						return false;
					}
				}//
 
			}
		}
	}
	catch (e)
	{
		alert(e.message+gSchRowNum);
		return false;
	}
 
	return true;
}
 
function submitSSch()
{
	if(check())
	{
		form1.submit();
	}
	
}
//-->
</SCRIPT>
</head>
 
<body onload="init();">
	<TABLE align="center" cellSpacing=0 cellPadding=0 width=577 border=0>
        <TBODY>
        <TR>
          <TD width=63><IMG height=50 src="${resource(dir: 'images/skin', file: 'w_left.gif')}"
            width=63></TD>
          <TD align=left width=505 background=${resource(dir: 'images/skin', file: 'm_left23.0.2.gif')}>
            <DIV id=cr_top><SPAN class=STYLE18><A class=hs1 id=qksearch 
            style="COLOR:#999900" onClick="onChangeState('1');" 
            href="#">快速检索</A></SPAN><SPAN 
            class=STYLE19></SPAN>&nbsp;| <SPAN class=STYLE18>&nbsp;<A class=hs1 style="COLOR:#333333" 
            id=gjsearch onClick="onChangeState('2');" 
            href="#">高级检索</A></SPAN> 
          </DIV></TD>
          <TD width=10><IMG height=50 src="${resource(dir: 'images/skin', file: 'w_right.gif')}"
            width=27></TD>
        </TR></TBODY>
	</TABLE>
 
	<TABLE align="center" id=simpleSearch style="display:block" cellSpacing=0 cellPadding=0 width=577 border=0>
        <form name="form2" action="result" method="post">
		<input type="hidden" name="isFirst" value="1">
		<input type="hidden" name="isSimple" value="1">
 
        <TR>
          <TD vAlign=top align=middle background=${resource(dir: 'images/skin', file: 'm_left43.0.2.gif')} height=101>
            <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
              <TBODY>
              <TR>
                <TD colSpan=5></TD></TR>
              <TR>
                <TD width="14%" height=27 align="right" vAlign=middle noWrap><SPAN 
                  class=STYLE16>资源检索</SPAN></TD>
                <TD vAlign=center noWrap align=center width="17%">&nbsp;&nbsp; 
					<select name="type">
					  <option value="1">资源名称</option>
					  <option value="2">主要责任者</option>
					  <option value="3">编目者</option>
					  <option value="4">关键词/标签</option>
					</select>
				</TD>
                <TD vAlign=center noWrap align=center width="43%"><input maxlength=30 size=30 name="keyword" value=""/></TD>
                <TD vAlign=center noWrap align=left width="26%"><img src="${resource(dir: 'images/skin', file: 'search.gif')}" border="0" style="cursor:pointer;" onclick="submitSimpleSch();"></TD>
              </TR>
              <TR>
                <TD height=33></TD>
                <TD align=left colSpan=3></TD>
              </TR>
              <TR>
                <TD height=27>&nbsp;</TD>
            <TD align=right colSpan=4></TD>
              </TR></TBODY></TABLE></TD></TR>
     </FORM>
	</TABLE>
 
 
	<TABLE align="center" id=advSearch style="display:none" cellSpacing=0 cellPadding=0 width=577 border=0>
        <form name="form1" action="advancedSearchResult" method="post">
		<input type="hidden" name="isFirst" value="1">
		<input type="hidden" name="isSimple" value="0">
        <TR>
          <TD align="center" valign="top" background=${resource(dir: 'images/skin', file: 'm_left4.gif')} height=206>
        
			<table width="540"  border="0" cellspacing="0" cellpadding="0" style="margin-top:10px; margin-bottom:10px ">
			  <tr>
				<td width="30"><img src="${resource(dir: 'images/skin', file: 'icon02.gif')}" ></td>
				<td width="510">
					选择类库：<select name="classid" onchange="onClassChange();" id="classid" >
<option value="27" >讲座</option>
<option value="26" >语言</option>
<option value="29" >网络课程</option>
<option value="4" >东大印象</option>
<option value="23" >音乐</option>
<option value="14" >影视</option>
<option value="31" >节目</option>
<option value="32" >动漫</option>
<option value="30" >戏剧戏曲</option>
<option value="2" >新东方</option>
<option value="1" >爱迪克森</option>
</select>
				</td>
			  </tr>
			</table>
 
			<table id="wtab" cellSpacing="1" width="540" align="center" border="0">
				<tr>
					<td >检索项</td>
					<td >检索子项</td>
					<td >匹配方式</td>
					<td >检索词</td>				
				</tr>
 
			</table>
 
			<table cellSpacing="1" width="540" align="center" border="0">
				<tr>
				  <td align="center">
				  入库时间：&nbsp;从 
					<input name="sch2_date_start" id="sch2_date_start" readonly type="text" value="" onClick="return Calendar('sch2_date_start');">&nbsp;到 
					<input name="sch2_date_end" id="sch2_date_end" readonly type="text" value="" onClick="return Calendar('sch2_date_end');">
					&nbsp;最新上传： 
					<select name="sch2_date_last" size="1">
						<option value="0" selected>全部</option>
						<option value="7" >最近一周</option>
						<option value="15" >最近半月</option>
						<option value="30" >最近一月</option>
						<option value="90" >最近三月</option>
						<option value="183" >最近半年</option>
					</select></td>
				</tr>
 
			</table>
 
			
 
			<table width="577"  border="0" cellspacing="0" cellpadding="0" style="margin-top:10px; margin-bottom:10px ">
			  <tr>
				<td width="67%" align="right">
				<img src="${resource(dir: 'images/skin', file: 'search.gif')}" width="68" height="20" border="0" align="absmiddle" onclick="submitSSch();" style="cursor:pointer;">
				<img src="${resource(dir: 'images/skin', file: 'clean.gif')}" width="68" height="20" border="0" align="absmiddle" style="cursor:pointer;"></td>
				<td width="33%" align="center"></td>
			  </tr>
			</table>
 
		  </TD>
		</TR>
		</FORM>
	 </TABLE>
 
	<TABLE align="center" cellSpacing=0 cellPadding=0 width=577 border=0>
        <TBODY>
        <TR>
          <TD align=left width=10><IMG height=28 src="${resource(dir: 'images/skin', file: 'm_left5.gif')}" width=22></TD>
          <TD class=STYLE22 align=right width=560 background="${resource(dir: 'images/skin', file: 'm_left63.0.2.gif')}"></TD>
          <TD align=right width=10><IMG height=28 src="${resource(dir: 'images/skin', file: 'm_left73.0.2.gif')}')}" width=27></TD>
        </TR>
        </TBODY>
    </TABLE>
 			
</body>
</html>

