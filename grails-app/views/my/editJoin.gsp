<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="my"/>
    <title>首页</title>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'xindex.css')}"
          media="all">
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'css', file: 'table.css')}" media="all">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>

    <SCRIPT type=text/javascript>
        function selectTag(showContent, selfObj) {
            // 操作标签
            var tag = document.getElementById("tags").getElementsByTagName("li");
            var taglength = tag.length;
            for (i = 0; i < taglength; i++) {
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
                    error: function (data) {
                        $("#category2").empty().append(data);
                    },
                    success: function (data) {
                        $("#category2").empty().append(data);
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
        function updateUserActivity() {
            //清空所有提示
            $("#namePrompt").html('');
            $("#shortNamePrompt").html('');
            $("#startTimePrompt").html('');
            $("#endTimePrompt").html('');
            $("#descriptionPrompt").html('');
            if ($("#name").val().trim().length == 0) {
                $("#namePrompt").html('&nbsp;<font style="color:red;">标题不能为空值</font>');
                $("#name").focus();
                $("#name").select();
                return false;
            }
            else if ($("#name").val().trim().length > 50) {
                var manyLength = (parseInt($("#name").val().trim().length) - 50);
                $("#namePrompt").html('&nbsp;<font style="color:red;">标题超出了' + manyLength + '个字符</font>');
                $("#name").focus();
                $("#name").select();
                return false;
            }
            else if ($("#name").val() == "标题必填，不得多于50个字。") {
                $("#namePrompt").html('&nbsp;<font style="color:red;">你还未输入标题</font>');
                $("#name").focus();
                $("#name").select();
                return false;
            }
            else if ($("#shortName").val().trim().length == 0) {
                $("#shortNamePrompt").html('&nbsp;<font style="color:red;">简称不能为空值</font>');
                $("#shortName").focus();
                $("#shortName").select();
                return false;
            }
            else if ($("#shortName").val().trim().length > 50) {
                var manyLength = (parseInt($("#shortName").value.trim().length) - 50);
                $("#shortNamePrompt").html('&nbsp;<font style="color:red;">简称超出了' + manyLength + '个字符</font>');
                $("#shortName").focus();
                $("#shortName").select();
                return false;
            }
            else if ($("#shortName").val() == "简称必填，不得多于50个字。") {
                $("#shortNamePrompt").html('&nbsp;<font style="color:red;">你还未输入简称</font>');
                $("#shortName").focus();
                $("#shortName").select();
                return false;
            }
            else if ($("#startTime").val().trim().length == 0) {
                $("#startTimePrompt").html('&nbsp;<font style="color:red;">开始时间不能为空</font>');
                $("#startTime").focus();
                $("#startTime").select();
                return false;
            }
            /*else if(new Date($("startTime").value) - new Date() < -24*60*60*1000 )
             {
             $("startTimePrompt").innerHTML = '&nbsp;<font style="color:red;">开始时间不能小于当天</font>' ;
             $("startTime").focus();
             $("startTime").select();
             return false;
             }*/
            else if ($("#endTime").val().trim().length == 0) {
                $("#endTimePrompt").html('&nbsp;<font style="color:red;">结束时间不能为空</font>');
                $("#endTime").focus();
                $("#endTime").select();
                return false;
            }
            else if (new Date($("#startTime").val()) > new Date($("#endTime").val())) {
                $("#endTimePrompt").html('&nbsp;<font style="color:red;">开始时间不能大于结束时间</font>');
                $("#endTime").focus();
                $("#endTime").select();
                return false;
            }
            else if ($("#description").val().trim().length == 0) {
                $("#descriptionPrompt").htm('&nbsp;<font style="color:red;">内容不能为空值</font>');
                $("#description").focus();
                $("#description").select();
                return false;
            }
            updateUserActivityForm.action = baseUrl + "my/updateJoin";
            updateUserActivityForm.submit();
        }
    </SCRIPT>
</head>

<body style="background:none;">

<!----首页正文开始---->
<div class="main top">
    <div class="commend mt1">
        <DIV id=con>
            <dl class="tbox light2">
                <dt class="light"><strong class="icos3">编辑活动</strong></dt>
            </dl>

            <DIV id=tagContent>
                <div style="font-size: 15px; color: red;padding-left: 12px;">${flash.message}</div>

                <DIV class="tagContent selectTag" id=tagContent0>
                    <form action="update" method="post" enctype="multipart/form-data" name="updateUserActivityForm"
                          id="updateUserActivityForm">
                        <input type="hidden" name="id" value="${userActivity.id}">
                        <input type="hidden" name="toPage" value="${params.toPage}">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="10%">*活动标题</td>
                                <td width="90%">
                                    <input type="text" class="inputwitdh" name="name" id="name"
                                           value="${userActivity.name}"/>
                                    <span id="namePrompt"></span></td>
                            </tr>
                            <tr>
                                <td>*活动简称</td>
                                <td>
                                    <input type="text" class="inputwitdh" name="shortName" id="shortName"
                                           value="${userActivity.shortName}"/>
                                    <span id="shortNamePrompt"></span></td>
                            </tr>
                            <tr>
                                <td>缩略图</td>
                                <td>
                                    <input type="file" name="updateImg" value="" class="inputwitdh" id="image"
                                           value=""/>
                                    <span id="imagePrompt"></span></td>
                            </tr>
                            <tr>
                                <td>一级分类</td>
                                <td>
                                    <select style="border:1px solid #dddddd;" name="category1" id="category1"
                                            onchange="showToLower(this)">
                                        <g:each in="${rmsCategoryList1}" status="i" var="rmsCategory1">
                                            <option value="${rmsCategory1.id}" ${userActivity.activityCategory.parentid == rmsCategory1.id ? "selected='selected'" : ""}>${rmsCategory1.name}</option>
                                        </g:each>
                                    </select><span id="ategory1Prompt"></span></td>
                            </tr>
                            <tr>
                                <td>二级分类</td>
                                <td>
                                    <select style="border:1px solid #dddddd;" name="categoryId" id="category2">
                                        <g:each in="${rmsCategoryList2}" status="i" var="rmsCategory2">
                                            <option value="${rmsCategory2.id}" ${userActivity.activityCategory.id == rmsCategory2.id ? "selected='selected'" : ""}>${rmsCategory2.name}</option>
                                        </g:each>
                                    </select><span id="ategory2Prompt"></span></td>
                            </tr>
                            <tr>
                                <td>*开始时间</td>
                                <td>
                                    <input class="text-input datepicker" name="startTime" id="startTime"
                                           value="${userActivity.startTime}" readonly type="text" style="width:160px;"
                                           value="" onClick="return Calendar('startTime');">(年-月-日)
                                    <span id="startTimePrompt"></span></td>
                            </tr>
                            <tr>
                                <td>*结束时间</td>
                                <td>
                                    <input class="text-input datepicker" name="endTime" id="endTime"
                                           value="${userActivity.endTime}" readonly type="text" style="width:160px;"
                                           value="" onClick="return Calendar('endTime');">(年-月-日)
                                    <span id="endTimePrompt"></span></td>
                            </tr>
                            <tr>
                                <td>*活动内容</td>
                                <td>
                                    <textarea name="description" id="description" cols="120"
                                              rows="15">${CTools.htmlToBlank(userActivity.description)}</textarea>
                                    <span id="descriptionPrompt"></span></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>
                                    <input type="button" onclick="updateUserActivity()" name="button" class="but"
                                           id="button" value="保存"/>
                                    <input type="button" onclick="window.close();" class="but" id="button2" value="关闭"/>
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
