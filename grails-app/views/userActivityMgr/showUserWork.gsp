<%@ page import="nts.utils.CTools; nts.program.domain.Serial" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>作品展示</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'showUserWork.css')}">
    <r:require modules="jwplayer"/>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>

</head>

<body>

<div class="works_show_hh">
    <div class="list_hd">
        <h3>${userWork.name}</h3>
        <dd class="hd_infor">
            <span>作者：${userWork.consumer.name}</span>
            <span>写作时间：<g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${userWork.dateCreated}"/></span>
            <span id="voteNum">投票总数：${userWork.voteNum}</span>
        </dd>

        <div id="player" class="nv_flash">

        </div>
    </div>
    <dl class="hd_nv">
        <dt>作品描述：</dt>
        <dd>${CTools.htmlToBlank(userWork.description)}</dd>
    </dl>
</div>
<script type="text/javascript">
    function constraintImg() {
        if (!$("#photo")) return;
        if ($("#photo").width() > 700) {
            $("#photo").addClass("js925img1");
        }
        else {
            $("#photo").addClass("js925img");
        }
    }

    $(function () {


        <g:if test="${userWork.transcodeState == Serial.CODED_STATE || userWork.transcodeState == Serial.NO_NEED_STATE}">
            <g:if test="${userWork.urlType == Serial.URL_TYPE_VIDEO}">
                var height = 360;
                var width = 700;
                var playList = ${playLinksNew(fileHash:userWork.fileHash)};
                jwplayerInit("player", playList, width, height, true, false);
            </g:if>

            <g:elseif test="${userWork.urlType == Serial.URL_TYPE_IMAGE}">
                var appendDiv = "<a href='${posterLinkNew(fileHash: userWork.fileHash, size: "600x430")}' title='查看原图' target='_blank'><img src='${posterLinkNew(fileHash: userWork.fileHash, size: "600x430")}' id='photo' onload='constraintImg();' width='600' height='430'/></a>";
                $("#player").empty().append(appendDiv);
            </g:elseif>
        </g:if>
        <g:else>
            myAlert("作品还未转码成功,不能点播");
            $("#player").empty();
        </g:else>

        //workPlay();


    });
</script>
%{--<script type="text/javascript">
    var gProgramId = 0;
    var isAnony = ${(session.consumer == null || session.consumer.name == 'anonymity')?"true":"false"};//是否匿名用户

    function createUserWork(id) {
        if (isAnony) {
            alert("匿名用户不能创建立拍秀，请先登录！");
            return;
        }
        window.open( baseUrl + "userWork/create?id=" + id, "_blank");
    }

    function init() {
        <g:if test="${userWork.urlType == Serial.URL_TYPE_VIDEO}">
        workPlay();
        </g:if>
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
        var request_url =  baseUrl + "userWork/voteAjax"; // 需要获取内容的url
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

    window.onload = init;

</script>--}%
</body>
</html>
