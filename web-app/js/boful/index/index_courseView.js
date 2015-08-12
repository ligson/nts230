var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}


var scrollbarArray = [];

function resizeCourseView() {
    var ww = $(window).width();
    if (ww < 1024) {
        $(".boful_course").css("width", 1024);
    } else {
        $(".boful_course").css("width", ww);
    }
}

//def consumerId = params.consumerId;
//def serialId = params.serialId;
//def timeLength = params.timeLength;
//def note = params.note;
//def canPublic = params.canPublic;
function voteNote(noteId, numId) {

    $.post(baseUrl + "index/voteNote", {noteId: noteId, consumerId: currentConsumerId}, function (data) {

        if (data.success) {
            var voteNumTag = $("#" + numId);
            voteNumTag.empty();
            voteNumTag.append("(" + data.voteNum + ")");
        } else {
            alert(data.msg);
        }
    });
}
function loadNewNote(serialId) {
    $.post(baseUrl + "index/listNewNote", {serialId: serialId}, function (data) {
        //alert(data);
        if (data.success) {
            var htmlString = "";
            for (var i = 0; i < data.notes.length; i++) {
                var noteItem = data.notes[i];
                htmlString += "<div class=\"note_cont_item\">";
                htmlString += "   <div class=\"note_item_icon\"></div>";

                htmlString += "   <div class=\"note_master_write\">";
                htmlString += "   <div class=\"note_master_write_time\"><a href=\"#\">" + noteItem.timeLength + "</a></div>";

                htmlString += "   <div class=\"note_master_write_from\"><span class='note_name_m'>" + noteItem.consumer.name + "</span><span>来自：</span></div>";
                htmlString += "</div>";

                htmlString += "<div class=\"note_master_write_describe\">";
                htmlString += noteItem.content;
                htmlString += "</div>";

                htmlString += "<div class=\"note_master_date\">";
                htmlString += "<p class=\"note_todate\">" + noteItem.createDate + "</p>";
                htmlString += "<p class=\"note_good\"><span class=\"good_number\" id='newNote_" + noteItem.id + "'>(" + noteItem.voteNum + ")</span><span class=\"good_icon\" onclick='voteNote(" + noteItem.id + ",\"newNote_" + noteItem.id + "\")'></span></p>";
                htmlString += "</div>";
                htmlString += "</div>";
            }


            $($("#scrollbar3").find(".overview")).empty().append(htmlString);
            scrollbarArray[2].update();
        }
    });
}

function loadVoteNote(serialId) {
    $.post(baseUrl + "index/listVoteNote", {serialId: serialId}, function (data) {
        //alert(data);
        if (data.success) {
            var htmlString = "";
            for (var i = 0; i < data.notes.length; i++) {
                var noteItem = data.notes[i];
                htmlString += "<div class=\"note_cont_item\">";
                htmlString += "   <div class=\"note_item_icon\"></div>";

                htmlString += "   <div class=\"note_master_write\">";
                htmlString += "   <div class=\"note_master_write_time\"><a href=\"#\">" + noteItem.timeLength + "</a></div>";

                htmlString += "   <div class=\"note_master_write_from\"><span class='note_name_m'>" + noteItem.consumer.name + "</span><span>来自：</span></div>";
                htmlString += "</div>";

                htmlString += "<div class=\"note_master_write_describe\">";
                htmlString += noteItem.content;
                htmlString += "</div>";

                htmlString += "<div class=\"note_master_date\">";
                htmlString += "<p class=\"note_todate\">" + noteItem.createDate + "</p>";
                htmlString += "<p class=\"note_good\"><span class=\"good_number\" id='voteNote_" + noteItem.id + "'>(" + noteItem.voteNum + ")</span><span class=\"good_icon\" onclick='voteNote(" + noteItem.id + ",\"voteNote_" + noteItem.id + "\")'></span></p>";
                htmlString += "</div>";
                htmlString += "</div>";
            }


            $($("#scrollbar2").find(".overview")).empty().append(htmlString);
            scrollbarArray[1].update();
        }
    });
}

