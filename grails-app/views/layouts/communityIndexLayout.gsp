<%@ page import="nts.commity.domain.ForumMember; nts.front.community.controllers.CommunityController; nts.commity.domain.Notice; nts.commity.domain.ForumReplyArticle; nts.commity.domain.ForumBoard; nts.commity.domain.ForumMainArticle; nts.commity.domain.Activity; java.text.SimpleDateFormat; nts.commity.domain.Sharing; nts.utils.CTools; nts.user.domain.Consumer" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'hader_page.css')}">
    <r:require modules="jquery-cookie"/>
    <g:include view="layouts/indexCommonResources.gsp"/>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'communityIndex.css')}">

    <title><g:layoutTitle/>${message(code: 'my.community.name')}${message(code: 'my.home.name')}</title>
    <g:layoutHead/>
    <script type="text/javascript">
        $(function () {
            //$("#forumDiv").dialog({autoOpen: false, width: 600});
            //$("#startTime").datepicker();
            // $("#endTime").datepicker();
            $("#topActivity").mousemove(function () {
                $(".ou_a_p").show();
            });
            $("#topActivity").mouseout(function () {
                $(".ou_a_p").hide();
            });
            $("#topActivity .ou_a_p").mousemove(function () {
                $(".ou_a_p").show();
            });
            $("#topActivity .ou_a_p").mouseout(function () {
                $(".ou_a_p").hide();
            });

            var group1 = $("#group1");
            var activity1 = $("#activity1");
            $("#join_cla1").click(function () {
                group1.show();
                activity1.hide();
            });
            $("#join_cla2").click(function () {
                group1.hide();
                activity1.show();
            });
        });
        function sentFurm() {
            var forumWin = $("#forumDiv");
            var dialogWidth = forumWin.width();
            var dialogHeight = forumWin.height();
            var winWidth = $(window).width();
            var winHeight = $(window).height();
            var top = (winHeight - dialogHeight) / 2;
            var left = (winWidth - dialogWidth ) / 2;
            forumWin.css({top: top + "px", left: left + "px"});
            var position = forumWin.position();

            $("forumDiv").html("left：" + position.left + ", top:" + position.top);
            $("#forumDiv").show();
        }
        function closeFurm() {
            $("#forumDiv").hide();
        }
    </script>
</head>

<body>
<!--header begin--->
<g:include view="layouts/indexHeader.gsp"/>
<!--header end--->

<div id="forumDiv" class="sent_window" title="发布话题">
    <div class="sent_window_nva">
        <p class="sent_window_chose">${message(code: 'my.chose.name')}${message(code: 'my.group.name')}</p>

        <p class="sent_window_close"><label><input type="button" value="" onclick="closeFurm();"></label></p>
    </div>

    <div>
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <g:each in="${boardList}" var="board">
                <tr>
                    <td class="sent_talk_ma_name"><p class="furm_group_list"><a>${board.name}</a></p></td>
                    %{--<td class="sent_talk_massage" align="center"><span></span></td>
                    <td class="sent_talk_number" align="center"><span>655个话题</span></td>--}%
                    <td class="sent_talk_m_but" align="right"><a
                            href="${createLink(controller: 'community', action: 'communityGroupIndex', params: [id: board.id])}">${message(code: 'my.send.name')}${message(code: 'my.topic.name')}</a>
                    </td>
                </tr>
            </g:each>
        </table>
        %{--  <g:each in="${boardList}" var="board">
              <p class="furm_group_list">
                  <a href="${createLink(controller: 'community', action: 'communityGroupIndex.js', params: [id: board.id])}">${board.name}</a>
              </p>
          </g:each>--}%
    </div>
    %{--<table>
         <tr>
             <td>话题名：</td>
             <td><input type="text" name="name"><input type="hidden" value="${studyCommunity?.id}" name="communityId"></td>
         </tr>
        <tr>
            <td>开始时间：</td>
            <td><input type="text" name="startTime" id="startTime"></td>
        </tr>
        <tr>
            <td>结束时间：</td>
            <td><input type="text" name="endTime" id="endTime"></td>
        </tr>
        <tr>
            <td>内容：</td>
            <td><textarea name="description" cols="30" rows="5"></textarea></td>
        </tr>
    </table>--}%
</div>

