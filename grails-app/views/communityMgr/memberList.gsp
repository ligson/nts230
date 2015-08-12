<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-3-15
  Time: 下午1:26
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>成员列表</title>
    <script type="text/javascript">
        //单个成员踢出
        function deleteMember(forumMemberId, studyCommunityId) {
            if (confirm("您确定要踢出他吗？")) {
                $.post(baseUrl + "communityMgr/deleteMember", {
                    forumMemberIds: forumMemberId,
                    studyCommunityId: studyCommunityId
                }, function (data) {
                    if (data.deleteSuccess) {
                        $("#tr" + forumMemberId).remove();
                        alert(data.msg);
                    } else {
                        alert(data.msg);
                    }
                })
            }
        }
        //成员批量踢出
        function deleteMeberList(studyCommunityId) {
            if (confirm("您确定要踢出他吗？")) {
                var checkboxList = $("input:checked");
                if (checkboxList.size() == 0) {
                    alert("请选择！！");
                    return false;
                }
                var forumMemberIds = "";
                for (var i = 0; i < checkboxList.size(); i++) {
                    var forumMemberId = checkboxList[i].value;
                    forumMemberIds += forumMemberId;
                    if (i != checkboxList.size() - 1) {
                        forumMemberIds += ",";
                    }
                }
                $.post(baseUrl + "communityMgr/deleteMember", {
                    forumMemberIds: forumMemberIds,
                    studyCommunityId: studyCommunityId
                }, function (data) {
                    if (data.deleteSuccess) {
                        var ids = forumMemberIds.split(",");
                        for (var i = 0; i < ids.length; i++) {
                            $("#tr" + ids[i]).remove();
                        }
                        alert(data.msg);
                    } else {
                        alert(data.msg);
                    }
                })
            }
        }
        function sub_id(str){
            return str.substr(str.indexOf('_')+1)
        }
        function sub_name(str){
            return str.substr(0,str.indexOf('_'))
        }
        $(document).ready(function () {
            //a标签点击事件
            $("tbody tr td a").bind("click", function () {
                var tmpThis = this;
                var name=$(this).attr("name");
                var id=sub_id(name)
//                var attrName = tmpThis.name;
                var attrName = sub_name(name);
//                var forumMemberId = tmpThis.parentNode.parentNode.children[0].value;
                var forumMemberId = $("#forumMemberId_"+id).val();
                //alert(forumMemberId)
                var studyCommunityId = $("#studyCommunityId").val();
                $.post(baseUrl + "community/changeForumMemberAttr", {
                    attrName: attrName,
                    forumMemberId: forumMemberId,
                    studyCommunityId: studyCommunityId
                }, function (data) {
                    if (data.success) {
                        tmpThis.innerHTML = data.forumMemberAttr;
                    } else {
                        alert("参数错误！！");
                    }
                })
            })
            //select下拉点击事件
            $("tbody tr td select").bind("change", function () {
//                var selectedObj = $(this.selectedOptions);
                var selectedObj = $(this).find("option:selected").val();
                var state_memberId = selectedObj.split("_");
                var state = state_memberId[0];
                var memberId = state_memberId[1];
                var studyCommunityId = $("#studyCommunityId").val();
                $.post(baseUrl + "community/changeForumMemberAttr", {
                    state: state,
                    forumMemberId: memberId,
                    studyCommunityId: studyCommunityId,
                    attrName: "state"
                }, function (data) {
                    if (!data.success) {
                        alert("参数错误！！");
                        window.location.reload();
                    }
                })
            })
        })

    </script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>

    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'dropdown.js')}"></script>
</head>

