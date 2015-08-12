<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/dateSelectBox.js')}"></script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/admin/css', file: 'main.css')}" type=text/css
          rel=stylesheet>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/div.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/updateNode.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/allselect.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/truevod.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/common.js')}"></script>
    <g:set var="entityName" value="${message(code: 'courseBcast.label', default: 'nts.broadcast.domain.CourseBcast')}"/>
    <style>

    .t5 {
        font-size: 12px;
        line-height: 15px;
        color: #003366;
        padding: 0px;
        margin: 0px;
    }
    </style>
    <SCRIPT LANGUAGE="JavaScript">
        function cancel() {
            self.location = baseUrl + 'appMgr/channelMgr';
        }


        function check() {

            if (form1.channelName.value.length < 1) {
                alert("请在频道名称框中输入值。");
                form1.channel.focus();
                return false;
            }
            if (form1.bcastAddr.value.length < 1) {
                alert("请在播出地址框中输入值。");
                form1.mediaUrl.focus();
                return false;
            }
            if (form1.prilevel.value.length < 1) {
                alert("请在权限级别框中输入值。");
                form1.screenUrl.focus();
                return false;
            }


            form1.action = "updateChannel";
            form1.submit();
            return true;

        }



    </SCRIPT>
</head>

<body>

<div class="x_daohang">
    <p style="font-size:12px">当前位置：<a href="${createLink(controller: 'news', action: 'list')}">应用管理</a>>><a
            href="${createLink(controller: 'courseBcast', action: 'courseMgr')}">广播直播</a>>>频道管理</p>
</div>

<div class="body">
    <div class="explain">添加频道
    </div>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${courseBcast}">
        <div class="errors">
            <g:renderErrors bean="${courseBcast}" as="list"/>
        </div>
    </g:hasErrors>
    <g:form name="form1" method="post">

        <div class="dialog">
            <table align="center">
                <tbody>

                <tr align="center">
                    <td colspan="4"><h4>频道信息</h4></td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="channelName"><g:message code="channel.channelName.label" default="频道名称"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: channel, field: 'channelName', 'errors')}">
                        <g:textField name="channelName" maxlength="80" size="88" value="${channel?.channelName}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="bcastAddr"><g:message code="channel.bcastAddr.label" default="播出地址"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: channel, field: 'bcastAddr', 'errors')}">
                        <g:textField name="bcastAddr" size="88" maxlength="400" value="${channel?.bcastAddr}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="bcastType"><g:message code="channel.bcastType.label" default="频道类型"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: channel, field: 'bcastType', 'errors')}">
                        <select name="bcastType">
                            <option value="1">广播</option>
                            <option value="0" selected="selected">直播</option>
                            <option value="2">转播</option>
                        </select>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="prilevel"><g:message code="channel.prilevel.label" default="权限级别"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: channel, field: 'prilevel', 'errors')}">
                        <g:textField name="prilevel" size="44" value="${fieldValue(bean: channel, field: 'prilevel')}"/>
                        (1~128位数字)
                    </td>

                </tr>
                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="channelDesc"><g:message code="channel.channelDesc.label" default="介绍信息"/></label>
                    </td>
                    <td valign="top" colspan="3"
                        class="value ${hasErrors(bean: channel, field: 'channelDesc', 'errors')}">
                        <g:textArea name="channelDesc" size="120" style="width:400px" maxlength="2000" cols="40"
                                    rows="5" value="${channel?.channelDesc}"/>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="buttons">
            <span class="button">

                <g:hiddenField name="id" value="${channel?.id}"/>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <img src="${resource(dir: 'images/skin', file: 'queding.gif')}" border="0" style="cursor:pointer;" onClick="return check();">
            </span>
            <span class="button">
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <a href="#dd" onClick="cancel();
                return false;"><img src="${resource(dir: 'images/skin', file: 'cancel.gif')}" border="0"></a>
            </span>
        </div>
    </g:form>
</div>
</body>
</html>
