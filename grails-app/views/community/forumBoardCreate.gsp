<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/5/28
  Time: 17:51
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>创建小组</title>
    <meta content="index" name="layout">
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_group_list.css')}">
    <script type="text/javascript">
        function checkValue() {
            var name = $("#name").val();
            var Img = $("#Img").val();
            var description = $("#description").val();
            if (name == "请输入小组名称" || name == "") {
                alert("请输入小组名称");
                return false;
            }
            var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
            if (patrn.test(name) == false) {
                alert("小组名称含有特殊字符!");
                return false;
            }
            if (Img == "") {
                alert("请选择文件");
                return false;
            }
            if (description == "") {
                alert("请输入小组介绍");
                return false;
            }
        }
    </script>
</head>

<body>
<div class="commubity_share_title">
    <div class="wrap">
        <div class="commubity_share_nav">
            <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: studyCommunity?.id])}">社区首页</a><span>/</span>
            <a href="javascript:void(0)">主题讨论</a>
        </div>
    </div>
</div>
<g:form controller="community" action="forumBoardSave" onsubmit="return checkValue();" enctype="multipart/form-data">
<input type="hidden" name="communityId" value="${studyCommunity?.id}">
<div class="forum_creat_content">
    <h1>创建小组</h1>
    <table class="table" width="100%">
        <tbody>
        <tr>
            <td width="120px" align="center" class="f_name">小组名称：</td>
            <td><input type="text" class="form-control" name="name" id="name"></td>
            <td width="150"></td>
        </tr>
        <tr>
            <td width="120px" align="center" class="f_name">小组图片：</td>
            <td><input type="file" name="Img" id="Img" style="border: 0; line-height: 25px"></td>
            <td></td>

        </tr>
        <tr>
            <td width="120px" align="center" class="f_name">小组介绍：</td>
            <td><textarea class="form-control" rows="5" cols="2" name="description" id="description"></textarea></td>
            <td></td>

        </tr>
        <tr>
            <td></td>
            <td><label><input type="submit" class="btn btn-success" value="提交"></label></td>
            <td></td>
        </tr>
        </tbody>
    </table>
</div>
</g:form>
</body>
</html>