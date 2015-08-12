<%@ page import="nts.utils.CTools; nts.program.domain.Serial; nts.program.domain.Program; nts.meta.domain.MetaContent" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>nts.program.domain.Program</title>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" rel="stylesheet" type="text/css">
    <link href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'proto.menu.0.6.css')}" type="text/css" media="screen"/>

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/truevod.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/meta.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/metalist.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'proto.menu.0.6.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'showProgram.js')}"></script>

    <SCRIPT LANGUAGE="JavaScript">
        <!--
        //全局变量
        var contentList = new Array();
        var metaList = new Array();
        var wtab;
        var gDisciplineId = "${application.metaDisciplineId}";
        var gProgramId = ${program?.id};

        //初始化,prototype没有
        //window.onload = init;

        function init() {
            wtab = document.getElementById("metaContTab");
            setCurMetaList(${program?.directory?.id}, 1, -1);//显示当前类下可摘要显示
            showAllTr();
            setPlayTrShow();
            setImgNum();

            document.getElementById("bodyDiv").style.display = "block";
        }

        <g:each in="${program.metaContents}" status="i" var="metaContent">
        contentList[${i}] = new CContentTypeObj(${metaContent.id}, ${metaContent.metaDefine.id}, ${metaContent.metaDefine.parentId}, ${MetaContent.numDataTypes.contains(metaContent.metaDefine.dataType)?1:2}, ${metaContent.numContent}, '${CTools.nullToBlank(metaContent.strContent).encodeAsJavaScript()}');
        </g:each>

        //-->
    </SCRIPT>
</head>

<body>

<div class="body" id="bodyDiv" style="display:none;margin:0px;">

    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>

<!--资源信息开始-->
    <div class="categoryTitle">${Program.cnTableName}信息</div>
    <table id="progInfo" border="0" width="100%" border="0" cellspacing="1">
        <tr>
            <td id="posterTd">
                <img src="${posterLink(serials: program?.serials, isAbbrImg: false)}">
            </td>
            <td id="progInfoTd">
                <table border="0" width="99%" id="metaContTab" style="border-collapse:collapse">
                    <tr>
                        <td colspan="2">
                            <img src="${createLinkTo(dir: 'images/skin', file: 'collect.gif')}" border=0>
                            <a href="#" onClick="showDiv('collectProgram')">我要收藏</a>&nbsp;&nbsp;&nbsp;
                        <g:remoteLink action="recommendProgram" id="${program?.id}">我要推荐</g:remoteLink>&nbsp&nbsp;&nbsp;
                            <a href="#" onClick="showDiv('correctError')">我要纠错</a>&nbsp&nbsp;&nbsp;
                        </td>
                    </tr>

                    <!-- 元数据
			
			-->
                    <tr>
                        <td class="key">${Program.cnField.dateCreated}</td>
                        <td class="value"><g:formatDate format="yyyy-MM-dd" date="${program?.dateCreated}"/></td>
                    </tr>
                    <!--<tr>
				<td class="key">${Program.cnField.consumer}</td>
				<td><g:link action="linkView"
                            params="[type: 1, keyword: program?.consumer.id, cnName: program?.consumer.nickname]">${program?.consumer.nickname.encodeAsHTML()}</g:link></td>
			</tr>-->
                    <tr>
                        <td class="key">统计</td>
                        <td>${Program.cnField.frequency}：${program?.frequency} 下载次数：${program?.downloadNum} 推荐次数：${program?.recommendNum}</td>
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
                </table>
            </td>
        </tr>
        <g:if test="${program?.serials.size() > 0}">
            <tr id="playTr">
                <td colspan="2" id="playTd"><b>播放资源</b>：鼠标点击播放链接即可播放资源,鼠标右键可复制播放链接,粘贴到PPT或WORD文档等。
                <g:playLinks programId="${program.id}" serials="${program?.serials}" isPlay="1"/>
                </td>
            </tr>
            <g:if test="${program?.canDownload}">
                <tr id="downTr">
                    <td colspan="2" id="downTd"><b>下载资源</b>：
                    <g:playLinks programId="${program.id}" serials="${program?.serials}" isPlay="0"/>
                    </td>
                </tr>
            </g:if>
        </g:if>
        <tr>
            <td colspan="2">简介：</td>
        </tr>
        <tr>
            <td colspan="2" class="desc" style="padding-left:10px;"><div
                    style="padding:5px;border:1px solid #ccc;">${CTools.codeToHtml(program?.description)}</div></td>
        </tr>

    </table>
