<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 14-4-30
  Time: 上午9:43
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta name="layout" content="my">
<title>社区修改</title>
%{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'communityEdit.css')}">--}%
<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
<script type="text/javascript">
    function showToLower(obj) {

        var request_url = baseUrl + "community/queryCategoryTwo"; // 需要获取内容的url
        var request_pars = "category1=" + obj.value;//请求参数

        try {
            var myAjax = new Ajax.Updater('category2', request_url, { // 将request_url返回内容绑定到id为result的容器中
                method: 'post', //HTTP请求的方法,get or post
                parameters: request_pars, //请求参数
                onFailure: reportError, //失败的时候调用 reportError 函数
                onLoading: loading, //正在获得内容的时候
                onComplete: done() //内容获取完毕的时候
            });
        } catch (e) {
            $.ajax({
                url: request_url,
                data: request_pars,
                onFailure: function (data) {
                    reportError()
                },
                success: function (data) {
                    $("#category2>option").remove();
                    $("#category2").append(data);
                }

            })
        }

    }
    function updateCheck() {
        //清空所有提示
        $("#communityName").html('');
        $("#communityDescription").html('');

        var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
        if ($("#name").val().trim().length == 0) {
            $("#communityName").html('&nbsp;&nbsp;<font style="color:red;">标题不能为空值</font>');
            $("#name").focus();
            $("#name").select();
            return;
        }
        else if (patrn.test($("#name").val()) == false) {
            $("#communityName").html('&nbsp;&nbsp;<font style="color:red;">活动标题含有特殊字符</font>');
            $("#name").focus();
            $("#name").select();
            return;
        }
        else if ($("#name").val().trim().length > 50) {
            var manyLength = (parseInt($("#name").val().trim().length) - 50);
            $("#communityName").html('&nbsp;&nbsp;<font style="color:red;">标题超出了' + manyLength + '个字符</font>');
            $("#name").focus();
            $("#name").select();
            return;
        } else {
            if ($("#category2").val() != null && $("#category2").val() != "") {
                $("#categoryId").val($("#category2").val());
            } else {
                $("#categoryId").val($("#category1").val());
            }
            var communityId = $("#communityId").val();
            var categoryId = $("#categoryId").val();
            var communityName = $("#name").val();
            $.post(baseUrl + "community/checkExistCommunityName", {communityId: communityId, categoryId: categoryId, communityName: communityName}, function (data) {
                if (data.success) {
                    if ($("#description").val().trim().length == 0) {
                        $("#communityDescription").html('&nbsp;&nbsp;<font style="color:red;">内容不能为空值</font>');
                        $("#description").focus();
                        $("#description").select();
                        return;
                    } else {
                        var updateForm = $("#updateForm");
                        updateForm.submit();
                    }
                } else {
                    $("#communityName").html('&nbsp;&nbsp;<font style="color:red;">' + data.msg + '</font>');
                    $("#name").focus();
                    $("#name").select();
                }
            });
        }
    }
</script>
</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="#">当前位置：社区主页</a><span class="t_mgr">/</span><em style="font-size: 14px;">社区修改</em>
</div>

<div class="communityEdit_box">

    <div class="community_inp_box">
        <form action="communityUpdate" method="post" enctype="multipart/form-data" name="updateForm" id="updateForm">
            <input type="hidden" name="categoryId" id="categoryId" value=""/>
            <input type="hidden" name="id" id="communityId" value="${studyCommunity?.id}"/>
            <table class="table">
                <tbody>
                <tr>
                    <td width="75" align="right" class="t_dt"><span class="inp_rd">*</span>社区名称</td>
                    <td>
                        <label style="width: 300px">
                            <input id="name" name="name" class="form-control" type="text"
                                   value="${studyCommunity?.name}">
                            <span id="communityName"></span>&nbsp;&nbsp;<span
                                style="color:red;">${flash.message}</span>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td align="right" class="t_dt"><span class="inp_rd">*</span>一级分类</td>
                    <td>
                        <label><select name="category1" id="category1" class="form-control"
                                       onchange="showToLower(this)">
                            <g:each in="${rmsCategoryList1}" status="i" var="rmsCategory1">
                                <option value="${rmsCategory1.id}" ${(rmsCategory1?.id == studyCommunity?.communityCategory?.parentid) ? "selected='selected'" : ""}>${rmsCategory1.name}</option>
                            </g:each>
                        </select></label>
                    </td>
                </tr>
                <tr>
                    <td align="right" class="t_dt"><span class="inp_rd">*</span>二级分类</td>
                    <td><label><select name="categoryId2" class="form-control" style="min-width: 100px"
                                       id="category2">
                        <g:each in="${rmsCategoryList2}" status="i" var="rmsCategory2">
                            <option value="${rmsCategory2.id}" ${(rmsCategory2?.id == studyCommunity?.communityCategory?.id) ? "selected='selected'" : ""}>${rmsCategory2.name}</option>
                        </g:each>
                    </select><span id="communityCategory2"></span></label></td>
                </tr>
                <tr>
                    <td align="right" class="t_dt"><span class="inp_rd">*</span>社区海报
                    </td>
                    <td>
                        <label><input type="file" name="Img" value=""> <a
                                href="${resource(dir: 'upload/communityImg', file: studyCommunity?.photo)}" target="_blank">显示活动图片</a>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td align="right" class="t_dt"><span class="inp_rd">*</span>社区背景
                    </td>
                    <td>
                        <label><input type="file" name="bgImage" value="">
                            <a href="${resource(dir: 'upload/communityImg/bgimg', file: studyCommunity?.bgPhoto)}" target="_blank">显示活动图片</a>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td align="right" class="t_dt"><span class="inp_rd">*</span>社区简介</td>
                    <td>
                        <label style="width: 100%">
                            <textarea name="description" id="description" class="form-control"
                                      rows="3">${CTools.htmlToBlank(studyCommunity.description)}</textarea><span
                                id="communityDescription"></span>
                        </label>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <label><input type="button" class="btn btn-success" value="提交" onclick="updateCheck()"></label>
                        <label><input type="button" class="btn btn-success" value="返回" onclick="history.back()"></label>
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
    </div>
</div>
</body>
</html>