<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/11/28
  Time: 15:01
--%>

<%@ page import="nts.meta.domain.MetaContent; nts.utils.CTools; nts.program.domain.Program; com.boful.common.date.utils.TimeLengthUtils" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="index">
    <title>Flash播放</title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_videoShow.css')}"/>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'playFlash.css')}"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/meta.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'metalist.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/showProgram.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/string.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/swfobject', file: 'swfobject.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'bofulswfobject.js')}"></script>
    <script type="text/javascript">
        //全局变量
        var contentList = [];
        var metaList = [];
        var wtab;
        var gDisciplineId = "${application?.metaDisciplineId}";
        var gProgramId = ${program?.id};
        var isOutPlay = false;//播放来自外部（省图下级节点）
        var gOutHost = "";//用于外部（省图下级节点）批量播放，host,如：http://192.168.1.13:80
        var gFromNodeId = 0;
        var gPosterImg = "${posterLink(serials:program?.serials,isAbbrImg:false)}";
        var gAutoPlayTime = ${application?.autoPlayTime == 0?30:application.autoPlayTime};
        var gLineList = "${application.lineList}";
        var gCanComment = ${session?.consumer?.canComment?"true":"false"};
        var isAnonymous = ${session.consumer?(session.consumer?.name?.equals(application.anonymityUserName)):true};
        var serialId = ${serial.id};
        var lastTime = ${lastTime?lastTime:-1};

        //初始化,prototype没有
        window.onload = init;

        function init() {
            //alert(234);
            wtab = document.getElementById("metaContTab");
            setCurMetaList(${program?.directory?.id?program?.directory?.id:-1}, 1, -1);//显示当前类下可摘要显示
            showAllTr();
            //setSerialList();


            //setPlayTrShow();
            //setImgNum();
            //实例化播放器
            //initJWPlay();
            //showSerialSlide();
            //document.getElementById("bodyDiv").style.display = "block";

        }

        <g:each in="${program.metaContents}" status="i" var="metaContent">
        contentList[${i}] = new CContentTypeObj(${metaContent.id}, ${metaContent.metaDefine.id}, ${metaContent.metaDefine.parentId}, ${MetaContent.numDataTypes.contains(metaContent.metaDefine.dataType)?1:2}, ${metaContent.numContent}, '${CTools.nullToBlank(metaContent.strContent).encodeAsJavaScript()}');
        </g:each>
    </script>

    <script type="text/javascript">
        $(function () {

            var swfUrl = "${playDocumentLinksNew(serial:serial)}";

            initSWF(swfUrl, "flashDiv", "1024", "560");

            var listItem = $(".list-item");
            var botItem = $(".bot-item");

            listItem.click(function () {
                var index3 = listItem.index($(this));

                listItem.removeClass("l-c");
                $(this).addClass("l-c");
                botItem.hide();

                var curenDiv = botItem[index3];
                $(curenDiv).show();

            });
        });

        function checkPlayType(id, fileHash, filePath) {
            if (checkFileType(filePath) == 2) {
                window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=document&fileHash=" + fileHash, '_blank');
            } else if (checkFileType(filePath) == 3) {
                window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=image&fileHash=" + fileHash, '_blank');
            } else if (checkFileType(filePath) == 1) {
                window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=video&fileHash=" + fileHash, '_blank');
            } else if (checkFileType(filePath) == 4) {
                window.open(baseUrl + "program/singlePlay?id=" + id + "&playType=audio&fileHash=" + fileHash, '_blank');
            } else if (checkFileType(filePath) == 5) {
                window.location.href = baseUrl + "program/playFlash?id=" + id;
            }
        }
    </script>
</head>
<%

    StringBuffer buffer = new StringBuffer();
    Map pars = request.getParameterMap();
    Iterator iterator = pars.keySet().iterator();
    while (iterator.hasNext()) {
        Object object = iterator.next();
        String[] values = pars.get(object);
        buffer.append(object);
        buffer.append("=")
        for (int i = 0; i < values.size(); i++) {
            buffer.append(values[i]);
        }
    }
    String path = request.getForwardURI() + "?" + buffer;
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path;

