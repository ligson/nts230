function downloadFormatter(cellvalue, options, rowObject) {
    if (rowObject.canDownload == true || rowObject.canDownload == "true") {
        return "<span>能</span>"
    } else if (rowObject.canDownload == false || rowObject.canDownload == "false") {
        return "<span>否</span>"
    }
}
function playFormatter(cellvalue, options, rowObject) {
    if (rowObject.canPlay == true || rowObject.canPlay == "true") {
        return "<span>能</span>"
    } else if (rowObject.canPlay == false || rowObject.canPlay == "false") {
        return "<span>否</span>"
    }
}
function operationFormatter(cellvalue, options, rowObject) {
    var canDownload = rowObject.canDownload;
    var downloadDiv = "";
    var isDownload;
    if (canDownload == true) {
        downloadDiv = "取消下载";
        isDownload = false;
    } else if (canDownload == false) {
        downloadDiv = "下载";
        isDownload = true;
    }
    var str = "<a class='ui-button searchbtn'  onclick='deleteSharing(" + rowObject.id + ")'>删除</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class='ui-button searchbtn' id='downloadBtn-"+rowObject.id+"' onclick=\"operateSharing(" + rowObject.id + "," + isDownload + ",'canDownload')\">" + downloadDiv + "</a>";
    return str;
}
function operate(action, pars, isFlag) {
    var ids = $("#sharingGrid").jqGrid("getGridParam", "selarrrow");
    if (ids.length == 0) {
        myAlert("请至少选择一条记录！");
        return false;
    }
    ;
    if (action == "deleteSharing") {
        deleteSharing(ids);
    } else if (action == "operateSharing") {
        operateSharing(ids, isFlag, pars);
    }
}
function operateSharing(idList, isFlag, state) {
    var url = baseUrl + "communityManager/operateSharing";
    var target  = null;
    $.ajax({
        url: url,
        data: "idList=" + idList + "&state=" + state + "&isFlag=" + isFlag,
        success: function (data) {
            if (data.success) {
                if (idList instanceof Array) {
                    for (var i = idList.length - 1; i >= 0; i--) {
                        if (state == "canDownload") {
                            $("#sharingGrid").setRowData(idList[i], {canDownload: isFlag});
                            target = $("#downloadBtn-"+idList[i]);
                            if(target){
                                if(isFlag == true || isFlag == "true") {
                                    target.attr("onclick", "operateSharing("+idList[i]+", 'false','canDownload')");
                                    target.text("取消下载");
                                } else if(isFlag == false || isFlag == "false") {
                                    target.attr("onclick", "operateSharing("+idList[i]+", 'true','canDownload')");
                                    target.text("下载");
                                }
                          }

                        } else if (state == "canPlay") {
                            $("#sharingGrid").setRowData(idList[i], {canPlay: isFlag});

                            target=$("#playBtn-"+idList[i]);
                            if(target){
                                if(isFlag == true || isFlag == "true") {
                                    target.attr("onclick", "operateSharing("+idList[i]+", 'false','canPlay')");
                                    target.text("取消点播");
                                } else if(isFlag == false || isFlag == "false"){
                                    target.attr("onclick", "operateSharing("+idList[i]+", 'true','canPlay')");
                                    target.text("点播");
                                }
                            }
                        }

                    }
                } else {
                    if (state == "canDownload") {
                        $("#sharingGrid").setRowData(idList, {canDownload: isFlag});

                        target=$("#downloadBtn-"+idList);
                        if(target){
                            if(isFlag == true || isFlag == "true") {
                                target.attr("onclick", "operateSharing("+idList+", 'false','canDownload')");
                                target.text("取消下载");
                            } else if(isFlag == false || isFlag == "false") {
                                target.attr("onclick", "operateSharing("+idList+", 'true','canDownload')");
                                target.text("下载");
                            }
                        }
                    } else if (state == "canPlay") {
                        $("#sharingGrid").setRowData(idList, {canPlay: isFlag});

                        target=$("#playBtn-"+idList);
                        if(target){
                            if(isFlag == true || isFlag == "true") {
                                target.attr("onclick", "operateSharing("+idList+", 'false','canPlay')");
                                target.text("取消点播");
                            } else if(isFlag == false || isFlag == "false") {
                                target.attr("onclick", "operateSharing("+idList+", 'true','canPlay')");
                                target.text("点播");
                            }
                        }
                    }
                }



            }
            myAlert(data.msg);
        }
    })
}
function deleteSharing(idList) {
    var url = baseUrl + "communityManager/sharingDelete";
    myConfirm("确认要删除吗？", null, function () {
        $.ajax({
            url: url,
            data: "idList=" + idList,
            success: function (data) {
                if (data.success) {
                    if (idList instanceof Array) {
                        for (var i = idList.length - 1; i >= 0; i--) {
                            $("#" + idList[i]).remove();
                        }
                    } else {
                        $("#" + idList).remove();
                    }


                }
                myAlert(data.msg);
            }
        })

    }, null);
}
$(function () {
    $("#sharingGrid").jqGrid({
        url: baseUrl + "communityManager/sharingList",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "共享名称", "所属社区", "共享时间", "共享者", "能否下载", "能否点播", "操作"],
        colModel: [
            { name: "id", width: 50, search: false},
            { name: "name", width: 150, search: true},
            { name: "studyCommunity", width: 100, search: true},
            { name: "createdDate", width: 80, search: false},
            { name: "shareConsumer", width: 80, search: false},
            { name: "canDownload", width: 80, search: false, formatter: downloadFormatter},
            { name: "shareRange", width: 80, search: false},
            { name: "操作", width: 200, search: false, sortable: false, formatter: operationFormatter}
        ],
        pager: "#GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        height: 600,
        sortorder: "desc",
        multiselect: true,
        gridComplete: function () {
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length * 25;
            $(this).setGridHeight(newRowHeight + 25);
        }
    }).trigger("reloadGrid");

})