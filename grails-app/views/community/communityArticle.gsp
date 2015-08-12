<%@ page import="nts.commity.domain.ForumMember; java.text.SimpleDateFormat; nts.utils.CTools" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>小组首页</title>
    <meta name="layout" content="index">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_article.css')}">
    <script type="text/javascript">
        $(function () {

        })
        $(document).ready(function () {
            $(".community_master_right_body").find("p").find("a").click(function () {
                var com = $($(this).parent("p")).parent(".community_master_right_body");
//                alert($(com).html);
                if ($(com).next().is(":hidden")) {
                    $(com).next().show(500);
                } else {
                    $(com).next().hide();
                }
            });
        });
    </script>

</head>

<body>
<g:render template="communitySubHeader" model="${[studyCommunity: article.forumBoard.studyCommunity]}"/>



<div class="community_groups_content">
<div class="community_group_content_left">

    <div class="community_article_release_box">
        <div class="community_group_infor_name">
            <p><span></span>${CTools.cutString(article?.name, 20)}</p>
        </div>

        <div class="user_release_box">
            <label>
                <input class="user_release_but" type="button" onclick="addFocus()" value="回复话题">
            </label>
        </div>
    </div>

    <div class="community_answer_items">
        <div class="community_master" style=" background:#fbfbfb;">
            <div class="c_master_mark"></div>

            <div class="community_master_left">
                <div class="community_master_left_img">
                    <img src="${generalUserPhotoUrl(consumer: article?.createConsumer)}" width="28" height="28"
                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                </div>

                <div class="community_master_infor">
                    <p>${article?.createConsumer?.name}</p>
                </div>
            </div>

            <div class="community_master_right">
                <div class="community_master_right_content">
                    %{--<img src="${resource(dir: 'skin/blue/pc/images', file: 'banner_img01.png')}"/>--}%

                    <p>
                        ${article?.description}
                    </p>
                </div>

                <div class="community_master_right_body">
                    <p>
                        %{-- <a href="#">回&nbsp;复（${article?.forumReplyArticle?.size()}）</a>
                         <strong>|</strong>--}%
                        <span><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${article?.dateCreated}"/></span>
                    </p>
                </div>
            </div>
        </div>
    </div>

    %{--<div class="c_answer_num">
        <div class="c_a_back">关于本帖共<span>1501</span>个回复:</div>
    </div>--}%

    <div class="community_answer_items">

    <!---------------回复内容-------------->
    <g:if test="${forumReplyArticle.size()>0}">
        <g:each in="${forumReplyArticle}" var="reply">
            <div class="community_answer_item">
                <div class="community_answer_item_left">
                    <div class="user_answer_left_phot">
                        <img src="${generalUserPhotoUrl(consumer: reply?.replyConsumer)}" width="28" height="28"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                    </div>

                    <div class="user_answer_left_names">
                        <p class="an_name">${reply?.replyConsumer?.name}</p>
                    </div>
                </div>

                <div class="community_answer_item_right">
                    <div class="other_answer_first">
                        <p class="other_answer_first_content">
                            ${CTools.htmlToBlank(reply?.description)}
                        </p>
                    </div>

                    <div class="community_master_right_body">
                        <p>
                            <a>${message(code: 'my.back.name')}(${reply?.forumReplySubjectArticle?.size()})</a>
                            <strong>|</strong>
                            <span><g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${reply?.dateCreated}"/></span>
                        </p>
                    </div>

                    <div class="community_master_question_backs" style="display: none">
                        <div class="master_question_back_box">
                            <div class="master_question_back_input">
                                <label>
                                    <textarea id="description${reply?.id}">输入回复内容</textarea>
                                </label>
                            </div>

                            <div class="master_question_back_but">
                                <label>
                                    <input type="button" value="发表"
                                           onclick="replyArticle(${reply?.id}, ${article.forumBoard.id})">
                                </label>
                            </div>
                        </div>

                        <div class="master_question_items">
                            <g:each in="${reply?.forumReplySubjectArticle}" var="subReply">
                                <div class="master_question_item">
                                    <div class="master_question_item_photo">
                                        <img src="${generalUserPhotoUrl(consumer: subReply?.consumer)}" width="28"
                                             height="28"
                                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
                                    </div>

                                    <div class="master_question_item_content">
                                        <div class="item_content_describe">
                                            <div class="master_question_item_name">${subReply?.consumer?.name}${message(code: 'my.back.name')}${reply?.replyConsumer?.name}：</div>
                                            ${CTools.htmlToBlank(subReply?.description)}
                                        </div>

                                        <div class="master_question_item_back_body">
                                            <p>
                                                %{-- <a href="#">回&nbsp;复</a>
                                                 <strong>|</strong>
                                                 <a href="#">收&nbsp;藏</a>
                                                 <strong>|</strong>--}%
                                                <span><g:formatDate format="yyyy-MM-dd HH:mm:ss"
                                                                    date="${subReply?.dateCreated}"/></span>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </g:each>

                        </div>
                    </div>
                </div>
            </div>
        </g:each>
        <div class="f_page">
            <g:guiPaginate controller="community" action="communityArticle" total="${forumReplyTotal}" params="${params}" />
        </div>
    </g:if>




        <div class="anyone_answer_back">
            <h1>${message(code: 'my.send.name')}${message(code: 'my.review.name')}</h1>

            <div class="anyone_answer_back_box">
                <label>
                    <textarea id="replayDescription"></textarea>
                </label>
            </div>

            <div class="anyone_answer_back_but">
                <label>
                    <input type="button" value="发表" onclick="addArticle(${article?.id}, ${article.forumBoard.id})">
                </label>
            </div>
        </div>
    </div>
