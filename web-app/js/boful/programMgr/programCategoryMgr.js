/**
 * Created with IntelliJ IDEA.
 * User: ligson
 * Date: 13-9-18
 * Time: 下午2:05
 * To change this template use File | Settings | File Templates.
 */
var zTree;
var setting = {
    async: {
        enable: true,
        url: baseUrl + "programMgr/listProgramCategory",
        autoParam: [ "id=pid" ]
    },
    callback: {
        onAsyncSuccess: zTreeOnAsyncSuccess,
        onClick: zTreeOnClick,
        onCheck: zTreeOnCheck,
        onDrop: zTreeOnDrop,
        onDrag: zTreeOnDrag
    },
    edit: {
        enable: true,
        showRemoveBtn: false,
        showRenameBtn: false,
        drag: {
            isCopy: false,
            isMove: true,
            prev: true,
            next: true,
            inner: true
        }
    },
    check: {
        enable: true,
        chkStyle: "checkbox",
        chkboxType: { "Y": "ps", "N": "s" },
        autoCheckTrigger: true
    },
    view: {
        addDiyDom: addDiyDom
    }
};

$(function () {

    zTree = $.fn.zTree.init($("#zTree"), setting);

    //同步分类
    $("#synProgramCategory").click(function () {
        $.post(baseUrl + "programMgr/synchronizeProgramCategory", function (data) {
            if (!data.success) {
                myAlert(data);
            } else {
                myAlert("分类同步成功!")
            }
        });
    });

    //清除选择
    $("#clearSelect").click(function () {
        if (zTree) {
            var nodes = zTree.getSelectedNodes();
            for (var i = 0; i < nodes.length; i++) {
                zTree.cancelSelectedNode(nodes[i]);
            }
        }
    });

    //删除节点
    $("#removeProgramType").click(function () {
        var selectId = $("#selectProgramTypeId").val();
        if (!selectId.isEmpty()) {
            $.post(baseUrl + "programMgr/removeProgramType", {id: selectId}, function (data) {
                if (data.success) {
                    myAlert("删除成功!");
                    var node = zTree.getNodeByParam("id", selectId, null);
                    var imgTd = $("#imgTd");
                    imgTd.find("img").eq(0).attr("src", "");
                    imgTd.find("img").eq(0).attr("style", "display:none");
                    $("#posterTd").find("img").eq(0).attr("src", "");
                    $("#posterTd").find("img").eq(0).attr("style", "display:none");
                    $("#defaultProgramPosterHash").val("");
                    $("#defaultProgramPosterPath").val("");
                    $("#showDefaultPosterName").empty();
                    $("#updateProgramCategoryForm select[name='updateDirectoryId'] option:first").attr("selected", "selected");
                    $("#updateProgramCategoryForm input[name='updateUploadPath']").val('');

                    $("#updateProgramCategoryForm input[name='updateId']").val('');
                    $("#updateProgramCategoryForm input[name='updateIsDisplay']").val('');
                    $("#updateProgramCategoryForm input[name='updatePCategoryName']").val('');
                    $("#updateProgramCategoryForm select[name='updateMediaType'] option:first").attr("selected", "selected");
                    $("#updateProgramCategoryForm textarea[name='updateDesc']").val('');
                    if(node.pid == 1) {
                        $("#directoryTr").show();
                        $("#uploadTr").show();
                        $("#imgTr").show();
                        $("#posterTr").show();
                    } else {
                        $("#directoryTr").hide();
                        $("#uploadTr").hide();
                        $("#imgTr").hide();
                        $("#posterTr").hide();
                    }
                    zTree.removeNode(node);

                } else {
                    myAlert("删除失败，原因:" + data.msg + "!");
                }
            });
        } else {
            myAlert("请选择一个根分类！");
        }
    });

    //定位节点
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

    //创建子节点点击事件
    $("#createSubProgramCategory").click(function () {
        if (!$("#selectProgramCategoryTypeId").val().isEmpty()) {
            $("#createSubProgramDialog input[name='categoryName']").val('');
            $("#createSubProgramDialog select option:first").attr("selected", "selected");
            $("#createSubProgramDialog textarea[name='description']").val('');
            $("#createSubProgramDialog").dialog("open");
        } else {
            myAlert("请选择一个根分类！");
        }
    });

    $("#createProgramCategory").click(function() {
        $("#createProgramCategoryDialog").dialog("open");
    });

    //创建字节点对话框
    $("#createSubProgramDialog").dialog({modal: true, title: "创建节点", autoOpen: false, width: 700, height: 500, buttons: {
        "提交": function () {
            var dialog = $("#createSubProgramDialog");
            var name = dialog.find("input[name=categoryName]").val();
            var desc = dialog.find("textarea[name=description]").val();
            var mediaType = dialog.find("select[name=mediaType]").val();
            var directoryId = dialog.find("select[name=directoryId]").val();
            var pid = $("#selectProgramCategoryTypeId").val();
            var isDisplay = $("#selectProgramCategoryDisplayType").val(); //显示状态为选中的父分类显示状态
            if (name.isEmpty() || pid.isEmpty()) {
                myAlert("分类名称不能为空!");
                return;
            } else {
                $("#createProgramCategoryForm").submit();
            }
        }, "取消": function () {
            $("#createSubProgramDialog").dialog("close");
        }
    }});


    //创建资源库
    $("#createProgramCategoryDialog").dialog({modal: true, title: "创建资源库", autoOpen: false, width: 700, height: 500, buttons: {
        "提交": function () {
            var dialog = $("#createProgramCategoryDialog");
            var name = dialog.find("input[name=categoryLibraryName]").val();
            if (name.isEmpty()) {
                myAlert("资源库名称不能为空!");
                return;
            } else {
                $("#createProgramCategoryLibraryForm").submit();
            }
        }, "取消": function () {
            $("#createProgramCategoryDialog").dialog("close");
        }
    }});

    //修改子节点
    $("#modifyProgramType").click(function () {
        var name = $("#programTypeName").val();
        var desc = $("#programTypeDesc").val();
        var selectProgramTypeId = $("#selectProgramTypeId").val();
        var uploadPath = $("#updateUploadPath").val();
        if (name.isEmpty() || selectProgramTypeId.isEmpty()) {
            myAlert("名称不允许为空!");
            return false;
        } else if(!uploadPath.isEmpty() && uploadPath != ""){
            var regx=/[a-zA-Z]:(\\([0-9a-zA-Z]+))+|(\/([0-9a-zA-Z]+))+/;
            if(!regx.test(uploadPath)){
                alert("路径格式错误,必须是服务器的绝对路径！");
                return false;
            }
        }
        var selectEl = $("select[name=updateMediaType]");
        var option = selectEl.find("option:selected");

        $("#updateProgramCategoryForm").submit();
    });

    /*    $("#createRootProgramDialog").dialog({title: "创建节点名称", autoOpen: false, width: 570, height: 360, buttons: {
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
     });*/
});


