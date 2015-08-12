
//全局常量
var OPT_IMG_POSTER = 1; //对应Serial字段：transcodeState 海报
var OPT_DOC_LIB = 2; //对应Serial字段：transcodeState 文库
var OPT_ISO_VIRTUAL = 4; //对应Serial字段：transcodeState 虚拟光驱
var OPT_VIDEW_STANDARD = 8; //对应Serial字段：transcodeState 标清,表示已经转码的文件
var OPT_VIDEW_HIGH = 16; //对应Serial字段：transcodeState 高清
var OPT_VIDEW_SUPER = 32; //对应Serial字段：transcodeState 超清

var isTruePlayerSetUped = false;//播放器是否已安装
var isUploadCtrlSetUped = false;//上传控件是否已安装
var txtExtNameList = "doc,rtf,txt";//文档类型扩展名列表,必须用小写
var Serial = {NO_NEED_STATE:0,NO_CODE_STATE:1,CODING_STATE:2,CODED_STATE:3,CODED_FAILED_STATE:4};

if(navigator.appName == "Netscape")
	{
		 var mimetype = navigator.mimeTypes["application/netplayer-script"];
		 if(mimetype)
		 {
		 		var plugin = mimetype.enabledPlugin;
			 	if(plugin)
			 	{
					document.write('<embed type="application/netplayer-script" width=1 height=1 hidden="true">');
				}
			}
}


function LoginDirect(strUsrName,strPassword)
{
	try
	{
		if(navigator.appName == "Microsoft Internet Explorer")
		{
			var LoginObj,lret;
			LoginObj = new ActiveXObject("XMNetHelper.NetLogin");
			LoginObj.LoginDirect(strUsrName,strPassword);
			delete LoginObj;
			//return true;
		}
		else
		{
				var embed = document.embeds[0];
				embed.LoginDirect(strUsrName,strPassword);
				//return true;
		}		
		
	}
	catch(e)
	{		
		//downloadTruePlayer();
		//用户点击了我已安装
		if(getCookie('playerSetuped') == "TRUE") isTruePlayerSetUped = true;
		return false;
	}

	isTruePlayerSetUped = true;
	return true;
}





function LoginDialog()
{
	try
	{
		var LoginObj,lret;
		LoginObj = new ActiveXObject("XMNetHelper.NetLogin");
		lret = LoginObj.LoginBox();
		delete LoginObj;
	}
	catch(e)
	{
		downloadTruePlayer();
	}
	return lret;
}
function TruevodPlay(strServer,strUrl)
{
	try
	{	
		
	if(navigator.appName == "Microsoft Internet Explorer")
		{
		var TruePlayer;
		TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
		TruePlayer.Play(strServer,strUrl);
		delete TruePlayer;
		}
		else
		{
				var embed = document.embeds[0];
				embed.Play(strServer,strUrl);
				return true;
		}				
		
	}
	catch(e)
	{
		downloadTruePlayer();
	}
	return true;
}

function TruevodPlayEx(strServer,strUrl,strProgName)
{
	try
	{	
	if(navigator.appName == "Microsoft Internet Explorer")
		{
			var TruePlayer;
			TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
			TruePlayer.PlayEx(strServer,strUrl,strProgName);
			delete TruePlayer;
		}
		else
		{
				var embed = document.embeds[0];
				embed.PlayEx(strServer,strUrl,strProgName);
				return true;
		}				

	}
	catch(e)
	{
		downloadTruePlayer();
	}
	return true;
}

function TruevodPlayExID(strServer,strUrl,strProgName,nProgID)
{
	try
	{
		

	if(navigator.appName == "Microsoft Internet Explorer")
		{
			var TruePlayer;
			TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
			TruePlayer.PlayExID(strServer,strUrl,strProgName,nProgID);
			delete TruePlayer;
		}
		else
		{
				var embed = document.embeds[0];
				embed.PlayExID(strServer,strUrl,strProgName,nProgID);
				return true;
		}		
		

	}
	catch(e)
	{
		downloadTruePlayer();
	}	
	return true;
}

