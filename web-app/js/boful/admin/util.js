function __DOMAIN(){
}
var DOMAIN=new __DOMAIN();
DOMAIN.img="http://img.xiaonei.com/";
function getEl(el){
return document.all?document.all[el]:document.getElementById(el);
}
function setElementStyle(id,_3){
getEl(id).className=_3;
}
function check(id,_5,_6){
if(getEl(id).value==""){
alert(_5+"\u4e0d\u80fd\u4e3a\u7a7a");
getEl(id).select();
return false;
}
if(getEl(id).value==_5){
alert(_6);
getEl(id).select();
return false;
}
return true;
}
function hideLayer(_7){
if(_7!=""){
if(document.getElementById){
document.getElementById(_7).style.display="none";
}else{
if(document.all){
document.all[_7].style.display="none";
}else{
if(document.layers){
eval("document."+_7+".display = 'none'");
}
}
}
}
}
function showLayer(_8){
if(_8!=""){
if(document.getElementById){
document.getElementById(_8).style.display="block";
}else{
if(document.all){
document.all[_8].style.display="block";
}else{
if(document.layers){
eval("document."+_8+".display = 'block'");
}
}
}
}
}
function display(id,_a){
var el=document.all?document.all[id]:document.getElementById(id);
if(el){
el.style.display=_a?"":"none";
}
}
function add_comsch(_c){
var i=++getEl("max_com").value;
if(i<6){
if(_c=="com"){
getEl("comName"+i).value="";
getEl("comTitle"+i).value="";
getEl("comStarTime"+i).value="";
getEl("comEndTime"+i).value="";
display("comdiv"+i,true);
}else{
getEl("schName"+i).value="";
display("schdiv"+i,true);
}
}
}
function onReport(_e,_f){
var win;
var bl=confirm("\u672c\u8d34\u542b\u6709\u8fdd\u89c4\u5185\u5bb9\uff0c\u5c06\u5411\u7ad9\u957f\u4e3e\u62a5\u3002\u7ee7\u7eed\uff1f");
var _12="/Report.do?postId=";
_12+=_f;
_12+="&threadId=";
_12+=_e;
if(bl){
win=window.open(_12,"editPost","left=100,top=100,width=550,height=350,status=no,toolbar=no,menubar=no,scrollbars,resizable=yes");
win.focus();
}
return false;
}
function LTrim(str){
var _14=new String(" \t\n\r");
var s=new String(str);
if(_14.indexOf(s.charAt(0))!=-1){
var j=0,i=s.length;
while(j<i&&_14.indexOf(s.charAt(j))!=-1){
j++;
}
s=s.substring(j,i);
}
return s;
}
function RTrim(str){
var _18=new String(" \t\n\r");
var s=new String(str);
if(_18.indexOf(s.charAt(s.length-1))!=-1){
var i=s.length-1;
while(i>=0&&_18.indexOf(s.charAt(i))!=-1){
i--;
}
s=s.substring(0,i+1);
}
return s;
}
function Trim(str){
return RTrim(LTrim(str));
}
function checkISBN(_1c){
return !/(?=.{13}$)\d{1,5}([-])\d{1,7}\1\d{1,6}\1(\d|X|x)/.test(_1c);
}
function checkNum(str){
return !/\D/.test(str);
}
function isValidDate(str){
return /^(\d{1,4})(-|\/)(\d{2})\2(\d{2})$/.test(str);
}
function isEmail(_1f){
if(_1f.length==0){
alert("\u8bf7\u586b\u5199\u7535\u5b50\u90ae\u4ef6\u5730\u5740\uff0c\u5426\u5219\u6211\u4eec\u5c06\u65e0\u6cd5\u4e0e\u60a8\u8054\u7cfb\u3002");
return false;
}
var _20=/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
if(!_20.test(_1f)){
alert("\u62b1\u6b49\uff0c\u7535\u5b50\u90ae\u7bb1\u683c\u5f0f\u4e0d\u5bf9\u6216\u8005\u5305\u542b\u4e0d\u5408\u6cd5\u5b57\u7b26");
return false;
}
return true;
}
function findPosX(obj){
var _22=0;
if(obj.offsetParent){
while(obj.offsetParent){
_22+=obj.offsetLeft;
obj=obj.offsetParent;
}
}else{
if(obj.x){
_22+=obj.x;
}
}
return _22;
}
function findPosY(obj){
var _24=0;
if(obj.offsetParent){
while(obj.offsetParent){
_24+=obj.offsetTop;
obj=obj.offsetParent;
}
}else{
if(obj.y){
_24+=obj.y;
}
}
return _24;
}
function mousePosX(e){
var _26=0;
if(!e){
var e=window.event;
}
if(e.pageX){
_26=e.pageX;
}else{
if(e.clientX&&document.body.scrollLeft){
_26=e.clientX+document.body.scrollLeft;
}else{
if(e.clientX&&document.documentElement.scrollLeft){
_26=e.clientX+document.documentElement.scrollLeft;
}else{
if(e.clientX){
_26=e.clientX;
}
}
}
}
return _26;
}
function mousePosY(e){
var _28=0;
if(!e){
var e=window.event;
}
if(e.pageY){
_28=e.pageY;
}else{
if(e.clientY&&document.body.scrollTop){
_28=e.clientY+document.body.scrollTop;
}else{
if(e.clientY&&document.documentElement.scrollTop){
_28=e.clientY+document.documentElement.scrollTop;
}else{
if(e.clientY){
_28=e.clientY;
}
}
}
}
return _28;
}
function debugOut(_29){
if($("debugout")){
$("debugout").style.overflow="auto";
$("debugout").innerHTML=_29+"<br>"+$("debugout").innerHTML;
}
}
function limitLen(str,len,_2c){
if(_2c){
str.replace("/</g","&lt;");
str.replace("/>/g","&gt;");
str.replace("/&/g","&amp;");
str.replace("/#/g","&#35;");
str.replace("/(/g","&#40;");
str.replace("/)/g","&#41;");
str.replace("/\"/g","&#34;");
str.replace("/'/g","&#39;");
}
if(str.length>len){
return false;
}else{
return true;
}
}
function cc(_2d){
var e,r;
if(_2d.srcElement){
e=_2d.srcElement;
r=e.createTextRange();
r.moveStart("character",0);
r.collapse(true);
r.select();
}else{
e=_2d.target;
e.selectionStart=0;
e.selectionEnd=0;
return true;
}
}
function noteme(el){
el.parentNode.nextSibling.className="hey";
}
function dontnoteme(el){
el.parentNode.nextSibling.className="note";
}
var oldload=(window.onload)?window.onload:function(){
};
window.onload=function(){
oldload();
var _31=document.body.id;
str="var regAction; if(typeof("+_31+"_onload) == \"function\") { regAction = "+_31+"_onload} else { regAction = function(){}};";
eval(str);
str="regAction()";
eval(str);
};
window.ow=function(win){
return getEl(win).contentWindow;
};
function GetHTML(_33){
if(typeof (_DEBUG)!="undefined"){
alert("inner GetHTML");
}
if(_33){
return ow(_33).getContent();
}
if(typeof (_DEBUG)!="undefined"){
alert("after getContent");
}
return null;
}
function isEmpty(_34){
if(_34){
return ow(_34).isEmpty();
}
}
function SetHTML(sz,_36){
if(_36){
ow(_36).setHtml(sz);
}
}
function SetFocus(_37){
if(_37){
ow(_37).setFocus();
}
}
function closeInfoWnd(_38){
try{
div=document.getElementById(_38);
if(div){
document.body.removeChild(div);
delete div;
div=null;
}
}
catch(E){
}
}
var IM=new Object();
var web5q=0;
function setPos(_39,_3a,_3b){
alert(1);
alert(_39);
var _3c=findPosX(getParentNode(_39));
var _3d=findPosY(getParentNode(_39));
alert(_3c+":"+_3d);
_3a.style.left=_3c-_3b-80+"px";
_3a.style.top=_3d+20+"px";
}
IM.setPos=function(el,_3f){
var _40=findPosX(el);
var _41=findPosY(el);
_3f.style.left=_40-20+"px";
_3f.style.top=_41+20+"px";
};
function downloadIM(tp){
window.location="http://im.xiaonei.com/setup/XiaoNeiSetup.exe";
closeInfoWnd("ImDownload");
}
IM.getimv=function(){
var _43="";
try{
web5q=web5q||new ActiveXObject("QImWeb.ImWebObj");
_43=web5q.GetImVersion();
}
catch(e){
}
return _43;
};
IM.startIM=function(_44,_45,f){
try{
web5q=web5q||new ActiveXObject("QImWeb.ImWebObj");
if(web5q!=null){
if(f==1){
web5q.Start5QIMNew(_44,_45);
}else{
web5q.Start5QIM(_44,_45);
}
}else{
IM.bigDownload(event,tp);
}
}
catch(e){
}
};
IM.openIM=function(_47,_48,f,_4a,tp){
try{
web5q=web5q||new ActiveXObject("QImWeb.ImWebObj");
if(web5q!=null){
if(f==1){
web5q.Start5QIMPopupNew(_47,_48);
}else{
web5q.Start5QIMPopup(_47,_48);
}
}else{
IM.bigDownload(_4a,tp);
}
}
catch(e){
IM.bigDownload(_4a,tp);
}
};
IM.download=function(){
closeInfoWnd("ImDownload");
var div=document.createElement("div");
div.id="ImDownload";
div.className="popupwrap";
div.style.zIndex="5000";
var _4d="<div class=\"popup\"><h4>\u6d4f\u89c8\u5668\u4e0d\u652f\u6301\u6216\u672a\u5b89\u88c5\u6821\u5185\u901a</h4><p>\u4e0b\u8f7d\u767b\u5f55\u6821\u5185\u901a\u540e\u5c31\u53ef\u4ee5\u804a\u5929\u4e86:)<br /><a href=\"http://im.xiaonei.com\" target=\"_blank\">\u4e86\u89e3\u6821\u5185\u901a</a></p><p class=\"operation\"><input type=\"button\" value=\"\u7acb\u5373\u4e0b\u8f7d\" class=\"subbutton\" onclick=\"javascript:downloadIM(78);\" /><input type=\"button\" value=\"\u5173\u95ed\" class=\"canbutton\" onclick=\"closeInfoWnd('ImDownload');\" /></p></div>";
div.innerHTML=_4d;
document.body.appendChild(div);
IM.setPos(IM.srcEl,div,300);
div.style.display="block";
};
IM.log=function(gid,uid){
var _50=new Date;
var url="logIM.do";
var _52="c=1&gid="+gid+"&hid="+uid+"&t="+_50.getTime();
var _53=new Ajax.Request(url,{method:"get",parameters:_52});
};
IM.srcEl;
IM.myid;
IM.toid;
IM.em;
function writepipe(uin,_55){
if(uin>0){
var s=GetCookie("_pipe");
if(s){
s+=":";
}
SetCookie("_pipe",s+uin+":"+escape(_55),null,"/","xiaonei.com");
}
var _57=GetCookie("_wi");
if("opening"==_57){
}else{
if("running"==_57){
}else{
SetCookie("_wi","opening",null,"/","xiaonei.com");
window.wiw=window.open("http://xiaonei.com/webpager.do?toid="+uin,"_blank","height=600,width=650,resizable=yes,location=yes");
if(window.wiw_checker){
window.clearInterval(window.wiw_checker);
}
window.wiw_checker=window.setInterval(function(){
if(window.wiw.closed){
window.clearInterval(window.wiw_checker);
SetCookie("_wi","",null,"/","xiaonei.com");
}
},1000);
return true;
}
}
try{
if(window.wiw){
window.wiw.focus();
}
}
catch(e){
}
return false;
}
function tnx2(_58,_59,_5a,em,_5c){
if(IM.getimv()==""){
writepipe(_5a,_5c);
}else{
IM.srcEl=_58.srcElement;
IM.myid=_59;
IM.toid=_5a;
IM.em=em;
try{
var _5d=new Ajax.Request("tnx.do",{method:"get",parameters:"v="+IM.getimv(),onComplete:tnxy2,onFailure:tnxn});
}
catch(e){
}
}
}
function tnx(){
try{
var _5e=new Ajax.Request("tnx.do",{method:"get",parameters:"v="+IM.getimv(),onComplete:tnxy,onFailure:tnxn});
}
catch(e){
}
}
function tnxy(r){
var p=r.responseText;
IM.startIM(tnxe,p.substring(0,p.length-1),p.substring(p.length-1,p.length));
}
function tnxy2(r){
var p=r.responseText;
if(document.all){
try{
IM.startIM(IM.em,p.substring(0,p.length-1),p.substring(p.length-1,p.length));
}
catch(e){
IM.download();
}
if(IM.toid>0){
try{
web5q.StartChat(IM.myid,IM.toid);
}
catch(e){
}
}
}else{
alert("\u4f60\u7684\u6d4f\u89c8\u5668\u4e0d\u652f\u6301\u6b64\u529f\u80fd\uff01");
}
IM.log(IM.toid,IM.myid);
}
function tnxn(t){
}
function getErrorCode(str){
var _65=new Date;
var url="pages/jsError.jsp";
var _67="errorStr="+str+"&t="+_65.getTime();
var _68=new Ajax.Request(url,{method:"post",parameters:_67,onComplete:getErrorCode_showResponse,onFailure:getErrorCode_showError});
}
function getErrorCode_showResponse(r){
return true;
}
function getErrorCode_showError(t){
}
function getIEVersonNumber(){
var ua=navigator.userAgent;
var _6c=ua.indexOf("MSIE ");
if(_6c<0){
return 0;
}
return parseFloat(ua.substring(_6c+5,ua.indexOf(";",_6c)));
}
function isIE6(){
return (getIEVersonNumber()==6);
}
function GetCookieVal(_6d){
var _6e=document.cookie.indexOf(";",_6d);
if(_6e==-1){
_6e=document.cookie.length;
}
return unescape(document.cookie.substring(_6d,_6e));
}
function GetCookie(_6f){
var arg=_6f+"=";
var _71=arg.length;
var _72=document.cookie.length;
var i=0;
while(i<_72){
var j=i+_71;
if(document.cookie.substring(i,j)==arg){
return GetCookieVal(j);
}
i=document.cookie.indexOf(" ",i)+1;
if(i==0){
break;
}
}
return null;
}
function SetCookie(_75,_76){
var _77=SetCookie.arguments;
var _78=SetCookie.arguments.length;
var _79=(_78>2)?_77[2]:null;
var _7a=(_78>3)?_77[3]:null;
var _7b=(_78>4)?_77[4]:null;
var _7c=(_78>5)?_77[5]:false;
document.cookie=_75+"="+escape(_76)+((_79==null)?"":("; expires="+_79.toGMTString()))+((_7a==null)?"":("; path="+_7a))+((_7b==null)?"":("; domain="+_7b))+((_7c==true)?"; secure":"");
}
String.prototype.trim=function(){
return this.replace(/^\s*|\s*$/g,"");
};
function formOnfocus(el){
el.onfocus=function(){
el.style.backgroundColor="#fcfcfc";
};
el.onblur=function(){
el.style.backgroundColor="#fff";
};
}
function upload(id){
if(!id){
document.location.href="http://photo.xiaonei.com/choosealbum.do";
}else{
if(document.all&&window.ActiveXObject&&navigator.userAgent.toLowerCase().indexOf("msie")>-1&&navigator.userAgent.toLowerCase().indexOf("opera")==-1){
document.location.href="http://photo.xiaonei.com/tophotox.do?id="+id;
}else{
document.location.href="http://upload.xiaonei.com/addphoto.do?id="+id;
}
}
}

