<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="layout" content="communityMain" />
<title>学习社区</title>
<script type="text/javascript">
	function doShowProgram(id)
	{
		top.location.href=baseUrl + "program/showProgram?id="+id;
	}

	//弹出发送消息
	function sendMessage(receiveId)
	{
		document.getElementById('qfbxtsun').style.display='block' ;
		document.getElementById('qfbxtbsun').style.display='block' ;
		document.getElementById('receiveId').value = receiveId ;
	}

	//提交消息
	function toSendMessage()
	{
		//清空所有提示
		$('labTitle').innerHTML = '标题' ;
		$('labDescription').innerHTML = '内容' ;

		if($("msgTitle").value.trim().length == 0) {
			$("labTitle").innerHTML += '&nbsp;&nbsp;<font style="color:red;">标题不能为空值</font>' ;
			$("msgTitle").focus();
			$("msgTitle").select();
			return ;
		}
		else if($("msgTitle").value == "标题必填，不得多于50个字。") {
			$("labTitle").innerHTML += '&nbsp;&nbsp;<font style="color:red;">你还未输入标题</font>' ;
			$("msgTitle").focus();
			$("msgTitle").select();
			return false;
		}
		else if($('msgContent').value.trim().length == 0) {
			$('labDescription').innerHTML += '&nbsp;&nbsp;<font style="color:red;">内容不能为空值</font>' ;
			return ;
		}
		else if($("msgTitle").value.trim().length > 50) {
			var manyLength = (parseInt($(msgTitle).value.trim().length)-50);
			$('labTitle').innerHTML += '&nbsp;&nbsp;<font style="color:red;">标题超出了'+manyLength+'个字符</font>' ;
			$('msgTitle').select();
			return ;
		}

		var request_url = baseUrl + "message/sendMessage"; // 需要获取内容的url
		var receiveId = document.getElementById('receiveId').value;
		var title = document.getElementById('msgTitle').value ;
		var content = document.getElementById('msgContent').value ;
		var request_pars = "receiveId="+receiveId+"&name="+title+"&description="+content//请求参数

		var myAjax = new Ajax.Request(request_url,{ 
			method : 'post', //HTTP请求的方法,get or post
			parameters : request_pars, //请求参数
			onFailure : reportError, //失败的时候调用 reportError 函数
			onLoading : loading, //正在获得内容的时候
			onComplete : returnMessage //内容获取完毕的时候
		});
	}
	
	function returnMessage(obj)
	{
		alert(obj.responseText) ;
		document.getElementById('qfbxtsun').style.display='none' ;
		document.getElementById('qfbxtbsun').style.display='none' ;
	}
	
	function loading(){}

	function done(){}

	function reportError(request)
	{
		alert(request) ;
	}

	//添加下载量
	function addDownloadCount(id)
	{
		var request_url = baseUrl + "sharing/addDownLoadCount";
		var request_pars = "id="+id;

		var myAjax = new Ajax.Request(request_url,{ 
			method : 'post', //HTTP请求的方法,get or post
			parameters : request_pars, //请求参数
			onFailure : reportError, //失败的时候调用 reportError 函数
			onLoading : loading, //正在获得内容的时候
			onComplete : done //内容获取完毕的时候
		});
	}
</script>
</head>

<body>

<div class="l w230">
 <div class="qs">
  <p class="lh22 cl">版主：${createConsumer?.name}<br />成员：${communityInstance?.members.size()}<br />浏览量：${communityInstance?.visit}<br />简介：<font title="${communityInstance?.description}">${CTools.cutString(fieldValue(bean:communityInstance, field:'description'),59)}</font></p>
 </div>
 <div class="qcy">
  <h2 class="qh2">
   <a href="${createLink(controller:'community',action:'listMember')}">社区成员</a>
  </h2>
  <div class="qcycon">
   <ul>
   <li><img src="${resource(dir: 'images', file: createConsumer?.photo==null||createConsumer?.photo==''?'default.gif':createConsumer?.photo?.encodeAsHTML())}"  class="qimg" /><p>版主：${createConsumer?.name}<span class="qh2"><a href="javascript:void(0)" onclick="sendMessage('${createConsumer.id}')" class="g3f">发送消息</a></span></p></li>
   <g:each status="i" in="${communityInstance?.members}" var="member">
   <g:if test="${i<=3}">
    <li><img src="${resource(dir: 'images', file: member?.photo==null||member?.photo==''?'default.gif':member?.photo?.encodeAsHTML())}" class="qimg" /><p>成员：${member?.name}<span class="qh2"><a href="javascript:void(0)" onclick="sendMessage('${member.id}')" class="g3f">发送消息</a></span></p></li>
   </g:if>
   </g:each>
   </ul>
  </div>
 </div>
 </div>
 <div class="l w550 pl5">
  <!--tab标签切换js开始-->
  <script type="text/javascript">
