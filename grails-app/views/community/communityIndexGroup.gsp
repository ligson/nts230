<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/6/16
  Time: 10:30
--%>

<%@ page import="nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.community.name')}${message(code: 'my.group.name')}</title>
    <meta name="layout" content="communityIndexLayout">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index_tab.css')}">
</head>

<body>
<div class="c_index_tab">
    <g:each in="${forumBoardList}" var="forumBoard" status="no">
        <div class="c_index_form">

            <div class="c_f_user">
                <a href="${createLink(controller: 'my', action: 'myIndex', params: [id: forumBoard.createConsumer.id])}"><img
                        src="${resource(dir: 'upload/communityImg/forumboard', file: forumBoard.photo)}"
                        style="border-radius: 0" onerror="this.src='${resource(dir: 'skin/blue/pc/front/images', file: "boful_community_content_items_img.png")}'"/></a>
                <g:if test="${session.consumer && forumBoard.createConsumer.id == session.consumer.id}">
                </g:if>
                <g:elseif test="${judgeJoinBoard(consumer: session.consumer, forumBoard: forumBoard) == 'true'}">
                    <div class="c_f_user_joined" id="unjoin${no}"><a href="javascript:void(0)"
                                                                     onclick="deleteMember(${forumBoard.id}, ${no})">-${message(code: 'my.exit.name')}${message(code: 'my.group.name')}</a>
                    </div>
                </g:elseif>
                <g:else>
                    <div class="c_f_user_join"><a
                            onclick="addGroup(${forumBoard?.id})">+${message(code: 'my.attending.name')}${message(code: 'my.group.name')}</a>
                    </div>
                </g:else>

            </div>


            <div class="c_index_form_in">
                <h2><a
                        href="${createLink(controller: 'community', action: 'communityGroupIndex', params: [id: forumBoard.id])}">${forumBoard.name}</a>
                </h2>

                <div class="c_in_word">
                    ${CTools.htmlToBlank(forumBoard.description)}
                </div>

                <p><span><a
                        href="${createLink(controller: 'my', action: 'userSpace', params: [id: forumBoard.createConsumer.id])}">${consumerName(id: forumBoard.createConsumer.id)}</a>
                </span><span>${forumBoard.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</span></p>

            </div>
        </div>
    </g:each>
    <div class="f_page">
        <g:guiPaginate controller="community" action="communityIndexGroup" total="${total}" params="${params}"
                       max="20"/>
    </div>

</div>
<script type="text/javascript">
    var isAnony = ${(session.consumer == null || session.consumer.name == 'anonymity')?"true":"false"};//是否匿名用户
    function addGroup(tag) {
        if(isAnony) {
            alert("匿名用户不能加入该小组，请先登录！");
            return;
        }
        var pars = {id: tag};
        var url = baseUrl + "community/addConsumerAjax";
        $.ajax({
            url: url,
            data: pars,
            success: function (data) {
                alert(data.msg);
                window.location.reload();
            }
        });
    }

    //成员退出
    function deleteMember(boardId, no) {
        if (confirm("您确定要退出吗？")) {
            $.ajax({
                url: baseUrl + "community/changeForumMemberAttr",
                data: {
                    state: 2,
                    forumBoardId: boardId,
                    attrName: "state"
                },
                success: function (data) {
                    if (!data.success) {
                        alert("参数错误！！");
                        window.location.reload();
                    }
                    else {
                        $('#unjoin' + no).html("<a onclick='addGroup(" + boardId + ")'>+加入小组</a>");
                        alert(data.message);
                    }
                }
            });

        }
    }
</script>
</body>
</html>