<%@ page import="com.boful.common.file.utils.FileType; nts.program.domain.RemarkScore; nts.user.domain.Consumer; com.boful.common.date.utils.TimeLengthUtils; java.text.SimpleDateFormat; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>课程简介</title>
    <meta name="layout" content="index">

    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'courseView.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'courseDetail.css')}">
    <r:require modules="jwplayer,raty,string"/>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'js/tiny/scrollbar/simple/css', file: 'website.css')}">
    <script type="text/javascript"
            src="${resource(dir: 'js/tiny/scrollbar/simple/js', file: 'jquery.tinyscrollbar.js')}"></script>
    <script type="text/javascript">
        var currentConsumerId = ${session.consumer.id} ? ${session.consumer.id} : 0;
    </script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/index/index_courseView.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
    <script type="text/javascript">
        var isAnonymous = ${session.consumer?(session.consumer?.name?.equals(application.anonymityUserName)):true};
        var lastTime = ${playedProgram?playedProgram.timeLength:-1};
        /*如果是笔记记录存在，则定位到笔记位置*/
        <g:if test="${note&&note.logicLength}">
        lastTime = ${note.logicLength};
        </g:if>

        var serialId = ${serial.id};
        var problemFlg = false;
        if (${problemFlg}) {
            problemFlg = ${problemFlg};
        }
        $(function () {
            var playList = ${playLinksNew(fileHash:serial.fileHash)};
            jwplayerInit("boful_video_player", playList, "100%", "100%", true, false);
            jwplayer("boful_video_player").playlistItem(${serial?.serialNo-1});
            jwplayer("boful_video_player").onTime(function (event) {
                if (!isAnonymous) {
                    var position = event.position;
                    if (position == parseInt(position) && position % 10 == 0) {
                        position = parseInt(position);
                        $.post("${createLink(controller:'program',action:'recoderPosition')}", {time: position, serialId: serialId}, function (data) {

                        });
                    }
                }
            });

            for (var i = 0; i < playList.length; i++) {
                var item = playList[i];
                if (item.id ==${serial.id}) {
                    jwplayer("boful_video_player").playlistItem(i);
                }
            }
            if (lastTime >= 0) {
                jwplayer("boful_video_player").seek(lastTime);
            }
            loadNewNote(${serial.id});
            loadVoteNote(${serial.id});
            loadNote(${session.consumer?.id}, ${serial.id});

            if (problemFlg) {
                window.location.hash = "#showQuestionId";
                $("#showQuestionId").trigger("click");
            }
        });
    </script>
</head>

<body>
<input id="con_name" type="hidden" value="${session?.consumer?.name}">

