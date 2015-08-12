<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-2-11
  Time: 下午2:34
--%>

<%@ page import="com.boful.common.file.utils.FileType; nts.program.domain.Serial; nts.meta.domain.MetaContent; java.text.SimpleDateFormat; com.boful.common.date.utils.TimeLengthUtils; nts.utils.CTools; nts.program.domain.PlayedProgram; nts.user.domain.Consumer; javax.servlet.http.HttpServletResponse; org.codehaus.groovy.grails.web.util.WebUtils; javax.servlet.ServletContext; javax.servlet.http.HttpServletRequest;" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<head>
    <title>${message(code: 'my.courses.name')}${message(code: 'my.introduction.name')}</title>
    <meta name="layout" content="index">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'courseDetail.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'hader_page.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'meta.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'metalist.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/appMgr', file: 'showProgram.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/index', file: 'collectionAndrecommend.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
    <r:require modules="raty"/>
    <script type="text/javascript">
        //显示评分星星
        $(function () {
            var programIds = $("input[name='programId']");//得到所有program
            for (var i = 0; i < programIds.size(); i++) {
                var programId = programIds[i].value;
                var serialLinkValue = $("#serialLink" + programId).val() / 2;
                var serialLinkShowDiv = $("div[name='serialLinkShow" + programId + "']");
                serialLinkShowDiv.raty({readOnly: true, width: 110, score: serialLinkValue});
            }
        })
        $(document).ready(function () {
            //显示课程大纲，目录，元数据
            $(".content_left_tab span").bind("click", function () {
                if (this.innerHTML == "课程介绍") {
                    $(".content_left_tab span").attr("style", "");
                    this.style.color = '#53A93F';
                    $("#boful_course_content_describe_Id").show();
                    $("#boful_course_content_directory_Id").hide();
                    $("#course_describe_infor_Id").hide();
                    $("#course_describe_sharing_id").hide();
                }
                if (this.innerHTML == "课程目录") {
                    $(".content_left_tab span").attr("style", "");
                    this.style.color = '#53A93F';
                    $("#boful_course_content_directory_Id").show();
                    $("#course_describe_infor_Id").hide();
                    $("#course_describe_sharing_id").hide();
                    $("#boful_course_content_describe_Id").hide();
                }
                if (this.innerHTML == "元数据") {
                    $(".content_left_tab span").attr("style", "");
                    this.style.color = '#53A93F';
                    $("#course_describe_infor_Id").show();
                    $("#course_describe_sharing_id").hide();
                    $("#boful_course_content_describe_Id").hide();
                    $("#boful_course_content_directory_Id").hide();
                }
                if (this.innerHTML == "课程共享") {
                    $(".content_left_tab span").attr("style", "");
                    this.style.color = '#53A93F';
                    $("#course_describe_sharing_id").show();
                    $("#boful_course_content_describe_Id").hide();
                    $("#boful_course_content_directory_Id").hide();
                    $("#course_describe_infor_Id").hide();
                }
            })
            //鼠标移动字体样式更改
            $(".course_content_list_item a").bind("mouseover", function () {
                var span = this.children[0].children;
                for (var i = 0; i < span.length; i++) {
                    if (span[i].className == "boful_course_content_number") {
                        span[i].style.color = "#FFFFFF";
                    }
                    if (span[i].className == "boful_course_content_number_mark") {
                        span[i].style.background.url = "none";
                        span[i].style.border = "1px solid #FFF";
                    }
                    if (span[i].className == "boful_course_content_time") {
                        span[i].style.color = "#FFFFFF";
                    }
                }
            });
            $(".course_content_list_item a").bind("mouseout", function () {
                var span = this.children[0].children;
                for (var i = 0; i < span.length; i++) {
                    if (span[i].className == "boful_course_content_number") {
                        span[i].style.color = "";
                    }
                    if (span[i].className == "boful_course_content_number_mark") {
                        span[i].style.background = "#FFF";
                        span[i].style.border = "1px solid #999";
                    }
                    if (span[i].className == "boful_course_content_time") {
                        span[i].style.color = "";
                    }
                }
            });
        })
    </script>
    <script type="text/javascript">
        //全局变量
        var contentList = [];
        var metaList = [];
        var wtab;
        var gDisciplineId = "";
        var gProgramId = 221;
        var isOutPlay = false;//播放来自外部（省图下级节点）
        var gCanComment = true;
        var isAnonymous = true;
        var serialId = 298;
        var lastTime = -1;

        <g:each in="${program.metaContents}" status="i" var="metaContent">
        contentList[${i}] = new CContentTypeObj(${metaContent.id}, ${metaContent.metaDefine.id}, ${metaContent.metaDefine.parentId}, ${MetaContent.numDataTypes.contains(metaContent.metaDefine.dataType)?1:2}, ${metaContent.numContent}, '${CTools.nullToBlank(metaContent.strContent).encodeAsJavaScript()}');
        </g:each>

        function init() {
            //alert(234);
            wtab = document.getElementById("metaContTab");
            setCurMetaList(${program?.directory?.id?program?.directory?.id:-1}, 1, -1);//显示当前类下可摘要显示
            showAllTr();
            //setSerialList();


            //setPlayTrShow();
            //setImgNum();
            //实例化播放器
            //initJWPlay();
            //showSerialSlide();
            //document.getElementById("bodyDiv").style.display = "block";

        }
        $(function () {
            init();
        });


    </script>

