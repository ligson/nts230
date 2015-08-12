<%@ page import="nts.system.domain.SysConfig; nts.system.domain.ServerNode" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>修改节点</title>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'css.css')}" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/Jtrim.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/common/isNum2.js')}"></script>
    <script type="text/javascript" src="${createLinkTo(dir: 'js', file: 'boful/appMgr/metaedit.js')}"></script>

    <SCRIPT LANGUAGE="JavaScript">
        function hiddenPath() {
            if ($('grade').value != ${ServerNode.GRADE_SELF}) {
                $('path_1').style.display = "none"
                if ($('path_2'))
                    $('path_2').style.display = "none"
            } else {
                $('path_1').style.display = "block"
                if ($('path_2'))
                    $('path_2').style.display = "block"
            }
        }

        function check() {
            if (!document.form1.name.value) {
                alert("节点名称不能为空！")
                document.form1.name.focus();
                return false;
            }
            if (!document.form1.ip.value) {
                alert("节点IP不能为空！")
                document.form1.ip.focus();
                return false;
            }
            if (!document.form1.port.value) {
                alert("节点端口不能为空！")
                document.form1.port.focus();
                return false;
            } else if (isNaN(document.form1.port.value)) {
                alert("节点端口只能是数字！")
                document.form1.port.focus();
                document.form1.port.value = ""
                return false;
            }
            if (!document.form1.webPort.value) {
                alert("节点WEB端口不能为空！")
                document.form1.webPort.focus();
                return false;
            } else if (isNaN(document.form1.webPort.value)) {
                alert("节点WEB端口只能是数字！")
                document.form1.webPort.focus();
                document.form1.webPort.value = ""
                return false;
            }

            if (isExit()) {
                alert("节点名称已存在！");
                document.form1.name.focus();
                return false;
            }
        }

        function isExit() {
            var boo = false;
            var url = "${createLink(action:'isExit')}"

            new Ajax.Request(url, {
                method: 'post',
                parameters: "name=" + document.form1.name.value + "&id=${serverNode?.id}",
                asynchronous: false,
                onComplete: function (req) {
                    if (req.responseText == "exit") boo = true;
                }
            })

            return boo;
        }
    </SCRIPT>

</head>

<body>
<div class="body">
    <p>当前位置：<a href="${createLink(controller: 'appMgr', action: 'serverNodeList')}">资源分发</a>>> 修改节点</p>
    <g:form name="form1" method="post" action="updateServerNode">
        <g:hiddenField name="id" value="${serverNode?.id}"/>
        <g:hiddenField name="version" value="${serverNode?.version}"/>
        <input type="hidden" id="to" name="to" value="${params.to}">

        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        名称：
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: serverNode, field: 'name', 'errors')}">
                        <g:textField name="name" maxlength="250" value="${serverNode?.name}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        IP：
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: serverNode, field: 'ip', 'errors')}">
                        <g:textField name="ip" maxlength="250" value="${serverNode?.ip}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        端口：
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: serverNode, field: 'port', 'errors')}">
                        <g:textField name="port" maxlength="20" value="${serverNode?.port}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        WEB端口：
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: serverNode, field: 'webPort', 'errors')}">
                        <g:textField name="webPort" maxlength="20" value="${serverNode?.webPort}"/>
                    </td>
                </tr>



                <tr id="path_1" style="display:<g:if
                        test="${serverNode.grade == ServerNode.GRADE_SELF}">block;</g:if><g:else>none;</g:else>"
                    class="prop">
                    <td valign="top" class="name">
                        分发节目路径：
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: serverNode, field: 'distriPath', 'errors')}">
                        <g:textField name="distriPath" maxlength="40" value="${serverNode?.distriPath}"/>
                    </td>
                </tr>
                <g:if test="${application.centerGrade != SysConfig.CENTER_GRADE_TOWNSHIP}">
                    <tr id="path_2" style="display:<g:if
                            test="${serverNode.grade == ServerNode.GRADE_SELF}">block;</g:if><g:else>none;</g:else>"
                        class="prop">
                        <td valign="top" class="name">
                            收割节目路径：
                        </td>
                        <td valign="top" class="value ${hasErrors(bean: serverNode, field: 'harvestPath', 'errors')}">
                            <g:textField name="harvestPath" maxlength="40" value="${serverNode?.harvestPath}"/>
                        </td>
                    </tr>
                </g:if>

                <tr class="prop">
                    <td valign="top" class="name">
                        描述：
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: serverNode, field: 'descriptions', 'errors')}">
                        <g:textArea name="descriptions" cols="40" rows="5" value="${serverNode?.descriptions}"/>
                    </td>
                </tr>
                <!--
                            <tr class="prop">
                                <td valign="top" class="name">
                                  <label for="isSendObject"><g:message code="serverNode.isSendObject.label"
                                                                       default="Is Send Object"/></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: serverNode, field: 'isSendObject', 'errors')}">
                                    <g:checkBox name="isSendObject" value="${serverNode?.isSendObject}"/>
                                </td>
                            </tr>
                            -->
                </tbody>
            </table>
        </div>

        <div class="buttons">
            <span class="buttons"><input class="save" type="submit" onclick="return check();" value="修改"/></span>
            <span class="buttons"><input class="return" type="button" onclick="history.back();" value="取消"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
