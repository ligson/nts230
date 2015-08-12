var zTree;
$(function () {

    /*
    var setting = {
        async: {
            enable: true,
            url: baseUrl + "programMgr/listMetaDefine",
            autoParam: [ "id=pid" ]
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
    };*/
    var setting = {
        view: {
            selectedMulti: false        //禁止多点选中
        },
        data: {
            simpleData: {
                enable:true,
                idKey: "id",
                pIdKey: "pid",
                rootPId: ""
            }
        },
        callback: {
            onClick: zTreeOnClick
        }
    };

    zTree = $.fn.zTree.init($("#zTree"), setting, treeNodes);

    $("#programGrid").jqGrid({
        url: baseUrl + "programMgr/metaProgramList?id="+$("#selectMetaDefineId").val(),
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "资源名称", "创建者", "类库", "创建日期", "推荐数", "收藏数", "点播数"],
        colModel: [
            { name: "id", width: 50, search: false},
            { name: "name", width: 200, search: true},
            { name: "consumer", width: 90, search: true},
            { name: "directoryName", width: 90, search: true},
            { name: "dateCreated", width: 80, align: "right", search: false},
            { name: "recommendNum", width: 30, search: true},
            { name: "collectNum", width: 30, search: true},
            { name: "frequency", width: 30, search: true}
        ],
        pager: "#GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autoencode: true,
        autowidth: true,
        height:600,
        sortorder:"desc",
        multiselect: true,
        gridComplete:function(){
            var rowData = $(this).getRowData();
            var newRowHeight = rowData.length*25;
            $(this).setGridHeight(newRowHeight+25);
        }
    });
});
function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
    var nodes = zTree.getNodes();
}
function zTreeOnClick(treeId, treeNode) {
    var treeObj = $.fn.zTree.getZTreeObj(treeNode);
    var selectedNode = treeObj.getSelectedNodes()[0];

    if(selectedNode.enumId == 0){
        $("#selectMetaDefineId").val(selectedNode.id);
    }
    else{
        $("#selectMetaDefineId").val(selectedNode.pid);
    }
    $("#enumId").val(selectedNode.enumId);

    if(selectedNode.pid != 0){
        var url = baseUrl + "programMgr/metaProgramList";
        var postData = {
            id: null,
            enumId: null
        };
        postData.id=$("#selectMetaDefineId").val();
        postData.enumId = $("#enumId").val();
        jQuery("#programGrid").jqGrid("setGridParam", {url: url, page: 1,postData:postData}).trigger("reloadGrid");
    }
}
