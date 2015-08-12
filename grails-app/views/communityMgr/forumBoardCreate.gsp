<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 14-3-12
  Time: 下午2:26
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <g:if test="${forumBoard?.id}">
        <title>${message(code: 'my.amend.name')}${message(code: 'my.group.name')}</title>
    </g:if>
    <g:else>
        <title>${message(code: 'my.creat.name')}${message(code: 'my.group.name')}</title>
    </g:else>
    %{--<link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'fromBordCreate.css')}">--}%
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <script type="text/javascript">
        function submitCreateBoard() {
            var patrn = /^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
            if ($("#forumBoardnameId").val() == "") {
                alert("请输入小组标题");
                return false;
            } else {
                var forumBoardId = $("#forumBoardId").val();
                var forumBoarName = $("#forumBoardnameId").val();
                var studyCommunityId = $("#studyCommunityId").val();
                $.post(baseUrl + "communityMgr/checkExistForumBoardName", {forumBoardId: forumBoardId, forumBoardName: forumBoarName, studyCommunityId: studyCommunityId}, function (data) {
                    if (data.success) {
                        /*if (patrn.test($("#forumBoardnameId").val()) == false) {
                         alert("小组标题含有特殊字符!");
                         return false;
                         } else*/
                        if ($.trim($("#forumBoardDescriptionId").val()) == "") {
                            alert("请填写小组描述");
                            return false;
                        } else if ($("#forumBoardDescriptionId").val().length > 500) {
                            alert("小组描述字符最多500字");
                            return false;
                        } else {
                            $("#createBoradForm").submit();
                        }
                    } else {
                        alert(data.msg);
                    }
                });
            }
        }
    </script>
    <style type="text/css">
    h1 {
        font-size: 15px;;
    }

    .com-dis {
        width: 680px;
        padding: 20px 15px;
        display: block;
        overflow: hidden;
    }

    .c-w {
        width: 180px;
        height: 30px;
    }
    </style>
    %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_space.css')}">--}%
</head>

<body>

<g:uploadForm controller="communityMgr" action="forumBoradSave" name="createBoradForm">
%{--这里应该还隐藏studyCommunityId--}%
    <input type="hidden" name="studyCommunityId" id="studyCommunityId" value="${studyCommunity.id}"/>
    <input type="hidden" name="forumBoardId" id="forumBoardId" value="${forumBoard?.id}"/>
    <input type="hidden" name="studyCommunityManager" value="1">
    <div class="community_form_content">
        <div class="community_form_content_creat">
            <g:if test="${forumBoard?.id}">
                <h1>+${message(code: 'my.amend.name')}${message(code: 'my.group.name')}</h1>
            </g:if>
            <g:else>
                <h1>+${message(code: 'my.creat.name')}${message(code: 'my.group.name')}</h1>
            </g:else>
            <g:message code="${flash.message}"></g:message>
            <div class="com-dis">
            <table class="table">
                <tbody>
                <tr>
                    <td width="75" align="right">${message(code: 'my.group.name')}${message(code: 'my.title.name')}</td>
                    <td>
                        <input type="text" class="form-control" name="forumBoardname" id="forumBoardnameId"
                               value="${forumBoard?.name}" style="width: 560px">
                    </td>
                </tr>
                <tr>
                    <td width="75"
                        align="right">${message(code: 'my.group.name')}${message(code: 'my.poster.name')}</td>
                    <td>
                        <input type="file" class="c-w" name="forumBoardPhoto" id="forumBoardPhotoId" value=""
                               style="width: 560px">
                    </td>
                </tr>
                <tr>
                    <td width="75"
                        align="right">${message(code: 'my.group.name')}${message(code: 'my.introduction.name')}</td>
                    <td>
                        <textarea class="form-control" rows="3" name="forumBoardDescription" style="width: 560px"
                                  id="forumBoardDescriptionId">${forumBoard?.description}</textarea>
                    </td>
                </tr>
                <g:if test="${studyCommunityManager && forumBoard?.id}">
                    <tr>
                        <td width="100"
                            align="right">${message(code: 'my.group.name')}${message(code: 'my.master.name')}</td>
                        <td>
                            <label>

                                <select class="form-control" style="width: 120px" name="forumBoardManagerId">
                                    %{--选择无表示默认为社区管理员，也就是当前用户,因为能修改板块管理员的只有社区管理员--}%
                                    <option value="${session?.consumer?.id}">无</option>
                                    <g:each in="${forumMemberList ?}" status="i" var="forumMember">
                                        <option value="${forumMember?.consumer.id}" ${(forumMember?.consumer.id == forumBoard?.createConsumer?.id) ? "selected='selected'" : ""}>${forumMember?.consumer?.name}</option>
                                    </g:each>
                                </select>

                            </label>
                            <span style="float: right;font-size: 12px;color: #999">设置小组管理员,如果为无，则默认为社区管理员</span>
                        </td>
                    </tr>
                </g:if>
                <tr>
                    <td></td>
                    <td>
                        <label>
                            <input class="btn btn-primary" type="button" onclick="submitCreateBoard()" value="提交"/>
                        </label>
                    </td>
                </tr>
                </tbody>
            </table>
            </div>
        </div>

    </div>

</g:uploadForm>
</body>
</html>