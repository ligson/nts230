<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-3-15
  Time: 下午4:42
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.topic.name')}${message(code: 'my.list.name')}</title>
    <script type="text/javascript">
        //批量删除
        function deleteForumMainArticleList(studyCommunityId) {
            var checkboxList = $("#forumMainArticleTable").find("input:checked");
            if (checkboxList.size() == 0) {
                alert("请选择要删除的话题！！");
            } else if (confirm("您确定要都删除吗?")) {
                var forumMainArticleId = "";
                for (var i = 0; i < checkboxList.size(); i++) {
                    forumMainArticleId += checkboxList[i].value;
                    if (i != checkboxList.size() - 1) {
                        forumMainArticleId += ",";
                    }
                }
                $.post("forumMainArticleDelete", {
                    forumMainArticleId: forumMainArticleId,
                    studyCommunityId: studyCommunityId
                }, function (data) {
                    if (data.deleteSuccess != null) {
                        var ids = forumMainArticleId.split(",");
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
        //删除
        function deleteForumMainArticle(studyCommunityId, forumMainArticleId) {
            if (confirm("您确定要删除？？")) {
                $.post("forumMainArticleDelete", {
                    studyCommunityId: studyCommunityId,
                    forumMainArticleId: forumMainArticleId
                }, function (data) {
                    if (data.deleteSuccess) {
                        $("#tr" + forumMainArticleId).remove();
                        alert(data.msg);
                    } else {
                        alert(data.msg);
                    }
                })
            }
        }
        //更改精华
        function changeElite(studyCommunityId, forumMainArticleId) {
            $.post("changeElite", {
                studyCommunityId: studyCommunityId,
                forumMainArticleId: forumMainArticleId
            }, function (data) {
                if (data.changeSuccess) {
                    $("#isEliteId" + forumMainArticleId).text(data.msg);
                } else {
                    alert('修改失败');
                }
            })
        }
        //更改置顶
        function changeTop(studyCommunityId, forumMainArticleId) {
            $.post("changeTop", {
                studyCommunityId: studyCommunityId,
                forumMainArticleId: forumMainArticleId
            }, function (data) {
                if (data.changeSuccess) {
                    $("#isTop" + forumMainArticleId).text(data.msg);
                } else {
                    alert('修改失败');
                }
            })
        }
    </script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>

</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.topic.name')}${message(code: 'my.list.name')}</a>
</div>

%{--<div style="float: left;text-align: left; margin: 10px 5px 10px 5px; font-size: 14px; color: #5a5f68;font-weight: bold; border-bottom: 1px #dddddd solid; "></div>--}%
<div>
    <table class="table table-striped" id="forumMainArticleTable">
        <thead>
        <tr>
            <th width="40" style="text-align: center">${message(code: 'my.chose.name')}</th>
            <th>${message(code: 'my.topic.name')}${message(code: 'my.title.name')}</th>
            %{-- <th>帖子内容</th>--}%
            <th width="70">${message(code: 'my.group.name')}</th>
            <th width="70">${message(code: 'my.essence.name')}</th>
            <th width="60">${message(code: 'my.top.name')}</th>
            <th width="90">${message(code: 'my.creat.name')}${message(code: 'my.time.name')}</th>
            <th width="70">${message(code: 'my.forumReplyArticle.name')}${message(code: 'my.number.name')}</th>
            <th width="60">${message(code: 'my.operation.name')}</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${forumMainArticleList}" var="forumMainArticle">
            <tr id="tr${forumMainArticle.id}">
                <td style="text-align: center; width: 50px;overflow: hidden ">
                    <g:checkBox name="forumMainArticleId" value="${forumMainArticle.id}" checked="false"></g:checkBox>
                </td>
                <td style="text-align: left">${forumMainArticle.name}</td>
                %{--  <td style="text-align: left">${CTools.cutString(forumMainArticle.description, 20)}</td>--}%
                <td style="text-align: left">${forumMainArticle.forumBoard.name}</td>
                <td>
                    <g:if test="${forumMainArticle?.isElite == 1}"><a id="isEliteId${forumMainArticle.id}"
                                                                      onclick="changeElite(${studyCommunity.id}, ${forumMainArticle.id})"
                                                                      class="btn  btn-success btn-xs">是</a></g:if>
                    <g:else><a id="isEliteId${forumMainArticle.id}"
                               onclick="changeElite(${studyCommunity.id}, ${forumMainArticle.id})"
                               class="btn  btn-success btn-xs">否</a></g:else>
                </td>
                <td>
                    <g:if test="${forumMainArticle?.isTop == 1}"><a id="isTop${forumMainArticle.id}"
                                                                    onclick="changeTop(${studyCommunity.id}, ${forumMainArticle.id})"
                                                                    class="btn  btn-success btn-xs">是</a></g:if>
                    <g:else><a id="isTop${forumMainArticle.id}"
                               onclick="changeTop(${studyCommunity.id}, ${forumMainArticle.id})"
                               class="btn  btn-success btn-xs">否</a></g:else>
                </td>
                <td>
                    ${new java.text.SimpleDateFormat("yyyy-MM-dd").format(forumMainArticle?.dateCreated)}
                </td>
                <td>${forumMainArticle.forumReplyArticle.size()}</td>
                <td><a onclick="deleteForumMainArticle(${studyCommunity.id}, ${forumMainArticle.id})"
                       class="btn  btn-warning btn-xs">删除</a></td>
            </tr>
        </g:each>
        <g:if test="${forumMainArticleList?.size() >= 2}">
            <tr>
                <td><input class="btn btn-default" type="button"
                           onclick="deleteForumMainArticleList(${studyCommunity.id})" value="批量删除"/></td>
            </tr>
        </g:if>

        </tbody>

        <div class="page">
            <g:guiPaginate controller="communityMgr" action="forumMainArticleList" total="${total}"
                           params="${[studyCommunityId: studyCommunity?.id]}"/></div>
    </table>
</div>
</body>
</html>