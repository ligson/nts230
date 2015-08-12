<%@ page import="nts.utils.CTools; nts.program.domain.Serial" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="index"/>
    <title>作品展示</title>
    %{-- <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'list_style.css')}"/>--}%
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'activity_show2.css')}">

    <r:require modules="jwplayer"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/CSerialObj.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common',file: 'fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>

</head>

<body>
<div class="boful_activity_show_bg">

    %{--<div class="works_show_title  wrap" id="location">

        --}%%{--    <div>
                <h1 class="color3 "><a href="${createLink(controller: 'userActivity', action: 'show' , params: [id: userWork.userActivity.id])}"
                                       title="${userWork.userActivity.name}">${CTools.cutString(fieldValue(bean: userWork.userActivity, field: 'name'), 18)}</a><span>/</span><font
                        title="${userWork.name}">${userWork.name}</font></h1>
            </div>--}%%{--
    </div>--}%
    <input type="hidden" id="voteState" value="${flash.voteState}">


    <div id="contentA" class="area">

        <div class="work_see_box">

            <div class="works_show_hh">
                <div class="list_hd">
                    <div class="work_hd_box">
                        <div class="hd_infor_tit">
                            <h3>${userWork.name}</h3>

                            <p class="hd_infor">
                                <span>${message(code: 'my.author.name')}：${userWork.consumer.name}</span>
                                <span>${message(code: 'my.upload.name')}${message(code: 'my.time.name')}：<g:formatDate
                                        format="yyyy-MM-dd HH:mm:ss"
                                        date="${userWork.dateCreated}"/></span>
                                <span>${message(code: 'my.vote.name')}${message(code: 'my.number.name')}：<em
                                        id="voteNum">${userWork.voteNum}</em></span>
                            </p>
                        </div>

                        <div class="hd_infor_num">
                            <button onclick="voteAjax(${userWork.id}, ${userWork.consumer.id});"
                                    class="hd_infor_num_but" type="button">${message(code: 'my.vote.name')}</button>
                        </div>

                    </div>

                    <div class="pl_win">
                        <div id="player" class="nv_flash">

                        </div>
                    </div>
                </div>
                <dl class="hd_nv">
                    <dt><em>${message(code: 'my.works.name')}${message(code: 'my.introduction.name')}：</em></dt>
                    <dd>${CTools.htmlToBlank(userWork.description)}</dd>
                </dl>

                <!-----------------------------------------其他作品------------------------------------------------>
                <div class="hd_other_work">
                    <h1><em>${message(code: 'my.other.name')}${message(code: 'my.works.name')}：</em></h1>

                    <div class="hd_other_work_con">
                        <g:each in="${otherUserWorkList}" var="userWork">
                            <div class="hd_other_work_item">
                                <div class="hd_other_work_item_img">
                                    <a href="${createLink(controller: 'userWork', action: 'show' , params: [id: userWork.id])}" target="_blank"
                                       title="${fieldValue(bean: userWork, field: 'name')}"><img src="${posterLinkNew(fileHash: userWork.fileHash, size: '220x160')}"
                                         width="220"
                                         height="160"
                                         onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"></a>
                                </div>

                                <div class="hd_other_work_item_infor">
                                    <h4><a href="${createLink(controller: 'userWork', action: 'show' , params: [id: userWork.id])}" target="_blank"
                                           title="${fieldValue(bean: userWork, field: 'name')}"/>${CTools.cutString(fieldValue(bean: userWork, field: 'name'), 12)}</h4>

                                    <P class="work_operat"><span><em>${userWork?.visitCount}</em>次浏览</span><span><em>${userWork?.voteNum}</em>票</span></P>

                                    <p class="work_itme"><span>${userWork?.consumer.name}</span><span>${userWork?.dateCreated.format('yyyy-MM-dd')}</span></p>
                                </div>
                            </div>
                        </g:each>
                    </div>
                </div>
            </div>
        </div>

        %{-- <div class="work_see_new  w_ou">
             <div class="indexMenu bord clear  o_hh">
                 <h2><span>最新作品</span></h2>
                 <dl class="list_left">
                     <g:each in="${newsUserWorkList}" status="j" var="newsUserWork">
                         <dd><a href="${createLink(controller: 'userWork', action: 'show' , params: [id: newsUserWork.id])}"
                                title="${newsUserWork?.name}">${CTools.cutString(fieldValue(bean: newsUserWork, field: 'name'), 14)}</a>
                         </dd>
                     </g:each>
                 </dl>
             </div>

             <div class="indexMenu bord clear o_hh">
                 <h2><span>热门作品</span></h2>
                 <dl class="list_left">
                     <g:each in="${hotUserWorkList}" status="j" var="hotUserWork">
                         <dd><a href="${createLink(controller: 'userWork', action: 'show' , params: [id: hotUserWork.id])}"
                                title="${hotUserWork?.name}">${CTools.cutString(fieldValue(bean: hotUserWork, field: 'name'), 14)}</a>
                         </dd>
                     </g:each>
                 </dl>
             </div>
         </div>--}%
    </div>
