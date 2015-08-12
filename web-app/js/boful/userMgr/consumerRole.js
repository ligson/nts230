
var zTree;
$(function(){
    var setting={
        async:{
            autoParam:["id=parentId"],
            enable:true,
            url:baseUrl+"userMgr/listRoleTreeForUser"
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
    var setting1={
        async:{
            autoParam:["id=parentId"],
            enable:true,
            url:baseUrl+"userMgr/listRoleTreeForUser"
        },
        callback: {
            onAsyncSuccess: zTreeOnAsyncSuccess,
            onClick: zTreeOnClick1
        },
        edit: {
            enable: false,
            showRemoveBtn: false,
            showRenameBtn: false
        }
    }
    zTree = $.fn.zTree.init($("#zTree"), setting1);
    zTree = $.fn.zTree.init($("#zTree1"), setting1);
    zTree = $.fn.zTree.init($("#zTree2"), setting);

    $("#createConsumerRoleDialog").dialog({title: "用户添加角色", autoOpen: false, width: 500, height: 260, buttons: {
        "提交": function () {
            var selectId=$("#selectRoleTypeId").val();
            if(selectId==''){
                alert("请先选择角色节点")
            }else{
                $("#createConsumerForm").submit();
            }

        },
        "取消": function () {
            $("#createConsumerRoleDialog").dialog("close");
        }
    }});
    $("#moveConsumerRoleDialog").dialog({title: "用户角色移动", autoOpen: false, width: 500, height: 260, buttons: {
        "提交": function () {
            var selectId=$("#selectRoleTypeId1").val();
            if(selectId==''){
                alert("请先选择角色节点")
            }else{
                $("#moveConsumerForm").submit();
            }
        },
        "取消": function () {
            $("#moveConsumerRoleDialog").dialog("close");
        }
    }});

})
function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
}
function zTreeOnClick(event, treeId, treeNode) {
    $("#id").val(treeNode.id);
    $("#name").val(treeNode.name);
    $("#selectRoleTypeId").val(treeNode.id);
    $("#selectRoleTypeId1").val(treeNode.id);
    $("#consumerRoleTypeId").val(treeNode.id);
    var roleId=treeNode.id;
    var url=baseUrl + "userMgr/consumerRoleAjax";
    var pars={roleId:roleId};
    var appendDiv=$("#appendDiv");
    $.ajax({
        url:url,
        data:pars,
        success:function(data){
            appendDiv.empty().append(data.appendHtml);
            $("#page").empty().append(data.page);
        }
    })
}
function zTreeOnClick1(event, treeId, treeNode) {
    $("#id").val(treeNode.id);
    $("#name").val(treeNode.name);
    $("#selectRoleTypeId").val(treeNode.id);
    $("#selectRoleTypeId1").val(treeNode.id);
    $("#consumerRoleTypeId").val(treeNode.id);
}
function createConsumer(name,id){
    var selectId=$("#selectRoleTypeId").val();
    $("#id"+id).val(id);
    $("#roleId").val(selectId);
    $("#consumerName").val(name);
    $("#idList").val(id);
    $("#createConsumerRoleDialog").dialog("open");
}

function moveConsumer(name,tag){
    var selectId=$("#selectRoleTypeId1").val();
    $("#id"+tag).val(tag);
    $("#roleId1").val(selectId);
    $("#consumerName1").val(name);
    $("#idList1").val(tag);
    $("#moveConsumerRoleDialog").dialog("open");
}

function addAll(){
    if (hasChecked("idList") == false) {
        alert("请至少选择一条记录！");
        return false;
    }
    var idList=getCheckBoxListStr("idList");
    var selectId=$("#selectRoleTypeId").val();
    $("#roleId").val(selectId);
    $("#idList").val(idList);
    $("#createConsumerRoleDialog").dialog("open");
}

function removeConsumer(tag){
    myConfirm("确定删除用户角色吗?", null, function () {
        $.post(baseUrl + "userMgr/consumerRemove", {consumerId:tag}, function (data) {
            if (data.success) {
                alert(data.msg);
                window.location.reload();
            } else {
                alert(data.msg);
            }
        })
    })

}

function checkId(tag){
    var idCheck=document.getElementById("id"+tag);
    if(idCheck.checked==true){
        idCheck.value=tag;
    }else{
        idCheck.value='';
    }
}
function checkAllConsumer(idList){
    var id;
    for(var i=0;i<idList.length;i++){
        id=idList[i];
        var idCheck=document.getElementById("id"+id);
        if(idCheck.checked==true){
            idCheck.checked=false;
            idCheck.value='';
        }else{
            idCheck.checked=true;
            idCheck.value=id;
        }
    }
}