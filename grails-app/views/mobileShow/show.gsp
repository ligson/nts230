<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>activity</title>
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0"/>
    <link rel="stylesheet" media="all" href="${resource(dir: '/mobileShow/css', file: 'lpstyle.css')}" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'mobile/js/jquery-1.9.1.min.js')}"></script>

    <script>

        var isAnony = ${(session.consumer == null || session.consumer.name == 'anonymity')?"true":"false"};//是否匿名用户

        function vote(userWorkId, consumerId) {
            if (isAnony) {
                alert("匿名用户不能投票，请先登录！");
                return;
            }
            if (consumerId == ${session.consumer.id}) {
                alert("用户不能给自己的作品投票！");
                //return;
            }
            window.location.href = baseUrl + "mobileShow/vote?userWorkId=" + userWorkId;
        }

        function init() {
            var voteState = '${flash.voteState}';
            if (voteState == '0') {
                alert("投票失败");
            }
            else if (voteState == '1') {
                alert("投票成功");
            }
            else if (voteState == '2') {
                alert("你已对该作品投过票了！");
            }
        }

        function createWork(activityId) {
            try {
                window.JSInterface.uploadActivityId(activityId);
            } catch (e) {
            }
        }

    </script>
</head>

<body>
<div class="wrap">
    <header>
        <div class="options">
            <ul>
				<li id="f-menu" class="f_menu">活动分类<span></span></li>
				<li id="f-serch" class="f_serch" style="float:right"><span>搜索</span></li>
			  </ul>
        </div>

        <div class="clear"></div>

        <div class="search-box">
            <form method="POST" action="/mobileShow/categoryView">
                <input type="hidden" name="directoryId" value="${params.directoryId}">
                <input type="text" name="keyword" placeholder="输入搜索内容……"/>
                <input type="submit" value="Go"/>
            </form>

            <div class="clear"></div>
        </div>
        <nav class="vertical menu">
            <ul>
                <g:each in="${rmsCategoryList}" status="i" var="rmsCategory">
                    <li><a href="${createLink(controller: 'mobileShow', action: 'categoryView', params: [directoryId: rmsCategory.id])}</a>
                    </li>
                </g:each>
            </ul>
        </nav>
    </header>

    <div class="content">
        <article>
            <h1>${userActivity?.name}</h1>

            <div style="text-align:center;"><img src="${resource(dir: 'upload/userActivityImg', file: userActivity.photo)}"
                                                 alt=""/></div>

            <div class="lpms"><span>创建者：${userActivity.consumer.name}</span> <span>类别：${userActivity.activityCategory.name}</span> <span>作品数：0</span><br> <span>时间：${userActivity.startTime}至${userActivity.endTime}</span><br/>
                <a href="javascript:void(0);" onclick="createWork(${userActivity.id})">我要参与</a>
            </div>

            <div class="select_tab">
                <ul>
                    <li id="select_a">参与作品</li>
                    <li id="select_b">描述</li>
                </ul>

                <div id="nva" class="vertical p_list">
                    <g:each in="${userWorkList}" status="i" var="userWork">
                        <div class="hdzp-preview"><a href="${createLink(controller: 'mobileShow', action: 'workShow', params: [id: userWork.id])}"><img
                                src="${workImgLink(userWork: userWork, isAbbrImg: true)}"/></a>
                            <span class="${params.offset.toInteger() < 1 && i < 3 ? 'back' + (i + 1) : ''}"></span>

                            <div class="tpiao"><a href="javascript:void(0);"
                                                  onclick="vote(${userWork.id}, ${userWork.consumer.id})"><img
                                        src="images/bt01.gif"/></a></div>

                            <p><a href="${createLink(controller: 'mobileShow', action: 'workShow', params: [id: userWork.id])}">${CTools.cutString(fieldValue(bean: userWork, field: 'name'), 8)}</a>
                                票数：${userWork.voteNum}<br>
                                作者：${userWork.consumer.name}<br>
                                时间：<g:formatDate format="yyyy-MM-dd" date="${userWork?.dateCreated}"/></p>
                        </div>
                    </g:each>

                    <div class="page">
                        <g:if test="${CTools.nullToZero(params.offset) > 0 && total > 0}">
                            <a class="thoughtbot"
                               href="${createLink(controller: 'mobileShow', action: 'show', params: [args: args, offset: (CTools.nullToZero(params.offset) - CTools.nullToZero(params.max))])}">上一页</a>
                        </g:if>
                        <g:if test="${(CTools.nullToZero(params.offset)+ CTools.nullToZero(params.max)) < total && userWorkList.size() >= CTools.nullToZero(params.max)}">
                            <a class="thoughtbot"
                               href="${createLink(controller: 'mobileShow', action: 'show', params: [args: args, offset:(CTools.nullToZero(params.offset) + CTools.nullToZero(params.max))])}">下一页</a>
                        </g:if>

                    </div>

                </div>

                <div id="nvb" class="vertical comments">
                    <p style=" line-height:28px; padding-top:10px; display:block;">${CTools.htmlToBlank(userActivity.description)}&nbsp;</p>
                </div>

            </div>
        </article>
    </div>
    <footer>
        <p><g:message code="application.copyright"
                      default="Copyright @ 2007-2013 ALL Rights Reserved By 北京邦丰信息技术有限公司"/></p>
    </footer>
</div>

<script type="text/javascript">
    window.addEventListener("load", function () {
        // Set a timeout...
        setTimeout(function () {
            // Hide the address bar!
            window.scrollTo(1, 2);
        }, 1);
    });
    $('.search-box,.menu,#nvb').hide();
    $('.select_tab #select_a').addClass('active');
    $('#f-serch').click(function () {
        $(this).toggleClass('active');
        $('.search-box').toggle();
        $('.menu').hide();
        $('.options #f-serch:first-child').removeClass('active');
    });
    $('#f-menu').click(function () {
        $(this).toggleClass('active');
        $('.menu').toggle();
        $('.search-box').hide();
        $('.options #f-menu:first-child').removeClass('active');
    });
    $('#select_a').click(function () {
        $(this).toggleClass('active');
        $('#nva').toggle();
        $('#nvb').hide();
        //$('#select_b:first-child').removeClass('active');
        $('.select_tab #select_b').removeClass('active');
    });
    $('#select_b').click(function () {
        $(this).toggleClass('active');
        $('#nvb').toggle();
        $('#nva').hide();
        //$('#select_a:first-child').removeClass('active');
        $('.select_tab #select_a').removeClass('active');
    });
    $('.content').click(function () {
        $('.search-box,.menu').hide();
        $('.options #f-menu:last-child, .options #f-serch:first-child').removeClass('active');
    });
</script>
</body>
</html>