</div>
<script type="text/javascript">
    var gProgramId = 0;
    var isAnony = ${(session.consumer == null || session.consumer.name == 'anonymity')?"true":"false"};//是否匿名用户

    function createUserWork(id) {
        if (isAnony) {
            alert("匿名用户不能创建立拍秀，请先登录！");
            return;
        }
        window.open(baseUrl + "userWork/create?id=" + id, "_blank");
    }


    function constraintImg() {
        if (!$("#photo")) return;
        if ($("#photo").width() > 700) {
            $("#photo").addClass("js925img1");
        }
        else {
            $("#photo").addClass("js925img");
        }
    }

    function voteAjax(userWorkId, consumerId) {
        if (isAnony) {
            alert("匿名用户不能投票，请先登录！");
            return;
        }
        if (consumerId == ${CTools.nullToZero(session.consumer?.id)}) {
            alert("用户不能给自己的作品投票！");
            return;
        }
        var request_url = baseUrl + "userWork/voteAjax"; // 需要获取内容的url
        var request_pars = "userWorkId=" + userWorkId;//请求参数

        try {
            var myAjax = new Ajax.Updater('voteNum', request_url, { // 将request_url返回内容绑定到id为result的容器中
                method: 'post', //HTTP请求的方法,get or post
                parameters: request_pars, //请求参数
                onFailure: reportError, //失败的时候调用 reportError 函数
                onLoading: loading, //正在获得内容的时候
                onComplete: done() //内容获取完毕的时候
            });
        } catch (e) {
            $.ajax({
                url: request_url,
                type: 'post',
                data: request_pars,
                success: function (data) {
                    if ($("#voteNum").text() == data) {
                        alert("不能重复投票")
                    } else {
                        $("#voteNum").empty().text(data)
                    }

                },
                error: function (data) {
                    alert("投票失败！")
                }
            })
        }

    }

    function loading() {
    }

    function done() {
        var voteState = document.getElementById("voteState").value;
        if (voteState == 1) alert("你已对该作品投过票了！");
        else if (voteState == "0") {
            alert("投票成功");
            document.getElementById("voteState").value = "1";
        }
    }

    function reportError(request) {
        alert("投票失败!");
    }

    <g:if test="${userWork.urlType == Serial.URL_TYPE_VIDEO}">
    <g:workPlayJson userWork="${userWork}"  />
    </g:if>

    $(function(){
        <g:if test="${userWork.urlType == Serial.URL_TYPE_VIDEO}">
        var height = 360;
        var width = 700;
        var playList = ${playLinksNew(fileHash:userWork.fileHash)};
        jwplayerInit("player", playList, width, height, true, false);
        //workPlay();
        </g:if>
        <g:if test="${userWork.urlType == Serial.URL_TYPE_IMAGE}">
        var appendDiv = "<a href='${posterLinkNew(fileHash: userWork.fileHash, size: "740x430")}' title='查看原图' target='_blank'><img src='${posterLinkNew(fileHash: userWork.fileHash, size: "740x430")}' id='photo' onload='constraintImg();' width='740' height='430'/></a>";
        $("#player").empty().append(appendDiv);
        </g:if>
    });
</script>
</body>
</html>
