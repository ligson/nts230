<%@ page import="nts.utils.CTools" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>首页</title>
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/common/css', file: 'xindex.css')}"
          media="all">
    <link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'userActivity.css')}"
          media="all">
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'list_style.css')}"/>
    <script>
        var isAnony = ${(session.consumer == null || session.consumer.name == 'anonymity')?"true":"false"};//是否匿名用户
        function createUserWork(id, startTime, endTime) {
            if (isAnony) {
                alert("匿名用户不能发布作品，请先登录！");
                return;
            }
            else if (new Date(Date.parse(startTime.replace(/-/g, "/"))) - new Date() > 0) {
                alert("对不起，活动尚未开始！");
                return;
            }
            else if (new Date(Date.parse(endTime.replace(/-/g, "/"))) - new Date() < -24 * 60 * 60 * 1000) {
                alert("对不起，活动已经结束！");
                return;
            }
            window.open(baseUrl + "userWork/create?id=" + id, "_blank");
        }
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
</head>

<body>
<div id="contentA" class="area areabg1">
    <div class="left areabg " style="float:right; margin-right: 6px;">
        <div class="indexMenu bord clear">
            <h2 style="text-align:left"><span>最新活动</span></h2>
            <dl class="list_left">
                <g:each in="${newsUserActivityList}" status="j" var="newsUserActivity">
                    <dd><a href="${createLink(controller: 'userActivity', action: 'show', params: [id: newsUserActivity.id])}"
                           title="${newsUserActivity?.name}">${CTools.cutString(fieldValue(bean: newsUserActivity, field: 'name'), 13)}</a>
                    </dd>
                </g:each>
            </dl>
        </div>

        <div class="indexMenu bord clear" style="margin-top:10px;">
            <h2 style="text-align:left"><span>热门活动</span></h2>
            <dl class="list_left">
                <g:each in="${hotUserActivityList}" status="j" var="hotUserActivity">
                    <dd><a href="${createLink(controller: 'userActivity', action: 'show', params: [id: hotUserActivity.id])}"
                           title="${hotUserActivity?.name}">${CTools.cutString(fieldValue(bean: hotUserActivity, field: 'name'), 13)}</a>
                    </dd>
                </g:each>
            </dl>
        </div>
    </div>

    <div class="right areabg" style="float:left; ">
        <style>
        .list_hd {
            float: left;
            margin: 5px;
            padding: 5px;
            width: 458px;
        }

        .list_hd h3 {
            text-align: center;
            margin-bottom: 10px;
        }

        .list_hd dd {
            float: left;
            text-align: left;
            width: 40%;
            line-height: 26px;
        }

        .hd_nv {
            float: left;
            margin: 5px;
            padding: 5px;
            width: 100%;
            overflow: hidden;
        }

        .hd_nv dt {
            float: left;
            text-align: left;
            width: 720px;
            border-bottom: 1px #DDD solid;
            line-height: 26px;
            overflow: hidden;
        }

        .hd_nv dd {
            float: left;
            text-align: left;
            width: 700px;
            padding: 5px 5px 5px 0px;
            line-height: 26px;
        }
        </style>

        <div style="width:735px;  overflow:hidden;">
            <div style="float:left; margin:10px 5px 10px 5px; padding:5px; border: 1px #DDD solid;"><img
                    src="${resource(dir: 'upload/userActivityImg', file: userActivity.photo == '' || userActivity.photo == null ? 'default.jpg' : userActivity.photo)}"
                    width="235" height="165"
                    onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'">
            </div>
            <dl class="list_hd"><h3
                    style="text-align: left;font-weight: bold;font-size: 18px;line-height: 27px;">${userActivity.name}</h3><dd>开始时间：${userActivity.startTime}</dd><dd>结束时间：${userActivity.endTime}</dd><dd>作品数目：${userActivity.workNum}</dd><dd>投票总数：${userActivity?.voteNum}</dd><dd>活动类别：${userActivity.activityCategory.name}</dd><dd><button
                    onclick="createUserWork(${userActivity.id}, '${userActivity.startTime}', '${userActivity.endTime}');"
                    class="btn btn-primary" style="background-color: rgb(83, 169, 63);" type="button">我要参与</button></dd>
            </dl>
            <dl class="hd_nv"><dt>活动内容</dt><dd>${CTools.htmlToBlank(userActivity.description)}</dd></dl>
        </div>

        <div class="menuC" style="width:725px; margin-left: 10px; overflow: hidden; ">
            <div class="l">
                <ul>
                    <li class="libg">参与作品</li>
                </ul>
            </div>

            <div class="taglist"><span onclick="lvs(2)" id="ltA" class="ltA" title="海报">海报</span> <span onclick="lvs(1)"
                                                                                                        title="列表"
                                                                                                        id="lzA"
                                                                                                        class="lzB">列表</span>
            </div>
        </div>

        <div class="jumpA clear" style="margin-bottom:10px;margin-right:5px;">
            <div class="r">
                <g:if test="${Integer.parseInt(params.offset) > 0}">
                    <a href="${createLink(controller: 'userActivity', action: 'show', params: [id: userActivity.id, max: params.max, offset: Integer.parseInt(params.offset) - Integer.parseInt(params.max), sort: params.sort, order: params.order])}"
                       class="pa">上一页</a>
                </g:if>
                <g:else>上一页</g:else>
                ${Integer.parseInt(params.offset) / Integer.parseInt(params.max) + 1}/${Math.round(Math.ceil(total / Integer.parseInt(params.max)))}
                <g:if test="${total - Integer.parseInt(params.offset) > Integer.parseInt(params.max)}">
                    <a href="${createLink(controller: 'userActivity', action: 'show', params: [id: userActivity.id, max: params.max, offset: Integer.parseInt(params.offset) + Integer.parseInt(params.max), sort: params.sort, order: params.order])}"
                       class="pa">下一页</a>
                </g:if>
                <g:else>下一页</g:else>
            </div>
        </div>

        <div class="clear" id="videoData">
            <!-- *******一组<div class="vData clear">有4个内容--开始  循环<div class="vData clear">..</div>即可多组显示***** -->
            <div class="vData clear">
            <!-- *******单个内容显示开始 且<div class="vInfo">单个内容</div>只能放3个内容为一排***** -->
                <g:each in="${userWorkList}" status="i" var="userWork">
                    <div class="vInfo">
                        <div class="vPic" style="z-index: 1; "><a href="${createLink(controller: 'userWork', action: 'show', params: [id: userWork.id])}"
                                                                  target="_blank"
                                                                  title="${fieldValue(bean: userWork, field: 'name')}"><img
                                    src="${posterLinkNew(fileHash: userWork.fileHash, size: '120x80')}" width="120"
                                    height="80"
                                    onerror="this.src = '${resource(dir:'skin/blue/pc/front/images',file:'boful_default_img.png')}'">
                        </a>

                            <div class="label"><i></i><em>${userWork.voteNum}票</em></div>
                            <span class="gq_ico"></span>
                        </div>

                        <div class="vTxt">
                            <h4 style="text-align:center;"><a href="${createLink(controller: 'userWork', action: 'show', params: [id: userWork.id])}"
                                                              title="${fieldValue(bean: userWork, field: 'name')}"
                                                              target="_blank">${CTools.cutString(fieldValue(bean: userWork, field: 'name'), 16)}</a>
                                <!-- 增加开始 -->
                                %{--<span class="vGra"><em>${userWork.voteNum}</em>票</span>--}%
                                <!-- 增加结束 -->
                            </h4>

                            <p>作者:<em>${userWork.consumer.name}</em></p>

                            <p>创建时间:<em>${userWork.dateCreated.format('yyyy-MM-dd HH:mm:ss')}</em></p>
                            <!-- 增加开始 -->
                            <dl>
                                <dt>作者：<em>${userWork.consumer.name}</em></dt>
                                <dd>创建时间：${userWork.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</dd>

                                <p></p>
                            </dd>
                            </dl>

                            <p class="detail">${CTools.cutString(fieldValue(bean: userWork, field: 'description'), 235)}<a
                                    href="${createLink(controller: 'userWork', action: 'show', params: [id: userWork.id])}" title="${CTools.htmlToBlank(userWork.description)}"
                                    target="_blank">[详细]</a></p>
                            <h5><a href="#" onclick="vote(${userWork.id}, ${userWork.consumer.id});">投 票</a></h5>
                            <!-- 增加结束 -->
                        </div>
                    </div>
                </g:each>
            <!-- *******单个内容显示结束***** -->
            </div>
            <!-- *******一组<div class="vData clear">有4个内容--结束***** -->
            <div class="vData clear"></div>
        </div>

        <div class="jumpB clear">
            <div class="xb_pages" align="right" style="height: 40px;">
                <g:guiPaginate controller="userActivity" action="show" total="${total}" params="${params}"
                               maxsteps="8"/>
            </div>
        </div>
    </div>
</div>
</body>
</html>