</div>

<div class="community_group_content_right">
    %{--    <div class="jion_group_mine">
            <div class="jion_group_mine_img">
                <img src="${generalUserPhotoUrl(consumer: article?.createConsumer)}" width="28" height="28"
                     onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
            </div>

            <div class="jion_group_mine_other">
                <h1 class="jion_group_name">${article?.createConsumer?.name}</h1>

                <div>
                    <p>发起：<span>${articleTotal}</span></p>

                    <p>回应：<span>${replyTotal}</span></p>
                </div>
            </div>
        </div>--}%

    <div class="community_group_user_offer">
        <h1 class="crate_plate">${message(code: 'my.group.name')}${message(code: 'my.informations.name')}<div
                class="community_jined">
            <g:if test="${session.consumer && (article?.forumBoard.createConsumer.id == session.consumer.id)}">
            </g:if>
            <g:elseif test="${judgeJoinBoard(consumer: session.consumer, forumBoard: article?.forumBoard) == 'true'}">
                <p class="other_group_jioned" style="cursor: pointer" id="unjoin"><span class="">-</span>&nbsp;<a
                        href="javascript:void(0)"
                        onclick="deleteMember(${article?.forumBoard?.id})">${message(code: 'my.exit.name')}${message(code: 'my.group.name')}</a>
                </p>
            </g:elseif>
            <g:else>
                <p><a onclick="addGroup(${article?.forumBoard?.id})">+${message(code: 'my.attending.name')}${message(code: 'my.group.name')}</a>
                </p>
            </g:else>
        </h1>

        <div class="community_group_user_offer_items">
            <div class="com_o_des">
                <p class="com_o_d_t"><span>${message(code: 'my.creat.name')}${message(code: 'my.time.name')}<em><g:formatDate
                        format="yyyy-MM-dd" date="${article?.forumBoard.dateCreated}"/></em>
                </span><span>${message(code: 'my.master.name')}<em>${article?.forumBoard.createConsumer.nickname}</em>
                </span></p>

                <p class="com_o_d_w">${CTools.htmlToBlank(article?.forumBoard.description)}</p>
            </div>
            %{-- <table>
                 <tbody>
                 <tr>
                     <td class="group_creat_user">所属社区：</td>
                     <td></td>
                 </tr>
                 <tr>
                     <td class="group_creat_user">创建人：</td>
                     <td>${article?.forumBoard?.createConsumer?.name}</td>
                 </tr>

                 <tr>
                     <td class="group_creat_user">人员：</td>
                     <td>${article?.forumBoard?.forumMainArticle?.size()}</td>
                 </tr>
                 <tr>
                     <td class="group_creat_user">话题：</td>
                     <td>${article?.forumBoard?.name}</td>
                 </tr>
                 <tr>
                     <td class="group_creat_user">
                         简介：
                     </td>
                     <td class="g_s">
                         <p>
                             ${CTools.cutString(article?.forumBoard?.description, 20)}
                         </p></td>
                 </tr>
                 </tbody>
             </table>--}%
        </div>
    </div>


    <!------------推荐小组------->
    <div class="community_group_user_plate">
        <h1 class="crate_plate">${message(code: 'my.recommend.name')}${message(code: 'my.group.name')}</h1>

        <g:each in="${boards}" var="board">
            <div class="group_user_item">
                <div class="community_group_user_plate_imgs">
                    <a href="javascript:void(0);"
                       onclick="checkBoard(${board?.id}, ${board?.studyCommunity?.id})">
                        <img src="${resource(dir: 'upload/communityImg/forumboard', file: board.photo)}"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                    </a>
                </div>

                <div class="user_plate_infor">
                    <a href="javascript:void(0);"
                       onclick="checkBoard(${board?.id}, ${board?.studyCommunity?.id})">
                        <h1>${CTools.cutString(board?.name, 6)}</h1>
                    </a>

                    <p class="user_plate_infor_des">${CTools.cutString(CTools.htmlToBlank(board?.description), 20)}</p>

                    <div class="user_plate_infor_number">
                        <p><span>${ForumMember.findAllByForumBoard(board)?.size()}</span>人</p>
                        <g:if test="${judgeJoinBoard(consumer: session.consumer, forumBoard: board) == 'true'}">
                            <p class="other_group_jioned" style="cursor: pointer"><span
                                    class="">√</span>&nbsp;${message(code: 'my.already.name')}${message(code: 'my.attending.name')}
                            </p>
                        </g:if>
                        <g:else>
                            <p><a onclick="addGroup(${board?.id})">+${message(code: 'my.attending.name')}${message(code: 'my.group.name')}</a>
                            </p>
                        </g:else>
                    </div>
                </div>
            </div>
        </g:each>
    </div>
