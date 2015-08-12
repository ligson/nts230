<%@ page import="nts.utils.CTools; java.text.SimpleDateFormat" contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>${message(code: 'my.activities.name')}</title>
    <meta name="layout" content="index">
    <link rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'userAcativity.css')}">
    <style type="text/css">
    #turnPage {
        width: 40px;
    }
    </style>
    <script type="text/javascript">
        var isAnony = ${(session.consumer == null || session.consumer.name == 'anonymity')?"true":"false"};//是否匿名用户
        function createUserWork(id, startTime, endTime) {
            /*
             if (isAnony) {
             alert("匿名用户不能发布作品，请先登录！");
             return;
             }
             else */
            if (new Date(Date.parse(startTime)) > new Date()) {
                alert("对不起，活动尚未开始！");
                return;
            }
            else if (new Date(Date.parse(endTime.replace(/-/g, "/"))) - new Date() < -24 * 60 * 60 * 1000) {
                alert("对不起，活动已经结束！");
                return;
            }
            //window.open( baseUrl + "userWork/create?id=" + id, "_blank");
            location.href = baseUrl + 'userActivity/show?id=' + id;
        }
        function create() {
            if (isAnony) {
                alert("匿名用户不能创建活动，请先登录！");
                return;
            }
            document.location.href = baseUrl + "userActivity/create";
        }
    </script>
</head>

<body>
<div class="boful_activity">
    %{-- <div class="boful_activity_nav">
         <div class="boful_activity_subnav" id="activity_child">
             <p>
                 <g:each in="${rmsCategoryList2}" var="category2">
                     <a href="${createLink(controller: 'userActivity', action: 'index', params: [categoryId: category2.id])}">${category2.name}</a>
                     <input type="hidden" id="second_id" value="${category2.parentid}">
                 </g:each>
             </p>
         </div>

         <div class="boful_activity_nav_class wrap" id="activity_nav">
             <p>
                 <a>全部活动</a>
                 <g:each in="${rmsCategoryList1}" var="category">
                     <a id="category_click"
                        href="${createLink(controller: 'userActivity', action: 'index', params: [categoryId: category.id])}">${category.name}</a>
                     <input type="hidden" id="first_id" value="${category.id}">
                 </g:each>
             </p>
             <span class="boful_activity_nav_class_new"><a href="#" onclick="create()">+创建活动</a></span>
         </div>
     </div>

     <div class="boful_activity_content wrap">
         <!----活动列表--->
         <div class="boful_activity_items">
             <g:if test="${total == 0}">
                 目前该分类没有活动资源!
             </g:if>
             <g:each in="${userActivityList}" var="userActivity">
                 <div class="boful_activity_item">
             --}%%{--  <a href="${createLink(controller: 'userActivity', action: 'show' , params: [id: userActivity.id])}"
                  title="${fieldValue(bean: userActivity, field: 'name')}">--}%%{--
                 <div class="boful_activity_item_img">
                     <div class="boful_activity_item_img_title">
                         <a href="${createLink(controller: 'userActivity', action: 'show' , params: [id: userActivity.id])}"
                            title="${fieldValue(bean: userActivity, field: 'description')}">
                             <h1>${CTools.cutString(userActivity.shortName, 10)}</h1>

                             <p>${CTools.cutString(userActivity.description, 10)}</p>
                         </a>
                     </div>
                     <img width="240" height="150"
                          onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'photo.gif')}'"
                          src="${resource(dir: 'upload/userActivityImg', file: userActivity.photo)}"/>
                 </div>

                 <p><a href="${createLink(controller: 'userActivity', action: 'show' , params: [id: userActivity.id])}"
                       title="${fieldValue(bean: userActivity, field: 'name')}">${CTools.cutString(userActivity.name, 10)}</a>

                 </p>

                 <div class="boful_activity_item_infor">
                     <span class="boful_activity_item_works">${userActivity.workNum}</span>
                     <span class="boful_activity_item_timer">${userActivity.startTime.replace('-', '/')}--${userActivity.endTime.replace('-', '/')}</span>
                 </div>
                 </a>

             </div>
             </g:each>
         </div>
     </div>--}%

    <!--------分页------->

    <div class="ou_activity_box   wrap">
        <div class="o_b_nav">
            <p>
                <span
                    <g:if test="${params.state == '0'}">class="active"</g:if>>${message(code: 'my.all.name')}${message(code: 'my.activities.name')}</span><span
                <g:if test="${params.state == '2'}">class="active"</g:if>>${message(code: 'my.starting.name')}${message(code: 'my.activities.name')}</span><span
                <g:if test="${params.state == '3'}">class="active"</g:if>>${message(code: 'my.ended.name')}${message(code: 'my.activities.name')}</span>
            </p>
        </div>

        <div class="ou_activity_box_body">

            <div class="ou_activity_items">
                <g:if test="${total == 0}">
                    目前该分类没有活动资源!
                </g:if>
                <g:each in="${userActivityList}" var="userActivity">
                    <div class="ou_activity_item">
                        <h1><a href="javascript:void(0)"
                               onclick="createUserWork('${userActivity.id}', '${userActivity.startTime}', '${userActivity.endTime}')"
                               title="">${fieldValue(bean: userActivity, field: 'name')}</a><span>（${userActivityState([startDate: userActivity.startTime, endDate: userActivity.endTime])}）</span>
                        </h1>

                        <p class="ou_a_time">${message(code: 'my.contribute.name')}${message(code: 'my.time.name')}：<span>${userActivity.startTime.replace('-', '-')}</span>&nbsp;/&nbsp;<span>${userActivity.endTime.replace('-', '-')}</span>
                        </p>

                        <p class="ou_a_t_img"><a
                                href="javascript:void(0)"
                                onclick="createUserWork('${userActivity.id}', '${userActivity.startTime}', '${userActivity.endTime}')"
                                title=""><img width="964" height="400"
                                              onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"
                                              src="${resource(dir: 'upload/userActivityImg', file: userActivity.photo)}"/>
                        </a></p>

                        <p class="ou_a_cont">${CTools.htmlToBlank(fieldValue(bean: userActivity, field: 'description'))}</p>
                    </div>
                </g:each>

            </div>
        </div>

        <div class="f_page">
            <g:guiPaginate controller="userActivity" action="index" total="${total}" params="${params}" max="20"/>
        </div>
    </div>

