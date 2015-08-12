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


    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_coursesytyle.css')}">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'communityMgr_index.css')}">

</head>

<body>

<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">当前位置：社区主页</a>
</div>

<div class="tabs_nav">
    <ul>
        <li><a href="javascript:void(0)">我加入的社区</a></li>
    </ul>
</div>

<div class="container" style="margin:0; padding: 0;">

    <div class="sub-con" style="display:block;">

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
