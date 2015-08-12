<%@ page import="nts.utils.CTools; nts.system.domain.SysConfig; nts.program.domain.Program" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title><g:message code="application.name" default="确然多媒体资源应用系统"/></title>
    <link type="text/css" rel="stylesheet" href="../css/index.css"/>

    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/admin/Base64.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/truevod.js')}"></script>
    <script language="javascript">
        var isAnony = ${(session.consumer == null || session.consumer.name == 'anonymity')?"true":"false"};//是否匿名用户
        //tabcount = 0;//
        ${cateTopList?.size()};//tab.js中的变量,tab条数
        function selectPage(opt) {
            if (isAnony) {
                if (opt == 4) {
                    alert("匿名用户不能进入个人空间，请先登录");
                    return;
                }
                else if (opt == 6) {
                    alert("匿名用户不能进入主题社区，请先登录");
                    return;
                }
            }

            document.pageForm.selectPage.value = opt;
            document.pageForm.action = baseUrl + "index/main";
            document.pageForm.submit();
        }
        function showTab(opt) {
            if (opt == '1') {
                document.getElementById('title1').style.display = "";
                document.getElementById('tab1').style.display = "";
                document.getElementById('more1').style.display = "";
                document.getElementById('title2').style.display = "none";
                document.getElementById('tab2').style.display = "none";
                document.getElementById('more2').style.display = "none";
            }
            if (opt == '2') {
                document.getElementById('title1').style.display = "none";
                document.getElementById('tab1').style.display = "none";
                document.getElementById('more1').style.display = "none";
                document.getElementById('title2').style.display = "";
                document.getElementById('tab2').style.display = "";
                document.getElementById('more2').style.display = "";
            }
        }

        function warning() {
            var stat =${canPlay};
            if (!stat) {
                alert("没有登录，不能操作！");
            }
        }
        function userLogin() {
            if (document.logFrm.name.value == "") {
                alert("请输入用户名");
                document.logFrm.name.focus();
                return false;
            }
            if (document.logFrm.password.value == "") {
                alert("请输入密码");
                document.logFrm.password.focus();
                return false;
            }
            document.logFrm.action = baseUrl + "index/login";
            document.logFrm.submit();
        }
        function password_keyPress() {
            if (event.keyCode == 13) {
                userLogin();
            }
        }

        function logout() {
            document.pageForm.action = baseUrl + "index/logout";
            document.pageForm.submit();
        }

        function programMore(type) {
            var stat =${canPlay};
            if (!stat) {
                alert("没有登录，不能浏览！");
                return false;
            }

        }
        function getFocus() {
            var frm = document.getElementById("logFrm");
            if (frm) {
                document.logFrm.name.focus();
            }

        }

        function toLib(classLibId) {
            pageForm.classLibId.value = classLibId;
            selectPage(2);
        }

        function submitSimpleSch() {
            var serverNode = document.getElementsByName("serverNode")
            if (serverNode != null && serverNode.length > 1) {
                if (serverNode[1].checked && serverNode[1].value == 1) {
                    document.form2.selectPage.value = "100"
                    document.form2.action = "http://${application.provinceIp}:${application.provinceWebPort}/index/checkLogin?name=anonymity&password=&from=search"
                } else {
                    document.form2.action = baseUrl + "index/main"
                }
            }
            document.form2.submit();
        }

        function init() {

            <g:if test="${flash.approvalAlert}">
            if (window.confirm("您好，有新资源等待您审批，是否转到审批列表页面？")) {
                selectPage(9);
            }
            </g:if>
        }

        function play(id) {
            var Url = baseUrl + "courseBcast/liveInfo?id=" + id;
            if (document.playWnd) {
                if (document.playWnd.closed == false)
                    document.playWnd.close();
            }

            document.playWnd = OpenWindowEx(Url, screen.height, screen.width, "频道信息");
        }

    </script>

</head>

<body>
<form name="pageForm" method="POST" action="main">
    <input type="hidden" name="selectPage" value="2">
    <input type="hidden" name="classLibId" value="0">
</form>