function TruevodPlayEx2ID(strServer,strUrl,strProgName,nProgID,nSubProgID)
{
	try
	{	
		
	if(navigator.appName == "Microsoft Internet Explorer")
		{
			var TruePlayer;
			TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
			TruePlayer.PlayEx2ID(strServer,'null',strProgName,nProgID,nSubProgID);
			delete TruePlayer;
	
		}
		else
		{
				var embed = document.embeds[0];
				embed.PlayEx2ID(strServer,'null',strProgName,nProgID,nSubProgID);
				return true;
		}				
	}
	catch(e)
	{
		downloadTruePlayer();
	}	
	return true;
}

function TruevodPlayEx3ID(strServer,strUrl,strProgName,nProgID,nSubProgID,strStartTm,strEndTm)
{
	try
	{	
		
	if(navigator.appName == "Microsoft Internet Explorer")
		{
			var TruePlayer;
			TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
			TruePlayer.PlayEx3ID(strServer,'null',strProgName,nProgID,nSubProgID, strStartTm,strEndTm);
			delete TruePlayer;
		}
		else
		{
				var embed = document.embeds[0];
				embed.PlayEx3ID(strServer,'null',strProgName,nProgID,nSubProgID, strStartTm,strEndTm);
				return true;
		}		
		
		
	}
	catch(e)
	{
		downloadTruePlayer();
	}	
	return true;
}

function BMTPPlayEx(strServer,strUrl,strProgName,strSubtitle1,strSubtitle2,strStartTm,strEndTm)
{
	strProgName="";//暂时设为空，太长点播不了
	strUrl = Jtrim(strUrl);//导入的数据或用户手工修改数据库，路径前后可能有空格
	var extName = getFileExtName(strUrl).toLowerCase();
	
	if(extName != "" && txtExtNameList.indexOf(extName) != -1)
	{
		BMTPDown(strServer,strUrl,strProgName,extName);
		return;
	}

	try
	{		
		if(navigator.appName == "Microsoft Internet Explorer")
		{
			var TruePlayer;
			TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
			TruePlayer.BmtpPlayEx(strServer,strUrl,strProgName,strSubtitle1,strSubtitle2,strStartTm,strEndTm);
			delete TruePlayer;
		}
		else
		{
				var embed = document.embeds[0];
				embed.BmtpPlayEx(strServer,strUrl,strProgName,strSubtitle1,strSubtitle2,strStartTm,strEndTm,2);
				return true;
		}				

	}
	catch(e)
	{
		downloadTruePlayer();
	}
	return true;
}

function BMTPPlayEx2ID(strServer,strProgName,nProgID,nSubProgID)
{
	try
	{	
		
	if(navigator.appName == "Microsoft Internet Explorer")
		{
			var TruePlayer;
			TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
			TruePlayer.BmtpPlayEx2ID(strServer,strProgName,nProgID,nSubProgID);
			delete TruePlayer;
		}
		else
		{
				var embed = document.embeds[0];
				embed.BmtpPlayEx2ID(strServer,strProgName,nProgID,nSubProgID);
				return true;
		}		
		

	}
	catch(e)
	{
		downloadTruePlayer();
	}
	return true;
}

