<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-3-13
  Time: 下午4:25
--%>

<%@ page import="java.text.SimpleDateFormat" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>公告列表</title>
    <script type="text/javascript">
        //Notice删除
        function deleteNotice(noticeId, studyCommunityId) {
            if (confirm("您确定要删除？")) {
                $.post("noticeDelete", {
                    noticeId: noticeId,
                    studyCommunityId: studyCommunityId

                }, function (data) {
                    if (data.deleteSuccess != null) {
                        $("#tr" + noticeId).remove();
                        alert("删除成功");
                    } else {
                        alert("删除失败");
                    }
                })
            }
        }
        //Notice批量删除
        function deleteNoticeList(studyCommunityId) {
            var checkboxList = $("#noticeTable").find("input:checked");
            if (checkboxList.size() == 0) {
                alert("请选择要删除的公告！");
            } else {
                if (confirm("您确定都删除吗？")) {
                    var noticeId = "";
                    for (var i = 0; i < checkboxList.size(); i++) {
                        noticeId += checkboxList[i].value;
                        if (i != checkboxList.size() - 1) {
                            noticeId += ",";
                        }
                    }
                    $.post("noticeDelete", {
                        noticeId: noticeId,
                        studyCommunityId: studyCommunityId
                    }, function (data) {
                        if (data.deleteSuccess != null) {
                            var ids = noticeId.split(",");
                            for (var i = 0; i < ids.length; i++) {
                                $("#tr" + ids[i]).remove();
                            }
                            alert("删除成功");
                        } else {
                            alert("删除失败");
                        }
                    })
                }
            }
        }
    </script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>

</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px; ">
    <a href="">${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.notice.name')}${message(code: 'my.list.name')}</a>
</div>
<table class="table table-striped " id="noticeTable">
    <thead>
    <tr>
        <th width="45">${message(code: 'my.chose.name')}</th>
        <th>${message(code: 'my.notice.name')}${message(code: 'my.title.name')}</th>
        %{--  <th>公告内容</th>--}%
        <th width="90">${message(code: 'my.notice.name')}${message(code: 'my.time.name')}</th>
        <th width="50">${message(code: 'my.amend.name')}</th>
        <th width="50">${message(code: 'my.delete.name')}</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${noticeList}" var="notice" status="i">
        <tr id="tr${notice.id}">
            <td><g:checkBox name="noticeId" value="${notice.id}" checked="false"></g:checkBox></td>
            <td>${notice.name}</td>
            %{--<td>${notice.description}</td>--}%
            <td>${new SimpleDateFormat("yyyy-MM-dd").format(notice.dateCreated)}</td>
            <td><a class="btn  btn-warning btn-xs"
                   href="${createLink(controller: 'CommunityMgr', action: 'noticeEdit', params: [noticeId: notice.id, studyCommunityId: studyCommunity.id])}">修改</a>
            </td>
            <td><a class="btn  btn-warning btn-xs"
                   onclick="deleteNotice(${notice.id}, ${studyCommunity.id})">${message(code: 'my.delete.name')}</a>
            </td>
        </tr>
        </div>
    </g:each>

    </tbody>

</table>
<br/>
<g:if test="${noticeList.size() >= 0}">
    <input type="button" class="btn btn-default" onclick="deleteNoticeList(${studyCommunity.id})" value="批量删除">
</g:if>
<div class="page">
    <g:guiPaginate controller="communityMgr" action="noticeList" total="${total}"
                   params="${[studyCommunityId: studyCommunity?.id]}"/>
</div>
</body>
</html>