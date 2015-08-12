<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><!-- saved from url=(0041)http://192.168.1.211:1314/nts/index/index -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta name="layout" content="index" />
<title>相册列表页</title>
    %{--<link href="${resource(dir: 'skin/default/pc/css', file: 'uniform.default.css')}" rel="stylesheet"/>--}%
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_common.css')}"/>
<link type="text/css" rel="stylesheet" href="${resource(dir: 'css', file: 'index2.css')}" media="all">

<script type="text/javascript">
	function showPhoto(programId,i)
	{
		var currentStep = $(".currentStep").text();
		document.location.href=baseUrl + "program/photoShow?programId="+programId+"&index="+i+"&currentStep="+currentStep;
	}
</script>
</head>
<body style="padding-top:165px;">
<!----首页正文开始第一部分---->

<div class="main">
<div class="hr4"></div>
 <div class="zyy723" style="background:#FFF;margin-left: -10px;">
  <div class="zyytit" style="text-align: left;">当前位置：<a href="javascript:selectPage(2);">资源浏览</a>>><a href="${createLink(controller: 'program', action: 'showProgram', params: [id: programInstance?.id])}">${programInstance.name}</a>>>图片列表</div>
  <div class="zyycon731">
   <ul style="margin-left: -20px;">
   <g:each in="${serialList}" status="i" var="serial">
    <li><p><a href="javascript:void(0);" onclick="showPhoto(${serial.programId},${i})"><img src="${photoLink(serial:serial,isAbbrImg:true)}" /></a></p><span><A href="#" onclick="showPhoto(${serial.programId},${i});">${serial?.name}</A></span></li>
   </g:each>
   </ul>
  </div>
  <div class="paginateButtons">
	<g:paginate controller="program" action="photoList" total="${total}" params="${params}" maxsteps="5" />
  </div>
 </div>
 <div style="height:10px; clear:both;"></div>
</div>
<!--通用网页底部结--->

</body></html>