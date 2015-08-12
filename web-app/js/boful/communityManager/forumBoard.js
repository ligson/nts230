function operationFormatter(cellvalue, options, rowObject){
    return "<a class='ui-button searchbtn' onclick='deleteBoard("+rowObject.id+")'>删除</a>";

}
function deleteBoard(idList){
    var url=baseUrl+"communityManager/forumBoardDelete";
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
    var ids=$("#boardGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0){
        myAlert("请至少选择一条记录！");
        return false;
    };
    deleteBoard(ids);
}
$(function(){
    $("#boardGrid").jqGrid({
        url:baseUrl+"communityManager/forumBoardList",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "小组名称","所属社区","创建时间", "创建者", "成员人数","操作"],
        colModel:[
            { name: "id", width: 50, search: false},
            { name: "name", width: 150, search: true},
            { name: "community", width: 150, search: true},
            { name: "dateCreated", width: 80, search: false},
            { name: "createConsumer", width: 80,search: false},
            { name: "studyCommunity", width: 80,search: false},
            { name: "操作", width: 200,search: false,formatter:operationFormatter,sortable:false}
        ],
        pager: "#GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        sortorder:"desc",
        height:600,
        multiselect: true,
        gridComplete:function(){
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length*25;
            $(this).setGridHeight(newRowHeight+25);
        }
    });
})