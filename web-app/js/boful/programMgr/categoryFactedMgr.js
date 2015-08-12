/**
 * Created with IntelliJ IDEA.
 * User: ligson
 * Date: 13-9-18
 * Time: 下午2:05
 * To change this template use File | Settings | File Templates.
 */
var zTree;
var setting = {
    async: {
        enable: true,
        url: baseUrl + "programMgr/listProgramCategory",
        autoParam: [ "id=pid" ]
    },
    callback: {
        onAsyncSuccess: zTreeOnAsyncSuccess,
        onClick: zTreeOnClick
    },
    edit: {
        enable: true,
        showRemoveBtn: false,
        showRenameBtn: false
    }
};

$(function () {

    zTree = $.fn.zTree.init($("#zTree"), setting);

    $("#categoryFactedGrid").jqGrid({
        caption: "分面列表",
        treeGrid: true,
        treeGridModel: 'adjacency',
        ExpandColumn: 'factedName',
        url:baseUrl+'programMgr/categoryFactedList',
        datatype: "json",
        mtype: "POST",
        search: false,
        colNames: ["ID", "分面名/值", "操作"],
        colModel: [
            { name: "id",index: 'id', width: 50, search: false},
            { name: "factedName", index: 'factedName', width: 200, search: false},
            {name: "操作", width: 300, search: false, sortable: false, formatter: operatorFormatter}
        ],
        pager: "#GridPaper",
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        height: 800,
        multiselect: true,
        jsonReader: {
            root: "rows",
            repeatitems: false
        },
        treeReader : {
            level_field: "level",
            parent_id_field: "parent",
            leaf_field: "isLeaf",
            expanded_field: "expanded"
        },
        gridComplete: function () {
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length * 28;
            $(this).setGridHeight(newRowHeight + 28);
            initPaneScrollbar('center', myLayout.panes.center);
        }
    }).trigger("reloadGrid");

    $("#createCategoryFatctedDialog").dialog({title: "创建分面名称", autoOpen: false, width: 570, height: 360, buttons: {
        "提交": function () {
            createCategoryFacted();
        },
        "取消": function () {
            closeCreateCategoryFatctedDialog();
        }
    }});

    $("#modifyCategoryFatctedDialog").dialog({title: "修改分面名称/值", autoOpen: false, width: 400, height: 200, buttons: {
        "保存": function () {
            modifyFactedName();
        },
        "取消": function () {
            closeModifyCategoryFactedDialog();
        }
    }});

    $("#createCategoryFatcted").click(function () {
        var selectId = $("#selectProgramCategoryId").val();
        var level = $("#level").val();
        if (!selectId.isEmpty()) {
            if(level!=0){
                var name = $("#selectProgramCategoryName").val();
                $("#createCategoryFatctedDialog input[name='categoryName']").val(name);
                $("#createCategoryFatctedDialog input[name='categoryFactedName']").val('');
                $("#createCategoryFatctedDialog").dialog("open");
            } else {
                myAlert("此节点不是分类节点,不能创建分面！");
            }
        } else {
            myAlert("请选择一个根分类！");
        }

    });
});


function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
}


function zTreeOnClick(event, treeId, treeNode) {
    $("#selectProgramCategoryId").val(treeNode.id);
    $("#selectProgramCategoryName").val(treeNode.name);
    $("#level").val(treeNode.level);

    if(treeNode.level != 0) {
        var url = baseUrl + "programMgr/categoryFactedList";
        var postData = {
            programCategoryId: treeNode.id
        };

        jQuery("#categoryFactedGrid").jqGrid("setGridParam", {url: url, page: 1,postData:postData}).trigger("reloadGrid");
    }
}

function operatorFormatter(cellvalue, options, rowObject) {
    var str = "<input class='ui-button searchbtn' type='button' value='修改' title='修改' onclick='categoryFactedModify(" + rowObject.factedId + ", \"" + rowObject.factedName + "\", " + rowObject.parent + ", " + rowObject.programCategoryId + ")'/>&nbsp;&nbsp;<input class='ui-button searchbtn' type='button' value='删除' title='删除' onclick='confirmDel(" + rowObject.factedId + ", " + rowObject.parent + ", " + rowObject.programCategoryId + ")'/>";
    if(rowObject.parent == undefined) {
        str = str + "&nbsp;&nbsp;<input class='ui-button searchbtn' type='button' value='添加分面值' title='添加分面值' onclick='createFactedValue(" + rowObject.factedId + ", " + rowObject.programCategoryId + ")'/>";
    }
    return str;

}

