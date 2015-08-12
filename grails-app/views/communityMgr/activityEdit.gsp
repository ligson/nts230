<%@ page import="nts.utils.CTools" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>${message(code: 'my.amend.name')}${message(code: 'my.activities.name')}</title>
    <meta name="layout" content="communityMgr">
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'activityCreate.css')}">
    <link type="text/css" rel="stylesheet"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'fromBordCreate.css')}">
    <r:require modules="jquery-ui"/>
    <script>
        $("document").ready(function () {
            $("#name").focus(function () {
                $(this).val('');
            });

            $("#activityStartTime").datepicker();
            $("#activityEndTime").datepicker();
        });

        function submitUpdateActivity() {

            // 解决ie兼容模式不支持trim方法
            if(!String.prototype.trim) {
                String.prototype.trim = function () {
                    return this.replace(/^\s+|\s+$/g,'');
                };
            }

            //清空所有提示
            $("#actName").html('');
            $("#actTime").html('');
            $("#actDescription").html('');

            if ($("#name").val().trim().length == 0) {
                $("#actName").html('&nbsp;&nbsp;<font style="color:red;">标题不能为空值</font>');
                $("#name").focus();
                $("#name").select();
                return;
            }
            var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
            if (patrn.test($("#name").val()) == false) {
                $("#actName").html('&nbsp;&nbsp;<font style="color:red;">标题含有特殊字符!</font>');
                $("#name").focus();
                $("#name").select();
                return;
            }
            if ($("#name").val().trim().length > 50) {
                var manyLength = (parseInt($("#name").val().trim().length) - 50);
                $("#actName").html('&nbsp;&nbsp;<font style="color:red;">标题超出了' + manyLength + '个字符</font>');
                $("#name").focus();
                $("#name").select();
                return;
            }

            if ($("#description").val().trim().length == 0) {
                $("#actDescription").html('&nbsp;&nbsp;<font style="color:red;">内容不能为空值</font>');
                $("#description").focus();
                $("#description").select();
                return;
            }

            if ($("#activityStartTime").val().trim().length == 0) {
                $("#actTime").html('&nbsp;&nbsp;<font style="color:red;">开始时间不能为空</font>');
                $("#activityStartTime").focus();
                $("#activityStartTime").select();
                return;
            }
            if ($("#activityEndTime").val().trim().length == 0) {
                $("#actTime").html('&nbsp;&nbsp;<font style="color:red;">结束时间不能为空</font>');
                $("#activityEndTime").focus();
                $("#activityEndTime").select();
                return;
            }
            /*            if (new Date(Date.parse($("#activityStartTime").val().toString().replace(/-/g, "/"))) - new Date() < -24 * 60 * 60 * 1000) {
             $("#actTime").html('&nbsp;&nbsp;<font style="color:red;">开始时间不能小于当天</font>');
                $("#activityStartTime").focus();
                $("#activityStartTime").select();
                return;
             }*/
            if (new Date(Date.parse($("#activityStartTime").val().toString().replace(/-/g, "/"))) > new Date(Date.parse($("#activityEndTime").val().toString().replace(/-/g, "/")))) {
                $("#actTime").html('&nbsp;&nbsp;<font style="color:red;">开始时间不能大于结束时间</font>');
                $("#activityEndTime").focus();
                $("#activityEndTime").select();
                return;
            }
            updateActivityForm.submit();
        }
    </script>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>

</head>

<body>
<div class="userspace_title" style="margin-bottom: 5px;">
    <a href="">${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.amend.name')}${message(code: 'my.activities.name')}</a>
</div>

<div class="activityCreate_content">
    <div class="activityCreate_content">
        <div class="community_form_content_creat">
            <h1>+${message(code: 'my.amend.name')}${message(code: 'my.activities.name')}</h1>
            <g:form controller="communityMgr" action="activityUpdate" method="post" name="updateActivityForm"
                    enctype="multipart/form-data">
                <input type="hidden" name="studyCommunityId" value="${studyCommunity?.id}"/>
                <input type="hidden" name="activityId" value="${activity?.id}"/>

            %{--<div class="form_creat_title">

                <input class="form-control" type="text" name="name" id="name" value="${activity?.name}">

                <span id="actName"></span>
            </div>--}%

                <table class="table" style="border: none">
                    <tr>
                        <td width="100"
                            align="right">${message(code: 'my.activities.name')}${message(code: 'my.title.name')}</td>
                        <td>
                            <input class="form-control" type="text" name="name" id="name" value="${activity?.name}">
                            <span id="actName"></span>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">${message(code: 'my.activities.name')}${message(code: 'my.poster.name')}</td>
                        <td><input type="file" name="photo" id="activityPhoto" value="上传活动图片"></td>
                    </tr>
                    <tr>
                        <td align="right">${message(code: 'my.start.name')}${message(code: 'my.time.name')}</td>
                        <td><input name="startTime" id="activityStartTime" readonly type="text"
                                   value="${activity?.startTime}"><!--时间控件-->(年-月-日)

                        </td>
                    </tr>
                    <tr>
                        <td align="right">结束时间</td>
                        <td><input name="endTime" id="activityEndTime" readonly type="text"
                                   value="${activity?.endTime}"><!--时间控件-->(年-月-日)
                            <br/>
                            <span id="actTime"></span>
                        </td>
                    </tr>
                    <tr>

                        <td align="right">${message(code: 'my.activities.name')}${message(code: 'my.state.name')}</td>
                        <td align="left"><select name="isOpen">
                            <option value="1" ${activity?.isOpen ? "selected='selected'" : ""}>打开</option>
                            <option value="0" ${!(activity?.isOpen) ? "selected='selected'" : ""}>关闭</option>
                        </select></td>

                    </tr>
                    <tr>
                        <td align="right">${message(code: 'my.activities.name')}${message(code: 'my.introduction.name')}</td>
                        <td>
                            <textarea class="form-control" rows="3" name="description"
                                      id="description">${CTools.htmlToBlank(activity?.description)}</textarea>

                            <span id="actDescription"></span>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <input class="btn btn-success" id="saveBtn" type="button" onclick="submitUpdateActivity()"
                                   value="提交"/>

                        </td>
                    </tr>
                </table>

            </g:form>
        </div>

    </div>
</div>
</body>
</html>