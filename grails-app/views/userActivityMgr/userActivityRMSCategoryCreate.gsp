<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-4-10
  Time: 下午12:57
--%>

<%@ page contentType="text/html;charset=UTF-8" %>



<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>添加学习圈(学习社区)类别</title>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'common.js')}"></script>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <style type="text/css">
    <!--
    .STYLE1 {
        font-size: 12px;
        font-weight: bold;
    }

    .STYLE2 {
        font-size: 12px
    }

    .STYLE3 {
        color: #FF0000;
        font-weight: bold;
    }

    .STYLE6 {
        font-size: 14px
    }

    .STYLE7 {
        font-size: 14px;
        font-weight: bold;
    }

    -->
    </style>
    <script type="text/javascript">
        function addCategory() {
            //清空所有提示
            $('#labname').innerHTML = '';

            if ($('#name').val().trim().length == 0) {
                $('#labname')[0].innerHTML = '名称不能为空值';
                return;
            }
            else if (!widthCheck($('#name').val().trim(), 50)) {
                $('#labname')[0].innerHTML = '名称不能大于50个字符';
                $('#name').select();
                return;
            }
            else {
                var checkType = "addCheck";
                var parentId = $('#parent').val() ? $('#parent').val() : $("#pId").val();
                if($("#rmsCategoryId").val()){
                    checkType = "updateCheck";
                }
                var categoryId = $("#rmsCategoryId").val();
                $.ajax({
                    type: 'POST',
                    url:baseUrl + 'userActivityMgr/checkCategoryName',
                    data:{categoryId: categoryId, categoryName:$('#name').val(), parentId:parentId, checkType: checkType},
                    success:function(data){
                        //alert(data);
                        if(data == 'true' || data == true){
                            alert('同一级别分类不允许重名！');
                        }
                        else{
                            document.form1.submit();
                        }
                    }
                });
            }

        }
    </script>
</head>

<body style="background-color:#ffffff">
<div style="clear:both;"></div>
<g:if test="${flash.message}">
    <div class="message">${flash.message}</div>
</g:if>

<g:if test="${rmsCategory}">
    <h1 style="font-size: 16px;">修改活动节点</h1>
</g:if>
<g:else>
    <h1 style="font-size: 16px;">创建活动节点</h1>
</g:else>
<form name="form1" method="post" action="/UserActivityMgr/rmsCategorySave">
    <input type="hidden" name="rmsCategoryId" id="rmsCategoryId" value="${rmsCategory?.id}"/>
    <input type="hidden" name="searchName" value="${searchName}"/>
    <input type="hidden" name="parentID" id="parentID" value="${parentID}"/>
    <input type="hidden" id="pId" value="${rmsCategory?.parentid}" />
    <input type="hidden" name="editPage" value="${editPage}"/>
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="table">
        <tr>
            <td width="2%">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                    <tr align="left" valign="top">
                        <td width="0%" height="17" valign="middle"></td>
                        <td width="8%" valign="middle"><p align="right">类别名称<span class="STYLE3">*</span>：</p></td>
                        <td colspan="2" valign="middle"><input type="text" maxLength="100" name="name" id="name"
                                                               size="40" style="width: 320px;" class="form-control"  value="${rmsCategory?.name}"/></td>
                        <td width="19%" valign="middle">&nbsp;</td>
                        <td width="9%" valign="middle">&nbsp;</td>
                        <td width="1%" valign="middle">&nbsp;</td>
                    </tr>
                    <tr align="left" valign="top">
                        <td valign="middle"></td>
                        <td valign="middle">&nbsp;</td>
                        <td colspan="2" valign="middle"><label id="labname" style="color:red;"></label></td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                    </tr>
                    <g:if test="${!rmsCategory}">
                        <tr align="left" valign="top">
                            <td height="14" valign="middle"></td>
                            <td valign="middle"><div align="right">上级类别<span class="STYLE3">*</span>：</div></td>
                            <td colspan="4" valign="middle">
                                <select name="parentid" class="form-control" style="width: 220px;" id="parent">
                                    <option value="0">无</option>
                                    <g:each in="${rmsCategoryParentList ?}" status="i" var="rmsCategoryParent">
                                        <option value="${rmsCategoryParent?.id}" ${(rmsCategory?.id == rmsCategoryParent?.id) ? "selected='selected'" : ""}>${rmsCategoryParent?.name}</option>
                                    </g:each>
                                </select>
                            </td>
                            <td valign="middle">&nbsp;</td>
                        </tr>
                    </g:if>
                    <g:else>
                        <input type="hidden" class="form-control" name="parentid" value="${rmsCategory?.parentid}"/>
                    </g:else>
                    <tr align="left" valign="top">
                        <td valign="middle"></td>
                        <td valign="middle">&nbsp;</td>
                        <td colspan="2" valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                    </tr>
                    <tr align="left" valign="top">
                        <td valign="middle"></td>
                        <td valign="middle">&nbsp;</td>
                        <td colspan="2" valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                    </tr>
                    <tr align="left" valign="top">
                        <td valign="middle"></td>
                        <td valign="middle">&nbsp;</td>
                        <td  valign="middle" align="left">
                            <g:if test="${!rmsCategory}">
                                <a href="#dwd"><input type="button" value="添加" class="btn btn-primary" onClick="addCategory();
                                return false;"/></a>
                            </g:if><g:else>
                            <a href="#dwd"><input type="button" value="修改" class="btn btn-primary" onClick="addCategory();
                            return false;"/></a>
                        </g:else>
                        <td width="31%" valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                        <td valign="middle">&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</form>
</body>
</html>
