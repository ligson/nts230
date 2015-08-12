<%--
  Created by IntelliJ IDEA.
  User: ligson
  Date: 14-3-19
  Time: 上午10:55
--%>

<%@ page import="com.boful.common.file.utils.FileType; nts.user.domain.Consumer; java.text.SimpleDateFormat; nts.utils.CTools" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>|${message(code: 'my.mined.name')}|${message(code: 'my.share.name')}|${message(code: 'my.list.name')}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <Link media="screen" href="${resource(dir: 'skin/blue/pc/common/css', file: 'unknow_style.css')}" type=text/css
          rel=stylesheet>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/common/css', file: 'my_userspace_index.css')}">
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'communiuty_share_list.css')}">

    <r:require modules="string,jwplayer,zTree"/>
    <script type="text/javascript" src="${resource(dir: 'js/jquery/', file: 'scrollpagination.js')}"></script>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'scrollpagination_boful.css')}">

    %{--右键--}%
    %{--<link rel="stylesheet" type="text/css"--}%
    %{--href="${resource(dir: 'skin/blue/pc/front/css', file: 'context.standalone.css')}">--}%
    <script type="text/javascript" src="${resource(dir: 'js/jquery/', file: 'rightclick.context.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/jquery/', file: 'rightclick_code.js')}"></script>
    %{--右键--}%

    <!--IE7下兼容问题-->
    <!--[if lte IE 7]>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/front/css', file: 'mysharingie7_hack.css')}">
  <![endif]-->
    <r:require modules="swfupload"/>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'fileType.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/file', file: 'fileList.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofuljwplayer.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js', file: 'boful/common/bofulFlexpaper.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/swfobject', file: 'swfobject.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'bofulswfobject.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/file', file: 'updateFile.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/file', file: 'userFileTree.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'allselect.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/boful/common', file: 'browserjude.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper.js')}"></script>
    %{--预览图片的CSS和js  prettyPhoto.css   jquery.prettyPhoto.js--}%
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/common/css', file: 'prettyPhoto.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/jquery', file: 'jquery.prettyPhoto.js')}"></script>

    <script type="text/javascript"
            src="${resource(dir: 'js/flexPaper_2.1.9/js', file: 'flexpaper_handlers.js')}"></script>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <script type="text/javascript">
        $(function () {
            // 淡入代码元素的元素
            $.fn.fadeInWithDelay = function () {
                var delay = 0;
                return this.each(function () {
                    $(this).delay(delay).animate({opacity: 1}, 200);
                    delay += 100;
                });
            };

        });
    </script>
    %{--图片预览基本配置--}%
    <script type="text/javascript" charset="utf-8">
        $(document).ready(function () {
            $("area[rel^='prettyPhoto']").prettyPhoto();

            $(".gallery:first a[rel^='prettyPhoto']").prettyPhoto({animation_speed: 'normal', theme: 'light_square', slideshow: 3000, autoplay_slideshow: true});
            $(".gallery:gt(0) a[rel^='prettyPhoto']").prettyPhoto({animation_speed: 'fast', slideshow: 10000, hideflash: true});


        });
        function sAll() {

            moveFile();
        }
    </script>
    <style type="text/css">
    .ui-widget-content {
        z-index: 110;
    }

    .serch_body {
        width: 328px;
        display: block;
        height: 38px;
        overflow: hidden;
        float: left;
    }

    </style>

</head>

<body>
<input value="${total}" id="maxCount" type="hidden"/>
<input value="${fileList.size()}" id="fileCount" type="hidden"/>
<input value="" id="fileHash" type="hidden"/>
<input value="" id="fileName" type="hidden"/>
<input value="" id="filePath" type="hidden"/>
<input value="" id="fileId" type="hidden"/>
<input value="" id="categoryId" type="hidden"/>
<input value="" id="categoryName" type="hidden"/>
<input id="name" value="${session?.consumer.name}" type="hidden"/>
<input id="maxSpaceSize" value="${session?.consumer.maxSpaceSize}" type="hidden"/>
<input id="useSpaceSize" value="${session?.consumer.useSpaceSize}" type="hidden"/>
<input id="parentId" type="hidden"/>
<input type="hidden" id="role" value="${session?.consumer?.role}">