function createFactedValue(factedId, programCategoryId) {
    $("#opt").val("create");
    $("#factedId").val(factedId);
    $("#parent").val('parent');
    $("#modifyCategoryFatctedDialog input[name='factedName']").val('');
    $("#programCategoryId").val(programCategoryId);
    $("#modifyCategoryFatctedDialog").dialog("open");

}

function categoryFactedModify(factedId, factedName, parent, programCategoryId) {
    $("#factedId").val(factedId);
    if(parent == undefined) {
        $("#parent").val('parent');
    } else {
        $("#parent").val('leaf');
    }
    $("#opt").val("modify");
    $("#programCategoryId").val(programCategoryId);
    $("#modifyCategoryFatctedDialog input[name='factedName']").val(factedName);
    $("#modifyCategoryFatctedDialog").dialog("open");

}

function confirmDel(factedId, parent, programCategoryId) {
    var parent1 = '';
    if(parent == undefined) {
        parent1 = 'parent';
    } else {
        parent1 = 'leaf';
    }
    myConfirm("确认要删除吗？", null, function () {
        $.ajax({
            url: baseUrl + "programMgr/removeCategoryFacted",
            data: "factedId=" + factedId + "&parent=" + parent1 + "&programCategoryId="+programCategoryId,
            success: function (data) {
                if (data.success) {
                    var url = baseUrl + "programMgr/categoryFactedList";
                    var postData = {
                        programCategoryId: programCategoryId
                    };

                    jQuery("#categoryFactedGrid").jqGrid("setGridParam", {url: url, page: 1,postData:postData}).trigger("reloadGrid");
                } else {
                    if (data.msg.length == 0) {
                        myAlert('登陆超时，请重新登录。');
                    } else {
                        myAlert(data.msg);
                    }
                }
            }
        });
    }, null);
}

function modifyFactedName(){
    var factedId = $("#factedId").val();
    var factedName = $("#modifyCategoryFatctedDialog input[name='factedName']").val();
    var parent = $("#parent").val();
    var programCategoryId = $("#programCategoryId").val();
    var opt = $("#opt").val();
    if("" == factedName) {
        myAlert("分面名称/值不能为空");
    } else {
        $.post(baseUrl + "programMgr/modifyCategoryFacted",
            {
                factedId: factedId,
                factedName: factedName,
                parent: parent,
                programCategoryId: programCategoryId,
                opt: opt
            },
            function (data) {
                if (data.success) {
                    $("#modifyCategoryFatctedDialog").dialog("close");

                    var url = baseUrl + "programMgr/categoryFactedList";
                    var postData = {
                        programCategoryId: programCategoryId
                    };

                    jQuery("#categoryFactedGrid").jqGrid("setGridParam", {url: url, page: 1,postData:postData}).trigger("reloadGrid");
                } else {
                    if (data.msg.length == 0) {
                        myAlert('登陆超时，请重新登录。');
                    } else {
                        myAlert(data.msg);
                    }
                }
            });
    }
}

function createCategoryFacted() {
    var selectProgramCategoryId = $("#selectProgramCategoryId").val();
    var selectProgramCategoryName = $("#selectProgramCategoryName").val();
    var categoryName = $("#createCategoryFatctedDialog input[name='categoryName']").val();
    var categoryFactedName = $("#createCategoryFatctedDialog input[name='categoryFactedName']").val();
    if("" == categoryFactedName) {
        myAlert("分面名称不能为空");
    } else {
        $.post(baseUrl + "programMgr/createCategoryFacted",
            {
                selectProgramCategoryId: selectProgramCategoryId,
                selectProgramCategoryName: selectProgramCategoryName,
                categoryName: categoryName,
                categoryFactedName: categoryFactedName
            },
            function (data) {
                if (data.success) {
                    $("#createCategoryFatctedDialog").dialog("close");

                    var url = baseUrl + "programMgr/categoryFactedList";
                    var postData = {
                        programCategoryId: selectProgramCategoryId
                    };

                    jQuery("#categoryFactedGrid").jqGrid("setGridParam", {url: url, page: 1,postData:postData}).trigger("reloadGrid");
                } else {
                    if (data.msg.length == 0) {
                        myAlert('登陆超时，请重新登录。');
                    } else {
                        myAlert(data.msg);
                    }
                }
            });
    }
}

function closeModifyCategoryFactedDialog() {
    $("#modifyCategoryFatctedDialog").dialog("close");
}

function closeCreateCategoryFatctedDialog() {
    $("#createCategoryFatctedDialog").dialog("close");
}
