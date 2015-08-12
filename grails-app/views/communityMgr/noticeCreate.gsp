<%--
  Created by IntelliJ IDEA.
  User: xuzhuo
  Date: 14-3-13
  Time: 下午4:25
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>公告创建</title>
    <script type="text/javascript">
        function noticeFormSubmit() {
            var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
            if ($("#noticeNameId").val() == "" || patrn.test($("#noticeNameId").val()) == false || $("#noticeNameId").val().length >= 100) {
                alert("请正确输入标题！！！");
                return false;
            }
            if ($("#noticeDescriptionId").val() == "" || $("#noticeDescriptionId").val().length >= 300) {
                alert("请正确输入内容！！！");
                return false;
            }
            $("#noticeFormId").submit();
        }
    </script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>

</head>

<body>
<style>
.notice_creat {
    width: 650px;
    margin: 5px;;
}

.notice_creat span {
    float: left;
    font-weight: bold;
    margin: 10px;;
}

.notice_span {
    font-size: 12px;
    color: #D46235;
    font-weight: normal;
}

</style>

<div class="userspace_title" style="margin-bottom: 20px;">
    <a href="">${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.notice.name')}${message(code: 'my.creat.name')}</a>
</div>

<div class="notice_creat">
    <form id="noticeFormId" action="noticeSave" name="noticeForm" method="post">
        %{--这里应该还隐藏studyCommunityId--}%
        <input type="hidden" name="studyCommunityId" value="${studyCommunity.id}">
        <input type="hidden" name="noticeId" value="${notice?.id}"/><g:message code="${flash.message}"></g:message><br/>
        <span>${message(code: 'my.notice.name')}${message(code: 'my.title.name')}：</span><span
            class="notice_span">标题名称不要超过100字</span><input class="form-control" type="text"
                                                          id="noticeNameId" name="name"
                                                          value="${notice?.name}"><br/>
        <span>${message(code: 'my.notice.name')}${message(code: 'my.introduction.name')}：</span><span
            class="notice_span">公告内容不要超过300字</span><textarea class="form-control"
                                                             id="noticeDescriptionId"
                                                             name="description">${notice?.description}</textarea><br/>
        <input class="btn btn-success" type="button" onclick="noticeFormSubmit()" value="提交"/>
    </form>
</div>
</body>
</html>