<div class="row panel panel-default" style="margin: 0 0 10px 0; padding: 10px 0 10px 0;">
    <table>
        <tr>
            <g:if test="${Consumer.findByName(session.consumer.name)?.uploadState == 1}">
                <td>
                    <div style="margin-left: 10px; margin-top:5px;width:90px;">
                        <input id="selectFileBtn" type="button"/>
                    </div>
                </td>
            </g:if>
            <td>
                <div>
                    <button type="button" class="btn btn-default btn-sm btnie_width" id="allFileBtn">
                        <span class="glyphicon glyphicon-folder-close folderie7"></span>${message(code: 'my.all.name')}${message(code: 'my.files.name')}
                    </button>
                </div>
            </td>
            <td>
                <div>
                    <button type="button" class="btn btn-default btn-sm"
                            style="width:100px; margin: 0 5px; display: block"
                            id="createfolder">
                        <span class="glyphicon glyphicon-folder-close folderie7" style="float: left"></span> <span
                            style="float: right;font-size: 12px;">${message(code: 'my.creat.name')}${message(code: 'my.folder.name')}</span>
                    </button>
                </div>
            </td>
            <td>
                <div class="col_box2" style="width: 78px;">
                    <button type="button" class="btn btn-default btn-sm" id="recycleBtn">
                        <span class="glyphicon glyphicon-shopping-cart"></span> ${message(code: 'my.recycling.name')}
                    </button>
                </div>
            </td>
            <td>
                <div class="col_box1">
                    <button type="button" id="deleteFileOrCategory" class="btn btn-default btn-sm">
                        <span class="glyphicon glyphicon-remove removeie7"></span> ${message(code: 'my.delete.name')}
                    </button>
                </div>
            </td>
            <td>
                <div class="col_box1">
                    <button type="button" id="sharing" class="btn btn-default btn-sm" style="margin-left: 5px;">
                        <span class="glyphicon glyphicon-share shareie7"></span> ${message(code: 'my.publicity2.name')}
                    </button>
                </div>
            </td>
            <td>
                <div class="col_box1">
                    <button type="button" id="sharingAll" class="btn btn-default btn-sm" style="margin-left: 5px;"
                            onclick="sAll()">
                        <span class="glyphicon glyphicon-share shareie7"></span> ${message(code: 'my.publicity3.name')}
                    </button>
                </div>
            </td>
            <td>
                <div style="float: right;text-align: right; ">
                    <div class="input-group" style="float: right">
                        <input type="text" class="form-control formcontrol_sty" id="searchName"
                               style="width: 100px; margin-left: 5px;"/>
                        <span class="input-group-btn" style="float: left">
                            <button class="btn btn-default bt_ie7" id="searchBtn" type="button"><span
                                    class="glyphicon glyphicon-search serchie7"></span>
                            </button>
                        </span>
                    </div>
                </div>
            </td>
        </tr>
    </table>

    %{--<div class="col_box1" style="margin-left: 10px;">
    <input id="selectFileBtn" type="button"/>
    </div>--}%
    %{--<div class="col_box2"  style="width: 90px; *margin-right: 20px;" >
        <button type="button"  class="btn btn-default btn-sm btnie_width" id="allFileBtn">
            <span class="glyphicon glyphicon-folder-close folderie7"></span>  全部文件
        </button>
    </div>
    <div class="col_box2">
        <button type="button"  class="btn btn-default btn-sm btnie_width" id="createfolder">
            <span class="glyphicon glyphicon-folder-close folderie7"></span> 新建文件夹
        </button>
    </div>--}%
    %{-- <div class="col_box2" style="width: 78px;">
         <button type="button" class="btn btn-default btn-sm" id="recycleBtn">
             <span class="glyphicon glyphicon-shopping-cart"></span>  回收站
         </button>
     </div>
     <div class="col_box1">
         <button type="button" id="deleteFileOrCategory"  class="btn btn-default btn-sm">
             <span class="glyphicon glyphicon-remove removeie7"></span> 删除
         </button>
     </div>--}%
    %{--<div class="col_box1">
        <button type="button" id="sharing"  class="btn btn-default btn-sm">
            <span class="glyphicon glyphicon-share shareie7"></span> 分享
        </button>
    </div>--}%
    %{--<div class="col_box1">
        <button type="button" onclick="mySpecial()"  class="btn btn-default btn-sm">
            <span class="glyphicon glyphicon-share shareie7"></span>我的专辑
        </button>
    </div>--}%
    %{--<div class="col_box1">
        <button type="button" id="uploadpanle"  class="btn btn-default btn-sm">
            <span class="glyphicon glyphicon-cloud-download downloadie7"></span>上传状况
        </button>
        </div>--}%
    %{--<div style="float: right; width: 250px;*width: 180px;  text-align: right; margin-right: 10px;">
        <div class="input-group" style="float: right">
            <input type="text" class="form-control formcontrol_sty" id="searchName" style="width: 100px;" />
            <span class="input-group-btn" style="float: left">
                <button class="btn btn-default bt_ie7" id="searchBtn"   type="button">  <span class="glyphicon glyphicon-search serchie7"  ></span>
                </button>
            </span>
        </div>
    </div>--}%