</div>
</div>
<script type="text/javascript">
    function checkBoard(boardId, studyCommunityId) {
        var pars = {studyCommunityId: studyCommunityId};
        var url = baseUrl + "community/checkCommunityState";
        $.post(url, pars, function (data) {
            if (data.success) {
                window.location.href = "/community/communityGroupIndex?id=" + boardId;
            } else {
                alert(data.msg);
            }

        });
    }

    function addGroup(tag) {
        var pars = {id: tag};
        var url = baseUrl + "community/addConsumerAjax";
        $.ajax({
            url: url,
            data: pars,
            success: function (data) {
                if (data.success) {
                    alert(data.msg);
                    window.location.reload();
                } else {
                    alert(data.msg);
                }

            }
        });
    }
    function replyArticle(tag, forumBoardId) {
        var description = $("#description" + tag).val();
        if ((description == "输入回复内容") || description == '') {
            alert("请输入回复内容!");
        } else {
            var url = "${createLink(controller: 'community',action: 'replayArticle')}";
            $.post(url, {id: tag, forumBoardId: forumBoardId, description: description}, function (data) {
                if (data.success) {
                    window.location.reload();
                } else {
                    alert(data.message);
                }
            });
        }

    }
    function addFocus() {
        $("#replayDescription").focus();
    }
    function addArticle(tag, forumBoardId) {
        var isLogin = ${(session.consumer == null || session.consumer.name == 'anonymity') ? false : true};
        if (!isLogin) {
            alert("您还没有登录！");
            return false;
        }

        var flag = ${judgeJoinBoard(consumer: session.consumer, forumBoard: article?.forumBoard) == 'true'};
        if (!flag) {
            alert("请先申请加入小组！");
            return false;
        }
        var replayDescription = $("#replayDescription").val();
        if (replayDescription == "") {
            alert("请输入评论内容!");
        } else {
            var url = baseUrl + "community/firstReplyArticle";
            var pars = {id: tag, forumBoardId: forumBoardId, description: replayDescription};
            $.post(url, pars, function (data) {
                if (data.success) {
                    window.location.reload();
                } else {
                    alert(data.message);
                }
            })
        }
    }
    $(function () {
        //$(".master_question_items").css("display", "none");
        $(".master_question_back_box textarea").click(function () {
            if ($(this).val() == "输入回复内容")$(this).val("");
        })
        $(".community_answer_items a").click(function () {
            var len = $(".community_answer_items a").length;
            var index = $(".community_answer_items a").index(this) - 1;
            for (var i = 0; i < len - 1; i++) {
                if (i == index) {
                    if ($(".community_answer_items .master_question_items:eq(" + i + ")").is(":hidden")) {
                        $(".community_answer_items .master_question_items:eq(" + i + ")").show();
                    } else {
                        $(".community_answer_items .master_question_items:eq(" + i + ")").hide();
                    }
                }
            }

        })
    })

    //成员退出
    function deleteMember(boardId) {
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
                        $('#unjoin').html("<a onclick='addGroup(" + boardId + ")'>+加入小组</a>");
                        alert(data.message);
                    }
                }
            });
        }
    }
</script>
</body>
</html>