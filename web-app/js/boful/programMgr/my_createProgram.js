//function checkValue() {
//    var name = $("#name").val();
//    var description = document.getElementById("description");
//    if (name == "") {
//        alert("资源名称不能为空!");
//        return false;
//    }
//    //不检查特殊字符
//    //var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\:+\：+\-+\－+\,+\《》]+$/;
//    //if (patrn.test(name) == false) {
//    //    alert("资源名称含有特殊字符!");
//    //    return false;
//    //}
//    var isFlag = document.getElementById("isFlag");
//    if (isFlag.value == "0") {
//        alert("未上传资源或者资源未上传完成!");
//        return false;
//    }
//
//    $(".resources_upload_save").css("display", "none");
//}
function fileSave() {
    var flag = true;
    var name = document.getElementById("name");
    var isFlag = document.getElementById("isFlag");
    var formPro = document.getElementById("formPro");
    var hasFile = $(".resources_upload_lists").children().size();
    if (name.value == "") {
        alert("资源名称不能为空!");
        flag = false;
        return;
    }
    if (name.value.length > 200) {
        alert("资源名称字符超过200!");
        flag = false;
        return;
    }
    if (isFlag.value == "0") {
        alert("未上传资源或者资源未上传完成!");
        flag = false;
        return;
    }
    //判断是否有上传文件
    if (hasFile == 0) {
        alert("没有上传资源！！！");
        flag = false;
        return;
    }
    if (flag == true) {
        formPro.submit();
    }
}