function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
    // 设置选中状态
    treeNodeCheckSetting(nodes);
}

/**
 * 节点选中状态初始化
 * @param nodes
 */
function treeNodeCheckSetting(nodes) {
    if (nodes) {
        for (var i = 0; i < nodes.length; i++) {
            if (nodes[i].name == '默认资源库') {
                zTree.setChkDisabled(nodes[i], true, false, true);
            }
            if (nodes[i].isDisplay == 0) {
                nodes[i].checked = true;
                zTree.updateNode(nodes[i], false);
            } else if (nodes[i].isDisplay == 1) {
                nodes[i].checked = false;
                zTree.updateNode(nodes[i], false);
            }
            var nodeChildren = nodes[i].children;
            treeNodeCheckSetting(nodeChildren);
        }
    } else {
        return;
    }
}

/**
 * 节点点击事件
 * @param event
 * @param treeId
 * @param treeNode
 */
function zTreeOnClick(event, treeId, treeNode) {
    if (treeNode.name == '默认资源库' || treeNode.chkDisabled == true || treeNode.chkDisabled == 'true') {
        myAlert("此资源库不允许修改！");
    } else {
        $("#programTypeName").val(treeNode.name);
        $("#programTypeDesc").val(treeNode.description);
        var imgTd = $("#imgTd");
        if (treeNode.level == 0) { //如果是第一级分类,可以设置上传路径,图片,元数据标准
            //图片
            var imgName = treeNode.img;
            var htmlStr = "";
            if(imgName && imgName!="") {
                var src = baseUrl + "upload/programCategoryImg/" + imgName;
                imgTd.find("img").eq(0).attr("src", src);
                imgTd.find("img").eq(0).attr("style", "display:block");
            } else {
                imgTd.find("img").eq(0).attr("src", "");
                imgTd.find("img").eq(0).attr("style", "display:none");
            }

            $("#updateUploadPath").val(treeNode.uploadPath);
            if(treeNode.directoryId != "") {
                $(".tree_content select[name=updateDirectoryId]").val(treeNode.directoryId);
            } else {
                $(".tree_content select[name=updateDirectoryId]").val("-1");
            }


            //资源海报图片
            var posterTd = $("#posterTd");
            var defaultProgramPosterHash = treeNode.defaultProgramPosterHash;
            var defaultProgramPosterPath = treeNode.defaultProgramPosterPath;
            if (defaultProgramPosterHash && defaultProgramPosterHash != "") {
                var defaultPosterSrc = ""
                $.post(baseUrl + "ntsService/posterUserFileImg", {fileHash: defaultProgramPosterHash, size:'40x40'}, function (data) {
                    if (data.src) {
                        defaultPosterSrc = data.src;
                        posterTd.find("img").eq(0).attr("src", defaultPosterSrc);
                        posterTd.find("img").eq(0).attr("style", "display:block");
                        $("#posterTr").show();
                    } else {
                        posterTd.find("img").eq(0).attr("src", "");
                        posterTd.find("img").eq(0).attr("style", "display:none");
                        $("#posterTr").show();
                    }
                });
            } else {
                posterTd.find("img").eq(0).attr("src", "");
                posterTd.find("img").eq(0).attr("style", "display:none");
                $("#posterTr").show();
            }

            $("#directoryTr").show();
            $("#uploadTr").show();
            $("#imgTr").show();
            $("#posterFormatTr").hide();
        } else {  // 子分类不设置
            $(".tree_content select[name=updateDirectoryId]").val("-1");
            $("#updateUploadPath").val("");
            imgTd.find("img").eq(0).attr("src", "");
            imgTd.find("img").eq(0).attr("style", "display:none");
            $("#posterTd").find("img").eq(0).attr("src", "");
            $("#posterTd").find("img").eq(0).attr("style", "display:none");
            $("#defaultProgramPosterHash").val("");
            $("#defaultProgramPosterPath").val("");
            $("#showDefaultPosterName").empty();

            $("#directoryTr").hide();
            $("#uploadTr").hide();
            $("#imgTr").hide();
            $("#posterTr").hide();
            $("#posterFormatTr").show();
            if(treeNode.posterFormatType == "1"){
                $("#updateProgramCategoryForm").find("input[name='posterFormat']").eq(1).prop("checked",true);
            } else {
                $("#updateProgramCategoryForm").find("input[name='posterFormat']").eq(0).prop("checked",true);
            }
        }

        $("#selectProgramTypeId").val(treeNode.id);
        $("#selectProgramDisplayType").val(treeNode.isDisplay);

        $("#selectProgramCategoryTypeId").val(treeNode.id);
        $("#selectProgramCategoryDisplayType").val(treeNode.isDisplay);

        //if(treeNode.mediaType){
        $(".tree_content select[name=updateMediaType]").val(treeNode.mediaType);


        //var selectEl = $(".tree_content select[name=mediaType]");
        //selectEl.find("option").removeAttr("selected");
        //var option = selectEl.find("option[value="+treeNode.mediaType+"]");
        //option.attr("selected",true);
        //option.remove();
        //var opt = "<option value='"+treeNode.mediaType+"' selected=\"selected\">"+option.html()+"</option>";
        //selectEl.prepend(opt);
        //}
    }

}