<div class="x_max">
<div class="x_top">
    <div class="x_logo"></div>

    <div class="x_nav">
        <div class="x_menu">
            <a href="index" onfocus="this.blur();" class="x_sel">首页</a>
            <a href="javascript:selectPage(2);" onfocus="this.blur()" class="x_noSel">资源浏览</a>
            <a href="javascript:selectPage(3);" onfocus="this.blur()" class="x_noSel">资源检索</a>
            <a href="javascript:selectPage(4);" onfocus="this.blur()" class="x_noSel">个人空间</a>
            <g:if test="${application.distributeModState == 0 || application.centerGrade < SysConfig.CENTER_GRADE_COUNTY}">
                <a href="javascript:selectPage(5);" onfocus="this.blur()" class="x_noSel">学习园地</a>
                <a href="javascript:selectPage(6);" onfocus="this.blur()" class="x_noSel">主题社区</a>
            </g:if>
            <g:if test="${session.consumer.role < 2}">
                <a href="javascript:selectPage(9);" onfocus="this.blur()" class="x_noSel">后台管理</a>
            </g:if>
            <a href="javascript:logout();" onfocus="this.blur()" class="x_noSel" style="background:none;">退出</a>

        </div>

    </div>

</div>

<div class="x_content">
<div class="x_contentLeft">
    <!--搜索S-->
    <div class="x_search">
        <form name="form2" action="/index/main" method="post">
            <input type="hidden" name="selectPage" value="100">

            <div>
                <span>搜索:</span>
                <span>
                    <select name="type">
                        <option value="1">${Program.cnField.name}</option>
                        <option value="2">${Program.cnField.actor}</option>
                        <option value="4">${Program.cnField.programTags}</option>
                        <option value="5">${Program.cnField.description}</option>
                    </select>
                </span>
                <span><input type="text" id="keyword" name="keyword" maxlength="40"/></span>
                <span><button class="x_searchB" onclick="submitSimpleSch();"></button></span>
            </div>
            <g:if test="${application.distributeModState == 1 && application.centerGrade > 2}">
                <div class="x_searchP">
                    <input type="radio" name="serverNode" value="0" checked="checked"/>本地
                    <input type="radio" name="serverNode" value="1"/>全省
                </div>
            </g:if>
        </form>
    </div>
    <!--搜索E-->


    <!--直播课堂S-->
    <div class="x_case">
        <div class="x_CaseTitle">
            <span class="x_CaseTitleL">直播课堂</span>
            <span class="x_more"><a href="programMore?sort=recommendNum&order=desc" target="_blank">更多>></a></span>
        </div>

        <div class="x_CaseCenter">
            <ul>
                <% for (int n = 1; n < 9; n++) { %>

                <li style="float:left;width:140px;height:22px;border-bottom:1px dotted #aaa;margin:10px 10px 2px 10px;overflow:hidden;">
                    <span style="float:left; text-align:left;width:118px;overflow:hidden;">大学英语四级频道</span>
                    <span style="float:left; text-align:left;width:20px;overflow:hidden;"><img
                            src="${resource(dir: 'images/skin', file: 'play1.jpg')}" style="cursor:pointer;" onclick="play();"></span>
                </li>
                <% } %>
            </ul>
        </div>

        <div class="x_CaseBottom"></div>
    </div>
    <!--直播课堂E-->

    <!--热门推荐S-->
    <div class="x_case">
        <div class="x_CaseTitle">
            <span class="x_CaseTitleL">热门推荐</span>
            <span class="x_more"><a href="programMore?sort=recommendNum&order=desc" target="_blank">更多>></a></span>
        </div>

        <div class="x_CaseCenter">
            <g:each in="${remProgramList}" var="program">
                <div class="x_colum">
                    <p class="x_pImg">
                        <a title="${program?.name}" href="../program/showProgram?id=${program?.id}" target="_blank"><img
                                src='${posterLink(serials: program?.serials, isAbbrImg: true)}'/></a>
                    </p>

                    <p class="x_pTitle"><a title="${fieldValue(bean: program, field: 'name')}"
                                           href="../program/showProgram?id=${program.id}"
                                           target="_blank">${CTools.cutString(fieldValue(bean: program, field: 'name'), 7)}</a>
                    </p>

                    <p class="x_pContent">${CTools.cutString(CTools.htmlToBlank(program.description), 32)}</p>

                </div>
            </g:each>
        </div>

        <div class="x_CaseBottom"></div>
    </div>
    <!--热门推荐E-->

    <!--点播排行S-->

    <div class="x_case">
        <div class="x_CaseTitle">
            <span class="x_CaseTitleL">${Program.cnTableName}排行</span>
            <span class="x_more"></span>
        </div>

        <div class="x_CaseCenter ">
            <div class="x_BannerContent llph x_listDiv">
                <% program = freProgramList[0] %>
                <div class="x_firstLeft">
                    <div class="x_firstImg">
                        <a title="${fieldValue(bean: program, field: 'name')}"
                           href="../program/showProgram?id=${program?.id}" target="_blank">
                            <img src="${posterLink(serials: program?.serials, isAbbrImg: true)}"/>
                        </a>
                    </div>

                    <div class="x_firstFont">
                        <a title="${fieldValue(bean: program, field: 'name')}"
                           href="../program/showProgram?id=${program?.id}"
                           target="_blank">${CTools.cutString(fieldValue(bean: program, field: 'name'), 12)}</a> <BR>
                        ${Program.cnField.actor}：${CTools.cutString(fieldValue(bean: program, field: 'actor'), 10)}<BR>
                        ${Program.cnField.dateCreated}：<g:formatDate format="yyyy-MM-dd"
                                                                     date="${program?.dateCreated}"/><BR>
                        ${Program.cnField.frequency}：${fieldValue(bean: program, field: 'frequency')}
                    </div>

                </div>
                <ul>
                    <% for (int j = 1; j < 4 && j < freProgramList.size(); j++) { %>
                    <% program = freProgramList[j] %>
                    <li>
                        <b class="x_onePic"></b>
                        <span class="x_content_llph"><a title="${fieldValue(bean: program, field: 'name')}"
                                                        href="../program/showProgram?id=${program?.id}"
                                                        target="_blank">${
                                    CTools.cutString(fieldValue(bean: program, field: 'name'), 16)}</a></span>
                        <span class="x_date">${fieldValue(bean: program, field: 'frequency')}</span>
                    </li>
                    <% } %>
                </ul>
            </div>

            <div class="x_BannerContent llph x_listDiv" style="border:0;">
                <ul>
                    <% for (int j = 4; j < 12 && j < freProgramList.size(); j++) { %>
                    <% program = freProgramList[j] %>
                    <li>
                        <b class="x_onePic"></b>
                        <span class="x_content_llph"><a title="${fieldValue(bean: program, field: 'name')}"
                                                        href="../program/showProgram?id=${program?.id}"
                                                        target="_blank">${
                                    CTools.cutString(fieldValue(bean: program, field: 'name'), 16)}</a></span>
                        <span class="x_date">${fieldValue(bean: program, field: 'frequency')}</span>
                    </li>
                    <% } %>
                </ul>
            </div>

        </div>

        <div class="x_CaseBottom"></div>
    </div>

