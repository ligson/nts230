<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-4-9
  Time: 下午6:52
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>添加分类</title>

    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <r:require module="jquery"></r:require>
</head>

<body>

<div class="bs-example" style="width: 400px; margin: 20px 0 0 10px;">
    <g:form action="categorySave" name="categoryForm">
        <div class="form-group">
            <label style="float: left; line-height: 30px; margin-right: 10px;" >分类名称</label>
            <input class="form-control"  name="name" id="categoryName" value="${categoryA?.name}">
            <input class="form-control"  name="id" id="categoryId" value="${categoryA?.id}" type="hidden">
        </div>

        <div class="form-group" style="width: 120px;">
            <label style="float: left; line-height: 30px; margin-right:10px;" >上级类别</label>

            <select class="form-control" name="parentid" id="parentid">
                <option value="0">无</option>
                <g:each in="${categoryList}" var="category">
                    <option value="${category?.id}">${category?.name}</option>
                </g:each>
            </select>
        </div>
        <input type="button" id="categoryBtn" class="btn btn-primary" style="margin-left: 45%;" value="提交">
    </g:form>
</div>
<script type="text/javascript" language="JavaScript">
    $(document).ready(function(){
        $("#categoryBtn").click(function(){
            var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
            if($('#categoryName').val() == ''){
                alert('请输入分类名称');
            }
            else if (patrn.test($('#categoryName').val()) == false) {
                alert("分类名称含有特殊字符!");
            }
            else{
                var checkType = "addCheck";
                if($("#categoryId").val()){
                    checkType = "updateCheck";
                }

                $.ajax({
                    type: 'POST',
                    url:baseUrl + 'communityManager/checkCategoryName',
                    data:{categoryId: $('#categoryId').val(), categoryName:$('#categoryName').val(), parentId:$('#parentid').val(), checkType: checkType},
                    success:function(data){
                        //alert(data);
                        if(data == 'true' || data == true){
                            alert('同一级别分类不允许重名！');
                        }
                        else{
                            $('#categoryForm').submit();
                        }
                    }
                })
            }
        });
    });
    $(function(){
        $("#parentid option[value='${categoryA?.parentid}']").attr("selected","true")
    })
</script>
</body>
</html>