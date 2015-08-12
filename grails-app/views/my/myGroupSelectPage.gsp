

<html>
    <head>      
    <link href="${createLinkTo(dir:'css',file:'zhigaiban.css')}"  rel="stylesheet" type="text/css">
	<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/common/allselect.js')}"></script>
	<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/userspace/photo.js')}"></script>
	<script type="text/javascript" src="${createLinkTo(dir:'js',file:'boful/index/time.js')}"></script>

        <title>条件选择页面</title>
	<script  Language="JavaScript">
	function search()
	{
		searchForm.action="myGroupSelectList";
		searchForm.submit();
	}  

	</script>
    </head>
    <body>
    <g:form name="searchForm" method="post" action="" >  
    <input type="hidden"  name="roleList"  value="">
	<div align="center">
	
	<TABLE width="630" border=0 align="center" cellPadding=0 cellSpacing=0>
		<TR>
		  <TD background="${resource(dir: 'images/skin', file: 'text_title_search.gif')}"  height=60>&nbsp;</TD>
		</TR>
	</TABLE>

          <TABLE cellSpacing=1 cellPadding=0 width="630" bgColor=#999999  border=0>
	      	  <TR class=table_tr>
                <TD width="25%" height="29" align=middle>按基本信息查询</TD>
                <TD  align="left" width="30%">&nbsp;  每页显示<input type="text" name="row" value="20" size="2" />行 </TD>
                <TD width="45%" align=middle colspan="3" ></TD>
              </TR>

              <TR class=table_tr>
                <TD width="7%" height="29" align=middle>&nbsp;用户帐号</TD>
                <TD align=left width="15%"> &nbsp; <input type="text" name="searchName" value="" /></TD>
		 <TD width="7%" align="left"  colspan="3" >&nbsp;<input name="searchType" type="radio" value="2" checked="true" />模糊查询   <input name="searchType" type="radio" value="1"  />全字匹配</TD>
                </TR>

		<TR class=table_tr>
                <TD width="7%" height="29" align=middle>&nbsp;用户昵称</TD>
                <TD align=left width="15%"> &nbsp; <input type="text" name="searchNickname" value="" /></TD>
		 <TD width="7%" align="left"  colspan="3" >&nbsp;<input name="searchNNType" type="radio" value="2" checked="true" />模糊查询   <input name="searchNNType" type="radio" value="1"  />全字匹配</TD>
                </TR>

		<TR class=table_tr>
                <TD height="29" align=middle>&nbsp;所属院系&nbsp;</TD>
                <TD colspan="4" align=left>&nbsp; 
		<select name="searchCollege" id="searchCollege" >
	       <option value="" >--选择院系--</option>
		<g:each in="${collegeList}" var="college">
		<option value="${college.id}" >${college.name}</option>
		</g:each>
		</select>
		</TD>
                </TR>

	      <TR class=table_tr>
                <TD height="29" align=middle>&nbsp;创建时间&nbsp;</TD>
                <TD colspan="4" align=left>&nbsp;
		<input name="dateBegin" type="text" onFocus="calendar()" />&nbsp;至
		&nbsp;<input name="dateEnd" type="text" onFocus="calendar()" />
		  </TD>
                </TR>
</TABLE>
<br>
<div class="buttons" align="center">
                    <span class="button"><input class="button_input"   type="button" value="查 询" onClick="search()" /></span>&nbsp;
   </div>
</div>
	<input type="hidden" name="groupId" value="${params.groupId}" />
	</g:form>
    </body>
</html>
