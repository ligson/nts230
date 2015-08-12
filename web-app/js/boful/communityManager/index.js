function isRecommendFormatter(cellvalue, options, rowObject){
    var isRecommend=rowObject.isRecommend;
    if(isRecommend==true || isRecommend == "true"){
        return "<span>已推荐</span>"
    }else if(isRecommend==false || isRecommend == "false"){
        return "<span>未推荐</span>"
    }

}
function stateFormatter(cellvalue, options, rowObject){
    var state=rowObject.state;
    var stateValue="";
    if(state==0){
        stateValue="已禁用";
    }else if(state==1){
        stateValue="已通过";
    }else if(state==2){
        stateValue="审核中";
    }
    else if(state==3){
        stateValue="申请中";
    }
    return "<span>"+stateValue+"</span>"
}

function operationFormatter(cellvalue, options, rowObject){
    var isRecommend=rowObject.isRecommend;
    if(isRecommend==null){
        isRecommend=rowObject.operationRecommend;
    }
    var recommend="";
    var recommendCheck;
    if(isRecommend==true || isRecommend=="true"){
        recommend="取消推荐";
        recommendCheck=false;
    }else if(isRecommend==false || isRecommend=="false"){
        recommend="推荐";
        recommendCheck=true;
    }
    var recommendStr = "<a id='recommend_"+rowObject.id+"' class='ui-button searchbtn' onclick='communityRecommend("+rowObject.id+","+recommendCheck+")'>"+recommend+"</a>";

    var state=rowObject.state;
    if(state==null){
        state=rowObject.operationState;
    }
    var stateValue="";
    var stateCheck;
    if(state==1){
        stateValue="禁用";
        stateCheck=0;
    }else if(state==0){
        stateValue="通过";
        stateCheck=1;
    }

    var stateStr = "<a id='state_"+rowObject.id+"' class='ui-button searchbtn' onclick='communityState("+rowObject.id+","+stateCheck+")'>"+stateValue+"</a>";

    return "<a class='ui-button searchbtn' onclick='deleteCommunity("+rowObject.id+")'>删除</a>"+'&nbsp;'+recommendStr+'&nbsp;'+stateStr;

}
function operationRecommendFormatter(cellvalue, options, rowObject){
    var isRecommend=rowObject.isRecommend;
    if(isRecommend==null){
        isRecommend=rowObject.operationRecommend;
    }
    var recommend="";
    var recommendCheck;
    if(isRecommend==true){
        recommend="取消推荐";
        recommendCheck=false;
    }else if(isRecommend==false){
        recommend="推荐";
        recommendCheck=true;
    }
    return "<a class='ui-button searchbtn' onclick='communityRecommend("+rowObject.id+","+recommendCheck+")'>"+recommend+"</a>";

}
function operationStateFormatter(cellvalue, options, rowObject){
    var state=rowObject.state;
    if(state==null){
        state=rowObject.operationState;
    }
    var stateValue="";
    var stateCheck;
    if(state==1){
        stateValue="禁用";
        stateCheck=0;
    }else if(state==0){
        stateValue="通过";
        stateCheck=1;
    }
    return "<a class='ui-button searchbtn' onclick='communityState("+rowObject.id+","+stateCheck+")'>"+stateValue+"</a>";

}
function communityRecommend(idList,recommend){
    var url=baseUrl+"communityManager/communityRecommend";
    $.ajax({
        url:url,
        data:"idList="+idList+"&recommend="+recommend,
        success:function(data){
            if(data.success){
                if(idList instanceof Array){
                    for(var i=idList.length-1;i>=0;i--){
                        $("#communityGrid").setRowData(idList[i],{isRecommend:recommend});
                        //$("#communityGrid").setRowData(idList[i],{id:idList[i],operationRecommend:recommend});

                        var target = $("#recommend_"+idList[i]);
                        if(target){
                            if(recommend == true || recommend == "true") {
                                target.attr("onclick", "communityRecommend("+idList[i]+", 'false')");
                                target.text("取消推荐");
                            } else {
                                target.attr("onclick", "communityRecommend("+idList[i]+", 'true')");
                                target.text("推荐");
                            }
                        }
                    }
                }else{
                    $("#communityGrid").setRowData(idList,{isRecommend:recommend});
                    //$("#communityGrid").setRowData(idList,{id:idList,operationRecommend:recommend});
                    var target = $("#recommend_"+idList);
                    if(target){
                        if(recommend == true || recommend == "true") {
                            target.attr("onclick", "communityRecommend("+idList+", 'false')");
                            target.text("取消推荐");
                        } else {
                            target.attr("onclick", "communityRecommend("+idList+", 'true')");
                            target.text("推荐");
                        }
                    }
                }

            }
            myAlert(data.msg);
        }
    })
}

