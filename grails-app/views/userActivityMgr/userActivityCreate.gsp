<%@ page import="nts.utils.CTools" %>
<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-4-9
  Time: 下午1:20
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <g:if test="${userActivity == null}">
        <title>创建活动</title>
    </g:if>
    <g:else>
        <title>修改活动</title>
    </g:else>


%{-- <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/default/pc/css/skin', file: 'list_style.css')}"/>--}%
%{-- <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/default/pc/css', file: 'regedit.css')}"/>--}%
%{-- <link rel="stylesheet" type="text/css" href="${resource(dir:'skin/blue/pc/css',file: 'userActivity_creat.css')}">--}%
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'activity_creat_item.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <r:require modules="jquery-ui"></r:require>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/useractivity.js')}"></script>

    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'string.js')}"></script>


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
            var request_url = baseUrl + "UserActivityMgr/rmsCategoryList2"; // 需要获取内容的url
            var request_pars = {category1: obj.value, category_type: 3};//请求参数
            $.ajax({
                type: "POST",
                dataType: 'text',
                url: request_url,
                data: request_pars,
                success: function (msg) {
                    $("#category2").html(msg);
                }
            });
            var myAjax = new Ajax.Updater('category2', request_url, { // 将request_url返回内容绑定到id为result的容器中
                method: 'post', //HTTP请求的方法,get or post
                parameters: request_pars, //请求参数
                onFailure: reportError, //失败的时候调用 reportError 函数
                onLoading: loading, //正在获得内容的时候
                onComplete: done() //内容获取完毕的时候
            });
        }

        function loading() {
        }

        function done() {
        }

        function reportError(request) {
            alert(request);
        }
        $(function () {
            $("#startTime").datepicker();
            $("#endTime").datepicker();
        })
    </SCRIPT>
</head>

<body style="background:none;">
<div class="creat_act_boxs_title">
    <g:if test="${userActivity == null}">
        <h1 class="wrap">发起活动</h1>
    </g:if>
    <g:else>
        <h1 class="wrap">修改活动</h1>
    </g:else>
    <g:if test="${flash.message}">
        ${flash.message}
    </g:if>
</div>

<div class="creat_act_boxs_body wrap">
<form action="userActivitySave" method="post" enctype="multipart/form-data" name="saveUserActivityForm"
      id="saveUserActivityForm">