/**
 * 修改资源显示状态
 * @param treeId
 * @param selectProgramTypeId
 * @param isDisplay
 */
function modifyProgramCategoryIsDisplay(treeId, selectProgramTypeId, isDisplay) {
    $.ajax({
        type: 'post',
        url: baseUrl + "programMgr/modifyProgramCategoryIsDisplay",
        data: {id: selectProgramTypeId, isDisplay: isDisplay},
        dataType: 'json',
        success: function (data) {
            if (!data.success) {
                myAlert(data.msg);
            } else {
                var node = zTree.getNodeByParam("id", selectProgramTypeId, null);
                if (node) {
                    node.isDisplay = isDisplay;
                    if (isDisplay == 0) {
                        node.checked = true;
                    } else if (isDisplay == 1) {
                        node.checked = false;
                    }
                    addDiyDom(treeId, node);
                    zTree.updateNode(node);
                }
            }
        }
    });
}

// 设置选中状态
function zTreeOnCheck(event, treeId, treeNode) {
    if (treeNode.name == '默认资源库') {
        myAlert("此资源库不允许修改！");
    } else {
        var name = treeNode.name;
        var desc = treeNode.description;
        var selectProgramTypeId = treeNode.id;
        var mediaType = treeNode.mediaType;
        var isDisplay;
        if (treeNode.checked) {
            isDisplay = 0;
        } else {
            isDisplay = 1;
        }
        if (mediaType == 0 && isDisplay == 0 && treeNode.level == 0) {
            myConfirm("资源库类别为未知时,前台默认不显示;确认要设置为显示状态吗？", null, function () {
                modifyProgramCategoryIsDisplay(treeId, selectProgramTypeId, isDisplay);
            }, null);
        } else {
            modifyProgramCategoryIsDisplay(treeId, selectProgramTypeId, isDisplay);
        }
    }
}

