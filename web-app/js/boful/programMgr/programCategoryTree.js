/**
 * Created with IntelliJ IDEA.
 * User: ligson
 * Date: 13-9-18
 * Time: 下午2:05
 * To change this template use File | Settings | File Templates.
 */
var zTree2;
var idCookies = "";
$(function () {

    var setting = {
        async: {
            enable: true,
            url: baseUrl + "programMgr/listProgramCategory2",
            autoParam: [ "id=pid" ]
        },
        callback: {
            onAsyncSuccess: zTreeOnAsyncSuccess2,
            onClick: zTreeOnClick2,
            onNodeCreated: zTreeOnNodeCreated2
        },
        edit: {
            enable: false,
            showRemoveBtn: false,
            showRenameBtn: false
        }
    };
    zTree2 = $.fn.zTree.init($("#CategoryTree2"), setting);
    $("#accordion").accordion({collapsible: true, heightStyle: "content",width:200});
    //得到所有标签
    var h1s = $(".scrolling-content h1");
    h1s.click(function () {
        $.cookie("program_show_cookie", this.id, {path: "/programMgr"});
    });
    var program_show_cookie = $.cookie("program_show_cookie");
    if (program_show_cookie != null) {
        var program_show_cookie = $.cookie("program_show_cookie");
        $("#" + program_show_cookie).click();
        if (program_show_cookie == "program_teach_Id") {
            $("#" + program_show_cookie).click();
        }
    }

    idCookies = $.cookie('programList_TreeNode_Tid_Cookie');
    /*var programList_parentTreeNode_Tid_Cookie = $.cookie('programList_parentTreeNode_Tid_Cookie');
     if(programList_parentTreeNode_Tid_Cookie!=null &&programList_parentTreeNode_Tid_Cookie!="null"){
     var parentTids = programList_parentTreeNode_Tid_Cookie.split(",");
     for(var i= parentTids.length-1; i>=0; i--){
     zTree2.getNodeByTId(parentTids[i]).expandNode();
     }
     }
     $.cookie('programList_parentTreeNode_Tid_Cookie', null);
     if(programList_TreeNode_Tid_Cookie!=null&&programList_TreeNode_Tid_Cookie!="null"){
     zTree2.getNodeByTId(programList_TreeNode_Tid_Cookie).onclick();
     }
     $.cookie("programList_TreeNode_Tid_Cookie", null);*/
});

function zTreeOnNodeCreated2(event, treeId, treeNode) {
    if (idCookies) {
        var ids = idCookies.split(",");
        var isExist = false;
        for (var i = 0; i < ids.length; i++) {
            if (treeNode) {
                if (treeNode.id == parseInt(ids[i])) {
                    isExist = true;
                }
            }
        }
        if (isExist) {
            //treeNode.open
            zTree2.expandNode(treeNode, true, true, true);
        }

        if (treeNode.id == parseInt(ids[ids.length - 1])) {
            zTree2.selectNode(treeNode);
            reloadGrid(treeNode);
        }
    }



}

function zTreeOnAsyncSuccess2(event, treeId, treeNode, msg) {
    //var nodes = zTree2.getNodes();

}


function reloadGrid(treeNode) {
    try{
        var url = baseUrl + "programMgr/programList2?categoryId=" + treeNode.id;
        jQuery("#programGrid").jqGrid("setGridParam", {url: url, page: 1}).trigger("reloadGrid");
    }catch(e){
    }
    var location_pathname = window.location.pathname;
    if (location_pathname.toString().indexOf("/programMgr/programList") == -1) {
        var treeNodeTid = treeNode.id;

        var nodeIds = [];
        var currentNode = treeNode;

        var parentTreeNode = null;

        while (true) {

            nodeIds.push(currentNode.id);
            currentNode = currentNode.getParentNode();
            if (currentNode == null) {
                //nodeIds.push(currentNode.id);
                break;
            }

        }

        nodeIds.reverse();
        $.cookie("programList_TreeNode_Tid_Cookie", nodeIds, {path: "/programMgr/programList"});
        //alert(treeNode.id);
        //var programList_TreeNode_Tid_Cookie = $.cookie("programList_TreeNode_Tid_Cookie",treeNodeTid,{path:baseUrl + "programMgr/programList"});
        //var programList_parentTreeNode_Tid_Cookie = $.cookie("programList_parentTreeNode_Tid_Cookie", parentTreeNodeTid,{path:baseUrl + "programMgr/programList"})
        window.location.href = baseUrl+"programMgr/programList";
    }
}
function zTreeOnClick2(event, treeId, treeNode) {
    zTree2.expandNode(treeNode,true,true);
    reloadGrid(treeNode);


}
