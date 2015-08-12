var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
function isTopFormatter(cellvalue, options, rowObject){
    var isTop=rowObject.isTop;
    var topDiv="";
    if(isTop==1){
        topDiv="是";
    }else if(isTop==0){
        topDiv="否";
    }
    return "<span>"+topDiv+"</span>"
}
function isEliteFormatter(cellvalue, options, rowObject){
    var isElite=rowObject.isElite;
    var eliteDiv="";
    if(isElite==1){
        eliteDiv="是";
    }else if(isElite==0){
        eliteDiv="否";
    }
    return "<span>"+eliteDiv+"</span>"
}
function operationFormatter(cellvalue, options, rowObject){
    return "<a class='ui-button searchbtn' onclick='deleteArticle("+rowObject.id+")'>删除</a>";
}
function nameLink(cellvalue,options,rowObject) {
    if(rowObject.name==null){
        return "";
    }
      return "<a title='"+rowObject.name+"' class='ui-button searchbtn' href='javascript:void(0)' onclick='fnLink("+rowObject.id+")'>"+rowObject.name.substr(0,20)+"</a>";
}
function fnLink(id){
   // alert(id)
    var url=baseUrl+"community/communityArticle?id="+id;
    //window.location.href=url;
    window.open(url)
}
function operationEliteFormatter(cellvalue, options, rowObject){
    var isElite=rowObject.isElite;
    if(isElite==null){
        isElite=rowObject.operationElite;
    }
    var eliteDiv="";
    var elite1;
    if(isElite==1){
        eliteDiv="普通贴";
        elite1=0;
    }else if(isElite==0){
        eliteDiv="精华帖";
        elite1=1;
    }
    return "<a class='ui-button searchbtn' onclick='eliteArticle("+rowObject.id+","+elite1+")'>"+eliteDiv+"</a>";

}
function operationTopFormatter(cellvalue, options, rowObject){
    var isTop=rowObject.isTop;
    if(isTop==null){
        isTop=rowObject.operationTop;
    }
    var topDiv="";
    var top1;
    if(isTop==1){
        topDiv="取消置顶";
        top1=0;
    }else if(isTop==0){
        topDiv="置顶";
        top1=1;
    }
    return "<a class='ui-button searchbtn' onclick='topArticle("+rowObject.id+","+top1+")'>"+topDiv+"</a>";

}
function operate(){
    var ids=$("#articleGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0){
        myAlert("请至少选择一条记录！");
        return false;
    };
    deleteArticle(ids);
}

function deleteArticle(idList){
    var url=baseUrl+"communityManager/articleDelete";
    myConfirm("确认要删除吗？",null,function(){
        $.ajax({
            url:url,
            data:"idList="+idList,
            success:function(data){
                if(data.success){
                    if(idList instanceof Array){
                        for(var i=idList.length-1;i>=0;i--){
                            $("#"+idList[i]).remove();
                        }
                    }else{
                        $("#"+idList).remove();
                    }


                }
                myAlert(data.msg);
            }
        })

    },null);
}

function eliteArticle(id,isElite){
    var url=baseUrl+"communityManager/eliteArticle";
    $.ajax({
        url:url,
        data:"id="+id+"&isElite="+isElite,
        success:function(data){
            $("#articleGrid").setRowData(id,{isElite:isElite});
            $("#articleGrid").setRowData(id,{id:id,operationElite:isElite});
            myAlert(data.msg);
        }
    })
}

function topArticle(id,isTop){
    var url=baseUrl+"communityManager/topArticle";
    $.ajax({
        url:url,
        data:"id="+id+"&isTop="+isTop,
        success:function(data){
            $("#articleGrid").setRowData(id,{isTop:isTop});
            $("#articleGrid").setRowData(id,{id:id,operationTop:isTop});
            myAlert(data.msg);
        }
    })
}

$(function(){
    $("#articleGrid").jqGrid({
        url:baseUrl+"communityManager/articleList",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "帖子名称", "所在小组","创建时间", "创建者", "浏览数", "回复数","置顶","精华帖","置顶设置","精华帖设置","操作"],
        colModel:[
            { name: "id", width: 50, search: false},
            { name: "name", width: 150, search: true,formatter:nameLink},
            { name: "forumBoard", width: 100, search: true},
            { name: "dateCreated", width: 80, search: false},
            { name: "createConsumer", width: 80,search: false},
            { name: "forumViewNum", width: 80,search: false},
            { name: "forumReplyArticle", width: 80,search: false},
            { name: "isTop", width: 80,search: false,formatter:isTopFormatter},
            { name: "isElite", width: 80,search: false,formatter:isEliteFormatter},
            { name: "operationTop", width: 80,search: false,formatter:operationTopFormatter,sortable:false},
            { name: "operationElite", width: 80,search: false,formatter:operationEliteFormatter,sortable:false},
            { name: "操作", width: 200,search: false,sortable:false,formatter:operationFormatter,sortable:false}
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
})