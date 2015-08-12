<%@ page import="nts.utils.CTools; nts.program.domain.Program; nts.meta.domain.MetaContent" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />		
        <title>nts.program.domain.Program List</title>
<link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}"  rel="stylesheet" type="text/css">

<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/appMgr/div.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/truevod.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/meta.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/metalist.js')}"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
//全局变量
var contentList = new Array();
var metaList = new Array();
var wtab;
var gDisciplineId="${application.metaDisciplineId}";

//初始化
window.onload = init;
function init()
{
	wtab = document.getElementById("metaContTab");
	setCurMetaList(${program?.directory?.id},1,-1);//显示当前类下可摘要显示
	showAllTr();
	setPlayTrShow();
	setImgNum();

	document.getElementById("bodyDiv").style.display = "block";	
}

//设置播放行，下载行是否显示,有的资源只有图片，没有可点播下载的资源
function setPlayTrShow()
{
	var playTrObj = document.getElementById("playTr");
	var playTdObj = document.getElementById("playTd");
	var downTrObj = document.getElementById("downTr");
	var downTdObj = document.getElementById("downTd");
	var imgDivObj = document.getElementById("imgDiv");
	

	if(playTdObj)
	{
		if(playTdObj.innerHTML.length < 10) playTrObj.style.display = "none";
	}
	if(downTdObj)
	{
		if(downTdObj.innerHTML.length < 10) downTrObj.style.display = "none";
	}
	if(imgDivObj)
	{
		if(imgDivObj.innerHTML.length < 100) imgDivObj.style.display = "none";
	}
}

function showTr(arrCell,iRow)
{
	if(iRow == -1) iRow=wtab.rows.length;//-1表从最末行显示
	wtab.insertRow(iRow);
	wtab.rows[iRow].insertCell(0);
	wtab.rows[iRow].cells[0].className="key";
	wtab.rows[iRow].cells[0].innerHTML=arrCell[0];
	wtab.rows[iRow].insertCell(1);
	wtab.rows[iRow].cells[1].innerHTML=arrCell[1];
}

function showAllTr()
{
	
	var arrCell=new Array("","");
	var i,iRow,j,elementObj,theProgObj,vContent;
	iRow=1;//从第几行开始
	for (i=0;i<metaList.length;i++)
	{
		if(metaList[i].parentId == 0)
		{			
			//theProgObj=progList[0];
			elementObj=metaList[i];
			vContent=getContent(elementObj);
			if (vContent == null || vContent == "")
				continue;
			
			arrCell[0]=elementObj.cnName;					
			arrCell[1]=vContent;
			showTr(arrCell,iRow);
				
			iRow++;				
		}
	}
	
}

function getENameFromId(vId,vArrEnum)
{
	if(vArrEnum == null)
		return "";
	var i;
	for (i=0;i<vArrEnum.length;i++)
	{
		if(vArrEnum[i].id == vId)
			return vArrEnum[i].name;
	}

	return "";	 
}

//参数是元素
function getContent(elementObj)
{
	if(elementObj == null)
		return null;
	var i,j,vStr,arrEnum,bAddBr,theContent,elementId,useMetaobj;
	var eleName="",decoName="";//元素名，修饰词名
	var eMenuId,eMenuName;
	var bDeco = elementObj.dataType == "decorate";//是否是复合元素
	vStr="";

	for (j=0;j<contentList.length ;j++ )
	{	
		theContent = contentList[j];
		elementId = bDeco?theContent.metaParentId:theContent.metaId;//是修饰词，则content元数据的parentId是元素ID

		if(elementId == elementObj.selfId)
		{
		
			useMetaobj = bDeco?getMetaFromId(theContent.metaId):elementObj;
			if(useMetaobj == null) continue;
			eleName=elementObj.cnName;
			decoName=useMetaobj.cnName;
			decoName = eleName==decoName?"":(decoName+"：");

			if(useMetaobj.dataType == "number")
			{
				if(theContent.numContent > 0)
					vStr += decoName+theContent.numContent+"<br>";
			}
			else if(useMetaobj.dataType == "enumeration")
			{
				arrEnum = useMetaobj.arrEnum;
				if(arrEnum != null)
				{
					eMenuId=theContent.numContent;
					eMenuName=getENameFromId(eMenuId,arrEnum)
					if(eMenuId > 0 && eMenuName != "")
					{
						vStr += decoName+eMenuName+"<br>";
					}
					else 
					{
						if(gDisciplineId==elementObj.selfId)//没有二级学科的显示一级学科名
							vStr += useMetaobj.cnName+"<br>";
					}
				}
			}
			else if(useMetaobj.dataType == "link")
			{
				if(theContent.strContent != "")
					vStr += decoName+HTMLDeCode(theContent.strContent)+"<br>";
			}
			else
			{
				if(theContent.strContent != "")
				{
					vStr += decoName+HTMLEnCode(theContent.strContent)+"<br>";
				}				
			}
		}	
	}//for

	if(vStr.substring(vStr.length-1) == "；")
		vStr=vStr.substring(0,vStr.length-1);
	
	return vStr;	 
}

