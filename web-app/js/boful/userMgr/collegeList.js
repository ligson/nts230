function updateFormatter(cellvalue, options, rowObject) {

    var str = "<a href=\""+baseUrl+"userMgr/collegeEdit?editPage="+jQuery("#collegeGrid").getGridParam('page')+"&updateId="+rowObject.id+"&updateName="+rowObject.name+"&updateDescription="+rowObject.description+"\"><img src=\""+baseUrl+"images/skin/modi.gif\" alt=\"\" width=\"14\" height=\"14\" border=\"0\"></a>" ;
    return str;
}

function deleteFormatter(cellvalue, options, rowObject) {
    var str = "<a onclick='deleteCollege(" + rowObject.id + ")'><img src='"+baseUrl+"images/skin/delete.gif' border='0' width='11' height='13'/>";
    return str;
}

function deleteCollege(collegeId) {
    var url = baseUrl + "userMgr/collegeDelete";
    myConfirm("确认要删除吗？", null, function () {
        $.ajax({
            url: url,
            data: "id=" + collegeId,
            success: function (data) {
                if (data.success) {
                    myAlert(data.message, " 删除");
                    $("#"+collegeId).remove();
                }
            }
        })

    }, null);
}

$(function () {
    if($('#editPage').val() == ''){
        $('#editPage').val('1');
    }

    $("#collegeGrid").jqGrid({
        url: baseUrl + "userMgr/collegeList2",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["序号", "部门名称", "部门说明", "修改", "删除"],
        colModel: [
            { name: "id", width: 50, search: false},
            { name: "name", width: 50, search: true},
            { name: "description", width: 300, search: true},
            { name: "collegeUpdate", width: 50, search: false, sortable: false, formatter: updateFormatter},
            { name: "collegeDelete", width: 50, search: false, sortable: false, formatter: deleteFormatter}
        ],
        page: parseInt($('#editPage').val()),
        pager: "#GridPaper",
        rowNum: 100,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        height: 600,
        sortorder: "desc",
        gridComplete: function () {
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length * 25;
            $(this).setGridHeight(newRowHeight + 25);
        }
    }).trigger("reloadGrid");

})