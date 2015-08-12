var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
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
        this.debug("connect success");
        if (eval("(" + serverData + ")").success) {
            var filePath = eval("(" + serverData + ")").filePath;
            var fileHash = eval("(" + serverData + ")").fileHash;
            $("#filePath").val(filePath);
            $("#fileHash").val(fileHash);
            $("#fileSize").val(file.size);
            $("#fileType").val(file.type);
            $("#fileName").val(file.name);
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
        //$("#process_" + file.id).empty().append(SWFUpload.speed.formatPercent(file.percentUploaded));
        $("#uploadSpeed").empty().append("完成：" + fileProcess);
        //$("#status_" + file.id).empty().append(SWFUpload.speed.formatBytes(file.currentSpeed / 8) + "/s" + "(" + SWFUpload.speed.formatBytes(file.averageSpeed / 8) + ")");
        //$("#status_" + file.id).empty().append(SWFUpload.speed.formatBytes(file.currentSpeed / 8) + "(" + SWFUpload.speed.formatBytes(file.averageSpeed / 8) + ")");
    } catch (ex) {
        this.debug(ex);
    }
}
function fileQueued(file) {
    try {
        //$("#fileProgressMonitor").append("<div id='" + file.id + "'>" + file.name + "<div id='fileprogress_"+file.id+"'><div id='progress_label_"+file.id+"'>等待上传</div></div></div>");
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
                alert("File is too big.");
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

function initFileUpload(uploadServerUrl, uploadUrl, params, limit) {
    var settings = {
        flash_url: uploadServerUrl + "/js/swfupload/swfupload.swf",
        flash9_url: uploadServerUrl + "/js/swfupload/swfupload_fp9.swf",
//        flash_url: baseUrl + "/js/swfupload/swfupload.swf",
//         flash9_url: baseUrl + "/js/swfupload/swfupload_fp9.swf",
        upload_url: uploadUrl,
        file_size_limit: "2048 MB",
        file_types: returnImagesType(),
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
        button_image_url: baseUrl + "skin/blue/pc/front/images/boful_resources_search_all_submit_bg.png",
        button_width: "85",
        button_height: "29",
        button_placeholder_id: "selectFileBtn",
        button_text: '<span class="theFont">上传海报</span>',
        //       button_text_style: ".theFont{background-color:#0F9;height:30px; display:block;text-align:right;line-height:30px;}",
        //       button_text_style: ".theFont{font-size:12px;font-family:'微软雅黑';background-color:#0F9; color:#333333; text-align:right;}",
        button_text_style: ".theFont{font-size:12px; font-family: '微软雅黑',serif; line-height: 30px; color:#ffffff; padding-top:10px; display:block;overflow:hidden; text-align:center;}",
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
    var params = {};
    var uploadServerUrl = "http://" + videoSevr + ":" + videoPort + "/bmc";
    var uploadUrl = "http://" + videoSevr + ":" + videoPort + "/bmc/upload/uploadFile";
    initFileUpload(uploadServerUrl, uploadUrl, params, null);
});