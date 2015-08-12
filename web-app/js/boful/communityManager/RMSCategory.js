
function typeFormatter(cellvalue, options, rowObject){
    var typeDiv="";
    if(rowObject.type==0){
        typeDiv="公共类别";
    }else if(rowObject.type==1){
        typeDiv="学习圈类别";
    }else if(rowObject.type==2){
        typeDiv="学习社区类别";
    }else if(rowObject.type==3){
        typeDiv="活动类别";
    }
    return "<span>"+typeDiv+"</span>"
}
function stateFormatter(cellvalue, options, rowObject){
    var stateDiv="";
    if(rowObject.state==true){
        stateDiv="使用中";
    }else if(rowObject.state==false){
        stateDiv="回收站";
    }
    return "<span>"+stateDiv+"</span>"
}

function deleteFormatter(cellvalue, options, rowObject){
    var str="";
    str+="<a class='ui-button searchbtn' onclick='deleteCategory("+rowObject.id+")'>删除</a>&nbsp;&nbsp;";
    str+="<a class='ui-button searchbtn' onclick='updateCategory("+rowObject.id+")'>修改</a>";
    return str;
}
function updateCategory(id){
   // alert(id)
    window.location.href=baseUrl+"communityManager/categoryCreate?id="+id
}
function deleteCategory(idList){
    var url=baseUrl+"communityManager/rmsCategoryDelete";
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
    var ids=$("#RMSCategoryGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0){
        myAlert("请至少选择一条记录！");
        return false;
    };
    deleteCategory(ids);
}
$(function(){
    $("#RMSCategoryGrid").jqGrid({
        url:baseUrl+"communityManager/RMSCategoryList",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "分类名称", "父分类","创建时间", "状态","操作"],
        colModel:[
            { name: "id", width: 50, search: false},
            { name: "name", width: 150, search: true},
            { name: "parentName", width: 100, search: true},
            { name: "dateCreated", width: 80, search: false},
           /* { name: "type", width: 80,search: false,formatter:typeFormatter},*/
            { name: "state", width: 80,search: false,formatter:stateFormatter},
            { name: "操作", width: 200,search: false,sortable:false,formatter:deleteFormatter}

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

    $("#searchBtn").click(function(){
        var searchToolBar = $("#searchToolBar");
        var name = searchToolBar.find("input[name='name']").val();
        var parentid = searchToolBar.find("select option:selected").val();
        var url = baseUrl + "communityManager/RMSCategoryList";
        var postData = {
            name: null,
            parentid: null
        };
        if (!name.isEmpty()) {
            postData.name=name;
        }
        if (parentid != "-1") {
            postData.parentid=parentid;
        }
        jQuery("#RMSCategoryGrid").jqGrid("setGridParam", {url: url,page:1,postData:postData}).trigger("reloadGrid");
    })
})