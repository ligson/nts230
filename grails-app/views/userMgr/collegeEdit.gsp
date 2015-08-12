<%@ page import="nts.utils.CTools" %>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" rel="stylesheet" type="text/css">
    <title>修改部门</title>
    <style type="text/css">
    td {
        text-align: left;
    }

    .zi-cu1 {
        font-size: 16px;
        margin: 10px;
    }
    </style>
    <script LANGUAGE="javascript">
        function newsUpdate() {
            if (colleageForm.updateName.value == "") {
                alert("请输入部门名称");
                colleageForm.updateName.focus();
                return false;
            } else {
                $.ajax({
                    url: baseUrl + "userMgr/checkCollegeName",
                    data: {collegeId: colleageForm.updateId.value, name: colleageForm.updateName.value, opt: 'update'},
                    success: function (data) {
                        if (!data.success) {
                            alert(data.msg);
                            colleageForm.updateName.focus();
                            return false;
                        } else {
                            if (colleageForm.updateDescription.value.length > 200) {
                                alert("部门说明输入不大于200字符");
                                colleageForm.updateDescription.focus();
                                return false;
                            } else {
                                colleageForm.action = "collegeUpdate";
                                colleageForm.submit();
                            }
                        }
                    }
                });
            }
        }
        function showinfo() {
            alert("无权操作");
        }

        $(function () {
            // 20140723 部门说明可以输入的字符树统计
            var limitNum = 200;
            var limitNum2 = 200 - colleageForm.updateDescription.value.length;
            var pattern = '还可以输入' + limitNum2 + '字符';
            $('#counter').html(pattern);
            $('#updateDescription').keyup(
                    function () {
                        var remain = $(this).val().length;
                        if (remain > 200) {
                            pattern = "字数超过限制！";
                        } else {
                            var result = limitNum - remain;
                            pattern = '还可以输入' + result + '字符';
                        }
                        $('#counter').html(pattern);
                    }
            );
        });
    </script>

</head>

<body>

<div>
    <form method="post" name="colleageForm" id="colleageForm">
        <input type="hidden" name="editPage" value="${editPage}">
        <input type="hidden" name="updateId" value="${collegeId}"/>

        <div id="addTable">
            <table width="95%" border="0" cellspacing="0">
                <tr>
                    <td align="left"><font><span class="zi-cu zi-cu1">修改部门</span></font></td>
                </tr>
            </table>

            <table border="0" cellspacing="0" cellpadding="0" class="table">
                <tr>
                    <td width="90" align="center">部门名称</td>
                    <td><input name="updateName" maxlength="20" type="text" size="52" class="form-control"
                               style="width: 400px"
                               value="${collegeInstance.name}"/></td>
                </tr>
                <tr>
                    <td width="90" align="center">部门说明</td>
                    <td><textarea class="form-control" name="updateDescription" id="updateDescription"
                                  style="width: 400px"
                                  rows="3">${CTools.htmlToBlank(collegeInstance.description)}</textarea><span
                            id="counter"></span></td>
                </tr>
                <tr>
                    <td></td>
                    <td valign="bottom">
                        <label>
                            <input name="update_enter" type="button" class="btn btn-primary" onClick="newsUpdate()"
                                   value="确定"/>
                        </label>
                    </td>
                </tr>
            </table>

        </div>

    </form>
</div>
</body>
</html>