<div class="boful_course">
<div class=" boful_course_botm">
    <div class="boful_course_names_bgs">
        <div class="boful_course_name wrap">
            <div class="boful_course_name_box">
                <div class="boful_course_name_title">
                    <g:if test="${serial.program.programCategories && serial.program.programCategories.size() > 0}">
                        <g:each var="programCategory" in="${serial.program.programCategories.toList()}">
                            <a class="course_name_frist" title="${programCategory.name}"
                               href="${createLink(controller: 'program', action: 'courseList', params: [categoryId: programCategory.id])}">
                                ${CTools.cutString(programCategory.name, 10)}
                            </a>
                        </g:each>
                    </g:if>


                    <span class="course_mark"></span>
                    <a class="course_name_second" title="${serial?.program?.name}"
                       href="${createLink(controller: 'program', action: 'courseDetail', params: [programId: serial.program.id])}">&nbsp;${CTools.cutString(serial?.program?.name, 20)}</a>
                </div>

                <p class="course_present_name">${CTools.cutString(serial?.name, 20)}</p>
            </div>

            <div class="boful_course_name_download">
                <g:if test="${isCanDownload}">
                    <a target="_blank"
                       href="${createLink(controller: 'program', action: 'downloadSharing', params: [serialId: serial?.id])}">
                        <span class="course_download_icon"></span>
                        <span class="course_download_name">下&nbsp;载</span>
                    </a></g:if>
            </div>
        </div>
        %{--  <div class="boful_course_name_download">
              <span class="course_download_icon"></span>
              <span class="course_download_name">下&nbsp;载</span>
          </div>--}%
    </div>

    <div class="wrap course_play_top_m">
        <div class="boful_course_play">
            <!-------播放窗口------->
            <div class="boful_course_play_window">
                <div id="boful_video_player" style="width:100%;height:100%;"></div>
            </div>
            <!-------播放窗口结束------->
            <!---右侧--->
            <div class="boful_video_infor_box">
                <!-------右侧部分------>
                <div class="boful_video_infor_box_left">
                    <!-----------笔记------>
                    <div class="infor_box_note" style="display: none">
                        <div class="infor_box_note_cut">
                            <p>
                                <span>${message(code: 'my.myNotes.name')}</span>

                                <span>${message(code: 'my.goodNotes.name')}</span>

                                <span>${message(code: 'my.latestNotes.name')}</span>
                            </p>
                        </div>

                        <div class="note_conts">
                            <div class="note_cont_items" id="scrollbar1">
                                <div class="scrollbar">
                                    <div class="track">
                                        <div class="thumb">
                                            <div class="end"></div>
                                        </div>
                                    </div>
                                </div>

                                <div class="viewport">
                                    <div class="overview">

                                    </div>
                                </div>
                            </div>

                            <div class="note_cont_items" style="display:none;" id="scrollbar2">
                                <div class="scrollbar">
                                    <div class="track">
                                        <div class="thumb">
                                            <div class="end"></div>
                                        </div>
                                    </div>
                                </div>

                                <div class="viewport">
                                    <div class="overview">
                                    </div>
                                </div>

                            </div>

                            <div class="note_cont_items" style="display:none;" id="scrollbar3">
                                <div class="scrollbar">
                                    <div class="track">
                                        <div class="thumb">
                                            <div class="end"></div>
                                        </div>
                                    </div>
                                </div>

                                <div class="viewport">
                                    <div class="overview">
                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class="note_write">
                            <div>
                                <label>
                                    <textarea></textarea>
                                </label>
                            </div>

                            <div class="note_write_save">
                                <p class="note_write_chose">
                                    <label>
                                        <input class="note_write_save1"
                                               type="checkbox"><span>${message(code: 'my.public.name')}</span>
                                    </label></p>

                                <p>
                                    <label>
                                        <input class="note_write_save2" type="button" value="发表笔记" id="writeNoteBtn"
                                               onclick="createNote(${session.consumer?.id}, ${serial.id})">
                                    </label>
                                </p>
                            </div>
                        </div>
                    </div>
                    <!----------视频列表------------>
                    %{--<div class="infor_box_lists">--}%
                    <div class="note_cont_itemsa" id="scrollbar4">
                        <!----------滚动条-------------->
                        <div class="scrollbar" style="background: #373e44">
                            <div class="track" style="background: #2b3136">
                                <div class="thumb" style="background: #373e44">
                                    <div class="end" style="background: #373e44"></div>
                                </div>
                            </div>
                        </div>
                        <!-----------内容----------->
                        <div class="viewport">
                            <div class="overview">
                                <div class="infor_box_lists">
                                    <g:each in="${videoSerial}" var="s">
                                        <p><a href="${createLink(controller: 'program', action: 'courseView', params: [serialId: s.id])}"><span
                                                class="infor_box_list_icon"></span></a>
                                            <a class="infor_box_list_ws"
                                               href="${createLink(controller: 'program', action: 'courseView', params: [serialId: s.id])}">${s.name}</a><span
                                                class="l_time">${TimeLengthUtils.NumberToString(s.timeLength)}</span>
                                        </p>
                                    </g:each>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="boful_video_infor_box_right">
                    <div class="s_note">${message(code: 'my.notes.name')}</div>

                    <div class="s_list">${message(code: 'my.list.name')}</div>
                </div>
            </div>
            <!-----结束----->
        </div>
    </div>
</div>