%{--隐藏标签，用来判断是保存还是修改--}%
<input type="hidden" name="userActivityId" value="${userActivity?.id}"/>
<input type="hidden" name="photo" value="${userActivity?.photo}"/>
<input type="hidden" name="editPage" value="${editPage}"/>
<input type = "hidden" name="categoryId" id="categoryId" value=""/>
<div id="contentA" class="creat_act_boxs">

    <table class="table">
        <tbody>
        <tr>
            <td width="120" class="creat_act_sup"><span>*</span>活动标题</td>
            <td>
                <input size="16" type="text" name="name" id="name" class="form-control mgr_in" style="width: 300px"
                       value="${userActivity?.name}"/>(标题必填，不得多于50个字符。)
            </td>
            <td width="200">
                <span id="namePrompt" style="font-size: 16px;color: red"></span>
            </td>
        </tr>
        <tr>
            <td class="creat_act_sup"><span>*</span>活动简称</td>
            <td>
                <input size="16" type="text" name="shortName" id="shortName" class="form-control"
                       style="width: 300px"
                       value="${userActivity?.shortName}"/>(简称必填，不得多于50个字符。)
            </td>
            <td>
                <span id="shortNamePrompt" style="font-size: 16px;color: red"></span>
            </td>
        </tr>
        <tr>
            <td class="creat_act_sup"><span>*</span>缩略图</td>
            <td>
                <input type="hidden" id="photo" value="${userActivity?.photo}">
                <g:if test="${userActivity}">
                    <a href="/upload/userActivityImg/${userActivity?.photo}" target="_blank">显示活动图片</a>
                </g:if>
                <input type="file" name="saveImg" value="" id="image"/>
            </td>
            <td>
                <span id="imagePrompt" style="font-size: 16px;color: red"></span>
            </td>
        </tr>
        <tr>
            <td class="creat_act_sup"><span>*</span>一级分类</td>
            <td>
                <select name="category1" id="category1" class="form-control" style="width: 200px"
                        onchange="showToLower(this)">
                    <g:each in="${rmsCategoryList1}" status="i" var="rmsCategory1">
                        <option value="${rmsCategory1.id}" ${(rmsCategory1?.id == userActivity?.activityCategory?.parentid) ? "selected='selected'" : ""}>${rmsCategory1.name}</option>
                    </g:each>
                </select>
            </td>
            <td>
                <span id="ategory1Prompt" style="font-size: 16px;color: red"></span>
            </td>
        </tr>
        <tr>
            <td class="creat_act_sup">二级分类</td>
            <td>
                <select name="category2" id="category2" class="form-control" style="width: 200px">
                    <g:each in="${rmsCategoryList2}" status="i" var="rmsCategory2">
                        <option value="${rmsCategory2.id}" ${(rmsCategory2?.id == userActivity?.activityCategory?.id) ? "selected='selected'" : ""}>${rmsCategory2.name}</option>
                    </g:each>
                </select>
            </td>
            <td>
                <span id="ategory2Prompt" style="font-size: 16px;color: red"></span>
            </td>
        </tr>
        <tr>
            <td class="creat_act_sup"><span>*</span>开始时间</td>
            <td>
                <input size="16" name="startTime" id="startTime" readonly type="text" style="width: 200px"
                       value="${userActivity?.startTime}" class="form-control">
            </td>
            <td>
                <span id="startTimePrompt" style="font-size: 16px;color: red"></span>
            </td>
        </tr>
        <tr>
            <td class="creat_act_sup"><span>*</span>结束时间</td>
            <td>
                <input size="16" name="endTime" id="endTime" readonly type="text" style="width: 200px"
                       value="${userActivity?.endTime}" class="form-control">
            </td>
            <td>
                <span id="endTimePrompt" style="font-size: 16px;color: red"></span>
            </td>
        </tr>
        <tr>
            <td class="creat_act_sup"><span>*</span>活动内容</td>
            <td>
                <textarea name="description" id="description" class="form-control" style="width: 500px"
                          rows="4">${CTools.htmlToBlank(userActivity?.description)}</textarea>
            </td>
            <td>
                <span id="descriptionPrompt"  style="float:left; text-align:left;font-size: 16px;color: red"></span>
            </td>
        </tr>
        <tr>
            <td></td>
            <td style="text-align: left">
                <button onclick="saveUserActivity()" type="button" class="btn btn-success " rows="2">确定</button>
            </td>
        </tr>
        </tbody>
    </table>


    %{-- <div >
        <dd><span  >*活动标题：</span>

            <div >
                <div >
                    <input size="16" type="text" name="name" id="name" />
                </div>
                <span id="namePrompt" ></span>
            </div>
        </dd>
        <dd><span>*活动简称：</span>

            <div >
                <div >
                    <input size="16" type="text" name="shortName" id="shortName"/>
                </div>
                <span id="shortNamePrompt"></span>
            </div>
        </dd>
        <dd><span>缩略图：</span>

            <div >
                <div >
                    <input type="file" name="saveImg" value="" id="image"/>
                </div>
                <span id="imagePrompt" ></span>
            </div>
        </dd>
        <dd><span>一级分类：</span>

            <div >
                <div >
                    <select  name="category1" id="category1"
                            onchange="showToLower(this)">
                        <g:each in="${rmsCategoryList1}" status="i" var="rmsCategory1">
                            <option value="${rmsCategory1.id}">${rmsCategory1.name}</option>
                        </g:each>
                    </select>
                </div>
                <span id="ategory1Prompt" ></span>
            </div>
        </dd>
        <dd><span>二级分类：</span>

            <div >
                <div >
                    <select  name="categoryId" id="category2">
                        <g:each in="${rmsCategoryList2}" status="i" var="rmsCategory2">
                            <option value="${rmsCategory2.id}">${rmsCategory2.name}</option>
                        </g:each>
                    </select>
                </div>
                <span id="ategory2Prompt" ></span>
            </div>
        </dd>
        <dd><span>*开始时间：</span>

            <div >
                <div>
                    <input size="16" name="startTime" id="startTime" readonly type="text"
                           value="" >
                </div>
                <span id="startTimePrompt" ></span>
            </div>
        </dd>
        <dd><span>*结束时间：</span>

            <div >
                <div >
                    <input size="16" name="endTime" id="endTime" readonly type="text"  value=""
                           >
                </div>
                <span id="endTimePrompt" ></span>
            </div>
        </dd>
        <dd><span>*活动内容：</span>

            <div >
                <div >
                    <textarea name="description" id="description" style="width:380px;" rows="10"></textarea>
                </div>
                <span id="descriptionPrompt" style="float:left; width:120px;text-align:left;"></span>
            </div>
        </dd>
        <dd style=" text-align:center;">
            <button onclick="saveUserActivity()"
                    style="background-color:#ef9632; border: 1px solid #ef9632; color: #FFF"  type="button">确定</button>
        </dd>
    </div>--}%
</div>
</form>
</div>
</body>
</html>