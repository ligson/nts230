<%@ page import="nts.utils.CTools; nts.program.domain.Program; nts.meta.domain.MetaContent" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta name="layout" content="index"/>
<link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css/skin', file: 'ny_main.css')}">
<link type="text/css" rel="stylesheet" href="${resource(dir: 'skin/blue/pc/front/css', file: 'index_common.css')}">
<link href="${resource(dir: 'css', file: 'hScrollPane.css')}" rel="stylesheet" type="text/css">
<title>点播页面</title>
<style type="text/css">
#metaContTab {
    width: 100%
}

#metaContTab TD {
    BORDER-BOTTOM: #e4e4e4 1px solid;
    BORDER-LEFT: #e4e4e4 1px solid;
    LINE-HEIGHT: 26px;
    BORDER-TOP: #e4e4e4 0px solid;
    BORDER-RIGHT: #e4e4e4 1px solid;
    padding-left: 7px;
}

.modulel .lists DL {
    MARGIN-TOP: 5px;
    WIDTH: 100%;
    FLOAT: left
}

.modulel .lists DL A {
    COLOR: #9a9a9a
}

.modulel .lists DL DT {
    TEXT-ALIGN: center;
    LINE-HEIGHT: 23px;
    WIDTH: 80px;
    BACKGROUND: url(/images/skin/xiazai.gif) no-repeat;
    FLOAT: left;
    HEIGHT: 23px;
    COLOR: #fff
}

.modulel .lists DL DD {
    BORDER-BOTTOM: #e3e3e3 1px solid;
    BORDER-LEFT: #e3e3e3 1px solid;
    PADDING-BOTTOM: 2px;
    MARGIN: 0px 5px;
    PADDING-LEFT: 4px;
    PADDING-RIGHT: 4px;
    FLOAT: left;
    BORDER-TOP: #e3e3e3 1px solid;
    BORDER-RIGHT: #e3e3e3 1px solid;
    PADDING-TOP: 2px
}

.modulel .lists DL DD .on {
    COLOR: #49b1fa
}

.tx img {
    margin: 8px;
    margin-top: 0;
    float: left;
    border: 1px solid #E3E3E3;
    padding: 2px;
    width: 70px;
    height: 70px;
}

.class0 {
    background-image: none;
    color: #333;
    font-weight: bold;
    padding-left: 15px;
}

.class1 {
    background-image: none;
    color: #333;
    font-weight: bold;
    padding-left: 15px;
}

.sharingDesc {
    margin: 15px 5px 5px 5px;
    font-weight: bold;
}

.sharing {
    margin: 2px 5px 5px 10px;
    line-height: 20px;
}

.share_text {
    height: 18px;
    width: 400px;
    padding: 2px;
    border: 1px solid;
    border-color: #CCC;
    background: #F5F5F5;
}

.share_btn {
    height: 24px;
    border: 1px solid;
    border-color: #CCC;
    background: #F5F5F5;
    margin-left: 20px;
    padding: 4px 8px 4px 8px
}

.ddt {
    font-weight: bold;
}



</style>

<script src="${resource(dir: 'js/qinghua', file: 'g.js')}" type="text/javascript"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery/jquery.mousewheel.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/hScrollPane.js')}"></script>

<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/truevod.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/meta.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/metalist.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js', file: 'boful/appMgr/showProgram.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/jwplayer', file: 'jwplayer.js')}"></script>
<script type="text/javascript">jwplayer.key = "ktWIk7l3bcd4z5Qe3GGwiYbMPu3Tu3Mhk2ifmbTkqLI=";</script>

<SCRIPT LANGUAGE="JavaScript" type="text/javascript">
    //全局变量
    var contentList = [];
    var metaList = [];
    var wtab;
    var gDisciplineId = "${application.metaDisciplineId}";
    var gProgramId = ${program?.id};
    var isOutPlay = false;//播放来自外部（省图下级节点）
    var gOutHost = "";//用于外部（省图下级节点）批量播放，host,如：http://192.168.1.13:80
    var gFromNodeId = 0;
    var gPosterImg = "${posterLinkNew(program: program,size:'670x340')}";
    var gAutoPlayTime = ${application.autoPlayTime == 0?30:application.autoPlayTime};
    var gLineList = "${application.lineList}";
    var gCanComment = ${session.consumer.canComment?"true":"false"}

            <g:if test="${isOutPlay}">
            isOutPlay = true;
    gOutHost = "http://${fromNode.ip}:${fromNode.webPort}";
    gFromNodeId =${fromNode.id};
    </g:if>

    //初始化,prototype没有
    //window.onload = init;
    function init() {

        wtab = document.getElementById("metaContTab");
        setSerialList();
        setCurMetaList(${program?.directory?.id}, 1, -1);//显示当前类下可摘要显示
        showAllTr();
        setPlayTrShow();
        setImgNum();
        //实例化播放器

        //initJWPlay();

        showSerialSlide();
        //document.getElementById("bodyDiv").style.display = "block";
        if (!canPlay) popBox(document.getElementById("player"));

    }


    <g:each in="${program.metaContents}" status="i" var="metaContent">
    contentList[${i}] = new CContentTypeObj(${metaContent.id}, ${metaContent.metaDefine.id}, ${metaContent.metaDefine.parentId}, ${MetaContent.numDataTypes.contains(metaContent.metaDefine.dataType)?1:2}, ${metaContent.numContent}, '${CTools.nullToBlank(metaContent.strContent).encodeAsJavaScript()}');
    </g:each>

    //页面层一
    /*function collectProgram() {
     $.layer({
     type: 1,

     title: ['收藏', true],
     closeBtn: [0, true],

     area: ['auto', 'auto'],
     shade: ['' , '' , false],
     offset: ['250px' , ''],
     page: {dom: '#collectProgram'}
     });

     $('#clctCloseBtn').live('click', function () {
     var index = layer.getIndex(this);
     layer.close(index);
     });

     }
     */
    $(function () {
        init();
        $("#program_nav").find("li").hover(function () {
            $(this).click();
        });

    });