function BMTPPlayEx3ID(strServer,strProgName,nProgID,nSubProgID,strStartTm,strEndTm)
{
	try
	{	

	if(navigator.appName == "Microsoft Internet Explorer")
		{
			var TruePlayer;
			TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
			TruePlayer.BmtpPlayEx3ID(strServer,strProgName,nProgID,nSubProgID, strStartTm,strEndTm);
			delete TruePlayer;
		}
		else
		{
				var embed = document.embeds[0];
				embed.BmtpPlayEx3ID(strServer,strProgName,nProgID,nSubProgID, strStartTm,strEndTm);
				return true;
		}				
		

	}
	catch(e)
	{
		downloadTruePlayer();
	}
	return true;
}
function BMTPPlayEx4ID(strServer,strProgName,nProgID,nSubProgID,sDiskId,strStartTm,strEndTm,nFlag)
{
	try
	{

	if(navigator.appName == "Microsoft Internet Explorer")
		{
			var TruePlayer;
			TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
			TruePlayer.BmtpPlayEx4ID(strServer,strProgName,nProgID,nSubProgID,sDiskId,strStartTm,strEndTm,nFlag);
			delete TruePlayer;
		}
		else
		{
				var embed = document.embeds[0];
				embed.BmtpPlayEx4ID(strServer,strProgName,nProgID,nSubProgID,sDiskId,strStartTm,strEndTm,nFlag);
				return true;
		}				
		
	}
	catch(e)
	{
		downloadTruePlayer();
	}
	return true;
}

function BMTPNullPlay(strServer,strProgName,strExt,nProgID,nSubProgID,DiskId,nFlag)
{
	try
	{	
		
	if(navigator.appName == "Microsoft Internet Explorer")
		{
			var TruePlayer;
			TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
			TruePlayer.BmtpNullPlay(strServer,strProgName,strExt,nProgID,nSubProgID,DiskId,nFlag);
			delete TruePlayer;
		}
		else
		{
				var embed = document.embeds[0];
				embed.BmtpNullPlay(strServer,strProgName,strExt,nProgID,nSubProgID,DiskId,nFlag);
				return true;
		}				
	}
	catch(e)
	{
		downloadTruePlayer();
	}
		return true;
}

function BMTPDown(strServer,strUrl,strProgName,strFileExt)
{
	try
	{	
	strUrl = Jtrim(strUrl);
	if(navigator.appName == "Microsoft Internet Explorer")
		{
			var TruePlayer;
			TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
			TruePlayer.BMTPDown(strServer,strUrl,strProgName,strFileExt);
			delete TruePlayer;
		}
		else
		{
				var embed = document.embeds[0];
				embed.BMTPDown(strServer,strUrl,strProgName,strFileExt);
				return true;
		}				
		
	
	}
	catch(e)
	{
		downloadTruePlayer();
	}
	return true;
}
//
function DisableIEMaximize()
{
	var TruePlayer;
	TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
	TruePlayer.IESizeEnable(0);
	delete TruePlayer;
	return true;
}
//
function NullPlay(strServer,strUrl,strProgName,strFileExt)
{
	try
	{	

	if(navigator.appName == "Microsoft Internet Explorer")
		{
			var TruePlayer;
			TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
			TruePlayer.NullPlay(strServer,strUrl,strProgName,strFileExt);
			delete TruePlayer;
		}
		else
		{
				var embed = document.embeds[0];
				embed.NullPlay(strServer,strUrl,strProgName,strFileExt);
				return true;
		}				
		
	
	}
	catch(e)
	{
		downloadTruePlayer();
	}
	return true;
}
///////////////////////////////////////////////////////////////////////////////
//主动接收广播
//	strServerIPAddr - 广播服务器的IP地址，字符串型
//	nChannelNo - 节目在广播服务器上设置的频道号数字型
//
//
//////////////////////////////////////////////////////////////////////////////
function PlayBroadCast(strServerIPAddr, nChannelNo)
{
	try
	{	
		var TruePlayer;
		TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
		TruePlayer. PlayBroadCast(strServerIPAddr, nChannelNo);
		delete TruePlayer;
	}
	catch(e)
	{
		downloadTruePlayer();
	}
	return true;
}

///////////////////////////////////////////////////////////////////////////////
//自动搜索广播
//////////////////////////////////////////////////////////////////////////////
function AutoReceive ()
{
	try
	{	
		var TruePlayer;
		TruePlayer = new ActiveXObject("XMNetHelper.NetPlayer");
		TruePlayer. AutoReceive();
		delete TruePlayer;
	}
	catch(e)
	{
		downloadTruePlayer();
	}
	return true;
}


