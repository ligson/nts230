/**
 * Created by xuzhuo on 14-4-10.
 */
/**
 * 一级节点显示
 */
$(function () {
    if($('#editPage').val() == ''){
        $('#editPage').val('1');
    }
    var searchToolBar = $("#searchToolBar");
    var name = searchToolBar.find("input[name='name']").val();
    var parentid = searchToolBar.find("select option:selected").val();
    $("#userActivityCategoryListId").jqGrid({
        url: baseUrl + "userActivityMgr/userActivityCategoryListAsJson?name="+name+"&parentid="+parentid,
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "名称", "父分类", "创建时间", "状态", "修改", "删除"],
        colModel: [
            {name: "id", width: 50},
            {name: "name", width: 200},
            {name: "parentName", width: 200},
            {name: "dateCreated", width: 100},
            { name: "state", width: 80,search: false,formatter:stateFormatter},
            {name: "修改", width: 100, sortable: false, formatter: rmsCategoryFormaterEdit},
            {name: "删除", width: 100, sortable: false, formatter: rmsCategoryFormaterDelete}
        ],
        page: parseInt($('#editPage').val()),
        pager: "GridPaper",
        rowNum: 10,
        viewrecords: true,
        gridview: true,
        autowidth: true,
        autoencode: true,
        multiselect: true,
        height: 300
    })

    //搜索按钮添加监听事件
    $("#searchBtn").click(function () {
        var url = baseUrl + "userActivityMgr/userActivityCategoryListAsJson";
        var searchToolBar = $("#searchToolBar");
        var name = searchToolBar.find("input[name='name']").val();
        var parentid = searchToolBar.find("select option:selected").val();
        var postData = {
            name: null,
            parentid: null
        };
        if (!name.isEmpty()) {
            postData.name = name;
        }
        postData.parentid = parentid;
        $("#userActivityCategoryListId").jqGrid("setGridParam", {url: url, page: 1, postData: postData}).trigger("reloadGrid");
    });
})

/**
 * 节点状态(使用中,回收站)
 * @param cellvalue
 * @param options
 * @param rowObject
 * @returns {string}
 */
function stateFormatter(cellvalue, options, rowObject){
    var stateDiv="";
    if(rowObject.state==true){
        stateDiv="使用中";
    }else if(rowObject.state==false){
        stateDiv="回收站";
    }
    return "<span>"+stateDiv+"</span>"
}

/**
 * 设置修改节点按钮
 * @param cellvalue
 * @param options
 * @param rowObject
 * @returns {string}
 */
function rmsCategoryFormaterEdit(cellvalue, options, rowObject) {
    var searchToolBar = $("#searchToolBar");
    var name = searchToolBar.find("input[name='name']").val();
    var parentid = searchToolBar.find("select option:selected").val();
    var html = "<a href='"+baseUrl+"userActivityMgr/rmsCategoryEdit?name="+name+"&parentid="+parentid+"&editPage="+jQuery("#userActivityCategoryListId").getGridParam('page')+"&rmsCategoryId=" + rowObject.id + "'><input class='ui-button searchbtn' type='button' value='修改'/></a>";
    return html;
}
/**
 * 设置删除按钮
 * @param cellvalue
 * @param options
 * @param rowObject
 */
function rmsCategoryFormaterDelete(cellvalue, options, rowObject) {
    var html = "<input  class='ui-button searchbtn' type='button' value='删除' onclick='rmsCategoryDelete(" + rowObject.id + ")'/>"
    return html;
}
/**
 * 删除节点
 * @param rmsCategoryId
 */
function rmsCategoryDelete(rmsCategoryId) {
    myConfirm("确认要删除吗？将会删除分类下所有活动以及相关数据...", null, function () {
        $.post(baseUrl + "userActivityMgr/rmsCategoryDelete", {rmsCategoryId: rmsCategoryId}, function (data) {
            if (data.success) {
                $("#" + rmsCategoryId).remove();
                myAlert(data.message);
            } else {
                myAlert(data.message);
            }
        })
    }, null)
}
/**
 * 批量删除节点
 */
function rmsCategoryDeletes() {
    myConfirm("确认要删除吗？将会删除分类下所有活动以及相关数据...", null, function () {
        var rmsCategoryIds = $("#userActivityCategoryListId").jqGrid("getGridParam", "selarrrow");
        if (rmsCategoryIds.length == 0) {
            myAlert("请至少选择一条记录！");
        } else {
            var rmsCategoryId = rmsCategoryIds.toString();
            $.post(baseUrl + "userActivityMgr/rmsCategoryDelete", {
                rmsCategoryId: rmsCategoryId
            }, function (data) {
                if (data.success) {
                    for (var i = 0; i < rmsCategoryIds.length; i++) {
                        if (rmsCategoryIds[i] == data.errorId) {
                            myAlert(data.message);
                            break;
                        }
                        $("#" + rmsCategoryIds[i]).remove();
                    }
                    myAlert(data.message);
                } else {
                    myAlert(data.message);
                }
            })
        }
    }, null)

}