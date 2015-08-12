<%@ page import="nts.utils.CTools" %>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" rel="stylesheet" type="text/css">

    <title>添加部门</title>
    <style type="text/css">
    <!--
    .STYLE1 {
        color: #8B0D11;
        font-weight: bold;
        font-size: 12px;
    }

    .STYLE4 {
        font-family: "宋体";
        font-size: 12px;
    }

    .STYLE5 {
        font-size: 12px
    }

    .STYLE6 {
        color: #990000;
        font-weight: bold;
    }

    .STYLE8 {
        font-size: 12
    }

    .STYLE9 {
        color: #990000;
        font-weight: bold;
        font-size: 12px;
    }

    -->
    .list_bg {
        border-top: #e2e2e2 1px solid;;
    }

    .list_bg td {
        background: url("${resource(dir: 'skin/blue/pc/images',file: 'th_bg.png')}") repeat-x;
        border-right: #e2e2e2 1px solid;
        border-bottom: #e2e2e2 1px solid;
        height: 25px;
        font-size: 14px;
        text-indent: 2em;
        text-align: left;
        line-height: 30px;
    }

    td {
        text-align: left;
    }

    .zi-cu1 {
        font-size: 16px;
        margin: 10px;
    }

    .button {
        color: #2e5b88;
        background: url("${resource(dir: 'skin/blue/pc/images',file: 'but_3.png')}") repeat-x;
        padding: 3px 15px;
        border: 1px solid #8fb2da;
        border-radius: 3px;
        height: 20px;
        line-height: 20px;
        overflow: visible;
        cursor: pointer;
    }

    .button:hover {
        background: url("${resource(dir: 'skin/blue/pc/images',file:'but_4.png')}") repeat-x;
        padding: 3px 15px;
        cursor: pointer;
    }
    </style>

    <script LANGUAGE="javascript">

        function addCollege() {
            if (colleageForm.name.value == "") {
                alert("请输入部门名称");
                colleageForm.name.focus();
                return false;
            } else {
                $.ajax({
                    url: baseUrl + "userMgr/checkCollegeName",
                    data: {name: colleageForm.name.value, opt: 'save'},
                    success: function (data) {
                        if (!data.success) {
                            alert(data.msg);
                            colleageForm.name.focus();
                            return false;
                        } else {
                            if (colleageForm.description.value.length > 200) {
                                alert("部门说明输入不大于200字符");
                                colleageForm.description.focus();
                                return false;
                            } else {
                                colleageForm.action = "collegeSave";
                                colleageForm.submit();
                            }
                        }
                    }
                })
            }
        }
        function showinfo() {
            alert("无权操作");
        }

        $(function () {
            // 20140723 部门说明可以输入的字符树统计
            var limitNum = 200;
            var pattern = '可以输入' + limitNum + '字符';
            $('#counter').html(pattern);
            $('#content').keyup(
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

<style>
#content {
    width: 100%;
    padding: 0px;
    min-width: 200px;
    overflow: auto;
}

#addTable {
    padding: 0 0px 10px 0px;
}
</style>

<div style="width: 98%; margin: 10px 0 0 10px;overflow-y:scroll;height:480px;">
    <form method="post" name="colleageForm" id="colleageForm">

        <div id="addTable">
            <table width="95%" border="0" cellspacing="0">
                <tr>
                    <td align="left"><font><span class="zi-cu zi-cu1">添加部门</span></font></td>
                </tr>
            </table>

            <table class="table">
                <tr>
                    <td width="91">部门名称:</td>
                    <td><input id="name" name="name" maxlength="20" type="text" size="52" class="form-control"
                               style="width: 200px"/>
                    </td>
                    <td width="647">&nbsp;</td>
                </tr>
                <tr>
                    <td>部门说明:</td>
                    <td><textarea id="content" name="description" class="form-control"
                                  cols="50" rows="3"></textarea><span id="counter"></span></td>
                </tr>
                <tr>
                    <td></td>
                    <td valign="bottom"><span style="height: 35px; padding: 0;float: left;">
                        <input name="groupAdd" type="button" class="btn btn-primary" onClick="addCollege()" value="添加"/>
                    </span></td>
                </tr>
            </table>
        </div>
    </form>
</div>
</body>
</html>