<!--资源信息结束-->

<!--图片开始-->
    <g:if test="${program?.serials.size() > 0}">
        <div id="imgDiv">
            <div class="categoryTitle">图片资源</div>
            <!--当前图片开始-->
            <DIV id="curImgDiv" class="bg" style="POSITION: relative;margin:2px 4px 2px 4px;display:none;">
                <DIV class="rg1"></DIV>

                <DIV class="rg2"></DIV>

                <DIV class="t1"><DIV class="leftTit" style="float:left;">图片</DIV>

                    <DIV class="closeBtn" style="padding:5px 5px 2px 2px;float:right;"><img
                            src="${resource(dir: 'images/skin', file: 'closeWnd.gif')}" onclick="hideImgWnd();" alt="关闭"></DIV></DIV>

                <DIV class="bc">
                    <div align="center"><img id="curImg" onMouseMove="onImg(this, 3);" onmouseover="onImg(this, 1);"
                                             onmouseout="onImg(this, 2);" onclick="onImg(this, 0);"
                                             onload="javascript:resizeImg(this, 840, 1100);"
                                             src="http://localhost:1680/iclass2/123_0_0_0/ZjovcHViL21hc3Rlci9saWIxL8TjusMuanBn@/frame.htm">
                    </div>

                    <div style="padding:4px 2px 2px 2px;" align="center"><img style="cursor:pointer;"
                                                                              src="${resource(dir: 'images/skin', file: 'bn_prev.gif')}"
                                                                              border="0" align="absmiddle"
                                                                              onmouseover="this.src = '${resource(dir: 'images/skin', file: 'bn_prev_o.gif')}'"
                                                                              onmouseout="this.src = '${resource(dir: 'images/skin', file: 'bn_prev.gif')}'"
                                                                              onclick="toImg(-1);">&nbsp;&nbsp;
                        <img style="cursor:pointer;" src="${resource(dir: 'images/skin', file: 'bn_next.gif')}" border="0" align="absmiddle"
                             onmouseover="this.src = '${resource(dir: 'images/skin', file: 'bn_next_o.gif')}'"
                             onmouseout="this.src = '${resource(dir: 'images/skin', file: 'bn_next.gif')}'" onclick="toImg(1);">&nbsp;&nbsp;<img
                            style="cursor:pointer;" src="${resource(dir: 'images/skin', file: 'close_btn.gif')}" onclick="hideImgWnd();"></div>
                </DIV>

                <DIV class="rg3"></DIV>

                <DIV class="rg4"></DIV>
            </DIV>
            <!--当前图片结束-->
            <g:imgLinks programId="${program.id}" serials="${program?.serials}" cols="${application.AbbrImgRowPerNum}"/>
        </div>
    </g:if>
<!--图片结束-->

<!--相关资源开始-->
    <g:if test="${program.relationPrograms && program.relationPrograms.size() > 0}">
        <div class="categoryTitle">相关资源</div>
        <g:relationProgramLinks programList="${program.relationPrograms.toList()}"/>
    </g:if>
<!--相关资源结束-->

<!--点播了此资源的用户开始-->
    <g:if test="${consumerList}">
        <div class="categoryTitle">点播了此资源的用户</div>
        <g:consumerLinks consumerList="${consumerList}"/>
    </g:if>
<!--点播了此资源的用户结束-->

<!--点播了此资源的用户还点播了开始-->
    <g:if test="${otherProgramList}">
        <div class="categoryTitle">点播了此资源的用户还点播了</div>
        <g:otherProgramLinks otherProgramList="${otherProgramList}"/>
    </g:if>
<!--点播了此资源的用户还点播了结束-->

