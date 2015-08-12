var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if ('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
function userStateFormatter(cellvalue, options, rowObject) {
    var userState = rowObject.userState;
    var userStateDiv = "";
    if (userState == 0) {
        userStateDiv = "<img src='" + baseUrl + "skin/blue/pc/admin/images/resource_arrow_n.png';>"
    } else if (userState == 1) {
        userStateDiv = "<img src='" + baseUrl + "skin/blue/pc/admin/images/resource_arrow_r.png';>";
    }
    //return "<span>"+userStateDiv+"</span>"
    return "<a class='ui-button searchbtn' onclick=\"operaConsumer(" + rowObject.id + ",'userState'," + userState + ")\">" + userStateDiv + "</a>"
}
function uploadStateFormatter(cellvalue, options, rowObject) {
    var uploadState = rowObject.uploadState;
    var uploadStateDiv = "";
    if (uploadState == 0) {
        uploadStateDiv = "<img src='" + baseUrl + "skin/blue/pc/admin/images/resource_arrow_n.png';>";
    } else if (uploadState == 1) {
        uploadStateDiv = "<img src='" + baseUrl + "skin/blue/pc/admin/images/resource_arrow_r.png';>";
    }
    //return "<span>"+uploadStateDiv+"</span>"
    return "<a class='ui-button searchbtn'  onclick=\"operaConsumer(" + rowObject.id + ",'uploadState'," + uploadState + ")\">" + uploadStateDiv + "</a>"
}
function downloadFormatter(cellvalue, options, rowObject) {
    var canDownload = rowObject.canDownload;
    var canDownloadDiv = "";
    if (canDownload == false) {
        canDownloadDiv = "<img src='" + baseUrl + "skin/blue/pc/admin/images/resource_arrow_n.png';>";
    } else if (canDownload == true) {
        canDownloadDiv = "<img src='" + baseUrl + "skin/blue/pc/admin/images/resource_arrow_r.png';>";
    }
    //return "<span>"+canDownloadDiv+"</span>"
    return "<a class='ui-button searchbtn' onclick=\"operaConsumer(" + rowObject.id + ",'canDownload'," + canDownload + ")\">" + canDownloadDiv + "</a>"
}

function playFormatter(cellvalue, options, rowObject) {
    var canPlay = rowObject.canPlay;
    var canPlayDiv = "";
    if (canPlay == false) {
        canPlayDiv = "<img src='" + baseUrl + "skin/blue/pc/admin/images/resource_arrow_n.png';>";
    } else if (canPlay == true) {
        canPlayDiv = "<img src='" + baseUrl + "skin/blue/pc/admin/images/resource_arrow_r.png';>";
    }
    //return "<span>"+canDownloadDiv+"</span>"
    return "<a class='ui-button searchbtn' onclick=\"operaConsumer(" + rowObject.id + ",'canPlay'," + canPlay + ")\">" + canPlayDiv + "</a>"
}
function commentFormatter(cellvalue, options, rowObject) {
    var canComment = rowObject.canComment;
    var canCommentDiv = "";
    if (canComment == false) {
        canCommentDiv = "<img src='" + baseUrl + "skin/blue/pc/admin/images/resource_arrow_n.png';>";
    } else if (canComment == true) {
        canCommentDiv = "<img src='" + baseUrl + "skin/blue/pc/admin/images/resource_arrow_r.png';>";
    }
    //return "<span>"+canCommentDiv+"</span>"
    return "<a class='ui-button searchbtn' onclick=\"operaConsumer(" + rowObject.id + ",'canComment'," + canComment + ")\">" + canCommentDiv + "</a>"
}
function examineFormatter(cellvalue, options, rowObject) {
    var isRegister = rowObject.isRegister;
    var isRegisterDiv = "";
    if (isRegister == true) {
        isRegisterDiv = "<img src='" + baseUrl + "skin/blue/pc/admin/images/resource_arrow_n.png';>";
    } else if (isRegister == false) {
        isRegisterDiv = "<img src='" + baseUrl + "skin/blue/pc/admin/images/resource_arrow_r.png';>";
    }
    //return "<span>"+notExamineDiv+"</span>"
    return "<a class='ui-button searchbtn' onclick=\"operaConsumer(" + rowObject.id + ",'isRegister'," + isRegister + ")\">" + isRegisterDiv + "</a>"
}
function operationFormatter(cellvalue, options, rowObject) {
    var userState = rowObject.userState;
    var uploadState = rowObject.uploadState;
    var canDownload = rowObject.canDownload;
    var canPlay = rowObject.canPlay;
    var canComment = rowObject.canComment;
    var notExamine = rowObject.notExamine;
    var userStateDiv = "";
    if (userState == 0) {
        userStateDiv = "正常";
    } else if (userState == 1) {
        userStateDiv = "禁用";
    }
    var uploadStateDiv = "";
    if (uploadState == 0) {
        uploadStateDiv = "允许上传";
    } else if (uploadState == 1) {
        uploadStateDiv = "禁止上传";
    }
    var canDownloadDiv = "";
    if (canDownload == false) {
        canDownloadDiv = "允许下载";
    } else if (canDownload == true) {
        canDownloadDiv = "禁止下载";
    }

    var canPlayDiv = "";
    if (canPlay == false) {
        canPlayDiv = "允许点播";
    } else if (canPlay == true) {
        canPlayDiv = "禁止点播";
    }

    var canCommentDiv = "";
    if (canComment == false) {
        canCommentDiv = "允许评论";
    } else if (canComment == true) {
        canCommentDiv = "禁止评论";
    }
    var notExamineDiv = "";
    if (notExamine == false) {
        notExamineDiv = "已审核";
    } else if (notExamine == true) {
        notExamineDiv = "审核";
    }
    var isDel = "";
    if (rowObject.name != "master") {
        isDel = "<a class='ui-button searchbtn' onclick='deleteConsumer(" + rowObject.id + ","+(rowObject.userRole=="1")+")'>删除</a>";
    }
    //return "<a onclick='deleteConsumer("+rowObject.id+")'>删除</a>&nbsp;&nbsp;&nbsp;&nbsp;<a onclick=\"operaConsumer("+rowObject.id+",'userState',"+userState+")\">"+userStateDiv+"</a>&nbsp;&nbsp;&nbsp;&nbsp;<a onclick=\"operaConsumer("+rowObject.id+",'uploadState',"+uploadState+")\">"+uploadStateDiv+"</a>&nbsp;&nbsp;&nbsp;&nbsp;<a onclick=\"operaConsumer("+rowObject.id+",'canDownload',"+canDownload+")\">"+canDownloadDiv+"</a>&nbsp;&nbsp;&nbsp;&nbsp;<a onclick=\"operaConsumer("+rowObject.id+",'canComment',"+canComment+")\">"+canCommentDiv+"</a>&nbsp;&nbsp;&nbsp;&nbsp;<a onclick=\"operaConsumer("+rowObject.id+",'notExamine',"+notExamine+")\">"+notExamineDiv+"</a>"
    return isDel + "&nbsp;&nbsp;&nbsp;&nbsp;<a class='ui-button searchbtn' onclick='editConsumer(" + rowObject.id + "," + jQuery("#consumerGrid").getGridParam('page') + ")'>修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class='ui-button searchbtn' onclick='editConsumerPwd(" + rowObject.id + ")'>重置密码</a>"
}
function deleteConsumer(idList,userRole) {
    var url = baseUrl + "userMgr/consumerDelete";
    var deleteMsg;
    // 被删除的用户拥有资源管理权限
    if(userRole) {
        deleteMsg="该用户是资源管理员，删除用户会同时删除其上传的所有资源。确认要删除吗？";
    } else {
        deleteMsg="确认要删除吗？";
        for(var i=0;i<idList.length;i++) {
            if($("#consumerGrid").jqGrid("getCell",idList[i],'userRole')){
                deleteMsg="删除的用户中包含资源管理员，删除用户会同时删除其上传的所有资源。确认要删除吗？";
                break;
            }
        }
    }
    myConfirm(deleteMsg, null, function () {
        $.ajax({
            url: url,
            data: "idList=" + idList,
            success: function (data) {
                if (data.success) {
                    myAlert(data.msg);
                    if (idList instanceof Array) {
                        for (var i = idList.length - 1; i >= 0; i--) {
                            $("#" + idList[i]).remove();
                        }
                    } else {
                        $("#" + idList).remove();
                    }


                } else {
                    myAlert(data.msg);
                }
            }
        })

    }, null);
}
function addConsumer() {
    self.location.href = "userCreate";
}
function editConsumer(id, page) {
    var searchToolBar = $("#searchToolBar");
    var searchName = searchToolBar.find("input[name='searchName']").val();
    var searchNickName = searchToolBar.find("input[name='searchNickName']").val();
    var searchTrueName = searchToolBar.find("input[name='searchTrueName']").val();
    var searchCollege = searchToolBar.find("select option:selected").val();
    var userRole = $('#userRole').val();
    self.location.href = baseUrl + "userMgr/userEdit?id=" + id + "&editPage=" + page + "&searchName=" + searchName + "&searchNickName=" + searchNickName + "&searchTrueName=" + searchTrueName + "&searchCollege=" + searchCollege + "&userRole=" + userRole;
}
function editConsumerPwd(id) {
    self.location.href = "consumerPwdEdit?id=" + id
}
function operaConsumer(idList, stateName, isFlag) {
    var url = baseUrl + "userMgr/operaConsumer";
    $.ajax({
        url: url,
        data: "idList=" + idList + "&stateName=" + stateName + "&isFlag=" + isFlag,
        success: function (data) {
            if (data.success) {
                if (isFlag == true) {
                    isFlag = false;
                } else if (isFlag == false) {
                    isFlag = true;
                }
                if (idList instanceof Array) {
                    for (var i = idList.length - 1; i >= 0; i--) {
                        if (stateName == "userState")$("#consumerGrid").setRowData(idList[i], {id: idList[i], userState: isFlag});
                        if (stateName == "uploadState")$("#consumerGrid").setRowData(idList[i], {id: idList[i], uploadState: isFlag});
                        if (stateName == "canDownload")$("#consumerGrid").setRowData(idList[i], {id: idList[i], canDownload: isFlag});
                        if (stateName == "canPlay")$("#consumerGrid").setRowData(idList[i], {id: idList[i], canPlay: isFlag});
                        if (stateName == "canComment")$("#consumerGrid").setRowData(idList[i], {id: idList[i], canComment: isFlag});
                        if (stateName == "isRegister")$("#consumerGrid").setRowData(idList[i], {id: idList[i], isRegister: isFlag});
                    }
                } else {
                    if (stateName == "userState")$("#consumerGrid").setRowData(idList, {id: idList, userState: isFlag});
                    if (stateName == "uploadState")$("#consumerGrid").setRowData(idList, {id: idList, uploadState: isFlag});
                    if (stateName == "canDownload")$("#consumerGrid").setRowData(idList, {id: idList, canDownload: isFlag});
                    if (stateName == "canPlay")$("#consumerGrid").setRowData(idList, {id: idList, canPlay: isFlag});
                    if (stateName == "canComment")$("#consumerGrid").setRowData(idList, {id: idList, canComment: isFlag});
                    if (stateName == "isRegister")$("#consumerGrid").setRowData(idList, {id: idList, isRegister: isFlag});
                }
            }
            myAlert(data.msg);
        }
    })
}
function operate(action, stateName, isFlag) {
    var ids = $("#consumerGrid").jqGrid("getGridParam", "selarrrow");
    if (ids.length == 0 && action != "addConsumer") {
        myAlert("请至少选择一条记录！");
        return false;
    }
    if (action == "deleteConsumer") {
        deleteConsumer(ids);
    } else if (action == "operaConsumer") {
        operaConsumer(ids, stateName, isFlag);
    } else if (action == "addConsumer") {
        addConsumer();
    }
}
$(function () {
    if ($('#editPage').val() == '') {
        $('#editPage').val('1');
    }
    var searchToolBar = $("#searchToolBar");
    var searchName = searchToolBar.find("input[name='searchName']").val();
    var searchNickName = searchToolBar.find("input[name='searchNickName']").val();
    var searchTrueName = searchToolBar.find("input[name='searchTrueName']").val();
    var searchCollege = searchToolBar.find("select option:selected").val();
    var userRole = $('#userRole').val();
    $("#consumerGrid").jqGrid({
        url: baseUrl + "userMgr/consumerList?searchName=" + searchName + "&searchNickName=" + searchNickName + "&searchTrueName=" + searchTrueName + "&searchCollege=" + searchCollege + "&userRole=" + userRole,
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "账号", "昵称", "真实姓名", "状态", "上传", "下载", "点播", "评论", "用户审核", "操作", ""],
        colModel: [
            { name: "id", width: 50, search: false},
            { name: "name", width: 100, search: true},
            { name: "nickname", width: 80, search: true},
            { name: "trueName", width: 50, search: false},
            { name: "userState", width: 50, search: false, formatter: userStateFormatter},
            { name: "uploadState", width: 80, search: false, formatter: uploadStateFormatter},
            { name: "canDownload", width: 80, search: false, formatter: downloadFormatter},
            { name: "canPlay", width: 80, search: false, formatter: playFormatter},
            { name: "canComment", width: 80, search: false, formatter: commentFormatter},
            { name: "isRegister", width: 80, search: false, formatter: examineFormatter},
            { name: "操作", width: 300, search: false, sortable: false, formatter: operationFormatter},
            { name: "userRole", hidden:true}
        ],
        page: parseInt($('#editPage').val()),
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
    });
    $("#searchBtn").click(function () {
        var searchToolBar = $("#searchToolBar");
        var searchName = searchToolBar.find("input[name='searchName']").val();
        var searchNickName = searchToolBar.find("input[name='searchNickName']").val();
        var searchTrueName = searchToolBar.find("input[name='searchTrueName']").val();
        var searchCollege = searchToolBar.find("select option:selected").val();
        var url = baseUrl + "userMgr/consumerList";
        var postData = {
            searchName: null,
            searchNickName: null,
            searchTrueName: null,
            searchCollege: null

        };
        if (!searchName.isEmpty()) {
            postData.searchName = searchName;
        }
        if (!searchNickName.isEmpty()) {
            postData.searchNickName = searchNickName;
        }
        if (!searchTrueName.isEmpty()) {
            postData.searchTrueName = searchTrueName;
        }
        if (searchCollege != "-1") {
            postData.searchCollege = searchCollege;
        }
        if (url.substring(url.length - 1) == "&") {
            url = url.substring(0, url.length - 1);
        }
        jQuery("#consumerGrid").jqGrid("setGridParam", {url: url, page: 1, postData: postData}).trigger("reloadGrid");
    })

})