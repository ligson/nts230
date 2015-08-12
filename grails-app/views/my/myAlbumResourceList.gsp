<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/6/4
  Time: 15:12
--%>

<%@ page import="com.boful.common.file.utils.FileType; java.text.SimpleDateFormat; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${message(code: 'my.album.name')}${message(code: 'my.detailed.name')}</title>
    <r:require modules="string,jwplayer,zTree"></r:require>
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'my_userspace_index.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'communiuty_share_list.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'myAlbumResourceList.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'communiuty_share_list.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'myAlbumResource.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper_handlers.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofulFlexpaper.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/swfobject', file: 'swfobject.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'bofulswfobject.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/special', file: 'userSpecialTree.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/special', file: 'userSpecial.js')}"></script>
    <style type="text/css">
    .ui-widget-content {
        z-index: 110;
    }
    </style>
</head>

<body>
<!---------分享弹出框--------->
<div id="groupAlbum" class="album_share_group">
    <div class="album_win_close_box"><input type="button" value="" class="album_win_close" onclick="albumClose();">
    </div>

    <div class="album_win_body">

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
        <tr>
            <td>
                <div class="album_creat_box">
                    <button type="button" class="btn btn-success  btn-sm" style="width:105px; display: block" id=""
                            onclick="choseNew();">
                        <em class=" album_creat_icon"
                            style="float: left ;font-size:12px "></em> <span>${message(code: 'my.creat.name')}${message(code: 'my.album.name')}</span>
                    </button>
                </div>
            </td>
        </tr>
    </table>
</div>

<div class="row" style="width: 740px ; height: 20px;  margin-left: 20px; display: block">
    <div id="topDiv"><a>${message(code: 'my.present.name')}${message(code: 'my.place.name')}：${message(code: 'my.mined.name')}${message(code: 'my.album.name')} ></a><span
            name="app"></span></div>
</div>

<div class="my_abum_resource_content">
    <div class="my_abum_resource_top">
        <div class="my_album_item_img"><img
                src="${posterLinkNew(fileHash: userSpecial?.posters[0]?.fileHash, size: '54x54')}"/></div>

        <div class="my_album_lis_item_infor">
            <input type="hidden" id="specialId" value="${userSpecial?.id}"/>

            <h1><span class="my_album_other_tt"
                      title="${userSpecial?.name}">${CTools.cutString(userSpecial?.name, 15)}</span><span
                    class="my_album_other_opreat">
                <label><input type="button" onclick="addSpecialFile()" class="btn btn-success btn-sm" value="添加文件">
                </label>
                <label><input type="button" onclick="executeSpecial(${userSpecial?.id})" class="btn btn-default btn-sm"
                              value="编辑专辑"></label>
                <label><input type="button" onclick="deleteSpecial(${userSpecial?.id})" class="btn btn-default btn-sm"
                              value="删除专辑"></label>
                <label><input type="button" onclick="shareGroup(${userSpecial?.id});" class="btn btn-default btn-sm"
                              value="分享专辑"></label>
            </span></h1>

            <p>${CTools.cutString(CTools.htmlToBlank(userSpecial?.description), 50)}</p>
        </div>

    </div>

    <div class="aibum_resource_list">
        <h1>${message(code: 'my.album.name')}<span>${specialFileList?.size()}</span>${message(code: 'my.files.name')}
        </h1>

        <div class="aibum_resource_list_tab">
            <table class=" table table-hover">
                <tbody>
                <tr>
                    <th width="80" align="center">媒体类型</th><th align="center">文件名</th><th width="100"
                                                                                          align="center">大小</th><th
                        width="120" align="center">浏览次数</th><th width="100" align="center">创建日期</th><th width="60"
                                                                                                        align="center">操作</th>
                </tr>
                <g:each in="${specialFileList}" var="specialFile">
                    <tr>
                        <td align="center">
                            <g:if test="${FileType.isVideo(specialFile?.userFile?.filePath)}">
                                <span class="tab_math_icon"></span>
                            </g:if>
                            <g:elseif test="${FileType.isImage(specialFile?.userFile?.filePath)}">
                                <span class="tab_math_image_icon"></span>
                            </g:elseif>
                            <g:elseif
                                    test="${FileType.isDocument(specialFile?.userFile?.filePath) || specialFile?.userFile?.filePath.endsWith("pdf") || specialFile?.userFile?.filePath.endsWith("PDF")}">
                                <span class="tab_math_doc_icon"></span>
                            </g:elseif>
                            <g:elseif test="${FileType.isAudio(specialFile?.userFile?.filePath)}">
                                <span class="tab_math_audio_icon"></span>
                            </g:elseif>
                            <g:elseif
                                    test="${specialFile?.userFile?.filePath.endsWith("swf") || specialFile?.userFile?.filePath.endsWith("SWF")}">
                                <span class="tab_math_icon"></span>
                            </g:elseif>
                            <g:else>
                                <span class="tab_math_other_icon"></span>
                            </g:else>

                        </td>
                        <td><a onclick="playShow(${specialFile?.id}, '${specialFile?.name}', '${specialFile?.userFile?.filePath}', '${specialFile?.userFile?.fileHash}')"
                               title="${specialFile?.name}">${CTools.cutString(specialFile?.name, 15)}</a>
                        </td>
                        <td>${convertHumanUnit(fileSize: specialFile?.userFile.fileSize)}</td>
                        <td>${specialFile?.userFile?.viewNum}</td>
                        <td>${new SimpleDateFormat('yyyy-MM-dd').format(specialFile?.createdDate)}</td>
                        <td><label><input type="button"
                                          onclick="deleteSpecialFile(${specialFile?.id}, ${specialFile?.userSpecial?.id})"
                                          class="btn btn-warning btn-xs" value="删除"></label></td>
                    </tr>
                </g:each>

                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="treeDialog" title="选择文件">
    <div id="zTree" class="ztree"></div>
</div>

<div id="addFileDialog" title="选择文件">
    <div id="zTree1" class="ztree"></div>
</div>

<div id="playViewDialog"></div>

</body>
</html>