<div class="ou_space_body">
    <div class="ou_space_con wrap">
        <div class="ou_space_head">
            <div class="ou_space_head_box">
                <div class="ou_space_head_img">
                    <img src="${generalCommunityPhotoUrl(community: studyCommunity)}"/>
                </div>

                <div class="ou_space_head_right">
                    <div class="ou_s_h_right"><p class="o_s_name">${studyCommunity.name}</p>

                        <p class="ou_s_h_opeart">
                            <span>${message(code: 'my.creator.name')}：<em>${readStudyCommunityCreater(id: studyCommunity.create_comsumer_id)}</em>
                            </span>
                            <span>${message(code: 'my.members.name')}：<em>${readStudyCommunityMembersCount(studyCommunity: studyCommunity)}</em>
                            </span>
                            %{--<span>帖子：<em>000</em></span>--}%
                            <span>${message(code: 'my.group.name')}：<em>${studyCommunity.forumBoards.size()}</em></span>
                        </p>
                    </div>

                    <p class="ou_s_h_des">${CTools.htmlToBlank(studyCommunity.description)}</p>
                </div>
            </div>
            <img class="ou_spou_space_con_img"
                 onerror="this.src='${resource(dir: 'skin/blue/pc/front/images', file: 'community_space_bg.png')}'" src="${communityIndexLayoutImgUrl(bgPhoto:  studyCommunity.bgPhoto)}"/>
        </div>

        <div class="ouknow_notice_item">
            <span>${message(code: 'my.inform.name')}${message(code: 'my.notice.name')}: &nbsp;</span>
            <g:if test="${noticeNew?.id}"><a href="${createLink(controller:'community', action:'showNotice', params:[noticeId:noticeNew?.id, studyCommunityId: studyCommunity.id])}">${noticeNew?.name}</a></g:if>
            <g:else><a href="#">暂无公告</a></g:else>

        </div>

        <div class="ou_space_nav wrap">
            <div class="ou_space_na">
                <p>

                <div class="o_p_nav" id="activity_style"><a
                        href="${createLink(controller: 'community', action: 'communityIndex', params: [id: studyCommunity.id])}" ${"communityIndex".equals(actionName) ? "class='o_p_nav_current'" : ""}>${message(code: 'my.topic.name')}</a>
                </div>

                <div class="o_p_nav" id="group_style"><a
                        href="${createLink(controller: 'community', action: 'communityIndexGroup', params: [id: studyCommunity.id])}" ${"communityIndexGroup".equals(actionName) ? "class='o_p_nav_current'" : ""}>${message(code: 'my.group.name')}</a>
                </div>

                <div class="o_p_nav" id="sharing_style"><a
                        href="${createLink(controller: 'community', action: 'communityIndexShare', params: [id: studyCommunity.id])}" ${"communityIndexShare".equals(actionName) ? "class='o_p_nav_current'" : ""}>${message(code: 'my.share.name')}</a>
                </div>

                <div class="o_p_nav" id="topActivity">
                    <div class="ou_a_p"><em
                            onclick="window.location.href = '${createLink(controller: "community",action: 'communityIndexActivity',params: [id:studyCommunity.id,isFlag:'0'])}'">${message(code: 'my.all.name')}${message(code: 'my.community.name')}${message(code: 'my.activities.name')}</em>
                        <em onclick="window.location.href = '${createLink(controller: "community",action: 'communityIndexActivity',params: [id:studyCommunity.id,isFlag:'1'])}'">${message(code: 'my.starting.name')}</em>
                        <em onclick="window.location.href = '${createLink(controller: "community",action: 'communityIndexActivity',params: [id:studyCommunity.id,isFlag:'-1'])}'">${message(code: 'my.ended.name')}</em>
                    </div>
                    <a href="${createLink(controller: 'community', action: 'communityIndexActivity', params: [id: studyCommunity.id])}" ${"communityIndexActivity".equals(actionName) ? "class='o_p_nav_current'" : ""}>${message(code: 'my.activities.name')}</a>
                </div>

            </div>

            %{--     <div class="c_m_quit">
                     --}%%{--<a class="c_m_fat" onclick="sentFurm();">发布话题</a>--}%%{--
                     --}%%{-- <a class="c_m_cg" href="" >创建小组</a>--}%%{----}%%{--<span>|</span>--}%%{--
                     <a class=" c_m_share" href="javascript:void(0);"
                        onclick="checkAuthority(1, ${studyCommunity?.id}, null, null, null)">${message(code: 'my.upload.name')}${message(code: 'my.share.name')}</a>
                     --}%%{--    <a class="c_m_ca" href="" >创建活动</a>--}%%{--

                 </div>--}%

            <div class="c_m_quit">
                <a class="c_m_fat"
                   onclick="sentFurm();">${message(code: 'my.send.name')}${message(code: 'my.topic.name')}</a>
            </div>

        </div>
    </div>


    <div class="ou_space_content">
        <div class="communityMain_content_other wrap">
            <!----社区动态---------->
            <div class="communityMain_content_other_lefts">
                <g:layoutBody/>
            </div>
            <!----  结束--------->
            <!----------右测-------->
            <div class="communityMain_content_other_right  community_r_m">

                <div class="communityMain_butto">
                    <g:if test="${judeLoginConsumer(consumer: session?.consumer) == 'true'}">
                        <div class="ouknow_c_r">
                            %{--     <div class="ouknow_c_r_user">
                                     <img src="${generalUserPhotoUrl(consumer: session?.consumer)}" width="80"
                                          height="80"
                                          onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>

                                     <div class="ouknow_c_user_in">
                                         <p class="ouknow_c_user_name"><a href="#">${session?.consumer?.name}</a></p>

                                         <p class="ouknow_c_user_op"><span>发起(${sendTotal})</span><span>回应(${replyTotal})</span></p>
                                     </div>
                                 </div>--}%

                            <div class="oc_tit">
                                <h1>${message(code: 'my.joining.name')}<p class="ou_g_l">
                                    <span class="o_line" id="join_cla1">${message(code: 'my.activity.name')}</span>
                                    <span id="join_cla2">${message(code: 'my.group.name')}</span>
                                </p></h1>

                            </div>

                            <div id="group1" class="o_join_cla">
                                <g:each in="${myActivityList}" var="activity">
                                    <p class="oc_tit_list"><a href="javascript:void(0);"
                                                              onclick="checkActivity(${activity?.id}, ${activity?.studyCommunity?.id})">${activity.name}</a>
                                    </p>
                                </g:each>

                            </div>

                            <div style="display: none" class="o_join_cla" id="activity1">
                                <g:each in="${myBoradList}" var="board">
                                    <p class="oc_tit_list">
                                        <a href="javascript:void(0);"
                                           onclick="checkBoard(${board?.forumBoard.id}, ${board?.studyCommunity?.id})"
                                           title="${board?.forumBoard.name}">
                                            ${CTools.cutString(board?.forumBoard.name, 10)}
                                        </a>
                                    </p>
                                </g:each>
                            </div>

                        </div>
                    </g:if>

                    <div class="communityMain_add_member">
                        <h1>${message(code: 'my.community.name')}${message(code: 'my.active.name')}${message(code: 'my.members.name')}<a
                                href="${createLink(controller: 'my', action: 'myCreatedCommunity')}" class="community-mgr">管理社区</a></h1>

                        <p>
                            <g:each in="${hotMembers}" var="member">
                                <a class="com_p"
                                   href="${createLink(controller: 'my', action: 'userSpace', params: [id: member.id])}"><img
                                        src="${generalUserPhotoUrl2(consumerID: member.id)}"/>${member.nickname}</a>
                            </g:each>
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
</div>


