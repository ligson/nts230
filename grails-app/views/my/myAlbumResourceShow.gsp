<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/6/4
  Time: 10:11
--%>

<%@ page import="nts.user.special.domain.SpecialPoster; java.text.SimpleDateFormat; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>${message(code: 'my.album.name')}${message(code: 'my.edit.name')}</title>
<r:require modules="swfupload"/>
<link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
%{--<link rel="stylesheet" type="text/css"--}%
      %{--href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_userspace_index.css')}">--}%
%{--<link rel="stylesheet" type="text/css"--}%
      %{--href="${resource(dir: 'skin/blue/pc/front/css', file: 'communiuty_share_list.css')}">--}%
</head>

<body>
<div class="my_album_in_body">
    <div class="my_album_in_con">
        <a href="${createLink(controller: 'my', action: 'myAlbumResource')}"
           class="btn btn-success   btn-sm a_back">返回专辑首页</a>
        %{--       <a onclick="choseNew()" class="btn  btn-success btn-sm a_creat">创建专辑</a>--}%
    </div>
</div>

<div class="my_album_introduction">

    <g:form controller="userSpecial" action="updateSpecial">
        <div class="my_album_des">
            <h1 class="my_album_in_title">专辑详细
                <a href="${createLink(controller: 'my', action: 'myAlbumResourceEdit', params: [id: userSpecial?.id])}"
                   title="编辑专辑" class="item_opreat_fix"></a>

            </h1>
            <table width="100%" class="table tablle-hover">
                <tr>
                    <th>${message(code: 'my.album.name')}${message(code: 'my.designation.name')}：</th>
                    <td>${userSpecial?.name}</td>
                </tr>
                <tr>
                    <th height="30">${message(code: 'my.album.name')}${message(code: 'my.tally.name')}：</th>
                    <td><g:each in="${userSpecial?.tags}" var="tag">
                        ${tag?.name}&nbsp;&nbsp;&nbsp;&nbsp;
                    </g:each></td>
                </tr>

                <tr>
                    <th>${message(code: 'my.album.name')}描述：</th>
                    <td>${CTools.htmlToBlank(userSpecial?.description)}</td>
                </tr>
                <tr>
                    <th>能否评论：</th>
                    <td>${userSpecial?.allowRemark == true ? '能' : '否'}</td>
                </tr>
            </table>
        </div>

        <div class="my_album_poster">
            <h1 class="my_album_poster_title">专辑海报</h1>
            <g:if test="${userSpecial?.posters.size() > 0}">
                <table class="table table-hover">
                    <tr>
                        <th>名称</th>
                        <th>hash</th>
                        %{-- <th>位置</th>--}%
                    </tr>
                    <g:each in="${userSpecial?.posters}" var="poster">
                        <tr>
                            <td>${poster?.fileName}</td>
                            <td>${poster?.fileHash}</td>
                            %{--<td>${SpecialPoster.locationCnField.get(poster?.showLocation)}</td>--}%
                        </tr>
                    </g:each>
                </table>
            </g:if>
        </div>
    </g:form>
</div>


<script type="text/javascript">
    $(function () {
        var tag = $("#tags").val();
        $("#tags").val(tag.substr(1, tag.length - 2));
    })
</script>
</body>

</html>