<!--点播排行E-->

<!--探索频道S-->
    <g:each in="${directoryList}" status="i" var="directory">
        <div class="x_case">
            <div class="x_CaseTitle">
                <span class="x_CaseTitleL">${fieldValue(bean: directory, field: 'name')}</span>
                <span class="x_more"><a href="javascript:toLib(${directory.id});">更多>></a></span>
            </div>

            <div class="x_CaseCenter ">
                <div class="x_BannerContent llph x_listDiv">
                    <% program = cateProgramList[i][0] %>
                    <div class="x_firstLeft">
                        <div class="x_firstImg">
                            <g:if test="${program}">
                                <a title="${fieldValue(bean: program, field: 'name')}"
                                   href="../program/showProgram?id=${program?.id}" target="_blank">
                                    <img src="${posterLink(serials: program?.serials, isAbbrImg: true)}"/>
                                </a>
                            </g:if>
                            <g:else>
                                <img src="${posterLink(serials: program?.serials, isAbbrImg: true)}"/>
                            </g:else>
                        </div>

                        <div class="x_firstFont">
                            <a title="${fieldValue(bean: program, field: 'name')}"
                               href="../program/showProgram?id=${program?.id}"
                               target="_blank">${CTools.cutString(fieldValue(bean: program, field: 'name'), 12)}</a> <BR>
                            ${Program.cnField.actor}：${CTools.cutString(fieldValue(bean: program, field: 'actor'), 10)}<BR>
                            ${Program.cnField.dateCreated}：<g:formatDate format="yyyy-MM-dd"
                                                                         date="${program?.dateCreated}"/><BR>
                            ${Program.cnField.frequency}：${fieldValue(bean: program, field: 'frequency')}
                        </div>

                    </div>
                    <ul>
                        <% for (int j = 1; j < 4 && j < cateProgramList[i].size(); j++) { %>
                        <% program = cateProgramList[i][j] %>
                        <li>
                            <b class="x_onePic"></b>
                            <span class="x_content_llph"><a title="${fieldValue(bean: program, field: 'name')}"
                                                            href="../program/showProgram?id=${program?.id}"
                                                            target="_blank">${
                                        CTools.cutString(fieldValue(bean: program, field: 'name'), 16)}</a></span>
                            <span class="x_date"><g:formatDate format="MM-dd" date="${program.dateCreated}"/></span>
                        </li>
                        <% } %>
                    </ul>
                </div>

                <div class="x_BannerContent llph x_listDiv" style="border:0;">
                    <ul>
                        <% for (int j = 4; j < 12 && j < cateProgramList[i].size(); j++) { %>
                        <% program = cateProgramList[i][j] %>
                        <li>
                            <b class="x_onePic"></b>
                            <span class="x_content_llph"><a title="${fieldValue(bean: program, field: 'name')}"
                                                            href="../program/showProgram?id=${program?.id}"
                                                            target="_blank">${
                                        CTools.cutString(fieldValue(bean: program, field: 'name'), 16)}</a></span>
                            <span class="x_date"><g:formatDate format="MM-dd" date="${program.dateCreated}"/></span>
                        </li>
                        <% } %>
                    </ul>
                </div>

            </div>

            <div class="x_CaseBottom"></div>
        </div>
    </g:each>
