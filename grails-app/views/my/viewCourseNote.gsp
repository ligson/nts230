<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-3-18
  Time: 下午7:42
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>笔记</title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_viewCourseNote.css')}">
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <script type="text/javascript">
        $(function () {
            $("#editNoteDialog").dialog({
                autoOpen: false
            });
        });
        function editNote(noteId, content, canPublic) {
            $("#editNoteDialog").dialog("open");
            $("#noteContent").empty().append(content);
            $("#noteContent").val(content);
            if (canPublic) {
                $("#canPublicCheckBox").attr("checked", true);
                $("#canPublicCheckBox").val("true");
            } else {
                $("#canPublicCheckBox").attr("checked", false);
                $("#canPublicCheckBox").val("false");
            }


            $("#noteId").val(noteId);
            return false;
        }
        $(document).ready(function () {
            $("#canPublicCheckBox").bind("click", function () {
                $("#canPublicCheckBox").val($("#canPublicCheckBox").prop("checked"));
            })
        })
    </script>
</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">当前位置：笔记</a>
</div>

<div class="f-innertitle title f-cb f-innder_mgr">
    <div class="j-name f-fl">"${session.consumer.name}"的笔记</div>

    <div title="返回课程笔记" class="btn btn-success btn-sm" style="float: right"><a
            href="${createLink(controller: 'my', action: 'myNotesProgramList')}" style="color: #FFF">返回</a></div>
</div>

<div class="notenav" style="border-bottom: 1px solid #ECECEC; "></div>

<div class="m-notespool">
<!--    笔记循环-->
    <g:each in="${notesList}" var="note">
        <div class="m-notespool1">
            <div>
                <div class="m-noteitem f-pr first m-notespool2">
                    <div class="j-noedit-box noedit">
                        <div class="img"><a href="" class="j-user" target="_blank"><img
                                src="${posterLinkNew(fileHash: note.serial.fileHash, size: '50x50')}" alt="userpic"
                                height="49px" width="49px"></a></div>

                        <div class="mnc">
                            <div>
                                <div class="notehead f-cb"><a
                                        href=" ${createLink(controller: 'program', action: 'courseView', params: [serialId: note?.serial?.id, programNoteId: note.id])}"
                                        class="j-user f-fl" target="_blank"><span
                                        class="usr">${note.serial.name}</span></a>

                                    <div class="noeditanchor f-fr"><a class="f-anchorLink f-ib"><span
                                            class="f-ib">${com.boful.common.date.utils.TimeLengthUtils.NumberToString(note.logicLength)}</span>
                                    </a></div>

                                    <div class="notelesson f-fr">第${note.serial.serialNo}课时</div>
                                </div>
                            </div>

                            <div class="notecnt"><span class="notect">${note.content}</span></div>

                            <div class="noteinfo f-cb">
                                <div style=""
                                     class="notedate">${java.util.Date.parse("yyyyMMddHHmmss", note.createDate).format("yyyy-MM-dd HH:mm:ss")}</div>

                                <div class="noteopt j-opt f-cb"><a href="javascript:void(0);"
                                                                   onclick="editNote(${note.id}, '${CTools.codeToHtml(note.content)}', ${note.canPublic})">编辑</a> <a
                                        href="${createLink(controller: 'my', action: 'myNoteDelete', params: [noteId: note.id])}"
                                        onclick="return confirm('确定要删除该笔记吗！！')">删除</a></div>

                                <div class="j-oper-box oper f-fr">
                                    <div class="noteact f-cb"><a title="顶">顶（${note.noteRecommends.size()}）</a> <span
                                            class="j-cmt notecmt"><span
                                                class="m-comment-wrapper"></span></span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </g:each>
<!--      笔记循环-->

</div>

<div id="editNoteDialog" title="编辑笔记">
    <g:form action="myModifyNote">
        <input type="hidden" name="noteId" value="" id="noteId"/>
        <table width="267">
            <tr>
                <td style="border: none"><textarea rows="3" name="content" style="width: 265px"
                                                   id="noteContent"></textarea></td>
            </tr>
            <tr>
                <td style="width: 80px;border: none "><span style="margin-top:5px; display: block"><input
                        name="canPublic"
                        type="checkbox"
                        value="" id="canPublicCheckBox"/>是否公开
                </span></td>
            </tr>
            <tr>
                <td style="text-align: center;border: none">
                    <input type="submit" value="修改">
                </td>
                <td style="border: none">&nbsp;</td>
            </tr>
        </table>
    </g:form>

</div>
</body>
</html>