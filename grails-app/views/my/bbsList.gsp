<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>nts</title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" type=text/css
          rel=stylesheet>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}" type=text/css
          rel=stylesheet>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'popup.css')}" rel="stylesheet" type="text/css">
    <style>
    table {
        border: 0px solid #ccc;
        margin-left: 20px;
        margin-right: 20px;
    }

    a:link, a:visited {
        font-weight: normal;
    }

    a:hover {
        color: #FF6600;
        font-weight: normal;
    }

    #catetab .curLink {
        color: #f60;
    }

    #progListTab td {
        line-height: 18px;
        padding-left: 2px;
    }

    </style>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>

    <SCRIPT LANGUAGE="JavaScript">
        <!--
        function setGroupListDiv() {
            var editDiv = document.getElementById("groupList");
            editDiv.style.display = "block";
            setDivPos(editDiv, 400, editDiv.offsetWidth);
            document.getElementById("applyToLib").style.display = "none";//同时只有一个层显示
        }

        function setApplyToLibDiv() {
            var editDiv = document.getElementById("applyToLib");
            editDiv.style.display = "block";
            setDivPos(editDiv, 400, editDiv.offsetWidth);
            document.getElementById("groupList").style.display = "none";//同时只有一个层显示
        }

        function checkGroup(theForm) {
            return true;
        }

        function onOperateSuccess(divId) {
            hideWnd(divId);
            alert("操作成功！");
        }

        function onOperateFailure(divId) {
            alert("操作失败！");
            //hideWnd(divId);
        }

        function onCanAll(theObj) {
            var divObj = document.getElementById("groupListTab");
            if (divObj) divObj.style.display = theObj.value == 1 ? "none" : "block";
        }

        function submitSch() {
            //self.location.href = baseUrl + "my/manageProgram?state="+theForm.state.value+"&max="+theForm.max.value;
            //self.location.href = "";
            document.form1.offset.value = 0;
            document.form1.submit();
        }

        function onPageNumPer(max) {
            document.form1.max.value = max;
            submitSch();
        }

        function onApplyOperateSuccess(divId) {
            //hideWnd(divId);
            //alert("操作成功！");
            document.form1.submit();
        }

        function operate(controller, action, operation) {
            if (operation != "clearRecycler") {
                if (hasChecked("idList") == false) {
                    alert("请至少选择一条记录！");
                    return false;
                }
            }

            if (operation == "clearRecycler") {
                if (confirm("确实要清空回收站吗？清空后就不能再恢复了。") == false) return;
            }
            else if (action == "delete") {
                if (confirm("确实要删除该资源吗？删除后就不能再恢复了。") == false) return;
            }


            if (operation != null) document.form1.operation.value = operation;
            if (operation != "public" && operation != "close") document.form1.offset.value = 0;

            document.form1.action = baseUrl + controller + "/" + action;
            document.form1.submit();
        }

        function init() {
            //form1.schState.value="0";
            changePageImg(10);
        }

        //-->
    </SCRIPT>
</head>

<body onload="init();" style="overflow-x:hidden">
<form name="form1" method="post" action="">
    <input type="hidden" name="max" value="10">
    <input type="hidden" name="offset" value="0">

    <div class="x_daohang">
        <p>当前位置：<a href="${createLink(controller: 'my', action: 'myInfo')}">个人空间</a>>><a href="${createLink(controller: 'my', action: 'bbsList')}">用户留言</a>>>主题列表</p>
    </div>

    <table width="95%" border="0" cellspacing="0" cellpadding="2" class="biaoge-hui"
           style="margin-top:10px;margin-bottom:10px;">
        <tr>
            <td>主题列表</td>
            <td width="10%"><input class="button" type="button" value="发 帖"
                                   onClick="self.location.href = 'createBbsTopic';"/></td>
        </tr>
    </table>

    <table width="95%" border="1" cellspacing="0" cellpadding="0" bordercolor="#FFFFFF" id="progListTab">
        <tr>
            <td align="center" bgcolor="#BDEDFB" class="STYLE5">主题</td>
            <td width="12%" align="center" bgcolor="#BDEDFB" class="STYLE5">发帖人</td>
            <td width="10%" align="center" bgcolor="#BDEDFB" class="STYLE5">回复数</td>
            <td width="12%" align="center" bgcolor="#BDEDFB" class="STYLE5">最新回复</td>
        </tr>
        <g:each in="${bbsTopicList ?}" status="i" var="bbsTopic">
            <tr class="even">
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
            </tr>
        </g:each>
    </table>

    <table width="95%" style="border: 0px;" height="16" border="0" cellpadding="1" cellspacing="1" bgcolor="#E9E8E7">
        <tr>
            <td width="300" height="16" align="center">
                主题数：${total}&nbsp; 每页显示:
                <img id="Img10" src="${resource(dir: 'images/skin', file: 'grkj_amount_10.gif')}" alt="每页显示10条" border="0"
                     onclick="onPageNumPer(10)">&nbsp;
                <img id="Img50" src="${resource(dir: 'images/skin', file: 'grkj_amount_50.gif')}" alt="每页显示50条" border="0"
                     onclick="onPageNumPer(50)">&nbsp;
                <img id="Img100" src="${resource(dir: 'images/skin', file: 'grkj_amount_100.gif')}" alt="每页显示100条" border="0"
                     onclick="onPageNumPer(100)">&nbsp;
                <img id="Img200" src="${resource(dir: 'images/skin', file: 'grkj_amount_200.gif')}" alt="每页显示200条" border="0"
                     onclick="onPageNumPer(200)">
            </td>
            <td align="right"><div class="paginateButtons"><g:paginate controller="my" action="bbsList" total="${total}"
                                                                       params="${params}"/></div></td>
        </tr>
    </table>
</form>

</body>
</html>