<!--资源评论开始-->
    <div class="categoryTitle">最新评论&nbsp&nbsp;<g:if test="${session.consumer?.canComment}"><img align="absmiddle"
                                                                                                style="cursor:pointer;"
                                                                                                src="${createLinkTo(dir: 'images/skin', file: 'wyfb.gif')}"
                                                                                                onclick="showRemarkPost();"></g:if>
    </div>

    <div id="remark" style="margin:8px 0px 10px 0px;">
        <div id="remarkPost" style="display:none">
            <table border="0" width="100%">
                <g:formRemote name="remarkForm" update="remarkList"
                              url="[action: 'saveRemark', params: ['program.id': program?.id]]"
                              after="hideRemarkPost();">
                    <tr>
                        <td id="radio"><font style="color:#ff6600">打分-></font>&nbsp;
                            <input type="radio" value="5" name="rank"><img
                                src="${createLinkTo(dir: 'images/skin', file: 'stars5.gif')}" border=0>&nbsp;&nbsp;
                            <input type="radio" value="4" name="rank"><img
                                src="${createLinkTo(dir: 'images/skin', file: 'stars4.gif')}" border=0>&nbsp;&nbsp;
                            <input type="radio" value="3" name="rank" checked><img
                                src="${createLinkTo(dir: 'images/skin', file: 'stars3.gif')}" border=0>&nbsp;&nbsp;
                            <input type="radio" value="2" name="rank"><img
                                src="${createLinkTo(dir: 'images/skin', file: 'stars2.gif')}" border=0>&nbsp;&nbsp;
                            <input type="radio" value="1" name="rank"><img
                                src="${createLinkTo(dir: 'images/skin', file: 'stars1.gif')}" border=0>
                        </td>
                    </tr>
                    <tr>
                        <td>主题：<input type="text" name="topic" size="60"></td>
                    </tr>
                    <tr>
                        <td>内容：</td>
                    </tr>
                    <tr>
                        <td style="padding-left:40px;"><textarea name="content"
                                                                 style="width:550px;height:60px;"></textarea></td>
                    </tr>
                    <tr>
                        <td align="center">小提示:您要为您发表的言论后果负责，请各位遵守法纪注意语言文明&nbsp;&nbsp;&nbsp;&nbsp;<input type="image"
                                                                                                         style="border:0px;height:22px;width:85px"
                                                                                                         align="absmiddle"
                                                                                                         src="${createLinkTo(dir: 'images/skin', file: 'fb.gif')}"
                                                                                                         onclick="return checkRemark();">&nbsp;<img
                                align="absmiddle" style="cursor:pointer;"
                                src="${createLinkTo(dir: 'images/skin', file: 'qx.gif')}" onclick="hideRemarkPost();">
                        </td>
                    </tr>

                </g:formRemote>
            </table>
        </div>
        <g:render template="remarkList" model="[remarkList: remarkList]"/>
    </div>
    <!--资源评论结束-->

</div>

<!--收藏开始-->
<DIV id="collectProgram" class="bg" style="width:300px;display:none;">
    <DIV class="rg1"></DIV>

    <DIV class="rg2"></DIV>

    <DIV class="t1">收藏</DIV>

    <DIV class="bc">

        <g:formRemote method="post" name="collectProgramForm" url="[action: 'collectProgram']"
                      before="hideWnd('collectProgram');">
            <input type="hidden" name="id" value="${program.id}">

            <div class="dialog">
                <table style="width:250px;">
                    <tbody>

                    <tr class="prop">
                        <td colspan="2" class="name">
                            <label for="tag">收藏选项设置</label>
                        </td>

                    </tr>

                    <tr class="prop">
                        <td class="name">
                            <label for="tag">个性标签:</label>
                        </td>
                        <td>
                            <input type="text" id="tag" style="width:200px;" maxlength="10" name="tag" value=""/>
                        </td>
                    </tr>

                    </tbody>
                </table>
            </div>

            <div align="center" style="margin-top:6px;">
                <g:submitButton name="upbtn" style="cursor:pointer;width:40px;" value="确定"
                                onclick="return checkCollect(this.form);"/>&nbsp;<input type="button"
                                                                                        onclick="hideWnd('collectProgram');"
                                                                                        style="cursor:pointer;width:40px;"
                                                                                        value="关闭">
            </div>
        </g:formRemote>

    </DIV>

    <DIV class="rg3"></DIV>

    <DIV class="rg4"></DIV>
</DIV>
<!--收藏结束-->