function HTMLDeCode(str)
{   
	var s="";   
	if(str.length==0) return "";
	s=str.replace(/&amp;/g,"&");
	s=s.replace(/&lt;/g,"<");
	s=s.replace(/&gt;/g,">");
	s=s.replace(/&nbsp;/g," ");
	s=s.replace(/<br>/g,"\n");
	s=s.replace(/&#39;/g,"\'");	
	s=s.replace(/&quot;/g,"\"");
	return s;
} 

function HTMLEnCode(str)
{   
	var s="";   
	if(str.length==0) return "";
	s=str.replace(/[\r\n]/g,"<br>");
	s=s.replace(/[\n]/g,"<br>");
	
	return s;
} 

function checkRemark()
{
	var theForm = document.remarkForm;

	if(theForm.topic.value == "")
	{
		alert("请输入主题。");
		theForm.topic.focus();
		return false;
	}

	if(theForm.content.value == "")
	{
		alert("请输入内容。");
		theForm.content.focus();
		return false;
	}

	//theForm.submit();
}

function showRemarkPost()
{
	var remarkPost = document.getElementById('remarkPost');
	remarkPost.style.display = "block";
}


function hideRemarkPost()
{
	var remarkPost = document.getElementById('remarkPost');//可用$()
	remarkForm.reset();
	remarkPost.style.display = "none";
}

//id是层ID
function showDiv(id)
{
	eval("document."+id+"Form.reset();");//清空先前的内容
	var editDiv=document.getElementById(id);
	editDiv.style.display = "block";
	setDivCenter(editDiv);
}

function checkError(theForm)
{
	if(theForm.errorTitle.value == "")
	{
		alert("请输入错误标题。");
		theForm.errorTitle.focus();
		return false;
	}

	if(theForm.errorContent.value == "")
	{
		alert("请输入错误内容。");
		theForm.errorContent.focus();
		return false;
	}
}

function checkCollect(theForm)
{
	if(theForm.tag.value == "")
	{
		alert("请输个性标签。");
		theForm.tag.focus();
		return false;
	}

	
}

function showFileInfo(theObj,sHtml)
{
	if(sHtml == null || sHtml == "") return;

	var divObj = document.getElementById("fileInfo");
	var subDivObj = document.getElementById("fileInfoBC");

	//防止右边div看不见
	var centerPos = document.body.clientWidth/2;//水平
	var theObjLeft = getAbsoluteLeft(theObj);
	
	if(theObjLeft < centerPos + divObj.clientWidth-35)
		divObj.style.left = theObjLeft;
	else
		divObj.style.left = theObjLeft-divObj.clientWidth;

	divObj.style.top = getAbsoluteTop(theObj)+25;
	subDivObj.innerHTML = HTMLEnCode(sHtml);
	divObj.style.display = "block";
}

function hideFileInfo()
{
	var fileDiv = document.getElementById("fileInfo");
	fileDiv.style.display = "none";
}

///////////////////////////////////////////////////////////////图片开始

var gImgNum=0;
var gCurImgIndex=0;
var gCurAbbrImgObj = null;

function openImg(index,url)
{	
	var curImgDivObj = document.getElementById("curImgDiv");
	var curImgObj = document.getElementById("curImg");
	
	if(gCurAbbrImgObj) gCurAbbrImgObj.className = "";
	curImgObj.style.zoom = "100%";
	curImgObj.src = url;

	gCurAbbrImgObj = document.getElementById("abbrImg_"+index);
	gCurAbbrImgObj.className = "curAbbrImg";
	
	curImgDivObj.style.display = "block";
	gCurImgIndex = index;
}

function resizeImg(ImgD,iwidth,iheight) { 
      var image=new Image(); 
      image.src=ImgD.src;

      if(image.width>0 && image.height>0){ 
         if(image.width/image.height>= iwidth/iheight){ 
            if(image.width>iwidth){ 
                ImgD.width=iwidth; 
                ImgD.height=(image.height*iwidth)/image.width; 
            }else{ 
                   ImgD.width=image.width; 
                   ImgD.height=image.height; 
                 } 
                ImgD.alt=image.width+"×"+image.height; 
         } 
         else{ 
                 if(image.height>iheight){ 
                        ImgD.height=iheight; 
                        ImgD.width=(image.width*iheight)/image.height; 
                 }else{ 
                         ImgD.width=image.width; 
                         ImgD.height=image.height; 
                      } 
                 ImgD.alt=image.width+"×"+image.height; 
             } 
　　　　　//ImgD.style.cursor= "pointer"; //改变鼠标指针 
　　　　　//ImgD.onclick = function() { window.open(this.src);} //点击打开大图片 
		
		//////////////////滚轮缩放开始 
		/*
		if(navigator.userAgent.toLowerCase().indexOf("ie") > -1)
		{  
　　　　　　ImgD.onmousewheel = function img_zoom() //滚轮缩放 
			{ 			
　　　　　　　　var zoom = parseInt(this.style.zoom, 10) || 100; 
　　　　　　　　zoom += event.wheelDelta / 12; 
　　　　　　　　if (zoom> 0 && ImgD.width*zoom/100 < iwidth)　this.style.zoom = zoom + "%"; 
　　　　　　　　return false; 				
　　　　　 } 
		} 
		//如果不是IE 
		else {
　　　　　　　      //ImgD.title = "点击图片可在新窗口打开"; 
		} 
		*/
		//////////////////滚轮缩放开始
     } 
} 

function toImg(n)//n=-1 pri,n=1 next
{
	if(gCurImgIndex < 1 && n < 0)
	{
		alert("已是第一张图片了！");
		return;
	}

	if(gCurImgIndex > gImgNum-2 && n > 0)
	{
		alert("已是最后一张图片了！");
		return;
	}

	gCurImgIndex=gCurImgIndex+n;
	var curImgObj = document.getElementById("curImg");
	var gCurAbbrImgObj = document.getElementById("abbrImg_"+gCurImgIndex);
	gCurAbbrImgObj.click();

	//setNodeInfo("imgCur.jsp?sid="+gArrSID[gCurImgIndex],"curImg");
	
	//document.getElementById("imgpos").innerHTML="("+(gCurImgIndex+1)+"/"+gImgNum+")";
	//document.getElementById("imgpos2").innerHTML="("+(gCurImgIndex+1)+"/"+gImgNum+")";
	//setNodeInfo("imgCur.jsp?sid="+gArrSID[gCurImgIndex],"curImgDesc");
}

function onImg(obj,n)//n=0 click ,1 onmouseover,2 onmouseout
{
	//obj=document.getElementById("curImg").firstChild;
	if(n==2)
	{
		obj.className="";
		return;
	}
	var vCenterPos=getCenterPos(obj);
	
	if(event.clientX < vCenterPos)
	{	
		if(n==0) 
		{
			//obj.alt="";
			toImg(-1);
			return;
		}
		
		obj.className="precur";
		//obj.alt="可使用鼠标滚轮缩放图片,点击图片左边跳到上一张";	
	}
	else
	{
		if(n==0) 
		{
			//obj.alt="";
			toImg(1);
			return;
		}
		
		obj.className="nextcur";
		//obj.alt="可使用鼠标滚轮缩放图片,点击图片右边跳到下一张";
	}	
}

function getCenterPos(obj)
{
	var w = document.body.clientWidth/2;
	return w;
}

function hideImgWnd()
{
	hideWnd('curImgDiv');
	if(gCurAbbrImgObj) gCurAbbrImgObj.className = "";
}

function setImgNum()
{
	var imgNumObj = document.getElementById("abbrImgNum");
	if(imgNumObj) gImgNum = imgNumObj.value;
}

//////////////////////////////////////////////////图片结束


<g:each in="${program.metaContents}" status="i" var="metaContent">
	contentList[${i}] = new CContentTypeObj(${metaContent.id},${metaContent.metaDefine.id},${metaContent.metaDefine.parentId},${MetaContent.numDataTypes.contains(metaContent.metaDefine.dataType)?1:2},${metaContent.numContent},'${CTools.nullToBlank(metaContent.strContent).encodeAsJavaScript()}');
</g:each>

//-->
</SCRIPT>
    </head>
    <body>
        
        <div class="body" id="bodyDiv" style="display:none">
				
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>

<!--资源信息开始-->
	<div class="categoryTitle">${Program.cnTableName}信息</div>
	<table id="progInfo" border="0" width="100%" border="0" cellspacing="1">
	<tr>
		<td id="posterTd">
			<img src="${posterLink(serials:program?.serials,isAbbrImg:false)}">
		</td>
		<td id="progInfoTd">
		  <table border="0" width="99%" id="metaContTab" style="border-collapse:collapse" >
			<tr>
				<td colspan="2">
				<img src="${createLinkTo(dir:'images/skin',file:'collect.gif')}" border=0 >
				<a href="#" onClick="showDiv('collectProgram')">我要收藏</a>&nbsp;&nbsp;&nbsp; 
				<g:remoteLink action="recommendProgram" id="${program?.id}">我要推荐</g:remoteLink>&nbsp&nbsp;&nbsp;
				<a href="#" onClick="showDiv('correctError')">我要纠错</a>&nbsp&nbsp;&nbsp;				
				</td>
			</tr>
		
			<!-- 元数据
			
			-->
			<tr>
				<td class="key">${Program.cnField.dateCreated}</td>
				<td class="value"><g:formatDate format="yyyy-MM-dd" date="${program?.dateCreated}"/></td>
			</tr>
			<tr>
				<td class="key">${Program.cnField.consumer}</td>
				<td><g:link action="linkView" params="[type:1,keyword:program?.consumer.id,cnName:program?.consumer.nickname]">${program?.consumer.nickname.encodeAsHTML()}</g:link></td>
			</tr>
			<tr>
				<td class="key">统计</td>
				<td>${Program.cnField.frequency}：${program?.frequency} 下载次数：${program?.downloadNum} 推荐次数：${program?.recommendNum}</td>
			</tr>
			
			<tr>
				<td class="key">${Program.cnField.programTags}</td>
				<td>
				<g:each in="${program?.programTags}" status="i" var="tag">
					<g:link action="linkView" params="[type:2,keyword:tag.id,cnName:tag?.name]">${tag?.name.encodeAsHTML()}</g:link>
				</g:each>
				</td>
			</tr>			
		  </table>
		</td>
	</tr>
<g:if test="${program?.serials.size() > 0}">
	<tr id="playTr">
		<td colspan="2" id="playTd">播放：
		<g:playLinks programId="${program.id}" serials="${program?.serials}" isPlay="1" />
		</td>
	</tr>
	<g:if test="${program?.canDownload}">
	<tr id="downTr">
		<td colspan="2" id="downTd">下载：
		<g:playLinks programId="${program.id}" serials="${program?.serials}" isPlay="0" />
		</td>
	</tr>
	</g:if>
</g:if>
	<tr>
		<td colspan="2">简介：</td>
	</tr>
	<tr>
		<td colspan="2" class="desc" style="padding-left:10px;"><div style="padding:5px;border:1px solid #ccc;">${CTools.codeToHtml(program?.description)}</div></td>
	</tr>
	
</table>
<!--资源信息结束-->

<!--图片开始-->
			<g:if test="${program?.serials.size() > 0}">
			<div id="imgDiv">
				<div class="categoryTitle">图片资源</div>
				<!--当前图片开始-->		
					<DIV id="curImgDiv" class="bg" style="POSITION: relative;margin:2px 4px 2px 4px;display:none;">
						<DIV class="rg1"></DIV><DIV class="rg2"></DIV> 
						<DIV class="t1"><DIV class="leftTit" style="float:left;">图片</DIV><DIV class="closeBtn" style="padding:5px 5px 2px 2px;float:right;"><img src="${resource(dir: 'images/skin', file: 'closeWnd.gif')}" onclick="hideImgWnd();" alt="关闭"></DIV></DIV>
						<DIV class="bc">
							<div align="center"><img id="curImg" onMouseMove="onImg(this,3);" onmouseover="onImg(this,1);" onmouseout="onImg(this,2);" onclick="onImg(this,0);" onload="javascript:resizeImg(this,840,1100);" src="http://localhost:1680/iclass2/123_0_0_0/ZjovcHViL21hc3Rlci9saWIxL8TjusMuanBn@/frame.htm"></div>
							
							<div style="padding:4px 2px 2px 2px;" align="center"><img style="cursor:pointer;" src="${resource(dir: 'images/skin', file: 'bn_prev.gif')}" border="0" align="absmiddle" onmouseover="this.src='${resource(dir: 'images/skin', file: 'bn_prev_o.gif')}'" onmouseout="this.src='${resource(dir: 'images/skin', file: 'bn_prev.gif')}'" onclick="toImg(-1);">&nbsp;&nbsp;
							<img style="cursor:pointer;" src="${resource(dir: 'images/skin', file: 'bn_next.gif')}" border="0" align="absmiddle" onmouseover="this.src='${resource(dir: 'images/skin', file: 'bn_next_o.gif')}'" onmouseout="this.src='${resource(dir: 'images/skin', file: 'bn_next.gif')}'" onclick="toImg(1);">&nbsp;&nbsp;<img style="cursor:pointer;" src="${resource(dir: 'images/skin', file: 'close_btn.gif')}" onclick="hideImgWnd();"></div>
						</DIV> 
						<DIV class="rg3"></DIV>
						<DIV class="rg4"></DIV> 
					</DIV>
				<!--当前图片结束-->
				<g:imgLinks programId="${program.id}" serials="${program?.serials}" cols="${application.AbbrImgRowPerNum}" />
			</div>
			</g:if>
<!--图片结束-->	

<!--相关资源开始-->
			<g:if test="${program.relationPrograms && program.relationPrograms.size()>0}">
				<div class="categoryTitle">相关资源</div>
				<g:relationProgramLinks programList="${program.relationPrograms.toList()}" />
			</g:if>
<!--相关资源结束-->	

<!--点播了此资源的用户开始-->
			<g:if test="${consumerList}">
				<div class="categoryTitle">点播了此资源的用户</div>
				<g:consumerLinks consumerList="${consumerList}" />
			</g:if>
<!--点播了此资源的用户结束-->

<!--点播了此资源的用户还点播了开始-->
			<g:if test="${otherProgramList}">
				<div class="categoryTitle">点播了此资源的用户还点播了</div>
				<g:otherProgramLinks otherProgramList="${otherProgramList}" />
			</g:if>
<!--点播了此资源的用户还点播了结束-->

<!--资源评论开始-->			
			<div class="categoryTitle">最新评论&nbsp&nbsp;<g:if test="${session.consumer?.canComment}"><img align="absmiddle" style="cursor:pointer;" src="${createLinkTo(dir:'images/skin',file:'wyfb.gif')}" onclick="showRemarkPost();"></g:if></div>
			<div id="remark" style="margin:8px 0px 10px 0px;">
				<div id="remarkPost" style="display:none">
					<table border="0" width="100%">
					 <g:formRemote name="remarkForm" update="remarkList" url="[action:'saveRemark', params: ['program.id':program?.id]]" after="hideRemarkPost();">
						<tr>
							<td id="radio"><font style="color:#ff6600">打分-></font>&nbsp;
							<input type="radio" value="5" name="rank"><img src="${createLinkTo(dir:'images/skin',file:'stars5.gif')}" border=0 >&nbsp;&nbsp;
							<input type="radio" value="4" name="rank"><img src="${createLinkTo(dir:'images/skin',file:'stars4.gif')}" border=0 >&nbsp;&nbsp;
							<input type="radio" value="3" name="rank" checked><img src="${createLinkTo(dir:'images/skin',file:'stars3.gif')}" border=0 >&nbsp;&nbsp;
							<input type="radio" value="2" name="rank"><img src="${createLinkTo(dir:'images/skin',file:'stars2.gif')}" border=0 >&nbsp;&nbsp;
							<input type="radio" value="1" name="rank"><img src="${createLinkTo(dir:'images/skin',file:'stars1.gif')}" border=0 >
							</td>
						</tr>
						<tr>
							<td>主题：<input type="text" name="topic" size="60"></td>
						</tr>
						<tr>
							<td>内容：</td>
						</tr>
						<tr>
							<td style="padding-left:40px;"><textarea name="content" style="width:550px;height:60px;"></textarea></td>
						</tr>
						<tr>
							<td align="center"> 小提示:您要为您发表的言论后果负责，请各位遵守法纪注意语言文明&nbsp;&nbsp;&nbsp;&nbsp;<input type="image" style="border:0px;height:22px;width:85px" align="absmiddle" src="${createLinkTo(dir:'images/skin',file:'fb.gif')}" onclick="return checkRemark();">&nbsp;<img align="absmiddle" style="cursor:pointer;" src="${createLinkTo(dir:'images/skin',file:'qx.gif')}" onclick="hideRemarkPost();"></td>
						</tr>
						
					 </g:formRemote>
					</table>
				</div>
			<g:render template="remarkList" model="[remarkList:remarkList]"/>
			</div>			
<!--资源评论结束-->


        </div>

<!--收藏开始-->	
		<DIV id="collectProgram" class="bg" style="width:300px;display:none;">
			<DIV class="rg1"></DIV><DIV class="rg2"></DIV> 
			<DIV class="t1">收藏</DIV>
			<DIV class="bc">

				<g:formRemote method="post" name="collectProgramForm" url="[action:'collectProgram']" before="hideWnd('collectProgram');">
				<input type="hidden" name="id" value="${program.id}">
					<div class="dialog">
                    <table style="width:250px;">
                        <tbody>
                       
                            <tr class="prop">
                                <td colspan="2" class="name">
                                    <label for="tag">收藏选项设置</label>
                                </td>
                                
                            </tr> 
							
							<tr class="prop">
                                <td class="name">
                                    <label for="tag">个性标签:</label>
                                </td>
                                <td>
                                    <input type="text" id="tag" style="width:200px;" maxlength="10" name="tag" value="" />
                                </td>
                            </tr> 
                            
                        </tbody>
                    </table>
                </div>
                <div align="center" style="margin-top:6px;">
					<g:submitButton name="upbtn" style="cursor:pointer;width:40px;" value="确定" onclick="return checkCollect(this.form);"/>&nbsp;<input type="button" onclick="hideWnd('collectProgram');" style="cursor:pointer;width:40px;" value="关闭">
                </div>
            </g:formRemote>

			</DIV> 
			<DIV class="rg3"></DIV>
			<DIV class="rg4"></DIV> 
		</DIV>
<!--收藏结束-->

<!--纠错开始-->	
		<DIV id="correctError" class="bg" style="width:390px;display:none;">
			<DIV class="rg1"></DIV><DIV class="rg2"></DIV> 
			<DIV class="t1">纠错</DIV>
			<DIV class="bc">

				<g:formRemote method="post" name="correctErrorForm" url="[action:'correctError']" before="hideWnd('correctError');">
					<div class="dialog">
                    <table>
                        <tbody>
                       
                            <tr class="prop">
                                <td class="name">
                                    <label for="errorTitle">错误标题:</label>
                                </td>
                                <td>
                                    <input type="text" id="errorTitle" style="width:200px;" maxlength="100" name="errorTitle" value="" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td class="name">
                                    <label for="errorContent">错误内容:</label>
                                </td>
                                <td>
                                    <textarea style="width:292px;height:60px;" name="errorContent"></textarea>
                                </td>
                            </tr> 
      
                        </tbody>
                    </table>
                </div>
                <div align="center" style="margin-top:6px;">
					<g:submitButton name="upbtn" style="cursor:pointer;width:40px;" value="确定" onclick="return checkError(this.form);"/>&nbsp;<input type="button" onclick="hideWnd('correctError');" style="cursor:pointer;width:40px;" value="关闭">
                </div>
            </g:formRemote>

			</DIV> 
			<DIV class="rg3"></DIV>
			<DIV class="rg4"></DIV> 
		</DIV>
<!--纠错结束-->

<!--文件信息开始-->	
		<DIV id="fileInfo" class="bg" style="width:250px;display:none;">
			<DIV class="rg1"></DIV><DIV class="rg2"></DIV> 
			<DIV class="t1">文件信息</DIV>
			<DIV class="bc" id="fileInfoBC">

			</DIV> 
			<DIV class="rg3"></DIV>
			<DIV class="rg4"></DIV> 
		</DIV>
<!--文件信息结束-->


	
    </body>
</html>
		    
