<%@ page import="nts.utils.CTools; nts.program.domain.Serial" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>首页</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'list_style.css')}"/>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css/skin', file: 'bootstrap-cerulean.css')}"/>

    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/showProgram.js')}"></script>
    <r:require modules="jwplayer"/>
    <script type="text/javascript">
        jwplayer.key = "ktWIk7l3bcd4z5Qe3GGwiYbMPu3Tu3Mhk2ifmbTkqLI=";
    </script>

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
            var request_url = baseUrl + "appMgr/voteAjax"; // 需要获取内容的url
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
                    data: request_pars,
                    success: function (data) {
                        done();
                    },
                    error: function (data) {
                        reportError();
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
                window.location.reload();
            }
        }

        function reportError(request) {
            alert("投票失败!");
        }

        if ("${userWork.urlType == Serial.URL_TYPE_VIDEO}") {
            ${workPlayJson(userWork: userWork)}
        }


        window.onload = init;

    </script>
</head>

<body>
<style>
.list_hd {
    float: left;
    margin: 5px;
    padding: 5px;
    width: 99%;
}

.list_hd h3 {
    text-align: center;
    margin-bottom: 10px;
    font-size: 16px;
}

.list_hd dd {
    text-align: center;
    margin-left: 5px;
    line-height: 26px;
}

.list_hd dd span {
    margin-left: 15px;
    line-height: 26px;
}

.list_hd dd.nv_flash {
    margin: 10px 5px 10px 0px;
    overflow: hidden;
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

.color3 {
    font-size: 14px;
    margin-left: 15px;
    line-height: 50px;
}
</style>
<input type="hidden" id="voteState" value="${flash.voteState}">

<div class="area" id="location" style="background-color:#F1F1F1">
    <div class="left ">
        <h1 class="color3 "><a href="${createLink(controller: 'appMgr', action: 'showUserActivity', params: [id: userWork.userActivity.id])}"
                               title="${userWork.userActivity.name}">${CTools.cutString(fieldValue(bean: userWork.userActivity, field: 'name'), 18)}</a>-><font
                title="${userWork.name}">${userWork.name}</font></h1>
    </div>
</div>

<div id="contentA" class="area areabg1">
    <div class="left areabg " style="float:right;margin-right:6px; ">
        <div class="indexMenu bord clear">
            <h2 style="text-align:left"><span>最新作品</span></h2>
            <dl class="list_left">
                <g:each in="${newsUserWorkList}" status="j" var="newsUserWork">
                    <dd><a href="${createLink(controller: 'appMgr', action: 'showUserWork', params: [id: newsUserWork.id])}"
                           title="${newsUserWork?.name}">${CTools.cutString(fieldValue(bean: newsUserWork, field: 'name'), 14)}</a>
                    </dd>
                </g:each>
            </dl>
        </div>

        <div class="indexMenu bord clear" style="margin-top:10px;">
            <h2 style="text-align:left"><span>热门作品</span></h2>
            <dl class="list_left">
                <g:each in="${hotUserWorkList}" status="j" var="hotUserWork">
                    <dd><a href="${createLink(controller: 'appMgr', action: 'showUserWork', params: [id: hotUserWork.id])}"
                           title="${hotUserWork?.name}">${CTools.cutString(fieldValue(bean: hotUserWork, field: 'name'), 14)}</a>
                    </dd>
                </g:each>
            </dl>
        </div>
    </div>

    <div class="right areabg" style="float:left; ">
        <div style="width:735px; margin-left:5px; overflow:hidden;">
            <div class="list_hd" style="overflow: hidden;">
                <h3><b>${userWork.name}</b></h3>
                <dd style="overflow: hidden; margin-bottom: 10px;"><span>作者：${userWork.consumer.name}</span><span>写作时间：${userWork.dateCreated}</span><span>投票总数：${userWork.voteNum}</span><span>
                    <button onclick="voteAjax(${userWork.id}, ${userWork.consumer.id});" class="btn btn-primary"
                            style="background-color:#BD2246;" type="button">投票</button>
                </span></dd>


                <div id="player" class="nv_flash"
                     style="margin:0 auto; overflow: hidden; text-align: center;width:700px;height:360px;">
                    <a href="${workImgLink(userWork: userWork, isAbbrImg: false)}" title="查看原图" target="_blank"><img
                            src="${workImgLink(userWork: userWork, isAbbrImg: false)}" id="photo"
                            onload="constraintImg();" width="600" height="430"/></a>
                </div>
            </div>
            <dl class="hd_nv">
                <dt>作品描述：</dt>
                <dd>${CTools.htmlToBlank(userWork.description)}</dd>
            </dl>
        </div>
    </div>
</div>
</body>
</html>
