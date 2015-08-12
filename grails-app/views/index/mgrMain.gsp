<%@ page import="nts.system.domain.SysConfig" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title><g:message code="application.name" default="确然多媒体资源应用系统"/></title>
    <meta content="none" name="layout">
    <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
        <!--
        var isAnony = false;//是否匿名用户
        function MyLoadPage() {
            <g:if test="${application.distributeModState == 0 || application.centerGrade != SysConfig.CENTER_GRADE_TOWNSHIP}">
            mainFrame.location.href = "${createLinkTo(dir:'program',file:'programMgr')}";
            </g:if>
            <g:else>
            mainFrame.location.href = baseUrl + "news/appMgrIndex?appControl=news&appAction=list";
            </g:else>
        }
        //-->
    </SCRIPT>
    <script type="text/javascript">
        function setWindowSize() { //iframe自动本窗口高度
            try {
                var thiswin = window.parent.document.getElementById("mainFrame");
                if (window.document.body.scrollWidth - thiswin.offsetWidth > 6) {
                    document.body.style.overflowX = "auto";
                    thiswin.height = window.document.body.scrollHeight + 20;
                    thiswin.width = window.document.body.scrollWidth + 20;
                } else {
                    document.body.style.overflowX = "hidden";
                    thiswin.height = window.document.body.scrollHeight;
                    thiswin.width = window.document.body.scrollWidth
                }
            } catch (e) {
            }
        }
    </script>
</head>

<body onLoad="MyLoadPage();" style="margin-top:0px">
<div style="text-align:center;">
    <iframe src="${createLink(controller: 'shared', action: 'ntsManagerHead')}" style="width:100%; height:168px;"
            name="topFrame" id="topFrame" frameborder="0" scrolling="no"></iframe>
    <iframe src="" name="mainFrame" id="mainFrame" style="width:1000px;height:730px;" frameborder="0"></iframe>
    <iframe src="${createLink(controller: 'shared', action: 'ntsBottom')}" style="width:100%; height:82px;"
            name="bottomFrame" id="bottomFrame" frameborder="0" scrolling="no"></iframe>
</div>
</body>
</html>
