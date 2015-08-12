<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-3-18
  Time: 下午8:01
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>我的提问</title>
</head>

<body>
<g:each in="${questionList}" var="question">
    ${question.title}----${question.course.name}---${question.createDate}---<br/>
</g:each>
</body>
</html>