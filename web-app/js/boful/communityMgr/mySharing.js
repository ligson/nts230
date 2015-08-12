var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
$(function(){
    $("#sharingDialog").dialog({autoOpen: false, width: 600, height: 500});
})
//批量删除
function deleteSharingList(studyCommunityId) {
    var checkboxList = $("#sharingTable").find("input:checked");
    if (checkboxList.size() == 0) {
        alert("请选择要删除的共享文件！！");
    } else if (confirm("您确定要都删除吗?")) {
        var sharingId = "";
        for (var i = 0; i < checkboxList.size(); i++) {
            sharingId += checkboxList[i].value;
            if (i != checkboxList.size() - 1) {
                sharingId += ",";
            }
        }
        $.post("sharingDelete", {
            sharingId: sharingId,
            studyCommunityId: studyCommunityId
        }, function (data) {
            if (data.success) {
                var ids = sharingId.split(",");
                for (var i = 0; i < ids.length; i++) {
                    $("#tr" + ids[i]).remove();
                }
            } else {
                alert(data.msg);
            }
        })
    }
}
//删除
function deleteSharing(sharingId, studyCommunityId) {
    if (confirm("您确定要删除吗?")) {
        $.post("sharingDelete", {
            sharingId: sharingId,
            studyCommunityId: studyCommunityId
        }, function (data) {
            if (data.success) {
                $("#tr" + sharingId).remove();
            } else {
                alert(data.msg);
            }
        })
    }
}
//播放修改
function changeCanPlay(studyCommunityId, sharingId) {
    $.post("changeCanPlay", {
        studyCommunityId: studyCommunityId,
        sharingId: sharingId
    }, function (data) {
        if (data.changeSuccess) {
            $("#canPlay" + sharingId).text(data.msg);
        } else {
            alert("修改失败");
        }
    })
}
//下载修改
function changeCanDownload(sharingId, canDownload, studyCommunityId) {
    $.post("changeCanDownload", {
        sharingId: sharingId,
        canDownload: canDownload,
        studyCommunityId: studyCommunityId
    }, function (data) {
        if (data.success) {
            $("#canDownload" + sharingId).text(data.msg);
        } else {
            alert(data.msg);
        }
    })
}

function changeSharingState(sharingId, studyCommunityId) {
    $.post(baseUrl + "communityMgr/changeSharingState", {sharingId: sharingId, studyCommunityId: studyCommunityId}, function (data) {
        if (data.success) {
            $("#state_" + sharingId).empty().append("已审批");
        } else {
            alert(data.msg);
        }
    });
}
function showAlbum(tag) {
    var userDownload = $("#userDownload").val();
    var url = baseUrl+"community/querySpecialSharing";
    /* var albumWin = $("#albumDiv");
     var dialogWidth = albumWin.width();
     var dialogHeight = albumWin.height();
     var winWidth = $(window).width();
     var winHeight = $(window).height();
     var top = (winHeight - dialogHeight) / 2;
     var left = (winWidth - dialogWidth) / 2;
     albumWin.css({top: top + "px", left: left + "px" });
     var position = albumWin.position();
     $("albumDiv").html("left" + position.left + "top" + position.top);*/
    $.post(url,{sharingId:tag},function(data){
        var sharing = data.sharing;
        var userSpecial =data.userSpecial;
        var userFiles = data.userFiles;
        var consumer = data.consumer;
        if((userSpecial!=null)&&(userFiles.length>0)){
            var titleDiv = "";
            var fileDiv = "";
            titleDiv+="<div class=\"group_dialog_img\">";
            $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: userFiles[0].fileHash}, function (data) {
                /*titleDiv+="<img src=\""+data.fileUrl+"\"/>";*/
                /*titleDiv+="</div><div class=\"group_dialog_infor\"><h1>"+userSpecial.name+"</h1>"+
                    "<p>"+userSpecial.description+"</p></div>";*/
                fileDiv+="<table width=\"100%\" class=\"c_tab\" border=\" 0\" cellpadding=\"0\" cellspacing=\"0\"><tbody>";
                for(var i=0;i<userFiles.length;i++){
                    var file = userFiles[i];
                    fileDiv+="<tr><td width=\"30\" align=\"center\" class=\"c_i\" id='img_"+file.id+"'>";
                    if(checkFileType(file.filePath)==1){
                        fileDiv+="<img src=\""+baseUrl+"skin/blue/pc/front/images/course_sup_videos.png\"/>";
                    }else if(checkFileType(file.filePath)==2){
                        fileDiv+="<img src=\""+baseUrl+"skin/blue/pc/front/images/course_sup_word.png\"/>";
                    }else if(checkFileType(file.filePath)==3){
                        fileDiv+="<img src=\""+baseUrl+"skin/blue/pc/front/images/course_sup_image.png\"/>";
                    }else if(checkFileType(file.filePath)==4){
                        fileDiv+="<img src=\""+baseUrl+"skin/blue/pc/front/images/course_sup_voice.png\"/>";
                    }else if(checkFileType(file.filePath)==5){
                        fileDiv+="<img src=\""+baseUrl+"skin/blue/pc/front/images/course_sup_videos.png\"/>";
                    }else{
                        fileDiv+="<img src=\""+baseUrl+"skin/blue/pc/front/images/course_sup_other.png\"/>";
                    }
                    fileDiv+="</td>";
                    if((checkFileType(file.filePath)==1)||(checkFileType(file.filePath)==2)||(checkFileType(file.filePath)==3)||(checkFileType(file.filePath)==4||(checkFileType(file.filePath)==5))){
                        fileDiv+="<td><a target=\"_blank\" href='"+baseUrl+"community/communitySharingShow?id="+file.id+"&sharingId="+sharing.id+"'>"+file.name+"</a></td>";
                    }else{
                        fileDiv+="<td><a onclick=\"downloadUserFile("+file.id+",'"+userDownload+"')\">"+file.name+"</a></td>";
                    }

                    fileDiv+="<td width=\"100\" align=\"center\"><a href=\"#\">"+consumer.name+"</a></td>"+
                        "<td width=\"100\" align=\"center\">"+file.createdDate.substr(0,file.createdDate.indexOf('T'))+"</td></tr>";


                }
                fileDiv+="</tbody></table>";
                $("#sharingDialog #specialTab").empty().append(fileDiv);
                $("#sharingDialog #specialTitle").empty().append(titleDiv);
                $("#sharingDialog").dialog("open");
            });

        }
    });
}

function downloadUserFile(tag,uploadState){
    if(uploadState=="false"){
        alert("没有权限下载");
        return false;
    }
    if(confirm("确定要下载吗?")){
        window.location.href = baseUrl + "userFile/downloadFile?id=" + tag;
    }
}