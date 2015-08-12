var ServerNodeTree;
$(function () {
    var setting = {
        async: {
            autoParam: ["id=parentId"],
            enable: true,
            url: baseUrl + "distributeApply/serverNodeMgr"
        },
        callback: {
            onAsyncSuccess: zTreeOnAsyncSuccess,
            onClick: zTreeOnClick
        },
        edit: {
            enable: false,
            showRemoveBtn: false,
            showRenameBtn: false
        }
    };
    ServerNodeTree = $.fn.zTree.init($("#serverNodeTree"), setting);

    var createRootServerNodeDialog = $("#createRootServerNodeDialog");
    createRootServerNodeDialog.dialog({title: "创建节点名称", autoOpen: false, width: 500, height: 300, buttons: {
        "提交": function () {
            $("#createServerNodeForm").submit();
        },
        "取消": function () {
            createRootServerNodeDialog.dialog("close");
        }
    }});

    $("#createChildServerNodeDialog").dialog({title: "创建子节点", autoOpen: false, width: 500, height: 300, buttons: {
        "提交": function () {
            $("#createChildServerNodeForm").submit();
        },
        "取消": function () {
            $("#createChildServerNodeDialog").dialog("close");
        }
    }});
    $("#removeServerNode").click(function () {
        var selectId = $("#selectServerNodeTypeId").val();
        if (selectId != '') {
            $.post(baseUrl + "distributeApply/deleteServerNode", {id: selectId}, function (data) {
                if (data.success) {
                    myAlert("删除节点成功!");
                    var node = ServerNodeTree.getNodeByParam("id", selectId, null);
                    ServerNodeTree.removeNode(node);
                } else {
                    myAlert(data.msg);
                }
            });
        } else {
            myAlert("请选择一个根节点！");
        }
    });
    $("#createServerNode").click(function () {
        $.post(baseUrl + "distributeApply/isExistLocalWebIPAndPort", function (data) {
            if (data.success) {
                createRootServerNodeDialog.dialog("open");
            } else {
                myAlert(data.msg);
            }
        });

    });
    $("#createChildServerNode").click(function () {
        $.post(baseUrl + "distributeApply/isExistLocalWebIPAndPort", function (data) {
            if (data.success) {
                var selectId = $("#selectServerNodeTypeId").val();
                if (selectId == '') {
                    alert("请先选择一个根节点!")
                } else {
                    $("#parentId").val(selectId);
                    $("#createChildServerNodeDialog").dialog("open");
                }
            } else {
                myAlert(data.msg);
            }
        });
    })

});
function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = ServerNodeTree.getNodes();
}
function zTreeOnClick(event, treeId, treeNode) {
    $("#id").val(treeNode.id);
    $("#name").val(treeNode.name);
    $("#ip").val(treeNode.ip);
    $("#port").val(treeNode.port);
    $("#selectServerNodeTypeId").val(treeNode.id);

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

function playLinkFormatter(cellvalue, options, rowObject) {
    var ipAddress = $("#ip").val();
    var port = $("#port").val();
    var bUrl = "http://" + ipAddress + ":" + port + "/";
    var url = bUrl + "program/showProgram?id=" + rowObject.id;
    var html = "<a href='" + url + "' target='_blank' title='" + rowObject.name + "'>" + cellvalue.substr(0, 15) + "</a>";
    return html;

}

function operatorFormatter(cellvalue, options, rowObject) {
    var html = "<button class=\"zTree_send\" onclick=\"send_btn('" + rowObject.id + "')\">分发资源</button>";
    return html;
}

function resources_btn(tag) {
    var selectServerNodeTypeId = document.getElementById("selectServerNodeTypeId").value;
    if (selectServerNodeTypeId == "") {
        alert("请先选择树节点!")
    } else {
        var url = baseUrl + "distributeApply/resourceProgram";
        var pars = {serverNodeId: selectServerNodeTypeId, programId: tag};
        $.ajax({
            url: url,
            data: pars,
            success: function (data) {
                if (data.success) {
                    alert(data.msg);
                } else {
                    $("#error_div").empty().append(data.msg);
                }

            }
        })
    }
}

$(function () {

    var ip = $("input[name=localNodeIp]").val();
    var port = $("input[name=localNodePort]").val();
    var id = $("input[name=localNodeId]").val();
    var url = baseUrl + "distributeApply/programAjaxServerNode";

    var isLocalNode = $("#isLocalNode");


    var postData = {ip: ip, port: port, id: id};
    //jQuery("#programGrid").jqGrid("setGridParam", {url: url, page: 1, postData: postData}).trigger("reloadGrid");

    $("#programGrid").jqGrid({
        postData: postData,
        url: url,
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "资源名称", "创建日期", "推荐数", "收藏数", "能否下载", "点播数", "状态", "操作"],
        colModel: [
            { name: "id", width: 50, search: false, sortable: false},
            { name: "name", width: 70, search: false, sortable: false, formatter: playLinkFormatter},
            { name: "dateCreated", width: 60, search: false, sortable: false},
            { name: "recommendNum", width: 60, search: false, sortable: false},
            { name: "collectNum", width: 60, search: false, sortable: false},
            { name: "canDownload", width: 60, search: false, sortable: false, formatter: downloadFormatter},
            { name: "frequency", width: 60, search: false, sortable: false},
            { name: "state", width: 60, search: false, sortable: false},
            {name: "操作", width: 60, search: false, sortable: false, formatter: operatorFormatter}
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
        // multiselect: true,
        gridComplete: function () {
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length * 25;
            $(this).setGridHeight(newRowHeight + 25);
            initPaneScrollbar('center', myLayout.panes.center);
        }
    });


});

function send_btn(tag) {
    var selectServerNodeTypeId = document.getElementById("selectServerNodeTypeId").value;
    if (selectServerNodeTypeId == "") {
        alert("请先选择树节点!")
    } else {
        var url = baseUrl + "distributeApply/sendProgram";
        var pars = {serverNodeId: selectServerNodeTypeId, programId: tag};
        $.ajax({
            url: url,
            data: pars,
            success: function (data) {
                if (data.success) {
                    alert(data.msg);
                } else {
                    $("#errors").empty().append(data.msg);
                }
            }
        })
    }

}