var zTree;
$(function () {

    var setting = {
        async: {
            enable: true,
            url: baseUrl + "programMgr/listProgramCategory",
            autoParam: [ "id=pid" ]
        },
        callback: {
            onAsyncSuccess: zTreeOnAsyncSuccess,
            onClick: zTreeOnClick
        }
    };
    zTree = $.fn.zTree.init($("#zTree"), setting);


    var selectCategoryBtn = $("#selectCategoryBtn");
    var clearCategoryBtn = $("#clearCategoryBtn");
    var categoryDialog = $("#selectCategoryDialog");
    var categoryId = $("#categoryId").val();
    var categoryName = $("#categoryName").val();
    categoryDialog.dialog({
        autoOpen: false,
        width: 500,
        height: 480,
        resizable: false,
        modal: true,
        buttons: {
            "确定": function () {
                var selectId = $("#selectedCategoryId").val();
                var selectName = $("#selectedCategoryName").val();
                if (selectId && selectName) {
                    $("#categoryId").empty().val(selectId);
                    $("#categoryName").empty().text(selectName);

                    var categoryId2 = $("#categoryId").val();
                    var categoryIdFirst = categoryId2;
                    if (categoryIdFirst.indexOf(',') > 0) {
                        categoryIdFirst = categoryIdFirst.substring(0, categoryIdFirst.indexOf(','));
                    }

                    //获取上传路径,元数据标准
                    $.post(baseUrl + "programMgr/queryCategoryDirectoryAndUploadPath",
                        {categoryId: categoryIdFirst},
                        function (data) {
                            if (data.success) {
                                $("#classLibId").val(data.directoryId);
                                $("#uploadPath").val(data.uploadPath);
                                queryuploadPath(); //重新设置上传路径
                            }
                        }
                    );
                    //获取分面
                    $.post(baseUrl + "programMgr/queryCategoryFacted",
                        {categoryId: categoryId2},
                        function (data) {
                            if (data.success) {
                                var factedTb = $("#factedTb");
                                factedTb.empty();
                                var rows = data.rows;
                                if (rows.length > 0) {
                                    //factedTb添加行列值
                                    $("#factedTr").show();
                                    var trHtml = "";
                                    for (var i = 0; i < rows.length; i++) {
                                        var tdHtml = "";
                                        var values = rows[i].values;
                                        if (values.length > 0) {
                                            for (var j = 0; j < values.length; j++) {
                                                tdHtml = tdHtml + "<input type='checkbox' name='factedValue' value='" + values[j].valId + "'/>" + values[j].valName + "&nbsp;";
                                            }
                                        }
                                        trHtml = trHtml + "<tr><th>" + rows[i].factedName + "</th><td>" + tdHtml + "</td></tr>";
                                    }
                                    factedTb.append(trHtml);
                                } else {
                                    $("#factedTr").hide();
                                }
                            }
                        });
                    $(this).dialog("close");
                } else {
                    myAlert("请选择分类!");
                }
            },
            "关闭": function () {
                $(this).dialog("close");
            }
        }
    });

    //选择分类点击事件
    selectCategoryBtn.click(function () {
        categoryDialog.dialog("open");
    });

    // 清楚分类点击事件
    clearCategoryBtn.click(function () {
        $("#categoryId").val("");
        $("#categoryName").text("");
        // 分类选择对话框清除选择值
        $("#selectedCategoryId").val("");
        $("#selectedCategoryName").val("");
        $("#categoryNameDiv").empty().append("<span>未选择</span>");
        //分面清楚并隐藏
        var factedTb = $("#factedTb");
        factedTb.empty();
        $("#factedTr").hide();
    });

    //增加继续上传
    $("#addBtn").click(function () {
        var tb = $("#tb");
        var fileUpload = $("#fileUpload");
        tb.append(fileUpload.html())
    });

    $(".resources_upload_save").click(function () {
        var inputArr = $(".resources_upload_lists").find(".upload_suc_title input");
        for (var i = 0; i < inputArr.length; i++) {
            if ((inputArr[i].value) == "") {
                alert("资源的标题不能为空");
                return false;
            }
        }
    });

    // 保存资源
    $("#saveBtn").click(function(){
        var name = $("#name").val();
        if (name.length <= 0) {
            alert("资源名称不能为空!");
            return;
        }
        var isFlag = $("#isFlag").val();
        if (isFlag == 0) {
            alert("资源未上传完成不能保存!");
            return;
        }
        //判断是否有上传文件
        //验证资源名称
        var hasFile = $(".resources_upload_lists").children().size();
        var hasSaveBtn = $(".resources_upload_lists").has("#saveBtn").size();
        if (hasFile == 1 && hasSaveBtn==1) {
            alert("没有上传资源！！！");
            return;
        }
        if (hasFile == 0 && hasSaveBtn==0) {
            alert("没有上传资源！！！");
            return;
        }

        var recommendNum = $("#recommendNumId").val();
        if(isNaN(recommendNum)){
            alert("推荐数必须输入数字！！！");
            return;
        }
        if(parseInt(recommendNum, 10) < 0){
            alert("推荐数必须为正整数！！！");
            return;
        }
        if(recommendNum.indexOf(".") > 0){
            alert("推荐数必须为正整数！！！");
            return;
        }

        $.ajax({
            type: "POST",
            url:baseUrl + "programMgr/programSave",
            data:$('#formPro').serialize(),
            success: function(data) {
               if(data.success){
                   if(confirm(data.msg)){
                       window.location.href=baseUrl + "programMgr/editMetaContent?id="+data.id;
                   } else{
                       window.location.href=baseUrl + "programMgr/uploadSuccess";
                   }
               } else {
                   alert(data.msg);
               }
            }
        });

//        var params = new Object();
//        // 资源名称
//        params.name = name;
//        // 类别
//        params.categoryId = $("#categoryId").val();
//        // 元数据标准
//        params.classLibId = $("#classLibId").val();
//        // 分面
//        var facted = $("input[name='factedValue']").find(":checked");
//        if(facted.size()==1) {
//            params.factedValue = facted.val();
//        } else if(facted.size() > 1) {
//            var factedArray = new Array();
//            facted.each(function(){
//                factedArray.put($(this).val());
//            });
//            params.factedValue = factedArray;
//        }
//        // 是否公开
//        params.canPublic = $("input[name='canPublic']").find(":checked").val();
//        // 浏览方式
//        params.otherOption = $("input[name='otherOption']").val();
//        // 标签
//        params.programTag = $("#programTag").val();
//        // 资源描述
//        params.description = $("#description").val();
//
//
//
//
//        params.classLibId = $("#classLibId").val();
//        params.classLibId = $("#classLibId").val();
//        params.classLibId = $("#classLibId").val();
//        params.classLibId = $("#classLibId").val();
//        params.classLibId = $("#classLibId").val();
    });

    if($("#role").val() != "0" ) {
        $("#maxSizeTd").empty().append(convertHumanUnit($("#maxSpaceSize").val()));
        $("#useSizeTd").empty().append(convertHumanUnit($("#useSpaceSize").val()));
        $("#maxSizeTr").show();
        $("#useSizeTr").show();
    }
});
function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
}
function zTreeOnClick(event, treeId, treeNode) {
    if (treeNode.level != 0) {
        zTree.cancelSelectedNode(treeNode);
        var selectId = $("#selectedCategoryId").val();
        var selectName = $("#selectedCategoryName").val();
        if (selectId && selectName) {
            // 已选择内容的ID数组
            var selectIdArray = selectId.split(",");
            // 如果当前选择的ID不在已选择的ID数组中，做添加处理
            if ($.inArray(treeNode.id.toString(),selectIdArray) < 0) {
                // 选中节点为父节点时，判断已经选中的内容中是否属于该父节点
                if(treeNode.isParent) {
                    if(isExistSelectChildrenId(treeNode, selectIdArray)) {
                        return;
                    }

                    if(isExistSelectParentId(treeNode, selectIdArray)) {
                        return;
                    }

                    // 选中节点为子节点时，判断已经选中的内容中是否有包含该字节点的父节点
                }else{
                    if(isExistSelectParentId(treeNode, selectIdArray)) {
                        return;
                    }
                }

                selectId = selectId + "," + treeNode.id;
                selectName = selectName + "," + treeNode.name;
                $.ajax({
                    type: 'post',
                    url: baseUrl + "programMgr/checkProgramCategory",
                    data: {categoryId: selectId},
                    dataType: 'json',
                    success: function(data) {
                        if(data.success) {
                            $("#selectedCategoryId").empty().val(selectId);
                            $("#selectedCategoryName").empty().val(selectName);

                            var name = $("#selectedCategoryName").val();
                            var categoryId = $("#selectedCategoryId").val();
                            var names = name.split(",");
                            var categoryIds = categoryId.split(",");
                            var html = "";
                            if (names && names.length > 0) {
                                for (var i = 0; i < names.length; i++) {
                                    html = html + "<div id=\"div_" + i + "\" style='height: 15px;line-height:15px;float:left;text-align:center;'>" +
                                        "<p style='height:35px;line-height:35px;text-align: center;'>" + names[i] +
                                        "<a class='boful_resources_classall_delete' onClick = 'spanClear(\"" + i + "\", \"" + names[i] + "\", \"" + categoryIds[i] + "\")'></a></p></div>&nbsp;";
                                }
                            }
                            $("#categoryNameDiv").empty().append(html);
                        } else {
//                            myAlert("请选择同一库下的分类！");
                            myAlert(data.msg);
                        }
                    }
                });
            }
        } else {
            $("#selectedCategoryId").empty().val(treeNode.id);
            $("#selectedCategoryName").empty().val(treeNode.name);

            var name = $("#selectedCategoryName").val();
            var categoryId = $("#selectedCategoryId").val();
            var names = name.split(",");
            var categoryIds = categoryId.split(",");
            var html = "";
            if (names && names.length > 0) {
                for (var i = 0; i < names.length; i++) {
                    html = html + "<div id=\"div_" + i + "\" style='height: 15px;line-height:15px;float:left;text-align:center;'>" +
                        "<p style='height:35px;line-height:35px;text-align: center;'>" + names[i] +
                        "<a class='boful_resources_classall_delete' onClick = 'spanClear(\"" + i + "\", \"" + names[i] + "\", \"" + categoryIds[i] + "\")'></a></p></div>&nbsp;";
                }
            }
            $("#categoryNameDiv").empty().append(html);
        }
    } else {
        zTree.expandNode(treeNode,true,true);
    }
}

