var planFile = [];
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if ('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
$(function () {
    $("#playViewDialog").dialog({autoOpen: false, width: 1000, height: 600, close: function () {
        $("#playViewDialog").empty();
    }});
    $("#treeDialog").dialog({autoOpen: false, width: 650, height: 600, buttons: {
        "继续": function () {
            var checkedNodes = queryCheckedNodes();
            if (checkedNodes.length == 0) {
                alert("请先选择文件!");
            } else {
                window.location.href = baseUrl + "my/myAlbumResourceCreat?idList=" + checkedNodes;
            }
            ;
            /*if(planFile.length==0){

             }else{

             }*/
        }
    }});
    $("#addFileDialog").dialog({autoOpen: false, width: 650, height: 600, buttons: {
        "添加": function () {
            var specialId = $("#specialId").val();
            var idList = "";
            var checkedNodes = queryCheckedNodes1();
            if (checkedNodes.length == 0) {
                alert("请先选择文件!");
                return false;
            }
            $.post(baseUrl + "userSpecial/saveUserSpecial", {idList: checkedNodes, specialId: specialId}, function (data) {
                if (data.success) {
                    window.location.href = baseUrl + "my/myAlbumResourceList?id=" + specialId;
                } else {
                    alert(data.msg);
                }
            });
        }
    }});
    $("#createBtn input[name=specialName]").click(function () {
        var specialName = $("#createBtn input[name=specialName]").val();
        if (specialName == '请输入新专辑名称') {
            $("#createBtn input[name=specialName]").val('');
        }
    })
});
function addSpecialFile() {
    planFile = [];
    $("#addFileDialog").dialog("open");
}
function choseNew() {
    planFile = [];
    $("#treeDialog").dialog("open");
    $(".ui-dialog").css({"border-right": "1px solid #3C3437", "border-left": "1px solid #3C3437", "border-bottom": "1px solid #3C3437"});
}
function addSpecial(fileId) {
    planFile[planFile.length] = fileId;
    alert("已加入!");
}
function specialType() {
    var specialType = $("#specialType option:selected").val();
    if (specialType == '1') {
        $("#checkBtn").show();
        $("#createBtn").hide();
    } else if (specialType == '0') {
        $("#checkBtn").hide();
        $("#createBtn").show();
    }
}
function createSpecial() {
    var idList = $("#idList").val();
    var specialName = $("#createBtn input[name=specialName]").val();
    var specialTag = $("#createBtn input[name=specialTag]").val();
    var specialDes = $("#createBtn textarea[name=specialDes]").val();
    if (idList.length == 0) {
        alert("请先选择文件");
        return false;
    }
    if (specialName == '请输入新专辑名称' || specialName == '') {
        alert("请输入专辑名称!");
        return false;
    }
    if (specialTag == "") {
        alert("专辑标签不能为空!");
        return false;
    }

    var tags = "";
    if (specialTag.split(" ")) {
        var strings = specialTag.split(" ");
        for (var i = 0; i < strings.length; i++) {
            tags += strings[i] + ",";
        }
    } else {
        tags = specialTag;
    }

    $.post(baseUrl + "userSpecial/saveUserSpecial", {idList: idList, specialName: specialName, specialTag: tags, specialDesc: specialDes}, function (data) {
        if (data.success) {
            window.location.href = baseUrl + "my/myAlbumResource"
        } else {
            alert(data.msg);
        }
    })
}

function removeFile(tag) {
    var ids = $("#idList").val();
    var idList = "";
    if (ids.indexOf(',')) {
        var strs = ids.split(',');
        for (var i = 0; i < strs.length; i++) {
            if (tag != strs[i]) {
                if (i == strs.length - 1) {
                    idList += strs[i];
                } else {
                    idList += strs[i] + ",";
                }

            }
        }
    } else {
        if (tag == ids) {
            idList = "";
        }
    }
    window.location.href = baseUrl + "my/myAlbumResourceCreat?idList=" + idList;
}

function deleteSpecial(tag) {
    if (confirm("确定删除该专辑吗?")) {
        window.location.href = baseUrl + "userSpecial/deleteSpecialById?id=" + tag;
    }
}
function deleteSpecialFile(tag, specialId) {
    if (confirm("确定删除该文件吗?")) {
        window.location.href = baseUrl + "userSpecial/deleteSpecialFileById?id=" + tag + "&specialId=" + specialId;
    }
}
function executeSpecial(tag) {
    window.location.href = baseUrl + "my/myAlbumResourceEdit?id=" + tag;
}

function deletePoster(tag) {
    window.location.href = baseUrl + "userSpecial/deleteSpecialPoster?id=" + tag;
}

function playShow(id, fileName, filePath, fileHash) {
    var appendDiv = "";
    $(".ui-dialog-title").html(fileName);
    //1.视频 2.文档  3.图片 4.音频
    if (checkFileType(filePath) == '1') {
        appendDiv += "<div id=\"boful_video_player\" style=\"width:100%;height:100%;\"></div>";
        $("#playViewDialog").empty().append(appendDiv);

        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            var playList = data.fileUrl;
            playList = typeof (playList) == "string" ? eval(playList) : playList;
            jwplayerInit("boful_video_player", playList, "900", "500", true, false);
            $("#playViewDialog").dialog("open");
        });
    } else if (checkFileType(filePath) == 2) {
        appendDiv += "<div class=\"playdocumment_left_show\" id=\"document_player\" style=\"height: 600px\"></div>";
        $("#playViewDialog").empty().append(appendDiv);
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            flexpaperInit("document_player", data.fileUrl, baseUrl);
            $("#playViewDialog").dialog("open");
        });
    } else if (checkFileType(filePath) == 3) {
        $.post(baseUrl + "ntsService/posterUserFileImg", {fileHash: fileHash, size: '600x-1'}, function (data) {
            var src = data.src;
            appendDiv = "<img src='" + src + "' />";
            $("#playViewDialog").empty().append(appendDiv);
            $("#playViewDialog").dialog("open");
        });
    } else if (checkFileType(filePath) == 4) {
        appendDiv += "<div id=\"boful_video_player\" style=\"width:100%;height:100%;\"></div>";
        $("#playViewDialog").empty().append(appendDiv);
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            var playList = data.fileUrl;
            playList = typeof (playList) == "string" ? eval(playList) : playList;
            jwplayerInit("boful_video_player", playList, "900", "20", true, false);
            $("#playViewDialog").dialog("open");
        });
    } else if (checkFileType(filePath) == 5) {
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            var strHtml = "<div id=\"boful_video_player\" style=\"width:100%;height:100%;\">";
            strHtml = strHtml + "</div>";
            $("#playViewDialog").empty().append(strHtml);
            initSWF(data.fileUrl, "boful_video_player", "900", "450");
            $("#playViewDialog").dialog("open");


//            var playList = data.fileUrl;
//            var strHtml = "<div id=\"boful_video_player\" style=\"width:100%;height:100%;\">";
//            strHtml = strHtml + "<object classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0\" width=\"900\" height=\"450\" align=\"middle\"\>";
//            strHtml = strHtml + "<embed src=\""+playList+"\" quality=\"high\" width=\"900\" height=\"450\"  type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" /\>";
//            strHtml = strHtml + "</object\>";
//            strHtml = strHtml + "</div>";
//            $("#playViewDialog").empty().append(strHtml);
//            $("#playViewDialog").dialog("open");
        });
    } else {
        window.location.href = baseUrl + "userSpecial/downloadSpecialFile?id=" + id;
    }

}