</head>
<%

    StringBuffer buffer = new StringBuffer();
    Map pars = request.getParameterMap();
    Iterator iterator = pars.keySet().iterator();
    while (iterator.hasNext()) {
        Object object = iterator.next();
        String[] values = pars.get(object);
        buffer.append(object);
        buffer.append("=")
        for (int i = 0; i < values.size(); i++) {
            buffer.append(values[i]);
        }
    }
%>

<body>
<div class="boful_course boful_course_mgr">
<div class="warp" style="background: #FFF">
<g:if test="${program.programCategories && program.programCategories.size() > 0}">
    <div class="boful_course_detail_t">
        <g:each var="programCategory" in="${program.programCategories.toList()}">
            <h1>
                <a href="${createLink(controller: 'program', action: 'courseList', params: [categoryId: programCategory.id])}">${programCategory.name}</a>
            </h1>
        </g:each>
        <span>${CTools.cutString(program?.name, 20)}</span>
    </div>

</g:if>


<div class="boful_course_detail">

    <div class="boful_course_detail_img">
        <img src="${posterLinkNew(program: program, size: '515x270')}"
             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
    </div>

    <div class="boful_course_detail_infor">
        <div class="boful_course_detail_infor_left">
            <p class="course_detail_number"><span
                    class="number_title">${message(code: 'my.courses.name')}${message(code: 'my.period.name')}</span><span
                    class="number_leng">${serialTotal}</span>
            </p>

            <p class="course_detail_answer"><span class="number_title">${message(code: 'my.problom.name')}</span><span
                    class="number_leng">${courseQuestionTotal}</span>
            </p>

            <p class="course_detail_note"><span class="number_title">${message(code: 'my.ClassNotes.name')}</span><span
                    class="number_leng">${programNoteTotal}</span>
            </p>
        </div>

        <div class="boful_course_detail_infor_right">
            <div class="detail_infor_des">
                <div class="boful_course_detail_start">
                    <div class="detail_start_place" name="serialLinkShow${program?.id}">
                    </div>
                    <input type="hidden" id="serialLink${program?.id}" value="${calcProgramScore(program: program)}"/>
                    <input type="hidden" name="programId" value="${program?.id}">
                    <span class="boful_course_detail_start_size">(${program?.remarks?.size()}条评论)</span>

                    <g:if test="${judgeCollectProgram(program: program) == 'true'}">
                        <span class="container_play_save"
                              style="color: #FFF; background: #999">${message(code: 'my.collected.name')}</span>
                    </g:if>
                    <g:else>
                        <span id="collection_program" class="container_play_save"
                              onclick="collectionProgram(${program.id}, '${session.consumer?.name}')">${message(code: 'my.collect.name')}</span>
                    </g:else>

                </div>

                <div class="">
                    <div id="course_describe_infor_Id" class="course_describe_infor" style="display: block;">
                        <table id="metaContTab"></table>
                    </div>
                    %{-- <p>讲师：<span>${program?.actor}</span></p>

                     <p>发布者：<span class="boful_course_detail_name"><a title="${program?.consumer?.name}"
                                                                      href="${createLink(controller: 'my', action: 'userSpace', params: [id: program.consumer.id])}">${CTools.cutString(program?.consumer?.name, 6)}</a>
                     </span></p>

                     <p>分类：<span class="boful_course_detail_name">
                         <a href="${createLink(controller: 'program', action: 'courseList', params: [categoryId: program?.programCategory?.id])}">${program?.programCategory?.name}</a>
                     </span></p>--}%
                </div>
            </div>
            <g:if test="${videoSerial && videoSerial.size() > 0}">
                <div class="detail_infor_join">
                    <a href="${createLink(controller: 'program', action: 'courseView', params: [serialId: videoSerial[0]?.id])}"
                       target="_blank">${message(code: 'my.learning.name')}</a>
                </div>
            </g:if>
        </div>





        %{--元数据--}%

    </div>