function loadNote(userId, serialId) {


    $.post(baseUrl + "index/listMyNote", {consumerId: userId, serialId: serialId}, function (data) {
        //alert(data);
        if (data.success) {
            var htmlString = "";
            for (var i = 0; i < data.notes.length; i++) {
                var noteItem = data.notes[i];
                htmlString += "<div class=\"note_cont_item\">";
                htmlString += "   <div class=\"note_item_icon\"></div>";

                htmlString += "   <div class=\"note_master_write\">";
                htmlString += "       <div class=\"note_master_write_time\"><a href=\"#\">" + noteItem.timeLength + "</a></div>";

                htmlString += "       <div class=\"note_master_write_fnamerom\"><span class='note_name_m'>" + noteItem.consumer.name + "</span><span>来自：</span></div>";
                htmlString += "   </div>";

                htmlString += "   <div class=\"note_master_write_describe\">";
                htmlString += noteItem.content;
                htmlString += "   </div>";

                htmlString += "   <div class=\"note_master_date\">";
                htmlString += "       <p class=\"note_todate\">" + noteItem.createDate + "</p>";
                htmlString += "   </div>";
                htmlString += " </div>";
            }


            var sb1 = $("#scrollbar1");
            $(sb1.find(".overview")).empty();
            $(sb1.find(".overview")).append(htmlString);
            scrollbarArray[0].update();
        }
    });
}
function createNote(userId, serialId) {
    var timeLength = jwplayer("boful_video_player").getPosition();
    var note = $($(".note_write").find("textarea")).val();
    if ((note + "").isEmpty()) {
        alert("不允许为空");
        return false;
    }
    var canPublic = $(".note_write_save1").prop("checked");
    $.post(baseUrl + "index/createNote", {consumerId: userId, serialId: serialId, timeLength: timeLength, canPublic: canPublic, note: note}, function (data) {
        // alert(data.success);
        if (data.success) {
            loadNote(userId, serialId);
        }
        $($(".note_write").find("textarea")).val("");
    });
}
var remarkScore = 0;
$(function () {
    resizeCourseView();
    $(window).resize(function () {
        resizeCourseView();
    });

    var boxRight = $(".boful_video_infor_box_right");
    var noteBtn = boxRight.find(".s_note");
    var listBtn = boxRight.find(".s_list");

    var sb1 = $("#scrollbar1");
    var sb2 = $("#scrollbar2");
    var sb3 = $("#scrollbar3");
    var sb4 = $("#scrollbar4");

    sb1.tinyscrollbar({axis: "y"});
    sb2.tinyscrollbar({axis: "y"});
    sb3.tinyscrollbar({axis: "y"});
    sb4.tinyscrollbar({axis: "y"});

    var scrollbarData1 = sb1.data("plugin_tinyscrollbar");
    var scrollbarData2 = sb2.data("plugin_tinyscrollbar");
    var scrollbarData3 = sb3.data("plugin_tinyscrollbar");
    var scrollbarData4 = sb4.data("plugin_tinyscrollbar");

    scrollbarArray[0] = scrollbarData1;
    scrollbarArray[1] = scrollbarData2;
    scrollbarArray[2] = scrollbarData3;
    scrollbarArray[3] = scrollbarData4;

    var currentScrollbarIndex = 0;
    noteBtn.click(function () {
        $(".note_cont_itemsa").hide();
        $(".infor_box_note").fadeIn();
        scrollbarArray[currentScrollbarIndex].update();
    });
    listBtn.click(function () {
        $(".infor_box_note").hide();
        $(".note_cont_itemsa").fadeIn(function () {
            scrollbarArray[3].update();
        });
    });


    var noteItemsContainer = $(".infor_box_note_cut").find("p");
    var spans = noteItemsContainer.find("span");
    var noteItems = $(".note_conts").find(".note_cont_items");

    spans.click(function () {
        $(spans).removeClass("note_item_tab");
        $(this).addClass("note_item_tab");
        var index = $(spans).index($(this));
        currentScrollbarIndex = index;
        for (var i = 0; i < noteItems.length; i++) {
            if (i != index) {
                var noteItem = noteItems[i];
                $(noteItem).hide();
            }
        }
        $(noteItems[index]).fadeIn(function () {
            var positionCurrent = scrollbarArray[currentScrollbarIndex].contentPosition + scrollbarArray[currentScrollbarIndex].viewportSize;
            scrollbarArray[currentScrollbarIndex].update();
        });
    });

    $("#rankScore").raty({half: true, width: 110, click: function (score) {
        remarkScore = score * 2;
    }});

    $("#serialLink").raty({readOnly: true, width: 110, score: 3.5});
    $("#remarkBtn").click(function () {
        var con_name = $("#con_name").val();
        var topic = $("#remarkTopic");
        var content = $("#remarkContent");
        var programId = $("#programId").val();
        if (topic.val() == '') {
            alert("主题不能为空");
            topic.focus();
            return false;
        }
        if (content.val() == '') {
            alert("内容不能为空");
            content.focus();
            return false;
        }
        if (con_name == 'anonymity') {
            alert("请登录后在做评论!");
            return false;
        }
        $.post(baseUrl + "program/saveRemark", {programId: programId, topic: topic.val().trim(), content: content.val(), rank: remarkScore}, function (data) {
            if (data.success) {
                window.location.reload();
            } else {
                alert(data.msg);
            }
        });
    });

    //显示评分星星
    /*var programIds = $("input[name='programId']")//得到所有program
     for(var i=0; i<programIds.size(); i++){
     var programId = programIds[i].value;
     var serialLinkValue = $("#serialLink"+programId).val()/2;
     var serialLinkShowDiv = $("div[name='serialLinkShow"+programId+"']");
     serialLinkShowDiv.raty({readOnly: true, score: serialLinkValue});
     }*/
    //设置cookie，当刷新页面的时候，记录上次位置
    var femarkOrQuestion = $.cookie("femarkOrQuestion");
    if (femarkOrQuestion == 'question') {
        showQuestion()
    } else {
        showRemark();
    }
});
/*%{--提交问题--}%*/
function submitCourseAnswer() {
    var courseAnswerVal = $("#remarkTopic").val();
    var programId = $("#programId").val();
    var courseTotal = $("#courseTotal").val();
    if (courseAnswerVal == "") {
        alert("亲～您还没有写问题呢");
    } else {
        var pars = {remarkTopic: courseAnswerVal, programId: programId, courseTotal: courseTotal};
        var url = baseUrl + "index/saveCourseQuestion";
        var otherQuerstion = $(".other_querstion");
        $.post(url, pars, function (data) {
            alert("提交成功！！");
            $("#remarkTopic").val("");
            otherQuerstion.after(data.appendHtml);
            $("#courseTotal").val(data.courseTotal);
        })
        /*$.ajax({
         url: url,
         data: pars,
         success: function (data) {

         //$("#course_question_user_massage_cons_Id"+courseTotal).css("width","600px");
         }
         })*/
    }
}
/*%{--显示隐藏回答问题--}%*/
/*function iAnswerQuestion(status){
 var course_question_user_back = $("#course_question_user_back"+status);            *//*%{--得到回答的div，用来显示隐藏--}%*//*
 var answer_Question = $("#answer_Question_Id"+status);                                *//*       %{--得到回答标签，用来修改显示的值--}%*//*
 if(course_question_user_back.is(":hidden")){
 course_question_user_back.show();
 answer_Question.text("隐藏回答");
 }else{
 course_question_user_back.hide();
 answer_Question.text("我来回答");
 }
 }*/
