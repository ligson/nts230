<%@ page import="nts.utils.CTools; nts.commity.domain.StudyCommunity" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <title>社区管理</title>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
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
            communityForm.action = "communityList";
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
            communityForm.action = "communityList";
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
    </script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'dropdown.js')}"></script>

    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_userspace_index.css')}">
    %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/css', file: 'my_space.css')}">--}%


    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_coursesytyle.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'communityMgr_index.css')}">

</head>

<body>

<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">当前位置：社区主页</a>
</div>

<div class="tabs_nav">
    <ul>
        <li><a href="javascript:void(0)" class="cur">我创建的社区</a></li>
        <li><a href="javascript:void(0)">我加入的社区</a></li>
    </ul>
</div>
<table>
    <tr>
        <td style="width: 60px; text-align: right"><span>主题名称:</span></td>
        <td><input type="text" class="form-control space_inputsty" name="name" value=""/></td>
        <td style="width: 40px; text-align: right"><span>状态:</span></td>
        <td style="width: 160px; text-align: right"><select class="form-control space_selectsty" name="state">
            <option value="">--请选择--</option>
            <option value="1">已通过</option>
            <option value="2">未通过</option>

        </select></td>
        <td style="width: 120px; text-align: right"><input name="search" type="button"
                                                           class="btn btn-primary btn-sm space_buttop"
                                                           onClick="communitySearch()"
                                                           value="查询"/></td>
        <td style="width: 220px; text-align: right"><a class="btn btn-primary btn-sm space_buttop"
                                                       href="${createLink(controller: 'community', action: 'create')}">创建社区</a>
        </td>

    </tr>
</table>

<div class="container" style="margin:0; padding: 0;">
    <div class="sub-con userspace_history cur-sub-con">
        <form name="communityForm" method="post" action="">
            <input type="hidden" name="communityType" value="${params.communityType}">
            <input type="hidden" name="sort" value="${params.sort}">
            <input type="hidden" name="order" value="${params.order}">
            <input type="hidden" name="max" value="${params.max}">
            <input type="hidden" name="offset" value="${params.offset}">
            <g:set var="typeName"
                   value="${['my': '我创建的主题列表', 'join': '我加入的主题列表', 'all': '所有主题列表', 'mgr': '社区管理']}"/>

            %{--<div class="space_line"></div>--}%
            <table class="table table-striped">
                <thead>
                <tr align="left" valign="top">
                    <td width="40" align="center" valign="middle">选择</td>
                    <td align="center" valign="middle"><a href="#" onClick="orderBy('name');
                    return false;">社区名称</a>
                    </td>
                    <td width="55" align="center" valign="middle"><a href="#"
                                                                     onClick="orderBy('communityCategory?.name');
                                                                     return false;">社区类别</a>
                    </td>
                    <td width="50" align="center" valign="middle">
                        <a href="#" onClick="orderBy('dateCreated');
                        return false;">创建时间</a>
                    </td>
                    <td width="50" align="center" valign="middle">
                        <a href="#" onClick="orderBy('create_comsumer_id');
                        return false;">创建者</a>
                    </td>
                    <td width="65" align="center" valign="middle">
                        <a href="#">成员人数</a></td>
                    <td width="60" align="center" valign="middle">
                        <a href="#" onClick="orderBy('state');
                        return false;">状态</a>
                    </td>
                    <td width="70" align="center" valign="middle">
                        <a href="#" onClick="orderBy('isRecommend');
                        return false;">推荐状态</a>
                    </td>
                    <td width="60" align="center" valign="middle">操作</td>
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
                        <td valign="middle"><g:formatDate format="yyyy-MM-dd"
                                                          date="${community.dateCreated}"/></td>
                        <td valign="middle">${nameList[i]}</td>
                        <td valign="middle">${community.members.size()}</td>
                        <td valign="middle">${community.state == 0 ? "已禁用" : community.state == 1 ? "已通过" : "审核中"}</td>
                        <td valign="middle">${community.isRecommend ? "已推荐" : "未推荐"}</td>
                        <td valign="middle" style="padding-left: 30px">

                            <div class="btn-group">
                                <button type="button" class="btn btn-default dropdown-toggle"
                                        style="font-size: 12px; padding: 3px 6px;" data-toggle="dropdown">
                                    操作<span class="caret"></span>
                                </button>
                                <ul class="dropdown-menu" role="menu">
                                    <li><a href="#" onClick="deleteCommunity(${community.id})">删除</a></li>
                                    <g:if test="${community.state == 1}">
                                        <li><a href="#" onClick="communityExamine(${community.id}, 0)">禁用</a>
                                        </li>
                                    </g:if>
                                    <g:else>
                                        <li><a href="#" onClick="communityExamine(${community.id}, 1)">通过</a>
                                        </li>
                                    </g:else>
                                    <li><a href="#" onClick="communityExamine(${community.id}, 1)">申请</a></li>
                                    <li><a href="${createLink(controller: 'communityMgr', action: 'forumBoradList', params: [studyCommunityId: community.id])}">社区管理</a>
                                    </li>

                                </ul>
                            </div>

                        </td>
                    </tr>
                </g:each>
            </table>

            <table width="100%" style="margin:5px 0 5px 0;" border="0" cellspacing="0" cellpadding="0">
                <tr><td align="left" width="100%"></td></tr>
                <tr><td align="left">

                    <a href="#" class="btn btn-default" style="font-size: 12px;" id="sel"
                       onclick="checkAll(this, 'idList')">全选</a>
                    &nbsp;
                    <input class="btn btn-default" type="button" value="删除所选"
                           onClick="deleteCommunityList()"/>  &nbsp; <a href="#" class="btn btn-default"
                                                                        style="font-size: 12px;"
                                                                        onclick="">批量申请</a></td>
                </tr>
            </table>

        </form>
    </div>

    <div class="sub-con">

        <g:each in="${joinCommunity}" var="community">
            <div class="ouknow_forum_right_item">
                <div class="ouknow_forum_icon"><a
                        href="${createLink(controller: 'community', action: 'communityIndex', params: [id: community.id])}">
                    <img src="${resource(dir: 'upload/communityImg', file: community.photo)}" width="100" height="100"
                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                </a></div>

                <div class="ouknow_forum_plate_cont">
                    <h2 class="ouknow_forum_plate_cont_tt"><a
                            href="${createLink(controller: 'community', action: 'communityIndex', params: [id: community.id])}">${CTools.cutString(community?.name, 7)}</a>
                    </h2>

                    <div class="ouknow_forum_plate_cont_des">${CTools.cutString(CTools.htmlToBlank(community?.description), 7)}</div>

                    <div class="ouknow_forum_plate_bot">
                        <p class="ouknow_forum_plate_post">人员：<span>${community?.members.size()}</span></p>

                        <p class="ouknow_forum_plate_post_back"><a onclick="removeConsumer(${community?.id})">取消加入</a>
                        </p>
                    </div>
                </div>
            </div>
        </g:each>

    </div>
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
