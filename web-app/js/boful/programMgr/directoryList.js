function operationFormatter(cellvalue, options, rowObject) {
    var str = "";
    str += "<a class='ui-button searchbtn' onclick='updateDirectory(" + rowObject.id + ")'>修改</a>";
    str += "&nbsp;&nbsp;&nbsp;&nbsp;<a class='ui-button searchbtn' onclick='deleteDirectory(" + rowObject.id + ")'>删除</a>";
    return str;
}
function updateDirectory(tag) {
    window.location.href = baseUrl + "programMgr/createDirectory?id=" + tag + "&editPage=" + jQuery("#directoryGrid").getGridParam('page');
}
function deleteDirectory(idList) {
    var url = baseUrl + "programMgr/directoryDelete";
    myConfirm("删除元数据标准的同时会把相应的资源、元数据一起删除,确定删除吗?", null, function () {
        $.ajax({
            url: url,
            data: "idList=" + idList,
            success: function (data) {
                if (data.success) {
                    if (idList instanceof Array) {
                        for (var i = idList.length - 1; i >= 0; i--) {
                            $("#" + idList[i]).remove();
                        }
                    } else {
                        $("#" + idList).remove();
                    }
                    myAlert(data.msg, "提示");
                } else {
                    myAlert(data.msg);
                }

            }
        })

    }, null);
}
function operate() {
    var ids = $("#directoryGrid").jqGrid("getGridParam", "selarrrow");
    if (ids.length == 0) {
        myAlert("请至少选择一条记录！");
        return false;
    }
    ;
    deleteDirectory(ids);
}
$(function () {
    if ($('#editPage').val() == '') {
        $('#editPage').val('1');
    }
    $("#directoryGrid").jqGrid({
        url: baseUrl + "programMgr/directoryList2",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "元数据标准名称", "元数据标准序号", "备注", "创建时间", "操作"],
        colModel: [
            { name: "id", width: 10, search: false},
            { name: "name", width: 80, search: true},
            { name: "showOrder", width: 50, search: true},
            { name: "description", width: 80, search: false},
            { name: "dateCreated", width: 80, search: false},
            { name: "操作", width: 80, search: false, formatter: operationFormatter}
        ],
        page: parseInt($('#editPage').val()),
        pager: "#GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        height: 600,
        sortorder: "desc",
        multiselect: true,
        gridComplete: function () {
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length * 25;
            $(this).setGridHeight(newRowHeight + 25);
        }
    });
})