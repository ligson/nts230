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
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'style_my.css')}" type="text/css"
          media="screen"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'invalid.css')}" type="text/css"
          media="screen"/>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" rel="stylesheet" type="text/css">
    <script language="javascript" type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/prototype.js')}"></script>

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
        function createCheck() {
            //清空所有提示
            $("communityName").innerHTML = '';
            $("communityDescription").innerHTML = '';

            if ($("name").value.trim().length == 0) {
                $("communityName").innerHTML = '&nbsp;&nbsp;<font style="color:red;">标题不能为空值</font>';
                $("name").focus();
                $("name").select();
                return;
            }
            else if ($("name").value.trim().length > 50) {
                var manyLength = (parseInt($("name").value.trim().length) - 50);
                $("communityName").innerHTML = '&nbsp;&nbsp;<font style="color:red;">标题超出了' + manyLength + '个字符</font>';
                $("name").focus();
                $("name").select();
                return;
            }
            else if ($("description").value.trim().length == 0) {
                $("communityDescription").innerHTML = '&nbsp;&nbsp;<font style="color:red;">内容不能为空值</font>';
                $("description").focus();
                $("description").select();
                return;
            }
            editForm.action.value = "update";
            editForm.submit();
        }
        function returnInfo() {
            document.location.href = baseUrl + "my/myCommunity?communityType=my";
        }
    </SCRIPT>
</head>

<body>
<div id="main-content">
    <div class="content-box">
        <!----首页正文开始---->
        <div class="main" style="width: 830px;">
            <div class="commend mt1">
                <DIV id=con>
                    <dl class="tbox light2">
                        <dt class="light"><strong class="icos3">编辑学习社区</strong></dt>
                    </dl>

                    <DIV id=tagContent>
                        <DIV class="tagContent selectTag" id=tagContent0>
                            <form action="update" method="post" enctype="multipart/form-data" name="editForm"
                                  id="editForm">
                                <input type="hidden" name="showType" value="${params.showType}">
                                <input type="hidden" name="id" value="${studyCommunityInstance.id}">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="35%" align="right">*社区名称：</td>
                                        <td width="65%"><label for="textfield"></label>
                                            <input type="text" class="inputwitdh" name="name" id="name"
                                                   value="${studyCommunityInstance.name}"/><span
                                                id="communityName"></span></td>
                                    </tr>
                                    <tr>
                                        <td align="right">*一级分类：</td>
                                        <td><label for="select"></label>
                                            <select style="border:1px solid #dddddd;" name="category1" id="category1"
                                                    onchange="showToLower(this)">
                                                <option>--请选择--</option>
                                                <g:each in="${rmsCategoryList1}" status="i" var="rmsCategory1">
                                                    <option value="${rmsCategory1.id}"
                                                            selected="${studyCommunityInstance.communityCategory.parentid == rmsCategory1.id ? 'selected' : ''}">${rmsCategory1.name}</option>
                                                </g:each>
                                            </select></td>
                                    </tr>
                                    <tr>
                                        <td align="right">*二级分类：</td>
                                        <td><label for="select"></label>
                                            <select style="border:1px solid #dddddd;" name="categoryId" id="category2">
                                                <option vlaue="">--请选择--</option>
                                                <g:each in="${rmsCategoryList2}" status="i" var="rmsCategory2">
                                                    <option value="${rmsCategory2.id}"
                                                            selected="${studyCommunityInstance.communityCategory.id == rmsCategory2.id ? 'selected' : ''}">${rmsCategory2.name}</option>
                                                </g:each>
                                            </select></td>
                                    </tr>
                                    <tr>
                                        <td align="right">缩&nbsp;&nbsp;略&nbsp;&nbsp;图：</td>
                                        <td><input type="file" name="updateImg" class="inputwitdh" id="fileField"/></td>
                                    </tr>
                                    <tr>
                                        <td align="right">描&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;述：</td>
                                        <td><label for="textarea"></label>
                                            <textarea name="description" class="inputwitdh" id="description" cols="45"
                                                      rows="5">${CTools.htmlToBlank(studyCommunityInstance.description)}</textarea><span
                                                id="communityDescription"></span></td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td><input type="button" onclick="createCheck()" name="button" class="but"
                                                   id="button" value="保存"/>
                                            <input type="button" onclick="returnInfo()" class="but" id="button3"
                                                   value="返回"/></td>
                                    </tr>
                                </table>
                            </form>
                        </DIV>
                    </DIV>
                </DIV>
            </div>
        </div>
    </div>
    <!--首页正文部分结束---->
    <div class="hr5"></div>
</div>
</body>
</html>
