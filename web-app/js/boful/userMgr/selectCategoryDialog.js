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
            url: baseUrl + "coreMgr/listProgramCategory",
            autoParam: [ "id=pid" ]
        },
        callback: {
            onAsyncSuccess: zTreeOnAsyncSuccess,
            onClick: zTreeOnClick
        }
    };
    zTree = $.fn.zTree.init($("#zTree"), setting);


    var selectCategoryBtn = $("#categoryName");
    var categoryDialog = $("#selectCategoryDialog");
    categoryDialog.dialog({
        autoOpen: false,
        width: 500,
        height: 480,
        resizable: false,
        modal: true,
        buttons: {
            "确定": function () {
                var selectId = $("#selectedCategoryId").val();
                var selectName = $("#selectedCategoryName").html();
                if (selectId && selectName) {
                    $("#categoryId").val(selectId);
                    $("#categoryName").val(selectName);
                }
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
    }else{
        zTree.expandNode(treeNode,true,true);
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
    if(newId=="") {
        $("#selectedCategoryId").val("");
        $("#selectedCategoryName").val("");
        $("#categoryNameDiv").empty().append("<span>未选择</span>");
    }
}