</SCRIPT>
</head>

<body>
<div class="area" id="location" style="background-color:#F1F1F1">
    <div class="left ">
        <h1 class="color3 " style="margin-left: 10px;">${program.name.encodeAsHTML()}</h1>
    </div>
</div>

<!-- Start:area -->
<div class="area" id="contentA" style="background-color:#DDDDDD;padding-top: 5px;">
    <div class="left" style="margin-left: 5px;">
        <!-- Start:block -->
        <div id="picFocusout">

            <div class="area" sizcache="1" id="player"></div>
            <g:if test="${application.lineList && application.lineList.length() > 5}"><div
                    id="lineListDiv"></div></g:if>
            <div class="tab1cont" id="serialPhotosDiv" style="display: none;background: #fff; ">
                <div style="font-weight:bold;font-size: 14px;padding:8px 3px 0px 5px;margin-bottom: -10px;background: #eee;">集数列表</div>

                <div class="container2"><ul id="serialPhotosUl"></ul></div>
            </div>

            <div class="modulel left noborder">
                <div class="zy_dy" id="playClassDiv">
                    <dl id="playClassList">

                        <g:playLinks programId="${program.id}" serials="${program?.serials}" isPlay="1" size="700x360"/>
                    </dl>
                </div>

                <g:if test="${program?.canDownload}">
                    <div class="zy_dy" id="downClassDiv">
                        <dl id="downClassList">
                            <dd><span class="all">下载资源</span></dd>
                            <g:playLinks programId="${program.id}" serials="${program?.serials}" isPlay="0"/>
                        </dl>
                    </div>
                </g:if>

            </div>
        </div>

        <div class="blockLA bord clear" id="blockA" style="margin-top: 5px;">
            <div class="tab1 clear">
                <ul id="program_nav">
                    <li class="tk1 active"><a>资源信息</a></li>
                    <li class="tk2"><a>内容描述</a></li>
                    <li class="tk3"><a>评 论</a></li>
                    <li class="tk4"><a>分 享</a></li>
                </ul>
            </div>

            <div class="tab1line"></div>

            <!-- allist tab1cont -->
            <!--tab -->
            <div class="tab1cont" id="tabMetaCont" style="display: none; ">
                <TABLE style="BORDER-COLLAPSE: collapse" id=metaContTab border=0 width="546">
                    <TBODY>
                    <!-- <tr>
					<td colspan="2" class="tabstya">
					<a href="#" onClick="collectProgram()">• 我要收藏</a>&nbsp;&nbsp;&nbsp;
					<a href= baseUrl + "program/recommendProgram/${program?.id}" onclick="jQuery.ajax({type:'POST', url: baseUrl + 'program/recommendProgram/${program?.id}',success:function(data,textStatus){},error:function(XMLHttpRequest,textStatus,errorThrown){}});return false;" action="recommendProgram" id="12345">• 我要推荐</a>&nbsp&nbsp;&nbsp;
					<a href="#" onClick="showDiv('correctError')">• 我要纠错</a>&nbsp&nbsp;&nbsp;
					</td>
				</tr>		-->
                    <!-- 元数据	-->
                    <tr>
                        <td class="key">${Program.cnField.dateCreated}</td>
                        <td class="value"><g:formatDate format="yyyy-MM-dd" date="${program?.dateCreated}"/></td>
                    </tr>

                    <tr>
                        <td class="key">统计</td>
                        <td>${Program.cnField.frequency}：${program?.frequency}&nbsp;&nbsp;下载次数：${program?.downloadNum}&nbsp;&nbsp;推荐次数：${program?.recommendNum}</td>
                    </tr>

                    <tr>
                        <td class="key">${Program.cnField.programTags}</td>
                        <td>
                            <g:each in="${program?.programTags}" status="i" var="tag">
                                <g:link action="linkView"
                                        params="[type: 2, keyword: tag.id, cnName: tag?.name]">${tag?.name.encodeAsHTML()}</g:link>
                            </g:each>
                        </td>
                    </tr>
                    </TBODY>
                </table>
            </div>

            <div class="tab1cont" style="display: none; ">
                <div id="ablum2">
                    ${(program?.otherOption & Program.RICH_TEXT_OPTION) == Program.RICH_TEXT_OPTION ? CTools.nullToBlank(program?.description) : CTools.codeToHtml(program?.description)}
                </div>
            </div>

            <div class="tab1cont" style="display: none; ">
                <div class="wyPl clear" id="ablum5">
                    <div class="comment clear" id="tvcomments">
                        <form name="bbsForm"
                              onsubmit="remarkFormSubmit(${program.id})" method="post"
                              action="${createLink(controller: 'program', action: 'saveRemark', params: [programId: program?.id])}"
                              name="remarkForm" id="remarkForm">
                            <input type="hidden" name="topic" value="ok"/>
                            <textarea id="content" name="content" maxlength="280" class="ta"
                                      style="resize:vertical;"></textarea>

                            <div id="cclogin" class="login hidden clear" style="display: block; ">
                                <div id="commPP" class="l">
                                    请在上面发表您个人看法，发言时请遵守法纪注意文明!
                                </div>
                                <a id="postComment" class="submits_comment" href="#FB" onclick="submitRemark()">发评论</a>
                            </div>
                        </form>
                    </div>

                    <div id="commentlistg" class="colist">
                        <div class="com clear">
                            <g:render template="remarkList" model="[remarkList: remarkList]"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tab1cont" style="display: none; ">
                <div class="sharingDesc">说明：</div>

                <div class="sharing">1.分享给站外好友，把视频贴到Blog、BBS、word文档、ppt中。</div>
                <!--<div class="sharing">2.在播放地址和内嵌代码中，可通过startTime和endTime参数，设置播放起止点，时间格式：时:分:秒，为了规范统一为2位。<br>&nbsp;&nbsp;&nbsp;如：http://.....&startTime=01:02:03&endTime=02:03:04表示：播放1小时2分3秒至2小时3分4秒片段。<br><br></div>-->

                <div class="sharing">网页地址：<input type="text" id="shareUrl" name="shareUrl" class="share_text"
                                                 value=""><input class="share_btn" type="button" value="复制"
                                                                 onclick="copyToClipBoard('shareUrl');">&nbsp;(当前网页地址。)
                </div>

                <div class="sharing">播放地址：<input type="text" id="flashUrl" name="flashUrl" class="share_text"
                                                 value=""><input class="share_btn" type="button" value="复制"
                                                                 onclick="copyToClipBoard('flashUrl');">&nbsp;(当前视频地址。)
                </div>

                <div class="sharing">内嵌代码：<input type="text" id="shareEmbed" name="shareEmbed" class="share_text"><input
                        class="share_btn" type="button" value="复制"
                        onclick="copyToClipBoard('shareEmbed');">&nbsp;(内嵌视频地址。)</div>
            </div>
        </div>


        <div class="blank12H"></div>
    </div>
    <!--end left-->
    <!-- Start:right -->
    <div class="right" style="margin-right: 5px;">
        <div class="blockRA bord clear ">
            <h2><span>${program.name.encodeAsHTML()}</span></h2>

            <div class="cont">
                <p>${Program.cnField.actor}：${program.actor.encodeAsHTML()}</p>

                <p>${Program.cnField.director}：${fieldValue(bean: news, field: 'title')}</p>

                <div class="line1"></div>

                <p>${Program.cnField.directory}：${program?.directory?.name}</p>

                <p>${Program.cnField.programTags}：
                    <g:each in="${program?.programTags}" status="i" var="tag">
                        <g:link action="linkView"
                                params="[type: 2, keyword: tag.id, cnName: tag?.name]">${tag?.name.encodeAsHTML()}</g:link>
                    </g:each></p>

                <div class="line1"></div>

                <p>${Program.cnField.frequency}：${program.frequency}</p>

                <p>${Program.cnField.downloadNum}：${program.downloadNum}</p>

                <p>${Program.cnField.recommendNum}：${program.recommendNum}</p>

                <div class="line1"></div>

                <p>${Program.cnField.dateCreated}：<g:formatDate format="yyyy-MM-dd" date="${program?.dateCreated}"/></p>

                <div class="line1"></div>

            </div>
        </div>
        <!-- End:block -->
        <div class="blank12H"></div>

        <div class="blockRF bord clear">
            <h2><span>${program?.directory?.name}</span></h2>

            <div class="snList clear">
                <ul>
                    <g:each in="${topProgramList}" status="i" var="topProgram">
                        <li><span
                                class="num">${topProgram.frequency}次</span><em ${i < 2 ? 'class="colorA"' : ''}>${i + 1}</em><a ${i < 2 ? 'class="color1"' : ''}
                                href="${createLink(controller: 'program', action: 'showProgram', params: [id: topProgram?.id])}">${CTools.cutString(fieldValue(bean: topProgram, field: 'name'), 6)}</a>
                        </li>
                    </g:each>
                </ul>
            </div>
        </div>

        <div class="blank12H"></div>
    </div>
    <!-- End:right -->
</div>

</body>
</html>