//
function OpenWindow(url,h,w,caption)
{
	var winobj;
	var left=(screen.width-w)/2
	var top=(screen.height-h)/2
	stropenopt = "height=" +h+",width="+w+",status=no,toolbar=no,menubar=no,location=no resizable =no top=" +top + " left=" + left;
	winobj = window.open(url,caption,stropenopt,true);
	return winobj;
}

function OpenWindowEx(url,h,w,caption)
{
	var winobj;
	var left=(screen.width-w)/2
	var top=(screen.height-h)/2
	stropenopt = "height=" +h+",width="+w+",status=no,scrollbars=yes,toolbar=no,menubar=no,location=no resizable =no top=" +top + " left=" + left;
	winobj = window.open(url,caption,stropenopt,true);
	return winobj;
}

function UPLoginDirect(strUsrName,strPassword)
{
	try
	{
		if(navigator.appName == "Microsoft Internet Explorer")
		{
			var LoginObj,ver;
			LoginObj = new ActiveXObject("uploadctl2.NetLogin");
			LoginObj.LoginDirect(strUsrName,strPassword);
			ver = LoginObj.Version;
			delete LoginObj;
			if( ver < 73) 
			{
				//alert("您安装的上传控件版本: Build "+ver+" ,当前系统上载版本为：Build 73 。请重新下载并安装上传控件。");
				//document.location.href=baseUrl + "downdir/upload.exe";
				downloadUploadCtrl(73);
				return false;

			}
			return true;
		}
		//上传控件暂不支持firfox
		else
		{
				//var embed = document.embeds[0];
				//embed.LoginDirect(strUsrName,strPassword);
				return true;
		}		
	}
	catch(e)
	{
		downloadUploadCtrl(0);
		//document.location.href=baseUrl + "downdir/upload.exe";
		return false;
	}
}

//点播或下载资源 参数programId是资源progam的id，serialId是子目serial的id,参数serialNum是资源progam的子目数serialNum(serialId>1时,该数字无用;serialId=0且serialNum=10000时,表示批量播放),isPlay:0下载 1播放
function playProgram2(isPlay,programId,serialId,serialNum,startTime,endTime,isWeb)
{
	//如果子目ID<1，且是多文件，打开详细页面	
	if(serialId<1 && serialNum > 1 &&  serialNum != 10000)
	{
		openWebWin(baseUrl + "program/showProgram?id="+programId);
		return;
	}

	if(true)//(checkPlayer())
	{			
		var url = baseUrl + 'program/playProgram';
		var params = 'isPlay='+isPlay+'&programId='+programId+'&serialId='+serialId+'&serialNum='+serialNum+'&startTime='+startTime+'&endTime='+endTime+'&timestamp'+new Date().getTime(); 
		
		//解决IE7等新开页面不是当前页面问题
		if(isWeb) document.WebWnd=window.open("about:blank");

		jQuery.ajax({
			type: "GET",
			url: url,
			data: params, 
			success: function(data){
				try{
					eval(data);
				}
				catch(e){alert("error:"+e.message)}
		   }
		});
	}
	else
	{
		downloadTruePlayer();
	}
}