</div>

<div class="boful_course_detail_content">
<div class="boful_course_detail_content_left">
    <div class="content_left_tab">
        <span>${message(code: 'my.courses.name')}${message(code: 'my.presentation.name')}</span><em>|</em>
        <span style="color: #53A93F">${message(code: 'my.courses.name')}${message(code: 'my.directory.name')}</span><em>|</em>
        <span>${message(code: 'my.courses.name')}${message(code: 'my.share.name')}</span><em>|</em>
        %{--  <span>元数据</span>--}%
    </div>
    <!----------课程大纲------------>
    <div id="boful_course_content_describe_Id" class="boful_course_content_describe" style="display: none">
        <p class="boful_course_content_describe_words">${CTools.htmlToBlank(program?.description)}
        </p>
    </div>
    <!----------课程目录------------>
    <div id="boful_course_content_directory_Id" class="boful_course_content_directory">
        %{--   <h2 class="directory_tt">课程目录</h2>--}%
        <div class="content_directory_line">
            <div></div>
        </div>

        <div class="boful_course_content_class_all">
            <div class="course_content_list_item">
                <g:each in="${videoSerial}" var="serial" status="sta">
                    <a href="${createLink(controller: 'program', action: 'courseView', params: [serialId: serial?.id])}"
                       target="_blank">
                        <div class="boful_course_content_class">
                            <span class="boful_course_content_number">第${(sta + 1) + Integer.parseInt(offset)}${message(code: 'my.period.name')}</span>
                            <span class="boful_course_content_number_mark"></span>
                            <span class="boful_course_content_title">${CTools.cutString(serial?.name, 20)}</span>
                            <span class="boful_course_content_time">${TimeLengthUtils.formatTime(TimeLengthUtils.NumberToString(serial?.timeLength))}</span>
                        </div></a>
                </g:each>
            </div>

            <div class="page">
                <g:guiPaginate controller="program" action="courseDetail" total="${serialTotal}"
                               params="${['programId': program.id]}"/>
            </div>
        </div>
    </div>
    <!---------------元数据------------->

    <!----翻页--->
    %{--   <div class="page">
           <g:paginate offset="${params.offset}" max="${params.max}" total="${total}" action="search"
                       params="${params}"/>
       </div>--}%
    <!----------课程分享------------>
    <div id="course_describe_sharing_id" class="course_describe_sharing" style="display: none">
        <table border="0" cellspacing="0" cellpadding="0">
            <g:set var="firstSerialId" value="${querySerialFirstId(program: program)}"/>
            <tbody>
            <tr>
                <td width="260"
                    class="describe_sharing_addres">${message(code: 'my.web.name')}${message(code: 'my.adress.name')}:<span>[${message(code: 'my.present.name')}${message(code: 'my.adress.name')}]</span>
                </td>
                <td width="100"></td>
            </tr>
            <tr>
                <td><label><input class="de_shar_input" type="text" value="<g:genBaseUrl/>" id="value1"></label></td>
                %{--<td><label><input class="de_shar_copy" type="button" value="复&nbsp;&nbsp;制" id="copy1"></label></td>--}%
            </tr>
            <tr>
                <td class="describe_sharing_addres">${message(code: 'my.play.name')}${message(code: 'my.adress.name')}:<span>[${message(code: 'my.present.name')}${message(code: 'my.adress.name')}]</span>
                </td>
                <td></td>
            </tr>
            <tr>
                <td><label><g:if test="${firstSerialId != 0 || firstSerialId != '0'}">
                    <input class="de_shar_input" type="text"
                           value="${playLinksNew2(serialId: firstSerialId)}"></g:if>
                </label></td>
                %{--<td><label><input class="de_shar_copy" type="button" value="复&nbsp;&nbsp;制"></label></td>--}%
            </tr>
            <tr>
                <td class="describe_sharing_addres">${message(code: 'my.embedded.name')}${message(code: 'my.code.name')}:<span>[${message(code: 'my.present.name')}${message(code: 'my.adress.name')}]</span>
                </td>
                <td></td>
            </tr>
            <tr>
                <td><label><input class="de_shar_input" type="text"
                                  value="<iframe width=700 height=400 id='embedPlayFrame' src='${firstSerialId != 0 ? playLinksNew2(serialId: firstSerialId) : ''}' />">
                </label></td>
                %{--<td><label><input class="de_shar_copy" type="button" value="复&nbsp;&nbsp;制"></label></td>--}%
            </tr>
            </tbody>
        </table>
    </div>
