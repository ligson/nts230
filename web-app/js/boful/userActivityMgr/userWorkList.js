/**
 * Created by xuzhuo on 14-4-9.
 */
/**
 * 作品页面展示
 */
$(function () {
    $("#userWorkListId").jqGrid({
        url: baseUrl + "userActivityMgr/userWorkListAsJson",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "作品名称", "活动名称", "投票数", "转码状态", "审批状态", "创建时间", "删除"],
        colModel: [
            {name: "id", width: 35},
            {name: "name", width: 200,formatter:hrefFormatter},
            {name: "userActivity.name", width: 200},
            {name: "voteNum", width: 90},
            {name: "transCodeState", width: 90, formatter: userWorkFormaterState},
            {name: "approval", width: 90, formatter: userWorkFormaterApproval},
            {name: "dateCreated", width: 90},
            {name: "删除", width: 90, sortable: false, formatter: userWorkFormaterDelete}
        ],
        pager: "GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        multiselect: true,
        height: 300
    })
    //搜索按钮添加监听事件
    $("#searchBtn").click(function () {
        var url = baseUrl + "userActivityMgr/userWorkListAsJson";
        var searchToolBar = $("#searchToolBar");
        var name = searchToolBar.find("input[name='name']").val();
        var approval = searchToolBar.find("select option:selected").val();
        var postData = {
            name: null,
            approval: null
        };
        if (!name.isEmpty()) {
            postData.name = name;
        }
        if (!approval.isEmpty || approval != 0) {
            postData.approval = approval;
        }
        $("#userWorkListId").jqGrid("setGridParam", {url: url, page: 1, postData: postData}).trigger("reloadGrid");
    });
})

/**
 * 设置转码状态显示显示
 * @param cellvalue
 * @param options
 * @param rowObject
 * @returns {string}
 */
function userWorkFormaterState(cellvalue, options, rowObject){
    var state = rowObject.transCodeState;
    var stateVal = "";
    if (state == 3) {
        stateVal = "已转码";
    } else if (state == 0) {
        stateVal = "不转码";
    } else if (state == 1) {
        stateVal = "待转码";
    } else if (state == 2) {
        stateVal = "正在转码";
    } else if (state == 4) {
        stateVal = "转码失败";
    }
    return "<span>" + stateVal + "</span>";
}

/**
 * 设置审批显示
 * @param cellvalue
 * @param options
 * @param rowObject
 * @returns {string}
 */
function userWorkFormaterApproval(cellvalue, options, rowObject) {
    var userWorkApproval = "";
    if (cellvalue == 1) {
        userWorkApproval = "审批未通过";
    }
    if (cellvalue == 2) {
        userWorkApproval = "待审批";
    }
    if (cellvalue == 3) {
        userWorkApproval = "审批通过";
    }
    return userWorkApproval;
}
/**
 * 添加userWord删除按钮
 * @param cellvalue
 * @param options
 * @param rowObject
 * @returns {string}
 */
function userWorkFormaterDelete(cellvalue, options, rowObject) {
    var html = "<input class='ui-button searchbtn' type='button' value='删除' onclick='userWorkDelete(" + rowObject.id + ")'/>"
    return html;
}
function hrefFormatter(cellvalue, options, rowObject){
    return "<a href='"+baseUrl+"userActivityMgr/showUserWork?id="+rowObject.id+"' target='_blank'>"+rowObject.name+"</a>"
}
/**
 * userWork删除
 * @param userWordId
 */
function userWorkDelete(userWorkId) {
    myConfirm("确认要删除吗？", null, function () {
        $.post(baseUrl + "userActivityMgr/userWorkDelete", {userWorkId: userWorkId}, function (data) {
            if (data.success) {
                $("#" + userWorkId).remove();
                myAlert(data.message);
            } else {
                myAlert(data.message);
            }
        })
    }, null)
}
/**
 * userWork批量删除
 */
function userWorkDeletes() {
    myConfirm("确认都要删除吗？", null, function () {
        var userWorkIds = $("#userWorkListId").jqGrid("getGridParam", "selarrrow");
        if (userWorkIds.length == 0) {
            myAlert("请至少选择一条记录！");
        } else {
            var userWorkId = userWorkIds.toString();
            $.post(baseUrl + "userActivityMgr/userWorkDelete", {
                userWorkId: userWorkId
            }, function (data) {
                if (data.success) {
                    for (var i = 0; i < userWorkIds.length; i++) {
                        if (userWorkIds[i] == data.errorId) {
                            myAlert(data.message);
                            break;
                        }
                        $("#" + userWorkIds[i]).remove();
                    }
                    myAlert(data.message);
                } else {
                    myAlert(data.message);
                }
            })
        }
    }, null)
}
/**
 * 作品审批状态更改
 * @param approval
 */
function userWorkApproval(approval) {
    myConfirm("确认都要更改吗？", null, function () {
        var userWorkIds = $("#userWorkListId").jqGrid("getGridParam", "selarrrow");
        if (userWorkIds.length == 0) {
            myAlert("请至少选择一条记录！");
        } else {
            var userWorkId = userWorkIds.toString();
            $.post(baseUrl + "userActivityMgr/userWorkApproval", {
                userWorkId: userWorkId,
                approval: approval
            }, function (data) {
                if (data.success) {
                    if (approval == "true") {
                        for (var i = userWorkIds.length - 1; i >= 0; i--) {
                            //修改某一行的值
                            $("#userWorkListId").setRowData(userWorkIds[i], {approval: 3});
                            $("#userWorkListId").setSelection(userWorkIds[i]);
                        }
                    } else {
                        for (var i = userWorkIds.length - 1; i >= 0; i--) {
                            //修改某一行的值
                            $("#userWorkListId").setRowData(userWorkIds[i], {approval: 1});
                            $("#userWorkListId").setSelection(userWorkIds[i]);
                        }
                    }
                } else {
                    myAlert(data.message);
                }
            })
        }
    }, null)
}