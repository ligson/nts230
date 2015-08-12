
$(document).ready(function () {
    $("#updateProgramId").bind("click", function () {
        var editProgramForm = $("#editProgramForm");
        var otherOption = $("#otherOption").val();
        var categoryId = $("#categoryId").val();
        var programId = $("#programId").val();
        var recommendNumId = $("#recommendNumId").val();
        var name = $("#programName").val();
        //var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\:+\：+\-+\－+\,+\《》]+$/;

        //if (patrn.test(name) == false) {
        if ((1 + 1) != 2) {
            alert("资源名称含有特殊字符!");
        } else if (!/^\d+$/.test(recommendNumId)) {
            alert("推荐数只能为数字！！");
        } else {
            if (otherOption == "128") {
                $.post(baseUrl + "programMgr/querySubCategory", {
                    categoryId: categoryId,
                    programId: programId
                }, function (data) {
                    if (data.success) {
                        editProgramForm.submit();
                    } else {
                        alert("请先把该资源的分类设置在课程分类下!");
                    }
                })
            } else {
                editProgramForm.submit();
            }
        }
    })
})

$(function () {
    $("#tagsInput").keyup(function () {
        var tags = $(this).val();

        // 全角逗号转换成半角逗号
        tags = tags.replace(/，/ig,",");
        var tagArr = tags.split(",");
        var tagCount=0;
        for (var j = 0; j < tagArr.length; j++) {
            var tag2 = tagArr[j].trim();
            if (!tag2.isEmpty()) {
                tagCount++;
            }
        }
        var appendHtml = "";
        var splitValue = "";
        if (tagCount > 5) {
            alert("标签数量不能超过五个!")
        } else {
            for (var i = 0; i<tagArr.length; i++) {
                var tag = tagArr[i].trim();
                if (!tag.isEmpty()) {
                    appendHtml += ("<span class='boful_program_tag'>" + tag + "</span>");
                    splitValue += (tag + " ")
                }

            }
            $("#tagShow").empty().append(appendHtml);
            $("input[name='programTag']").val(splitValue);
        }


    });
});

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
    var categoryName = $("#categoryName").text();
    categoryDialog.dialog({
        autoOpen: false,
        width: 500,
        height: 480,
        resizable: false,
        modal: true,
        open: function(){
            var categoryId = $("#categoryId").val();
            var name = $("#categoryName").text();
            if(categoryId && name) {
                $("#selectedCategoryId").val(categoryId);
                $("#selectedCategoryName").val(name);
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
        },
        buttons: {
            "确定": function () {
                var selectId = $("#selectedCategoryId").val();
                var selectName = $("#selectedCategoryName").val();
                if (selectId && selectName) {
                    $("#categoryId").empty().val(selectId);
                    $("#categoryName").empty().text(selectName);

                    var categoryId2 = $("#categoryId").val();
//                    if (categoryId2.indexOf(',') > 0) {
//                        categoryId2 = categoryId2.substring(0, categoryId2.indexOf(','));
//                    }

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