/*
十三妖
qq:181907667
msn:wl181907667@hotmail.com
邮箱:thirdteendevil@163.com
*/
function scrollDoor(){
}
scrollDoor.prototype = {
 sd : function(menus,divs,openClass,closeClass){
  var _this = this;
  if(menus.length != divs.length)
  {
   alert("菜单层数量和内容层数量不一样!");
   return false;
  }   
  for(var i = 0 ; i < menus.length ; i++)
  {
   _this.$(menus[i]).value = i;   
   _this.$(menus[i]).onmouseover = function(){
    
    for(var j = 0 ; j < menus.length ; j++)
    {     
     _this.$(menus[j]).className = closeClass;
     _this.$(divs[j]).style.display = "none";
    }
    _this.$(menus[this.value]).className = openClass;
    _this.$(divs[this.value]).style.display = "block";   
   }
  }
  },
 $ : function(oid){
  if(typeof(oid) == "string")
  return document.getElementById(oid);
  return oid;
 }
}
window.onload = function(){
 init();
 var SDmodel = new scrollDoor();
 SDmodel.sd(["m01","m02","m03","m04"],["c01","c02","c03","c04"],"sd01","sd02");

 var liType = "${liType}";
 liType = liType.substr(2,1);
 document.getElementById("c01").style.display = "none";
 document.getElementById("c0"+liType).style.display = "block";
}
</script>
  <!--tab标签切换js结束-->
  <div class="scrolldoorFrame">
   <ul class="scrollUl">
    <li class='${liType=="m01"?"sd01":"sd02"}' id="m01">最新动态</li>
    <li class='${liType=="m02"?"sd01":"sd02"}' id="m02">最新公告</li>
    <li class='${liType=="m03"?"sd01":"sd02"}' id="m03">推荐的资源</li>
    <li class='${liType=="m04"?"sd01":"sd02"}' id="m04">共享</li>
   </ul>
   <div class="cont">
    <div id="c01">
     <!--最新动态-->
     <ul>
	 <g:each in="${logsPublicList}" var="logsPublic">
		${CTools.htmlToBlank(logsPublic?.description)}
	 </g:each>
     </ul>
     <!--翻页-->
     <div class="qfy">
      <dl class="mt5">
       <% if(pageCount!=0){ %>
			<dt>共${pageCount}页</dt>
			<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageIndex: 1, liType: 'm01'])}">首页</a></dt>
			<% if(pageIndex!=1){ %>
			<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageIndex: pageIndex==1?1:pageIndex-1, liType: 'm01'])}">上一页</a></dt>
			<% } %>
			<%
			for(int i=1; i<= pageCount; i++){
			%>                
			  <% if(pageIndex==i&&pageIndex+2>=i&&pageIndex-2<=i){ %>
				<dt class="qdqy"}>${i}</dt>
			  <% } %>
			  <% if(pageIndex!=i&&pageIndex+2>=i&&pageIndex-2<=i||(pageIndex<=2&&(i==4||i==5))||(pageIndex>=pageCount-2&&(i==pageCount-3||i==pageCount-4))){ %>
				<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageIndex: i, liType: 'm01'])}">${i}</a></dt>
			  <% } %>
			<%}%>
			<% if(pageIndex!=pageCount){ %>
			<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageIndex: pageIndex==pageCount?pageCount:pageIndex+1, liType: 'm01'])}">下一页</a></dt>
			<% } %>
			<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageIndex: pageCount, liType: 'm01'])}">末页</a></dt>
	  <% } %>
	  <% if(pageCount==0){ %>
		抱歉，公告栏内没有公告。
	  <% } %>
      </dl>
     </div>
    </div>
    <div id="c02" class="dn">
     <!--最新公告-->
     <ul>
	 <g:each in="${noticeList}" status="i" var="notice">
      <li><div class="l"><img src="${resource(dir: 'images/skin', file: 'qsq.gif')}" class="qimg" width="42" height="42" /></div><div class="qc01r g9"><a href="${createLink(controller: 'notice', action: 'show', params: [id: notice.id])}" title="${notice?.name}" class="g3f">${CTools.cutString(fieldValue(bean:notice, field:'name'),20)}</a><br />创建者：${createConsumer?.name}&nbsp;&nbsp;&nbsp;&nbsp;创建时间：<g:formatDate format="yyyy-MM-dd" date="${notice.dateCreated}"/><p title="${notice?.description}">${CTools.cutString(fieldValue(bean:notice, field:'description'),112)}</p></div></li>
	 </g:each>
     </ul>
     <!--翻页-->
     <div class="qfy">
      <dl class="mt5">
       <% if(pageNoticeCount!=0){ %>
		<dt>共${pageNoticeCount}页</dt>
		<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageNoticeIndex: 1, liType: 'm02'])}">首页</a></dt>
		<% if(pageNoticeIndex!=1){ %>
		<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageNoticeIndex: pageNoticeIndex==1?1:pageNoticeIndex-1, liType: 'm02'])}">上一页</a></dt>
		<% } %>
		<%
		for(int i=1; i<= pageNoticeCount; i++){
		%>                
		  <% if(pageNoticeIndex==i&&pageNoticeIndex+2>=i&&pageNoticeIndex-2<=i){ %>
			<dt class="qdqy"}>${i}</dt>
		  <% } %>
		  <% if(pageNoticeIndex!=i&&pageNoticeIndex+2>=i&&pageNoticeIndex-2<=i||(pageNoticeIndex<=2&&(i==4||i==5))||(pageNoticeIndex>=pageNoticeCount-2&&(i==pageNoticeCount-3||i==pageNoticeCount-4))){ %>
			<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageNoticeIndex: i, liType: 'm02'])}">${i}</a></dt>
		  <% } %>
		<%}%>
		<% if(pageNoticeIndex!=pageNoticeCount){ %>
		<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageNoticeIndex: pageNoticeIndex==pageNoticeCount?pageNoticeCount:pageNoticeIndex+1, liType: 'm02'])}">下一页</a></dt>
		<% } %>
		<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageNoticeIndex: pageNoticeCount, liType: 'm02'])}">末页</a></dt>
	  <% } %>
	  <% if(pageNoticeCount==0){ %>
		抱歉，公告栏内还没有公告
	  <% } %>
      </dl>
     </div>
    </div>
    <div id="c03" class="dn">
     <!--推荐的资源-->
     <ul>
	 <g:each in="${programList}" status="i" var="program">
      <li><a href="javascript: doShowProgram(${program.id})" class="g6f"><b title="${program?.name}">${CTools.cutString(fieldValue(bean:program, field:'name'),20)}</b></a>&nbsp;&nbsp;&nbsp;<a href="javascript: doShowProgram(${program.id})" class="gblue qck qh2">查看</a><p class="g6 mt5 lh18">&nbsp;&nbsp;&nbsp;创建者：${program.consumer.name}&nbsp;&nbsp;&nbsp;创建时间：<span class="g9"><g:formatDate format="yyyy-MM-dd" date="${program.dateCreated}"/></span></p></li>      
	 </g:each>
     </ul>
     <!--翻页-->
     <div class="qfy">
      <dl class="mt5">
       <% if(pageTuiCount!=0){ %>
		<dt>共${pageTuiCount}页</dt>
		<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageTuiIndex: 1, liType: 'm03'])}">首页</a></dt>
		<% if(pageTuiIndex!=1){ %>
		<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageTuiIndex: pageTuiIndex==1?1:pageTuiIndex-1, liType: 'm03'])}">上一页</a></dt>
		<% } %>
		<%
		for(int i=1; i<= pageTuiCount; i++){
		%>                
		  <% if(pageTuiIndex==i&&pageTuiIndex+2>=i&&pageTuiIndex-2<=i){ %>
			<dt class="qdqy"}>${i}</dt>
		  <% } %>
		  <% if(pageTuiIndex!=i&&pageTuiIndex+2>=i&&pageTuiIndex-2<=i||(pageTuiIndex<=2&&(i==4||i==5))||(pageTuiIndex>=pageTuiCount-2&&(i==pageTuiCount-3||i==pageTuiCount-4))){ %>
			<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageTuiIndex: i, liType: 'm03'])}">${i}</a></dt>
		  <% } %>
		<%}%>
		<% if(pageTuiIndex!=pageTuiCount){ %>
		<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageTuiIndex: pageTuiIndex==pageTuiCount?pageTuiCount:pageTuiIndex+1, liType: 'm03'])}">下一页</a></dt>
		<% } %>
		<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageTuiIndex: pageTuiCount, liType: 'm03'])}">末页</a></dt>
	  <% } %>
	  <% if(pageTuiCount==0){ %>
		抱歉，社区成员还没有推荐过资源。
	  <% } %>
      </dl>
     </div>
    </div>
    <div id="c04" class="dn">
     <!--共享-->
     <ul>
	 <g:each in="${sharingList}" status="i" var="sharing">
      <li><a href="${createLink(controller: 'sharing', action: 'show', params:[id: sharing.id])}" class="g6f"><b title="${sharing?.name}">${CTools.cutString(fieldValue(bean:sharing, field:'name'),18)}</b></a><br/>共享者：${sharing.shareConsumer.name}&nbsp;&nbsp;&nbsp;共享时间：<span class="g9"><g:formatDate format="yyyy-MM-dd" date="${sharing.dateCreated}"/></span>&nbsp;&nbsp;&nbsp;<a onclick="javascript:addDownloadCount(${sharing.id});" href="${'bfp://192.168.1.125:8080/pfg=d&enc=b&url='+('BMSP://ADDR=192.168.1.125:1680;UID='+session.consumer?.name+';PWD='+session.consumer?.password+';FILE='+sharing.url+';PN='+CTools.readFileName(sharing.url,true)+';EXT='+CTools.readExtensionName(sharing.url)+';PFG=2;').getBytes('GBK').encodeAsBase64().toString()}" class="gblue qdown qh2">下载</a></li>
	 </g:each>
     </ul>
     <!--翻页-->
     <div class="qfy">
      <dl class="mt5">
       <% if(pageSharingCount!=0){ %>
		<dt>共${pageSharingCount}页</dt>
		<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageSharingIndex: 1, liType: 'm04'])}">首页</a></dt>
		<% if(pageSharingIndex!=1){ %>
		<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageSharingIndex: pageSharingIndex==1?1:pageSharingIndex-1, liType: 'm04'])}">上一页</a></dt>
		<% } %>
		<%
		for(int i=1; i<= pageSharingCount; i++){
		%>                
		  <% if(pageSharingIndex==i&&pageSharingIndex+2>=i&&pageSharingIndex-2<=i){ %>
			<dt class="qdqy"}>${i}</dt>
		  <% } %>
		  <% if(pageSharingIndex!=i&&pageSharingIndex+2>=i&&pageSharingIndex-2<=i||(pageSharingIndex<=2&&(i==4||i==5))||(pageSharingIndex>=pageSharingCount-2&&(i==pageSharingCount-3||i==pageSharingCount-4))){ %>
			<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageSharingIndex: i, liType: 'm04'])}">${i}</a></dt>
		  <% } %>
		<%}%>
		<% if(pageSharingIndex!=pageSharingCount){ %>
		<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageSharingIndex: pageSharingIndex==pageSharingCount?pageSharingCount:pageSharingIndex+1, liType: 'm04'])}">下一页</a></dt>
		<% } %>
		<dt><a href="${createLink(controller: 'community', action: 'communityLeft', params: [pageSharingIndex: pageSharingCount, liType: 'm04'])}">末页</a></dt>
	  <% } %>
	  <% if(pageSharingCount==0){ %>
		抱歉，社区成员还没有上传过共享。
	  <% } %>
      </dl>
     </div>
    </div>
   </div>
  </div>
 </div>

