<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 13-12-19
  Time: 下午8:06
--%>

<%@ page import="nts.program.domain.Program" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><g:layoutTitle/>-<g:message code="application.name" default="邦丰资源管理平台"/></title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<g:include view="layouts/indexCommonResources.gsp"/>
<g:layoutHead/>
</head>
<body>
<!--header begin--->
<g:include view="layouts/indexHeader.gsp"/>
<!--header end--->

<!---body begin--->
<g:layoutBody/>
<!---body end--->

<!---footer begin--->
<g:include view="layouts/indexFooter.gsp"/>
<!---footer end--->

</body>
</html>