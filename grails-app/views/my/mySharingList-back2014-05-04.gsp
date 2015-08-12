<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-3-19
  Time: 上午10:55
--%>

<%@ page import="com.boful.common.file.utils.FileType;java.text.SimpleDateFormat; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>我的共享列表</title>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_userspace_index.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'communiuty_share_list.css')}">
    <script type="text/javascript">
        $(function () {
            $("#communityListDialog").dialog({autoOpen: false, buttons: {
                "进入上传": function () {
                    var sharingForm = $("#createSharingForm");
                    var select = sharingForm.find("select");
                    if ($($(select).find("option:selected")).val()) {
                        sharingForm.submit();
                    }
                }
            }});
            $("#uploadBtn").click(function () {
                $("#communityListDialog").dialog("open");
            });
        });
    </script>
</head>

<body>
<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">当前位置：我的文件</a>
</div>

<div style="float: left; width: 100%; overflow: hidden;margin-top:-30px;"><span
        style="float: right; margin-right: 25px;display: block;margin-bottom: 5px;"><input type="button"
                                                                                           style="width: 120px;"
                                                                                           class="btn btn-success"
                                                                                           value="上传" id="uploadBtn">
</span></div>
<table class="table table-condensed">
    <thead>
    <tr style="border-top: 1px #dddddd solid">
        <td width="80" align="center" valign="middle">资源类型</td>
        <td>资源名称</td>
        <td width="120" align="center" valign="middle">贡献者</td>
        <td width="80" align="left" valign="middle">下载</td>
        <td width="100" align="center" valign="middle">共享时间</td>
    </tr>
    </thead>
    <tbody>
    <g:each in="${sharingList}" var="sharing">
        <tr>
            <%
                if (FileType.isVideo(new File(sharing?.url).getName())) {
            %><td class="share_class_icon share_class" title="视频"></td><%
            } else if (FileType.isImage(new File(sharing?.url).getName())) {
        %><td class="share_class_icon1 share_class" title="图片"></td><%
            } else if (FileType.isDocument(new File(sharing?.url).getName())) {
        %><td class="share_class_icon2 share_class" title="文档"></td><%
            } else {
        %><td class="share_class_icon4 share_class" title="未知"></td><%
            }

        %>
            <td><a href="${createLink(controller: 'community', action: 'communitySharingShow', params: [id: sharing?.id])}">${CTools.cutString(sharing?.name, 6)}</a>
            </td>
            <td align="center">
                ${sharing?.shareConsumer?.name}
            </td>
            <td align="center">
                <a class="share_class_iconss" title="下载" style="cursor: pointer;"
                   href="${createLink(controller: 'program', action: 'downloadSharing', params: [url: playSharingLink(sharing: sharing)])}"></a>
            </td>
            <td align="center">${new SimpleDateFormat('yyyy-MM-dd').format(sharing?.dateCreated)}</td>
        </tr></g:each>
    </tbody>

</table>


<div id="communityListDialog" title="社区列表">
    <g:form controller="community" action="createSharing" name="createSharingForm">
        <g:select name="communityId" from="${communitites}" size="10" optionValue="name" optionKey="id"/>
    </g:form>
</div>
</body>
</html>