/*%{--回答问题--}%*/
function submitQusetionSolution(status, courseQuestionId, consumerId) {
    var question_contentText = $("#question_content" + status)[0].value;
    if (question_contentText == "") {
        alert("亲～请您填写答案");
        return false;
    } else {
        $.post(baseUrl + "index/saveCourseAnswer", {
            courseQuestionId: courseQuestionId,
            courseAnswerContent: question_contentText
        }, function (data) {
            if (data.saveError != null) {
                alert(data.saveError);
            }
            alert("回答成功");
            $("#question_content" + status).val("");
            var str = '<div class="course_question_back_items">';
            str += '<div class="course_question_back_item">';
            str += '<div class="course_question_back_item_con">' + question_contentText;
            str += '</div>'
            str += '<div class="course_question_back_item_infor">'
            str += '<span class="course_question_user_massage_name">回答者：<a title="' + data.courseAnswerConsumer.name + '" href="'+baseUrl+'my/userSpace/' + data.courseAnswerConsumer.id + '">' + data.courseAnswerConsumer.name + '</a>';
            str += '</span>';
            str += '<span class="course_question_user_massage_time">' + data.courseAnswerCreateDate + '</span>';
            if (consumerId == data.courseQuestion.consumer.id) {
                str += '<span class="course_question_back_mark"><a onclick="acceptionRightAnswer(' + data.courseQuestion.id + ',' + data.courseAnswer.id + ')">采纳答案</a><a class="mark_line">|</a></span>'
            }

            str += '</div>';
            str += '</div>';
            str += '</div>';
            $("#course_question_back_all" + status).after(str);
        })
    }
}
/*%{--采纳答案--}%*/
function acceptionRightAnswer(courseQuestionId, courseAnswerId) {
    $.post(baseUrl + "index/acceptionRightAnswer", {
        courseAnswerId: courseAnswerId,
        courseQuestionId: courseQuestionId,
        serialId: $("#serialId").val()
    }, function () {
        window.location.reload()
    })
}
/*显示隐藏答案*/
function answerShowOrHidden(status) {
    var course_question_user_back = $("#course_question_user_back" + status);     //获取div的id
    var answer_Question = $("#answer_Question_Id" + status);                      //获取回答字体
    //判断回答是否隐藏
    if (course_question_user_back.is(":hidden")) {
        course_question_user_back.show();
        answer_Question.text("隐藏回答");
    } else {
        course_question_user_back.hide();
        answer_Question.text("我来回答");
    }
}
/*显示评论*/
function showRemark() {
    //设置字体样式
    $("#showRemarkId").attr("style", "color:#53A93F");
    $("#showQuestionId").attr("style", "");

    var boful_course_content_directory_talk = $("#boful_course_content_directory_talk_Id");
    var boful_course_content_directory_question = $("#boful_course_content_directory_question_Id");
    if (boful_course_content_directory_talk.is(":hidden")) {
        boful_course_content_directory_talk.show();
        boful_course_content_directory_question.hide();
    }
    $.cookie("femarkOrQuestion", "remark", {path: baseUrl + "program/courseView"});
}
/*显示问题*/
function showQuestion() {
    //设置字体样式
    $("#showQuestionId").attr("style", "color:#53A93F");
    $("#showRemarkId").attr("style", "");

    var boful_course_content_directory_talk = $("#boful_course_content_directory_talk_Id");
    var boful_course_content_directory_question = $("#boful_course_content_directory_question_Id");
    if (boful_course_content_directory_question.is(":hidden")) {
        boful_course_content_directory_question.show();
        boful_course_content_directory_talk.hide();
    }
    $.cookie("femarkOrQuestion", "question", {path: baseUrl + "program/courseView"});
}
/*保存评论*/
function saveRemark(serialId) {
    var remarkContent = $("#remarkContentId")[0].value;
    var star = $("#rankScore")[0].score[0].defaultValue;
    var courseItems = $("#boful_course_play_class_items_remark");
    var remarkTotal = $("#remarkTotal").val();
    var appendDiv = "";
    if (remarkContent == "") {
        alert("您还没有写评论");
        return false;
    }
    if (star == "") {
        star = 0;
    }
    $.post(baseUrl + "index/saveRemark", {
        serialId: serialId,
        rank: remarkScore,
        remarkContent: remarkContent,
        remarkTotal: remarkTotal
    }, function (data) {
        if(!data.isPass){
            alert("提交成功，谢谢您的评论，但须管理员审核后方能显示。");
            return;
        }
        alert("评论成功!!");
        $("#remarkContentId").val("");
        $("#remarkTotal").val(data.total);
        if(data.isFlag){
            $(".column_talk_input_start").empty();
        }
        courseItems.prepend(data.appendHtml);
    })
}
/*显示回复*/
function showRemarkReplys(status) {
    var course_others_talkback = $("#course_others_talkback_Id" + status);                    //全部回复
    var course_play_user_massage_talk_back = $("#course_play_user_massage_talk_back_Id" + status);//回复标签
    var remarkReply = $("input[name='remarkReplyNum" + status + "']")           //回复的div class
    if (course_others_talkback.is(":hidden")) {
        course_others_talkback.show();
        course_play_user_massage_talk_back.text("隐藏回复");
    } else {
        course_others_talkback.hide();

        course_play_user_massage_talk_back.text("回复数：" + remarkReply.size());
    }
}
/*提交回复*/
function submitRemarkReply(status, remarkId) {
    var onClickObj = this;
    var remarkContent = $("#remarkReply" + status).val();
    if (remarkContent == "") {
        alert("您还没有输入内容");
        return false;
    }
    $.post(baseUrl + "index/saveRemarkReply", {
        remarkId: remarkId,
        content: remarkContent
    }, function (data) {
        if (data.params != null) {
            alert(data.parems.saveError)
        } else {
            var course_others_talkback_items = $("#course_others_talkback_items_Id" + status)
            var div = '<input type="hidden" name="remarkReplyNum' + status + '" value=""/>';
            div += '<div class="course_others_talkback_item">';
            div += '<div class=" course_others_talkback_item_image"><a title="' + data.consumer.name + '" href="'+baseUrl+'my/userSpace/' + data.consumer.id + '">';
            //请求判断头像是否存在
            var photoPath = "";
            $.ajax(baseUrl + "upload/photo/" + data.consumer.photo, {
                async: false,
                error: function () {
                    photoPath = baseUrl + "skin/blue/pc/front/images/photo.gif";
                },
                success: function () {
                    photoPath = baseUrl + "upload/photo/" + data.consumer.photo;
                }
            })
            div += '<img src="' + photoPath + '" /></a>';
            div += '</div>';
            div += '<div class="course_others_talk_back">';
            div += '<div class="course_others_talk_back_infor">';
            div += '<span class="course_play_user_massage_name"><a title="' + data.consumer.name + '" href="'+baseUrl+'my/userSpace/' + data.consumer.id + '">' + data.consumer.name + '</a></span>';
            div += '<span class="course_play_user_massage_time">' + data.remarkReplyCreateDate + '</span>';
            div += '</div>';
            div += '<p class="course_others_talkback_descript">' + remarkContent;
            div += '</p></div></div>';
            alert("回复成功");
            $("#remarkReply" + status).val("");
            course_others_talkback_items.prepend(div);
        }
    })
}