<!--纠错开始-->
<DIV id="correctError" class="bg" style="width:390px;display:none;">
    <DIV class="rg1"></DIV>

    <DIV class="rg2"></DIV>

    <DIV class="t1">纠错</DIV>

    <DIV class="bc">

        <g:formRemote method="post" name="correctErrorForm" url="[action: 'correctError']"
                      before="hideWnd('correctError');">
            <div class="dialog">
                <table>
                    <tbody>

                    <tr class="prop">
                        <td class="name">
                            <label for="errorTitle">错误标题:</label>
                        </td>
                        <td>
                            <input type="text" id="errorTitle" style="width:200px;" maxlength="100" name="errorTitle"
                                   value=""/>
                        </td>
                    </tr>

                    <tr class="prop">
                        <td class="name">
                            <label for="errorContent">错误内容:</label>
                        </td>
                        <td>
                            <textarea style="width:292px;height:60px;" name="errorContent"></textarea>
                        </td>
                    </tr>

                    </tbody>
                </table>
            </div>

            <div align="center" style="margin-top:6px;">
                <g:submitButton name="upbtn" style="cursor:pointer;width:40px;" value="确定"
                                onclick="return checkError(this.form);"/>&nbsp;<input type="button"
                                                                                      onclick="hideWnd('correctError');"
                                                                                      style="cursor:pointer;width:40px;"
                                                                                      value="关闭">
            </div>
        </g:formRemote>

    </DIV>

    <DIV class="rg3"></DIV>

    <DIV class="rg4"></DIV>
</DIV>
<!--纠错结束-->

<!--文件信息开始-->
<DIV id="fileInfo" class="bg" style="width:250px;display:none;">
    <DIV class="rg1"></DIV>

    <DIV class="rg2"></DIV>

    <DIV class="t1">文件信息</DIV>

    <DIV class="bc" id="fileInfoBC">

    </DIV>

    <DIV class="rg3"></DIV>

    <DIV class="rg4"></DIV>
</DIV>
<!--文件信息结束-->

<!--选择集数开始-->
<DIV id="batchPlay" class="bg" style="width:400px;display:none;">
    <DIV class="rg1"></DIV>

    <DIV class="rg2"></DIV>

    <DIV class="t1"><DIV class="leftTit" style="float:left;">选择资源</DIV>

        <DIV class="closeBtn" style="padding:5px 5px 2px 2px;float:right;"><img src="${resource(dir: 'images/skin', file: 'closeWnd.gif')}"
                                                                                onclick="hideWnd('batchPlay');"
                                                                                alt="关闭"></DIV></DIV>

    <DIV class="bc" id="batchPlayBC">
        <form name="batchPlayForm" action="">
            <div style="margin:8px 6px 2px 4px;">请在下面选择资源：</div>
            <table id="batchPlayTab">
                <tr>
                    <th align="center">选择</td>
                    <th align="center">序号</td>
                    <th align="center">名称</td>
                </tr>
                <g:findAll in="${program?.serials}" expr="it.urlType == nts.program.domain.Serial.URL_TYPE_VIDEO">
                    <tr>
                        <td align="center" width="40"><input type="checkbox" checked style="border:0px;" name="idList"
                                                             value="${it.id}" onclick="unCheckAll('selall');"
                                                             id="idList"/></td>
                        <td align="center" width="50">${it.serialNo}</td>
                        <td>${it.name}</td>
                    </tr>
                </g:findAll>

            </table>

            <div align="center" style="margin-top:6px;">
                <input id="selall" style="border:0px;" name="selall" onclick="checkAll(this, 'idList')" checked
                       type="checkbox">全选 <input type="button" style="cursor:pointer;width:70px;" value="播放所选"
                                                 onclick="batchPlay(this.form, 1);"/>&nbsp;<input type="button"
                                                                                                  style="cursor:pointer;width:90px;"
                                                                                                  value="复制所选链接"
                                                                                                  onclick="batchPlay(this.form, 0);"/>&nbsp;<input
                    type="button" onclick="hideWnd('batchPlay');" style="cursor:pointer;width:40px;" value="关闭">
            </div>
        </form>
    </DIV>

    <DIV class="rg3"></DIV>

    <DIV class="rg4"></DIV>
</DIV>
<!--选择集数结束-->

<SCRIPT LANGUAGE="JavaScript">
    <!--
    init();
    //-->
</SCRIPT>

</body>
</html>
