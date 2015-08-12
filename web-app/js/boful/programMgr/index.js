/**
 * Created by ligson on 14-3-26.
 */
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if ('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
function setGroupListDiv() {
    var editDiv = document.getElementById("groupList");
    editDiv.style.display = "block";
    setDivPos(editDiv, 400, editDiv.offsetWidth);
    document.getElementById("applyToLib").style.display = "none";//同时只有一个层显示
}

function setApplyToLibDiv() {
    var editDiv = document.getElementById("applyToLib");
    editDiv.style.display = "block";
    setDivPos(editDiv, 400, editDiv.offsetWidth);
    document.getElementById("groupList").style.display = "none";//同时只有一个层显示
}

function checkGroup(theForm) {
    return true;
}

function onOperateSuccess(divId) {
    hideWnd(divId);
    alert("操作成功！");
}

function onOperateFailure(divId) {
    alert("操作失败！");
    //hideWnd(divId);
}

function onCanAll(theObj) {
    var divObj = document.getElementById("groupListTab");
    if (divObj) divObj.style.display = theObj.value == 1 ? "none" : "block";
}

function submitSch() {
    //document.form1.action = "${createLink(controller: 'my', action: 'manageProgram')}?state="+theForm.state.value+"&max="+theForm.max.value;
    //self.location.href = "";
    //document.form2.offset.value = 0;
    document.form1.submit();
}

function onPageNumPer(max) {
    document.form1.max.value = max;
    submitSch();
}

function onApplyOperateSuccess(divId) {
    //hideWnd(divId);
    //alert("操作成功！");
    document.form1.submit();
}

function operate(controller, action, operation) {
    //获取选择行ID
    var ids = $("#programGrid").jqGrid("getGridParam", "selarrrow");
    if (ids.length == 0) {
        myAlert("请至少选择一条记录！");
        return false;
    }
    ;
    var url = "/" + controller + "/" + action;
    if (action == "userGroupList") {
        window.location.href = url + "?idList=" + ids + "&operation=" + operation;
    } else {
        $.ajax({
            url: url,
            data: "idList=" + ids + "&operation=" + operation,
            success: function (data) {
                if (data.success) {
                    myAlert(data.message);
                    var stateName = data.stateName;
                    for (var i = ids.length - 1; i >= 0; i--) {
                        //修改某一行的值
                        $("#programGrid").setRowData(ids[i], {state: stateName[i]});
                        $("#programGrid").setSelection(ids[i]);
                    }
                } else {
                    if (data.state.length == 0) {
                        myAlert('登陆超时，请重新登录。');
                    } else {
                        myAlert(data.state);
                    }
                }
            }
        })

    }
}

function operate2(controller, action, operation, val) {
    //获取选择行ID
    var ids = $("#programGrid").jqGrid("getGridParam", "selarrrow");
    if (ids.length == 0) {
        myAlert("请至少选择一条记录！");
        return false;
    }

    var url = baseUrl + controller + "/" + action;
    $.ajax({
        url: url,
        data: "idList=" + ids + "&operation=" + operation + "&val=" + val,
        success: function (data) {
            if (data.success) {
                for (var i = ids.length - 1; i >= 0; i--) {
                    //修改某一行的值
                    if (operation == "canDownload") {
                        $("#programGrid").setRowData(ids[i], {canDownload: val});
                        if (val == '0') {
                            $("#programGrid").setRowData(ids[i], {canAllDownload: val});
                        }
                    }
                    if (operation == "canAllDownload")$("#programGrid").setRowData(ids[i], {canAllDownload: val});
                    if (operation == "canPlay") {
                        $("#programGrid").setRowData(ids[i], {canPlay: val});
                        if (val == '0') {
                            $("#programGrid").setRowData(ids[i], {canAllPlay: val});
                        }
                    }
                    if (operation == "canAllPlay")$("#programGrid").setRowData(ids[i], {canAllPlay: val});
                    $("#programGrid").setSelection(ids[i]);
                }
                myAlert(data.message);
            } else {
                if (data.state.length == 0) {
                    myAlert('登陆超时，请重新登录。');
                } else {
                    myAlert(data.state);
                }
            }
        }
    })
}

//批量更改公开状态
function changePublics(controller, action, operation) {
    //获取选择行ID
    var ids = $("#programGrid").jqGrid("getGridParam", "selarrrow");
    if (ids.length == 0) {
        myAlert("请至少选择一条记录！");
        return false;
    }
    ;
    var url = baseUrl + controller + "/" + action;
    if (action == "userGroupList") {
        window.location.href = url + "?idList=" + ids + "&operation=" + operation;
    } else {
        $.ajax({
            url: url,
            data: "idList=" + ids + "&operation=" + operation,
            success: function (data) {
                if (data.success) {
                    myAlert(data.message);
                    var publicstatic = data.publicstatic;
                    for (var i = ids.length - 1; i >= 0; i--) {
                        //修改某一行的值
                        $("#publicStataId" + ids[i]).val(publicstatic);
                        $("#programGrid").setSelection(ids[i]);
                    }
                } else {
                    if (data.message.length == 0) {
                        myAlert('登陆超时，请重新登录。');
                    } else {
                        myAlert(data.message);
                    }
                }
            }
        })

    }
}
//单个更改公开状态
function changePublic(pId, operation) {
    $.post(baseUrl + "programMgr/changePublicStata", {idList: pId, operation: operation}, function (data) {
        if (data.success) {
            myAlert(data.message);
            var publicstatic = data.publicstatic;
            $("#publicStataId" + pId).val(publicstatic);
            if (publicstatic == "是") {
                $("#publicStataId" + pId).attr("onClick", "changePublic(" + pId + ",\"changeNotPublic\")");
            } else {
                $("#publicStataId" + pId).attr("onClick", "changePublic(" + pId + ",\"changePublic\")");
            }
        } else {
            if (data.message.length == 0) {
                myAlert('登陆超时，请重新登录。');
            } else {
                myAlert(data.message);
            }
        }
    })
}
function operate1(controller, action, operation) {

    if (operation != "clearRecycler") {
        if (hasChecked("idList") == false) {
            alert("请至少选择一条记录！");
            return false;
        }
    }

    if (operation == "clearRecycler") {
        if (confirm("确实要清空回收站吗？清空后就不能再恢复了。") == false) return;
    }
    else if (action == "delete") {
        if (confirm("确实要删除该资源吗？删除后就不能再恢复了。") == false) return;
    }

    if (operation != null) document.form1.fromModel.value = operation;
    if (operation != "public" && operation != "close") document.form1.offset.value = 0;

    document.form1.action = baseUrl + controller + "/" + action;
    document.form1.submit();
}
function init() {
    //form1.schState.value = "${CTools.nullToZero(params.schState)}";
    //changePageImg(${CTools.nullToOne(params.max)});
}
$(function () {
    $("#sub_btn").click(function () {
        $("#form2").submit();
    });

});
//-->

function operationFormatter(cellvalue, options, rowObject) {
    var baseInfoHref = baseUrl + "programMgr/programInfoEdit?id=" + rowObject.id;
    var metaHref = baseUrl + "programMgr/editMetaContent?id=" + rowObject.id;
    var serialList = baseUrl + "programMgr/editSerialList?id=" + rowObject.id;
    var str = "<a class='jqgfirstrow_a_s' href='" + baseInfoHref + "' target='_blank' class='ui-button'>基本信息</a><a class='jqgfirstrow_a_s' href='" + metaHref + "'  target='_blank'>元数据</a><a class='jqgfirstrow_a_s'href='" + serialList + "'  target='_blank'>子文件列表</a>";
    return str;

}

function deleteFormatter(cellvalue, options, rowObject) {
    var deleteHref = baseUrl + "";
    return "<input class='ui-button searchbtn' type='button' value='删除' onclick='confirmDel(" + rowObject.id + ")'/>";

}
function moreDelBtn() {
    //获取选择行ID
    var ids = $("#programGrid").jqGrid("getGridParam", "selarrrow");
    if (ids.length == 0) {
        myAlert("请至少选择一条记录！");
        return false;
    }
    confirmDel(ids);
}

function moreSyncBtn() {
    var url = baseUrl + "programMgr/sysncTransCode";
    $.ajax({
        url: url,
        success: function (data) {
            if (data.success) {
                myAlert("同步成功");
            } else {
                myAlert('同步失败');
            }
        }
    });
}

function syncProgramBtn() {
    //获取选择行ID
    var ids = $("#programGrid").jqGrid("getGridParam", "selarrrow");
    if (ids.length == 0) {
        myAlert("请至少选择一条记录！");
        return false;
    }
    var url = baseUrl + "programMgr/syncIndexProgram";
    $.ajax({
        url: url,
        data: "idList=" + ids,
        success: function (data) {
            if (data.success) {
                myAlert("同步成功");
            } else {
                myAlert(data.msg);
            }
        }
    });
}


function confirmDel(programId) {
    myConfirm("确认要删除吗？", null, function () {
        $.ajax({
            url: baseUrl + "programMgr/toRecycler",
            data: "idList=" + programId,
            success: function (data) {
                if (data.success) {
                    myAlert(data.message);
                    if (programId instanceof Array) {
                        for (var i = programId.length - 1; i >= 0; i--) {
                            $("#" + programId[i]).remove();
                        }
                    } else {
                        $("#" + programId).remove();
                    }
                } else {
                    if (data.message.length == 0) {
                        myAlert('登陆超时，请重新登录。');
                    } else {
                        myAlert(data.message);
                    }
                }
            }
        });
    }, null);
}
//公开状态
function programPublicStata(cellvalue, options, rowObject) {
    var publicButton = "";
    if (cellvalue == true) {
        publicButton = "<input class='ui-button searchbtn' id='publicStataId" + rowObject.id + "' type='button' value='是' onclick='changePublic(" + rowObject.id + ",\"changeNotPublic\")'/>";
    } else {
        publicButton = "<input class='ui-button searchbtn' id='publicStataId" + rowObject.id + "' type='button' value='否' onclick='changePublic(" + rowObject.id + ",\"changePublic\")'/>";
    }
    return publicButton;

}

function playLinkFormatter(cellvalue, options, rowObject) {
    var state = rowObject.transcodeState;
    var html = "";
    if (state == 2 || state == 100) { //转码成功, 无需转码
        var url = baseUrl + "program/showProgram?id=" + rowObject.id;
        html = "<a href='" + url + "' target='_blank' title='" + rowObject.name + "'>" + cellvalue.substr(0, 15) + "</a>";
    } else {
        html = "<span title='" + rowObject.name + "'>" + cellvalue.substr(0, 15) + "</span>";
    }
    return html;
}
function downloadFormatter(cellvalue, options, rowObject) {
    var canDownload = rowObject.canDownload;
    var app = "";

    if (canDownload == true) {
        app = "允许下载";
    } else {
        app = "禁止下载";
    }

    return "<span>" + app + "</span>"
}
function canAllDownloadFormatter(cellvalue, options, rowObject) {
    var canAllDownload = rowObject.canAllDownload;
    var appAll = "";
    if (canAllDownload == true) {
        appAll = "允许所有用户组下载";
    } else {
        appAll = "禁止所有用户组下载";
    }
    return "<span>" + appAll + "</span>";
}
function playFormatter(cellvalue, options, rowObject) {
    var canPlay = rowObject.canPlay;
    var app = "";

    if (canPlay == true) {
        app = "允许点播";
    } else {
        app = "禁止点播";
    }

    return "<span>" + app + "</span>"
}
function canAllPlayFormatter(cellvalue, options, rowObject) {
    var canAllPlay = rowObject.canAllPlay;
    var appAll = "";
    if (canAllPlay == true) {
        appAll = "允许所有用户组点播";
    } else {
        appAll = "禁止所有用户组点播";
    }
    return "<span>" + appAll + "</span>";
}
function fromNodeFormatter(cellvalue, options, rowObject) {
    var nodeName = "";
    if (rowObject.fromNode) {
        nodeName = rowObject.fromNode.name;
    } else {
        nodeName = "本地";
    }
    return "<span>" + nodeName + "</span>";
}
function transCodeStateFormatter(cellvalue, options, rowObject) {
    var state = rowObject.transcodeState;
    var stateVal = "";
    if (state == 2) {
        stateVal = "转码成功";
    } else if (state == 3) {
        stateVal = "转码失败";
    } else if (state == 0) {
        stateVal = "等待转码";
    } else if (state == 100) {
        stateVal = "无需转码";
    } else if (state == 1) {
        stateVal = "正在转码";
    } else if (state == 4) {
        stateVal = "转码队列中";
    }else if(state==5){
        stateVal="部分转码";
    }
    return "<span>" + stateVal + "</span>";
}

function otherOptionFormatter(cellvalue, options, rowObject) {
    var option = rowObject.otherOption;
    var optionVal = "";
    if (option == 0) {
        optionVal = "视频";
    } else if (option == 1) {
        optionVal = "音频";
    } else if (option == 16) {
        optionVal = "图片";
    } else if (option == 8) {
        optionVal = "文档";
    } else if (option == 128) {
        optionVal = "课程";
    } else if (option == -1) {
        optionVal = "全部";
    } else if (option = 6){
        optionVal = "flash动画";
    }
    return "<span>" + optionVal + "</span>";
}

$(function () {
    $("#programGrid").jqGrid({
        url: baseUrl + "programMgr/programList2",
        datatype: "json",
        mtype: "POST",
        search: true,
//        colNames: ["ID", "资源名称", "转码状态", "分类", "类别", "创建者", "元数据标准", "创建日期", "来源", "下载", "用户(组)下载", "点播", "用户(组)点播", "状态", "推荐数", "收藏数", "点播数", "公开", "修改", "删除"],
        colNames: ["ID", "资源名称", "转码状态", "分类", "类别", "创建者", "元数据标准", "创建日期", "来源", "下载", "用户组下载", "点播", "用户组点播", "状态", "推荐数", "收藏数", "点播数", "公开", "修改", "删除"],
        colModel: [
            { name: "id", width: 50, search: false},
            { name: "name", width: 200, search: true, formatter: playLinkFormatter},
            { name: "transcodeState", width: 70, search: false, formatter: transCodeStateFormatter},
            { name: "categoryName", width: 70, search: false},
            { name: "otherOption", width: 70, search: true, formatter: otherOptionFormatter},
            { name: "consumer", width: 60, search: true},
            { name: "directoryName", width: 60, search: true},
            { name: "dateCreated", width: 80, align: "right", search: false},
            { name: "fromNode", width: 40, align: "right", search: false, formatter: fromNodeFormatter},
            { name: "canDownload", width: 50, align: "right", search: false, formatter: downloadFormatter},
            { name: "canAllDownload", width: 120, align: "right", search: false, formatter: canAllDownloadFormatter},
            { name: "canPlay", width: 50, align: "right", search: false, formatter: playFormatter},
            { name: "canAllPlay", width: 120, align: "right", search: false, formatter: canAllPlayFormatter},
            { name: "state", width: 60, sortable: false, search: true},
            { name: "recommendNum", width: 30, search: true},
            { name: "collectNum", width: 30, search: true},
            { name: "frequency", width: 30, search: true},
            { name: "canPublic", width: 50, sortable: true, formatter: programPublicStata, search: true},
            { name: "修改", width: 150, sortable: false, formatter: operationFormatter, search: false},
            { name: "删除", width: 50, sortable: false, formatter: deleteFormatter, search: false}
        ],
        pager: "#GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        rowList: [10, 20, 50],
        //caption: "My first grid",
        autowidth: true,
        sortorder: "desc",
        height: 500,
        multiselect: true,
        gridComplete: function () {
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length * 25;
            $(this).setGridHeight(newRowHeight + 25);
            initPaneScrollbar('center', myLayout.panes.center);
        }
    });

    //jQuery("#programGrid").jqGrid('navGrid','#GridPaper', {edit:false,add:false,del:false}, {multipleSearch:true} );

    $("#searchBtn").click(function () {
        var searchToolBar = $("#searchToolBar");
        var name = searchToolBar.find("input[name='name']").val();
        //var consumer = searchToolBar.find("input[name='consumer']").val();
        var state = searchToolBar.find("select[name='state'] option:selected").val();
        var directoryId = searchToolBar.find("select[name='directoryId'] option:selected").val();
        var otherOption = searchToolBar.find("select[name='otherOption'] option:selected").val();
        var canDownload = searchToolBar.find("select[name='canDownload'] option:selected").val();
        var canPlay = searchToolBar.find("select[name='canPlay'] option:selected").val();
        var canPublic = searchToolBar.find("select[name='canPublic'] option:selected").val();
        var url = baseUrl + "programMgr/programList2";
        var postData = {
            name: null,
            state: null
        };

        if (!name.isEmpty()) {
            postData.name = name;
        } else {
            postData.name = "";
        }

        if (state != "-1") {
            postData.state = state;
        } else {
            postData.state = "";
        }

        if (directoryId != "-1") {
            postData.directoryId = directoryId;
        } else {
            postData.directoryId = "";
        }

        if (otherOption != "-1") {
            postData.otherOption = otherOption;
        } else {
            postData.otherOption = "";
        }

        if (canDownload != "-1") {
            postData.canDownload = canDownload;
        } else {
            postData.canDownload = "";
        }

        if (canPlay != "-1") {
            postData.canPlay = canPlay;
        } else {
            postData.canPlay = "";
        }

        if (canPublic != "-1") {
            postData.canPublic = canPublic;
        } else {
            postData.canPublic = "";
        }

        var transcodeState = searchToolBar.find("select[name='transcodeState'] option:selected").val();
        if (transcodeState != "-1") {
            postData.transcodeState = transcodeState;
        } else {
            postData.transcodeState = "";
        }

        jQuery("#programGrid").jqGrid("setGridParam", {url: url, page: 1, postData: postData}).trigger("reloadGrid");
    });
});