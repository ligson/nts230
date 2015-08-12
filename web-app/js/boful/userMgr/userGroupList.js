function userStateFormatter(cellvalue, options, rowObject){
    var userState=rowObject.userState;
    var userStateDiv="";
    if(userState==0){
        userStateDiv="禁用";
    }else if(userState==1){
        userStateDiv="正常";
    }
    return userStateDiv;
}

function editUserGroupFormatter(cellvalue, options, rowObject){
    return "<a href=\""+baseUrl+"userMgr/userGroupEdit?editPage="+jQuery("#userGroupGrid").getGridParam('page')+"&groupId="+rowObject.id+"\"><img src=\""+baseUrl+"images/skin/modi.gif\" alt=\"\" width=\"14\" height=\"14\" border=\"0\"></a>" ;
}

function importUsersFormatter(cellvalue, options, rowObject){
    //return "<a href=\""+baseUrl+"userMgr/groupSelectPage?groupId="+rowObject.id+"\"><img src=\"${resource(dir: 'images/skin', file: 'modi.gif')}\" alt=\"\" width=\"14\" height=\"14\" border=\"0\"></a>" ;
    return "<a href=\"javascript:void(0)\" onclick=\"consumerImport("+rowObject.id+")\"><img src=\""+baseUrl+"images/skin/modi.gif\" alt=\"\" width=\"14\" height=\"14\" border=\"0\"></a>" ;
}

function userListFormatter(cellvalue, options, rowObject){
    return "<a href=\""+baseUrl+"userMgr/groupConsumerList?editPage="+jQuery("#userGroupGrid").getGridParam('page')+"&groupId="+rowObject.id+"\"><img src=\""+baseUrl+"images/skin/modi.gif\" alt=\"\" width=\"14\" height=\"14\" border=\"0\"></a>" ;
}

function addCanPlayProgramFormatter(cellvalue, options, rowObject){
    return "<a class='ui-button searchbtn' href=\"addCanPlayProgram?editPage="+jQuery("#userGroupGrid").getGridParam('page')+"&groupId="+rowObject.id+"\">添加可点播资源</a>"
}

function addCanDownloadProgramFormatter(cellvalue, options, rowObject){
    return "<a class='ui-button searchbtn' href=\"addCanDownloadProgram?editPage="+jQuery("#userGroupGrid").getGridParam('page')+"&groupId="+rowObject.id+"\">添加可下载资源</a>"
}

function canPlayProgramListFormatter(cellvalue, options, rowObject){
    return "<a class='ui-button searchbtn' href=\"canPlayProgramList?editPage="+jQuery("#userGroupGrid").getGridParam('page')+"&groupId="+rowObject.id+"\">查看可点播资源</a>"
}

function canDownloadProgramListFormatter(cellvalue, options, rowObject){
    return "<a class='ui-button searchbtn' href=\"canDownloadProgramList?editPage="+jQuery("#userGroupGrid").getGridParam('page')+"&groupId="+rowObject.id+"\">查看可下载资源</a>"
}

function deleteUserGroup(idList){
    var url=baseUrl+"userMgr/userGroupDelete";
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

                    myAlert(data.msg);
                } else {
                    myAlert(data.msg);
                }
            }
        })

    },null);
}

function addUserGroup(){
    self.location.href = "userGroupAdd" ;
}

function canPlay(val, idList){
    var url=baseUrl+"userMgr/userGroupConsumersIsCanPlay";
    $.ajax({
        url:url,
        data:"idList="+idList+"&userState="+val,
        success:function(data){
            myAlert(data.msg);
        }
    })
}

function canDownload(val, idList){
    var url=baseUrl+"userMgr/userGroupConsumersIsCanDownload";
    $.ajax({
        url:url,
        data:"idList="+idList+"&canDownload="+val,
        success:function(data){
            myAlert(data.msg);
        }
    })
}

function operate(action,pars){
    var ids=$("#userGroupGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0 && action!="addUserGroup"){
        myAlert("请至少选择一条记录！");
        return false;
    };
    if(action=="deleteUserGroup"){
        deleteUserGroup(ids);
    }else if(action=="addUserGroup"){
        addUserGroup();
    }
    else if(action == "canPlay"){
        canPlay(pars, ids);
    }
    else if(action == "canDownload"){
        canDownload(pars, ids);
    }
}

function addToUserGroup(ids){
    var groupId = $("#groupId").val();
    //alert(groupId);
    $.ajax({
        url:baseUrl+"userMgr/userGroupConsumerAdd",
        data:"idList="+ids+"&groupId="+groupId,
        success:function(data){
            myAlert(data.msg);
        }
    })
}

function operate2(action,pars){
    var ids=$("#consumerGrid").jqGrid("getGridParam","selarrrow");
    if(ids.length==0){
        myAlert("请至少选择一条记录！");
        return false;
    };
    if(action=="addToUserGroup"){
        addToUserGroup(ids);
    }
}

$(function(){
    if($('#editPage').val() == ''){
        $('#editPage').val('1');
    }
    $("#userGroupGrid").jqGrid({
        url:baseUrl+"userMgr/userGroupListShow",
        datatype: "json",
        mtype: "POST",
        search: true,
        colNames: ["组名", "备注", "创建者","创建时间", "修改组名和备注", "导入组成员", "管理组成员", "添加点播资源", "添加下载资源", "查看点播资源", "查看下载资源"],
        colModel:[
            { name: "name", width: 80, search: true},
            { name: "description", width: 100, search: true},
            { name: "creator", width: 30, search: true},
            { name: "dateCreated", width: 80, search: true},
            { name: "editUserGroup", width: 50,search: false,formatter:editUserGroupFormatter,sortable:false},
            { name: "importUsers", width: 50,search: false,formatter:importUsersFormatter,sortable:false},
            { name: "userList", width: 50,search: false,formatter:userListFormatter,sortable:false},
            { name: "addCanPlayProgram", width: 50,search: false,formatter:addCanPlayProgramFormatter,sortable:false},
            { name: "addCanDownloadProgram", width: 50,search: false,formatter:addCanDownloadProgramFormatter,sortable:false},
            { name: "canPlayProgramList", width: 50,search: false,formatter:canPlayProgramListFormatter,sortable:false},
            { name: "canDownloadProgramList", width: 50,search: false,formatter:canDownloadProgramListFormatter,sortable:false}
        ],
        page: parseInt($('#editPage').val()),
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

    $("#searchConsumerBtn").click(function(){
        var searchToolBar = $("#searchToolBar");
        var searchName = searchToolBar.find("input[name='searchName']").val();
        var searchCollege = searchToolBar.find("select option:selected").val();
        var groupId = searchToolBar.find("input[name='groupId']").val();
        var url = baseUrl + "userMgr/consumerList2";
        var postData = {
            searchName: null,
            searchCollege: null

        };
        if (!searchName.isEmpty()) {
            postData.searchName=searchName;
        }
        if (searchCollege != "-1") {
            postData.searchCollege=searchCollege;
        }
        if (!groupId.isEmpty()) {
            postData.groupId=groupId;
        }
        if(url.substring(url.length-1) == "&")
        {
            url = url.substring(0,url.length-1) ;
        }
        jQuery("#consumerGrid").jqGrid("setGridParam", {url: url,page:1,postData:postData}).trigger("reloadGrid");
    })
})