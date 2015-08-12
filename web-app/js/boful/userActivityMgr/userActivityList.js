/**
 * jqGrid页面展示
 */
$(function () {
    if($('#editPage').val() == ''){
        $('#editPage').val('1');
    }
    $("#userActivityListId").jqGrid({
        url: baseUrl + "userActivityMgr/userActivityListAsJson",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "标题", "创建者", "开始时间", "结束时间", "审批状态", "活动状态", "作品数", "投票数", "创建时间", "修改", "删除"],
        colModel: [
            {name: "id", width: 40},
            {name: "name", width: 150},
            {name: "createName", width: 100},
            {name: "startTime", width: 100},
            {name: "endTime", width: 100},
            {name: "approval", width: 100, formatter: userActivityApprovalFormatter},
            {name: "isOpen", width: 100, sortable: false, formatter: userActivityIsOpenFormatter},
            {name: "workNum", width: 80},
            {name: "voteNum", width: 80},
            {name: "dateCreated", width: 100},
            {name: "修改", width: 80, sortable: false, formatter: userActiviyFormaterEdit},
            {name: "删除", width: 80, sortable: false, formatter: userActiviyFormaterDelete}
        ],
        page: parseInt($('#editPage').val()),
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
        var url = baseUrl + "userActivityMgr/userActivityListAsJson";
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
        $("#userActivityListId").jqGrid("setGridParam", {url: url, page: 1, postData: postData}).trigger("reloadGrid");
    });
})
/**
 * 设置审批显示
 * @param cellvalue
 * @param options
 * @param rowObject
 * @returns {string}
 */
function userActivityApprovalFormatter(cellvalue, options, rowObject) {
    var userActivityApproval = "";
    if (cellvalue == 1) {
        userActivityApproval = "审批未通过";
    }
    if (cellvalue == 2) {
        userActivityApproval = "待审批";
    }
    if (cellvalue == 3) {
        userActivityApproval = "审批通过";
    }
    return userActivityApproval;
}
/**
 * 设置活动状态显示
 * @param cellvalue
 * @param options
 * @param rowObject
 * @returns {string}
 */
function userActivityIsOpenFormatter(cellvalue, options, rowObject) {
    var html = "";
    if (cellvalue) {
        html = "<input id='openStataId" + rowObject.id + "' class='ui-button searchbtn' type='button' value='开启' onclick='userActivityOpenChange(" + rowObject.id + ",\"false\")'/>"
    } else {
        html = "<input id='openStataId" + rowObject.id + "' class='ui-button searchbtn' type='button' value='关闭' onclick='userActivityOpenChange(" + rowObject.id + ",\"true\")'/>"
    }
    return html;
}
/**
 * 添加userActivity删除按钮
 * @param cellvalue
 * @param options
 * @param rowObject
 */
function userActiviyFormaterDelete(cellvalue, options, rowObject) {
    var html = "<input  class='ui-button searchbtn' type='button' value='删除' onclick='userActivityDelete(" + rowObject.id + ")'/>"
    return html;
}
/**
 * 添加userActivity修改按钮
 * @param cellvalue
 * @param options
 * @param rowObject
 */
function userActiviyFormaterEdit(cellvalue, options, rowObject) {
    var html = "<a class='ui-button searchbtn' href='"+baseUrl+"userActivityMgr/userActivityEdit?editPage="+jQuery("#userActivityListId").getGridParam('page')+"&userActivityId=" + rowObject.id + "'>修改</a>"
    return html;
}
/**
 * 删除userActivity
 * @param userActivityId
 * @returns {string}
 */
function userActivityDelete(userActivityId) {
    myConfirm("确认要删除吗？", null, function () {
        $.post(baseUrl + "userActivityMgr/userActivityDelete", {userActivityId: userActivityId}, function (data) {
            if (data.success) {
                $("#" + userActivityId).remove();
                myAlert(data.message);
            } else {
                myAlert(data.message);
            }
        })
    }, null)
}
/**
 * 批量删除userActivity
 */
