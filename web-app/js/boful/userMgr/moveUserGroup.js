
var zTree;
$(function(){
    var setting={
        async:{
            autoParam:["id=parentId"],
            enable:true,
            url:baseUrl+"userMgr/listRoleTreeForUserGroup"
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
            url:baseUrl+"userMgr/listRoleTreeForUserGroup"
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

    $("#createUserGroupRoleDialog").dialog({title: "用户组添加角色", autoOpen: false, width: 500, height: 260, buttons: {
        "提交": function () {
            var selectTypeId=$("#roleId").val();
            if(selectTypeId){
                $("#createUserGroupForm").submit();
            }else{
                alert("请选择角色!")
            }

        },
        "取消": function () {
            //$("#createUserGroupRoleDialog").dialog("close");
            $( this ).dialog( "close" );
        }
    }});
    $("#moveUserGroupRoleDialog").dialog({title: "用户组角色移动", autoOpen: false, width: 500, height: 260, buttons: {
        "提交": function () {
            var selectTypeId=$("#roleId1").val();
            if(selectTypeId){
                $("#moveUserGroupForm").submit();
            }else{
                alert("请选择角色!")
            }
        },
        "取消": function () {
            //$("#moveUserGroupRoleDialog").dialog("close");
            $( this ).dialog( "close" );
        }
    }});


});
function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
}
function zTreeOnClick1(event, treeId, treeNode) {
    $("#id").val(treeNode.id);
    $("#name").val(treeNode.name);
    $("#roleId").val(treeNode.id);
    $("#roleId1").val(treeNode.id);
    $("#selectTypeId").val(treeNode.id);
    $("#userGroupRoleTypeId").val(treeNode.id);

}
function zTreeOnClick(event, treeId, treeNode) {
    $("#id").val(treeNode.id);
    $("#name").val(treeNode.name);
    $("#roleId").val(treeNode.id);
    $("#roleId1").val(treeNode.id);
    $("#selectTypeId").val(treeNode.id);
    $("#userGroupRoleTypeId").val(treeNode.id);
    var roleId=treeNode.id;
    var url=baseUrl + "userMgr/userGroupsAjax";
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
function createUserGroup(name,id){
    var selectId=$("#selectRoleTypeId").val();
    $("#id"+id).val(id);
    $("#roleId").val(selectId);
    $("#userGroupName").val(name);
    $("#idList").val(id);
    $("#createUserGroupRoleDialog").dialog("open");
}

function removeUserGroup(tag){
    myConfirm("确定删除用户组角色吗?", null, function () {
        $.post(baseUrl + "userMgr/userGroupRemove", {userGroupId:tag}, function (data) {
            if (data.success) {
                alert(data.msg);
                window.location.reload()
            } else {
                alert(data.msg);
            }
        })
    });
}

function moveUserGroup(name,tag){
    $("#idList1").val(tag);
    $("#userGroupName1").val(name);
    $("#moveUserGroupRoleDialog").dialog("open");
}
function checkId(tag){
    var idCheck=document.getElementById("id"+tag);
    if(idCheck.checked==true){
        idCheck.value=tag;
    }else{
        idCheck.value='';
    }
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
    $("#createUserGroupRoleDialog").dialog("open");
}

function checkAllUserGroup(idList){
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