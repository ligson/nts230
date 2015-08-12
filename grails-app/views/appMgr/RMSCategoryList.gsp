

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>(活动)社区类别列表</title>
		<link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}"  rel="stylesheet" type="text/css">
		<style>


		a:link,a:visited {
			font-weight:normal;
		}

		a:hover {
			color: #FF6600;
			font-weight:normal;
		}

		#catetab .curLink{color:#f60;}
		#progListTab td{line-height:28px;padding-left:2px;}

		</style>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/allselect.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/common.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/dateSelectBox.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/appMgr/updateNode.js')}"></script>
		<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/appMgr/div.js')}"></script>
		<script type="text/javascript">
			function submitSch()
			{
				if(!widthCheck($('#schName').val().trim(),100)) {
					alert('搜索名称不能大于100个字符') ;
					$('#schName').select() ;
					return ;
				}

				document.form1.submit() ;
			}

			function onPageNumPer(max)
			{
				document.form1.max.value = max;
				submitSch();
			}

			function operate(controller,action,operation)
			{
				if(action == "toRecycler")
				{
					if (hasChecked("idList")==false)
					{
						alert("请至少选择一条记录！");
						return false;
					}
					if(confirm("确实要删除该类别吗？") == false) return;
				}				
				if(operation != null) document.form1.operation.value = operation;	
				//if(operation != "public" && operation != "close") document.form1.offset.value = 0;

				document.form1.action=baseUrl+controller+"/"+action;
				document.form1.submit();
			}

			function maxShow(max)
			{	
				document.form1.max.value=max;
				document.form1.offset.value=0;
				document.form1.action=baseUrl + "appMgr/RMSCategoryList";
				document.form1.submit();
			}
		</script>
    </head>
    <body>
    <div class="x_daohang">
        <span class="dangqian">当前位置：</span><a href="${createLink(controller: 'appMgr', action: 'RMSCategoryList')}">活动(社区)类别管理</a>>> 类别列表
    </div>

        <form name="form1" method="post" action="/appMgr/searchRMSCategory">
			<input type="hidden" name="max" value="${params.max}">
			<input type="hidden" name="offset" value="${params.offset}">
			<input type="hidden" name="operation">

			<table width="98%" border="0" cellspacing="0" cellpadding="0" class="biaoge-hui" style="margin-top:10px;margin-bottom:10px;">
				<tr style="height:30px;">
					<td align="center" style="display:none;">类型:</td>
					<td style="display:none;">  
						<select name="type" style="height:25px;">
							<option value="0" selected>公共</option>
							<option value="1">学习圈</option>
							<option value="2">学习社区</option>
						</select>			  
					</td>
					<td align="center">分类级别</td>
					<td>  
						<select name="level">
							<option value="1">一级分类</option>
							<option value="2">二级分类</option>	
						</select>			  
					</td>
					<td align="center">检索名称:</td>
					<td>						
						<input name="schName" id="schName" value="" style="width:200px;">
					</td>
				  
					<td width="10%"><img src="${resource(dir: 'images/skin', file: 'search.gif')}" style="cursor:pointer;" onclick="submitSch();" border="0"></td>
				</tr>
			</table>
		
			<table width="98%" border="0" cellspacing="0" cellpadding="0"   id="progListTab" style=" display: block; margin-left:10px;border: #e2e2e2 1px solid" >
				<tr>
					<td width="4%" align="left" bgcolor="#BDEDFB" class="STYLE5 th">选择</td>
					<td width="6%" align="left" bgcolor="#BDEDFB" class="STYLE5 th">类别名称</td>
					<td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5 th">创建时间</td>
					<td width="6%" align="center" bgcolor="#BDEDFB" class="STYLE5 th">上级类别</td>
					<td width="4%" align="center" bgcolor="#BDEDFB"  class="STYLE5 th">修改</td>
					<td width="4%" align="center" bgcolor="#BDEDFB" class="STYLE5 th">删除</td>
					<td width="4%" align="center" bgcolor="#BDEDFB" class="STYLE5 th">下级类别</td>
				</tr
				<g:each in="${categoryList?}" status="i" var="category">
				<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					<td align="left"><input type="checkbox" name="idList" value="${category.id}" onclick="unCheckAll('selall');" id="idList"/></td>
					<td align="left">${category?.name.encodeAsHTML()}</td>
					<td align="center" class="STYLE5"><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${category?.dateCreated}"/></td>
					<td align="center">${category?.parentName.encodeAsHTML()}</td>
					<td align="center"><a href="${createLink(controller:'appMgr',action:'editRMSCategory',id:category?.id,params:[type:category?.type])}"><img src="${resource(dir: 'images/skin', file: 'modi.gif')}" alt="修改" border="0"></a></td>
					<td align="center"><a href="${createLink(controller:'appMgr',action:'toRecycler',params:[idList:category?.id, operation:1])}" onclick="return confirm('确实要删除该类别吗？');"><img src="${resource(dir: 'images/skin', file: 'delete.gif')}" alt="删除" border="0"></a></td>
					<td align="center"><a href="${createLink(controller: 'appMgr', action: 'lowerList', params: [parentid: category?.id, type: category?.type])}"><img src="${resource(dir: 'images/skin', file: 'page_copy.png')}" alt="查看下级类别" border="0"></a></td>
				</tr>
				</g:each>
			</table>

			<div id="progDeal" style="margin: 10px 0 0 10px;">
				<input  id="selall"  name="selall" onclick="checkAll(this,'idList')" type="checkbox">全选
				<input class="subbtn"  type="button" value="删除" onClick="operate('appMgr','toRecycler','1');" />
				<input class="subbtn"  type="button" value="添加类别" onClick="operate('appMgr','toAdd','0');" />
				<input class="subbtn" style="display:none;"  type="button" value="添加学习圈类别" onClick="operate('appMgr','toAdd','1');" />
				<input class="subbtn" style="display:none;"  type="button" value="添加学习社区类别" onClick="operate('appMgr','toAdd','2');" />
			</div>
		 
			<table width="98%" style="border: 0px;display: block; margin: 10px 0 0 10px; padding: 0 15px;" cellpadding="1" cellspacing="1" bgcolor="#E9E8E7">
				<tr>
					<td width="300" height="16">
						&nbsp;总共：${total} 条记录|每页${params.max}条
						<img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0" onclick="maxShow(10)">
						<img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0" onclick="maxShow(50)">
						<img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0" onclick="maxShow(100)">
						<img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0" onclick="maxShow(200)">
					</td>
					<td align="right" ><div class="paginateButtons"><g:paginate controller="RMSCategory" action="list" total="${total}" params="${params}" /></div></td>
				</tr>
			</table>
		</form>
	<script Language="JavaScript">
		changePageImg(${params.max});
	</script>
    </body>
</html>