<!--发送消息-->
<form id="msgForm" name="msgForm" method="post">
	<div id="qfbxtsun" class="qfbxt">
		<div class="qhdtit">
			<a href = "javascript:void(0)" onclick = "document.getElementById('qfbxtsun').style.display='none';document.getElementById('qfbxtbsun').style.display='none'" class="qhdclose"><img src="${resource(dir: 'images/skin', file: 'close.gif')}" /></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;发送消息
		</div>
		<div class="h24 cl"></div>
		<div class="qtd">
			<h2 id="labTitle">标题</h2>
			<div class="qtdcon"><input name="name" id="msgTitle" type="text" class="qtdin" value="标题必填，不得多于50个字。" onfocus="javascript:nameFocus('msgTitle');" onblur="javascript:nameBlur('msgTitle');"/></div>
		</div>
		<div class="h24 cl"></div>
		<div class="qtd">
			<h2 id="labDescription">内容</h2>
			<div class="qtdcon"><textarea name="description" id="msgContent" cols="" rows="5" class="qtdte"></textarea></div>
		</div>
		<div class="h14 cl"></div>
		<div class="qtdb">
			<div class="qtdbr"><br/>
				<input name="" type="button" value=" 提 交 " class="qtdbbut" onclick="toSendMessage()"/>&nbsp;&nbsp;&nbsp;&nbsp;
				<input name="" type="button" value=" 取 消 "class="qtdbbut" onclick="document.getElementById('qfbxtsun').style.display='none';document.getElementById('qfbxtbsun').style.display='none'"/>
			</div>
		</div>
	</div>
	<div id="qfbxtbsun" class="black_overlay"></div>
	<input type="hidden" name="receiveId" id="receiveId">
</form>

</body>
</html>
