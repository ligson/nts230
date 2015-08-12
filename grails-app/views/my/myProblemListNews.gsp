<%@ page import="nts.utils.CTools; nts.program.domain.Program" %>
<html>
<head>
    <title>${message(code: 'my.mined.name')}${message(code: 'my.questions.name')}</title>
    %{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'myHistoryProgramlist.css')}">--}%
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/common.js')}"></script>
%{--<script type="text/javascript" src="${resource(dir: 'js', file: 'truevod.js')}"></script>--}%
<SCRIPT LANGUAGE="JavaScript" type="text/javascript">
    <!--
    function submitSch() {
        document.form1.submit();
    }
    function onPageNumPer(max) {
        document.form1.max.value = max;
        document.form1.offset.value = 0;
        submitSch();
    }
    //如果右边页面用类库(目录) 则metaId2是目录ID，enumId2为0 名称后缀2表示是右边的类别,如此设计是为了用户如果...
    function categorySch(metaId2, enumId2) {
        document.form1.metaId2.value = metaId2;
        document.form1.keyword.value = "";//点击时不使用搜索条件
        submitSch();
    }
    function init() {
        changePageImg(${CTools.nullToOne(params.max)});
    }
    //-->
</SCRIPT>
%{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/css', file: 'my_space.css')}">--}%
<Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css rel=stylesheet>
%{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_coursesytyle.css')}">--}%
<script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'dropdown.js')}"></script>
%{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'myHistoryProgramlist_course.css')}">--}%
%{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'myNotesProgramList_news.css')}">--}%
<link rel="stylesheet" type="text/css"href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_userspace_index.css')}">
</head>

<body>

%{--我的问题开始部分--}%
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.mined.name')}${message(code: 'my.questions.name')}</a>
</div>

<div class="tabs_nav">
    <ul>
        <li><a href="javascript:void(0)"
               class="cur">${message(code: 'my.mined.name')}${message(code: 'my.questions.name')}</a></li>
        <li><a href="javascript:void(0)">${message(code: 'my.mined.name')}${message(code: 'my.answer.name')}</a></li>
        %{--<li><a href="javascript:void(0)">关注的问题</a></li>--}%
    </ul>
</div>