</div>

<div class="boful_course_detail_content_right course_mar">
    <h1 class="c_detail_author">${message(code: 'my.instructor.name')}</h1>

    <div class="boful_course_detail_content_author">
        <div class="boful_course_detail_content_right_user_point">
            <a title="${program?.consumer?.name}"
               href="${createLink(controller: 'my', action: 'userSpace', params: [id: program?.consumer?.id])}">
                <div class="course_video_item_user_img">
                    <img src="${generalUserPhotoUrl(consumer: program?.consumer)}"
                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'">
                </div></a>
        </div>


        <span class="course_author_name">
            <a title="${program?.consumer?.name}"
               href="${createLink(controller: 'my', action: 'userSpace', params: [id: program.consumer.id])}">${CTools.cutString(program?.consumer?.name, 8)}</a>
        </span>

        <p class="course_author_infor">
            <g:if test="${program?.consumer?.descriptions?.size() == 0}">
                没有个人信息!
            </g:if>
            <g:else>
                ${CTools.cutString(program?.consumer?.descriptions, 300)}
            </g:else>
        </p>
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
            <g:each in="${otherSerial}" var="serial" status="sta">
                <g:if test="${sta < 5}">
                    <a <g:if test="${FileType.isDocument(serial?.filePath) || serial.filePath.endsWith("pdf") || serial.filePath.endsWith("PDF")}">class="boful_course_detail_attachment_word"</g:if>
                       <g:if test="${FileType.isAudio(serial?.filePath)}">class="boful_course_detail_attachment_voice"</g:if>
                       <g:if test="${FileType.isImage(serial?.filePath)}">class="boful_course_detail_attachment_images"</g:if>
                       <g:if test="${serial.filePath.endsWith("swf") || serial.filePath.endsWith("SWF")}">class="boful_course_detail_attachment_swf"</g:if>
                       href="${createLink(controller: 'program', action: 'lessionProgram', params: [serialId: serial.id])}"
                    %{--href="javascript:void(0);"
                    onclick="checkPlayType('${serial?.id}', '${serial?.fileHash}', '${serial?.filePath}')"--}%
                       target="_blank">
                        ${CTools.cutString(serial?.name, 20)}</a>
                </g:if>

            </g:each>

        </p>
    </div>

    <div class="boful_course_detail_content_evaluation">
        <h1>${message(code: 'my.problom.name')}</h1>

        <div
            <g:if test="${remarkList.size() > 4}">class="boful_course_detail_content_evaluation_line_1"</g:if>
            <g:if test="${remarkList.size() <= 4}">class="boful_course_detail_content_evaluation_line"</g:if>>
            <g:each in="${remarkList}" var="remark">
                <div class="boful_course_detail_content_talk">
                    <div class="boful_course_detail_content_userinfor">
                        <a title="${remark?.consumer?.name}"
                           href="${createLink(controller: 'my', action: 'userSpace', params: [id: remark?.consumer?.id])}">
                            <div class="course_video_item_user_img">
                                <img src="${generalUserPhotoUrl(consumer: remark?.consumer)}"
                                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                            </div></a>

                        <p>
                            <span class="boful_course_detail_content_username">
                                <a title="${remark?.consumer?.name}"
                                   href="${createLink(controller: 'my', action: 'userSpace', params: [id: remark.consumer.id])}">${CTools.cutString(remark?.consumer?.name, 6)}</a>
                            </span>
                            <span class="boful_course_detail_content_time">${new SimpleDateFormat("yyyy-MM-dd").format(remark?.dateCreated)}</span>
                        </p>
                    </div>

                    <p class="boful_course_detail_content_taik_infor">
                        ${CTools.cutString(remark?.content, 20)}
                    </p>
                </div>
            </g:each>

        </div>

        <div class="boful_course_detail_content_more"
             onclick="moreRemark('${program?.serials.size()>0?querySerialFirstId(program: program):''}')">${message(code: 'my.more.name')}${message(code: 'my.review.name')}</div>
    </div>
    <!-------学习成员--------------->
    <div class="boful_course_detail_content_users">
        <h1><g:if test="${studyCourse(playedPrograms: program?.playedPrograms) != ''}">
            ${studyCourse(playedPrograms: program?.playedPrograms)}${message(code: 'my.people.name')}${message(code: 'my.learn.name')}
        </g:if>
            <g:else>
                目前还没有在学!
            </g:else></h1>

        <div class="boful_course_detail_content_user">

            <%
                def played = program?.playedPrograms;
                List<Consumer> consumers = [];
                for (int i = 0; i < played.size(); i++) {
                    PlayedProgram playedProgram = played[i];
                    consumers.add(playedProgram.consumer);
                }
                HashSet hs = new HashSet(consumers);
                consumers.clear();
                consumers.addAll(hs);
                for (int j = 0; j < consumers.size(); j++) {
            %>
            <p>
                <a title="${consumers.get(j).name}"
                   href="${createLink(controller: 'my', action: 'userSpace', params: [id: consumers.get(j).id])}">
                    <img src="${generalUserPhotoUrl(consumer: consumers.get(j))}" width="49" height="49"
                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                </a>
                <span>
                    <a title="${consumers.get(j).name}" href="${
                            createLink(controller: 'my', action: 'userSpace', params: [id: consumers.get(j).id])}">${
                            consumers.get(j)?.name}</a></span>
            </p>
            <%
                }
            %>

            %{-- <p>
                 <img src="${resource(dir: 'upload/photo',consumers.get(j)?.photo)}" width="49" height="49"
                      onerror="this.src = '${resource(dir:'images',file:'defaultPoster.jpg')}'">
                 <span>${consumers.get(j)?.name}</span>
             </p>--}%

            %{--<g:each in="${studyCourseTotal(playedPrograms:program?.playedPrograms)}" var="id" status="sta">
                <p>
                    <img src="${resource(dir: 'upload/photo',nts.user.domain.Consumer.findById(id)?.photo)}" width="49" height="49"
                         onerror="this.src = '${resource(dir:'images',file:'defaultPoster.jpg')}'">
                    <span>${nts.user.domain.Consumer.findById(id)?.name}</span>
                </p>
            </g:each>--}%

        </div>
    </div>
</div>
</div>
</div>
</div>
<script type="text/javascript">
    function moreRemark(tag) {
        window.location.href = baseUrl + "program/courseView?serialId=" + tag;
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
</script>
</body>

</html>