function communityState(idList,state){
    var url=baseUrl+"communityManager/communityState";
    $.ajax({
        url:url,
        data:"idList="+idList+"&state="+state,
        success:function(data){
            if(data.success){
                if(idList instanceof Array){
                    for(var i=idList.length-1;i>=0;i--){
                        $("#communityGrid").setRowData(idList[i],{state:state});
                        //$("#communityGrid").setRowData(idList[i],{id:idList[i],operationState:state});
                        var target = $("#state_"+idList[i]);
                        if(target){
                            if(state == 1) {
                                target.attr("onclick", "communityState("+idList[i]+", '0')");
                                target.text("禁用");
                            } else {
                                target.attr("onclick", "communityState("+idList[i]+", '1')");
                                target.text("通过");
                            }
                        }
                    }
                }else{
                    $("#communityGrid").setRowData(idList,{state:state});
                    //$("#communityGrid").setRowData(idList,{id:idList,operationState:state});
                    var target = $("#state_"+idList);
                    if(target){
                        if(state == 1) {
                            target.attr("onclick", "communityState("+idList+", '0')");
                            target.text("禁用");
                        } else {
                            target.attr("onclick", "communityState("+idList+", '1')");
                            target.text("通过");
                        }
                    }

                }


            }
            myAlert(data.msg);
        }
    })
}

function deleteCommunity(idList){
    var url=baseUrl+"communityManager/communityDelete";
    myConfirm("确认要删除吗？",null,function(){
        $.ajax({
            url:url,
            data:"idList="+idList,
            success:function(data){
                if(data.success){
//                    myAlert(data.msg);
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

function operate(action,pars){
    var ids=$("#communityGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0){
        myAlert("请至少选择一条记录！");
        return false;
    };
    if(action=="deleteCommunity"){
        deleteCommunity(ids);
    }else if(action=="communityState"){
        communityState(ids,pars);
    }else if(action=="communityRecommend"){
        communityRecommend(ids,pars)
    }
}

$(function(){
    $("#communityGrid").jqGrid({
        url:baseUrl+"communityManager/communityList",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["ID", "社区名称", "社区类别","创建时间", "创建者", "成员人数", "状态","推荐状态","操作"],
        colModel:[
            { name: "id", width: 50, search: false},
            { name: "name", width: 150, search: true},
            { name: "communityCategory", width: 100, search: true},
            { name: "dateCreated", width: 80, search: false},
            { name: "create_comsumer_id", width: 80,search: false},
            { name: "members", width: 80,search: false},
            { name: "state", width: 80,search: false,formatter:stateFormatter},
            { name: "isRecommend", width: 80,search: false,formatter:isRecommendFormatter},
            //{ name: "operationState", width: 80,search: false,formatter:operationStateFormatter,sortable:false},
            //{ name: "operationRecommend", width: 80,search: false,formatter:operationRecommendFormatter,sortable:false},
            { name: "操作", width: 200,search: false,formatter:operationFormatter,sortable:false}
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
    }).trigger("reloadGrid");

    $("#searchBtn").click(function(){
        var searchToolBar = $("#searchToolBar");
        var name = searchToolBar.find("input[name='name']").val();
        var state = searchToolBar.find("select option:selected").val();
        var url = baseUrl + "communityManager/communityList";
        var postData = {
            name: null,
            state: null
        };
        if (!name.isEmpty()) {
            postData.name=name;
        }
        if (state != "-1") {
            postData.state=state;
        }
        jQuery("#communityGrid").jqGrid("setGridParam", {url: url, page: 1,postData:postData}).trigger("reloadGrid");
    })

})