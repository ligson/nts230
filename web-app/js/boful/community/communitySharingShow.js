var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if ('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
$(function () {
    var fileHash = $("#fileHash").val();
    var filePath = $("#filePath").val();
    if (checkFileType(filePath) == 1) {
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            var playList = data.fileUrl;
            playList = typeof (playList) == "string" ? eval(playList) : playList;
            jwplayerInit("boful_video_player", playList, "984", "450", true, false);
        });
    } else if (checkFileType(filePath) == 2) {
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            flexpaperInit("boful_video_player", data.fileUrl, baseUrl);
            $("#boful_video_player").addClass("doc_style");
        });

    } else if (checkFileType(filePath) == 3) {
        $.post(baseUrl + "ntsService/posterUserFileImg", {fileHash: fileHash, size: '600x-1'}, function (data) {
            var src = data.src;
            $("#boful_video_player").empty().append("<img src=\"" + src + "\" onerror=\"this.src = " + baseUrl + "'skin/blue/pc/front/images/boful_default_img.png'\"/>");
        });

    } else if (checkFileType(filePath) == 4) {
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            var playList = data.fileUrl;
            playList = typeof (playList) == "string" ? eval(playList) : playList;
            jwplayerInit("boful_video_player", playList, "984", "20", true, false);
        });
    } else if (checkFileType(filePath) == 5) {
        $.post(baseUrl + "ntsService/playUserFileLinkNew", {fileHash: fileHash}, function (data) {
            initSWF(data.fileUrl, "boful_video_player", "984", "450");
//            var strHtml = "";
//            strHtml = strHtml + "<object classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0\" width=\"984\" height=\"450\" align=\"middle\"\>";
//            strHtml = strHtml + "<embed src=\""+data.fileUrl+"\" quality=\"high\" width=\"984\" height=\"450\"  type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" /\>";
//            strHtml = strHtml + "</object\>";
//            $("#boful_video_player").empty().append(strHtml);
        });
    }

    var remarkScore = 0;
    try {
        $("#rankScore").raty({half: true, width: 110, click: function (score) {
            remarkScore = score * 2;
        }});
    } catch (e) {

    }

    $("#sharingContent").click(function () {
        $("#sharingContentDiv").show();
        $("#sharingListDiv").hide();
        $("#sharingArtialDiv").hide();
        $("#sharingContent").addClass("com_chose_meau");
        $("#sharingList").removeClass("com_chose_meau");
        $("#sharingArtial").removeClass("com_chose_meau");
    });
    $("#sharingList").click(function () {
        $("#sharingContentDiv").hide();
        $("#sharingListDiv").show();
        $("#sharingArtialDiv").hide();
        $("#sharingContent").removeClass("com_chose_meau");
        $("#sharingList").addClass("com_chose_meau");
        $("#sharingArtial").removeClass("com_chose_meau");
    });
    $("#sharingArtial").click(function () {
        $("#sharingContentDiv").hide();
        $("#sharingListDiv").hide();
        $("#sharingArtialDiv").show();
        $("#sharingContent").removeClass("com_chose_meau");
        $("#sharingList").removeClass("com_chose_meau");
        $("#sharingArtial").addClass("com_chose_meau");
    });

    $("#remarkSaveBtn").click(function () {
        var studyCommunityId = $("#studyCommunityId").val();
        var remarkContent = $("#remarkContent").val();
        if (remarkContent == "") {
            alert("评论内容不能为空!");
            return false;
        }
        var fileId = $("#fileId").val();
        var url = baseUrl + "community/specialRemarkSave";
        $.post(url, {content: remarkContent, rank: remarkScore, fileId: fileId, studyCommunityId: studyCommunityId}, function (data) {
            if (data.success) {
                var remarkDiv = $("#remarkDiv");
                var app = "";
                var remark = data.remark;
                var consumer = data.consumer;
                $.post(baseUrl + "ntsService/queryConsumerPhoto", {photo: consumer.photo}, function (data) {
                    app += "<div class=\"album_talk_item_pom\"><img src=\"" + data.url + "\"/></div>";
                    app += "<div class=\"album_talk_item_infor\"><div class=\"album_talk_item_des\">" +
                        "<p class=\"album_talk_user\"><span class=\"tl_user\"><a href=\"#\">" + consumer.name + "</a>" +
                        "</span><span class=\"tl_time\">" + remark.createdDate.substr(0, remark.createdDate.indexOf('T')) + "</span></p>" +
                        "<p class=\"album_user_back\">" + remark.remarkContent + "</p></div>" +
                        "<div id=\"reply_" + remark.id + "\"></div>" +
                        "<p class=\"aum_back_word\"><span onclick=\"replyShow(" + remark.id + ")\">回&nbsp;复</span></p>" +
                        "<div class=\"album_talk_back\" id=\"replyShowDiv_" + remark.id + "\" style=\"display: none\">" +
                        "<div class=\"album_talk_back_inp\"><label><textarea id=\"replyContent_" + remark.id + "\"></textarea></label></div>" +
                        "<div class=\"album_talk_back_but\"><label><input class=\"\" type=\"button\"" +
                        "value=\"评价\" onclick=\"replySave(" + remark.id + ")\"></label></div></div></div>";
                    remarkDiv.append(app);
                    $("#remarkContent").val('');
                });

            } else {
                alert(data.msg)
            }
        })
    });
});

function replyShow(tag) {
    if ($("#replyShowDiv_" + tag).css("display") == "none") {
        $("#replyShowDiv_" + tag).show();
    } else {
        $("#replyShowDiv_" + tag).hide();
    }
}
function replySave(tag) {
    var remarkId = tag;
    var replyContent = $("#replyContent_" + tag).val();
    if (replyContent == "") {
        alert("回复内容不能为空!");
        return false;
    }
    var url = baseUrl + "community/specialReplySave";
    $.post(url, {content: replyContent, remarkId: remarkId}, function (data) {
        if (data.success) {
            var reply = data.comment;
            var consumer = data.consumer;
            var replyDiv = $("#reply_" + tag);
            var appDiv = "";
            appDiv = "<div class=\"album_talk_back_items\"><p class=\"album_talk_user\"><span class=\"tl_user\"><a href=\"#\">" + consumer.name + "</a>" +
                "</span><span class=\"tl_time\">" + reply.createdDate.substr(0, reply.createdDate.indexOf('T')) + "</span></p>" +
                "<p class=\"album_user_back\">" + reply.commentContent + "</p></div>";
            replyDiv.append(appDiv);
        } else {
            alert(data.msg)
        }
    })
}