//点播或下载资源 
function playProgram(playUrl,programId,urlType,isPlay,authState,playType,serialId,transcodeState,state)
{
	//记得与progedit.js中的同步
	var urlTypes={
		"BATCH":-1,
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

	var playTypes={		
		"PC":0,
		"MOBILE":1,
		"TABLET":2
	};

	var authStateMap = {'OK':0,'AUTH_FAIL':1,'NO_EXIST':2};
	var arrPlay = new Array("下载","点播");
	var serialIdList = "";

	if(typeof(gProgramId) != 'undefined' && gProgramId > 0) programId = gProgramId;

	//有的页面，如历史记录没有定义gOutHost变量
	if(typeof(gOutHost) != "string") gOutHost = "";

	if(authState == authStateMap.AUTH_FAIL)
	{
		alert("对不起，权限不够，你不能"+arrPlay[isPlay]+"该资源，请联系管理员。");
		return;
	}
	else if(authState == authStateMap.NO_EXIST)
	{
		alert("对不起，该资源不存在，可能已被删除。");
		return;
	}

	if(isPlay == 0 && urlType != urlTypes.VIDEO && urlType != urlTypes.COURSE && urlType != urlTypes.DOCUMENT && urlType != urlTypes.BATCH && urlType != urlTypes.MOBILE && urlType != urlTypes.TABLET)
	{
		alert("对不起，该资源只是一个链接，不能被下载。");
		return;
	}

	if(isPlay == 0 && playUrl.indexOf("http://") != -1)
	{
		alert("对不起，该资源只是一个链接，不能被下载。");
		return;
	}

	//2 is OPT_DOC_LIB,文库中不转码的尚无处理逻辑
	if(isPlay == 1 && urlType == urlTypes.DOCUMENT && (transcodeState & 2) == 2 && state != Serial.CODED_STATE && state != Serial.NO_NEED_STATE)
	{
		alert("对不起，该文件尚未转码完成，现暂时下载打开原始文档。");
		OpenPlayUrl(playUrl);
		return;
	}

	if(urlType == urlTypes.BATCH) serialIdList = playUrl;
	
	//ajax 到服务器端计数与写操作日志
	var url = baseUrl + 'program/playProgram';
	var params = 'isPlay='+isPlay+'&programId='+programId+'&urlType='+urlType+'&serialIdList='+serialIdList+'&isOutHost='+(gOutHost != ""?1:0)+'&&timestamp='+new Date().getTime(); 
	/*如果下面代码不注释，会在下级节点创建OutPlayLog
	if(gOutHost != "") 
	{
		url = baseUrl + 'webMethod/proxy?url=' + gOutHost+ encodeURIComponent(url+'?'+params);
		params = '';
	}
	*/

	//只有本地播放(非采集)，才支持批量播放和写入播放日志
	//if(gOutHost == "")
	if(true)
	{	
		if("undefined" != typeof jQuery){
			jQuery.ajax({
				type: "GET",
				url: url,
				data: params, 
				success: function(data){
					try{
						eval(data);
					}
					catch(e){alert("error:"+e.message)}
			   }
			});
		}
		else{
			var myAjax = new Ajax.Request( 
			url, 
			{ 
				method: 'get', 
				parameters: params, 
				onComplete: function(request){ 
					try{
						eval(request.responseText);
					}
					catch(e){alert("error:"+e.message)}
				} 
			});
		}
	}
	
	if(urlType != urlTypes.BATCH) 
	{	
		//因为audio标签支持的格式有限，帮必须同时保证资源格式及点播设备都满足
		if(isPlay == 1 && (playType == playTypes.MOBILE || playType == playTypes.TABLET) && (urlType == urlTypes.MOBILE || urlType == urlTypes.TABLET))
			openWebWin(baseUrl + "program/playHTML5.gsp?playUrl="+encodeURIComponent(playUrl));
		else if(isPlay == 1 && urlType == urlTypes.DOCUMENT && ((transcodeState & OPT_DOC_LIB) == OPT_DOC_LIB))
			openWebWin(baseUrl + "program/textLibrary?programId="+programId+"&serialId="+serialId+"&playUrl="+encodeURIComponent(playUrl));
		else
			OpenPlayUrl(playUrl);
	}
}

function openWebWin(strurl)
{
	window.open(strurl);
}

function downloadTruePlayer()
{
	showDownPlayerDiv(1,0);
}

function downloadUploadCtrl(version)
{
	showDownPlayerDiv(2,version);
}

//type 1下载播放器 2下载上传控件 version对应的版本号
function showDownPlayerDiv(type,version)
{
	var div = null;
	var divWidth = 360;
	var divHeight = 300;
	try
	{
		div = document.getElementById("downPlayerDiv");
		if(div)
		{
			div.style.display = "block";
		}
		else
		{
			if(!existPopupCss()) loadCss(baseUrl + "css/popup.css");
			div = document.createElement("div");
			div.id = "downPlayerDiv";
			
			div.style.width = divWidth;
			//div.style.height = divHeight;
			 
			div.style.left = (document.body.clientWidth-divWidth)/2+"px";
			div.style.top = (document.body.clientHeight-divHeight-100)/2+"px";
			div.innerHTML = getDownStr(type,version);
			document.body.appendChild(div);
			div.className = "bg";
		}

	}
	catch(e)
	{
		alert("error:"+e.message)
	}
}

//判断popup.css是否已经被引入
function existPopupCss()
{
	var exist = false;
	var arrCss = document.getElementsByTagName("link");
	if(arrCss)
	{
		for (var i=0;i<arrCss.length ;i++ )
		{
			if(arrCss[i].href == baseUrl + "css/popup.css") return true;
		}
	}

	return exist;
}

function getDownStr(type,version)
{
	var str = '';
	var arrTypeName=new Array("","网络播放器","上传控件");
	var arrTypeExe=new Array("","TruePlayer.exe","upload.exe");
	
	str += '<DIV class="rg1"></DIV><DIV class="rg2"></DIV> ';
	str += '<DIV class="t1">提示信息</DIV>';
	str += '<DIV class="bc">';

	str += '<DIV style="line-height:20px;">';
	if(version > 0)
		str += '您的系统当前'+arrTypeName[type]+'版本号小于'+version+'。请安装最新版本。<br>';  
	else
		str += '您的系统当前可能还没有安装本系统必须的'+arrTypeName[type]+'。<br>';

	str += '请点击[安装'+arrTypeName[type]+']按钮，然后选择运行。<font color="#ff6600"><br>注意：<br>1.如果被迅雷等下载软件拦截，请下载它，然后双击下载后的exe文件进行安装。<br>2.安装前请关闭所有浏览器。<br>3.如果不知道如何安装或安装不成功，请查看<a style="color:blue;font-weight:normal;" title="点击查看安装说明" href="/program/downloadPlayerDesc.gsp" target="_top">[安装说明]。</a><br>4.如果已安装'+arrTypeName[type]+',系统仍提示没安装，请点击[我已安装'+arrTypeName[type]+']。</font>';
	str += '<div style="text-align:center;padding-top:10px;"><input type="buttom" class="buttons" onclick="document.location.href=baseUrl + \'/downdir/'+arrTypeExe[type]+'\';" style="cursor:pointer;width:90px;" value="安装'+arrTypeName[type]+'">&nbsp;';
	str += '<input type="buttom" class="buttons" onclick="setPlayerSetuped('+type+');" style="cursor:pointer;width:120px;" value="我已安装'+arrTypeName[type]+'">&nbsp;';
	str += '<input type="buttom" class="buttons" onclick="document.getElementById(\'downPlayerDiv\').style.display=\'none\';" style="cursor:pointer;width:40px;" value="关闭"></div>';	
	str += '</DIV> ';
				
	str += '</DIV> ';
	str += '<DIV class="rg3"></DIV>';
	str += '<DIV class="rg4"></DIV> ';
	
	return str;
}

function loadCss(file){
    var cssTag = document.getElementById('loadCss');
    var head = document.getElementsByTagName('head').item(0);
    if(cssTag) head.removeChild(cssTag);
    css = document.createElement('link');
    css.href = file;
    css.rel = 'stylesheet';
    css.type = 'text/css';
    css.id = 'loadCss';
    head.appendChild(css);
}


function getFileExtName(filePath)
{
	if(filePath == null || filePath == "") return "";

	var sExtName="";
	var nTPos=filePath.lastIndexOf(".");
	if(nTPos>0) sExtName=filePath.substring(nTPos+1);

	return sExtName;
}

function Jtrim(str)
{
			if(str==null || str=="")
				return "";
	        var i = 0;
	        var len = str.length;
	        j = len -1;
	        flagbegin = true;
	        flagend = true;
	        while ( flagbegin == true && i< len)
	        {
	           if ( str.charAt(i) == " " )
	                {
	                  i=i+1;
	                  flagbegin=true;
	                }
	                else
	                {
	                        flagbegin=false;
	                }
	        }
	
	        while  (flagend== true && j>=0)
	        {
	            if (str.charAt(j)==" ")
	                {
	                        j=j-1;
	                        flagend=true;
	                }
	                else
	                {
	                        flagend=false;
	                }
	        }
	
	        if ( i > j ) return ("")
	
	        trimstr = str.substring(i,j+1);
	        return trimstr;
}

//用于播放的frame,是一个隐藏的iframe, http://打头的都不用检测播放器
function OpenPlayUrl(url)
{
	if(url.indexOf("http://") != -1) 
	{
		openWebWin(url);
		return;
	}

	if(!isTruePlayerSetUped)
	{
		LoginDirect('guest','f4c3b130f7cf5dc74ff79c40b');
		if(!isTruePlayerSetUped){
			downloadTruePlayer();
			return;
		}
	}

	var iframeObj = document.getElementById("playFrame");
	if(!iframeObj) iframeObj = createIframe("playFrame");
	iframeObj.src = url;
}

//创建隐藏的iframe
function createIframe(name)
{
	var iframeObj = document.createElement("iframe"); 
	iframeObj.id= name; 
	iframeObj.width = 0; 
	iframeObj.height = 0; 
	iframeObj.frameborder = 0; 
	iframeObj.src=""; 
	document.body.appendChild(iframeObj); 

	return iframeObj;
}


//////////////////////播放器cookie设置开始
function setCookie(c_name,value,expiredays)
{
	var exdate=new Date();
	exdate.setDate(exdate.getDate()+expiredays);
	document.cookie=c_name+"="+escape(value)+((expiredays==null)?"":";expires="+exdate.toGMTString())+";path=/";
}

function getCookie(c_name)
{
	if (document.cookie.length>0)
	{
		c_start=document.cookie.indexOf(c_name + "=");
		if (c_start!=-1)
		{ 
			c_start=c_start + c_name.length+1; 
			c_end=document.cookie.indexOf(";",c_start);
			if (c_end==-1) c_end=document.cookie.length;
			return unescape(document.cookie.substring(c_start,c_end));
		} 
	}
	return ""
}

//用户点击我已安装播放器将安装状态设置到cookie中
function setPlayerSetuped(type)
{
	var arrCookieName=new Array("","playerSetuped","uploadSetuped");
	setCookie(arrCookieName[type],"TRUE",1);
	document.getElementById('downPlayerDiv').style.display='none';
}
//////////////////////播放器cookie设置结束

///////////////////////////////////////////////////////////////////////////////
//播放在线节目
//////////////////////////////////////////////////////////////////////////////
function NetPlay(strProgName,strUrl)
{
	try
	{	
		var host = window.location.host;
		url = Base64.encode(strUrl);
		url = "bfp://"+host+"/pfg=p&enc=b&url="+url;
		OpenPlayUrl(url);		
	}
	catch(e)
	{
		//alert(e.description );
		document.location.href="../downdir/TruePlayer.exe";
	}	
	//return true;
}


function playHTM5(playUrl)
{
	var video = document.getElementById("video1");
	video.src = playUrl;
	video.play();
}

function checkhHtml5() {
	if (typeof(Worker) !== "undefined") {
		//alert("支持HTML5");
		return true;
	}
	else {
		//alert("不支持HTML5");
		return false;
	}
}
