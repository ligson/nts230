
function directoryFormatter(cellvalue, options, rowObject){
    var directoryList=rowObject.directory;
    var appendDiv="";
    if(directoryList.length>0){
        for(var i=0;i<directoryList.length;i++){
            appendDiv+=directoryList[i].name;
        }
    }else{
        appendDiv="所有库";
    }

    return "<span>"+appendDiv+"</span>"
}
function updateFormatter(cellvalue, options, rowObject){
    var url=baseUrl+"programMgr/metaDefineEdit?id="+rowObject.id;
    return "<a class='ui-button searchbtn' href='"+url+"'>修改</a>"
}
function deleteFormatter(cellvalue, options, rowObject){
    return "<span class='ui-button searchbtn' onclick='deleteMetaDine("+rowObject.id+")'>删除</span>"
}
function deleteMetaDine(idList){
    var url=baseUrl+"programMgr/metaDefineDelete";
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
    var ids=$("#metaDefineGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0){
        myAlert("请至少选择一条记录！");
        return false;
    };
    deleteMetaDine(ids);
}
$(function(){
    $("#metaDefineGrid").jqGrid({
        url:baseUrl+"programMgr/metaDefineList",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID","序号", "名称", "中文名称", "数据类型", "所属类库", "修改", "删除"],
        colModel:[
            { name: "id", width: 50, search: false},
            { name: "showOrder", width: 50, search: true},
            { name: "name", width: 100, search: true},
            { name: "cnName", width: 80,search: false},
            { name: "dataType", width: 80,search: false},
            { name: "directory", width: 80,search: false,sortable:false,formatter:directoryFormatter},
            { name: "修改", width: 80,search: false,sortable:false,formatter:updateFormatter},
            { name: "删除", width: 80,search: false,sortable:false,formatter:deleteFormatter}
        ],
        pager: "#GridPaper",
        rowNum: 20,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        height:400,
        multiselect: true,
        gridComplete:function(){
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length*25;
            $(this).setGridHeight(newRowHeight+25);
        }
    });
})