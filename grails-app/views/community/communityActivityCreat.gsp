<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh" lang="zn">
<head>
    <title>小组首页</title>
    <r:require modules="jquery-ui"/>
    <meta name="layout" content="index">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'community_activity_creat.css')}">
    <script type="text/javascript">
        $(function () {
            $("#startTime").datepicker();
            $("#endTime").datepicker();
            $("#name").click(function () {
                $("#name").val("");
            })
        })
        function checkValue() {
            var name = $("#name").val();
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();
            var nowTime = $("#nowTime").val();
            var Img = $("#Img").val();
            if (nowTime > endTime) {
                alert("活动结束时间必须大于或者等于今天");
                return false;
            }
            ;
            if (startTime > endTime) {
                alert("开始时间必须小于结束时间");
                return false;
            }
            var description = $("#description").val();
            if (name == "请输入活动标题" || name == "") {
                alert("请输入活动标题");
                return false;
            }
            var patrn=/^[0-9a-zA-Z\u4e00-\u9fa5+\.+\《》]+$/;
            if (patrn.test(name) == false) {
                alert("活动标题含有特殊字符!");
                return false;
            }
            if (startTime == "") {
                alert("请选择时间");
                return false;
            }
            if (endTime == "") {
                alert("请选择时间");
                return false;
            }
            if (Img == "") {
                alert("请选择文件");
                return false;
            }
            if (description == "") {
                alert("请选择内容");
                return false;
            }
        }
    </script>
</head>

<body>
<div class="community_activity_creat">
    <div class="activity_creat_title">
        <div class="wrap">
            <h1>创建讨论</h1>
        </div>
    </div>
</div>

<div class="activity_creat_box wrap"><input type="hidden"
                                            value="${new SimpleDateFormat("yyyy-MM-dd").format(new Date())}"
                                            id="nowTime">
    <g:form controller="community" action="saveActivity" onsubmit="return checkValue();" enctype="multipart/form-data">
        <input type="hidden" name="communityId" value="${communityId}">
        <table>
            <tr>
                <td class="creat_title"><span class="c_al">*</span>讨论主题</td>
                <td>
                    <label>
                        <input type="text" value="请输入活动标题" name="name" id="name">
                    </label>
                </td>
            </tr>
            <tr>
                <td class="creat_title"><span class="c_al">*</span>开始时间</td>
                <td>
                    <label>
                        <input readonly="true" type="text" name="startTime" id="startTime">
                    </label>
                </td>
            </tr>
            <tr>
                <td class="creat_title"><span class="c_al">*</span>结束时间</td>
                <td>
                    <label>
                        <input readonly="true" type="text" name="endTime" id="endTime">
                    </label>
                </td>
            </tr>
            <tr>
                <td class="creat_title"><span class="c_al">*</span>上传图片</td>
                <td>
                    <label>
                        <input type="file" name="Img" id="Img" style="border: 0; line-height: 25px">
                    </label>
                </td>
            </tr>
            %{--<tr>
                <td class="creat_title"><span class="c_al">*</span>状态</td>
                <td class="creat_mode">
                    <label>
                        <select>
                            <option>开始活动</option>
                            <option>结束活动</option>
                        </select>
                    </label>
                </td>
            </tr>--}%
            <tr>
                <td class="creat_title"><span class="c_al">*</span>讨论内容</td>
                <td class="creat_word">
                    <label>
                        <textarea name="description" id="description"></textarea>
                    </label>
                </td>
            </tr>
            <tr>
                <td></td>
                <td colspan="1">
                    <input class="creat_submit" value="提交" type="submit" style="border: 0; color: #FFF">
                </td>
                <td></td>

            </tr>
        </table>
    </g:form>
</div>

</body>
</html>