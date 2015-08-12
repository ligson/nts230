<%@ page import="nts.system.domain.SysConfig" %>
<!--左侧菜单开始-->
<div id="sidebar">
    <div id="sidebar-wrapper">
        <ul id="main-nav">
            <img src="${resource(dir: 'images', file: 'qtitle_1.png')}" style="padding-bottom:10px"/>
            <li><a id="myleft1" href="${createLink(controller: 'my', action: 'myInfo')}" class="nav-top-item"><img
                    src="${resource(dir: 'images/icons', file: '20120705092437983_easyicon_cn_16.png')}"/>个人资料</a></li>
            <g:if test="${session.consumer.uploadState == 1 || session.consumer.role == 0}">
                <g:if test="${application.distributeModState == 0 || application.centerGrade != SysConfig.CENTER_GRADE_TOWNSHIP}"><li><a
                        id="myleft2" href="${createLink(controller: 'program', action: 'create')}"
                        class="nav-top-item"><img
                            src="${resource(dir: 'images/icons', file: 'document_small_upload.png')}"/>资源上传</a>
                </li></g:if>
                <li><a id="myleft3" href="${createLink(controller: 'my', action: 'myManageProgram')}"
                       class="nav-top-item"><img
                            src="${resource(dir: 'images/icons', file: 'documents_new.png')}"/>资源管理</a></li>
            </g:if>
            <li><a id="myleft9" href="${createLink(controller: 'my', action: 'myJoinList')}"
                   class="nav-top-item"><img
                        src="${resource(dir: 'images/icons', file: 'activity.png')}"/>活动管理</a></li>
            <li><a id="myleft4"
                   href="${createLink(controller: 'my', action: 'myHistoryProgramList', params: [listType: "view"])}"
                   class="nav-top-item"><img
                        src="${resource(dir: 'images/icons', file: '20120705092437983_easyicon_cn_16.png')}"/>历史记录</a>
            </li>
            <li><a id="myleft8"
                   href="${createLink(controller: 'my', action: 'myCommunity', params: [communityType: "my"])}"
                   class="nav-top-item"><img
                        src="${resource(dir: 'images/icons', file: '20120705092437983_easyicon_cn_16.png')}"/>社区管理</a>
            </li>
            <li><a id="myleft10" href="${createLink(controller: 'my', action: 'myGroupList')}" class="nav-top-item"><img
                    src="${resource(dir: 'images/icons', file: 'documents_new.png')}"/>我创建的组</a></li>

        </ul>
    </div>
</div>
<!--左侧菜单结束-->
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/myLeft.js')}"></script>