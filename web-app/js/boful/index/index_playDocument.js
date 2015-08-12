/**
 * Created by ligson on 13-12-21.
 */
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
$(function () {
    flexpaperInit("document_player", swfFileUrl, baseUrl);

    var remarkScore = 0;
    $("#remarkBtn").click(function () {
        var con_name = $("#con_name").val();
        var content = $("#remarkContent");
        var programId = $("#programId").val();
        var proSerialId = $("#serialId").val();
        if (con_name == 'anonymity') {
            alert("请登录后在做评论!");
            return false;
        }
        if (content.val().length < 1 || content.val() == '') {
            alert("内容不能为空");
            content.focus();
            return false;
        }

        $.post(baseUrl + "program/saveRemark", {serialId: proSerialId, programId: programId, content: content.val(), rank: remarkScore}, function (data) {
            if (data.success) {
                var appendHtml="";
                var remark = data.remark;
                var consumer = data.consumer;
                var name = $("#con_name").val();
                var consumerId = $("#consumerId").val();
                var consumerPhoto = $("#consumerPhoto").val();
                if(remark!=null){
                    // 审核判断
                    if(!remark.isPass) {
                        alert(data.msg);
                        return;
                    }
                    if(data.isFlag){
                        $(".playdocumment_left_column_talk_input_star").empty();
                    }
                    $.post(baseUrl+"ntsService/queryConsumerPhoto",{photo:consumerPhoto},function(res){
                        appendHtml+="<div class=\"playdocumment_left_column_talk_box\" id=\"remark"+remark.id+"\">"+
                            "<p class=\"playdocumment_left_column_talk_box_portrait\"><a title=\""+consumer.name+"\" href=\""+baseUrl+"my/userSpace?id="+consumer.id+"\">"+
                            "<img src=\""+res.url+"\" width=\"35\" height=\"35\"/>"+
                            "</a></p><div class=\"playdocumment_left_column_talk_contets\">"+
                            "<div class=\"playdocumment_left_column_talk_contets_user\"><span class=\"playdocumment_left_column_talk_contets_user_name\"><a "+
                            "title=\""+consumer.name+"\" href=\""+baseUrl+"my/userSpace?id="+consumer.id+"\">"+consumer.name+"</a>"+
                            "</span><span class=\"playdocumment_left_column_talk_contets_user_date\">"+remark.dateCreated.substr(0, remark.dateCreated.indexOf('T'))+"</span>"+
                            "</div><p class=\"playdocumment_left_column_talk_contets_user_words\">"+remark.content+"</p>"+
                            "<div class=\"playdocumment_left_column_talk_back_others\" id=\"replyList_"+remark.id+"\">";
                        appendHtml+="</div><div class=\"playdocumment_left_column_talk_contets_user_words_back\">"+
                            "<a href=\"javascript:void(0);\" onclick=\"replyDiv("+remark.id+")\" id=\"remark_a\" >回复</a>";
                        if(consumer.id == consumerId){
                            appendHtml+="<a href=\"javascript:void(0);\" onclick=\"remarkDelete("+remark.id+")\">删除</a>";
                        }
                        appendHtml+="</div><div class=\"playdocumment_left_column_talk_contets_user_words_content\" style=\"display:none;\" id=\"replyDiv_"+remark.id+"\">"+
                            "<textarea style=\"height: 100px;width: 596px;border: 1px solid #e4e4e4; padding: 5px\" id=\"reply_"+remark.id+"\"></textarea>"+
                            "<input class=\"playdocumment_left_column_talk_contets_user_words_content_but1\" type=\"button\" value=\"确认评价\" onclick=\"replyRemark("+remark.id+")\">"+
                            "</div></div></div><input type=\"hidden\" id=\"remarkId\" value=\""+remark.id+"\">"+
                            "<input type=\"hidden\" id=\"replyNum\" value=\""+remark.replyNum+"\"><input type=\"hidden\" id=\"remarkName\" value=\""+name+"\">";

                        $("#remarkDiv").prepend(appendHtml);
                    });

                }

            } else {
                alert(data.msg);
            }
        });
    });


    try {
        $("#rankScore").raty({half: true, width: 110, click: function (score) {
            remarkScore = score * 2;
        }});
    } catch (e) {

    }


    $(".playdocumment_left_column_talk_contets_user_words_back #remark_a").click(function () {
        $(this).parent().next().toggle("slow");
    });

});

function replyDiv(index){
    var replyDiv = $("#replyDiv_"+index);
    if(replyDiv.css("display")=='none')replyDiv.show();
    else replyDiv.hide();
}

function remarkDelete(remarkID) {
    $.post(baseUrl + "program/remarkDelete", {remarkID: remarkID}, function (data) {
        if (data.success) {
            alert(data.msg);
            $("#remark"+remarkID).remove();
        } else {
            alert(data.msg);
        }
    });
}

function replyRemark(id) {
    var con_name = $("#con_name").val();
    if (con_name == 'anonymity') {
        alert("请登录后在做评论!");
        return false;
    }
    var content = $("#reply_" + id).val();
    var replyNum = $("#replyNum").val();
    if (!content.isEmpty()) {
        $.post(baseUrl + "program/saveRemarkReply", {id: id, content: content, replyNum: replyNum}, function (data) {
            if (data.success) {
                var html = "<div class=\"playdocumment_left_column_talk_back_other\"><div class=\"playdocumment_left_column_talk_back_other_backname\">" +
                    "<h3>" + "<a title='" + data.user + "' href='/my/userSpace/" + data.consumerId + "'>" + data.user + "</a></h3>" +
                    "<span>" + data.date + "</span>" +
                    "</div>";

                $("#replyList_" + id).append(html + "<p>" + content + "</p></div>");
                $("#reply_" + id).val("");
            }
        });
    } else {
        alert("请输入内容！！！");
    }

}