//修改资源分类位置
function zTreeOnDrop(event, treeId, treeNodes, targetNode, moveType) {
    var targetId = targetNode ? targetNode.id : "isRoot";
    if (targetId != "isRoot") {
        for (var i = 0; i < treeNodes.length; i++) {
            $.ajax({
                type: 'post',
                url: baseUrl + "programMgr/modifyProgramCategoryOrderIndex",
                data: {id: treeNodes[0].id, targetId: targetId, moveType: moveType},
                dataType: 'json',
                success: function (data) {
                    if (!data.success) {
                        myAlert(data.msg);
                    } else {
                        myAlert("顺序修改成功!");
                    }
                }
            });
        }
    }
};
//修改资源分类位置前触发
function zTreeOnDrag(event, treeId, treeNodes) {
    for (var i = 0; i < treeNodes.length; i++) {
        if (treeNodes[0].name == '默认资源库') {
            myAlert("此资源库不允许拖动！");
            return false;
        }
    }
}
//添加节点显示标志
function addDiyDom(treeId, treeNode) {
    if (treeNode.isDisplay == 0) {
        treeNode.checked = true;
        zTree.updateNode(treeNode, false);
    } else if (treeNode.isDisplay == 1) {
        treeNode.checked = false;
        zTree.updateNode(treeNode, false);
    }

    var aObj = $("#" + treeNode.tId + "_a");
    if ($("#text_" + treeNode.id).length > 0) {
        $("#text_" + treeNode.id).remove();
    }
    var spanStr = '';
    if (treeNode.isDisplay == 0) {
        spanStr = "<span id='text_" + treeNode.id + "' style='color: #C0C0C0'>&nbsp;&nbsp;显示</span>";
    } else if (treeNode.isDisplay == 1) {
        spanStr = "<span id='text_" + treeNode.id + "' style='color: #C0C0C0'>&nbsp;&nbsp;不显示</span>";
    }
    aObj.append(spanStr);
}

/**
 * 创建子分类check
 */
function checkSubCategoryValue() {
    var name = $("#createProgramCategoryForm input[name='categoryName']").val();
    if (name.isEmpty()) {
        myAlert("分类名称不允许为空!");
        return false;
    }
}

/**
 * 创建资源库check
 */
function checkCategoryValue() {
    var name = $("#createProgramCategoryLibraryForm input[name='categoryLibraryName']").val();
    var uploadPath = $("#createProgramCategoryLibraryForm input[name='libraryUploadPath']").val();
    if (name.isEmpty()) {
        myAlert("资源库名称不允许为空!");
        return false;
    } else if(!uploadPath.isEmpty() && uploadPath != ""){
        var regx=/[a-zA-Z]:(\\([0-9a-zA-Z]+))+|(\/([0-9a-zA-Z]+))+/;
        if(!regx.test(uploadPath)){
            myAlert("路径格式错误,必须是服务器的绝对路径！");
            return false;
        }
    }
}