<div class="boful_video_player_information">
<!------简介------------->
<div class="boful_course_play_content_left cou_mar">
<div class="boful_course_play_describe">
    <h1>${CTools.cutString(serial?.name, 15)}</h1>

    <div class="boful_course_play_describe_infor">
        <div class="boful_course_play_describe_infor_starts">
            <div class="infor_starts">
                <div name="serialLinkShow${serial?.program?.id}">
                </div>
            </div>
            <input type="hidden" id="serialLink${serial?.program?.id}"
                   value="${calcProgramScore(program: serial?.program)}"/>
            <input type="hidden" name="programId" value="${serial?.program?.id}">

            <span class="boful_course_play_describe_infor_talk">(${serial?.program?.remarks?.size()}次${message(code: 'my.review.name')})</span>
        </div>

        <div class="boful_course_play_describe_infor_user">
            <p>${message(code: 'my.lecturer.name')}：<span>${CTools.cutString(serial?.program?.actor, 5)}</span></p>

            <p>${message(code: 'my.publisher.name')}：<span
                    class="boful_course_detail_name"><a title="${serial?.program?.consumer?.name}"
                                                        href="${createLink(controller: 'my', action: 'userSpace', params: [id: serial?.program?.consumer?.id])}">${CTools.cutString(serial?.program?.consumer?.name, 5)}</a>
            </span>
            </p>

            <p>${message(code: 'my.class.name')}：
                <g:if test="${serial.program.programCategories && serial.program.programCategories.size() > 0}">
                    <g:each var="programCategory" in="${serial.program.programCategories.toList()}">
                        <span class="boful_course_detail_name">
                            <a title="${programCategory.name}>"
                               href="${createLink(controller: 'program', action: 'courseList', params: [categoryId: programCategory.id])}">${CTools.cutString(programCategory.name, 20)}</a>
                        </span>
                    </g:each>
                </g:if>

            </p>
        </div>

    </div>

    <p class="boful_course_play_describe_words">${CTools.cutString(CTools.htmlToBlank(serial?.description), 300)}
    </p>
</div>
<!----------问题解答----------->
<!-----------课堂互动---------->
<div class="boful_course_content_directory_play directory_mgr">

<h1><g:if test="${Consumer.findByName(session.consumer.name)?.canComment}"><a id="showRemarkId"
                                                                              onclick="showRemark()">${message(code: 'my.Classroom.name')}</a></g:if><a
        id="showQuestionId"
        onclick="showQuestion()">${message(code: 'my.solving.name')}</a>