<div class="c_bg" style="width: 100%;">
    <div class="sub-con cur-sub-con" style="padding: 0 15px;">
        <div class="m-cloudAsk">
            <div class="pool f-bg">
                <g:each in="${courseQuestionList}" var="courseQuestion" status="i">
                    <div class="m-data-lists f-cb f-pr j-data-list">
                        <div class="poolitem f-cb first last">
                            <p class="askInfo">
                                <a class="j-replylink" target="_blank" href="${createLink(controller: 'program', action: 'courseView', params: [serialId: courseQuestion.course.serials.id, problemFlg: '1'])}">${courseQuestion.title}</a>
                                &nbsp;&nbsp;
                                <a class="btn btn-danger spa_mm btn-xs"
                                    style="color: #FFF; font-size: 12px; font-weight:normal"
                                    href="${createLink(controller: 'my', action: 'deleteMyCourseQuestion', params: [courseQuestionId: courseQuestion.id])}"
                                    onclick="return confirm('确定要删除吗？')">${message(code: 'my.delete.name')}${message(code: 'my.questions.name')}</a>
                            </p>

                            <p class="moreinfo f-cb">

                                <g:if test="${courseQuestion.rightAnswer == null}">
                                    <span class="f-fl j-askinfo">
                                        ${message(code: 'my.no.name')}${message(code: 'my.Adopt.name')} | ${message(code: 'my.answer.name')}(${courseQuestion.answer.size()})
                                    </span>
                                </g:if>
                                <g:else>
                                    <span class="f-fl j-askinfo">
                                        ${message(code: 'my.bestAnswer.name')}：${courseQuestion.rightAnswer.content} <br/><br/>${message(code: 'my.answer.name')}(${courseQuestion.answer.size()})
                                    </span>
                                </g:else>
                                <span class="f-fr j-asktime">${message(code: 'my.time.name')}：${new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(courseQuestion.createDate)}</span>
                                %{--浏览（5）|--}% %{--| 投票（0）--}%</p>
                        </div>
                    </div>
                </g:each>
            %{-- <div class="m-data-lists f-cb f-pr j-data-list">
                 <div class="poolitem f-cb first last">
                     <p class="askInfo"><a class="j-replylink" target="_blank" href="/">道之道，才是道</a></p>

                     <p class="moreinfo f-cb">
                         <span class="f-fl j-askinfo">浏览（5）| 答案（1）| 投票（0）</span><span class="f-fr j-asktime">3月14日</span></p>
                     </div>
                 </div>

     <div class="m-data-lists f-cb f-pr j-data-list">
         <div class="poolitem f-cb first last">
             <p class="askInfo"><a class="j-replylink" target="_blank" href="/">道之道，才是道</a></p>

             <p class="moreinfo f-cb">
                 <span class="f-fl j-askinfo">浏览（5）| 答案（1）| 投票（0）</span><span class="f-fr j-asktime">3月14日</span></p>
         </div>
     </div>


     <div class="m-data-lists f-cb f-pr j-data-list">
         <div class="poolitem f-cb first last">
             <p class="askInfo"><a class="j-replylink" target="_blank" href="/">道之道，才是道</a></p>

             <p class="moreinfo f-cb">
                 <span class="f-fl j-askinfo">浏览（5）| 答案（1）| 投票（0）</span><span class="f-fr j-asktime">3月14日</span></p>

         </div>
     </div>
--}%

            </div>
        </div>

    </div>

    <div class="sub-con">
        <div class="m-cloudAsk">
            <div class="pool f-bg">
                <g:each in="${courseAnswerQuestionList}" var="courseAnswerQuestion">
                    <div class="m-data-lists f-cb f-pr j-data-list">
                        <div class="poolitem f-cb first last">
                            <p class="askInfo">
                                <a class="j-replylink" target="_blank" href="${createLink(controller: 'program', action: 'courseView', params: [serialId: courseAnswerQuestion?.course.serials.id, problemFlg: 'true'])}">${courseAnswerQuestion?.title}</a>
                            </p>

                            <p class="moreinfo f-cb">
                                点击我提出的一个问题
                                <g:if test="${courseAnswerQuestion?.rightAnswer?.consumer?.id == session.consumer?.id}">
                                    <span class="f-fl j-askinfo">
                                        ${message(code: 'my.Adopt.name')}|${message(code: 'my.answer.name')}(${courseAnswerQuestion.answer.size()})
                                    </span>
                                </g:if>
                                <g:else>
                                    <span class="f-fl j-askinfo">
                                        ${message(code: 'my.no.name')}${message(code: 'my.Adopt.name')} | |${message(code: 'my.answer.name')}(${courseAnswerQuestion.answer.size()})
                                    </span>
                                </g:else>
                                <span class="f-fr j-asktime">|${message(code: 'my.time.name')}：${new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(courseAnswerQuestion.createDate)}</span>
                                %{--浏览（5）|--}% %{--| 投票（0）--}%</p>
                        </div>
                    </div>
                </g:each>
            %{--<div class="m-data-lists f-cb f-pr j-data-list">
                <div class="poolitem f-cb first last">
                    <p class="askInfo"><a class="j-replylink" target="_blank" href="/">道之道，才是道</a></p>

                    <p class="moreinfo f-cb">
                        <span class="f-fl j-askinfo">浏览（5）| 答案（1）| 投票（0）</span><span class="f-fr j-asktime">3月14日</span></p>
                    <div class="replyCon f-cb">
                        <div class="vote f-fl j-replyvote">0<br> 投票</div>
                        <p class="con f-fl j-replytxt">是道</p>
                    </div>
                </div>
            </div>

            <div class="m-data-lists f-cb f-pr j-data-list">
                <div class="poolitem f-cb first last">
                    <p class="askInfo"><a class="j-replylink" target="_blank" href="/">道之道，才是道</a></p>

                    <p class="moreinfo f-cb">
                        <span class="f-fl j-askinfo">浏览（5）| 答案（1）| 投票（0）</span><span class="f-fr j-asktime">3月14日</span></p>
                    <div class="replyCon f-cb">
                        <div class="vote f-fl j-replyvote">0<br> 投票</div>
                        <p class="con f-fl j-replytxt">是道</p>
                    </div>
                </div>
            </div>


            <div class="m-data-lists f-cb f-pr j-data-list">
                <div class="poolitem f-cb first last">
                    <p class="askInfo"><a class="j-replylink" target="_blank" href="/">道之道，才是道</a></p>

                    <p class="moreinfo f-cb">
                        <span class="f-fl j-askinfo">浏览（5）| 答案（1）| 投票（0）</span><span class="f-fr j-asktime">3月14日</span></p>
                    <div class="replyCon f-cb">
                        <div class="vote f-fl j-replyvote">0<br> 投票</div>
                        <p class="con f-fl j-replytxt">是道</p>
                    </div>
                </div>
            </div>--}%

            </div>
        </div>
    </div>

    %{--<div class="sub-con">
        <div class="m-cloudAsk">
            <div class="pool f-bg">

                <div class="m-data-lists f-cb f-pr j-data-list">
                    <div class="poolitem f-cb first last">
                        <p class="askInfo"><a class="j-replylink" target="_blank" href="/">道之道，才是道</a></p>

                        <p class="moreinfo f-cb">
                            <span class="f-fl j-askinfo">浏览（5）| 答案（1）| 投票（0）</span><span class="f-fr j-asktime" style="margin-left: 10px;"><a>取消关注</a></span><span class="f-fr j-asktime">3月14日</span></p>
                    </div>
                </div>

                <div class="m-data-lists f-cb f-pr j-data-list">
                    <div class="poolitem f-cb first last">
                        <p class="askInfo"><a class="j-replylink" target="_blank" href="/">道之道，才是道</a></p>

                        <p class="moreinfo f-cb">
                            <span class="f-fl j-askinfo">浏览（5）| 答案（1）| 投票（0）</span><span class="f-fr j-asktime" style="margin-left: 10px;"><a>取消关注</a></span><span class="f-fr j-asktime">3月14日</span></p>
                    </div>
                </div>


                <div class="m-data-lists f-cb f-pr j-data-list">
                    <div class="poolitem f-cb first last">
                        <p class="askInfo"><a class="j-replylink" target="_blank" href="/">道之道，才是道</a></p>

                        <p class="moreinfo f-cb">
                            <span class="f-fl j-askinfo">浏览（5）| 答案（1）| 投票（0）</span><span class="f-fr j-asktime" style="margin-left: 10px;"><a>取消关注</a></span><span class="f-fr j-asktime">3月14日</span></p>

                    </div>
                </div>


            </div>
        </div>
    </div>--}%
