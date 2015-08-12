var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
function programFormatter(cellvalue, options, rowObject){
    return "<a href='"+baseUrl+"program/showProgram?id="+rowObject.programId+"' target='_blank' title='"+rowObject.program+"'>"+rowObject.program.substring(0,10)+"</a>"
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
   var str= "<a class='ui-button searchbtn' onclick='deleteDirectory("+rowObject.id+")'>删除</a>";
    if(rowObject.isPass==false || rowObject.isPass=='false'){
        str = str + "&nbsp;&nbsp;<a class='ui-button searchbtn' onclick='approveRemark("+rowObject.id+")'>审批</a>"
    } else {
        str = str + "&nbsp;&nbsp;<a class='ui-button searchbtn'>已审批</a>"
    }
    return str;
}
function hrefFormatter(cellvalue, options, rowObject){
    return "<a href='"+baseUrl+"programMgr/showRemark?id="+rowObject.id+"'>"+rowObject.name+"</a>"
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

function approveRemark(idList){
    var url=baseUrl+"programMgr/approveRemark";
    $.ajax({
        url:url,
        data:"idList="+idList,
        success:function(data){
            if(data.success){
                if(idList instanceof Array){
                    for(var i=idList.length-1;i>=0;i--){
                        var str= "<a class='ui-button searchbtn' onclick='deleteDirectory("+idList[i]+")'>删除</a>";
                        str = str + "&nbsp;&nbsp;<a class='ui-button searchbtn'>已审批</a>"
                        $("#remarkGrid").setRowData(idList[i], {isPass: true, operate: str});
                    }
                }else{
                    $("#remarkGrid").setRowData(idList, {isPass: true});
                }
            }
            myAlert(data.msg);
        }
    })
}
function operate(){
    var ids=$("#remarkGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0){
        myAlert("请至少选择一条记录！");
        return false;
    };
    deleteDirectory(ids);
}

function operateApprove(){
    var ids=$("#remarkGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0){
        myAlert("请至少选择一条记录！");
        return false;
    };
    approveRemark(ids);
}

$(function(){
    $("#remarkGrid").jqGrid({
        url:baseUrl+"programMgr/remarkList",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "评论资源名称", "评论子资源名称", "评论者","评分","回复数","审批状态", "评论时间", "操作"],
        colModel:[
            { name: "id", width: 50, search: false},
            { name: "program", width: 200, search: true,formatter:programFormatter},
            { name: "name", width: 200, search: true,formatter:hrefFormatter},
            { name: "consumer", width: 80,search: false},
            { name: "rank", width: 80,search: false},
            { name: "replyNum", width: 100, search: true},
            { name: "isPass", width: 80,search: false,formatter:isPassFormatter},
            { name: "dateCreated", width: 80,search: false},
            { name: "operate", width: 80,search: false,sortable:false,formatter:operationFormatter}
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

    $("#searchBtn").click(function () {
        var postData = new Object();
        if($("#approveState").val() != "") {
            postData.approveState = $("#approveState").val();
        }
        jQuery("#remarkGrid").jqGrid("setGridParam", {url: baseUrl+"programMgr/remarkList", page: 1, postData: postData}).trigger("reloadGrid");
    });
})