</h1>
<g:if test="${Consumer.findByName(session.consumer.name)?.canComment}">
    <div class="boful_course_content_directory_talk" id="boful_course_content_directory_talk_Id">
        <div class="boful_course_content_directory_column">
            <div class="boful_course_content_directory_column_talk">
                %{-- <h3>标题</h3>
                 <input id="remarkTopic" name="remarkTopic" class="column_talk_input" type="text" value="">--}%
                <textarea id="remarkContentId" name="remarkContent" class="column_talk_input_words"></textarea>
            </div>

            <div class="column_talk_input_starts">
                <div class="column_talk_input_start">
                    <p>评价:</p>

                    <div class="column_talk_input_userstart">
                        <div id="rankScore"></div>
                    </div>
                </div>

                <label>
                    <input class="column_talk_input_but" type="button" value="评价" id="remarkBtn1"
                           onclick="saveRemark(${serial?.id})">
                </label>
            </div>

            <div class="boful_course_play_class_items" id="boful_course_play_class_items_remark">
                <g:each in="${remarkList}" var="remark" status="i">
                    <div class="boful_course_play_class_item">
                        <div class="course_play_user_massage">
                            <a title="${remark?.consumer?.name}"
                               href="${createLink(controller: 'my', action: 'userSpace', params: [id: remark?.consumer?.id])}">
                                <div class="course_others_talkback_item_image">
                                    <img src="${generalUserPhotoUrl(consumer: remark?.consumer)}"
                                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                                </div></a>

                            <p>
                                <span class="course_play_user_massage_name"><a title="${remark?.consumer?.name}"
                                                                               href="${createLink(controller: 'my', action: 'userSpace', params: [id: remark.consumer.id])}">${CTools.cutString(remark?.consumer?.name, 8)}</a>
                                </span>
                                <span class="course_play_user_massage_time">${new SimpleDateFormat("yyyy-MM-dd").format(remark?.dateCreated)}</span>
                            </p>
                        </div>

                        <h3 class="course_play_user_massage_title"></h3>

                        <div class="course_play_user_massage_talk">${CTools.cutString(remark?.content, 50)}</div>

                        <a><div class="course_play_user_massage_talk_back"
                                id="course_play_user_massage_talk_back_Id${i}"
                                onclick="showRemarkReplys(${i})">回复数：${remark.replyNum}</div></a>

                        <div class="course_others_talkback" id="course_others_talkback_Id${i}" style="display: none">
                            <div class="course_others_talkback_input">
                                <label>
                                    <textarea id="remarkReply${i}"></textarea>
                                </label>

                                <div class="course_others_talkback_but">
                                    <label>
                                        <input type="button" value="提交回复" class=""
                                               onclick="submitRemarkReply(${i}, ${remark.id})">
                                    </label>
                                </div>
                            </div>

                            <div class="course_others_talkback_items" id="course_others_talkback_items_Id${i}">
                                <g:each in="${remark.remarkReplys}" var="remarkReply">
                                %{--用来标记，用于js获取当前评论的所有回复--}%
                                    <input type="hidden" name="remarkReplyNum${i}" value=""/>

                                    <div class="course_others_talkback_item">
                                        <a title="${remarkReply?.consumer?.name}"
                                           href="${createLink(controller: 'my', action: 'userSpace', params: [id: remarkReply?.consumer?.id])}">
                                            <div class="course_others_talkback_item_image">
                                                <img src="${generalUserPhotoUrl(consumer: remarkReply?.consumer)}"
                                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                                            </div></a>

                                        <div class="course_others_talk_back">
                                            <div class="course_others_talk_back_infor">
                                                <span class="course_play_user_massage_name"><a
                                                        title="${remarkReply?.consumer?.name}"
                                                        href="${createLink(controller: 'my', action: 'userSpace', params: [id: remarkReply.consumer.id])}">${CTools.cutString(remarkReply?.consumer?.name, 8)}</a>
                                                </span>
                                                <span class="course_play_user_massage_time">${new java.text.SimpleDateFormat("yyyy-MM-dd").format(remarkReply?.dateCreated)}</span>
                                            </div>

                                            <p class="course_others_talkback_descript">
                                                ${remarkReply.content}
                                            </p>

                                        </div>
                                    </div>
                                </g:each>
                            </div>
                        </div>

                    </div>
                </g:each>
            </div>
        </div>
    </div>
