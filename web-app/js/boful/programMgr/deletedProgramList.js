/**
 * Created by ligson on 14-3-27.
 */


function operationFormatter(cellvalue, options, rowObject) {
    var deleteHref = baseUrl + "";
    return "<input class='ui-button' type='button' value='还原' onclick='resetDel(" + rowObject.id + ")'/>";


}

function deleteFormatter(cellvalue, options, rowObject) {
    var deleteHref = baseUrl + "";
    return "<input class='ui-button' type='button' value='删除' onclick='confirmDel(" + rowObject.id + ")'/>";

}
function confirmAction(ids,url){
    $.ajax({
        url:url,
        data:"idList="+ids,
        success:function(data){
            if(data.success){
                for(var i=ids.length-1;i>=0;i--){
                    //修改某一行的值
                    $("#"+ids[i]).remove();
                }
            }else{
                myAlert(data.state);
            }
        }
    })
}
function operate(controller, action) {
    //获取选择行ID
    var ids=$("#programGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0){
        myAlert("请至少选择一条记录！");
        return false;
    };
    var url=baseUrl + controller + "/" + action;
    var isFlag=false;
    if (action == "programDelete") {
        myConfirm("确认删除吗?",null,function(){
            confirmAction(ids,url);
        },null)
    }
    if(action=="programStateSet"){
        myConfirm("确认要还原吗？",null,function(){
            confirmAction(ids,url);
        },null)
    }

}
function resetDel(programId){
    var url=baseUrl+"programMgr/programStateSet";
    myConfirm("确认要还原吗？",null,function(){
        $.post(url,{idList:programId,operation:'restore'},function(data){
            if(data.success){
                $("#"+programId).remove();
            }else{
                myAlert(data.message);
            }
        });
    },null)
}
function confirmDel(programId,action) {
    var url=baseUrl+"programMgr/programDelete";
    myConfirm("确认要删除吗？",null,function(){
        $.post(url,{idList:programId},function(data){
            if(data.success){
                $("#"+programId).remove();
            }else{
                myAlert(data.message);
            }
        });
    },null)
}

$(function () {
    $("#programGrid").jqGrid({
        url: baseUrl + "programMgr/queryDeletedProgramList",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "资源名称", "创建者", "创建日期",  "删除日期","删除", "还原"],
        colModel: [
            { name: "id", width: 50, search: false},
            { name: "name", width: 200, search: true, formatter: playLinkFormatter},
            { name: "consumer", width: 90, search: true},
            { name: "dateCreated", width: 80, align: "right", search: false},
            { name: "dateDeleted", width: 80, align: "right", search: false},
            { name: "删除", width: 150, sortable: false, formatter: deleteFormatter, search: false},
            { name: "还原", width: 50, sortable: false, formatter: operationFormatter, search: false}
        ],
        pager: "#GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        //caption: "My first grid",
        autowidth: true,
        height: 400,
        multiselect: true,
        gridComplete:function(){
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length*30;
            $(this).setGridHeight(newRowHeight+25);
        }
    });
});

function playLinkFormatter(cellvalue, options, rowObject) {
    var url = baseUrl + "program/showProgram?id=" + rowObject.id;
    var html = "<a href='" + url + "' target='_blank' title='" + rowObject.name + "'>" + cellvalue.substr(0, 15) + "</a>";
    return html;
}