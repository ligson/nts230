<%@ page import="nts.user.domain.Consumer; nts.utils.CTools" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="index"/>
    <title>活动参与</title>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'activity_show.css')}">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'list_style.css')}"/>
    <script type="text/javascript" language="JavaScript">
        var isAnony = ${(session.consumer == null || session.consumer.name == 'anonymity')?"true":"false"};//是否匿名用户
        function createUser() {
            var id = document.getElementById("user_id").value;
            var startTime = document.getElementById("user_start").value;
            var endTime = document.getElementById("user_end").value;
            if (isAnony) {
                alert("匿名用户不能发布作品，请先登录！");
                return;
            }
            else if (new Date(Date.parse(startTime + ' 00:00:00')) > new Date()) {
                alert("对不起，活动尚未开始！");
                return;
            }
            else if (new Date(Date.parse(endTime + ' 23:59:59')) < new Date()) {
                alert("对不起，活动已经结束！");
                return;
            }
            window.open(baseUrl + "userWork/create?id=" + id, "_blank");
        }
    </script>
</head>

<body>
<div class="boful_activity_show_bg">
    <div id="contentA" class="area boful_activity_show_wit">
        <div class="right areabg activity_show_wid">
            <div style="display: block; overflow: hidden">
                <div class="activity_img">
                    <img width="994" height="300"
                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"
                         src="${resource(dir: 'upload/userActivityImg', file: userActivity.photo)}"/>
                </div>

                <div class="list_hd">
                    <h3>${userActivity.name}</h3>
                    <dl class="list_hd_smail">
                        <dd>${message(code: 'my.start.name')}${message(code: 'my.time.name')}：${userActivity.startTime}</dd>
                        <dd>${message(code: 'my.end.name')}${message(code: 'my.time.name')}：${userActivity.endTime}</dd>
                        <dd>${message(code: 'my.works.name')}${message(code: 'my.number.name')}：${userActivity.workNum}</dd>
                        <dd>${message(code: 'my.vote.name')}${message(code: 'my.number.name')}：${userActivity?.voteNum}</dd>
                        <dd>${message(code: 'my.activities.name')}${message(code: 'my.sort.name')}：${userActivity.activityCategory.name}</dd>
                        <input type="hidden" value="${userActivity.id}" id="user_id">
                        <input type="hidden" value="${userActivity.startTime}" id="user_start">
                        <input type="hidden" value="${userActivity.endTime}" id="user_end">
                    </dl>
                    <g:if test="${Consumer.findByName(session.consumer.name)?.uploadState}">
                        <button onclick="createUser()"
                                class="btn btn-primary">${message(code: 'my.minejoin.name')}</button></g:if>
                </div>
                <dl class="hd_nv">
                    <dt style="font-size: 18px; color: #333333;"><span
                            class="ou_hd_tit">${message(code: 'my.activities.name')}${message(code: 'my.content.name')}</span>
                    </dt>
                    <dd>${CTools.htmlToBlank(userActivity.description)}</dd>
                </dl>
            </div>

            <div class="menuC">
                <div class="l">
                    <ul>
                        <li class="libg"
                            style="text-align: left">${message(code: 'my.activities.name')}${message(code: 'my.works.name')}</li>
                    </ul>
                </div>

                %{--  <div class="taglist"><span onclick="lvs(2)" id="ltA" class="ltA" title="海报">海报</span> <span
                          onclick="lvs(1)"
                          title="列表"
                          id="lzA"
                          class="lzB">列表</span>
                  </div>--}%
            </div>


            <div id="videoData">
                <!-- *******一组<div class="vData clear">有4个内容--开始  循环<div class="vData clear">..</div>即可多组显示***** -->
                <div class="vData ">
                    <div class="hd_other_work_con">
                    <!-- *******单个内容显示开始 且<div class="vInfo">单个内容</div>只能放3个内容为一排***** -->
                        <g:each in="${userWorkList}" status="i" var="userWork">
                        %{--    <div class="vInfo">
                                <div class="vPic" style="z-index: 1; ">
                                    --}%%{-- <div class="label"><i></i><em>${userWork.voteNum}票</em></div>--}%%{--
                                    <a href="${createLink(controller: 'userWork', action: 'show' , params: [id: userWork.id])}" target="_blank"
                                       title="${fieldValue(bean: userWork, field: 'name')}">
                                        <img src="${posterLinkNew(fileHash: userWork.fileHash, size: '120x80')}" width="120"
                                             height="80"
                                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                    </a>
                                    <span class="gq_ico"></span>
                                </div>

                                <div class="vTxt">
                                    <h4 style="text-align:center;">
                                        <a class="vT_a" href="${createLink(controller: 'userWork', action: 'show' , params: [id: userWork.id])}"
                                           title="${fieldValue(bean: userWork, field: 'name')}"
                                           target="_blank">${CTools.cutString(fieldValue(bean: userWork, field: 'name'), 16)}</a>
                                        <!-- 增加开始 -->
                                        --}%%{--<span class="vGra"><em>${userWork.voteNum}</em>票</span>--}%%{--
                                        <!-- 增加结束 -->
                                    </h4>

                                    <p><em class="p_name">${userWork.consumer.name}</em><em
                                            class="p_fan">${userWork.voteNum}票</em></p>

                                    <p><em>${userWork.dateCreated.format('yyyy-MM-dd')}</em></p>

                                </div>
                            </div>--}%
                            <div class="hd_other_work_item">
                                <div class="hd_other_work_item_img">
                                    <a href="${createLink(controller: 'userWork', action: 'show' , params: [id: userWork.id])}" target="_blank"
                                       title="${fieldValue(bean: userWork, field: 'name')}">
                                        <img src="${posterLinkNew(fileHash: userWork.fileHash, size: '220x160')}"
                                             width="220"
                                             height="160"
                                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'">
                                    </a>
                                </div>

                                <div class="hd_other_work_item_infor">
                                    <h4><a href="${createLink(controller: 'userWork', action: 'show' , params: [id: userWork.id])}"
                                           title="${fieldValue(bean: userWork, field: 'name')}"
                                           target="_blank">${CTools.cutString(fieldValue(bean: userWork, field: 'name'), 12)}</a>
                                    </h4>

                                    <P class="work_operat"><span><em>${userWork?.visitCount}</em>次浏览
                                    </span><span><em>${userWork?.voteNum}</em>票
                                    </span></P>

                                    <p class="work_itme"><span>${userWork.consumer.name}</span><span>${userWork.dateCreated.format('yyyy-MM-dd')}</span>
                                    </p>
                                </div>
                            </div>
                        </g:each>
                    <!-- *******单个内容显示结束***** -->
                    </div>
                    <!-- *******一组<div class="vData clear">有4个内容--结束***** -->
                    <div class="vData"></div>
                </div>

                %{--     <div class="jumpB ">
                         <div class="xb_pages">
                             <g:guiPaginate controller="userActivity" action="show" total="${total}" params="${params}"
                                            maxsteps="8"/>
                         </div>
                     </div>--}%
                <div class="jumpA">
                    <div class="r">
                        <g:if test="${Integer.parseInt(params.offset) > 0}">
                            <a href="${createLink(controller: 'userActivity', action: 'show' , params: [id: userActivity.id, max: params.max, offset: Integer.parseInt(params.offset) - Integer.parseInt(params.max), sort: params.sort, order: params.order])}"
                               class="pa">上一页</a>
                        </g:if>
                        <g:else>上一页</g:else>
                        ${Integer.parseInt(params.offset) / Integer.parseInt(params.max) + 1}/<g:if
                            test="${total < Integer.parseInt(params.max)}">1</g:if><g:else>${Math.round(Math.ceil(total / Integer.parseInt(params.max)))}</g:else>
                        <g:if test="${total - Integer.parseInt(params.offset) > Integer.parseInt(params.max)}">
                            <a href="${createLink(controller: 'userActivity', action: 'show' , params: [id: userActivity.id, max: params.max, offset: Integer.parseInt(params.offset) + Integer.parseInt(params.max), sort: params.sort, order: params.order])}"
                               class="pa">下一页</a>
                        </g:if>
                        <g:else>下一页</g:else>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<script type="text/javascript" language="JavaScript">
    function vote(userWorkId, consumerId) {
        if (isAnony) {
            alert("匿名用户不能投票，请先登录！");
            return;
        }
        if (consumerId == ${session?.consumer?.id}) {
            alert("用户不能给自己的作品投票！");
            return;
        }
        window.location.href = baseUrl + "userWork/vote?userWorkId=" + userWorkId;
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

    function showhide_obj(obj, icon) {
        obj = document.getElementById(obj);
        icon = document.getElementById(icon);
        if (obj.style.display == "none") {
            //指定文档中的对象为div,仅适用于IE;
            div_list = document.getElementsByTagName("div");
            for (i = 0; i < div_list.length; i++) {
                thisDiv = div_list[i];
                if (thisDiv.id.indexOf("title") != -1)//当文档div中的id含有list时,与charAt类似;
                {
                    //循环把所有菜单链接都隐藏起来
                    thisDiv.style.display = "none";
                    icon.innerHTML = "+";
                }
            }

            myfont = document.getElementsByTagName("font");
            for (i = 0; i < myfont.length; i++) {
                thisfont = myfont[i];
            }
            icon.innerHTML = "-";
            obj.style.display = ""; //只显示当前链接
        }
        else {
            //当前对象是打开的，就关闭它;
            icon.innerHTML = "+";
            obj.style.display = "none";
        }
    }
</script>
</body>
</html>