/**
 * 判断选择的父节点的字节点ID是否在已经选中的ID数组中存在
 * @param parentNode 选择的父节点
 * @param selectIdArray 已经选中的ID数组
 */
function isExistSelectChildrenId(parentNode, selectIdArray) {
    var childrenNodes = parentNode.children;
    // 父节点中的子节点未加载的时候
    if(typeof(childrenNodes)=== 'undefined' ){
        return false;
    }

    var childrenNode;
    var nodeLen = childrenNodes.length;
    for(var index=0;index<nodeLen;index++) {
        childrenNode = childrenNodes[index];
        if($.inArray(childrenNode.id.toString(), selectIdArray) >= 0) {
            return true;
        }
        // 如果该字节点存在下层节点，递归调用本方法
        if(childrenNode.isParent) {
            if(isExistSelectChildrenId(childrenNode, selectIdArray)) {
                return true;
            }
        }
    }

    return false;
}

/**
 * 判断选择的子节点对应的父节点ID是否在已经选中的ID数组中存在
 * @param childrenNode
 * @param selectIdArray
 */
function isExistSelectParentId(childrenNode, selectIdArray) {
    // 取得父节点
    var parentNode = childrenNode.getParentNode();
    if($.inArray(parentNode.id.toString(), selectIdArray) >= 0) {
        return true;
    }
    // 如果取得的父节点不是最顶层，递归调用本方法
    if(parentNode.level != 0) {
        if(isExistSelectParentId(parentNode, selectIdArray)) {
            return true;
        }
    }

    return false;
}

/**
 * 清楚选项
 * @param index
 */
function spanClear(index, categoryName, categoryId) {
    var childDiv = $("#div_" + index);
    var newName = "";
    var newId = "";
    var selectId = $("#selectedCategoryId").val();
    var selectName = $("#selectedCategoryName").val();
    var names = selectName.split(",");
    var categoryIds = selectId.split(",");

    if (names && names.length > 0) {
        for (var i = 0; i < names.length; i++) {
            if (names[i] != categoryName) {
                newName = newName + names[i] + ",";
                newId = newId + categoryIds[i] + ",";
            }
        }
    }
    if (newName.indexOf(",") > 0) {
        newName = newName.substring(0, newName.length - 1);
        newId = newId.substring(0, newId.length - 1);
    }

    $("#selectedCategoryId").val(newId);
    $("#selectedCategoryName").val(newName);
    childDiv.remove();
}



