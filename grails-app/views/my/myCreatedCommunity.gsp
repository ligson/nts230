<%@ page import="nts.user.domain.Consumer; nts.commity.domain.ForumMember; nts.utils.CTools; nts.commity.domain.StudyCommunity" %>
<html>
<head>
    %{--<meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>--}%
    <title>${message(code: 'my.mined.name')}${message(code: 'my.community.name')}</title>
    %{--<link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">--}%
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <script language="javaScript">
        function maxShow(max) {
            //调用setParams()对查询参数进行负值
            setParams();
            communityForm.max.value = max;
            communityForm.offset.value = 0;
            communityForm.action = "communityList";
            communityForm.submit();
        }
        function deleteCommunity(communityId) {
            if (confirm("确定删除该学习社区吗？")) {
                //setParams();
                communityForm.action = baseUrl + "my/deleteCommunity1?delId=" + communityId;
                communityForm.submit();
            }
        }
        function editCommunity(communityId) {
            communityForm.action = "edit?communityId=" + communityId;
            communityForm.submit();
        }
        function userList(communityId) {
            communityForm.action = "userList?communityId=" + communityId + "&listType=all";
            communityForm.submit();
        }
        function communitySearch() {
            communityForm.action = "myCreatedCommunity";
            communityForm.submit();
        }
        function setParams() {
            communityForm.name.value = "${params.name}";
            communityForm.state.value = "${params.state}";
        }

        function orderBy(sort) {
            //调用setParams()对查询参数进行负值
            setParams();
            communityForm.sort.value = sort;
            if (communityForm.order.value == "desc") {
                communityForm.order.value = "asc";
            }
            else {
                communityForm.order.value = "desc";
            }
            communityForm.action = "myCreatedCommunity";
            communityForm.submit();
        }
        function deleteCommunityList() {
            setParams();
            communityForm.action = "deleteCommunityList";
            communityForm.submit();
        }
        function communityExamine(communityId, state) {
            setParams();
            communityForm.action = baseUrl + "my/communityExamine?id=" + communityId + "&communityState=" + state;
            communityForm.submit();
        }
        function communityRecommend(communityId, isRecommend) {
            setParams();
            communityForm.action = baseUrl + "appMgr/communityRecommend?id=" + communityId + "&isRecommend=" + isRecommend;
            communityForm.submit();
        }
        //退出小组
        function leaveForum(forumMemberId, obj) {
            if (confirm("确定要退出吗")) {
                var prev = $(obj.parentNode).prevAll();
                for (var i = 0; i < prev.size(); i++) {
                    if (prev[i].innerText == "正常") {
                        $.post(baseUrl + "my/leaveForum", {forumMemberId: forumMemberId}, function (data) {
                            if (data.success) {
                                prev[i].innerText = "退出";
                                alert("退出成功！！！");
                            } else {
                                alert("数据错误，退出失败！！！");
                                window.location.reload();
                            }
                        })
                        break;
                    }
                }
            }
        }
        $(function(){
           // alert(${tstate})
            $("#stateSelect").val('${tstate}');
        })
    </script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <!--[if lte IE 6]>
<Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style-ie6.css')}" type=text/css rel=stylesheet>
<![endif]-->
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'dropdown.js')}"></script>
    %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/css', file: 'my_space.css')}">--}%
    %{--<link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_coursesytyle.css')}">--}%

</head>

<body>

<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.community.name')}${message(code: 'my.home.name')}</a>
</div>

<div class="tabs_nav">
    <ul>
        <li><a href="javascript:void(0)"
               class="cur">${message(code: 'my.mined.name')}${message(code: 'my.creat.name')}${message(code: 'my.community.name')}</a>
        </li>
        <li><a href="javascript:void(0)"
               class="cur">${message(code: 'my.joining.name')}${message(code: 'my.community.name')}</a></li>
        <li><a href="javascript:void(0)"
               class="cur">${message(code: 'my.joining.name')}${message(code: 'my.group.name')}</a></li>
    </ul>
</div>


<div class="container" style="margin:0; padding: 0; width: 756px;">
<div class="sub-con userspace_history cur-sub-con  t_f_bg">
    <form name="communityForm" method="post" action="">
        <input type="hidden" name="communityType" value="${params.communityType}">
        <input type="hidden" name="sort" value="${params.sort}">
        <input type="hidden" name="order" value="${params.order}">
        <input type="hidden" name="max" value="${params.max}">
        <input type="hidden" name="offset" value="${params.offset}">
        <g:set var="typeName"
               value="${['my': '我创建的主题列表', 'join': '我加入的主题列表', 'all': '所有主题列表', 'mgr': '社区管理']}"/>

        %{--<div class="space_line"></div>--}%
        <div class="t_m">
            <table>
                <tr>
                    <td style="width: 60px; text-align: right"><span>${message(code: 'my.community.name')}${message(code: 'my.designation.name')}:</span>
                    </td>
                    <td style="width: 180px; height: 34px">
                        <input type="text" style="width: 150px; height: 26px;" name="wyName" value="${twyName}"/>
                    </td>
                    <td style="width: 40px; text-align: right"><span>${message(code: 'my.state.name')}:</span></td>

                    <td style="width: 110px; text-align: left; height: 34px">
                        <select class="" style="width: 100px" name="state" id="stateSelect">
                        <option value="">--请选择--</option>
                        <option value="1">已通过</option>
                        <option value="2">审核中</option>

                    </select></td>
                    <td style="width: 120px; text-align: left"><input name="search" type="button"
                                                                      class="admin_default_but_green"
                                                                      onClick="communitySearch()"
                                                                      value="查询"/></td>
                    <td style="width: 220px; text-align: right">
                        <g:if test="${Consumer.findByName(session.consumer.name)?.uploadState==1}">
                            <a class="admin_default_but_green"
                               href="${createLink(controller: 'community', action: 'create')}">${message(code: 'my.creat.name')}${message(code: 'my.community.name')}</a>
                        </g:if>
                        <div>

                        </div>
                    </td>

                </tr>
            </table>
        </div>
        <table class="table table-striped">
            <thead>
            <tr align="left" valign="top" class="t_bg">
                <th width="40" align="center" valign="middle">${message(code: 'my.chose.name')}</th>
                <th align="center" valign="left"><a href="#" onClick="orderBy('name');
                return false;">${message(code: 'my.community.name')}${message(code: 'my.designation.name')}</a>
                </th>
                <th width="70" align="center" valign="middle"><a href="#"
                                                                 onClick="orderBy('communityCategory');
                                                                 return false;">${message(code: 'my.community.name')}${message(code: 'my.class.name')}</a>
                </th>
                <th width="70" align="center" valign="middle">
                    <a href="#" onClick="orderBy('dateCreated');
                    return false;">${message(code: 'my.creat.name')}${message(code: 'my.time.name')}</a>
                </th>
                <th width="60" align="center" valign="middle">
                    <a href="#" onClick="orderBy('create_comsumer_id');
                    return false;">${message(code: 'my.creator.name')}</a>
                </th>
                <th width="65" align="center" valign="middle">
                    <a href="#">${message(code: 'my.members.name')}${message(code: 'my.number.name')}</a></th>
                <th width="60" align="center" valign="middle">
                    <a href="#" onClick="orderBy('state');
                    return false;">${message(code: 'my.state.name')}</a>
                </th>
                <th width="70" align="center" valign="middle">
                    <a href="#" onClick="orderBy('isRecommend');
                    return false;">${message(code: 'my.recommend.name')}${message(code: 'my.state.name')}</a>
                </th>
                <th width="60" align="center" valign="middle">${message(code: 'my.operation.name')}</th>
            </tr>
            </thead>
            <g:each in="${communityList}" status="i" var="community">
                <tr>
                    <td><g:checkBox name="idList" value="${community.id}" checked=""
                                    onclick="unCheckAll('selall');"/></td>
                    <td valign="middle" align="left">&nbsp;&nbsp;
                        <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: community.id])}">${community?.name}</a>
                    </td>
                    <td valign="middle">${community.communityCategory?.name}</td>
                    <td valign="middle" style="width:100px"><g:formatDate format="yyyy-MM-dd"
                                                                          date="${community.dateCreated}"/></td>
                    <td valign="middle">${nameList[i]}</td>
                    <td valign="middle">${readStudyCommunityMembersCount(studyCommunity: community)}</td>
                    <td valign="middle">${community.state == 0 ? "已禁用" : community.state == 1 ? "已通过" : community.state == 2 ? "审核中" : "审核中"}</td>
                    <td valign="middle">${community.isRecommend ? "已推荐" : "未推荐"}</td>
                    <td valign="middle" style="padding-left: 30px;">
                        <g:if test="${community.state == 0}">
                            禁用
                        </g:if>
                        <g:else>
                        <div class="btn-group">
                            <button type="button" class="btn btn-default dropdown-toggle"
                                    style="font-size: 12px; padding: 3px 6px;" data-toggle="dropdown">
                                ${message(code: 'my.operation.name')}<span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu" role="menu">
                                <li><a href="${createLink(controller: 'community', action: 'communityEdit', params: [communityId: community.id])}">${message(code: 'my.amend.name')}</a>
                                </li>
                                <li><a href="#"
                                       onClick="deleteCommunity(${community.id})">${message(code: 'my.delete.name')}</a>
                                </li>
                                %{--
                                <g:if test="${community.state == 1}">
                                    <li><a href="#" onClick="communityExamine(${community.id}, 0)">禁用</a>
                                    </li>
                                </g:if>
                                <g:else>
                                    <li><a href="#" onClick="communityExamine(${community.id}, 1)">通过</a>
                                    </li>
                                </g:else>
                                --}%
                                %{--申请中--}%
                                %{--<g:if test="${community.state!=1&&community.state!=3}">
                                    <li><a href="#"
                                           onClick="communityExamine(${community.id}, 3)">${message(code: 'my.apply.name')}</a>
                                    </li>
                                </g:if>--}%
                                <li><a href="${createLink(controller: 'communityMgr', action: 'forumBoradList', params: [studyCommunityId: community.id])}">${message(code: 'my.community.name')}${message(code: 'my.manage.name')}</a>
                                </li>
                            </ul>
                        </div>
                        </g:else>
                    </td>
                </tr>
            </g:each>
        </table>

        <table width="100%" style="margin:5px 0 5px 0;" border="0" cellspacing="0" cellpadding="0">
            <tr><td align="left" width="100%"></td></tr>
            <tr><td align="left">

                <a href="#" class="btn btn-default" style="font-size: 12px;" id="sel"
                   onclick="checkboxAll('idList')">全选</a>
                &nbsp;
                <a href="#" class="btn btn-default" style="font-size: 12px;" id="sel2"
                   onclick="unCheckboxAll('idList')">取消全选</a>
                &nbsp;
                <input class="btn btn-default" type="button" value="删除所选"
                       onClick="deleteCommunityList()"/>  &nbsp; <a href="#" class="btn btn-default"
                                                                    style="font-size: 12px;"
                                                                    onclick="">批量申请</a></td>
            </tr>
        </table>

    </form>
