function userStateFormatter(cellvalue, options, rowObject) {
    var userState = rowObject.userState;
    var userStateDiv = "";
    if (userState == 0) {
        userStateDiv = "禁用";
    } else if (userState == 1) {
        userStateDiv = "正常";
    }
    return "<span>" + userStateDiv + "</span>"
}
function uploadStateFormatter(cellvalue, options, rowObject) {
    var uploadState = rowObject.uploadState;
    var uploadStateDiv = "";
    if (uploadState == 0) {
        uploadStateDiv = "禁止上传";
    } else if (uploadState == 1) {
        uploadStateDiv = "允许上传";
    }
    return "<span>" + uploadStateDiv + "</span>"
}
function downloadFormatter(cellvalue, options, rowObject) {
    var canDownload = rowObject.canDownload;
    var canDownloadDiv = "";
    if (canDownload == false || canDownload == "false" || canDownload== 0) {
        canDownloadDiv = "禁止下载";
    } else if (canDownload == true || canDownload == "true" || canDownload== 1) {
        canDownloadDiv = "允许下载";
    }
    return "<span>" + canDownloadDiv + "</span>"
}
function commentFormatter(cellvalue, options, rowObject) {
    var canComment = rowObject.canComment;
    var canCommentDiv = "";
    if (canComment == false || canComment == "false"  || canComment== 0) {
        canCommentDiv = "禁止评论";
    } else if (canComment == true || canComment == "true" || canComment== 1) {
        canCommentDiv = "允许评论";
    }
    return "<span>" + canCommentDiv + "</span>"
}
function examineFormatter(cellvalue, options, rowObject) {
    var notExamine = rowObject.notExamine;
    var notExamineDiv = "";
    if (notExamine == false || notExamine == "false" ||  notExamine== 0) {
        notExamineDiv = "审核";
    } else if (notExamine == true || notExamine == "true" || notExamine== 0) {
        notExamineDiv = "已审核";
    }
    return "<span>" + notExamineDiv + "</span>"
}
function operationFormatter(cellvalue, options, rowObject) {
    var userState = rowObject.userState;
    var uploadState = rowObject.uploadState;
    var canDownload = rowObject.canDownload;
    var canComment = rowObject.canComment;
    var notExamine = rowObject.notExamine;
    var userStateDiv = "";
    var userStateFlg="";
    if(userState==0){
        userStateDiv="正常";
        userStateFlg = 1;
    }else if(userState==1){
        userStateDiv="禁用";
        userStateFlg = 0;
    }
    var uploadStateDiv="";
    var uploadStateFlg=""
    if(uploadState==0){
        uploadStateDiv="允许上传";
        uploadStateFlg=1;
    }else if(uploadState==1){
        uploadStateDiv="禁止上传";
        uploadStateFlg=0;
    }
    var canDownloadDiv="";
    var canDownloadFlg="";
    if(canDownload==false){
        canDownloadDiv="允许下载";
        canDownloadFlg=true;
    }else if(canDownload==true){
        canDownloadDiv="禁止下载";
        canDownloadFlg=false;
    }
    var canCommentDiv="";
    var canCommentFlg="";
    if(canComment==false){
        canCommentDiv="允许评论";
        canCommentFlg=true;
    }else if(canComment==true){
        canCommentDiv="禁止评论";
        canCommentFlg=false;
    }
    var notExamineDiv="";
    var notExamineFlg="";
    if(notExamine==false){
        notExamineDiv="已审核";
        notExamineFlg=true;
    }else if(notExamine==true){
        notExamineDiv="审核";
        notExamineFlg=false;
    }
    return "<a class='ui-button searchbtn' onclick='deleteConsumer(" + rowObject.id + ")'>删除</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class='ui-button searchbtn' id='userStateBtn-"+rowObject.id+"' onclick=\"operaCommunityConsumer(" + rowObject.id + ",'userState'," + userStateFlg + ")\">" + userStateDiv + "</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class='ui-button searchbtn' id='uploadStateBtn-"+rowObject.id+"' onclick=\"operaCommunityConsumer(" + rowObject.id + ",'uploadState'," + uploadStateFlg + ")\">" + uploadStateDiv + "</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class='ui-button searchbtn' id='canDownloadBtn-"+rowObject.id+"' onclick=\"operaCommunityConsumer(" + rowObject.id + ",'canDownload'," + canDownloadFlg + ")\">" + canDownloadDiv + "</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class='ui-button searchbtn' id='canCommentBtn-"+rowObject.id+"' onclick=\"operaCommunityConsumer(" + rowObject.id + ",'canComment'," + canCommentFlg + ")\">" + canCommentDiv + "</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class='ui-button searchbtn' id='notExamineBtn-"+rowObject.id+"' onclick=\"operaCommunityConsumer(" + rowObject.id + ",'notExamine'," + notExamineFlg + ")\">" + notExamineDiv + "</a>"
}
function deleteConsumer(idList) {
    var url = baseUrl + "communityManager/consumerDelete";
    myConfirm("确认要删除吗？", null, function () {
        $.ajax({
            url: url,
            data: "idList=" + idList,
            success: function (data) {
                if (data.success) {
//                    myAlert(data.msg);
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
function operaCommunityConsumer(idList, stateName, isFlag) {
    var url = baseUrl + "communityManager/operaCommunityConsumer";
    var target = null;
    $.ajax({
        url: url,
        data: "idList=" + idList + "&stateName=" + stateName + "&isFlag=" + isFlag,
        success: function (data) {
            if (data.success) {
                if (idList instanceof Array) {
                    for (var i = idList.length - 1; i >= 0; i--) {
                        if (stateName == "userState"){
                            $("#adminGrid").setRowData(idList[i], {userState: isFlag});
                            target = $("#userStateBtn-"+idList[i]);
                            if(target){
                                if(isFlag == 0) {
                                    target.attr("onclick", "operaCommunityConsumer("+idList[i]+", 'userState','1')");
                                    target.text("正常");
                                } else {
                                    target.attr("onclick", "operaCommunityConsumer("+idList[i]+", 'userState','0')");
                                    target.text("禁用");
                                }
                            }
                        }
                        if (stateName == "uploadState") {
                            $("#adminGrid").setRowData(idList[i], {uploadState: isFlag});
                            target = $("#uploadStateBtn-"+idList[i]);
                            if(target){
                                if(isFlag == 0) {
                                    target.attr("onclick", "operaCommunityConsumer("+idList[i]+", 'uploadState','1')");
                                    target.text("允许上传");
                                } else {
                                    target.attr("onclick", "operaCommunityConsumer("+idList[i]+", 'uploadState','0')");
                                    target.text("禁止上传");
                                }
                            }
                        }
                        if (stateName == "canDownload") {
                            $("#adminGrid").setRowData(idList[i], {canDownload: isFlag});
                            target = $("#canDownloadBtn-"+idList[i]);
                            if(target){
                                if(isFlag == false || isFlag == "false" || isFlag == 0) {
                                    target.attr("onclick", "operaCommunityConsumer("+idList[i]+", 'canDownload','true')");
                                    target.text("允许下载");
                                } else {
                                    target.attr("onclick", "operaCommunityConsumer("+idList[i]+", 'canDownload','false')");
                                    target.text("禁止下载");
                                }
                            }
                        }
                        if (stateName == "canComment") {
                            $("#adminGrid").setRowData(idList[i], {canComment: isFlag});
                            target = $("#canCommentBtn-"+idList[i]);
                            if(target){
                                if(isFlag == false || isFlag == "false" || isFlag == 0) {
                                    target.attr("onclick", "operaCommunityConsumer("+idList[i]+", 'canComment','true')");
                                    target.text("允许评论");
                                } else {
                                    target.attr("onclick", "operaCommunityConsumer("+idList[i]+", 'canComment','false')");
                                    target.text("禁止评论");
                                }
                            }
                        }
                        if (stateName == "notExamine") {
                            $("#adminGrid").setRowData(idList[i], {notExamine: isFlag});
                            target = $("#notExamineBtn-"+idList[i]);
                            if(target){
                                if(isFlag == false || isFlag == "false" || isFlag == 0) {
                                    target.attr("onclick", "operaCommunityConsumer("+idList[i]+", 'notExamine','true')");
                                    target.text("已审核");
                                } else {
                                    target.attr("onclick", "operaCommunityConsumer("+idList[i]+", 'notExamine','false')");
                                    target.text("审核");
                                }
                            }
                        }
                    }
                } else {
                    if (stateName == "userState") {
                        $("#adminGrid").setRowData(idList, {userState: isFlag});
                        target = $("#userStateBtn-"+idList);
                        if(target){
                            if(isFlag == 0) {
                                target.attr("onclick", "operaCommunityConsumer("+idList+", 'userState','1')");
                                target.text("正常");
                            } else {
                                target.attr("onclick", "operaCommunityConsumer("+idList+", 'userState','0')");
                                target.text("禁用");
                            }
                        }
                    }
                    if (stateName == "uploadState") {
                        $("#adminGrid").setRowData(idList, {uploadState: isFlag});
                        target = $("#uploadStateBtn-"+idList);
                        if(target){
                            if(isFlag == 0) {
                                target.attr("onclick", "operaCommunityConsumer("+idList+", 'uploadState','1')");
                                target.text("允许上传");
                            } else {
                                target.attr("onclick", "operaCommunityConsumer("+idList+", 'uploadState','0')");
                                target.text("禁止上传");
                            }
                        }
                    }
                    if (stateName == "canDownload") {
                        $("#adminGrid").setRowData(idList, {canDownload: isFlag});

                        target = $("#canDownloadBtn-"+idList);
                        if(target){
                            if(isFlag == false || isFlag == "false" || isFlag == 0) {
                                target.attr("onclick", "operaCommunityConsumer("+idList+", 'canDownload','true')");
                                target.text("允许下载");
                            } else {
                                target.attr("onclick", "operaCommunityConsumer("+idList+", 'canDownload','false')");
                                target.text("禁止下载");
                            }
                        }
                    }
                    if (stateName == "canComment") {
                        $("#adminGrid").setRowData(idList, {canComment: isFlag});

                        target = $("#canCommentBtn-"+idList);
                        if(target){
                            if(isFlag == false || isFlag == "false" || isFlag == 0) {
                                target.attr("onclick", "operaCommunityConsumer("+idList+", 'canComment','true')");
                                target.text("允许评论");
                            } else {
                                target.attr("onclick", "operaCommunityConsumer("+idList+", 'canComment','false')");
                                target.text("禁止评论");
                            }
                        }
                    }
                    if (stateName == "notExamine") {
                        $("#adminGrid").setRowData(idList, {notExamine: isFlag});

                        target = $("#notExamineBtn-"+idList);
                        if(target){
                            if(isFlag == false || isFlag == "false" || isFlag == 0) {
                                target.attr("onclick", "operaCommunityConsumer("+idList+", 'notExamine','true')");
                                target.text("已审核");
                            } else {
                                target.attr("onclick", "operaCommunityConsumer("+idList+", 'notExamine','false')");
                                target.text("审核");
                            }
                        }
                    }
                }

            }
            myAlert(data.msg);
        }
    })
}
function operate(action, stateName, isFlag) {
    var ids = $("#adminGrid").jqGrid("getGridParam", "selarrrow");
    if (ids.length == 0) {
        myAlert("请至少选择一条记录！");
        return false;
    }
    ;
    if (action == "deleteConsumer") {
        deleteConsumer(ids);
    } else if (action == "operaCommunityConsumer") {
        operaCommunityConsumer(ids, stateName, isFlag);
    }
}
$(function () {
    $("#adminGrid").jqGrid({
        url: baseUrl + "communityManager/communityAdminList",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "管理员", "昵称", "真实姓名", "状态"/*, "上传", "下载", "评论", "用户审核", "操作"*/],
        colModel: [
            { name: "id", width: 50, search: false},
            { name: "name", width: 100, search: true},
            { name: "nickname", width: 80, search: true},
            { name: "trueName", width: 50, search: false},
            { name: "userState", width: 50, search: false, formatter: userStateFormatter}/*,
            { name: "uploadState", width: 50, search: false, formatter: uploadStateFormatter},
            { name: "canDownload", width: 50, search: false, formatter: downloadFormatter},
            { name: "canComment", width: 50, search: false, formatter: commentFormatter},
            { name: "notExamine", width: 50, search: false, formatter: examineFormatter},
            { name: "操作", width: 300, search: false, sortable: false, formatter: operationFormatter}*/
        ],
        pager: "#GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        height: 600,
        multiselect: true,
        gridComplete: function () {
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length * 25;
            $(this).setGridHeight(newRowHeight + 25);
        }
    }).trigger("reloadGrid");
    $("#searchBtn").click(function () {
        var searchToolBar = $("#searchToolBar");
        var name = searchToolBar.find("input[name='name']").val();
        var communityId = searchToolBar.find("select option:selected").val();
        var url = baseUrl + "communityManager/communityAdminList";
        var postData = {
            name: null,
            communityId: null
        };
        if (!name.isEmpty()) {
            postData.name = name;
        }
        if (communityId != "-1") {
            postData.communityId = communityId;
        }
        jQuery("#adminGrid").jqGrid("setGridParam", {url: url, page: 1, postData: postData}).trigger("reloadGrid");
    })

})