<%--
  Created by IntelliJ IDEA.
  User: boful
  Date: 14-12-23
  Time: 上午10:13
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="nts.utils.CTools;"%>
<html>
<head>
    <title>我的资源</title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_userspace_index.css')}">
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/myDeleteProgram.js')}"></script>
</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">当前位置：我的资源</a>
</div>
<div class="content-box-header">
    <ul class="content-box-tabs">

        <li><a href="${createLink(controller: 'my', action: 'myManageProgram')}">我的资源</a>
        </li>
        <li><a href="${createLink(controller: 'my', action: 'myDeleteProgram')}"  class="default-tab current">回收站</a></li>
    </ul>

    <div class="clear"></div>
</div>

<table class="table">
    <tbody>
<g:each in="${programList}" status="i" var="program">
    <tr>
        <td width="20"><input id="idList" type="checkbox" value="${program?.id}" name="idList"></td>
        <td width="60"><img width="25" height="25" src="${posterLinkNew(program: program, size: '54x54')}"/></td>
        <td align="left">${CTools.cutString(program?.name, 26).encodeAsHTML()}</td>
        <td width="150"><a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;" onClick="deleteUserActivityList(${program?.id});">删除</a>
        <a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;" onclick="programSet(${program?.id})">还原</a></td>
    </tr>
</g:each>
    </tbody>
</table>

<table class="table">
    <tr>
        <td align="left">
            <a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;" id="sel" name="selall"
               onclick="checkboxAll('idList')">全选</a>
            <a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;" onClick="deleteUserActivityList('');">批量删除</a>
            <a href="javascript:void(0)" class="btn btn-default" style="font-size: 12px;" onclick="programSet('')">批量还原</a>
        </td>
    </tr>
    <tr>

        <td align="right">
            <g:paginate controller="my" action="myDeleteProgram" total="${total}"/>
        </td>
    </tr>
</table>

</body>
</html>