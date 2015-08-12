<%@ page import="nts.utils.CTools" %>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <script type="text/javascript" src="${resource(dir: 'js/boful/userMgr', file: 'collegeList.js')}"></script>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" rel="stylesheet" type="text/css">
    <link href="${resource(dir: 'skin/blue/pc/admin/css', file: 'collegeList.css')}" rel="stylesheet" type="text/css">

    <title>部门设置</title>
    <script LANGUAGE="javascript">
        function showinfo() {
            alert("无权操作");
        }
    </script>

</head>

<body>
<div class="programMgrMain">
    <input class="btn btn-success but_mar" onclick="self.location.href = 'collegeAdd'" type="button" value="添加部门"/>

    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${college}">
        <div class="errors">
            <g:renderErrors bean="${college}" as="list"/>
        </div>
    </g:hasErrors>

    <table id="collegeGrid"></table>
    <div id="GridPaper"></div>
    <input id="editPage" type="hidden" value="${editPage}">
</div>

</body>
</html>

