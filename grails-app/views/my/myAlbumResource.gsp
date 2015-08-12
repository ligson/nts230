<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/6/4
  Time: 10:11
--%>

<%@ page import="java.text.SimpleDateFormat; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.mined.name')}${message(code: 'my.album.name')}</title>
    <r:require modules="zTree"></r:require>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'myAlbumResource.css')}">
    %{--<link rel="stylesheet" type="text/css"href="${resource(dir: 'skin/blue/pc/front/css', file: 'communiuty_share_list.css')}">--}%
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/special', file: 'userSpecialTree.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/special', file: 'userSpecial.js')}"></script>
    <style type="text/css">
    .ui-widget-content {
        z-index: 110;
    }
    .divTT{ border-right:1px solid #3C3437;border-left: 1px solid #3C3437;border-bottom: 1px solid #3C3437}
    </style>
</head>

<body>
<!---------分享弹出框--------->
<div id="groupAlbum" class="album_share_group">
    <div class="album_win_close_box"><input type="button" value="" class="album_win_close" onclick="albumClose();">
    </div>

    <div class="album_win_body">
        <input type="hidden" id="specialId"/>

        <div id="communityDiv">
            
        </div>

        <div id="boardDiv">

        </div>

        <div id="sharingSetDiv">
            <input type="hidden" id="boardId"/>

            <div class="share_opreat_mgr"><div>下载权限:</div>

                <div><input type="radio" name="canDownload" value="true" checked/>能</div>

                <div><input type="radio" name="canDownload" value="false"/>否</div></div>

            <div class="share_opreat_mgr"><div>共享范围:</div>

                <div><select name="shareRange">
                    <g:each in="${nts.commity.domain.ForumSharing.rangeCnField}" var="range">
                        <option value="${range?.key}">${range?.value}</option>
                    </g:each>
                </select>
                </div>
            </div>
        </div>

    </div>

    <div class="album_share_but">
        <input type="button" value="分享" class="btn btn-success" onclick="specialSharing()">
    </div>
</div>

<div class="row panel panel-default" style="margin: 0 0 10px 0; padding: 10px 0 10px 0;">
    <table>
        <tbody>
        <tr>
            <td>
                <div class="album_creat_box">
                    <button type="button" class="btn btn-success btn-sm" id="" onclick="choseNew();">
                        <em class=" album_creat_icon"
                            style="float: left ;font-size:12px "></em> <span>${message(code: 'my.creat.name')}${message(code: 'my.album.name')}</span>
                    </button>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
</div>

<div class="row" style="width: 760px ; height: 20px; float: right">
    <div id="topDiv"><a>${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.mined.name')}${message(code: 'my.album.name')} ></a><span></span>
    </div>
</div>

<div class="my_album_items">
    <g:each in="${userSpecialList}" var="special">
        <div class="my_album_item">
            <div class="my_album_item_img">
                <img src="${posterLinkNew(fileHash: special?.posters[0]?.fileHash, size: '54x54')}"/>
            </div>

            <div class="my_album_item_infor">
                <h1><a href="${createLink(controller: 'my', action: 'myAlbumResourceList', params: [id: special?.id])}"
                       title="${special?.name}">${CTools.cutString(special?.name, 20)}</a>
                </h1>

                <P class="my_album_item_des">${CTools.cutString(CTools.htmlToBlank(special?.description), 50)}</P>

                <div class="my_album_item_opreat">
                    <a onclick="deleteSpecial(${special?.id})" class="item_opreat_delete" title="删除专辑"></a>
                    <a href="${createLink(controller: 'my', action: 'myAlbumResourceEdit', params: [id: special?.id])}"
                       class="item_opreat_fix" title="编辑专辑"></a>
                    <a href="${createLink(controller: 'my', action: 'myAlbumResourceShow', params: [id: special?.id])}"
                       target="_blank" class="item_opreat_word" title="专辑详细"></a>
                    <a id="sharingBtn" title="分享专辑" class="item_opreat_share"
                       onclick="shareGroup(${special?.id});"></a>
                    <a onclick="albumResourceRelease(${special?.id});" class="item_opreat_sent" title="发布为资源"></a>
                </div>

                <p class="my_album_item_time"><span>${new SimpleDateFormat('yyyy-MM-dd').format(special?.createdDate)}</span>
                </p>

            </div>

        </div>
    </g:each>
    <g:paginate total="${total}" controller="my" action="myAlbumResource"></g:paginate>
</div>

<div id="treeDialog" title="选择文件">
    <div id="zTree" class="ztree"></div>
</div>

</body>
<script type="text/javascript">
    $(document).ready(function () {
        $(".my_album_item").bind("mouseover", function () {
            if (!$(this).children(".my_album_item_time")[2].hidden) {
                $(this).children(".my_album_item_time").hide();
                $(this).children(".my_album_item_opreat").show();
            }
        });
        $(".my_album_item").bind("mouseleave", function () {
            $(".my_album_item_opreat").hidden();
            $(".my_album_item_time").show();
        });
    });
</script>
</html>