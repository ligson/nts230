<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
%{--<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>--}%
<title>编辑活动</title>
%{--<link type="text/css" rel="stylesheet" href="${resource(dir: 'css', file: 'xindex.css')}" media="all">--}%
%{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/css', file: 'editUserActivity.css')}">--}%
<r:require modules="jquery,jquery-ui"/>

<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/editUserActivity.js')}"></script>
<Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css rel=stylesheet>
</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">当前位置：编辑活动</a>
</div>
<!----首页正文开始---->
%{--<div class="main top">--}%
%{--<div class="commend mt1">--}%
%{--<DIV id=con>--}%
<style>
.edituser_table {
    width: 80px;
    display: block;
}

.edituser_table2 {
    width: 200px;
    display: block;
}
</style>

%{--<DIV id=tagContent>--}%
<div style="font-size: 15px; color: red;padding-left: 12px;">${flash.message}</div>

%{--<DIV class="tagContent selectTag" id=tagContent0>--}%
<form action="update" method="post" enctype="multipart/form-data" name="updateUserActivityForm"
      id="updateUserActivityForm">
    <input type="hidden" name="id" value="${userActivity.id}">
    <input type="hidden" name="toPage" value="${params.toPage}">

    <table class="table" style="border: none;">
        <tr>
            <td width="90">*活动标题</td>
            <td width="420"><input type="text" class="form-control" name="name" id="name" value="${userActivity.name}"/>
            </td>
            <td><span id="namePrompt"></span></td>
        </tr>
        <tr>
            <td>*活动简称</td>
            <td><input class="form-control" type="text" name="shortName" id="shortName"
                       value="${userActivity.shortName}"/></td>
            <td><span id="shortNamePrompt"></span></td>
        </tr>
        <tr>
            <td>缩略图</td>
            <td><input type="file" class="choose_files_but" name="updateImg" value="" id="image"
                       value=""/></td>
            <td><span style="color: #e35804" id="imagePrompt"></span></td>
        </tr>
        <tr>
            <td>一级分类</td>
            <td><select style="border:1px solid #abadb3;padding: 5px;height: 36px;width: 120px"
                        name="category1" id="category1" onchange="showToLower(this)">
                <g:each in="${rmsCategoryList1}" status="i" var="rmsCategory1">
                    <option value="${rmsCategory1.id}" ${userActivity.activityCategory.parentid == rmsCategory1.id ? "selected='selected'" : ""}>${rmsCategory1.name}</option>
                </g:each>
            </select></td>
            <td><span id="ategory1Prompt"></span></td>
        </tr>
        <tr>
            <td>二级分类</td>
            <td><select style="border:1px solid #abadb3;padding: 5px;height: 36px;width: 120px"
                        name="categoryId" id="category2">
                <g:each in="${rmsCategoryList2}" status="i" var="rmsCategory2">
                    <option value="${rmsCategory2.id}" ${userActivity.activityCategory.id == rmsCategory2.id ? "selected='selected'" : ""}>${rmsCategory2.name}</option>
                </g:each>
            </select></td>
            <td><span id="ategory2Prompt"></span></td>
        </tr>
        <tr>
            <td>*开始时间</td>
            <td><input class="form-control" style="width: 200px;" name="startTime" id="startTime"
                       value="${userActivity.startTime}" readonly type="text" value="">
                (年-月-日)</td>
            <td><span id="startTimePrompt"></span></td>
        </tr>
        <tr>
            <td>*结束时间</td>
            <td><input class="form-control" style="width: 200px;" name="endTime" id="endTime"
                       value="${userActivity.endTime}" readonly type="text">
                (年-月-日)</td>
            <td><span id="endTimePrompt"></span></td>
        </tr>
        <tr>
            <td>*活动内容</td>
            <td><textarea name="description" id="description" class="form-control"
                          cols="10">${CTools.htmlToBlank(userActivity.description)}</textarea></td>
            <td><span id="descriptionPrompt"></span></td>
        </tr>
        <tr>
            <td></td>
            <td><input type="button" onClick="window.close();" class="btn btn-default" id="button2" value="关闭"/>
                <input type="button" onClick="updateUserActivity()" name="button" class="btn btn-default" id="button"
                       value="保存"/></td>
            <td></td>
        </tr>
    </table>
</form>
%{--</DIV>--}%
%{--</DIV>--}%
%{--</DIV>--}%
%{--</div>--}%

<!--首页正文部分结束---->
<div class="hr5"></div>
</body>
</html>
