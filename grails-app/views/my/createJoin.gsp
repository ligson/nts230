<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="index"/>
    <title>首页</title>

    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'list_style.css')}"/>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css/skin', file: 'regedit.css')}"/>
    <r:require modules="jquery-ui"></r:require>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/useractivity.js')}"></script>
    <script language="JavaScript" src="${resource(dir: 'js/qinghua', file: 'fenlei.js')}" type="text/javascript"></script>

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

            $.ajax({
                type: "POST",
                dataType:'text',
                url: request_url,
                data:request_pars,
                success: function(msg){
                    $("#category2").html(msg);
                }
            });
            /*var myAjax = new Ajax.Updater('category2', request_url, { // 将request_url返回内容绑定到id为result的容器中
                method: 'post', //HTTP请求的方法,get or post
                parameters: request_pars, //请求参数
                onFailure: reportError, //失败的时候调用 reportError 函数
                onLoading: loading, //正在获得内容的时候
                onComplete: done() //内容获取完毕的时候
            });*/
        }

        function loading() {
        }

        function done() {
        }

        function reportError(request) {
            alert(request);
        }
        $(function(){
            $("#startTime").datepicker();
            $("#endTime").datepicker();
        })
    </SCRIPT>
</head>

<body style="background:none;">
<form action="saveJoin" method="post" enctype="multipart/form-data" name="saveUserActivityForm" id="saveUserActivityForm">
    <div id="contentA" class="area areabg1">
        <div class="ban_x bcorlor1" style=" text-align:left"><span>发起活动</span></div>

        <div class="regedit center" style="text-align: left;width:510px; border-bottom:none;">
            <dd><span>*活动标题：</span>

                <div style="float:right; width:400px;">
                    <div style="float:left;width:220px; ">
                        <input size="16" type="text" name="name" id="name"/>
                    </div>
                    <span id="namePrompt" style="float:left; width:150px;text-align:left;"></span>
                </div>
            </dd>
            <dd><span>*活动简称：</span>

                <div style="float:right; width:400px;">
                    <div style="float:left;width:220px; ">
                        <input size="16" type="text" name="shortName" id="shortName"/>
                    </div>
                    <span id="shortNamePrompt" style="float:left; width:150px;text-align:left;"></span>
                </div>
            </dd>
            <dd><span>缩略图：</span>

                <div style="float:right; width:400px;">
                    <div style="float:left;width:220px; ">
                        <input style="width:220px;" type="file" name="saveImg" value="" id="image"/>
                    </div>
                    <span id="imagePrompt" style="float:left; width:150px;text-align:left;"></span>
                </div>
            </dd>
            <dd><span>一级分类：</span>

                <div style="float:right; width:400px;">
                    <div style="float:left;width:220px; ">
                        <select style="border:1px solid #dddddd;" name="category1" id="category1"
                                onchange="showToLower(this)">
                            <g:each in="${rmsCategoryList1}" status="i" var="rmsCategory1">
                                <option value="${rmsCategory1.id}">${rmsCategory1.name}</option>
                            </g:each>
                        </select>
                    </div>
                    <span id="ategory1Prompt" style="float:left; width:150px;text-align:left;"></span>
                </div>
            </dd>
            <dd><span>二级分类：</span>

                <div style="float:right; width:400px;">
                    <div style="float:left;width:220px; ">
                        <select style="border:1px solid #dddddd;" name="categoryId" id="category2">
                            <g:each in="${rmsCategoryList2}" status="i" var="rmsCategory2">
                                <option value="${rmsCategory2.id}">${rmsCategory2.name}</option>
                            </g:each>
                        </select>
                    </div>
                    <span id="ategory2Prompt" style="float:left; width:150px;text-align:left;"></span>
                </div>
            </dd>
            <dd><span>*开始时间：</span>

                <div style="float:right; width:400px;">
                    <div style="float:left;width:200px; ">
                        <input size="16" name="startTime" id="startTime" readonly type="text" style="width:190px;"
                               value="" >
                    </div>
                    <span id="startTimePrompt" style="float:left; width:170px;text-align:left;"></span>
                </div>
            </dd>
            <dd><span>*结束时间：</span>

                <div style="float:right; width:400px;">
                    <div style="float:left;width:200px; ">
                        <input size="16" name="endTime" id="endTime" readonly type="text" style="width:190px;" value=""
                               >
                    </div>
                    <span id="endTimePrompt" style="float:left; width:170px;text-align:left;"></span>
                </div>
            </dd>
            <dd><span>*活动内容：</span>

                <div style="float:right; width:400px;">
                    <div style="float:left;width:380px; ">
                        <textarea name="description" id="description" style="width:380px;" rows="10"></textarea>
                    </div>
                    <span id="descriptionPrompt" style="float:left; width:120px;text-align:left;"></span>
                </div>
            </dd>
            <dd style=" text-align:center;">
                <button onclick="saveUserActivity()" class="btn btn-primary"
                        style="background-color:#BD2246; border: 1px solid #BD2246;" type="button">确定</button>
            </dd>
        </div>
    </div>
</form>
</body>
</html>
