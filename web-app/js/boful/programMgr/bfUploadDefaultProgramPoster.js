var bfUploadDefaultPoster;
var bfUploadCreateDefaultPoster;

function myUploadPosterSuccess(file, serverData) {
    try {
        this.debug("connect success");
        if (eval("(" + serverData + ")").success) {
            var filePath = eval("(" + serverData + ")").filePath;
            var fileHash = eval("(" + serverData + ")").fileHash;
            var fileName = eval("(" + serverData + ")").fileName;
            $("#defaultProgramPosterHash").val(fileHash);
            $("#defaultProgramPosterPath").val(filePath);
            $("#showDefaultPosterName").empty().append(fileName);
            alert("上传完成!")
        } else {
            alert(serverData.msg);
        }
    } catch (ex) {
        this.debug(ex);
    }
}

function myUploadPosterCreateSuccess(file, serverData) {
    try {
        this.debug("connect success");
        if (eval("(" + serverData + ")").success) {
            var filePath = eval("(" + serverData + ")").filePath;
            var fileHash = eval("(" + serverData + ")").fileHash;
            var fileName = eval("(" + serverData + ")").fileName;
            $("#defaultProgramPosterHashCreate").val(fileHash);
            $("#defaultProgramPosterPathCreate").val(filePath);
            $("#showDefaultPosterNameCreate").empty().append(fileName);
            alert("上传完成!")
        } else {
            alert(serverData.msg);
        }
    } catch (ex) {
        this.debug(ex);
    }
}

function myUploadPosterCompletr(file) {

}

function myFileDialogPosterComplete(numFilesSelected, numFilesQueued) {
    try {
        bfUploadDefaultPoster.startUpload()
    } catch (ex) {
        this.debug(ex);
    }
}

function myFileDialogPosterCreateComplete(numFilesSelected, numFilesQueued) {
    try {
        bfUploadCreateDefaultPoster.startUpload()
    } catch (ex) {
        this.debug(ex);
    }
}

function myFileQueuePosterError(file, errorCode, message) {
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
                alert("不合法的文件类型!");
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
function uploadPosterSuccess(file, bytesLoaded, bytesTotal) {

}

var fileMap = [];
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

function initDefaultPosterUpload(uploadServerUrl, uploadUrl, params) {
    var settings = {
        flash_url: uploadServerUrl + "/js/swfupload/swfupload.swf",
        flash9_url: uploadServerUrl + "/js/swfupload/swfupload_fp9.swf",
        upload_url: uploadUrl,
        file_size_limit: "2048 MB",
        file_types: "*.jpg;*.gif;*.png",
        file_post_name: "fileEntity",
        post_params: params,
        file_types_description: "Image Files",
        file_upload_limit: 50,
        file_queue_limit: 50,
        debug: false,

        // Button settings
        button_image_url: baseUrl + "skin/blue/pc/common/images/button_bg.png",
        button_width: "65",
        button_height: "28",
        button_placeholder_id: "programPoster",
        button_text: '<span class="theFont">上传海报</span>',
        button_text_style: ".theFont{font-size:12px;color:#ffffff;text-align:center;font-weight:bold;}",
        button_text_top_padding: 3,
        upload_complete_handler: myUploadPosterCompletr,
        upload_success_handler: myUploadPosterSuccess,
        upload_progress_handler: uploadPosterSuccess,
        file_dialog_complete_handler: myFileDialogPosterComplete,
        file_queue_error_handler: myFileQueuePosterError
    };

    bfUploadDefaultPoster = new SWFUpload(settings);

}

function initCreateDefaultPosterUpload(uploadServerUrl, uploadUrl, params) {
    var settings = {
        flash_url: uploadServerUrl + "/js/swfupload/swfupload.swf",
        flash9_url: uploadServerUrl + "/js/swfupload/swfupload_fp9.swf",
        upload_url: uploadUrl,
        file_size_limit: "2048 MB",
        file_types: "*.jpg;*.gif;*.png",
        file_post_name: "fileEntity",
        post_params: params,
        file_types_description: "Image Files",
        file_upload_limit: 50,
        file_queue_limit: 50,
        debug: false,

        // Button settings
        button_image_url: baseUrl + "skin/blue/pc/common/images/button_bg.png",
        button_width: "65",
        button_height: "28",
        button_placeholder_id: "programPosterCreate",
        button_text: '<span class="theFont">上传海报</span>',
        button_text_style: ".theFont{font-size:12px;color:#ffffff;text-align:center;font-weight:bold;}",
        button_text_top_padding: 3,
        upload_complete_handler: myUploadPosterCompletr,
        upload_success_handler: myUploadPosterCreateSuccess,
        upload_progress_handler: uploadPosterSuccess,
        file_dialog_complete_handler: myFileDialogPosterCreateComplete,
        file_queue_error_handler: myFileQueuePosterError
    };
    bfUploadCreateDefaultPoster = new SWFUpload(settings);

}

$(function () {
    var videoSevr = $.cookie("uploadServerAddress");
    var videoPort = $.cookie("uploadServerPort");
    var uploadServerRootUrl = "http://" + videoSevr + ":" + videoPort + "/bmc";
    var uploadUrl = "http://" + videoSevr + ":" + videoPort + "/bmc/upload/uploadFile";
    var pars = {};
    initDefaultPosterUpload(uploadServerRootUrl, uploadUrl, pars);
    initCreateDefaultPosterUpload(uploadServerRootUrl, uploadUrl, pars);
});