</div>

<div class="row" style="width: 100%;height: 20px">
    <div id="topDiv"><a>${message(code: 'my.present.name')} ${message(code: 'my.place.name')}： ${message(code: 'my.mined.name')} ${message(code: 'my.files.name')} ></a><span
            name="app"></span></div>
</div>

<div id="scrollpagboful" class="panel panel-default">

    <table>
        <tr style="height: 32px; line-height: 32px;border-bottom: 1px solid #DDD; display: block">
            <td>
                <div class="col-md-1 mysharinglist_cent" style="width: 40px;"><input type="checkbox" name="allselect"
                                                                                     class="allselect"/></div>
            </td>
            <td>
                <div class="col-md-6 "
                     style="overflow: hidden">${message(code: 'my.resources.name')}${message(code: 'my.designation.name')}</div>
            </td>
            <td>
                <div class="col-md-2 " style="width: 120px;"></div>
            </td>
            <td>
                <div class="col-md-1 mysharinglist_cent"
                     style="width: 100px; text-align: left">${message(code: 'my.size.name')}</div>
            </td>
            <td>
                <div class="col-md-2 mysharinglist_cent">${message(code: 'my.upload.name')}${message(code: 'my.time.name')}</div>
            </td>
        </tr>
    </table>

    <div id="content" class="shar_sellectlist">
        <table class="append_folder"></table>

        <div id="categoryDiv">
            <table>
                <g:each in="${categoryList}" var="category">
                    <tr id="categoryDiv_${category?.id}"
                        onmousedown="userFilebtn(event, 'c_${category?.id}', '${category?.name}', 'null', 'null', 'category')"
                        name="category"
                        onmousemove="categoryFileId(${category?.id}, '${category?.name}', 'null', 'category')"
                        onmouseout="folderOut(${category?.id})">
                        <td width="40">
                            <input type="hidden" id="cId" value="${category?.id}"/>
                            <input type="hidden" id="cName" value="${category?.name}"/>

                            <div class="col-md-1 mysharinglist_cent" style="width: 40px;"><input
                                    id="checkBox_c_${category.id}"
                                    name="checkCategoryList" class="checklist" type="checkbox" value="${category?.id}"
                                    onclick="removeSelect('categoryDiv_${category?.id}')"/>
                            </div>
                        </td>
                        <td width="370">
                            <div style="line-height: 28px;" ondblclick="checkCategory('${category?.id}')"><span
                                    class='myshar_listico share_class_files_icon'></span>
                                <span id="spanCate">${category?.name}</span>
                                <span id="spanCate1" style="display: none">
                                    <input class='form-control f_controlsty' value="${category?.name}"
                                           id="updateCName"/><a class='glyphicon glyphicon-ok btn-sm bt1_ie7 wy_sty3'
                                                                onclick="updateCate(${category?.id})"></a>
                                    <button class='btn-link glyphicon glyphicon-remove btn-sm removeie7 wy_sty2'
                                            onclick="resetCate(${category?.id})"></button>
                                </span>
                            </div>
                        </td>
                        <td width="120">
                            <div>
                                <div class="shar_tools">
                                    <a style="float: left;"><span
                                            class="myshar_listico share_class_files_icon"
                                            style="padding: 0;margin: 0 5px;"></span></a>
                                    <a style="float: left;"><span class="myshar_listico share_class_files_icon"
                                                                  style="padding: 0;margin: 0 8px;"></span></a>
                                    <a style="float: left;"><span class="myshar_listico share_class_files_icon"
                                                                  style="padding: 0;margin: 0 5px;"></span></a>
                                </div>
                            </div>
                        </td>
                        <td width="100">
                            <div class="col-md-1 mysharinglist_cent" style="width: 100px; text-align: left">--</div>
                        </td>
                        <td>
                            <div class="col-md-2 mysharinglist_cent">${new SimpleDateFormat('yyyy-MM-dd').format(category?.createdDate)}</div>
                        </td>
                    </tr>
                </g:each>
            </table>
        </div>

        <div id="userFileDiv">
            <table id="userFileTable">
                <tbody>
                <g:each in="${fileList}" var="userFile">
                    <tr id="userFileDiv_${userFile?.id}"
                        onmousedown="userFilebtn(event, ${userFile?.id}, '${userFile?.name}', '${userFile?.fileHash}', '${userFile?.filePath}', 'file')"
                        name="userFile"
                        onmousemove="categoryFileId(${userFile?.id}, '${userFile?.name}', '${userFile?.fileHash}', 'file')"
                        onmouseout="fileOut(${userFile?.id})">
                        <td width="40">
                            <input value="${userFile?.fileHash}" id="hash" type="hidden"/>
                            <input value="${userFile?.filePath}" id="path" type="hidden"/>
                            <input value="${userFile?.name}" id="fname" type="hidden"/>
                            <input value="${userFile?.id}" id="fid" type="hidden"/>

                            <div class="col-md-1 mysharinglist_cent" style="width: 40px;">
                                <input name="checkFileList" id="checkBox_${userFile.id}" class="checklist"
                                       type="checkbox" value="${userFile?.id}"
                                       onclick="removeSelect('userFileDiv_${userFile?.id}')"/>
                            </div>
                        </td>
                        <td width="370">
                            <div style="overflow: hidden;line-height: 28px;">
                                <g:if test="${FileType.isVideo(userFile?.filePath)}">
                                    <span class="myshar_listico share_class_icon"></span>
                                </g:if>
                                <g:elseif test="${FileType.isImage(userFile?.filePath)}">
                                    <span class="myshar_listico share_class_icon1"></span>
                                </g:elseif>
                                <g:elseif
                                        test="${FileType.isDocument(userFile?.filePath) || userFile?.name.endsWith("pdf") || userFile?.name.endsWith("PDF")}">
                                    <span class="myshar_listico share_class_icon2"></span>
                                </g:elseif>
                                <g:elseif test="${FileType.isAudio(userFile?.filePath)}">
                                    <span class="myshar_listico share_class_icon3"></span>
                                </g:elseif>
                                <g:elseif test="${userFile?.name.endsWith("swf") || userFile?.name.endsWith("SWF")}">
                                    <span class="myshar_listico share_class_icon"></span>
                                </g:elseif>
                                <g:else>
                                    <span class="myshar_listico share_class_icon4"></span>
                                </g:else>
                                <span id="spanFile">
                                    <a title="${CTools.htmlToBlank(userFile?.name)}"
                                       onclick="playBtn('${CTools.htmlToBlank(userFile?.name)}', '${userFile?.filePath}', '${userFile?.fileHash}')">${CTools.cutString(userFile?.name, 30)}</a>
                                </span>
                                <span id="spanFile1" style="display: none">
                                    <input class='form-control f_controlsty'
                                           value="${CTools.htmlToBlank(userFile?.name)}"
                                           id="updateName"/><a class='glyphicon glyphicon-ok btn-sm bt1_ie7 wy_sty3'
                                                               onclick="updateFile(${userFile?.id})"></a>
                                    <button class='btn-link glyphicon glyphicon-remove btn-sm removeie7 wy_sty2'
                                            onclick="resetFile(${userFile?.id})"></button>
                                </span>
                            </div>
                        </td>
                        %{-- <td class="shar_sty1">已分享
                         </td>--}%
                        <td width="120">
                            <div>
                                <div class="shar_tools">
                                    <a class="state_display" title="下载" name="download"><span
                                            class="glyphicon glyphicon-cloud-download btn-sm downloadie7"
                                            style="padding: 0;margin: 0 5px;"></span></a>
                                    <a class="state_display" title="公开" name="sharingFile"><span
                                            class="glyphicon glyphicon-share btn-sm shareie7"
                                            style="padding: 0;margin: 0 8px;"></span></a>
                                    <a class="state_display" title="删除" name="deleteFile"><span
                                            class="glyphicon glyphicon-remove btn-sm removeie7"
                                            style="padding: 0;margin: 0 5px;"></span></a>
                                </div>
                            </div>
                        </td>
                        <td width="100">
                            <div class="col-md-1 mysharinglist_cent" style="width: 100px; text-align: left"
                                 name="fileSize">${convertHumanUnit(fileSize: userFile?.fileSize)}
                            </div>
                        </td>
                        <td>
                            <div class="col-md-2 mysharinglist_cent">${new SimpleDateFormat('yyyy-MM-dd').format(userFile?.createdDate)}</div>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>

    </div>

    <div id="loadingDiv"><table></table></div>

    <div class="loading" id="loading">${message(code: 'my.loading.name')}</div>

    <div class="loading" id="nomoreresults">${message(code: 'my.loaded.name')}</div>