<!--探索频道E-->

</div>

<div class="x_contentRight">

<!--在线帮助S-->
<div class="x_rightFirst">
    <span><a href="/help/" target="_blank">在线帮助</a></span><span>|</span><span><a
        href="javascript:selectPage(8);">问题反馈</a></span>
    <span style="margin-left:12px;"><a href="register"><img src="${resource(dir: 'images/skin', file: 'free_l.gif')}"/></a></span>
    <span><a href="login"><img src="${resource(dir: 'images/skin', file: 'login.gif')}"/></a></span>
</div>
<!--在线帮助E-->

<!--欢迎登录用户S-->
<g:if test="${session.consumer && session.consumer.name != 'anonymity'}">
    <div class="x_welcome">
        <span>${session.consumer.nickname}您好，欢迎访问本系统！</span>
    </div>
</g:if>
<!--欢迎登录用户E-->

<!--其它频道S-->

<div class="x_otherweb">
    <g:each in="${directoryList}" status="i" var="directory">
        <a href="javascript:toLib(${directory.id});">${fieldValue(bean: directory, field: 'name')}</a>|<!--${(i % 3 == 2 || (i + 1) == directoryList.size()) ? "<br>" : "|"} -->
    </g:each>
</div>
<!--其它频道E-->
<!--最新公告S-->
<div class="x_rightBanner">
    <div class="x_rightBannerTop">
        <div class="x_titleH">
            <span class="x_titleHLeft x_zxgg">最新公告</span>
            <span class="x_titleHRight"><a href="newsMore?type=new" target="_blank">更多>></a></span>
        </div>

        <div class="x_BannerContent">
            <ul>
                <g:each in="${newsList}" status="i" var="news">
                    <li>
                        <span class="x_content_llph_news"><a href="showNews?id=${fieldValue(bean: news, field: 'id')}"
                                                             title="${fieldValue(bean: news, field: 'title')}"
                                                             target="_blank">${CTools.cutString(fieldValue(bean: news, field: 'title'), 11)}</a>
                        </span>
                        <span class="x_date"><g:formatDate format="MM-dd" date="${news.submitTime}"/></span>
                    </li>
                </g:each>
            </ul>

        </div>

    </div>

    <div class="x_rightBannerBottom"></div>
