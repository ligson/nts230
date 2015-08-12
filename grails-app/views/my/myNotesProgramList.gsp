<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-3-14
  Time: 下午7:57
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.mined.name')}${message(code: 'my.notes.name')}</title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_userspace_index.css')}">
    %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/css', file: 'my_space.css')}">--}%
    %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_userspace_index.css')}">--}%
    %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'myNotesProgramList.css')}">--}%
    %{--<link rel="stylesheet" type="text/css"  href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_coursesytyle.css')}">--}%
</head>

<body>

<div class="userspace_title" style="width: 100%;">
    <a href="">${message(code: 'my.mined.name')}${message(code: 'my.notes.name')}</a>
</div>

<div class="m-data-lists f-cb f-pr j-data-list">
    <g:each in="${notesList}" var="model">
        <div class="w-cardnoteitem f-cb first last">
            <a href="${createLink(controller: 'program', action: 'showProgram', params: [id: model[0].id])}"
               target="_blank"><img class="img j-img" src="${posterLinkNew(program: model[0], size: "120x66")}">
            </a>

            <div class="info">
                <p title="" class="j-name name f-thide">
                    <a href="${createLink(controller: 'my', action: 'viewCourseNote', params: [programId: model[0].id])}">${model[0].name}</a>
                </p>

                <p class="numwrap">共<span class="num j-num">${model[1]}</span>条</p>

                <p class="time"><span>${message(code: 'my.creat.name')}${message(code: 'my.time.name')}：</span><span
                        class="j-time">${Date.parse("yyyyMMddHHmmss", model[2] as String).format("yyyy-MM-dd HH:mm:ss")}</span>
                </p>
            </div>

        </div>
    </g:each>

</div>
</body>
</html>