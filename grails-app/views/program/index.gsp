<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>公告列表</title>
	<script language="JavaScript">
	function warning()
	{
		var stat=${play};
		if (stat==0)
		{
			alert("没有登录，不能点播");
		}
	}
	</script>
    </head>
    <body>
    通知公告
<div class="list" >
 <table>
 <thead>
<tr>
 <td style="width:100px;" class="sortable">标题</td>
  <td style="width:100px;" class="sortable">发布人</td>                
 </tr>
</thead>
 <tbody>
 <g:each in="${newsList}" status="i" var="news">
 <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
<td>
<g:if test="${play == 0}">
<a href="#" onClick="warning()" >${fieldValue(bean:news, field:'title')}</a>
</g:if>
<g:else>
<g:link action="showNews" target="blank" id="${news.id}" params="${[sort:params.sort,order:params.order,offset:params.offset]}" >${fieldValue(bean:news, field:'title')}</g:link>
</g:else>
</td>
<td>${fieldValue(bean:news, field:'publisher.nickname')}</td>
  </tr>
   </g:each>
  </tbody>
</table>
</div>
<br>
<br>

  最新发布

    <body>
<div class="list" >
 <table>
 <thead>
<tr>
 <td style="width:100px;" class="sortable">节目名称</td>
  <td style="width:100px;" class="sortable">发布时间</td>                
 </tr>
</thead>
 <tbody>
 <g:each in="${newProgramList}" status="i" var="newProgram">
 <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
<td>
<g:if test="${play == 0}">
<a href="#" onClick="warning()" >${fieldValue(bean:newProgram, field:'title')}</a>
</g:if>
<g:else>
<g:link action="showProgram" target="blank" id="${newProgram.id}" >${fieldValue(bean:newProgram, field:'name')}</g:link>
</g:else>
</td>
<td>${fieldValue(bean:newProgram, field:'dateCreated')}</td>
  </tr>
   </g:each>
  </tbody>
</table>
</div>
<br>
<br>

推荐节目

    <body>
<div class="list" >
 <table>
 <thead>
<tr>
 <td style="width:100px;" class="sortable">节目名称</td>
  <td style="width:100px;" class="sortable">发布时间</td>                
 </tr>
</thead>
 <tbody>
 <g:each in="${remProgramList}" status="i" var="remProgram">
 <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
<td>
<g:if test="${play == 0}">
<a href="#" onClick="warning()" >${fieldValue(bean:remProgram, field:'title')}</a>
</g:if>
<g:else>
<g:link action="showProgram"  target="blank" id="${remProgram.id}" >${fieldValue(bean:remProgram, field:'name')}</g:link>
</g:else>
</td>
<td>${fieldValue(bean:remProgram, field:'dateCreated')}</td>
  </tr>
   </g:each>
  </tbody>
</table>
</div>

<br>
<br>

点击排行

    <body>
<div class="list" >
 <table>
 <thead>
<tr>
 <td style="width:100px;" class="sortable">节目名称</td>
  <td style="width:100px;" class="sortable">发布时间</td>                
 </tr>
</thead>
 <tbody>
 <g:each in="${freProgramList}" status="i" var="freProgram">
 <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
<td>
<g:if test="${play == 0}">
<a href="#" onClick="warning()" >${fieldValue(bean:freProgram, field:'title')}</a>
</g:if>
<g:else>
<g:link action="showProgram"  target="blank" id="${freProgram.id}" >${fieldValue(bean:freProgram, field:'name')}</g:link>
</g:else>
</td>
<td>${fieldValue(bean:freProgram, field:'dateCreated')}</td>
  </tr>
   </g:each>
  </tbody>
</table>
</div>

${session.consumer}

</body>