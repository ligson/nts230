<%@ page import="nts.commity.domain.StudyCommunity; nts.commity.domain.ForumMember; nts.commity.domain.ForumReplyArticle; nts.commity.domain.ForumBoard; nts.commity.domain.ForumMainArticle; nts.commity.domain.Activity; java.text.SimpleDateFormat; nts.commity.domain.Sharing; nts.utils.CTools; nts.user.domain.Consumer" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'communityIndex.css')}">
    <meta name="layout" content="index">
    <script type="text/javascript" src="${resource(dir: 'js/boful/community', file: 'autoLoading.js')}"></script>
    <title>社区首页</title>
    <script type="text/javascript">
        $(function () {
            $("#categoryMenu").hover(function () {
                $(this).find(".o_c_sup_cla").show();
            }).click(function () {
                $(this).find(".o_c_sup_cla").toggle();
                $(".o_c_sup_s").hide();
            });
            var spans = $("#category_first").find("span");
            $("#category_first span").hover(function () {
                var index =$("#category_first span").index($(this));
                $(".o_c_sup_s").hide();
                var categorySub = $(".o_c_sup_s")[index];
                $(categorySub).css("margin-top",0);
                $(categorySub).css("top", $(this).offset().top).show();
            });
            $(".o_c_sup_s").mouseleave(function () {
                $(this).hide();
                $(".o_c_sup_cla").hide();
            });
            $(".o_c_sup_cla").mouseleave(function () {
                document.onmouseover = function (e) {
                    var el = e.target;
                    if (el.id == 'category_first' || el.id == 'categoryMenu' || el.id == 'pp' || el.id == 'ss' || el.id == 'sp' || el.id == 'c1' || el.id == 'sp1' || el.id == 'c2') {
                        $(this).find(".o_c_sup_cla").show();
                    }
                    else {
                        var str = baseUrl + 'community/index?categoryId=';
                        if (el.toString().indexOf(str) < 0) {
                            $(".o_c_sup_cla").hide();
                            $(".o_c_sup_s").hide();
                        }
                    }

                }
            });
        });
        /*
         document.onmouseover = function(e){
         var el = e.target;
         var str = baseUrl + 'community/index?categoryId=';
         if(el.toString().indexOf(str) < 0){
         $(".o_c_sup_cla").hide();
         }
         }
         */
    </script>
</head>

<body>
<div class="o_c_bg">
    <div class="ouknow_community_box">
        <div class="ouknow_community_nav">
            <g:each in="${rmsCategoryList1}" var="category1" status="st">
                <div class="o_c_sup_s" style="display: none;" id="c2">
                    <g:each in="${rmsCategoryList2}" var="category2">
                        <g:if test="${category2.parentid == category1.id}">
                            <span id="sp"><a id="ss"
                                             href="${createLink(controller: 'community', action: 'index', params: [categoryId: category2.id])}">${category2.name}</a>
                            </span>
                        </g:if>
                    </g:each>
                </div>
            </g:each>




            <div class="o_c_all com_aa_n <g:if test="${flag == 1}">com_aa_n2</g:if>">
                <a href="${createLink(controller: 'community', action: 'index')}">${message(code: 'my.all.name')}${message(code: 'my.community.name')}</a>
            </div>

            <div class="o_c_cla com_aa_n <g:if test="${flag == 2}">com_aa_n2</g:if>" id="categoryMenu">

                <div class="o_c_sup_cla" style="display:none;" id="category_first">
                    <g:each in="${rmsCategoryList1}" var="category1" status="i">
                        <span id="sp1">
                            <a id="c1" href="${createLink(controller: 'community', action: 'index', params: [categoryId: category1.id])}">${category1.name}</a>%{--${createLink(controller: 'community', action: 'index', params: [categoryId: category1.id])}--}%
                        </span>
                    </g:each>
                </div>


                <p id="pp">${message(code: 'my.class.name')}${message(code: 'my.community.name')}</p>
            </div>

            <div class="o_c_new com_aa_n <g:if test="${flag == 3}">com_aa_n2</g:if>">
                <a href="${createLink(controller: 'community', action: 'index', params: [order: 'desc', sort: 'dateCreated'])}">${message(code: 'my.newest.name')}${message(code: 'my.community.name')}</a>
            </div>
            <g:if test="${Consumer.findByName(session?.consumer?.name)?.uploadState}">
            <span class="o_c_creat">
                <a href="${createLink(controller: 'community', action: 'create')}">+${message(code: 'my.creat.name')}${message(code: 'my.community.name')}</a>
            </span></g:if>
        </div>

        <div class="ouknow_com_num"><p>共<span>${total}</span>个${message(code: 'my.community.name')}</p></div>
        <div class="ouknow_community_con">
            <g:each in="${studyCommunityList}" var="community" status="sta">
                <div class="ouknow_com_item">
                    <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: community?.id])}">
                    <div class="ouknow_com_item_black"></div>
                    </a>
                    <img src="${generalCommunityPhotoUrl(community: community)}"/>

                    <div class="ouknow_com_item_in">
                        <h1><a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: community?.id])}">${community?.name}</a>
                        </h1>

                        <p class="ou_ci_in">${CTools.codeToHtml(community?.description)}</p>

                        <p class="ou_ci_opreat"><span><em>${community.forumBoards.size()}</em>${message(code: 'my.group.name')}
                        </span><span><em>${readStudyCommunityMembersCount(studyCommunity: community)}</em>${message(code: 'my.members.name')}
                        </span></p>
                    </div>
                </div>
            </g:each>

        </div>

        <div class="f_page">
            <g:guiPaginate controller="community" action="index" total="${total}" params="${params}" max="20"/>
        </div>
    </div>
</div>
<!--------分页------->
%{--<div class="boful_activity_footer_page wrap">
    <p>
        <g:guiPaginate controller="community" action="communityIndex" total="${total}"/>
    </p>
</div>--}%

</body>
</html>