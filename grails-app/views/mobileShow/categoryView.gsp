<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>活动</title>
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0" />
<link rel="stylesheet" media="all" href="${resource(dir: '/mobileShow/css', file: 'lpstyle.css')}" type="text/css">
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'mobile/js/jquery-1.9.1.min.js')}"></script>
</head>

<body>
<div class="wrap">
  <header>
    <div class="options">
      <ul>
        <li id="f-menu" class="f_menu">活动分类<span></span></li>
        <li id="f-serch" class="f_serch" style="float:right"><span>搜索</span></li>
      </ul>
    </div>
    <div class="clear"></div>
    <div class="search-box">
		<form method="POST" action="/mobileShow/categoryView">
			<input type="hidden" name="directoryId" value="${params.directoryId}">
			<input type="text" name="keyword" placeholder="输入搜索内容……" />
			<input type="submit" value="Go" />
		</form>
      <div class="clear"></div>
    </div>
    <nav class="vertical menu">
      <ul>
		<g:each in="${rmsCategoryList}" status="i" var="rmsCategory">
			<li><a href="${createLink(controller: 'mobileShow',  action: 'categoryView', params: [directoryId: rmsCategory.id])}">${rmsCategory.name}</a></li>
		</g:each>
        
      </ul>
    </nav>
  </header>
  <div class="content">

    <g:each in="${userActivityList}" status="i" var="userActivity">
    <article class="underline">
      <div class="post-preview"> <a href="${createLink(controller: 'mobileShow',  action: 'show', params: [id: userActivity.id])}"><img src="${resource(dir: 'userActivityImg', file: userActivity.photo == '' || userActivity.photo == null ? 'default.jpg': userActivity.photo)}"/></a> </div>
      <div class="play-preview"> <a href="${createLink(controller: 'mobileShow',  action: 'show', params: [id: userActivity.id])}"><img src="${resource(dir: 'mobileShow/images', file: '33.png')}" alt="play"/></a> </div>
      <div class="post-content">
        <h2><a href="${createLink(controller: 'mobileShow',  action: 'show', params: [id: userActivity.id])}">${CTools.cutString(fieldValue(bean:userActivity, field:'name'),14)}</a></h2>
        <div class="lpdata"><span>创建者：${userActivity.consumer.name}</span></div>
        <div class="lptime"><span>开始时间：${userActivity.startTime} <br>结束时间：${userActivity.endTime}</span> </div>
      </div>
      <div class="clear"></div>
    </article>
    </g:each>

	<div class="page">
	<g:if test="${CTools.nullToZero(params.offset) > 0 && total > 0}">
		<a class="thoughtbot" href="${createLink(controller: 'mobileShow',  action: 'categoryView', params: [args: args, offset: (CTools.nullToZero(params.offset) - CTools.nullToZero(params.max))])}">上一页</a>
	</g:if>
	<g:if test="${(CTools.nullToZero(params.offset)+ CTools.nullToZero(params.max)) < total && userActivityList.size() >= CTools.nullToZero(params.max)}">
		<a class="thoughtbot" href="${createLink(controller: 'mobileShow',  action: 'categoryView', params: [args: args, offset: (CTools.nullToZero(params.offset) + CTools.nullToZero(params.max))])}">下一页</a>
	</g:if>
	</div>
  </div>
  <footer>
    <p><g:message code="application.copyright" default="Copyright @ 2007-2013 ALL Rights Reserved By 北京邦丰信息技术有限公司"/></p>
  </footer>
</div>

<script type="text/javascript">
   window.addEventListener("load",function() {
	  // Set a timeout...
	  setTimeout(function(){
	    // Hide the address bar!
	    window.scrollTo(1, 2);
	  }, 1);
	});
   $('.search-box,.menu' ).hide();   
   $('#f-serch').click(function(){
   		$(this).toggleClass('active');      			
   		$('.search-box').toggle();  		
   		$('.menu').hide(); 
   		$('.options #f-serch:first-child').removeClass('active'); 		
   });
   $('#f-menu').click(function(){
	   
   		$(this).toggleClass('active');      			
   		$('.menu').toggle();  		
   		$('.search-box').hide(); 
   		$('.options #f-menu:first-child').removeClass('active'); 		
   });
   $('.content').click(function(){
   		$('.search-box,.menu' ).hide();   
   		$('.options #f-menu:last-child, .options #f-serch:first-child').removeClass('active');
   });   
</script>
</body>
</html>