</div>
<!--最新公告E-->

<!--浏览排行S-->
<div class="x_rightBanner">
    <div class="x_rightBannerTop">
        <div class="x_titleH">
            <span class="x_titleHLeft x_llph">最新${Program.cnTableName}</span>
            <span class="x_titleHRight"><a href="javascript:toLib(0);">更多>></a></span>
        </div>

        <div class="x_BannerContent llph">
            <ul>
                <g:each in="${newProgramList}" status="i" var="program">
                    <li>
                        <b class="no${i + 1}"></b><span class="x_content_llph_left"><a
                            title="${fieldValue(bean: program, field: 'name')}"
                            href="../program/showProgram?id=${program?.id}"
                            target="_blank">${CTools.cutString(fieldValue(bean: program, field: 'name'), 12)}</a></span>
                        <span class="x_date"><g:formatDate format="MM-dd" date="${program.dateCreated}"/></span>
                    </li>
                </g:each>
            </ul>
        </div>

    </div>

    <div class="x_rightBannerBottom"></div>

</div>
<!--浏览排行E-->

<!--热点专题S-->
<div class="x_rightBanner">
    <div class="x_rightBannerTop">
        <div class="x_titleH">
            <span class="x_titleHLeft x_rdzt">热点专题</span>
            <span class="x_titleHRight"><a href="programTopicMore" target="_blank">更多>></a></span>
        </div>

        <div class="x_BannerContent">
            <ul>
                <g:each in="${programTopicList}" status="i" var="programTopic">
                    <li>
                        <span class="x_content_llph_topic"><g:link controller="index"
                                                                   title="${fieldValue(bean: programTopic, field: 'name')}"
                                                                   action="showProgramTopic" target="_blank"
                                                                   id="${programTopic.id}">${CTools.cutString(fieldValue(bean: programTopic, field: 'name'), 11)}</g:link></span>
                        <span class="x_date"><g:formatDate format="MM-dd" date="${programTopic.dateCreated}"/></span>
                    </li>
                </g:each>
            </ul>

        </div>

    </div>

    <div class="x_rightBannerBottom"></div>
</div>
<!--热点专题E-->
<!--外部资源S-->
<!--<div class="x_rightBanner">
				<div class="x_rightBannerTop">
					<div class="x_titleH">
						<span class="x_titleHLeft x_wbzy">外部资源</span>
						<span class="x_titleHRight"><a href="#">更多>></a></span>
					</div>
					<div class="x_BannerContent">
						<ul>
							<li><a href="#">系统</a></li>
							<li><a href="#">系统(12782)</a></li>
							<li><a href="#">系统</a></li>
						</ul>
					
					</div>
				
				</div>
				<div class="x_rightBannerBottom"></div>
			</div>-->
<!--外部资源E-->

<!--网络电视S-->
<g:if test="${channelList && channelList.size() > 0}">
    <div class="x_rightBanner">
        <div class="x_rightBannerTop">
            <div class="x_titleH">
                <span class="x_titleHLeft x_wlds">网络电视</span>
                <span class="x_titleHRight"><a href="channelMore" target="_blank">更多>></a></span>
            </div>

            <div class="x_BannerContent">
                <ul>
                    <g:each in="${channelList}" status="i" var="channel">
                        <li>
                            <span class="x_content_llph_courseBcast"><a
                                    href="showChannel?id=${fieldValue(bean: channel, field: 'id')}"
                                    title="${fieldValue(bean: channel, field: 'channelName')}" onfocus="this.blur()"
                                    target="_blank">${CTools.cutString(fieldValue(bean: channel, field: 'channelName'), 11)}</a>
                            </span>
                            <span class="x_content_llph_courseBcastPlay"><img src="${resource(dir: 'images/skin', file: 'play1.jpg')}"
                                                                              style="cursor:pointer;"
                                                                              onclick="NetPlay('${channel.channelName.encodeAsJavaScript()}', '${channel.bcastAddr.encodeAsJavaScript()}');">
                            </span>
                        </li>
                    </g:each>
                </ul>

            </div>

        </div>

        <div class="x_rightBannerBottom"></div>
    </div>