</g:if>
%{--<div class="boful_course_detail_content_evaluation" style="display:none;">
    <h1>评价</h1>

    <div class="boful_course_detail_content_evaluation_line">
        <div class="boful_course_detail_content_talk">
            <div class="boful_course_detail_content_userinfor">
                <img src="${resource(dir: 'skin/blue/pc/images', file: 'boful_course_detail_content_userinfor.jpg')}">

                <p>
                    <span class="boful_course_detail_content_username">李涛</span>
                    <span class="boful_course_detail_content_time">1月-5日</span>
                </p>
            </div>

            <p class="boful_course_detail_content_taik_infor">
                非常好值得学习~如果有PSD文件边看教程边修就更加好了
            </p>
        </div>

        <div class="boful_course_detail_content_talk">
            <div class="boful_course_detail_content_userinfor">
                <img src="${resource(dir: 'skin/blue/pc/images', file: 'boful_course_detail_content_userinfor.jpg')}">

                <p class="boful_course_detail_content_taik_infor">
                    <span class="boful_course_detail_content_username">李涛</span>
                    <span class="boful_course_detail_content_time">1月-5日</span>
                </p>
            </div>

            <p class="boful_course_detail_content_taik_infor">
                非常好值得学习~如果有PSD文件边看教程边修就更加好了
            </p>
        </div>

        <div class="boful_course_detail_content_talk">
            <div class="boful_course_detail_content_userinfor">
                <img src="${resource(dir: 'skin/blue/pc/images', file: 'boful_course_detail_content_userinfor.jpg')}">

                <p>
                    <span class="boful_course_detail_content_username">李涛</span>
                    <span class="boful_course_detail_content_time">1月-5日</span>
                </p>
            </div>

            <p class="boful_course_detail_content_taik_infor">
                非常好值得学习~如果有PSD文件边看教程边修就更加好了
            </p>
        </div>

        <div class="boful_course_detail_content_talk">
            <div class="boful_course_detail_content_userinfor">
                <img src="${resource(dir: 'skin/blue/pc/images', file: 'boful_course_detail_content_userinfor.jpg')}">

                <p>
                    <span class="boful_course_detail_content_username">李涛</span>
                    <span class="boful_course_detail_content_time">1月-5日</span>
                </p>
            </div>

            <p class="boful_course_detail_content_taik_infor">
                非常好值得学习~如果有PSD文件边看教程边修就更加好了
            </p>
        </div>
    </div>

    <div class="boful_course_detail_content_more">更多评论</div>
</div>--}%
<input value="${total}" id="remarkTotal" type="hidden">
<input value="${courseTotal}" id="courseTotal" type="hidden">
<!----------问题解答----------->
<div class="boful_course_content_directory_question" id="boful_course_content_directory_question_Id"
     style="display: ${Consumer.findByName(session.consumer.name)?.canComment ? 'none' : 'black'}">
    <div class="boful_course_content_directory_column">

        <g:form controller="index" action="saveCourseQuestion" name="form_courseQuestion" id="form_courseQuestion"
                method="post">
            <div class="boful_course_content_directory_column_talk">

                %{--问题提交表单--}%
                <input name="serialId" id="serialId" type="hidden" value="${serial.id}">
                <input name="programId" id="programId" type="hidden" value="${serial?.program?.id}">
                <h4 class="question_green">${message(code: 'my.question.name')}</h4>
                <input id="remarkTopic" name="remarkTopic" class="column_talk_input" type="text" value="">

                %{--<h3>问题描述</h3>
                <textarea id="remarkContent" name="remarkContent" class="column_talk_input_words"></textarea>--}%
            </div>

            <div class="column_talk_input_starts">
                <label>
                    <input class="column_talk_input_but1" type="button" value="提交问题" id="remarkBtn2"
                           onclick="submitCourseAnswer()"/>
                </label>
            </div>
        </g:form>

        <div class="boful_course_play_class_items" id="boful_course_play_class_items_courseQuestion">
            <div class="other_querstion">
                <h4 class="question_green">${message(code: 'my.OtherQuestions.name')}</h4>
            </div>
        %{-- 所有问题--}%
            <g:each in="${courseQuestionList}" var="courseQuestion" status="i">
                <div class="boful_course_play_class_item">
                    <div class="course_question_user_massage_bod">
                        <div class="course_play_user_massage_portrait">
                            <a title="${courseQuestion?.consumer?.name}"
                               href="${createLink(controller: 'my', action: 'userSpace', params: [id: courseQuestion?.consumer?.id])}">
                                <div class="course_video_item_user_img">
                                    <img src="${generalUserPhotoUrl(consumer: courseQuestion.consumer)}"
                                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                                </div></a>
                            %{--<img src="${resource(dir: 'skin/blue/pc/images', file: 'boful_course_detail_content_userinfor.jpg')}"/>--}%
                        </div>

                        <div class="course_question_user_massage_cons" id="course_question_user_massage_cons_Id${i}"
                             onclick="answerShowOrHidden(${i})">
                            <div class="course_question_user_massage_con">
                                <div class="course_play_user_massage_question">${courseQuestion.title}</div>

                                <div class="course_play_user_massage_question_infor">
                                    <span class="course_question_user_massage_name">${message(code: 'my.questioner.name')}:&nbsp;<a
                                            title="${courseQuestion?.consumer?.name}"
                                            href="${createLink(controller: 'my', action: 'userSpace', params: [id: courseQuestion.consumer.id])}">${CTools.cutString(courseQuestion?.consumer?.name, 8)}</a>
                                    </span>
                                    <span class="course_question_user_massage_time">${message(code: 'my.questiontime.name')}:&nbsp;<a><g:formatDate
                                            format="yyyy-MM-dd HH:mm:ss"
                                            date="${courseQuestion.createDate}"></g:formatDate></a>
                                    </span>
                                </div>

                            </div>

                            <div class="my_quesion"><a id="answer_Question_Id${i}"
                                                       onclick="iAnswerQuestion(${i})">${message(code: 'my.meAnswer.name')}</a>
                            </div>
                        </div>

                    </div>

                </div>

                <!--------我来回答--------->
                <div class="course_question_user_back" id="course_question_user_back${i}" style="display:none">
                    <h4 class="question_ye">${message(code: 'my.meAnswer.name')}</h4>

                    <div class="course_question_back_input">
                        <label>
                            <textarea class="question_content" id="question_content${i}"></textarea>
                        </label>
                    </div>

                    <div class="course_question_back_up">
                        <input type="button" class="course_question_back_solution" value="提交回答"
                               onclick="submitQusetionSolution(${i}, ${courseQuestion.id}, ${session?.consumer?.id})"/>
                    </div>

                %{--回答答案--}%
                    <g:if test="${courseQuestion?.rightAnswer != null}">
                        <!--------最佳答案-------->
                        <h5 class="question_back_size">${message(code: 'my.bestAnswer.name')}<span
                                class="question_back_size_icon"></span></h5>

                        <div class="course_question_back_items">

                            <div class="cquestion_back_bg">
                                <div class="course_question_back_item_con">${courseQuestion?.rightAnswer?.content}</div>

                                <div class="course_question_back_item_infor">
                                    <span class="course_question_user_massage_name">回答者：<a
                                            title="${courseQuestion?.rightAnswer?.consumer?.name}"
                                            class="${courseQuestion?.rightAnswer?.consumer?.name}"
                                            href="${createLink(controller: 'my', action: 'userSpace', params: [id: courseQuestion?.rightAnswer?.consumer.id])}">${CTools.cutString(courseQuestion?.rightAnswer?.consumer?.name, 4)}</a>
                                    </span>
                                    <span class="course_question_user_massage_time"><g:formatDate
                                            date="${courseQuestion?.rightAnswer?.createDate}"
                                            format="yyyy-MM-dd HH:mm:ss"></g:formatDate></span>
                                </div>

                            </div>
                        </div>
                    </g:if>
                    <g:else>
                        <h5 class="question_back_size">${message(code: 'my.respondents.name')}<span
                                class="question_back_size_icon"></span></h5>

                        <div class="course_question_back_items">

                            <div class="cquestion_back_bg">
                                <div class="course_question_back_item_con">暂无</div>
                            </div>
                        </div>
                    </g:else>


                %{--全部回答--}%
                    <h5 class="course_question_back_all"
                        id="course_question_back_all${i}">${message(code: 'my.all.name')}${message(code: 'my.answer.name')}</h5>

                    <g:each in="${courseQuestion?.answer}" var="questionAnswer">
                        <g:if test="${questionAnswer.courseQuestion.rightAnswer?.id != questionAnswer.id}">

                            <div class="course_question_back_items">

                                <div class="course_question_back_item">

                                    <div class="course_question_back_item_con">
                                        ${questionAnswer?.content}
                                    </div>

                                    <div class="course_question_back_item_infor">
                                        <span class="course_question_user_massage_name">${message(code: 'my.respondents.name')}：<a
                                                title="${questionAnswer?.consumer?.name}"
                                                href="${createLink(controller: 'my', action: 'userSpace', params: [id: questionAnswer.consumer.id])}">${CTools.cutString(questionAnswer?.consumer?.name, 4)}</a>
                                        </span>
                                        <span class="course_question_user_massage_time"><g:formatDate
                                                format="yyyy-MM-dd HH:mm:ss"
                                                date="${questionAnswer?.createDate}"/></span>
                                        <g:if test="${session.consumer.id == courseQuestion.consumer.id && courseQuestion.rightAnswer == null}">
                                            <span class="course_question_back_mark"><a
                                                    onclick="acceptionRightAnswer(${courseQuestion.id}, ${questionAnswer.id})">${message(code: 'my.Adopt.name')}</a><a
                                                    class="mark_line">|</a></span>
                                        </g:if>
                                    </div>

                                </div>
                            </div>
                        </g:if>
                    </g:each>
                </div>
            </g:each>
        <!--------结束--------->
        </div>
    </div>