</div>
<br>

<div id="spaceSizeDiv" class="panel panel-default"
     style="height:30px; padding-left: 10px;padding-top: 5px;display: none;">
    <strong>个人空间大小：<span id="showMaxSize"></span>&nbsp;&nbsp;&nbsp;&nbsp;已经使用空间：<span id="showUseSize"></span></strong>
</div>
%{--<div class="row" style="margin: 0 0 10px 0;">
    <div class="col-lg-6" id="topDiv"> <a>当前位置：我的文件 ></a><span name="app"></span></div>
</div>--}%

%{--<div id="scrollpagboful" class="panel panel-default" >
    <div class="row mysharinglist_line" >
        <div class="col-md-1 mysharinglist_cent" style="width: 40px;" ><input type="checkbox" name="allselect" class="allselect" /></div>

        <div class="col-md-6 " style="overflow: hidden">资源名称</div>

        <div class="col-md-2 " style="width: 120px;"></div>
        <div class="col-md-1 mysharinglist_cent" style="width: 100px; text-align: left" >大小</div>
        <div class="col-md-2 mysharinglist_cent" >上传时间</div>
    </div>

    <div id="content" class="shar_sellectlist">

        <div class="append_folder">

        </div>
        <div id="categoryDiv">
        <g:each in="${categoryList}" var="category">
            <div name="category" class="row mysharinglist_line"  id="categoryDiv_${category?.id}">
                <input type="hidden" id="cId" value="${category?.id}"/>
                <input type="hidden" id="cName" value="${category?.name}"/>
                <div class="col-md-1 mysharinglist_cent" style="width: 40px;"><input name="checkCategoryList" class="checklist"  type="checkbox" value="${category?.id}" /></div>

                <div class="col-md-6" style="line-height: 28px;"><span class='glyphicon glyphicon-folder-close btn-lg folderie7 wy_sty1'></span>
                    <span id="spanCate"><a onclick="checkCategory('${category?.id}')">${category?.name}</a></span>
                    <span id="spanCate1" style="display: none">
                        <input class='form-control f_controlsty' value="${category?.name}" id="updateCName"/><a class='glyphicon glyphicon-ok btn-sm bt1_ie7 wy_sty3' onclick="updateCate(${category?.id})"></a>
                        <button class='btn-link glyphicon glyphicon-remove btn-sm removeie7 wy_sty2' onclick="resetCate()"></button>
                    </span>
                </div>
                <div class="col-md-2" >
                    <div class="shar_tools">
                        <a style="float: left;"><span  class="glyphicon glyphicon-cloud-download btn-sm downloadie7" style="padding: 0;margin: 0 5px;"></span></a>
                        <a style="float: left;"><span class="glyphicon glyphicon-share btn-sm shareie7" style="padding: 0;margin: 0 8px;"></span></a>
                        <a style="float: left;"> <span  class="glyphicon glyphicon-remove btn-sm removeie7" style="padding: 0;margin: 0 5px;"></span></a>
                    </div>
                </div>
                <div class="col-md-1 mysharinglist_cent" style="width: 100px; text-align: left">--</div>
                <div class="col-md-2 mysharinglist_cent">${new SimpleDateFormat('yyyy-MM-dd').format(category?.createdDate)}</div>
            </div>
        </g:each>
        </div>
        <div id="userFileDiv">
        <g:each in="${fileList}" var="userFile">

            <div class="row mysharinglist_line display_tool" id="userFileDiv_${userFile?.id}" name="userFile">
                <input value="${userFile?.fileHash}" id="hash" type="hidden"/>
                <input value="${userFile?.name}" id="fname" type="hidden"/>
                <input value="${userFile?.id}" id="fid" type="hidden"/>
                <div class="col-md-1 mysharinglist_cent" style="width: 40px;"><input name="checkFileList" class="checklist"  type="checkbox" value="${userFile?.id}" /></div>

                <div class="col-md-6" style="overflow: hidden;line-height: 28px;">
                    <g:if test="${FileType.isVideo(userFile?.filePath)}">
                        <span class="myshar_listico share_class_icon" ></span>
                    </g:if>
                    <g:elseif test="${FileType.isImage(userFile?.filePath)}">
                        <span class="myshar_listico share_class_icon1" ></span>
                    </g:elseif>
                    <g:elseif test="${FileType.isDocument(userFile?.filePath)}">
                        <span class="myshar_listico share_class_icon2" ></span>
                    </g:elseif>
                    <g:elseif test="${FileType.isAudio(userFile?.filePath)}">
                        <span class="myshar_listico share_class_icon3" ></span>
                    </g:elseif>
                    <g:else>
                        <span class="myshar_listico share_class_icon4" ></span>
                    </g:else>
                    <span id="spanFile">
                        <a title="${userFile?.name}" onclick="playBtn('${userFile?.name}','${userFile?.fileHash}')">${CTools.cutString(userFile?.name, 30)}</a>
                    </span>
                    <span id="spanFile1" style="display: none">
                        <input class='form-control f_controlsty' value="${userFile?.name}" id="updateName"/><a class='glyphicon glyphicon-ok btn-sm bt1_ie7 wy_sty3' onclick="updateFile(${userFile?.id})"></a>
                        <button class='btn-link glyphicon glyphicon-remove btn-sm removeie7 wy_sty2' onclick="resetFile()"></button>
                    </span>
                    </div>
            <div class="col-md-2">
                <div class="shar_tools">
                <a class="state_display" title="下载" name="download"><span  class="glyphicon glyphicon-cloud-download btn-sm downloadie7" style="padding: 0;margin: 0 5px;"></span></a>
                <a class="state_display" title="共享" name="sharingFile"><span class="glyphicon glyphicon-share btn-sm shareie7" style="padding: 0;margin: 0 8px;"></span></a>
               <a class="state_display" title="删除" name="deleteFile"> <span  class="glyphicon glyphicon-remove btn-sm removeie7" style="padding: 0;margin: 0 5px;"></span></a>
                </div>
                </div>
                <div class="col-md-1 mysharinglist_cent" style="width: 100px; text-align: left"  name="fileSize">${convertHumanUnit(fileSize:userFile?.fileSize)}
                </div>
                <div class="col-md-2 mysharinglist_cent">${new SimpleDateFormat('yyyy-MM-dd').format(userFile?.createdDate)}</div>
            </div>

        </g:each>

            <div id="loadingDiv"></div>
        </div>

    </div>
    <div class="loading" id="loading">稍等……正在加载!</div>
    <div class="loading" id="nomoreresults">展示完相关资源</div>
</div>--}%

