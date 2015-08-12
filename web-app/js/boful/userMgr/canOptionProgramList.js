
function operate(controller, action, operation) {
    var groupId = $("#groupId").val();
    //获取选择行ID
    var ids = $("#programGrid").jqGrid("getGridParam", "selarrrow");
    if (ids.length == 0) {
        myAlert("请至少选择一条记录！");
        return false;
    }
    ;
    var url = baseUrl + controller + "/" + action;
    $.ajax({
        url: url,
        data: "idList=" + ids + "&groupId=" + groupId + "&kind=" + operation,
        success: function (data) {
            if(data.success){
//                myAlert(data.msg);
                if(ids instanceof Array){
                    for(var i=ids.length-1;i>=0;i--){
                        $("#"+ids[i]).remove();
                    }
                }else{
                    $("#"+ids).remove();
                }
            }
            myAlert(data.msg);
        }
    })
}

$(function () {
    $("#programGrid").jqGrid({
        url: baseUrl + "userMgr/canOptionProgramList?groupId=" + $("#groupId").val() + "&kind=" + $("#kind").val(),
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "资源名称", "创建者", "类库", "创建日期", "推荐数", "收藏数", "点播数"],
        colModel: [
            { name: "id", width: 50, search: false},
            { name: "name", width: 200, search: true},
            { name: "consumer", width: 90, search: true},
            { name: "directoryName", width: 90, search: true},
            { name: "dateCreated", width: 80, align: "right", search: false},
            { name: "recommendNum", width: 30, search: true},
            { name: "collectNum", width: 30, search: true},
            { name: "frequency", width: 30, search: true}
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
        var searchToolBar = $("#searchToolBar");
        var name = searchToolBar.find("input[name='name']").val();
        var groupId = searchToolBar.find("input[name='groupId']").val();
        var kind = searchToolBar.find("input[name='kind']").val();
        var url = baseUrl + "userMgr/canOptionProgramList";
        var postData = {
            name: null,
            category: null
        };
        if (!name.isEmpty()) {
            postData.name=name;
        }
        if (!groupId.isEmpty()) {
           postData.groupId=groupId;
        }
        if (!kind.isEmpty()) {
            postData.kind=kind;
        }

        jQuery("#programGrid").jqGrid("setGridParam", {url: url, page: 1,postData:postData}).trigger("reloadGrid");
    });
});