</div>
</div>
</div>

<div class="boful_course_detail_content_right">
    <div class="boful_course_play_content_about boful_c_pad">
        <div class="boful_course_play_content_user_portrait">
            <a title="${serial?.program?.consumer?.name}"
               href="${createLink(controller: 'my', action: 'userSpace', params: [id: serial?.program?.consumer?.id])}">
                <div class="course_video_item_user_img">
                    <img src="${generalUserPhotoUrl(consumer: serial?.program?.consumer)}"
                         src="${generalUserPhotoUrl(consumer: serial?.program?.consumer)}"
                         width="115" height="115"
                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                </div></a>

        </div>

        <div class="boful_course_play_content_user_infor1">
            <span class="boful_course_user_names"><a title="${serial?.program?.consumer?.name}"
                                                     href="${createLink(controller: 'my', action: 'userSpace', params: [id: serial?.program.consumer.id])}">${CTools.cutString(serial?.program?.consumer?.name, 8)}</a>
            </span>

            <p>${CTools.cutString(serial?.program?.consumer?.descriptions, 30)}</p>
        </div>
    </div>

    <div class="boful_course_detail_content_about">
        <div class="detail_content-title">
            <h1>
                ${message(code: 'my.Relatedaccessories.name')}
                <g:if test="${otherSerial && otherSerial.size() > 5}">
                    <a href="${createLink(controller: 'program', action: 'lessionProgram', params: [serialId: otherSerial?.get(0)?.id])}"
                       target="_blank">
                        ${message(code: 'my.more.name')}</a>
                </g:if>
            </h1>

        </div>

        <p class="detail_content-item">
            <g:each in="${otherSerial}" var="serial2" status="sta">
                <g:if test="${sta < 5}">
                    <a <g:if test="${FileType.isDocument(serial2?.filePath) || serial2.filePath.endsWith("pdf") || serial2.filePath.endsWith("PDF")}">class="boful_course_detail_attachment_word"</g:if>
                       <g:if test="${FileType.isAudio(serial2?.filePath)}">class="boful_course_detail_attachment_voice"</g:if>
                       <g:if test="${FileType.isImage(serial2?.filePath)}">class="boful_course_detail_attachment_images"</g:if>
                       <g:if test="${serial2.filePath.endsWith("swf") || serial2.filePath.endsWith("SWF")}">class="boful_course_detail_attachment_swf"</g:if>
                       href="${createLink(controller: 'program', action: 'lessionProgram', params: [serialId: serial2.id])}"
                       target="_blank">
                        ${CTools.cutString(serial2?.name, 20)}</a>
                </g:if>
            </g:each>
        </p>
    </div>

</div>
</div>
</div>

<script type="text/javascript">
    var programIds = $("input[name='programId']")//得到所有program
    for (var i = 0; i < programIds.size(); i++) {
        var programId = programIds[i].value;
        var serialLinkValue = $("#serialLink" + programId).val() / 2;
        var serialLinkShowDiv = $("div[name='serialLinkShow" + programId + "']");
        serialLinkShowDiv.raty({readOnly: true, width: 110, score: serialLinkValue});
    }

    function checkPlayType(id, fileHash, filePath) {
        if (checkFileType(filePath) == 3) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=image&fileHash=" + fileHash, '_blank');
        } else if (checkFileType(filePath) == 4) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=audio&fileHash=" + fileHash, '_blank');
        } else if (checkFileType(filePath) == 2) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=document&fileHash=" + fileHash, '_blank');
        } else if (checkFileType(filePath) == 5) {
            window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=flash&fileHash=" + fileHash, '_blank');
        }
    }

    function downloadSharing() {
        var serialId = $("#currentSerialId").val();
        window.location.href = baseUrl + "program/downloadSharing?serialId" + serialId;
    }
</script>
</body>
</html>