<div id="playViewDialog"></div>

<div id="fileSharViewDialog"></div>

<div id="categoryDialog" style="width: 400px">
    请选择文件夹:<div id="zTree" class="ztree"></div>
    <input id="zid" type="hidden">
    <input id="zname" type="hidden">
</div>

<div id="fileRoleDialog" style="width: 400px" title="权限设置">

</div>
%{--上传列表--}%

<div id="uploadListDialog" title="上传列表">
    <div class="panel-body">
        <table class="table table-striped">
            <tbody>
            <tr>
                <th width="220">文件名</th>
                <th width="100">大小</th>
                <th width="150">进度</th>
                <th width="80">状态</th>
            </tr>
            </tbody>
        </table>
    </div>
</div>

<div id="sharingFileDialog">
    <div class="album_win_body">
        <input type="hidden" id="specialId"/>

        <div id="communityDiv"></div>

        <div id="boardDiv"></div>

        <div id="sharingSetDiv">
            <input type="hidden" id="boardId"/>
            下载权限:<input type="radio" name="canDownload" value="true" checked/>能<input type="radio" name="canDownload"
                                                                                      value="false"/>否<br>
            共享范围:<select name="shareRange">
            <g:each in="${nts.commity.domain.ForumSharing.rangeCnField}" var="range">
                <option value="${range?.key}">${range?.value}</option>
            </g:each>
        </select>
        </div>
    </div>
</div>
%{--上传列表结束--}%
<script language="JavaScript" type="text/JavaScript">
    //鼠标移动显示下载分享等
    /*$(document).ready(function(){
     $(".display_tool").mouseenter(function(){
     //                var shar_state =  $(this).find(".shar_tools").css("display");
     $(this).find(".shar_tools").css("display","block");
     $(this).css("background-color","#E3FCE4");
     }).mouseleave(function(){
     $(this).find(".shar_tools").css("display","none");
     $(this).css("background-color","#ffffff");
     });


     //添加文件夹

     })*/
</script>
</body>
</html>