var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
var zTree;
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
    zTree = $.fn.zTree.init($("#zTree"), setting);

    $("#addDistributeDiadog").dialog({autoOpen:false,width:450,height:345,buttons:{
        "确认":function(){
            $("#addDistributeDiadog form[name=addDistribute]").submit();
            $("#addDistributeDiadog").dialog("close");
        },
        "关闭":function(){
            $("#addDistributeDiadog").dialog("close");
        }
    }});
    $("#addDistributeBtn").click(function(){
        var serverNodeId = $("#serverNodeId").val();
        if(serverNodeId==''){
            alert("请先选择需要添加策略的节点树！");
        }else{
            $("#addDistributeDiadog").dialog("open");
        }

    })
});
function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
}
function zTreeOnClick(event, treeId, treeNode) {
    $("#serverNodeId").val(treeNode.id);

}

function deletePolicy(tag){
   var url = baseUrl+"programMgr/deleteDistributePolicy?id="+tag;
   if(confirm("确定删除吗?")){
       window.location.href=url;
   }
}