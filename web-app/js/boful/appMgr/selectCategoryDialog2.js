/**
 * Created by ligson on 13-12-19.
 */
/**
 * Created with IntelliJ IDEA.
 * User: ligson
 * Date: 13-9-18
 * Time: 下午2:05
 * To change this template use File | Settings | File Templates.
 */
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
    var categoryDialog = $("#selectCategoryDialog");
    categoryDialog.dialog({
        autoOpen: false,
        width: 450,
        height: 480,
        resizable: true,
        modal: true,
        buttons: {
            "确定": function () {
                var selectId = $("#selectedCategoryId").val();
                var selectName = $("#selectedCategoryName").val();
                if (selectId && selectName) {

                    var selectedStr = "";
                    var ids=$("#programGrid").jqGrid("getGridParam","selarrrow");
                    if(ids.length==0){
                        myAlert("请至少选择一条记录！");
                        return false;
                    }
                    selectedStr += ids.toString();
                    if (!selectedStr.isEmpty()) {
                        $.post(baseUrl+"programMgr/changeProgramCategory", {idList: selectedStr, categoryId: selectId}, function (data) {
                            $("#programGrid").trigger("reloadGrid");
                            $("#selectedCategoryId").val("");
                            $("#selectedCategoryName").val("");
                            $("#categoryNameDiv").empty().append("<span>未选择</span>");
                            myAlert("修改成功","提示");
                        });
                    }

                }
                $(this).dialog("close");
            },
            "关闭": function () {
                $(this).dialog("close");
            }
        }
    });
    selectCategoryBtn.click(function () {
        var ids=$("#programGrid").jqGrid("getGridParam","selarrrow");
        if(ids.length==0){
            myAlert("请至少选择一条记录！");
            return false;
        }
        categoryDialog.dialog("open");
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
    }else{
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
    if(newId=="") {
        $("#selectedCategoryId").val("");
        $("#selectedCategoryName").val("");
        $("#categoryNameDiv").empty().append("<span>未选择</span>");
    }
}