<div id="createArticleDialog" style="display:none;">
    <g:form controller="community" action="save" name="createArticleForm" enctype="multipart/form-data"
            onsubmit="return checkStudy();">
        <div class="ui-dialog-content ui-widget-content">
            <table>
                <tr>
                    <td>${message(code: 'my.title.name')}:</td>
                    <td><input type="text" id="name" name="name"></td>
                </tr>
                <tr>
                    <td>${message(code: 'my.thumbnail.name')}:</td>
                    <td><input type="file" name="Img"></td>
                </tr>
                <tr>
                    <td>${message(code: 'my.introduction.name')}:</td>
                    <td><textarea name="description" id="description" cols="30" rows="5"></textarea></td>
                </tr>
            </table>

        </div>
    </g:form>
</div>
%{--<script type="text/javascript">
    $(function () {

        $("#createArticleDialog").dialog({title: "创建社区", autoOpen: false, width: 600, height: 380, buttons: {
            "提交": function () {
                $("#createArticleForm").submit();

            },
            "取消": function () {
                $("#createArticleDialog").dialog("close");
            }
        }});

        $("#saveArticle").click(function () {
            $("#createArticleDialog").dialog("open");
        })


    })

    function checkStudy() {
        var name = $("#name").val();
        var description = $("#description").val();
        if (name == "") {
            alert("请输入社区名称!");
            return false;
        }
        if (description == "") {
            alert("请对社区进行简单描述!");
            return false;
        }
    }
</script>
<input value="${params.max}" id="max" type="hidden">
<input value="6" id="offset" type="hidden">
<script type="text/javascript">
    $(function () {
        var communityLeft = $(".community_other_left_items");
        var communityGroup = $(".community_other_group_items");
        var communityPosts = $(".community_other_posts_items");
        var communityActivity = $(".community_other_activity_items");
        $("#groupId").css("border-bottom", "2px solid #4db652").css("color", "#4db652");
        $("#groupId").click(function () {
            $(this).css("border-bottom", "2px solid #4db652").css("color", "#4db652");
            $("#sharingId").css("border-bottom", "").css("color", "");
            $("#articleId").css("border-bottom", "").css("color", "");
            $("#activityId").css("border-bottom", "").css("color", "");
            communityGroup.show();
            communityLeft.hide();
            communityPosts.hide();
            communityActivity.hide();
        })
        $("#sharingId").click(function () {
            $(this).css("border-bottom", "2px solid #4db652").css("color", "#4db652");
            $("#groupId").css("border-bottom", "").css("color", "");
            $("#articleId").css("border-bottom", "").css("color", "");
            $("#activityId").css("border-bottom", "").css("color", "");
            communityGroup.hide();
            communityLeft.show();
            communityPosts.hide();
            communityActivity.hide();
        })
        $("#articleId").click(function () {
            $(this).css("border-bottom", "2px solid #4db652").css("color", "#4db652");
            $("#sharingId").css("border-bottom", "").css("color", "");
            $("#groupId").css("border-bottom", "").css("color", "");
            $("#activityId").css("border-bottom", "").css("color", "");
            communityGroup.hide();
            communityLeft.hide();
            communityPosts.show();
            communityActivity.hide();
        });
        $("#activityId").click(function () {
            $(this).css("border-bottom", "2px solid #4db652").css("color", "#4db652");
            $("#sharingId").css("border-bottom", "").css("color", "");
            $("#groupId").css("border-bottom", "").css("color", "");
            $("#articleId").css("border-bottom", "").css("color", "");
            communityGroup.hide();
            communityLeft.hide();
            communityPosts.hide();
            communityActivity.show();
        });
        var totalHeight = 0;
        var diffNum = 0;
        var footer = $(".boful_footer").height();
        var copyFoot = $(".foot_copyright").height();
        $(window).scroll(function () {
            var group = $(".community_other_group_items");
            var groupDiv = $(".community_other_group_items>div").length;
            var sharing = $(".community_other_left_items");
            var sharingDiv = $(".community_other_left_items>div").length;
            var article = $(".community_other_group_item_list");
            var articleDiv = $(".community_other_group_item_list>div").length;
            var activity = $(".community_other_activity_items");
            var activityDiv = $(".community_other_activity_items>div").length;
            var divTop = $(".community_other_group_items>div:eq(" + (groupDiv - 1) + ")").offset().top;
            var sTop = $(window).scrollTop();
            totalHeight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());
            if (sTop / divTop >= 0.7 && sTop / divTop < 0.8) {

                var url = "/community/autoLoading";
                var max = $("#max").val();
                var offset = $("#offset").val();
                var pars = {max: max, offset: offset};


                $.ajax({
                    url: url,
                    data: pars,
                    success: function (data) {
                        $("#max").val(data.max);
                        $("#offset").val(parseInt(data.offset) + 6);
                        if (groupDiv <= data.boardTotal) {
                            group.append(data.boardHtml);
                        }
                        if (sharingDiv <= data.sharingTotal) {
                            sharing.append(data.sharingHtml);
                        }
                        if (articleDiv <= data.acticleTotal) {
                            article.append(data.articleHtml);
                        }
                        if (activityDiv <= data.activityTotal) {
                            activity.append(data.activityHtml);
                        }

                    }
                })
            }
        })
    });

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

