<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 14-3-12
  Time: 下午2:26
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.group.name')}${message(code: 'my.list.name')}</title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    %{--<link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'formBoardList.css')}">--}%
    %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_space.css')}">--}%
</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.group.name')}${message(code: 'my.list.name')}</a>
</div>


<div class="community_forms_contents" id="forumBoardTable">
    <div class="community_forms_items">
        <table class="table" style="background: #FFF">
            <tbody>
            <tr>
                <th width="50" align="center">${message(code: 'my.chose.name')}</th>
                <th width="80">${message(code: 'my.poster.name')}</th>
                <th width="100">${message(code: 'my.designation.name')}</th>
                <th width="80">${message(code: 'my.creator.name')}</th>
                <th width="80">${message(code: 'my.topic.name')}${message(code: 'my.number.name')}</th>
                <th width="120">${message(code: 'my.creat.name')}${message(code: 'my.time.name')}</th>
                <th width="80">${message(code: 'my.state.name')}</th>
                <th width="80">${message(code: 'my.amend.name')}</th>
                <th width="80">${message(code: 'my.delete.name')}</th>
            </tr>
            <g:each in="${forumBoardList}" status="i" var="forumBoard">
                <tr id="tr${forumBoard?.id}">
                    <td>
                        <g:checkBox name="boardId" value="${forumBoard?.id}" checked="false"></g:checkBox>
                    </td>
                    <td><a class="forms_manager_point" href="#"><img
                            onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"
                            src="${resource(dir: 'upload/communityImg/forumboard', file: forumBoard.photo)}"></a>
                    </td>
                    <td><a class="forms_manager_title"
                           href="${createLink(controller: 'community', action: 'communityGroupIndex', params: [id: forumBoard?.id, communityId: forumBoard?.studyCommunity?.id])}">${forumBoard.name}</a>
                    </td>
                    <td><span class="forms_manager_name">${forumBoard.createConsumer.name}</span></td>
                    <td><span class="forms_manager_number">${forumBoard.forumMainArticle.size()}</span></td>
                    <td><span class="forms_manager_time"><g:formatDate format="yyyy-MM-dd hh:mm:ss" date="${forumBoard.dateCreated}"/></span></td>
                    <td><span class="forms_manager_time" id="stateSpan">
                        <a class="btn btn-success btn-xs" id="isBoardId${forumBoard.id}"
                           onclick="changeState(${studyCommunity.id}, ${forumBoard.id})"><g:if
                                test="${forumBoard.state == 1}">审核通过</g:if><g:else>待审核</g:else></a>
                    </span></td>
                    <td><span><a
                            href="${createLink(controller: 'CommunityMgr', action: 'forumBoradEdit', params: [forumBoardId: forumBoard.id, studyCommunityId: studyCommunity?.id, studyCommunityManager : 1])}"
                            class="btn btn-default btn-xs">修改</a>
                    </span></td>
                    <td><a onclick="deleteBoard(${studyCommunity?.id}, ${forumBoard?.id})"
                           class="btn btn-default btn-xs">删除</a></td>
                </tr>

            %{--<div class="community_forms_item" style="padding-right:10px;">
                <div class="ouknow_forum_icon">
                    --}%%{--<img src="${resource(dir: 'upload/communityImg', file: 'default.jpg')}"/>--}%%{--
                    <img onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'"
                         src="${resource(dir: 'upload/communityImg/forumboard', file: forumBoard.photo)}">
                </div>

                <div class="ouknow_forum_plate_cont">
                    <h2>${forumBoard.name}</h2>

                    <div class="ouknow_forum_plate_cont_des">${forumBoard.description}</div>

                    <div class="ouknow_forum_plate_bot">
                        <div class="ouknow_forum_plate_post">帖子：<span>${forumBoard.forumMainArticle.size()}</span></div>

                        <div class="ouknow_forum_plate_post_back"><span><a
                                href="${createLink(controller: 'CommunityMgr', action: 'forumBoradEdit', params: [forumBoardId: forumBoard.id, studyCommunityId: studyCommunity?.id])}">修改</a>
                        </span></div>
                    </div>
                </div>
            </div>--}%
            </g:each>

            </tbody>

        </table>
    </div>
</div>
<input type="button" class="btn btn-default" onclick="deleteBoardList(${studyCommunity?.id})" value="批量删除">

<div class="page">
    <g:guiPaginate controller="communityMgr" action="forumBoradList" total="${total}"
                   params="${[studyCommunityId: studyCommunity?.id]}"/>
</div>
<script type="text/javascript" language="JavaScript">
    //更改精华
    function changeState(studyCommunityId, forumBoardId) {
        $.post("changeForumBoardState", {
            studyCommunityId: studyCommunityId,
            forumBoardId: forumBoardId
        }, function (data) {
            if (data.changeSuccess) {
                $("#isBoardId" + forumBoardId).text(data.msg);
            } else {
                alert('修改失败');
            }
        })
    }

    //批量删除
    function deleteBoardList(studyCommunityId) {
        var checkboxList = $("#forumBoardTable").find("input:checked");
        if (checkboxList.size() == 0) {
            alert("请选择要删除的小组！！");
        } else if (confirm("您确定要都删除吗?")) {
            var forumBoardIds = "";
            for (var i = 0; i < checkboxList.size(); i++) {
                forumBoardIds += checkboxList[i].value;
                if (i != checkboxList.size() - 1) {
                    forumBoardIds += ",";
                }
            }
            $.post("deleteForumBoards", {
                idList: forumBoardIds,
                studyCommunityId: studyCommunityId
            }, function (data) {
                if (data.deleteSuccess != null) {
                    var ids = forumBoardIds.split(",");
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
    function deleteBoard(studyCommunityId, boardId) {
        if (confirm("您确定要删除？？")) {
            $.post("deleteForumBoards", {
                studyCommunityId: studyCommunityId,
                idList: boardId
            }, function (data) {
                if (data.deleteSuccess) {
                    $("#tr" + boardId).remove();
                    alert(data.msg);
                } else {
                    alert(data.msg);
                }
            })
        }
    }

</script>
</body>
</html>