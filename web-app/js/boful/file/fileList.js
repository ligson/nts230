var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if ('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}

var bfFileUploadObject;
function fixFloatNum(num, size) {
    if (size == null) {
        size = 2;
    }
    var numStr = num.toString();
    var index = numStr.indexOf(".");
    if (index != -1) {
        index = (index + size) > (numStr.length - 1) ? (numStr.length - 1) : (index + size);
        return numStr.substr(0, index);
    } else {
        return num;
    }
}
/**
 * 转换单位
 * @param fileSize
 */
function convertHumanUnit(fileSize) {
    if (fileSize < 1024) {
        return fixFloatNum(fileSize, 2) + "B";
    } else if ((fileSize >= 1024) && (fileSize < 1024 * 1024)) {
        return fixFloatNum(fileSize / (1024), 2) + "KB";
    } else if ((fileSize >= 1024 * 1024) && (fileSize < 1024 * 1024 * 1024)) {
        return fixFloatNum(fileSize / (1024 * 1024), 2) + "MB";
    } else if ((fileSize >= 1024 * 1024 * 1024) && (fileSize < 1024 * 1024 * 1024 * 1024)) {
        return fixFloatNum(fileSize / (1024 * 1024 * 1024), 2) + "GB";
    } else {
        return fixFloatNum(fileSize) + "B";
    }
}

function fileUploadSuccess(file, serverData) {
    try {
        if (eval("(" + serverData + ")").success) {
            var filePath = eval("(" + serverData + ")").filePath;
            var fileHash = eval("(" + serverData + ")").fileHash;
            $("#fileName").val(file.name);
            var parentId = $("#parentId").val();
            $(document).queue(function(){
                $.post(baseUrl + "userFile/saveUserFile", {name: file.name, filePath: filePath, fileHash: fileHash, fileSize: file.size, parentId: parentId}, function (data) {
                    if (data.success) {
                        var userFile = data.userFile;
                        var userFileDiv = $("#userFileDiv");
                        var name = $("#name").val();
                        var fileDiv = "";
                        fileDiv += "<tr onmousedown=\"userFilebtn(event," + userFile.id + ",'" + userFile.name + "','" + userFile.fileHash + "','" + userFile.filePath + "','file')\" onmousemove=\"categoryFileId(" + userFile.id + ",'" + userFile.name + "','" + userFile.fileHash + "','file')\" onmouseout=\"fileOut(" + userFile.id + ")\" id=\"userFileDiv_" + userFile.id + "\" name=\"userFile\"><td width=\"40\"><input value=\"" + userFile.fileHash + "\" id=\"hash\" type=\"hidden\"/>" +
                            "<input value=\"" + userFile.name + "\" id=\"fname\" type=\"hidden\"/><input value=\"" + userFile.id + "\" id=\"fid\" type=\"hidden\"/>" +
                            "<div class=\"col-md-1 mysharinglist_cent\" style=\"width: 40px;\"><input name=\"checkFileList\" class=\"checklist\"  type=\"checkbox\" value=\"" + userFile.id + "\" id=\"checkBox_" + userFile.id + "\" /></div></td>";
                        fileDiv += "<td width=\"370\"><div style=\"overflow: hidden;line-height: 28px;\">";
                        if (checkFileType(userFile.fileType) == 1) {
                            fileDiv += "<span class=\"myshar_listico share_class_icon\" ></span>";
                        } else if (checkFileType(userFile.fileType) == 2) {
                            fileDiv += "<span class=\"myshar_listico share_class_icon2\" ></span>";
                        } else if (checkFileType(userFile.fileType) == 3) {
                            fileDiv += "<span class=\"myshar_listico share_class_icon1\" ></span>";
                        } else if (checkFileType(userFile.fileType) == 4) {
                            fileDiv += "<span class=\"myshar_listico share_class_icon3\" ></span>";
                        } else if(checkFileType(file.filePath)==5){
                            fileDiv += "<span class=\"myshar_listico share_class_icon\" ></span>";
                        } else {
                            fileDiv += "<span class=\"myshar_listico share_class_icon4\" ></span>";
                        }
                        fileDiv += "<span id=\"spanFile\"><a title=\"" + userFile.name + "\" onclick=\"playBtn('" + userFile.name + "','" + userFile.fileType + "','" + userFile.fileHash + "')\">" + userFile.name.substr(0, 30) + "</a>" +
                            "</span><span id=\"spanFile1\" style=\"display: none\">" +
                            "<input class='form-control f_controlsty' value=\"" + userFile.name + "\" id=\"updateName\"/><a class='glyphicon glyphicon-ok btn-sm bt1_ie7 wy_sty3' onclick=\"updateFile(" + userFile.id + ")\"></a>" +
                            "<button class='btn-link glyphicon glyphicon-remove btn-sm removeie7 wy_sty2' onclick=\"resetFile(" + userFile.id + ")\"></button>" +
                            "</span></div></td>";
                        fileDiv += "<td width=\"120\"><div><div class=\"shar_tools\">" +
                            "<a class=\"state_display\" title=\"下载\" name=\"download\"><span  class=\"glyphicon glyphicon-cloud-download btn-sm downloadie7\" style=\"padding: 0;margin: 0 5px;\"></span></a>" +
                            "<a class=\"state_display\" title=\"公开\" name=\"sharingFile\"><span class=\"glyphicon glyphicon-share btn-sm shareie7\" style=\"padding: 0;margin: 0 8px;\"></span></a>" +
                            "<a class=\"state_display\" title=\"删除\" name=\"deleteFile\"> <span  class=\"glyphicon glyphicon-remove btn-sm removeie7\" style=\"padding: 0;margin: 0 5px;\"></span></a>" +
                            "</div></div></td>";
                        fileDiv += "<td width=\"100\"><div class=\"col-md-1 mysharinglist_cent\" style=\"width: 100px; text-align: left\"  name=\"fileSize\">" + convertHumanUnit(userFile.fileSize) + "</div></td>";
                        fileDiv += "<td><div class=\"col-md-2 mysharinglist_cent\">" + userFile.createdDate.substr(0, userFile.createdDate.indexOf('T')) + "</div></td></tr>";

                        var fileTable = userFileDiv.find("table");
                        var fileTbody = fileTable.find("tbody");
                        if(fileTbody.size() == 0) {
                            fileTable.append(fileDiv);
                        } else {
                            fileTbody.append(fileDiv);
                        }
                    } else {
                        alert(data.msg);
                    }
                    $(document).dequeue();
                });
            });
        } else {
            alert(serverData.msg);
        }
    } catch (ex) {
        this.debug(ex);
    }
}
function fileUploadComplete(file) {

}

function fileDialogComplete(numFilesSelected, numFilesQueued) {
    try {
        bfFileUploadObject.startUpload();
    } catch (ex) {
        this.debug(ex);
    }
}

function uploadProgress(file, bytesLoaded, bytesTotal) {
    try {
        //var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);
        //console.log(percent);
        var fileProcess = parseInt(file.percentUploaded) + "%";
        //alert(fileProcess);
        if (isIE) {
            for (var i = 0; i <= 80000; i++) {
                if (i == 80000) {
                    $("#process_" + file.id).empty().append(SWFUpload.speed.formatPercent(file.percentUploaded));
                    $("#status_" + file.id).empty().append(SWFUpload.speed.formatBytes(file.currentSpeed / 8) + "/s" + "(" + SWFUpload.speed.formatBytes(file.averageSpeed / 8) + ")");
                }
            }
        } else {
            $("#process_" + file.id).empty().append(SWFUpload.speed.formatPercent(file.percentUploaded));
            $("#status_" + file.id).empty().append(SWFUpload.speed.formatBytes(file.currentSpeed / 8) + "/s" + "(" + SWFUpload.speed.formatBytes(file.averageSpeed / 8) + ")");
        }


        //$("#status_" + file.id).empty().append(SWFUpload.speed.formatBytes(file.currentSpeed / 8) + "(" + SWFUpload.speed.formatBytes(file.averageSpeed / 8) + ")");
    } catch (ex) {
        this.debug(ex);
    }
}
function fileQueued(file) {
    try {
        //$("#fileProgressMonitor").append("<div id='" + file.id + "'>" + file.name + "<div id='fileprogress_"+file.id+"'><div id='progress_label_"+file.id+"'>等待上传</div></div></div>");
        var isFlag = isIE();
        if (isFlag) {
            $("#uploadListDialog").parent().show();
        }
        $("#uploadListDialog").dialog("open");
        var fileName = file.name.toString();
        var fileSize = convertHumanUnit(file.size);

        var useSize = parseInt($("#useSpaceSize").val(), 10) + file.size;
        var maxSize = parseInt($("#maxSpaceSize").val(), 10);

        var fileSubName = fileName.length > 20 ? (fileName.substr(0, 20) + "...") : fileName;

        // 已经使用的空间+文件大小 > 最大容量时，取消上传该文件
        if(useSize > maxSize && $("#role").val() != "0" ) {
            bfFileUploadObject.cancelUpload(file.id);
            var html = "<tr>" +
                "<td title='" + file.name + "'>" + fileSubName + "</td><td>" + fileSize + "</td><td></td><td style='color:red;'>容量不足<br>无法上传</td></tr>";
            $("#uploadListDialog table").append(html);
        } else {

            var html = "<tr>" +
                "<td title='" + file.name + "'>" + fileSubName + "</td><td>" + fileSize + "</td><td id='status_" + file.id + "'>状态</td><td id='process_" + file.id + "'>状态</td>" +
                "</tr>";
            $("#uploadListDialog table").append(html);
            $("#useSpaceSize").val(useSize);
            if($("#role").val() != "0" ) {
                $("#showMaxSize").empty().append(convertHumanUnit($("#maxSpaceSize").val()));
                $("#showUseSize").empty().append(convertHumanUnit($("#useSpaceSize").val()));
            }
        }
    } catch (ex) {
        alert(ex);
    }

}
function fileQueueError(file, errorCode, message) {
    try {
        if (errorCode === SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {
            alert("您上传的文件个数超过了限制！");
            return;
        }


        switch (errorCode) {
            case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
                alert("文件大小超出限制!");
                this.debug("Error Code: File too big, File name: " + file.name + ", File size: " + file.size + ", nts.system.domain.Message: " + message);
                break;
            case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
                alert("不能上传空文件!");
                this.debug("Error Code: Zero byte file, File name: " + file.name + ", File size: " + file.size + ", nts.system.domain.Message: " + message);
                break;
            case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
                alert("Invalid File Type.");
                this.debug("Error Code: Invalid File Type, File name: " + file.name + ", File size: " + file.size + ", nts.system.domain.Message: " + message);
                break;
            default:
                if (file !== null) {
                    alert("Unhandled Error");
                }
                this.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", nts.system.domain.Message: " + message);
                break;
        }
    } catch (ex) {
        this.debug(ex);
    }
}

function initFileUpload(uploadServerUrl, uploadUrl, fileSizeLimit, params, limit) {
    var settings = {
        flash_url: uploadServerUrl + "/js/swfupload/swfupload.swf",
        flash9_url: uploadServerUrl + "/js/swfupload/swfupload_fp9.swf",
//        flash_url: baseUrl + "/js/swfupload/swfupload.swf",
//         flash9_url: baseUrl + "/js/swfupload/swfupload_fp9.swf",
        upload_url: uploadUrl,
        file_size_limit: fileSizeLimit,
        file_types: "*.*",
        file_post_name: "fileEntity",
        post_params: params,
        file_types_description: "All Files",
        file_upload_limit: limit,
        file_queue_limit: limit,
        /*custom_settings: {
         progressTarget: "fsUploadProgress",
         cancelButtonId: "btnCancel"
         },*/
        debug: false,

        // Button settings
        button_image_url: baseUrl + "skin/blue/pc/common/images/file_button_bg.png",
        button_width: "85",
        button_height: "29",
        button_placeholder_id: "selectFileBtn",
        button_text: '<span class="theFont"></span>',
        button_text_style: ".theFont{background-color:#0F9;height:30px; display:block;text-align:right;line-height:30px;}",
//        button_text_style: ".theFont{font-size:12px;font-family:'微软雅黑';background-color:#0F9; color:#333333; text-align:right;}",
//        button_text_style: ".theFont{font-size:12px;font-family:'微软雅黑'; color:#333333;padding-top:8px;display:block;text-align:center;}",
        button_window_mode: SWFUpload.WINDOW_MODE.OPAQUE,
        //button_text_left_padding: 12,
//        button_right_padding: 12,
        button_text_right_padding: 3,
        file_queued_handler: fileQueued,
        upload_complete_handler: fileUploadComplete,
        upload_success_handler: fileUploadSuccess,
        upload_progress_handler: uploadProgress,
        file_dialog_complete_handler: fileDialogComplete,
        file_queue_error_handler: fileQueueError
    };

    bfFileUploadObject = new SWFUpload(settings);

}

$(function () {
    var uploadPath = $.cookie("uploadPath3");
    $("#uploadPath").val(uploadPath);
    var videoSevr = $.cookie("uploadServerAddress");
    var videoPort = $.cookie("uploadServerPort");
    var fileSizeLimit = $.cookie("fileSizeLimit") * 1024;
    var params = {};
    var uploadServerUrl = "http://" + videoSevr + ":" + videoPort + "/bmc2";
    var uploadUrl = "http://" + videoSevr + ":" + videoPort + "/bmc2/api/upload";
    initFileUpload(uploadServerUrl, uploadUrl, fileSizeLimit, params, null);
});