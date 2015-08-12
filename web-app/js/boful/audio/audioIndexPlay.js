/**
 * Created by Administrator on 5/20/14.
 */
/**
 * 页面加载完成后执行
 */
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if ('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}

var remarkScore = 0;

$(document).ready(function () {
//    var localObj = window.location;
//    var contextPath = localObj.pathname.split("/")[1];
//    //前面url获取
//    var baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
    //绑定鼠标移动上去时间
    $(".audio_album_icon p").bind("mouseover", function () {
        if (this.childNodes[0].className == "al_play") {
            this.childNodes[0].style.background = "url(" + baseUrl + "skin/blue/pc/front/images/al_p.png)";
        }
        if (this.childNodes[0].className == "al_recommend") {
            this.childNodes[0].style.background = "url(" + baseUrl + "skin/blue/pc/front/images/al_re.png)";
        }
        if (this.childNodes[0].className == "al_save") {
            this.childNodes[0].style.background = "url(" + baseUrl + "skin/blue/pc/front/images/al_sv.png)";
        }
    })
    //绑定鼠标移除样式
    $(".audio_album_icon p").bind("mouseout", function () {
//                this.childNodes[0].style.removeProperty("background");
        if (this.childNodes[0].className == "al_play") {
            this.childNodes[0].style.background = "url(" + baseUrl + "skin/blue/pc/front/images/al_p_m.png)";
        }
        if (this.childNodes[0].className == "al_recommend") {
            this.childNodes[0].style.background = "url(" + baseUrl + "skin/blue/pc/front/images/al_re_m.png)";
        }
        if (this.childNodes[0].className == "al_save") {
            this.childNodes[0].style.background = "url(" + baseUrl + "skin/blue/pc/front/images/al_sv_m.png)";
        }
    })
    //初始化audio专辑资源目录播放列表
    /*$("#audioTbody tr").each(function(i){
     var filePath = $("#audioPath"+i).val();
     var fileHash = $("#audioFileHash"+i).val();
     var id = $("#audioId"+i).val();
     var playList = $("#audioHash"+i).val();
     playList = typeof (playList)=="string"?eval(playList):playList;

     if(checkFileType(filePath)==4){
     jwplayerInit("container"+i, playList, "200", "20", false, false);
     var thePlayer=jwplayer("container"+i);
     $('#apaly'+i).click(function() {
     if (thePlayer.getState() != 'PLAYING') {
     thePlayer.play(true);
     //this.value = '暂停';
     } else {
     thePlayer.play(false);
     //this.value = '播放';
     }
     });
     } else {
     $('#apaly'+i).click(function() {
     if(checkFileType(filePath)==1) {
     window.open(baseUrl + "program/singlePlay?id="+id+"&playType=video&fileHash="+fileHash, '_blank');
     } else if(checkFileType(filePath)==3){
     window.open(baseUrl + "program/singlePlay?id="+id+"&playType=image&fileHash="+fileHash, '_blank');
     } else if(checkFileType(filePath)==2){
     window.open(baseUrl + "program/singlePlay?id="+id+"&playType=document&fileHash="+fileHash, '_blank');
     }else if(checkFileType(filePath)==5){
     window.open(baseUrl + "program/singlePlay?id="+id+"&playType=flash&fileHash="+fileHash, '_blank');
     }
     });
     }
     });*/
    $("#rankScore").raty({half: true, width: 110, click: function (score) {
        remarkScore = score * 2;
    }});
})

function playProgram(index) {
    var filePath = $("#audioPath" + index).val();
    var fileHash = $("#audioFileHash" + index).val();
    var id = $("#audioId" + index).val();
    var name = $("#audioName" + index).val();

    if (checkFileType(filePath) == 4) {
        $("#playingItem").text("正在播放" + name);
        jwplayer("audioPlayer").playlistItem(index);
//        var thePlayer = jwplayer("audioPlayer");
//        if (thePlayer.getState() != 'PLAYING') {
//            thePlayer.play(true);
//            //this.value = '暂停';
//        } else {
//            thePlayer.play(false);
//            //this.value = '播放';
//        }
    } else {
        if (checkFileType(filePath) == 1) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=video&fileHash=" + fileHash, '_blank');
        } else if (checkFileType(filePath) == 3) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=image&fileHash=" + fileHash, '_blank');
        } else if (checkFileType(filePath) == 2) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=document&fileHash=" + fileHash, '_blank');
        } else if (checkFileType(filePath) == 5) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=flash&fileHash=" + fileHash, '_blank');
        }
    }
}
function trim(str) { //删除左右两端的空格
    return str.replace(/(^\s*)|(\s*$)/g, "");
}
//资源平价
function fnevaluate(userName) {
    if (userName == "" || userName == 'anonymity') {
        alert("请先登录!");
        return;
    }
    var programId = $("#pId").val();
    var text = trim($("#evaluateTextarea").val());
    if (text == '') {
        alert("评价为空,不能发表")
    } else {
        $.post(baseUrl + "program/evaluate", {programId: programId, text: text, rank: remarkScore}, function (data) {
            data = eval(data);
            if (!data[0].isPass) {
                alert("提交成功，谢谢您的评论，但须管理员审核后方能显示。");
                return;
            }
            var programRemark = $("#programRemark0").clone(true).insertAfter("#programRemark0");//评论对象
            programRemark.attr("id", "programRemark_" + data[0].id);
            $.post(baseUrl + "ntsService/queryConsumerPhoto", {photo: data[1].photo}, function (photoPath) {
                photoPath = eval(photoPath)
                programRemark.find("#consumerImg").attr("src", photoPath.url);//头像
            })
            programRemark.find("#rDiv").attr("id", "rDiv_" + data[0].id);//
            var remarkId = programRemark.find("#remarkId").attr("id", "remarkId_" + data[0].id);//评论id
            $(remarkId).val(data[0].id);
            var remarkConsumerName = programRemark.find("#remarkConsumerName").attr("id", "remarkConsumerName_" + data[1].id);//评论人名称
            $(remarkConsumerName).append(data[1].name);
            var remarkDateCreate = programRemark.find("#remarkDateCreate").attr("id", "remarkDateCreate_" + data[0].id);//评论日期
            $(remarkDateCreate).append(data[0].dateCreated.substr(0, data[0].dateCreated.indexOf('T')));
            var remarkContent = programRemark.find("#remarkContent").attr("id", "remarkContent_" + data[0].id);//评论内容
            $(remarkContent).append(data[0].content);

            var fnReply = programRemark.find("#fnReply").attr("id", "fnReply_" + data[0].id);//回复链接
            var remarkDiv = programRemark.find("#remarkDiv").attr("id", "remarkDiv_" + data[0].id);//回复框div

            var replyTextarea = programRemark.find("#replyTextarea").attr("id", "replyTextarea_" + data[0].id);//回复框
            var remarkReplyEvaluateId = programRemark.find("#remarkReplyEvaluateId").attr("id", "remarkReplyEvaluateId_" + data[0].id);//回复框
            $("#evaluateTextarea").val("")
            programRemark.show()
        })
    }
}
//回复
function fnreply(obj, userName) {
    if (userName == "" || userName == 'anonymity') {
        alert("请先登录!");
        return;
    }
    var div1 = $("#remarkDiv_" + sub_id($(obj).attr('id'))).show();
}
//截取XXX_id  中id
function sub_id(str) {
    return str.substr(str.indexOf('_') + 1);
}
//回复平价  replyTextarea
function fnevaluate2(obj) {
    var id = sub_id($(obj).attr('id'));
    var remarkId = $("#remarkId_" + id).val();
    var text = trim($("#replyTextarea_" + id).val());
    if (text == '') {
        alert("回复为空不能评价");
        return false;
    } else {
        $.post(baseUrl + "program/reply", {remarkId: remarkId, text: text}, function (data) {
            data = eval(data);
            var replyDiv = $("#replyDiv0").clone(true).insertAfter("#rDiv_" + remarkId);//回复对象
            $(replyDiv).attr('id', "replyDiv_" + data[0].id);
            $(replyDiv).find("#replyConsumerName").append(data[1].name)
            $(replyDiv).find("#replyDateCreate").append(data[0].dateCreated.substr(0, data[0].dateCreated.indexOf('T')))
            $(replyDiv).find("#replyContent").append(data[0].content)
            replyDiv.show();
            $("#remarkDiv_" + id).hide()
            $("#replyTextarea_" + id).val("")
        })
    }
}

