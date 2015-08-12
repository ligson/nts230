
var zTree;
$(function(){
    var setting={
        async:{
            autoParam:["id=parentId"],
            enable:true,
            url:baseUrl+"userMgr/listRoleTree"
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
    }
    zTree = $.fn.zTree.init($("#zTree"), setting);

    $("#createRoleDialog").dialog({title: "创建角色", autoOpen: false, width: 500, height: 260, buttons: {
        "提交": function () {
            //$(this).dialog("close");
            //$("#createRoleForm").submit();
            var parentId = $("#parentId").val();
            var roleName = $("#roleName").val();
            if(roleName==""){
                myAlert("角色名称不能为空");
            }else{
                $.post(baseUrl+"userMgr/roleCreate",{parentId:parentId,name:roleName},function(data){
                    if(data.success){
                        window.location.reload();
                    }else{
                        myAlert(data.msg)
                    }
                })
            }
        },
        "取消": function () {
            $("#createRoleDialog").dialog("close");
        }
    }});

    $("#createResourceDialog").dialog({title: "角色添加权限", autoOpen: false, width: 600, height: 500, buttons: {
        "提交": function () {
            $("#createResourceForm").submit();
        },
        "取消": function () {
            $("#createResourceDialog").dialog("close");
        }
    }});
    $("#removeRole").click(function () {
        var selectId = $("#selectRoleTypeId").val();
        if (selectId!='') {
            $.post(baseUrl + "userMgr/roleDelete", {id: selectId}, function (data) {
                if (data.success) {
                    alert(data.msg);
                    var node = zTree.getNodeByParam("id", selectId, null);
                    zTree.removeNode(node);
                } else {
                    alert(data.msg);
                }
            });
        } else {
            myAlert("请选择一个根节点！");
        }
    });
    $("#createRole").click(function () {
        var selectId=$("#selectRoleTypeId").val();
        $("#parentId").val(selectId);
        $("#createRoleDialog").dialog("open");
    });
    $("#createResource").click(function(){
        var selectId=$("#selectRoleTypeId").val();
        if(selectId==''){
            alert("请选择要加权限的角色")
        }else{
            $("#createResourceDialog").dialog("open");
        }
    });

    $("#resourcesGrid").jqGrid({
        datatype: "json",
        mtype: "POST",
        search: false,
        colNames: ["ID", "角色", "权限", "操作"],
        colModel: [
            { name: "id", width: 50, search: false},
            { name: "role", width: 100, search: false},
            { name: "resource", width: 200, search: false},
            {name: "操作", width: 70, search: false, sortable: false, formatter: operatorFormatter}
        ],
        pager: "#GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        width:750,
        height:260,
        sortorder:"desc"
    }).trigger("reloadGrid");

    $("#appendDiv").hide();
})

function operatorFormatter(cellvalue, options, rowObject) {
    var html = "<input type=\"button\" class=\"clear_border\" value=\"删除权限\" onclick=\"removeResource('" + rowObject.id + "', '" + rowObject.roleId + "')\" />";
    return html;
}

function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
}
function zTreeOnClick(event, treeId, treeNode) {
    $("#id").val(treeNode.id);
    $("#name").val(treeNode.name);
    $("#selectRoleTypeId").val(treeNode.id);
    $("#resourceId").val(treeNode.id);
    $("#resourceName").val(treeNode.name);
    var postData = {id: treeNode.id};

    var url=baseUrl + "userMgr/resourceList";
    jQuery("#resourcesGrid").jqGrid("setGridParam", {url: url,page:1,postData:postData}).trigger("reloadGrid");
    $("#appendDiv").show();
}

function removeResource(tag,roleId){
    var url = baseUrl + "userMgr/resourceRemove";
    var pars = {id: tag, roleId: roleId};
    myConfirm("确定删除角色权限吗?", null, function () {
        $.ajax({
            url:url,
            data:pars,
            success:function(data){
                if(data.success){
                    alert(data.msg);
                    $("#"+tag).remove();
                }else{
                    alert(data.msg);
                }
            }
        })
    })

}

function changeControllerName(){
    var id=$("#selectCheck").val();
    var roleId = $("#selectRoleTypeId").val();
    var url= baseUrl + "userMgr/appendActionNameList";
    var pars={id:id,roleId:roleId};
    $.ajax({
        url:url,
        data:pars,
        success:function(data){
            $("#appendSelect").empty().append(data.appendHtml);
            // 绑定全选择/取消事件
            $("input[name='userRoleAll']").click(function(){
                $("input[name='actionId']").prop("checked", $(this).prop("checked"));
            });
            // 如果所有选项都选择了，设置全选择为checked
            var allChecked = true;
            $("input[name=actionId]").each(function(){
                if(!$(this).prop("checked")) {
                    allChecked = false;
                    return;
                }
            });
            $("input[name='userRoleAll']").prop("checked",allChecked);
        }
    })
}

function updateRoleBtn(){
    var id = $("#id").val();
    var name = $("#name").val();
    if(id==""){
        myAlert("请选择需要修改的节点");
    }else
    if(name==""){
        myAlert("角色名称不能为空");
    }else{
        $.post(baseUrl+"userMgr/roleUpdate",{id:id,name:name},function(data){
            if(data.success){
                window.location.reload();
            }else{
                myAlert(data.msg)
            }
        })
    }
}
