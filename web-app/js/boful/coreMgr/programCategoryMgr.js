/**
 * Created with IntelliJ IDEA.
 * User: ligson
 * Date: 13-9-18
 * Time: 下午2:05
 * To change this template use File | Settings | File Templates.
 */
var zTree;
$(function () {

    var setting = {
        async: {
            enable: true,
            url: baseUrl + "coreMgr/listProgramCategory",
            autoParam: [ "id=pid" ]
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
    zTree = $.fn.zTree.init($("#zTree"), setting);


    $("#createRootProgramDialog").dialog({title: "创建节点名称", autoOpen: false, width: 570, height: 360, buttons: {
        "提交": function () {
            //$(this).dialog("close");
            $("#createProgramCategoryForm").submit();
        },
        "取消": function () {
            $("#createRootProgramDialog").dialog("close");
        }
    }});

    $("#createProgramCategory").click(function () {
        $("#createRootProgramDialog").dialog("open");
    });

    $("#createSubProgramDialog").dialog({title: "创建节点名称", autoOpen: false, width: 570, height: 360, buttons: {
        "提交": function () {
            //$(this).dialog("close");
            var dialog = $("#createSubProgramDialog");
            var name = dialog.find("input[name=categoryName]").val();
            var desc = dialog.find("textarea[name=description]").val();
            var mediaType = dialog.find("select[name=mediaType]").val();
            var pid = $("#selectProgramTypeId").val();
            if (name.isEmpty() || pid.isEmpty()) {
                myAlert("分类名称不能为空!");
                return;
            }
            $.post(baseUrl + "coreMgr/createProgramCategory", {pid: pid, categoryName: name, desc: desc,mediaType:mediaType, returnType: 'json'}, function (data) {
                if (data.success) {
                    var node = zTree.getNodeByParam("id", pid, null);
                    if (node) {
                        zTree.addNodes(node, {id: data.id, name: name.trim(), pid: pid});
                    }
                    $("#createSubProgramDialog").dialog("close");
                    myAlert("创建成功！","提示");
                } else {
                    myAlert(data.msg);
                }
            });
        }, "取消": function () {
            $("#createSubProgramDialog").dialog("close");
        }
    }});

    $("#createSubProgramCategory").click(function () {
        if (!$("#selectProgramTypeId").val().isEmpty()) {
            $("#createSubProgramDialog").dialog("open");
        } else {
            myAlert("请选择一个根分类！");
        }
    });

    $("#clearSelect").click(function () {
        if (zTree) {
            var nodes = zTree.getSelectedNodes();
            for (var i = 0; i < nodes.length; i++) {
                zTree.cancelSelectedNode(nodes[i]);
            }
        }
    });

    $("#modifyProgramType").click(function () {
        var name = $("#programTypeName").val();
        var desc = $("#programTypeDesc").val();
        var selectProgramTypeId = $("#selectProgramTypeId").val();
        if (name.isEmpty() || selectProgramTypeId.isEmpty()) {
            myAlert("名称不允许为空!");
            return;
        }
        $.post(baseUrl + "coreMgr/modifyProgramType", {id: selectProgramTypeId, name: name.trim(), description: desc.trim()}, function (data) {
            if (!data.success) {
                myAlert(data)
            } else {
                var node = zTree.getNodeByParam("id", selectProgramTypeId, null);
                if (node) {
                    node.name = name.trim();
                    node.description = desc.trim();
                    zTree.updateNode(node);
                }
            }
        });
    });

    $("#removeProgramType").click(function () {
        var selectId = $("#selectProgramTypeId").val();
        if (!selectId.isEmpty()) {
            $.post(baseUrl + "coreMgr/removeProgramType", {id: selectId}, function (data) {
                if (data.success) {
                    myAlert("删除分类成功!");
                    var node = zTree.getNodeByParam("id", selectId, null);
                    zTree.removeNode(node);
                } else {
                    myAlert("删除分类失败，原因:" + data.msg + "!");
                }
            });
        } else {
            myAlert("请选择一个根分类！");
        }
    });

    $("#expandProgramType").click(function () {
        var selectId = $("#selectProgramTypeId").val();
        if (!selectId.isEmpty()) {
            var node = zTree.getNodeByParam("id", selectId, null);
            var parentNode = node.getParentNode();
            if (parentNode) {
                zTree.expandNode(parentNode, true, false, false);
            }

        } else {
            myAlert("未选择分类！");
        }
    });
});
function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
}
function zTreeOnClick(event, treeId, treeNode) {

    $("#programTypeName").val(treeNode.name);
    $("#programTypeDesc").val(treeNode.description);
    $("#selectProgramTypeId").val(treeNode.id);
}
