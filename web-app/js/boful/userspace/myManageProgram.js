var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
var zTree;
$(function () {
    var checkboxList = [];
    var setting = {
        async: {
            enable: true,
            url: baseUrl + "my/listProgramCategory",
            autoParam: [ "id=pid" ]
        },
        callback: {
            onAsyncSuccess: zTreeOnAsyncSuccess,
            onClick: zTreeOnClick
        }
    };
    zTree = $.fn.zTree.init($("#zTree"), setting);


    var selectCategoryBtn = $("#selectCategoryBtn");
    var categoryDialog = $("#selectCategoryDialog");
    categoryDialog.dialog({
        autoOpen: false,
        width: 500,
        height: 480,
        resizable: false,
        modal: true,
        buttons: {
            "确定": function () {

                var selectId = $("#selectedCategoryId").val();
                var clickTreeId = zTree.getSelectedNodes();
                if (!clickTreeId.length == 1) {
                    alert("请选择!!");
                    return false;
                }
                if (clickTreeId[0].isParent) {
                    alert("请选择节点，不要选择目录！！");
                    return false;
                }
                var programCategoryId = clickTreeId[0].id;
                var programIds = "";
                for (var i = 0; i < checkboxList.size(); i++) {
                    programIds += checkboxList[i].value;
                    if (i != checkboxList.size() - 1) {
                        programIds += ",";
                    }
                }
                $.post(baseUrl + "program/changeProgramCategory", {
                    programIds: programIds,
                    programCategoryId: programCategoryId
                }, function (data) {
                    alert(data.msg);
                })
                $(this).dialog("close");
            },
            "关闭": function () {
                $(this).dialog("close");
            }
        }
    });
    selectCategoryBtn.click(function () {
        checkboxList = $("input:checked");
        if (checkboxList.size() == 0) {
            alert("您还没有选择！！");
            return false;
        }
        categoryDialog.dialog("open");
    });

    //增加继续上传
    $("#addBtn").click(function () {
        var tb = $("#tb");
        var fileUpload = $("#fileUpload");
        console.log(fileUpload.html())
        tb.append(fileUpload.html())
    });

    $(".resources_upload_save").click(function () {
        var inputArr = $(".resources_upload_lists").find(".upload_suc_title input");
        for (var i = 0; i < inputArr.length; i++) {
            if ((inputArr[i].value) == "") {
                alert("资源的标题不能为空");
                return false;
            }
        }
    });
});

function deleteUserActivityList(pId) {
    if(pId !="") {
        if(confirm("您确定要删除吗?")) {
            var url = baseUrl + "my/toRecycler?idList=" + pId;
            window.location.href = url;
        }
    } else {
        if (!hasChecked("idList")) {
            alert("至少选择一条需要删除的资源!");
            return;
        }
        var idList = getCheckBoxListStr("idList");
        if(confirm("您确定要都删除吗?")){
            var url = baseUrl + "my/toRecycler?idList=" + idList;
            window.location.href = url;
        }
    }
}
function programSet(className, isFlag) {
    if (!hasChecked("idList")) {
        alert("至少选择一条需要删除的资源!");
        return;
    }
    var idList = getCheckBoxListStr("idList");
    var url = baseUrl + "my/setMyProgramState?idList=";
    url += idList;
    url += "&className=";
    url += className;
    url += "&isFlag=";
    url += isFlag;
    window.location.href = url;
}
function submitSch() {
    $("#programForm").submit();
}

function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
}
function zTreeOnClick(event, treeId, treeNode) {
    if (!treeNode.isParent) {
        $("#selectedCategoryId").val(treeNode.id);
        $("#selectedCategoryName").empty().append(treeNode.name);
    }
}

