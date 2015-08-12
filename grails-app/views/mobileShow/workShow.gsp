<%@ page import="nts.utils.CTools; nts.program.domain.Serial" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>work play</title>
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0" />
<link rel="stylesheet" media="all" href="${resource(dir: '/mobileShow/css', file: 'lpstyle.css')}" type="text/css">
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'mobile/js/jquery-1.9.1.min.js')}"></script>

<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'showProgram.js')}"></script>
<script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'jwplayer/jwplayer.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>

<script>
	fromPlayWeb = 4;
	var gProgramId = 0;
	var isAnony = ${(session.consumer == null || session.consumer.name == 'anonymity')?"true":"false"};//是否匿名用户
	
	function createUserWork(id) 
	{
		if(isAnony)
		{
			alert("匿名用户不能创建活动，请先登录！");
			return;
		}
		window.open(baseUrl + "userWork/create?id=" + id,"_blank");
	}
	
	function init()
	{
		<g:if test="${userWork.urlType == Serial.URL_TYPE_VIDEO}">
			phonePlay();
		</g:if>
	}
	function constraintImg() {
		if(!$("#photo")) return;
		if ($("#photo").width()>700) {
			$("#photo").addClass("js925img1");
		}
		else {
			$("#photo").addClass("js925img");
		}
	}

	function voteAjax(userWorkId, consumerId)
	{

		if(isAnony)
		{
			alert("匿名用户不能投票，请先登录！");
			//return;
		}
		if (consumerId == ${session.consumer.id})
		{
			//alert("用户不能给自己的作品投票！");
			//return;
		}
		var request_url = baseUrl + "userWork/voteAjax"; // 需要获取内容的url
		var request_pars = "userWorkId=" + userWorkId;//请求参数

		

		$.ajax({
			type : 'post',
		  url: request_url,
		  data: {
			userWorkId: userWorkId
		  },
		  error:function(  ) {
			reportError();
		  },
		  success: function( data ) {
			done();
		  }
		});
	}

	

	function done(){
		var voteState = document.getElementById("voteState").value;
		if (voteState == 1) alert("你已对该作品投过票了！");
		else if (voteState == "0") {
			alert("投票成功");
			document.getElementById("voteState").value = "1";
		}
	}

	function reportError(request)
	{
		alert("投票失败!") ;
	}



<g:if test="${userWork.urlType == Serial.URL_TYPE_VIDEO}">
	<g:workPlayJson userWork="${userWork}"  />
</g:if>
	
</script>
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
			<li><a href="${createLink(controller: 'mobileShow', action: 'categoryView' , params: [directoryId: rmsCategory.id])}">${rmsCategory.name}</a></li>
		</g:each>
      </ul>
    </nav>
  </header>
  <div class="content">
    <article>
      <h1>${fieldValue(bean:userWork, field:'name')}</h1>
     <div id="player" style="text-align:center;">
	 <g:if test="${userWork.urlType == Serial.URL_TYPE_IMAGE}">
		<img src="${workImgLink(userWork:userWork,isAbbrImg:false)}" id="photo"  />
	 </g:if>
	 </div>
	 <div><img src="images/bt02.gif" onclick="voteAjax(${userWork.id}, ${userWork.consumer.id});" /></div>
	 <div class="lpms"><span>创建者：${userWork.consumer.name}</span>  <span>投票数：${userWork.voteNum}</span><br> <span>创建时间：<g:formatDate format="yyyy-MM-dd" date="${userWork?.dateCreated}"/></span></span><span class="nv_span"></div>
      <div class="select_tab">
        <ul>
          <li id="select_a" >作品描述</li>
        </ul>
        
        

        <div id="nva" class="vertical comments">
          <p style=" line-height:28px; padding-top:10px; display:block;">${CTools.htmlToBlank(userWork.description)}&nbsp;</p>
        </div>
      </div>
    </article>
  </div>

  
  

  <footer>
    <p><g:message code="application.copyright" default="Copyright @ 2007-2013 ALL Rights Reserved By 北京邦丰信息技术有限公司"/></p>
  </footer>
</div>

<script type="text/javascript">
   window.addEventListener("load",function() {
	init();
	  // Set a timeout...
	  setTimeout(function(){
	    // Hide the address bar!
	    window.scrollTo(1, 2);
	  }, 1);
	});
   $('.search-box,.menu,#nvb' ).hide();  
   $('.select_tab #select_a' ).addClass('active'); 
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
   $('#select_a').click(function(){	   
   		$(this).toggleClass('active');      			
   		$('#nva').toggle();  		
   		$('#nvb').hide(); 
   		//$('#select_b:first-child').removeClass('active'); 
		 $('.select_tab #select_b' ).removeClass('active');		
   }); 
   $('#select_b').click(function(){	   
   		$(this).toggleClass('active');      			
   		$('#nvb').toggle();  		
   		$('#nva').hide(); 
   		//$('#select_a:first-child').removeClass('active'); 
		$('.select_tab #select_a' ).removeClass('active');			
   });      
   $('.content').click(function(){
   		$('.search-box,.menu' ).hide();   
   		$('.options #f-menu:last-child, .options #f-serch:first-child').removeClass('active');
   });   
</script>
</body>
</html>