</div>


%{--我的问题结束部分--}%






%{--  <div class="course_right_nav" style="margin-top: 30px;">

      <ul style="overflow: hidden">
          <li><a href="${createLink(controller: 'my', action: 'myHistoryProgramList')}">我的课程</a></li>
          --}%%{--<li><a href="${createLink(controller: 'my', action: 'myHistoryProgramList')}">学习提醒</a></li>--}%%{--
          <li><a href="${createLink(controller: 'my', action: 'myNotesProgramList')}">我的笔记</a></li>
          <li><a class="courcrr" href="${createLink(controller: 'my', action: 'myProblemListNews')}">我的问题</a></li>
          --}%%{--<li><a href="${createLink(controller: 'my', action: 'myHistoryProgramList')}">搜藏的课程</a></li>--}%%{--
      </ul>
  </div>--}%






<script type="text/javascript">
    $(document).ready(function () {
        var intervalID;
        var curLi;
        var tabNav = $(".tabs_nav li a");
        tabNav.mouseover(function () {
            curLi = $(this);
//鼠标移入的时候有一定的延时才会切换到所在项，防止用户不经意的操作
            intervalID = setInterval(onMouseOver, 250);
        });
        function onMouseOver() {
            $(".cur-sub-con").removeClass("cur-sub-con");
            $(".sub-con").eq(tabNav.index(curLi)).addClass("cur-sub-con");
            $(".cur").removeClass("cur");
            curLi.addClass("cur");
        }

        tabNav.mouseout(function () {
            clearInterval(intervalID);
        });

//鼠标点击也可以切换
        tabNav.click(function () {
            clearInterval(intervalID);
            $(".cur-sub-con").removeClass("cur-sub-con");
            $(".sub-con").eq(tabNav.index(curLi)).addClass("cur-sub-con");
            $(".cur").removeClass("cur");
            curLi.addClass("cur");
        });
    });
</script>
</body>
</html>