</g:if>
<!--网络电视E-->

<!--直播课堂B-->
<!--<g:if test="${courseBcastList && courseBcastList.size() > 0}">
    <div class="x_rightBanner">
        <div class="x_rightBannerTop">
            <div class="x_titleH">
                <span class="x_titleHLeft x_zbkt">直播课堂</span>
                <span class="x_titleHRight"><a href="courseBcastMore" target="_blank">更多>></a></span>
            </div>
            <div class="x_BannerContent">
                <ul>
    <g:each in="${courseBcastList}" status="i" var="courseBcast">
        <li>
              <span class="x_content_llph_courseBcast" ><g:link controller="index"
                                                                                    onfocus="this.blur()"
                                                                                    title="${fieldValue(bean: courseBcast, field: 'channel')}"
                                                                                    action="showCourseBcast"
                                                                                    target="_blank"
                                                                                    id="${courseBcast.id}">${CTools.cutString(fieldValue(bean: courseBcast, field: 'channel'), 11)}</g:link></span>
							      <span class="x_content_llph_courseBcastPlay" ><img src="${resource(dir: 'images/skin', file: 'play1.jpg')}" style="cursor:pointer;" onclick="play(${courseBcast?.id});"></span>
							</li>
    </g:each>
    </ul>

</div>

</div>
<div class="x_rightBannerBottom"></div>
</div>
</g:if>-->
<!--直播课堂B-->

<!--工具下载S-->
<div class="x_rightBanner">
    <div class="x_rightBannerTop">
        <div class="x_titleH x_downDT">
            <span class="x_titleHLeft x_downsSpan">工具下载</span>
            <span class="x_titleHRight"></span>
        </div>

        <div class="toolDown">
            <ul>
                <g:each in="${toolsList}" status="i" var="tools">
                    <li>
                        <g:if test="${tools.dirName == 'TruePlayer.exe'}">
                            <img src="${resource(dir: 'images/skin', file: 'anzhuang3.jpg')}"/>
                        </g:if>
                        <g:elseif test="${tools.dirName == 'upload.exe'}">
                            <img src="${resource(dir: 'images/skin', file: 'anzhuang2.jpg')}"/>
                        </g:elseif>
                        <g:else>
                            <img src="${resource(dir: 'images/skin', file: 'anzhuang1.jpg')}"/>
                        </g:else>
                        <a href="/downdir/${tools.dirName}"
                           title="${fieldValue(bean: tools, field: 'name')}">${CTools.cutString(fieldValue(bean: tools, field: 'name'), 10)}</a>
                    </li>
                </g:each>
            </ul>
        </div>
    </div>

    <div class="x_rightBannerBottom"></div>
</div>
<!--工具下载E-->

<!--本站统计S-->
<div class="x_rightBanner">
    <div class="x_rightBannerTop ">
        <div class="x_titleH x_downDT">
            <span class="x_titleHLeft x_tongji">本站统计</span>
        </div>

        <div class="x_BannerContent">
            <ul>
                <li>访问次数：<strong>${application.programViewSum}</strong>&nbsp;次</li>
                <li>点播次数：<strong>${application.programPlaySum}</strong>&nbsp;次</li>
                <li>资源总数：<strong>${application.programCount}</strong>&nbsp;个</li>
            </ul>
        </div>
    </div>

    <div class="x_rightBannerBottom"></div>
</div>
<!--本站统计E-->

</div>

<div class="x_contentBottom">
    <g:message code="application.bottom" default="确然多媒体资源应用系统"/>
</div>
</div>

</div>
</body>
</html>