function shareGroup(tag) {
    $("#specialId").val(tag);
    var url = baseUrl + "userSpecial/queryAllCommunity";
    $.post(url, function (data) {
        var communityList = data.communityList;
        var commDiv = "";
        for (var i = 0; i < communityList.length; i++) {
            commDiv += "<p onclick=\"showBoard(" + communityList[i].id + ");showBg(this)\">" + communityList[i].name + "</p>";
        }
        $("#communityDiv").empty().append(commDiv);
        $("#groupAlbum").show();
    });

}
function showBg(obj) {
    $("#communityDiv > p").css("background-color", "");
    $(obj).css("background-color", 'rgb(227, 252, 228)')
}
function showBg2(obj) {
    $("#boardDiv > p").css("background-color", "");
    $(obj).css("background-color", 'rgb(227, 252, 228)')
}
function showBoard(tag) {
    var url = baseUrl + "userSpecial/queryAllBoards";
    $.post(url, {id: tag}, function (data) {
        var boardList = data.boardList;
        var boardDiv = "";
        for (var i = 0; i < boardList.length; i++) {
            boardDiv += "<p onclick=\"queryBoardId(" + boardList[i].id + ");showBg2(this)\">" + boardList[i].name + "</p>";
        }
        $("#boardDiv").empty().append(boardDiv);
    });
}
function queryBoardId(tag) {
    $("#boardId").val(tag);
}
//共享专辑到社区板块
function specialSharing() {
    var boardId = $("#boardId").val();
    var specialId = $("#specialId").val();
    if (boardId == "") {
        alert("请先选择需要共享到的小组!");
        return false;
    }
    var canDownload = $("#sharingSetDiv input[name=canDownload]:checked").val();
    var shareRange = $("#sharingSetDiv select[name=shareRange]").val();
    var url = baseUrl + "userSpecial/specialSharing";
    $.post(url, {boardId: boardId, specialId: specialId, canDownload: canDownload, shareRange: shareRange}, function (data) {
        if (data.success) {
            alert(data.msg);
            $("#groupAlbum").hide();
            $("#sharingBtn").removeClass("item_opreat_share");
        } else {
            alert(data.msg);
        }
    });
}
function albumClose() {
    $("#groupAlbum").hide();
}