</script>--}%
<script type="text/javascript" language="JavaScript">

    function checkActivity(activityId, studyCommunityId) {
        var pars = {studyCommunityId: studyCommunityId};
        var url = baseUrl + "community/checkCommunityState";
        $.post(url, pars, function (data) {
            if (data.success) {
                window.location.href = "/community/communityActivityShow?id=" + activityId;
            } else {
                alert(data.msg);
            }

        });
    }

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


    function checkAuthority(type, communityId, sharingId, fileHash, fileType) {
        $.ajax({
            url: baseUrl + 'community/checkAuthority',
            data: "type=" + type + "&communityId=" + communityId,
            success: function (data) {
                if (data == 'true') {
                    if (type == 1) {
                        window.location.href = baseUrl + 'community/createSharing?communityId=' + communityId;
                    }
                    else {
                        window.location.href = baseUrl + 'community/downloadSharing?communityId=' + communityId + "&id=" + sharingId + '&fileHash=' + fileHash + '&fileType=' + fileType;
                    }
                }
                else {
                    if (type == 1) {
                        alert('对不起，您没有权限上传共享！');
                    }
                    else {
                        alert('对不起，您没有权限下载共享！');
                    }
                }
            }
        })

    }
</script>
<!---footer begin--->
<g:include view="layouts/indexFooter.gsp"/>
<!---footer end--->

</body>
</html>