</div>

<div class="sub-con t_f_bg">
    <table class="table table-hover mine_g">
        <tbody>
        <tr class="t_bg">
            <th width="70">社区头像</th>
            <th>社区名称</th>
            <th width="80">成员数量</th>
            <th width="150">操作</th>
        </tr>
        <g:each in="${joinCommunity}" var="community">
            <tr>
                <td class="mine_grupe_list">
                    <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: community.id])}">
                        <img width="28" height="28"
                             src="${generalCommunityPhotoUrl(community: community)}"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                    </a>
                </td>
                <td>
                    <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: community.id])}">${community?.name}</a>
                </td>
                <td>
                    <span>${readStudyCommunityMembersCount(studyCommunity: community)}个</span>
                </td>
                <td>
                    <input value="取消加入" class="btn btn-warning btn-xs" type="button"
                           onclick="removeConsumer(${community?.id})">
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<div class="sub-con t_f_bg">
    <table class="table table-hover mine_g">
        <tbody>
        <tr class="t_bg">
            <th width="70">小组头像</th>
            <th>小组名称</th>
            <th width="100">所在社区</th>
            <th width="80">状态</th>
            <th width="80">成员数量</th>
            <th width="80">话题数量</th>
            <th width="150">操作</th>
        </tr>
        <g:each in="${forumMemberList}" var="forumMember">
            <tr>
                <td class="mine_grupe_list">
                    <a href="${createLink(controller: 'community', action: 'communityGroupIndex', params: [id: forumMember?.forumBoard?.id])}">
                        <img width="28" height="28"
                             src="${resource(dir: 'upload/communityImg/forumboard', file: forumMember?.forumBoard?.photo)}"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                    </a>
                </td>
                <td class="mine_grupe_name">
                    <a href="${createLink(controller: 'community', action: 'communityGroupIndex', params: [id: forumMember?.forumBoard?.id])}">${CTools.cutString(forumMember?.forumBoard?.name, 10)}</a>
                </td>
                <td>
                    <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: forumMember?.studyCommunity?.id])}">${CTools.cutString(forumMember?.studyCommunity?.name, 15)}</a>
                </td>
                <td>
                    <span>${ForumMember.stateCn[forumMember.state]}</span>
                </td>
                <td>
                    <span>${forumBoardMemberMap[forumMember?.id]}人</span>
                </td>
                <td>
                    <span>${forumMember?.forumBoard?.forumMainArticle?.size()}个</span>
                </td>
                <td>
                    <g:if test="${forumMember.forumBoard.createConsumer.id == session?.consumer.id}">
                        <a href="${createLink(controller: 'communityMgr', action: 'forumBoradList', params: [studyCommunityId: forumMember?.studyCommunity?.id])}"
                           class="btn btn-warning  btn-xs">小组管理</a>
                    </g:if>
                    <a onclick="deleteMember(${forumMember?.forumBoard?.id})" class="btn btn-warning  btn-xs">退出小组</a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>
