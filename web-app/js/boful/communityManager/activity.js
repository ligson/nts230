function stateFormatter(cellvalue, options, rowObject){
    var openDiv="";
    if(rowObject.isOpen==true){
        openDiv="开启";
    }else{
        openDiv="关闭";
    }
    return "<span>"+openDiv+"</span>"
}
function operationFormatter(cellvalue, options, rowObject){
    return "<a class='ui-button searchbtn' onclick='deleteActivity("+rowObject.id+")'>删除</a>";

}
function operationOpenFormatter(cellvalue, options, rowObject){
    var isOpen=rowObject.isOpen;
    if(isOpen==null){
        isOpen=rowObject.operationOpen;
    }
    var openDiv="";
    var state;
    if(isOpen==true){
        openDiv="关闭";
        state=false;
    }else{
        openDiv="开启";
        state=true;
    }
    return "<a class='ui-button searchbtn' onclick='operaActivityState("+rowObject.id+","+state+")'>"+openDiv+"</a>";

}
function operaActivityState(idList,isFlag){
    var url=baseUrl+"communityManager/operaActivityState";
    $.ajax({
        url:url,
        data:"idList="+idList+"&isOpen="+isFlag,
        success:function(data){
            if(data.success){
                if(idList instanceof Array){
                    for(var i=idList.length-1;i>=0;i--){
                        $("#activityGrid").setRowData(idList[i],{isOpen:isFlag});
                        $("#activityGrid").setRowData(idList[i],{id:idList[i],operationOpen:isFlag})
                    }
                }else{
                    $("#activityGrid").setRowData(idList,{isOpen:isFlag});
                    $("#activityGrid").setRowData(idList,{id:idList,operationOpen:isFlag})
                }


            }
            myAlert(data.msg);
        }
    })
}
function deleteActivity(idList){
    var url=baseUrl+"communityManager/activityDelete";
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

function operate(action,isFlag){
    var ids=$("#activityGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0){
        myAlert("请至少选择一条记录！");
        return false;
    };
    if(action=="deleteActivity"){
        deleteActivity(ids);
    }else{
        operaActivityState(ids,isFlag);
    }
}

$(function(){
    $("#activityGrid").jqGrid({
        url:baseUrl+"communityManager/activityList",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "活动名称", "所属社区","创建时间", "创建者", "开始时间", "结束时间","状态","设置","操作"],
        colModel:[
            { name: "id", width: 50, search: false},
            { name: "name", width: 150, search: true},
            { name: "studyCommunity", width: 100, search: true},
            { name: "dateCreated", width: 80, search: false},
            { name: "createConsumer", width: 80,search: false},
            { name: "startTime", width: 80,search: false},
            { name: "endTime", width: 80,search: false},
            { name: "isOpen", width: 80,search: false,formatter:stateFormatter},
            { name: "operationOpen", width: 80,search: false,formatter:operationOpenFormatter},
            { name: "操作", width: 200,search: false,sortable:false,formatter:operationFormatter}
        ],
        pager: "#GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        sortorder:"desc",
        autowidth: true,
        height:600,
        multiselect: true,
        gridComplete:function(){
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length*25;
            $(this).setGridHeight(newRowHeight+25);
        }
    });
})