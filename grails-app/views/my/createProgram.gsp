<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 13-12-21
  Time: 下午12:33
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>资源上传</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/front/css', file: 'createProgram.css')}">
    <r:require modules="swfupload,zTree,string,jquery-ui"/>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/my_createProgram.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/admin/admin.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/bfUploadProgram.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/userspace/progedit.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/commonLib', file: 'string.js')}"></script>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_space.css')}">
</head>

<body>
<div style=" margin:0 auto; overflow: hidden">
    <input type="hidden" id="uId" value="${session?.consumer?.id}">
    <input type="hidden" id="uName" value="${session?.consumer?.name}">
    <input type="hidden" id="jId" value="${session?.id}">
    <input type="hidden" id="dirId" value="${classLibId}">
    <g:form controller="my" action="saveProgram" name="formPro" method="post">
        <!--文件个数-->
        <input type="hidden" name="fileCount" value=""/>
        <!--确认资源是否上传完成-->
        <input type="hidden" id="isFlag" value="0">
        ${flash.saveMes}
        <table id="tb" class="resources_upload_infor" width="100%" cellpadding="0" cellspacing="0">
            <tbody>
            <tr>
                <th style="width: 120px"><span class="name_warning">*&nbsp;</span>资源名称</th>
                <td>
                    <label>
                        <input maxlength="400" id="name" name="name" type="text" class="resources_upload_title widt"
                               value="${params.program?.name}"/>
                    </label><span class="name_warning  warning_size">&nbsp;[可输入200字]</span></td>
            </tr>
            %{--<tr><th style="width: 120px"><span class="name_warning">*&nbsp;</span>选择类库</th>
                <td><label>
                    <select class="resources_upload_chose" id="classLib.id" name='classLib.id'>
                        <g:each in="${directoryList}" var="directory">
                            <option value="${directory.id}">${directory.name}</option>
                        </g:each>
                    </select>
                </label></td>
            </tr>--}%
            <tr>
                <th style="width: 120px"><span class="name_warning">*&nbsp;</span>选择类别</th>
                <td>
                    <input type="button" id="selectCategoryBtn" class="resources_upload_chose_but"
                           value="默认分类">
                    <input type="button" id="clearCategoryBtn" class="resources_upload_chose_but"
                           value="清楚所选分类">
                    <span class="name_warning warning_size">&nbsp;[点击选择分类,&nbsp;可多选;&nbsp;&nbsp;默认分类中资源前台不显示]</span>
                </td>

            </tr>
            <tr>
                <th></th>
                <td>
                    <input type="hidden" name="categoryId" id="categoryId">
                    <span id="categoryName" name="categoryName"></span>
                </td>
            </tr>

            <tr id="factedTr" style="display: none">
                <th style="width: 120px">选择分面</th>
                <td>
                    <table id="factedTb" class="resources_upload_infor" width="100%" cellpadding="0"
                           cellspacing="0"></table>
                </td>
            </tr>
            <tr>
                <th style="width: 120px">标&nbsp;&nbsp;签</th>
                <td>
                    <label>
                        <input type="text" id="programTagInput" class="resources_upload_key widt">
                    </label>
                    <input type="hidden" name="programTag" value=""/>
                    <span class="name_warning warning_size">&nbsp;[ 多标签，请用空格隔开]</span>
                </td>
            </tr>
            <tr>
                <th></th>
                <td id="tagShow">
                </td>
            </tr>
            <tr>
                <th style="width: 120px">资源描述</th>
                <td><label>
                    <textarea type="text" name="description" class="resources_describe widt hidt"></textarea>
                </label>
            </tr>
            <tr>
                <th style="width: 120px">上传资源</th>
                <td><input class="resources_upload_buttom" type="button" id="bfSelectFileBtn" value="上传资源"></td>
            </tr>
            </tbody>
        </table>

        <div class="resources_upload_lists">
        </div>
        <input type="submit" class="resources_upload_save" style="margin-left: 40%;" value="保存">

        <div id="file_save" class="file_save_box" style="position: fixed;z-index: 5;top: 0;left: 0;">
            <span class="file_save_icon" id="file_save_icon"><a onclick="fileSave()">快速保存</a></span>
        </div>
    </g:form>
    <div id="selectCategoryDialog" class="bg" style="display:none;" title="选择分类">
        <div>
            <input type="hidden" id="selectedCategoryId" value=""/>
            <input type="hidden" id="selectedCategoryName" value="" />
            <table>
                <tr>
                    <td>
                        选择的分类：
                    </td>
                    <td>
                        <div id="categoryNameDiv" style="height:15px;line-height:15px;text-align: center;"><span>未选择</span></div>
                    </td>
                </tr>
            </table>
        </div>

        <div id="zTree" class="ztree">
        </div>
    </div>
</div>
<script type="text/javascript">
    var isFlag = document.getElementById("isFlag");
    if (isFlag.value == "0") {
        window.onbeforeunload = function () {
            return "";
        }
    }


    function fileSave() {
        var flag = true;
        var name = document.getElementById("name");
        var isFlag = document.getElementById("isFlag");
        var formPro = document.getElementById("formPro");
        if (name.value == "") {
            alert("资源名称不能为空!");
            flag = false;
            return;
        }
        if (isFlag.value == "0") {
            alert("未上传资源或者资源未上传完成!");
            flag = false;
            return;
        }
        console.log(flag);
        if (flag == true) {
            formPro.submit();
        }
    }
</script>
</body>
</html>