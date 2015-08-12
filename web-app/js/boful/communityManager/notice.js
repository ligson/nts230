function operationFormatter(cellvalue, options, rowObject){
    return "<a class='ui-button searchbtn' onclick='deleteNotice("+rowObject.id+")'>删除</a>";

}
function deleteNotice(idList){
    var url=baseUrl+"communityManager/noticeDelete";
    myConfirm("确认要删除吗？",null,function(){
        $.ajax({
            url:url,
            data:"idList="+idList,
            success:function(data){
                if(data.success){
//                    myAlert(data.msg);
                    if(idList instanceof Array){
                        for(var i=idList.length-1;i>=0;i--){
                            $("#"+idList[i]).remove();
                        }
                    }else{
                        $("#"+idList).remove();
                    }


                }
                myAlert(data.msg);
            }
        })

    },null);
}

function operate(){
    var ids=$("#noticeGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0){
        myAlert("请至少选择一条记录！");
        return false;
    };
    deleteNotice(ids);
}
$(function(){
    $("#noticeGrid").jqGrid({
        url:baseUrl+"communityManager/noticeList",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "公告名称", "所属社区","创建时间","操作"],
        colModel:[
            { name: "id", width: 50, search: false},
            { name: "name", width: 150, search: true},
            { name: "studyCommunity", width: 100, search: true},
            { name: "dateCreated", width: 80, search: false},
            { name: "操作", width: 200,search: false,sortable:false,formatter:operationFormatter}
        ],
        pager: "#GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        height:600,
        sortorder:"desc",
        multiselect: true,
        gridComplete:function(){
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length*25;
            $(this).setGridHeight(newRowHeight+25);
        }
    });
})