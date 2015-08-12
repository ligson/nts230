
var ServerNodeTree;
$(function(){
    var setting={
        async:{
            autoParam:["id=parentId"],
            enable:true,
            url:baseUrl+"distributeApply/serverNodeMgr"
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

    $("#createChildServerNodeDialog").dialog({title:"创建子节点",autoOpen:false,width:500,height:300,buttons:{
        "提交":function(){
            $("#createChildServerNodeForm").submit();
        },
        "取消":function(){
            $("#createChildServerNodeDialog").dialog("close");
        }
    }});
    $("#createParentServerNodeDialog").dialog({title:"创建上级节点",autoOpen:false,width:500,height:300,buttons:{
        "提交":function(){
            $("#createParentServerNodeForm").submit();
        },
        "取消":function(){
            $("#createParentServerNodeDialog").dialog("close");
        }
    }});
    $("#removeServerNode").click(function () {
        var selectId = $("#selectServerNodeTypeId").val();
        if (selectId!='') {
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
        $.post(baseUrl+"distributeApply/isExistLocalWebIPAndPort",function(data){
            if(data.success){
                createRootServerNodeDialog.dialog("open");
            }else{
                myAlert(data.msg);
            }
        });

    });
    $("#createChildServerNode").click(function(){
        $.post(baseUrl+"distributeApply/isExistLocalWebIPAndPort",function(data){
            if(data.success){
                var selectId=$("#selectServerNodeTypeId").val();
                if(selectId==''){
                    alert("请先选择一个根节点!")
                }else{
                    $("#parentId").val(selectId);
                    $("#createChildServerNodeDialog").dialog("open");
                }
            }else{
                myAlert(data.msg);
            }
        });
    })
    $("#createParentServerNode").click(function(){
        $.post(baseUrl+"distributeApply/isExistLocalWebIPAndPort",function(data){
            if(data.success){
                var selectId=$("#selectServerNodeTypeId").val();
                if(selectId==''){
                    alert("请先选择一个节点!")
                }else{
                    $("#childId").val(selectId);
                    $("#createParentServerNodeDialog").dialog("open");
                }
            }else{
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
    var appendInput = "";
    if(treeNode.isSendObject==true){
        appendInput="<input style=\"width: 25px;\" type=\"radio\" value=\"true\" name=\"isSendObject\" checked/>是<input style=\"width: 25px;\" type=\"radio\" value=\"false\" name=\"isSendObject\"/>否";
    }else{
        appendInput="<input style=\"width: 25px;\" type=\"radio\" value=\"true\" name=\"isSendObject\"/>是<input style=\"width: 25px;\" type=\"radio\" value=\"false\" name=\"isSendObject\" checked/>否";
    }
    $("#updateObj").empty().append(appendInput);
}