/**
 * Created with IntelliJ IDEA.
 * User: ligson
 * Date: 13-8-5
 * Time: 上午9:35
 * To change this template use File | Settings | File Templates.
 */
var bfUploadObject;
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
function fileQueued(file) {
    try {
        //$("#fileProgressMonitor").append("<div id='" + file.id + "'>" + file.name + "<div id='fileprogress_"+file.id+"'><div id='progress_label_"+file.id+"'>等待上传</div></div></div>");

        var fileName = file.name.toString();
        var fileSize = convertHumanUnit(file.size);

        var fileSubName = fileName.length > 20 ? (fileName.substr(0, 20) + "...") : fileName;
        var html = "<tr>" +
            "<td title='" + file.name + "'>" + fileSubName + "</td><td>" + fileSize + "</td><td id='status_" + file.id + "'>状态</td><td id='process_" + file.id + "'>状态</td><td>操作</td>" +
            "</tr>";

        $("#fileProgressMonitor").append(html);
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

function fileDialogComplete(numFilesSelected, numFilesQueued) {
    try {
        /*if (numFilesSelected > 0) {
         document.getElementById(this.customSettings.cancelButtonId).disabled = false;
         }*/

        /* I want auto start the upload and I can do that here */
        //this.startUpload();
    } catch (ex) {
        this.debug(ex);
    }
}

function uploadStart(file) {
    try {
        /*var progressbar = $("#fileprogress_"+file.id);
         progressbar.progressbar( "value",0);*/
        $("#startUploadBtn").attr("disabled", "disabled");
    }
    catch (ex) {
    }

    return true;
}

function uploadProgress(file, bytesLoaded, bytesTotal) {
    try {
        //var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);
        //console.log(percent);
        $("#process_" + file.id).empty().append(SWFUpload.speed.formatPercent(file.percentUploaded));
        $("#status_" + file.id).empty().append(SWFUpload.speed.formatBytes(file.currentSpeed / 8) + "(" + SWFUpload.speed.formatBytes(file.averageSpeed / 8) + ")");
    } catch (ex) {
        this.debug(ex);
    }
}

function uploadSuccess(file, serverData) {
    try {
        this.debug("connect success");
        var data = eval("(" + serverData + ")");
        if (data.success) {
            fileMap.push({fileId: file.id, filePath: data.filePath, fileHash: data.fileHash});
        } else {
            alert(file.name + "上传失败：" + data.msg);
        }
    } catch (ex) {
        this.debug(ex);
    }
}

function uploadError(file, errorCode, message) {
    try {

        switch (errorCode) {
            case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
                alert("Upload Error: " + message);
                this.debug("Error Code: HTTP Error, File name: " + file.name + ", nts.system.domain.Message: " + message);
                break;
            case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
                alert("Upload Failed.");
                this.debug("Error Code: Upload Failed, File name: " + file.name + ", File size: " + file.size + ", nts.system.domain.Message: " + message);
                break;
            case SWFUpload.UPLOAD_ERROR.IO_ERROR:
                alert("Server (IO) Error");
                this.debug("Error Code: IO Error, File name: " + file.name + ", nts.system.domain.Message: " + message);
                break;
            case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
                alert("不能连接到上传服务器！");
                this.debug("Error Code: Security Error, File name: " + file.name + ", nts.system.domain.Message: " + message);
                break;
            case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
                alert("Upload limit exceeded.");
                this.debug("Error Code: Upload Limit Exceeded, File name: " + file.name + ", File size: " + file.size + ", nts.system.domain.Message: " + message);
                break;
            case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
                alert("Failed Validation.  Upload skipped.");
                this.debug("Error Code: File Validation Failed, File name: " + file.name + ", File size: " + file.size + ", nts.system.domain.Message: " + message);
                break;
            case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
                // If there aren't any files left (they were all cancelled) disable the cancel button
                if (this.getStats().files_queued === 0) {
                    document.getElementById(this.customSettings.cancelButtonId).disabled = true;
                }
                alert("Cancelled");
                progress.setCancelled();
                break;
            case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
                alert("Stopped");
                break;
            default:
                alert("Unhandled Error: " + errorCode);
                this.debug("Error Code: " + errorCode + ", File name: " + file.name + ", File size: " + file.size + ", nts.system.domain.Message: " + message);
                break;
        }
    } catch (ex) {
        this.debug(ex);
    }
}

function uploadComplete(file) {
    console.log(file);
    var names = file.name.split(".");
    var urlType = $("select[name='urlType'] option:selected").val();
    var filePath = null;
    var fileHash = null;
    for (var i = 0; i < fileMap.length; i++) {
        var obj = fileMap[i];
        if (obj.fileId == file.id) {
            filePath = obj.filePath;
            fileHash = obj.fileHash;
            break;
        }
    }
    if (filePath) {
        $.post(baseUrl + "program/saveSerial", {programId: global.programId, name: file.name, serialNo: (file.index + 1), svrAddress: global.videoSevr, filePath: filePath, fileHash: fileHash}, function (data) {
            if (!data.success) {
                alert(data.msg);
            }
        });
    }

}

// This event comes from the Queue Plugin
function queueComplete(numFilesUploaded) {
    $("#uploadDialog").dialog("close");
}

function initBfUpload(uploadServerRootUrl, uploadUrl, params, limit, finishHandler) {
    if (!limit) {
        limit = 100;
    }
    var settings = {
        flash_url: uploadServerRootUrl + "/js/swfupload/swfupload.swf",
        flash9_url: uploadServerRootUrl + "/js/swfupload/swfupload_fp9.swf",
        upload_url: uploadUrl,
        file_size_limit: "2048 MB",
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
        button_image_url: baseUrl + "images/button_bg.png",
        button_width: "65",
        button_height: "28",
        button_placeholder_id: "bfSelectFileBtn",
        button_text: '<span class="theFont">选择文件</span>',
        button_text_style: ".theFont{font-size:12px;color:#000;text-align:center;font-weight:bold;}",
        //button_text_left_padding: 12,
        button_text_top_padding: 3,

        // The event handler functions are defined in handlers.js
        file_queued_handler: fileQueued,
        file_queue_error_handler: fileQueueError,
        file_dialog_complete_handler: fileDialogComplete,
        upload_start_handler: uploadStart,
        upload_progress_handler: uploadProgress,
        upload_error_handler: uploadError,
        upload_success_handler: uploadSuccess,
        upload_complete_handler: finishHandler ? finishHandler : uploadComplete,
        queue_complete_handler: queueComplete	// Queue plugin event
    };

    bfUploadObject = new SWFUpload(settings);

}

function startUpload() {
    bfUploadObject.startUpload();
}

/*
 this.customSettings.tdCurrentSpeed.innerHTML = SWFUpload.speed.formatBPS(file.currentSpeed);
 this.customSettings.tdAverageSpeed.innerHTML = SWFUpload.speed.formatBPS(file.averageSpeed);
 this.customSettings.tdMovingAverageSpeed.innerHTML = SWFUpload.speed.formatBPS(file.movingAverageSpeed);
 this.customSettings.tdTimeRemaining.innerHTML = SWFUpload.speed.formatTime(file.timeRemaining);
 this.customSettings.tdTimeElapsed.innerHTML = SWFUpload.speed.formatTime(file.timeElapsed);
 this.customSettings.tdPercentUploaded.innerHTML = SWFUpload.speed.formatPercent(file.percentUploaded);
 this.customSettings.tdSizeUploaded.innerHTML = SWFUpload.speed.formatBytes(file.sizeUploaded);
 this.customSettings.tdProgressEventCount.innerHTML = this.customSettings.progressCount;
 */