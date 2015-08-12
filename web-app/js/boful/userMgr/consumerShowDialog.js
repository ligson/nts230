$(function () {
    var consumerDialog = $("#consumerDialog");
    consumerDialog.dialog({
        autoOpen: false,
        width: 700,
        height: 530,
        resizable: false,
        modal: true,
        buttons: {
            "确定": function () {

                $(this).dialog("close");
            },
            "关闭": function () {
                $(this).dialog("close");
            }
        }
    });
});

function consumerImport(groupId){
    $("#groupId").val(groupId) ;
    $("#searchConsumerBtn").click();
    $("#consumerGrid").jqGrid({
        url:baseUrl+"userMgr/consumerList2?groupId="+groupId,
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "账号", "昵称","真实姓名", "状态"],
        colModel:[
            { name: "id", width: 50, search: false},
            { name: "name", width: 100, search: true},
            { name: "nickname", width: 100, search: true},
            { name: "trueName", width: 100, search: false},
            { name: "userState", width: 100,search: false,formatter:userStateFormatter}
        ],
        pager: "#consumerGridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        height:480,
        sortorder:"desc",
        multiselect: true,
        gridComplete:function(){
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length*25;
            $(this).setGridHeight(newRowHeight+25);
        }
    });

    $("#consumerDialog").dialog("open");
}