<body>
<g:form action="membersList" controller="communityMgr">
    <input id="studyCommunityId" type="hidden" name="studyCommunityId" value="${studyCommunity.id}"/>

    <div class="userspace_title" style="margin-bottom: 20px;">
        <a href="">${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.members.name')}${message(code: 'my.list.name')}</a>
    </div>

    <div>
        ${message(code: 'my.members.name')}:
        <input type="text" style="width: 150px; height: 26px;" name="memberName" id="memberName" value="${memberName}"/>
        <input name="search" type="submit" class="admin_default_but_green" value="查询"/>

    </div>
    <table class="table table-striped">
        <thead>
        <tr>
            <th width="40" align="center">${message(code: 'my.chose.name')}</th>
            <th>${message(code: 'my.members.name')}</th>
            <th>${message(code: 'my.group.name')}</th>
            %{--  <th>所属社区</th>--}%
            <th>${message(code: 'my.master.name')}</th>
            <th width="45" align="center">${message(code: 'my.download.name')}</th>
            <th width="45" align="center">${message(code: 'my.upload.name')}</th>
            <th width="45" align="center">${message(code: 'my.Posting.name')}</th>
            <th width="45" align="center">${message(code: 'my.Return.name')}</th>
            <th width="45" align="center">${message(code: 'my.review.name')}</th>
            <th width="45" align="center">${message(code: 'my.play.name')}</th>
            <th width="90" align="center">${message(code: 'my.attending.name')}${message(code: 'my.time.name')}</th>
            %{--  <th style="width:40px; text-align: center">操作</th>--}%
            <th>${message(code: 'my.state.name')}</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${forumMember}" var="member" status="i">
            <tr id="tr${member?.id}">
                <input type="hidden" name="forumMemberId_${member?.id}" id="forumMemberId_${member?.id}"
                       value="${member?.id}"/>
                <td>
                    <g:checkBox name="memberId" value="${member?.id}" checked="false"></g:checkBox>
                </td>
                <td>${member?.consumer?.name}</td>
                <td>${member?.forumBoard?.name}</td>
                %{--  <td>${member?.studyCommunity?.name}</td>--}%
                <td>${member?.forumBoard?.createConsumer.name}</td>
                <td>
                    <g:if test="${member?.canDownload}">
                        <a name="canDownload_${member.id}" class="btn  btn-success btn-xs">是</a>
                    </g:if><g:else>
                    <a name="canDownload_${member.id}" class="btn  btn-success btn-xs">否</a>
                </g:else>
                    <input type="hidden" name="canDownload" value="${member?.canDownload}"/>
                </td>
                <td>
                    <g:if test="${member?.canUpload}">

                        <a name="canUpload_${member.id}" class="btn  btn-success btn-xs">是</a>
                    </g:if><g:else>
                    <a name="canUpload_${member.id}" class="btn  btn-success btn-xs">否</a>
                </g:else>
                </td>
                <td>
                    <g:if test="${member?.canCreateArticle}">

                        <a name="canCreateArticle_${member.id}" class="btn  btn-success btn-xs">是</a>
                    </g:if><g:else>
                    <a name="canCreateArticle_${member.id}" class="btn  btn-success btn-xs">否</a>
                </g:else>
                </td>
                <td>
                    <g:if test="${member?.canReply}">

                        <a name="canReply_${member.id}" class="btn  btn-success btn-xs">是</a>
                    </g:if><g:else>
                    <a name="canReply_${member.id}" class="btn  btn-success btn-xs">否</a>
                </g:else>
                </td>
                <td>
                    <g:if test="${member?.canComment}">

                        <a name="canComment_${member.id}" class="btn  btn-success btn-xs">是</a>
                    </g:if><g:else>
                    <a name="canComment_${member.id}" class="btn  btn-success btn-xs">否</a>
                </g:else>
                </td>
                <td>
                    <g:if test="${member?.canPlay}">

                        <a name="canPlay_${member.id}" class="btn  btn-success btn-xs">是</a>
                    </g:if><g:else>
                    <a name="canPlay_${member.id}" class="btn  btn-success btn-xs">否</a>
                </g:else>
                </td>
                <td><g:formatDate date="${member?.joinDate}" format="yyyy-MM-dd"></g:formatDate></td>
                <td>
                    <select>
                        <g:each in="${nts.commity.domain.ForumMember.stateCn}" var="state">
                            <option value="${state.key + '_' + member.id}" ${(state.key == member?.state) ? "selected='selected'" : ""}>${state.value}</option>
                        </g:each>
                    </select>
                </td>

                %{--   <td>
                       <div class="admin_recommend">
                           <div class="btn-group rec_mr">
                               <button type="button" class="btn  btn-default  dropdown-toggle rec_wid"
                                       style="font-size: 12px; padding: 5px 10px;" data-toggle="dropdown">
                                   审批操作<span class="caret" style="margin-left:5px"></span>
                               </button>
                               <ul class="dropdown-menu" role="menu">
                                   <li>
                                       <a href="javascript:void(0);" class="rec_mr_inp"
                                       --}%%{-- onclick=" operate('programMgr', 'programStateSet', 'pass');"--}%%{--/>同意</a>
                                   </li>
                                   <li>
                                       <a href="javascript:void(0);" class="rec_mr_inp res_dieer"
                                          onclick="operate('programMgr', 'programStateSet', 'noPass');">锁定</a></li>
                                   <li>
                                       <a href="javascript:void(0);" class="rec_mr_inp"
                                          onclick="operate('programMgr', 'programStateSet', 'public');">删除</a>
                                   </li>

                               </ul>
                           </div>
                       </div>
                       --}%%{-- <input type="button" class="btn btn-link" onclick="deleteMember(${member?.id}, ${studyCommunity.id})"  value="踢出"/>--}%%{--
                   </td>--}%
            </tr>
        </g:each>

        </tbody>

    </table>

    <!------------权限操作-------------->
%{--<div class="">
    <div class="admin_recommend">
        <div class="btn-group rec_mr">
            <button type="button" class="btn  btn-default  dropdown-toggle rec_wid"
                    style="font-size: 12px; padding: 5px 10px;" data-toggle="dropdown">
                成员权限设置<span class="caret" style="margin-left:5px"></span>
            </button>
            <ul class="dropdown-menu" role="menu">
                <li>
                    <a href="javascript:void(0);" class="rec_mr_inp"
                       onclick=" operate('programMgr', 'programStateSet', 'pass');"/>审批通过</a>
                </li>
                <li>
                    <a href="javascript:void(0);" class="rec_mr_inp res_dieer"
                       onclick="operate('programMgr', 'programStateSet', 'noPass');">审批退回</a></li>
                <li>
                    <a href="javascript:void(0);" class="rec_mr_inp"
                       onclick="operate('programMgr', 'programStateSet', 'public');">发布</a>
                </li>

                <li>
                    <a href="javascript:void(0);" class="rec_mr_inp res_dieer"
                       onclick="operate('programMgr', 'programStateSet', 'close');">取消发布</a></li>
                <li>
                    <a href="javascript:void(0);" class="rec_mr_inp"
                       onclick="changePublics('programMgr', 'changePublicStata', 'changePublic');">公开</a>
                </li>
                <li>
                    <a href="javascript:void(0);" class="rec_mr_inp"
                       onclick="changePublics('programMgr', 'changePublicStata', 'changeNotPublic');">不公开</a>
                </li>

            </ul>
        </div>
    </div>
</div>--}%
    <!------------权限操作结束-------------->
    <g:if test="${forumMember.size() >= 2}">
        <input type="button" class="btn btn-default" onclick="deleteMeberList(${studyCommunity.id})" value="批量踢出">
    </g:if>
    <div class="page">
        <g:guiPaginate controller="communityMgr" action="membersList" total="${total}"
                       params="${[studyCommunityId: studyCommunity?.id]}"/></div>
</g:form>
</body>
</html>