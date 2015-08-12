<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="layout" content="communityMain" />
<title>标题搜索列表</title>

</head>
<body>
  <div class="l w785">
   <div class="qtlqtit">
    <h2>搜索结果</h2>
    <div class="r pt15"></div>
   </div>
   <div class="cl"></div>
   <div class="qtdblb">
   <table cellpadding="0" cellspacing="0" width="100%">
    <tr class="qtawb f14 wh lh24 b pt5" bgcolor="#f4f4f4">
     <td class="qtawb" width="37%">标题</td><td class="qtawb qtawl" width="18%">创建者</td><td class="qtawb qtawl" width="10%">资源类型</td><td class="qtawb qtawl" width="25%">创建时间</td>
    </tr>
   <g:each in="${multipleList}" status="i" var="multiple">
    <tr class="qtagbg">
     <td class="qtabl qtabb  qtabt"><a href="${createLink(controller: 'forumArticle', action: 'list', params: [boardId: multiple.id])}" title="${multiple.name}" class="gblue">${CTools.cutString(fieldValue(bean:multiple, field:'name'),22)}</a></td>
	 <td class="qtabl qtabb  qtabt">
		<g:if test="${params.type=='post'}">
			${multiple.createConsumer.name}
		</g:if>
		<g:if test="${params.type=='sharing'}">
			${multiple.shareConsumer.name}
		</g:if>
		<g:if test="${params.type=='activity'}">
			${multiple.createConsumer.name}
		</g:if>
		<g:if test="${params.type=='notice'}">
			${session.consumer.name}
		</g:if>
		<g:if test="${params.type=='recommend'}">
			${multiple.consumer.name}
		</g:if>
	 </td>
	 <td class="qtabl qtabb  qtabt g9">${searchType}</td>
	 <td class="qtabl qtabb  qtabt g9"><g:formatDate format="yyyy-MM-dd" date="${multiple.dateCreated}"/></td>
    </tr>
   </g:each>
   </table>
  </div>
   <div class="qfy cl">
      <dl class="mt5">
       <% if(pageCount!=0){ %>
			<dt>共${pageCount}页</dt>
			<dt><a href='${createLink(controller: 'community', action: 'multipleSearch', params: [pageIndex: 1, type: params.type, name: params.name])}'>首页</a></dt>
			<% if(pageIndex!=1){ %>
			<dt><a href='${createLink(controller: 'community', action: 'multipleSearch', params: [pageIndex: pageIndex==1?1:pageIndex-1, type: params.type, name: params.name])}'>上一页</a></dt>
			<% } %>
			<%
			for(int i=1; i<= pageCount; i++){
			%>                
			  <% if(pageIndex==i&&pageIndex+2>=i&&pageIndex-2<=i){ %>
				<dt class="qdqy"}>${i}</dt>
			  <% } %>
			  <% if(pageIndex!=i&&pageIndex+2>=i&&pageIndex-2<=i||(pageIndex<=2&&(i==4||i==5))||(pageIndex>=pageCount-2&&(i==pageCount-3||i==pageCount-4))){ %>
				<dt><a href="${createLink(controller: 'community', action: 'multipleSearch', params: [pageIndex: i, type: params.type, name: params.name])}">${i}</a></dt>
			  <% } %>
			<%}%>
			<% if(pageIndex!=pageCount){ %>
			<dt><a href='${createLink(controller: 'community', action: 'multipleSearch', params: [pageIndex: pageIndex==pageCount?pageCount:pageIndex+1, type: params.type, name: params.name])}'>下一页</a></dt>
			<% } %>
			<dt><a href='${createLink(controller: 'community', action: 'multipleSearch', params: [pageIndex: pageCount, type: params.type, name: params.name])}'>末页</a></dt>
		  <% } %>
		  <% if(pageCount==0){ %>
			抱歉，没有你要查找的数据。
		  <% } %>
      </dl>
     </div>
</div>

</body>
</html>