</div>
<g:form name="userActivityForm" controller="userActivity" action="index">
    <input type="hidden" name="state" id="userActivityState">
</g:form>
<script type="text/javascript">
    $(function () {
        $('.o_b_nav span').click(function () {
            var index = $(".o_b_nav span").index(this);
            var state = 0;
            if (index == 1) {
                state = 2;
            }
            else if (index == 2) {
                state = 3;
            }
            $('#userActivityState').val(state);
            $('#userActivityForm').submit();
        });

        $("#search_btn").click(function () {
            $("#search_btn").val('');
        })
        $("#activity_nav a").mouseover(function () {
            var index = $("#activity_nav a").index(this);
            var parentId;
            var n = 0;
            if (index == 0) {
                n = 1;
            }
            if (index != 0) {
                parentId = $("#activity_nav input:eq(" + (index - 1) + ")").val();
            }

            var index_child = $("#activity_child a").length;
            for (var i = 0; i < index_child; i++) {
                var child_val = $("#activity_child input:eq(" + i + ")").val();
                if (n == 1) {
                    $("#activity_child a:eq(" + i + ")").show();
                } else if (child_val == parentId && n == 0) {
                    $("#activity_child a:eq(" + i + ")").show();
                } else {
                    $("#activity_child a:eq(" + i + ")").hide();
                }

            }
        });

        $("#name_search").click(function () {
            var search_btn = $("#search_btn").val();
            location.href = baseUrl + "userActivity/index?name=" + search_btn;
        })

    })
</script>
</body>
</html>