%>
<body>
<div class="playFlash-win">
    <div class="wrap">
        <div class="flash-tit">
            <a href="#">${program?.name}</a><span>${CTools.cutString(serial?.name, 20)}</span>
        </div>

        <div class="flash-win" id="flashDiv">

        </div>
    </div>
</div>

<div class="playFlash-content">
    <!-----播放列表---->
    <div class="flash-list">
        <div class="wrap">
            <g:each in="${serialList}" status="i" var="serial">
                <div class="video_item">
                    <div class="boful_recommond_video_item_play"><a
                            href="javascript:void(0);"
                            onclick="checkPlayType('${serial.id}', '${serial.fileHash}', '${serial.filePath}')"><img
                                style="box-shadow: none"
                                src="${resource(dir: 'skin/blue/pc/front/images', file: 'boful_recommond_video_item_play_icon.png')}">
                    </a></div>
                    <a href="javascript:void(0);"
                       onclick="checkPlayType('${serial.id}', '${serial.fileHash}', '${serial.filePath}')">
                        <img src="${resource(dir: 'images/flash', file: 'flash-imgs.png')}"
                             onerror="this.src = '${resource(dir: 'skin/blue/pc/front/images', file: 'boful_default_img.png')}'"/>
                    </a>

                    <p>
                        <a href="javascript:void(0);"
                           onclick="checkPlayType('${serial.id}', '${serial.fileHash}', '${serial.filePath}')">${serial?.name}</a>
                    </p>
                </div>
            </g:each>

        </div>
    </div>

</div>

<div class="flash-botm">
    <div class="flash-infor">
        <div class="wrap">
            <div class="infor-list">
                <div class="list-item">资源信息</div>

                <div class="list-item">分&nbsp;&nbsp;享</div>
            </div>

            <div class="infor-bot">
                <div class="bot-item" style="display: block">
                    <table>
                        <tbody>
                        <tr>
                            <td width="100" align="left">${Program.cnField.dateCreated}:</td>
                            <td>${program?.dateCreated?.format("yyy-MM-dd HH:mm:ss")}</td>
                        </tr>
                        <tr>
                            <td width="100" align="left">${Program.cnField.name}:</td>
                            <td>${CTools.cutString(program?.name, 10)}</td>
                        </tr>
                        <tr>
                            <td width="100" align="left">${Program.cnField.frequency}：</td>
                            <td>${program?.frequency}</td>
                        </tr>
                        <g:if test="${program?.programTags?.size() > 0}">
                            <tr>
                                <td width="100" align="left">${Program.cnField.programTags}:</td>
                                <td>
                                    <g:each in="${program?.programTags}" var="tags">
                                        ${tags?.name}
                                    </g:each>
                                </td>
                            </tr>
                        </g:if>
                        <tr>
                            <td width="100" align="top">${Program.cnField.description}:</td>
                            <td>
                                <g:if test="${program?.description == ""}">
                                    <p>暂无简介</p>
                                </g:if>
                                <g:else>
                                    <p>${CTools.htmlToBlank(program?.description)}</p>
                                </g:else>
                            </td>
                        </tr>
                        </tbody>
                    </table>

                    <table id="metaContTab"></table>

                </div>

                <div class="bot-item" style="display: none">
                    <table>
                        <tbody>
                        <tr>
                            <td width="100" align="left">网页地址：</td>
                            <td><input type="text" name="" value="${basePath}"></td>
                            <td width="100" align="right"><span>[当前网页地址]</span></td>
                        </tr>
                        <tr>
                            <td width="100" align="left">资源名称:</td>
                            <td>
                                <label>
                                    <g:if test="${serial != null}">
                                        <input class="desc_share_in" name="desc_share_in1" type="text"
                                               value="${playLinksNew2(serialId: serial?.id)}"></g:if>
                                </label>
                            </td>
                            <td width="100" align="right"><span>[当前视频地址]</span></td>
                        </tr>
                        <tr>
                            <td width="100" align="left">内嵌代码:</td>
                            <td><input type="text" name=""
                                       value="<iframe width=700 height=400 id='embedPlayFrame' src='${playLinksNew2(serialId: serial?.id)}' />">
                            </td>
                            <td width="100" align="right"><span>[内嵌视频地址]</span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>