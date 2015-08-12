/**
 * Created with IntelliJ IDEA.
 * User: ligson
 * Date: 13-11-21
 * Time: 下午6:22
 * To change this template use File | Settings | File Templates.
 */
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}

var bfShareUploadObject;
function shareUploadSuccess(file, serverData) {
    try {
        this.debug("connect success");
        if (eval("(" + serverData + ")").success) {
            var filePath = eval("(" + serverData + ")").filePath;
            var fileHash = eval("(" + serverData + ")").fileHash;
            $("#saveHeadSharingForm").find("input[name='url']").val(filePath);
            $("#headAddFilePath").val(filePath);
            $("#fileHash").val(fileHash);
            $("#fileType").val(file.type);
            $("#fileName").val(file.name);
        } else {
            alert(serverData.msg);
        }
    } catch (ex) {
        this.debug(ex);
    }
}
function shareUploadComplete(file) {

}

function shareFileDialogComplete(numFilesSelected, numFilesQueued) {
    try {
        /*if (numFilesSelected > 0) {
         document.getElementById(this.customSettings.cancelButtonId).disabled = false;
         }*/
        var shareForm = $("#saveHeadSharingForm");
        var userId = shareForm.find("input[name=userId]").val();
        var communityId = shareForm.find("input[name=communityId]").val();
        var uploadPath = shareForm.find("input[name=uploadPath]").val();
        var params = {userId: userId, communityId: communityId, uploadPath: uploadPath};
        bfShareUploadObject.setPostParams(params);
        /* I want auto start the upload and I can do that here */
        bfShareUploadObject.startUpload();
    } catch (ex) {
        this.debug(ex);
    }
}

function uploadProgress(file, bytesLoaded, bytesTotal) {
    try {
        //var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);
        //console.log(percent);
        var fileProcess = parseInt(file.percentUploaded) + "%";
        $("#uploadSpeed").css("width", fileProcess).css("display", "block");
        $("#uploadSuccess").empty().append("已完成" + fileProcess);
        //$("#status_" + file.id).empty().append(SWFUpload.speed.formatBytes(file.currentSpeed / 8) + "(" + SWFUpload.speed.formatBytes(file.averageSpeed / 8) + ")");
    } catch (ex) {
        this.debug(ex);
    }
}

function shareFileQueueError(file, errorCode, message) {
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

function initshareUpload(uploadServerUrl, uploadUrl, params) {
    var settings = {
        flash_url: uploadServerUrl + "/js/swfupload/swfupload.swf",
        flash9_url: uploadServerUrl + "/js/swfupload/swfupload_fp9.swf",
        upload_url: uploadUrl,
        file_size_limit: "2048 MB",
        file_types: FILE_TYPES,
        file_post_name: "fileEntity",
        post_params: params,
        file_types_description: "All Files",
        file_upload_limit: 1,
        file_queue_limit: 1,
        /*custom_settings: {
         progressTarget: "fsUploadProgress",
         cancelButtonId: "btnCancel"
         },*/
        debug: false,

        // Button settings
        button_image_url: baseUrl+"skin/blue/pc/common/images/button_bg.png",
        button_width: "65",
        button_height: "28",
        button_placeholder_id: "uploadShareBtn",
        button_text: '<span class="theFont">选择文件</span>',
        button_text_style: ".theFont{font-size:12px;color:#000;text-align:center;font-weight:bold;}",
        //button_text_left_padding: 12,
        button_text_top_padding: 3,
        upload_complete_handler: shareUploadComplete,
        upload_success_handler: shareUploadSuccess,
        upload_progress_handler: uploadProgress,
        file_dialog_complete_handler: shareFileDialogComplete,
        file_queue_error_handler: shareFileQueueError
    };

    bfShareUploadObject = new SWFUpload(settings);

}

$(function () {
    var uploadPath = $.cookie("uploadPath3");
    $("#uploadPath").val(uploadPath);
    var videoSevr = $.cookie("videoSevr");
    var videoPort = $.cookie("videoPort");
    var params = {userId: 1, uploadPath: uploadPath};
    var uploadServerUrl = "http://" + videoSevr + ":" + videoPort + "/bmc";
    var uploadUrl = "http://" + videoSevr + ":" + videoPort + "/bmc/upload/uploadFile";
    initshareUpload(uploadServerUrl, uploadUrl, params);
});
