<%--
  Created by IntelliJ IDEA.
  User: lvy6
  Date: 14-4-10
  Time: 下午2:08
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>添加元数据标准</title>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
    <script type="text/javascript">

        function myGroupAdd() {
//            var saveImg = $("#saveImg").val();
            if (directoryForm.name.value == "") {
                alert("请输入元数据标准名称");
                directoryForm.name.focus();
                return false;
            } else if (directoryForm.name.value.length > 20) {
                alert("元数据标准名称不大于20字符");
                directoryForm.name.focus();
                return false;
            } else {
                var directoryId = $("#id").val();
                var directoryName = $("#name").val();
                var url = baseUrl + "programMgr/checkDirectoryNameExist";
                $.post(url, {directoryId: directoryId, directoryName: directoryName}, function (data) {
                    if (data.success) {
                        alert("元数据标准名称已存在，请重新输入！");
                        directoryForm.name.focus();
                        return false;
                    } else {
                        if (directoryForm.showOrder.value == "") {
                            alert("请输入排列序号");
                            directoryForm.showOrder.focus();
                            return false;
                        } else if (directoryForm.description.value.length > 200) {
                            alert("备注不大于200个字符");
                            directoryForm.description.focus();
                            return false;
                        } else {
                            directoryForm.action = "directorySave";
                            directoryForm.submit();
                        }
                    }
                });
            }
            /*  if(saveImg!=""){
             if(checkFileType(saveImg)!=3){
             myAlert("上传类型不正确");
             return false;
             }
             }*/
        }
        function showInfo(id, name, showOrder) {
            var description = eval("directoryForm.bz" + id + ".value");
            img1.style.visibility = 'visible';
            img1.style.height = 300;
            addTable.style.visibility = 'hidden';
            addTable.style.height = 0;
            directoryForm.updateId.value = id;
            directoryForm.updateName.value = name;
            directoryForm.updateShowOrder.value = showOrder;
            directoryForm.updateDescription.value = description;
            img1.style.display = 'block';
            addTable.style.display = 'none';
        }
        function myGroupUpdate() {
//            var saveImg = $("#saveImg").val();
            if (directoryForm.name.value == "") {
                alert("请输入元数据标准名称");
                directoryForm.name.focus();
                return false;
            } else if (directoryForm.name.value.length > 20) {
                alert("元数据标准名称不大于20字符");
                directoryForm.name.focus();
                return false;
            } else {
                var directoryId = $("#id").val();
                var directoryName = $("#name").val();
                var url = baseUrl + "programMgr/checkDirectoryNameExist";
                $.post(url, {directoryId: directoryId, directoryName: directoryName}, function (data) {
                    if (data.success) {
                        alert("元数据标准名称已存在，请重新输入！");
                        directoryForm.name.focus();
                        return false;
                    } else {
                        if (directoryForm.showOrder.value == "") {
                            alert("请输入排列序号");
                            directoryForm.showOrder.focus();
                            return false;
                        } else if (directoryForm.description.value.length > 200) {
                            alert("备注不大于200个字符");
                            directoryForm.description.focus();
                            return false;
                        } else {
                            directoryForm.action = "directoryUpdate";
                            directoryForm.submit();
                        }
                    }
                });
            }
            /*if(saveImg!=""){
             if(checkFileType(saveImg)!=3){
             myAlert("上传类型不正确");
             return false;
             }
             }*/
        }
    </script>
</head>

<body>
<form method="post" name="directoryForm" id="directoryForm" enctype="multipart/form-data">
    <input type="hidden" name="offset" value="${params.offset}"/>
    <input type="hidden" name="sort" value="${params.sort}"/>
    <input type="hidden" name="order" value="${params.order}"/>
    <input type="hidden" name="max" value="${params.max}"/>
    <input type="hidden" name="id" id="id" value="${directory?.id}"/>
    <input type="hidden" name="editPage" value="${editPage}"/>

    <div id="addTable">
        <div>
            <table width="98%" border="0" cellspacing="0">
                <tbody>
                <tr>
                    <td align="left"><span style="margin-left: 10px; font-weight: bold; color: #000;">
                        <g:if test="${directory == null}">添加元数据标准</g:if>
                        <g:else>修改元数据标准</g:else>
                    </span></td>
                </tr>
            </table>
            <table class="table">

                <tr>
                    <td width="120" align="right">元数据标准名称 :</td>
                    <td><input id="name" name="name" value="${directory?.name}" maxLength="20" type="text"
                               style="width: 400px"
                               class="form-control" size="52"/></td>
                    <td width="300"></td>
                </tr>
                <tr>
                    <td align="right">排列序号 :</td>
                    <td>
                        <input type="text" id="showOrder" maxLength="5" name="showOrder" class="form-control" size="52"
                               style="width: 400px;float: left"
                               value="${directory?.showOrder}"
                               onkeyup="this.value = this.value.replace(/\D/g, '')"
                               onafterpaste="this.value = this.value.replace(/\D/g, '')"/>

                        <span style="color: red;line-height: 30px;overflow: hidden">序号小的排前面，序号为0时不显示</span>
                    </td>
                    <td width="300" align="center"></td>
                </tr>
                %{--<tr>
                    <td width="120" align="right">上传路径 :</td>
                    <td><input id="uploadPath" name="uploadPath" value="${directory?.uploadPath}" maxLength="20"
                               type="text" style="width: 400px"
                               class="form-control" size="52"/></td>
                    <td width="300"></td>
                </tr>
                <tr>
                    <td align="right">图片 :</td>
                    <td>
                        <g:if test="${directory == null}"><input name="saveImg" id="saveImg" type="file"
                                                                 size="30"></g:if>
                        <g:else><input name="updateImg" id="saveImg" type="file"
                                       size="30"></g:else>

                    </td>
                    <td></td>
                </tr>--}%

                <tr>
                    <td align="right">备注:</td>
                    <td><textarea id="description" name="description" cols="50"
                                  class="form-control">${directory?.description}</textarea>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td align="left">
                        <g:if test="${directory == null}">
                        %{--<g:if test="${session.consumer.role == 0}">--}%
                                <input name="groupAdd" type="button" class="admin_default_but_blue"
                                       onClick="myGroupAdd()" value="添加"/>
                            %{--</g:if>
                            <g:else>
                                <input name="groupAdd" type="button" class="admin_default_but_blue"
                                       onClick="showInfo('${directory?.id}', '${directory?.name}', '${directory?.showOrder}')"
                                       value="添加"/>
                            </g:else>--}%
                        </g:if>
                        <g:else>
                            <input name="update_enter" type="button" class="admin_default_but_blue"
                                   onClick="myGroupUpdate()"
                                   value="确定"/>
                        </g:else>
                </tr>
            </tbody>
            </table>
        </div>
    </div>
</form>
</body>
</html>