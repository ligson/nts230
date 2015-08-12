<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/6/4
  Time: 10:11
--%>

<%@ page import="nts.user.special.domain.SpecialPoster; java.text.SimpleDateFormat; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>${message(code: 'my.creat.name')}${message(code: 'my.edit.name')}</title>
<r:require modules="swfupload,zTree"/>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
%{--<link rel="stylesheet" type="text/css"--}%
      %{--href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_userspace_index.css')}">--}%
%{--<link rel="stylesheet" type="text/css"--}%
      %{--href="${resource(dir: 'skin/blue/pc/front/css', file: 'communiuty_share_list.css')}">--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/boful/special', file: 'userSpecial.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'js/boful/special', file: 'bfUploadSpecial.js')}"></script>
</head>

<body>
<div class="my_album_in_body">
    <div class="my_album_in_con">
        <a href="${createLink(controller: 'my', action: 'myAlbumResource')}"
           class="btn btn-success btn-sm a_back">返回专辑首页</a>
        %{--      <a onclick="choseNew()" class="btn  btn-success btn-sm a_creat">创建专辑</a>--}%
    </div>
</div>

<div>
    <g:form controller="userSpecial" action="updateSpecial">
        <div class="my_album_des">
            <h1 class="my_album_in_title">专辑编辑</h1>
            <table class="table ">
                <tr>
                    <th>${message(code: 'my.album.name')}${message(code: 'my.designation.name')}</th>
                    <td><input name="name" class="form-control" style="width: 300px;"
                               value="${userSpecial?.name}"/><input type="hidden" name="id"
                                                                            value="${userSpecial?.id}"/></td>
            </tr>
            <tr>
                <th>${message(code: 'my.album.name')}${message(code: 'my.tally.name')}：</th>
                <td><input id="tags" class="form-control" style="width: 300px; float:left;" name="specialTags"
                           value="${userSpecial?.tags?.name}" size="30"/><span
                        class="album_warm_infor">(多个标签以逗号区分)</span></td>
            </tr>
            <tr>
                <th>${message(code: 'my.album.name')}${message(code: 'my.poster.name')}</th>
                <td><span id="uploadSpeed"></span><input id="selectFileBtn" type="button"/><input id="fileName"
                                                                                                  name="fileName"
                                                                                                  type="hidden"/><input
                        id="filePath" name="filePath" type="hidden"/> <input id="fileHash" name="fileHash"
                                                                             type="hidden"/><input id="fileSize"
                                                                                                   name="fileSize"
                                                                                                   type="hidden"/><input
                        id="fileType" name="fileType" type="hidden"/></td>
            </tr>
                %{--<tr>
                    <th>${message(code: 'my.poster.name')}${message(code: 'my.place.name')}</th>
                    <td><select name="showLocation">
                        <g:each in="${SpecialPoster.locationCnField}" var="locationFile">
                            <option value="${locationFile.key}">${locationFile.value}</option>
                        </g:each>
                    </select></td>
                </tr>--}%
                <tr>
                    <th>${message(code: 'my.album.name')}${message(code: 'my.introduction.name')}：</th>
                    <td><textarea cols="50" rows="5" name="description"
                                  class="form-control">${CTools.htmlToBlank(userSpecial?.description)}</textarea></td>
                </tr>
                <tr>
                <th>${message(code: 'my.review.name')}${message(code: 'my.setting.name')}：</th>
                <td>
                    <input class="review_inp" type="radio" name="allowRemark"
                           value="true" ${userSpecial?.allowRemark == true ? 'checked' : ''}/><span
                        class="review_infor">是</span>
                    <input class="review_inp" type="radio" name="allowRemark"
                           value="false" ${userSpecial?.allowRemark == false ? 'checked' : ''}/><span
                        class="review_infor">否</span>
                </td>
            </tr>
            <tr>
                <td colspan="2"><input type="submit" class="btn  btn-success" style="padding:  0 20px" value="修改"/></td>
            </tr>
        </table>
        </div>

        <div class="my_album_poster">
            <h1 class="my_album_poster_title">专辑海报</h1>
            <g:if test="${userSpecial?.posters.size() > 0}">
                <table class="table table-hover">
                    <tr>
                        <th align="center">${message(code: 'my.designation.name')}</th>
                        <th width="200" align="center">${message(code: 'my.hash.name')}</th>
                        %{--<th width="100" align="center">${message(code: 'my.place.name')}</th>--}%
                        <th width="100" align="center">${message(code: 'my.operation.name')}</th>
                    </tr>
                    <g:each in="${userSpecial?.posters}" var="poster">
                        <tr>
                            <td>${poster?.fileName}</td>
                            <td>${poster?.fileHash}</td>
                            %{--<td>${SpecialPoster.locationCnField.get(poster?.showLocation)}</td>--}%
                            <td><input type="button" onclick="deletePoster(${poster?.id})" class="btn btn-danger btn-xs"
                                       value="删除"/></td>
                        </tr>
                    </g:each>
                </table>
            </g:if>
        </div>
    </g:form>

</div>

<div id="treeDialog" title="选择文件">
    <div id="zTree" class="ztree"></div>
</div>
<script type="text/javascript">
    $(function () {
        var tag = $("#tags").val();
        $("#tags").val(tag.substr(1, tag.length - 2));
    })
</script>
</body>

</html>