/**
 * 创建专辑时，文件列表内容预览用方法
 * @param id 文件id
 * @param fileName 文件名
 * @param filePath 文件路径
 * @param fileHash HASH码
 */
function playPreview(id, fileName, filePath, fileHash) {
    var appendDiv = "";
    $(".ui-dialog-title").html(fileName);
    //1.视频 2.文档  3.图片 4.音频 5.SWF
    if (checkFileType(filePath) == '1') {
        appendDiv += "<div id=\"boful_video_player\" style=\"width:100%;height:100%;\"></div>";
        $("#playViewDialog").empty().append(appendDiv);

        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            var playList = data.fileUrl;
            playList = typeof (playList) == "string" ? eval(playList) : playList;
            jwplayerInit("boful_video_player", playList, "900", "500", true, false);
            $("#playViewDialog").dialog("open");
        });
    } else if (checkFileType(filePath) == 2) {
        appendDiv += "<div class=\"playdocumment_left_show\" id=\"document_player\" style=\"height: 600px\"></div>";
        $("#playViewDialog").empty().append(appendDiv);
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            flexpaperInit("document_player", data.fileUrl, baseUrl);
            $("#playViewDialog").dialog("open");
        });
    } else if (checkFileType(filePath) == 3) {
        $.post(baseUrl + "ntsService/posterUserFileImg", {fileHash: fileHash, size: '600x-1'}, function (data) {
            var src = data.src;
            appendDiv = "<img src='" + src + "' />";
            $("#playViewDialog").empty().append(appendDiv);
            $("#playViewDialog").dialog("open");
        });
    } else if (checkFileType(filePath) == 4) {
        appendDiv += "<div id=\"boful_video_player\" style=\"width:100%;height:100%;\"></div>";
        $("#playViewDialog").empty().append(appendDiv);
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            var playList = data.fileUrl;
            playList = typeof (playList) == "string" ? eval(playList) : playList;
            jwplayerInit("boful_video_player", playList, "900", "20", true, false);
            $("#playViewDialog").dialog("open").height(20);
            ;
        });
    } else if (checkFileType(filePath) == 5) {
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            var playList = data.fileUrl;
            var strHtml = "<div id=\"boful_video_player\" style=\"width:100%;height:100%;\">";
            strHtml = strHtml + "<object style=\"overflow:hidden;z-index:90;width:100%;height:100%;\" classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0\" width=\"900\" height=\"450\" align=\"middle\"\>";
            strHtml = strHtml + "<embed src=\"" + playList + "\" quality=\"high\" width=\"900\" height=\"450\"  type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" /\>";
            strHtml = strHtml + "</object\>";
            strHtml = strHtml + "</div>";
            $("#playViewDialog").empty().append(strHtml);
            $("#playViewDialog").dialog("open");
        });
    } else {
        window.location.href = baseUrl + "userFile/downloadFile?id=" + id;
    }

}

function albumResourceRelease(sId) {
    $.post(baseUrl + "my/checkAlbumResourceRelease", {id: sId}, function (data) {
        if (data.success) {
            window.location.href = baseUrl + "my/myAlbumResourceRelease?id=" + sId;
        } else {
            alert(data.msg);
        }
    });
}