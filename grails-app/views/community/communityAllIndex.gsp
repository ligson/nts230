<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 14-5-27
  Time: 上午8:39
--%>

<%@ page import="java.text.SimpleDateFormat; nts.user.domain.Consumer; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="index">
    <title>社区列表</title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_all_index.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'userAcativity.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'turnPage.js')}"></script>
</head>

<body>
<div class="commubity_share_title">
    <div class="wrap">
        <div class="commubity_share_nav">
            <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: studyCommunity?.id])}">社区首页</a><span>/</span>
            <a href="javascript:void(0)">社区列表</a>
        </div>

        %{--<div class="share_upload">
            <a class="admin_default_but_green"
               href="${createLink(controller: 'community', action: 'communityActivityCreat', params: [communityId: studyCommunity?.id])}">创建讨论</a>
        </div>--}%
    </div>
</div>

<div class="commubity_more">
    <div class="commubity_more_left">
        <div class="aibum_index_items">
            <h1>社区列表</h1>
            <g:each in="${communityList}" var="community">
                <div class="aibum_index_item">
                    <div class="aibum_index_item_sup">
                        <a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: community?.id])}">
                            <img src="${resource(dir: 'upload/communityImg', file: community.photo)}" width="200"
                                 height="120"
                                 onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                        </a>

                        <div class="aibum_index_item_infor">
                            <h2><a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: community?.id])}">${CTools.cutString(community?.name, 20)}</a>
                            </h2>

                            <p class="aibum_infor_des">${CTools.cutString(CTools.htmlToBlank(community?.description), 50)}</p>

                            <p class="aibum_infor_user"><a
                                    href="${createLink(controller: 'my', action: 'userSpace', params: [id: community?.create_comsumer_id])}">${Consumer.get(community?.create_comsumer_id)?.name}</a><span>•</span><span>${new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(community?.dateCreated)}</span>
                            </p>
                        </div>
                    </div>
                </div>
            </g:each>
            <div class="boful_activity_footer_page wrap">
                <g:paginate total="${total}" action="communityAllIndex" controller="community"></g:paginate>
            </div>
            %{--<div class="aibum_index_item">
                <div class="aibum_index_item_sup">
                    <a href="#"><img src="${resource(dir: 'skin/blue/pc/front/images', file: 'audio_album_img.jpg')}"/>
                    </a>

                    <div class="aibum_index_item_infor">
                        <h2><a href="#">HTML5 Game Development 基于HTML5的游戏开发</a></h2>

                        <p class="aibum_infor_des">下面推荐一些我认为适合高中生（或初中生），学习的公开课网站或课程（C站、X站、U站、学堂在线上面也有很多适合中学生学习的课程，这里就不提了）</p>

                        <p class="aibum_infor_user"><a href="#">master</a><span>•</span><span>2014-05-09</span></p>
                    </div>
                </div>
            </div>

            <div class="aibum_index_item">
                <div class="aibum_index_item_sup">
                    <a href="#"><img src="${resource(dir: 'skin/blue/pc/front/images', file: 'audio_album_img.jpg')}"/>
                    </a>

                    <div class="aibum_index_item_infor">
                        <h2><a href="#">HTML5 Game Development 基于HTML5的游戏开发</a></h2>

                        <p class="aibum_infor_des">下面推荐一些我认为适合高中生（或初中生），学习的公开课网站或课程（C站、X站、U站、学堂在线上面也有很多适合中学生学习的课程，这里就不提了）</p>

                        <p class="aibum_infor_user"><a href="#">master</a><span>•</span><span>2014-05-09</span></p>
                    </div>
                </div>
            </div>

            <div class="aibum_index_item">
                <div class="aibum_index_item_sup">
                    <a href="#"><img src="${resource(dir: 'skin/blue/pc/front/images', file: 'audio_album_img.jpg')}"/>
                    </a>

                    <div class="aibum_index_item_infor">
                        <h2><a href="#">HTML5 Game Development 基于HTML5的游戏开发</a></h2>

                        <p class="aibum_infor_des">下面推荐一些我认为适合高中生（或初中生），学习的公开课网站或课程（C站、X站、U站、学堂在线上面也有很多适合中学生学习的课程，这里就不提了）</p>

                        <p class="aibum_infor_user"><a href="#">master</a><span>•</span><span>2014-05-09</span></p>
                    </div>
                </div>
            </div>--}%
        </div>
    </div>

    <div class="commubity_more_right">
        <h1>热门社区</h1>

        <div class="c_m_list">
            <g:each in="${hotCommunities}" var="community">
                <p><a href="${createLink(controller: 'community', action: 'communityIndex', params: [id: community?.id])}">${community?.name}</a>
                </p>
            </g:each>
        </div>
    </div>
</div>
</body>
</html>