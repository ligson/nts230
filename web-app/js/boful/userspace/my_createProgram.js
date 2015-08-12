
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
                }

                var categoryId2 = $("#categoryId").val();
                if (categoryId2.indexOf(',') > 0) {
                    categoryId2 = categoryId2.substring(0, categoryId2.indexOf(','));
                }

                //获取上传路径,元数据标准
                $.post(baseUrl + "programMgr/queryCategoryDirectoryAndUploadPath",
                    {categoryId: categoryId2},
                    function (data) {
                        if (data.success) {
                            $("#classLibId").val(data.directoryId);
                            $("#uploadPath").val(data.uploadPath);
                            queryuploadPath();
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
            },
            "关闭": function () {
                $(this).dialog("close");
            }
        }
    });
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
    $("#addBtn").click(function(){
        var tb = $("#tb");
        var fileUpload = $("#fileUpload");
        tb.append(fileUpload.html())
    });

    $(".resources_upload_save").click(function(){
        var inputArr=$(".resources_upload_lists").find(".upload_suc_title input");
        for(var i=0;i<inputArr.length;i++){
            if((inputArr[i].value)==""){
                alert("资源的标题不能为空");
                return false;
            }
        };
    });
});
function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
}
function zTreeOnClick(event, treeId, treeNode) {
    if (!treeNode.isParent) {
        zTree.cancelSelectedNode(treeNode);
        var selectId = $("#selectedCategoryId").val();
        var selectName = $("#selectedCategoryName").val();
        if (selectId && selectName) {
            if (selectName.indexOf(treeNode.name) < 0) {
                selectId = selectId + "," + treeNode.id;
                selectName = selectName + "," + treeNode.name;
                $("#selectedCategoryId").empty().val(selectId);
                $("#selectedCategoryName").empty().val(selectName);
            }
        } else {
            $("#selectedCategoryId").empty().val(treeNode.id);
            $("#selectedCategoryName").empty().val(treeNode.name);
        }
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