<g:paginate total="${total}" controller="my" action="myCreatedCommunity"/>
</div>


<script type="text/javascript">
    function removeConsumer(tag) {
        var pars = {id: tag};
        var url = baseUrl + "my/removeConsumer";
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
        })
    }

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
                    }
                    else {
                        alert(data.message);
                        window.location.reload();
                    }
                }
            });

        }
    }

    $(document).ready(function () {
        var intervalID;
        var curLi;
        var tabNav = $(".tabs_nav li a");
        tabNav.mouseover(function () {
            curLi = $(this);
//鼠标移入的时候有一定的延时才会切换到所在项，防止用户不经意的操作
            intervalID = setInterval(onMouseOver, 250);
        });
        function onMouseOver() {
            $(".cur-sub-con").removeClass("cur-sub-con");
            $(".sub-con").eq(tabNav.index(curLi)).addClass("cur-sub-con");
            $(".cur").removeClass("cur");
            curLi.addClass("cur");
        }

        tabNav.mouseout(function () {
            clearInterval(intervalID);
        });

//鼠标点击也可以切换
        tabNav.click(function () {
            clearInterval(intervalID);
            $(".cur-sub-con").removeClass("cur-sub-con");
            $(".sub-con").eq(tabNav.index(curLi)).addClass("cur-sub-con");
            $(".cur").removeClass("cur");
            curLi.addClass("cur");
        });
    });
</script>

</body>
</html>
