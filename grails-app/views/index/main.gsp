<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title><g:message code="application.name" default="确然多媒体资源应用系统"/></title>
    <meta content="none" name="layout"/>
    <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
        <!--
        var isAnony = false;//是否匿名用户
        function MyLoadPage(opt) {
            if (opt == 4 && isAnony) {
                alert("匿名用户不能进入个人空间，请先登录");
                return;
            }

            <g:if test="${flash.approvalAlert}">
            if (window.confirm("您好，有新资源等待您审批，是否转到审批列表页面？")) {
                opt = 9;
            }
            </g:if>

            if (!opt) {
                mainFrame.location.href = baseUrl + "program/directoryView";
                return;
            }

            switch (opt) {
                case 1:
                    top.location.href = baseUrl + "index/index";
                    break;
                case 2:
                    mainFrame.location.href = baseUrl + "program/directoryView";
                    break;
                case 3:
                    mainFrame.location.href = baseUrl + "search/searchInput";
                    break;
                case 4:
                    //mainFrame.location.href=baseUrl + "my/myIndex.gsp";
                    top.location.href = baseUrl + "my/myInfo";
                    break;
                case 5:
                    //mainFrame.location.href=baseUrl + "study/studyIndex";
                    //mainFrame.location.href=baseUrl + "studyCircle/index";//学习圈
                    location.href = baseUrl + "studyCircle/index";//学习圈
                    break;
                case 6:
                    top.location.href = baseUrl + "community/communityIndex";
                    break;
                case 7:
                    mainFrame.location.href = baseUrl + "shared/test.gsp";
                    break;
                case 8:
                    mainFrame.location.href = baseUrl + "question/questionIndex";
                    break;
                case 9:
                    top.location.href = "${createLinkTo(dir:'index',file:'mgrMain')}";
                    break;
                case 10:
                    mainFrame.location.href = baseUrl + "search/result";
                    break;
                case 12:
                    top.location.href = baseUrl + "serverNode/nodeCloud";
                    break;
                case 100:
                    mainFrame.location.href = baseUrl + "search/result";
                    break;
            }
            //setWindowSize();
            //var topFrame = document.getElementById("topFrame");
            topFrame.selectPage(opt);

        }

        //以后有空实现，参见帮助中的实现
        function setFrameHeight(theFrame) {
            /*var iframe = document.getElementById("mainFrame");
             var height = 0;
             try{
             if(theFrame){
             if(theFrame.document.body.offsetHeight) height = theFrame.document.body.offsetHeight+30;
             }
             }catch(e){
             //
             }

             height = Math.max(730, height);
             iframe.height =  height;953*/
        }
        //-->
    </SCRIPT>

</head>

<body onLoad="MyLoadPage(${selectPage});" style="margin:0px">
<div style="text-align:center;">
    <iframe src="${createLink(controller: 'shared', action: 'ntsHead')}" style="width:100%; height:161px;"
            name="topFrame" id="topFrame" frameborder="0" scrolling="no"></iframe>
    <iframe src="" name="mainFrame" id="mainFrame" style="width:1020px;height:730px;" frameborder="0"></iframe>
    <iframe src="${createLink(controller: 'shared', action: 'ntsBottom')}" style="width:100%; height:82px;"
            name="bottomFrame" id="bottomFrame" frameborder="0" scrolling="no"></iframe>
</div>
</body>
</html>
