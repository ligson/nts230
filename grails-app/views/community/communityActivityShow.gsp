<%@ page import="java.text.SimpleDateFormat; nts.utils.CTools" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>活动展示</title>
    <meta name="layout" content="index">
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_group.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_index.css')}">
    <ckeditor:resources/>
</head>

<body>
%{--<div class="wrap">
    <div class="commubity_share_nav">
        <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: studyCommunity?.id])}">社区首页</a><span>/</span>
        <a href="${createLink(controller: 'community', action: 'communityActivityIndex', params: [studyCommunityId: studyCommunity?.id])}">主题讨论</a><span>/</span>
        <a href="javascript:void(0)">${activity.name}</a>
    </div>
</div>--}%

<g:render template="communitySubHeader" model="${[studyCommunity: activity.studyCommunity]}"/>

<div class="community_act_content">
    <div class="community_group_content_left">
        <div class="community_group_release_box">
            <div class="com_release" style="width: 360px; float: left">
                <h1>${activity.name}</h1>

                <p class="com_release_time">
                    <span>${activity?.startTime}</span><a>-</a><span>${activity.endTime}</span>
                </p>

                <p class="com_release_content">${CTools.htmlToBlank(activity.description)}</p>
            </div>

            <div style="float: left; width: 260px; margin-left: 20px; height:160px;">
                <img src="${resource(dir: 'upload/communityImg/activity', file: activity.photo)}" width="260"
                     height="160"/>
            </div>

            %{--  <div class="user_release_box">
                  <label>
                      <textarea name="description" id="description">请输入内容</textarea>
                  </label>
                  <label>
                      <input class="user_release_but" type="submit" value="活动建议">
                  </label>
              </div>--}%
        </div>
        <!--------------建议列表----------->

        <div class="community_activity_proposal">
            <div class="com_g_t">
                <h3><span>${message(code: "my.subject.name")}${message(code: "my.reply.name")}</span></h3>
            </div>

            <div class="activity_proposal_items">
                <g:each in="${activitySubjectList}" var="subject">
                    <div class="activity_proposal_item">
                        <div class="activity_proposal_item_img">
                            <a href="${createLink(controller: 'my', action: 'userSpace', params: [id: subject?.createConsumer?.id])}">
                                <img src="${generalUserPhotoUrl(consumer: subject?.createConsumer)}"/>
                                %{--    <em class="p_name">${consumerName(id:subject?.createConsumer?.id)}</em>--}%
                            </a>
                        </div>

                        <div class="activity_proposal_item_infor">
                            <h1><a href="${createLink(controller: 'my', action: 'userSpace', params: [id: subject?.createConsumer?.id])}">${consumerName(id: subject?.createConsumer?.id)}</a>
                                <span>${new SimpleDateFormat('yyyy年MM月dd日').format(subject?.dateCreated)}</span></h1>

                            <p class="proposal_item_words">${subject?.description}</p>
                        </div>
                    </div>
                </g:each>
            </div>

            <div class="com_g_t">
                <h3><span>${message(code: 'my.activities.name')}${message(code: 'my.suggest.name')}</span></h3>
            </div>
            <g:form controller="community" action="saveActivitySubject" onsubmit="return checkValue()">
                <input type="hidden" name="id" value="${activity?.id}">

                <div class="user_release_b">
                    <div class="user_release_box">
                        <div>
                            <ckeditor:config var="toolbar_bar01">
                                [
                                  ['Bold','Italic','Underline','Strike'],
                                  ['Format'],
                                  ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
                                  ['Link','Unlink','Anchor'],
                                  ['Image','Flash','Table','Smiley','PageBreak']
                              ]
                            </ckeditor:config>
                            <ckeditor:editor name="description" id="description" height="400px" width="100%" toolbar="bar01">
                            </ckeditor:editor>
                        </div>
                        %{--<label>
                            <textarea name="description" id="description">请输入内容</textarea>
                        </label>--}%
                        <label>
                            <input class="user_release_but" type="submit" value="活动建议">
                        </label>
                    </div>
                </div>

            </g:form>
        </div>

    </div>


    <div class="community_group_content_right">
        %{-- <div class="jion_group_mine">
             <div class="jion_group_mine_img">
                 <img src="${generalUserPhotoUrl(consumer: session?.consumer)}" width="28" height="28"
                      onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"/>
             </div>

             <div class="jion_group_mine_other">
                 <h1 class="jion_group_name">${session?.consumer?.name}</h1>

                 <div>
                     <p>建议：<span>${activity?.activitySubject?.size()}</span></p>
                 </div>
             </div>
         </div>

         <div class="community_group_user_offer">
             <h1 class="crate_plate">活动信息</h1>

             <div class="community_group_user_offer_items">
                 <table>
                     <tbody>
                     <tr>
                         <td class="group_creat_user">所属社区:</td>
                         <td></td>
                     </tr>
                     <tr>
                         <td class="group_creat_user">创建人：</td>
                         <td>${activity?.createConsumer?.name}</td>
                     </tr>
                     <tr>
                         <td class="group_creat_user">标题：</td>
                         <td>${activity?.name}</td>
                     </tr>
                     <tr>
                         <td class="group_creat_user">
                             简介：
                         </td>
                         <td class="g_s">
                             <p>
                                 ${CTools.cutString(activity?.description, 40)}
                             </p></td>
                     </tr>
                     </tbody>
                 </table>
             </div>
         </div>--}%
        <!------------推荐小组------->
        <div class="community_group_user_plate">
            <h1 class="crate_plate">${message(code: 'my.recommend.name')}${message(code: 'my.activities.name')}</h1>

            <g:each in="${recommendActivity}" var="board">
                <div class="group_user_item">
                    <div class="community_group_user_plate_imgs">
                        %{--<img src="${resource(dir: 'upload/communityImg/forumboard', file: activity.photo)}" width="240"
                             height="100"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/images', file: 'boful_community_content_items_img.png')}'"/>--}%
                        <a href="javascript:void(0);"
                           onclick="checkActivity(${board?.id}, ${board.studyCommunity?.id})">
                            <img src="${resource(dir: 'upload/communityImg/activity', file: board.photo)}"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                        </a>
                    </div>

                    <div class="user_plate_infor">
                        <a href="javascript:void(0);"
                           onclick="checkActivity(${board?.id}, ${board.studyCommunity?.id})">
                            <h1>${CTools.cutString(board?.name, 8)}</h1>
                        </a>

                        <p class="user_plate_infor_des">${CTools.cutString(CTools.htmlToBlank(board?.description), 20)}</p>

                        <div class="user_plate_infor_number">
                            <p><span>${readActivityMemberCount(activity: board)}</span>人</p>

                            <p><a href="javascript:void(0);"
                                  onclick="checkActivity(${board?.id}, ${board.studyCommunity?.id})">${message(code: 'my.attend.name')}${message(code: 'my.talk.name')}</a>
                            </p>
                        </div>
                    </div>
                </div>
            </g:each>
        </div>
    </div>
</div>
<script type="text/javascript">
    function checkActivity(boardId, studyCommunityId) {
        var pars = {studyCommunityId: studyCommunityId};
        var url = baseUrl + "community/checkCommunityState";
        $.post(url, pars, function (data) {
            if (data.success) {
                window.location.href = "/community/communityActivityShow?id=" + boardId;
            } else {
                alert(data.msg);
            }

        });
    }

    function checkValue() {
        var isLogin = ${(session.consumer == null || session.consumer.name == 'anonymity') ? false : true };
        if (!isLogin) {
            alert("对不起，您还没有登陆！");
            return false;
        }
    }
    $(function () {
        var errmsg = '${flash.message}';
        if (errmsg.length > 0) {
            alert(errmsg);
        }

        $("#description").click(function () {
            $("#description").val("");
        })
    })
</script>
</body>
</html>