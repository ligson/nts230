function programFormatter(cellvalue, options, rowObject){
    return "<span title='"+rowObject.program+"'>"+rowObject.program.substring(0,10)+"</span>"
}
function isPassFormatter(cellvalue, options, rowObject){
    var isPass=rowObject.isPass;
    var passDiv="";
    if(isPass==true){
        passDiv="通过";
    }else{
        passDiv="待审批";
    }
    return "<span>"+passDiv+"</span>"
}
function operationFormatter(cellvalue, options, rowObject){
    return "<a onclick='deleteDirectory("+rowObject.id+")'>删除</a>"
}
function deleteDirectory(idList){
    var url=baseUrl+"programMgr/deleteRemark";
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
    var ids=$("#remarkGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0){
        myAlert("请至少选择一条记录！");
        return false;
    };
    deleteDirectory(ids);
}
$(function(){
    $("#sortProgramGrid").jqGrid({
        url:baseUrl+"programMgr/remarkSortProgram",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "资源名称", "评论数"],
        colModel:[
            { name: "id", width: 350, search: false},
            { name: "name", width: 500, search: true},
            { name: "replyNum", width: 500, search: true}
        ],
        pager: "#GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        height:600,
        multiselect: false,
        gridComplete:function(){
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length*25;
            $(this).setGridHeight(newRowHeight+25);
        }
    });

    $("#sortConsumerGrid").jqGrid({
        url:baseUrl+"programMgr/remarkSortConsumer",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "用户名称", "评论数"],
        colModel:[
            { name: "id", width: 350, search: false},
            { name: "name", width: 500, search: true},
            { name: "replyNum", width: 500, search: true}
        ],
        pager: "#GridConPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        height:600,
        multiselect: false,
        gridComplete:function(){
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length*25;
            $(this).setGridHeight(newRowHeight+25);
        }
    });


    $("#programRemark").click(function(){
        $("#programDiv").show();
        $("#consumerDiv").hide();
    })
    $("#consumerRemark").click(function(){
        $("#programDiv").hide();
        $("#consumerDiv").show();
    })
})