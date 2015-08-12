<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="index"/>
    <title>创建社区</title>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'xindex.css')}"
          media="all">
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}"
          media="all">
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'string.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'common.js')}"></script>
    <SCRIPT type=text/javascript>
        function selectTag(showContent, selfObj) {
            // 操作标签
            var tag = document.getElementById("tags").getElementsByTagName("li");
            var taglength = tag.length;
            for (i = 0; taglength > i; i++) {
                tag[i].className = "";
            }
            selfObj.parentNode.className = "selectTag";
            // 操作内容
            for (i = 0; j = document.getElementById("tagContent" + i); i++) {
                j.style.display = "none";
            }
            document.getElementById(showContent).style.display = "block";

        }
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

        function loading() {
        }

        function done() {
        }

        function reportError(request) {
            alert(request);
        }
        function createCheck() {
            //清空所有提示
            $("#communityName").html('');
            $("#communityDescription").html('');
            $("#communityImage").html("");
            $("#communityImage2").html("");

            var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
            if ($("#name").val().trim().length == 0) {
                $("#communityName").html("&nbsp;&nbsp;<font style='color:red;'>标题不能为空值</font>");
                $("#name").focus();
                $("#name").select();
                return;
            }
            else if (patrn.test($("#name").val()) == false) {
                $("#communityName").html('&nbsp;&nbsp;<font style="color:red;">标题含有特殊字符</font>');
                $("#name").focus();
                $("#name").select();
                return;
            }
            else if ($("#name").val().trim().length > 50) {
                var manyLength = (parseInt($("#name").val().trim().length) - 50);
                $("#communityName").html("&nbsp;&nbsp;<font style='color:red;'>标题超出了" + manyLength + "个字符</font>");
                $("#name").focus();
                $("#name").select();
                return;
            } else {
                if ($("#category2").val() != null && $("#category2").val() != "") {
                    $("#categoryId").val($("#category2").val());
                } else {
                    $("#categoryId").val($("#category1").val());
                }

                var communityName = $("#name").val();
                var categoryId = $("#categoryId").val();
                $.post(baseUrl + "community/checkExistCommunityName", {categoryId: categoryId, communityName: communityName}, function (data) {
                    if (data.success) {
                        if ($("#category1").val() == null || $("#category1").val() == "") {
                            $("#communitycategory1").html("&nbsp;&nbsp;<font style='color:red;'>请选择一级分类</font>");
                            $("#category1").focus();
                            $("#category1").select();
                            return;
                        }

                        else if ($("#image").val() == null || $("#image").val() == "") {
                            $("#communityImage").html("&nbsp;&nbsp;<font style='color:red;'>请选择缩略图</font>");
                            return;
                        }

                        else if (checkImg($("#image").val()) != "") {
                            $("#communityImage").html("&nbsp;&nbsp;<font style='color:red;'>" + checkImg($("#image").val()) + "</font>");
                            return;
                        }

                        else if ($("#bgImage").val() == null || $("#bgImage").val() == "") {
                            $("#communityImage2").html("&nbsp;&nbsp;<font style='color:red;'>请选择背景图</font>");
                            return;
                        }

                        else if (checkImg($("#bgImage").val()) != "") {
                            $("#communityImage2").html("&nbsp;&nbsp;<font style='color:red;'>" + checkImg($("#bgImage").val()) + "</font>");
                            return;
                        }

                        else if ($("#description").val().trim().length == 0) {
                            $("#communityDescription").html("&nbsp;&nbsp;<font style='color:red;'>内容不能为空值</font>");
                            $("#description").focus();
                            $("#description").select();
                            return;
                        }

                        else if ($("#description").val().trim().length > 500) {
                            $("#communityDescription").html("&nbsp;&nbsp;<font style='color:red;'>内容不能超过500个字符</font>");
                            $("#description").focus();
                            $("#description").select();
                            return;
                        } else {
                            createForm.action.value = "save";
                            createForm.submit();
                        }
                    } else {
                        $("#communityName").html("&nbsp;&nbsp;<font style='color:red;'>" + data.msg + "</font>");
                        $("#name").focus();
                        $("#name").select();
                        return;
                    }
                });

            }
        }
    </SCRIPT>
</head>

<body style="background:none;">

<!----首页正文开始---->
<div class="creat_community_works">
    <h1 class="wrap"><span>+</span>创建社区</h1>
</div>

<div class="creat_community_body" style="width: 1024px; margin: 0 auto">
    <div class="commend mt1">
        <DIV id=con>
            %{-- <dl class="tbox light2 commend_comm">
                 <dt class="light"><strong class="icos3"><span>+</span>创建学习社区</strong></dt>
             </dl>--}%

            <DIV id=tagContent>
                <DIV class="tagContent selectTag" id=tagContent0>
                    <form action="save" method="post" enctype="multipart/form-data" name="createForm" id="createForm">
                        <input type = "hidden" name="categoryId" id="categoryId" value=""/>
                        <span style="color:red;">${flash.message}</span>
                        <table width="100%" class="table">
                            <tr>
                                <td width="100px" align="right"><span style="color: red">*</span>标题</td>
                                <td width="80%"><label>
                                    <input type="text"
                                           class="form-control" name="name" id="name"/><span
                                            id="communityName"></span>
                                </label>
                                </td>
                            </tr>
                            <tr>
                                <td width="100px" align="right"><span style="color: red">*</span>一级分类</td>
                                <td><label>
                                    <select name="category1" id="category1" class="form-control"
                                            onchange="showToLower(this)">
                                        <g:each in="${rmsCategoryList1}" status="i" var="rmsCategory1">
                                            <option value="${rmsCategory1.id}">${rmsCategory1.name}</option>
                                        </g:each>
                                    </select><span id="communityCategory1"></span></td>
                            </label>
                            </tr>
                            <tr>
                                <td width="100px" align="right">二级分类</td>
                                <td><label>
                                    <select name="categoryId2" class="form-control" style="min-width: 100px"
                                            id="category2">
                                        <g:each in="${rmsCategoryList2}" status="i" var="rmsCategory2">
                                            <option value="${rmsCategory2.id}">${rmsCategory2.name}</option>
                                        </g:each>
                                    </select><span id="communityCategory2"></span></td>
                            </label>
                            </tr>
                            <tr>
                                <td align="right"><span style="color: red">*</span>缩略图</td>
                                <td>
                                    <input type="file" name="Img"value="" id="image"/>
                                    <span id="communityImage"></span></td>
                            </tr>
                            <tr>
                                <td align="right"><span style="color: red">*</span>背景图</td>
                                <td>
                                    <input type="file" name="bgImage"value="" id="bgImage"/>
                                    <span id="communityImage2"></span></td>
                            </tr>
                            <tr>
                                <td align="right"><span style="color: red">*</span>简介</td>
                                <td><label>
                                    <textarea name="description" id="description" class="form-control" cols="200"
                                              rows="6"></textarea><span
                                            id="communityDescription"></span>
                                </label>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <input type="button" onclick="createCheck()" name="button" class="btn btn-success"
                                           id="button"
                                           value="保存"/>
                                    <input type="button" onclick=" history.go(-1)" class="btn btn-success" id="button2"
                                           value="关闭"/>
                                </td>
                            </tr>
                        </table>
                    </form>
                </DIV>
            </DIV>
        </DIV>
    </div>
</div>
<!--首页正文部分结束---->
<div class="hr5"></div>
</body>
</html>