function userActivityDeletes() {
    myConfirm("确认都要删除吗？", null, function () {
        var userActivityIds = $("#userActivityListId").jqGrid("getGridParam", "selarrrow");
        if (userActivityIds.length == 0) {
            myAlert("请至少选择一条记录！");
        } else {
            var userActivityId = userActivityIds.toString();
            $.post(baseUrl + "userActivityMgr/userActivityDelete", {
                userActivityId: userActivityId
            }, function (data) {
                if (data.success) {
                    for (var i = 0; i < userActivityIds.length; i++) {
                        if (userActivityIds[i] == data.errorId) {
                            myAlert(data.message);
                            break;
                        }
                        $("#" + userActivityIds[i]).remove();
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
 * 更改userActivity活动状态
 * @param userActivityId
 * @param changeOpen
 */
function userActivityOpenChange(userActivityId, changeOpen) {
    $.post(baseUrl + "userActivityMgr/userActivityOpenChange", {
        userActivityId: userActivityId,
        changeOpen: changeOpen
    }, function (data) {
        if (data.success) {
            var userActivityOpen = data.userActivityOpen;
            var openStataButton = $("#openStataId" + userActivityId);
            if (userActivityOpen) {
                openStataButton.val("开启");
                openStataButton.attr("onClick", "userActivityOpenChange(" + userActivityId + ",\"false\")");
            } else {
                openStataButton.val("关闭");
                openStataButton.attr("onClick", "userActivityOpenChange(" + userActivityId + ",\"true\")");
            }
        } else {
            myAlert(data.message);
        }
    })
}
/**
 * 批量更改userActivity活动状态
 * @param changeOpen
 */
function userActivityOpenChanges(changeOpen) {
    myConfirm("确认都要更改吗？", null, function () {
        var userActivityIds = $("#userActivityListId").jqGrid("getGridParam", "selarrrow");
        if (userActivityIds.length == 0) {
            myAlert("请至少选择一条记录！");
        } else {
            var userActivityId = userActivityIds.toString();
            $.post(baseUrl + "userActivityMgr/userActivityOpenChange", {
                userActivityId: userActivityId,
                changeOpen: changeOpen
            }, function (data) {
                if (data.success) {
                    if (data.userActivityOpen) {
                        for (var i = userActivityIds.length - 1; i >= 0; i--) {
                            //修改某一行的值
                            $("#openStataId" + userActivityIds[i]).val("开启");
                            $("#openStataId" + userActivityIds[i]).attr("onClick", "userActivityOpenChange(" + userActivityIds[i] + ",\"false\")");
                            $("#userActivityListId").setSelection(userActivityIds[i]);
                        }
                    } else {
                        for (var i = userActivityIds.length - 1; i >= 0; i--) {
                            //修改某一行的值
                            $("#openStataId" + userActivityIds[i]).val("关闭");
                            $("#openStataId" + userActivityIds[i]).attr("onClick", "userActivityOpenChange(" + userActivityIds[i] + ",\"true\")");
                            $("#userActivityListId").setSelection(userActivityIds[i]);
                        }
                    }
                } else {
                    myAlert(data.message);
                }
            })
        }
    }, null)
}
/**
 * 审批userActivity
 * @param approval
 *  true 通过审批
 *  false 不通过审批
 */
function userActivityApproval(approval) {
    myConfirm("确认都要更改吗？", null, function () {
        var userActivityIds = $("#userActivityListId").jqGrid("getGridParam", "selarrrow");
        if (userActivityIds.length == 0) {
            myAlert("请至少选择一条记录！");
        } else {
            var userActivityId = userActivityIds.toString();
            $.post(baseUrl + "userActivityMgr/userActivityApproval", {
                userActivityId: userActivityId,
                approval: approval
            }, function (data) {
                if (data.success) {
                    if (approval == "true") {
                        for (var i = userActivityIds.length - 1; i >= 0; i--) {
                            //修改某一行的值
                            var approvalText = $("#userActivityListId").getCell(userActivityIds[i], 'approval');
                            if (approvalText == "待审批") {
                                $("#userActivityListId").setCell(userActivityIds[i], 'approval', 3);
                            }
                            $("#userActivityListId").setSelection(userActivityIds[i]);
                        }
                    } else {
                        for (var i = userActivityIds.length - 1; i >= 0; i--) {
                            //修改某一行的值
                            var approvalText = $("#userActivityListId").getCell(userActivityIds[i], 'approval');
                            if (approvalText == "待审批") {
                                $("#userActivityListId").setCell(userActivityIds[i], 'approval', 1);
                            }
                            $("#userActivityListId").setSelection(userActivityIds[i]);
                        }
                    }
                } else {
                    myAlert(data.message);
                }
            })
        }
    }, null)
}

function createUserActivity(url) {
    location.href = url ;
}