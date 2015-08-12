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
            url:baseUrl+"userSpecial/queryCategoryAndFile"
        },
        callback: {
            onAsyncSuccess: zTreeOnAsyncSuccess,
            onClick: zTreeOnClick,
            onCheck: zTreeOnCheck
        },
        edit: {
            enable: false,
            showRemoveBtn: false,
            showRenameBtn: false
        },
        check:{
          enable:true,
          chkStyle:"checkbox",
          chkboxType:{"Y":"s","N":"s"}
        }
    };
    zTree = $.fn.zTree.init($("#zTree"), setting);
    zTree = $.fn.zTree.init($("#zTree1"), setting);
});
function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
}

function zTreeOnCheck(event, treeId, treeNode){

}

function queryCheckedNodes(){
    var strs ="";
    var treeObj = $.fn.zTree.getZTreeObj("zTree");
    var nodes = treeObj.getCheckedNodes(true);
    for(var i=0;i<nodes.length;i++){
        if(nodes[i].fileHash!=null){
            if(i==nodes.length-1)strs+=nodes[i].id;
            else strs+=nodes[i].id+",";
        }
    }
    return strs;
}

function queryCheckedNodes1(){
    var strs ="";
    var treeObj = $.fn.zTree.getZTreeObj("zTree1");
    var nodes = treeObj.getCheckedNodes(true);
    for(var i=0;i<nodes.length;i++){
        if(nodes[i].fileHash!=null){
            if(i==nodes.length-1)strs+=nodes[i].id;
            else strs+=nodes[i].id+",";
        }
    }
    return strs;
}

function zTreeOnClick(event, treeId, treeNode) {

}



