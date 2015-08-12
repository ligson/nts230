
var zTree;
$(function(){
    var setting={
        async:{
            autoParam:["id=parentId"],
            enable:true,
            url:baseUrl+"userFile/userCategoryList"
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
});
function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
}
function zTreeOnClick(event, treeId, treeNode) {
    $("#categoryDialog #zid").val(treeNode.id);
    $("#categoryDialog #zname").val(treeNode.name);
}



