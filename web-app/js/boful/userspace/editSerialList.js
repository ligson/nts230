/**
 * Created with IntelliJ IDEA.
 * User: ligson
 * Date: 13-11-21
 * Time: 下午6:22
 * To change this template use File | Settings | File Templates.
 */
var bfUploadMyProgram;
var localObj = window.location;
var contextPath = localObj.pathname.split("/")[1];
var baseUrl = '';
if('nts' != contextPath) {
    baseUrl = localObj.protocol + "//" + localObj.host + "/";
} else {
    baseUrl = localObj.protocol + "//" + localObj.host + "/" + contextPath + "/";
}
function workUploadSuccess(file, serverData) {
    try {
        this.debug("connect success");
        if (eval("(" + serverData + ")").success) {
            var filePath = eval("(" + serverData + ")").filePath;
            var fileHash = eval("(" + serverData + ")").fileHash;
            $("#filePath_" + file.id).val(filePath);
            $("#fileHash_" + file.id).val(fileHash);

        } else {
            alert(serverData.msg);
        }
    } catch (ex) {
        this.debug(ex);
    }
}
function workUploadComplete(file) {

}

function workFileDialogComplete(numFilesSelected, numFilesQueued) {
    try {
        this.debug("选择文件个数：" + numFilesSelected);
        $("#fileCountShow").empty().append(numFilesQueued);
        bfUploadMyProgram.startUpload()
    } catch (ex) {
        this.debug(ex);
    }
}

function workFileQueueError(file, errorCode, message) {
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
function uploadProgress(file, bytesLoaded, bytesTotal) {
    try {
        var fileProcess = parseInt(file.percentUploaded) + "%";
        var fileUploaded = convertHumanUnit(bytesLoaded);
        var fileSpeed = SWFUpload.speed.formatBytes(file.currentSpeed / 8) + "(" + SWFUpload.speed.formatBytes(file.averageSpeed / 8) + ")";
        $("#file_upload_size_" + file.id).empty().append(fileUploaded);
        $("#file_upload_speed_" + file.id).empty().append(fileSpeed);
        $("#file_upload_process_" + file.id).css("width", fileProcess);
    } catch (ex) {
        this.debug(ex + "--" + bytesTotal);
    }
}
var fileCount = 0;
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
    fileCount++;
    var fileName = file.name;
    var fileId = file.id;
    var fileSize = file.size;
    var html = "<div class=\"upload_item\" id='file_item_" + fileId + "' style='display:none;'>" +
        "<input type='hidden' name='fileHash_" + fileCount + "' id='fileHash_" + file.id + "'>" +
        "<input type='hidden' name='filePath_" + fileCount + "' id='filePath_" + file.id + "'>" +
        "<table class=\"table\" style=\" \">" +
        "       <tr>" +
        "           <th width=\"45\" style=\"line-height: 30px; color: #bbbbbb;\" colspan=\"1\">" +
        "           进度" +
        "           </th>" +
        "           <td colspan=\"2\">" +

        "                    <div class=\"progress\" style=\"margin: 4px 0 0 0; \">" +
        "                   <div class=\"progress-bar progress-bar-info\" id='file_upload_process_" + fileId + "'></div>" +
        "               </div>" +

        "               <div class=\"boful_ui_processbar_text\">" +
        "               </div>" +
        "           </td>" +
        "           <td colspan=\"1\">" +
        "           </td>" +
        "<tr>" +
        "<th style=\"line-height: 30px;color: #bbbbbb;\" >&nbsp;</th>" +
        " <td style=\" line-height: 30px;\">" +
        "                   已上传：<span id='file_upload_size_" + fileId + "'>0</span>&nbsp;" +
        "                   总大小:<span>" + convertHumanUnit(fileSize) + "</span>&nbsp;" +
        "                   平均上传速度：<span id='file_upload_speed_" + fileId + "'>未知</span>" +
        "</td>" +
        "</tr>" +
        " <tr>" +
        "           <th width=\"45\" style=\"line-height: 30px;color: #bbbbbb;\" >名称</th>" +
        "           <td><input type=\"text\" class =\"form-control\" value='" + fileName + "' name='fileName_" + fileCount + "' id='fileName_" + fileId + "'></td>" +
        "           </tr>" +
        "           <tr>" +
        "               <th width=\"45\" style=\"line-height: 80px;color: #bbbbbb;\" >描述</th>" +
        "               <td><textarea class=\"form-control\"  rows=\"3\"name='fileDesc_" + fileCount + "'></textarea>" +
        "               </td>" +
        "           </tr>" +
        "       </table>" +
        "   </div>";
    $(".upload_list").append(html);
    $("#file_item_" + fileId).show();
}
function initMyUpload(uploadServerUrl, uploadUrl, params) {
    var settings = {
        flash_url: uploadServerUrl + "/js/swfupload/swfupload.swf",
        flash9_url: uploadServerUrl + "/js/swfupload/swfupload_fp9.swf",
        upload_url: uploadUrl,
        file_size_limit: "2048 MB",
        file_types: FILE_TYPES,
        file_post_name: "fileEntity",
        post_params: params,
        file_types_description: "All Files",
        file_upload_limit: 50,
        file_queue_limit: 50,
        /*custom_settings: {
         progressTarget: "fsUploadProgress",
         cancelButtonId: "btnCancel"
         },*/
        debug: false,

        // Button settings
        button_image_url: baseUrl + "images/button_bg.png",
        button_width: "65",
        button_height: "28",
        button_placeholder_id: "bfUploadFileBtn",
        button_text: '<span class="theFont">继续添加</span>',
        button_text_style: ".theFont{font-size:12px;color:#ffffff;text-align:center;font-weight:bold;}",
        //button_text_left_padding: 12,
        button_text_top_padding: 3,
        upload_complete_handler: workUploadComplete,
        upload_success_handler: workUploadSuccess,
        upload_progress_handler: uploadProgress,
        file_queued_handler: fileQueued,
        file_dialog_complete_handler: workFileDialogComplete,
        file_queue_error_handler: workFileQueueError
    };

    bfUploadMyProgram = new SWFUpload(settings);

}

function removeSerial(url, id, trId) {
    //return false;
    if (confirm("您确认要删除吗？")) {
        var programId = $("#programId").val();
        $.post(url, {id: id, programId: programId}, function (data) {
            if (data.success) {
                $("#" + trId).remove();
            } else {
                alert("删除失败！" + data.msg);
            }
        });

    }

}
function dealFormSubmit() {
    $("#editSerialListForm").submit(function () {
        var fileCount = $(".upload_list").find(".upload_item").length;
        $("#fileCount").val(fileCount);
        return true;
    });
}
$(function () {
    var videoSevr = $.cookie("videoSevr");
    var videoPort = $.cookie("videoPort");
    var uploadServerRootUrl = "http://" + videoSevr + ":" + videoPort + "/bmc";
    var uploadUrl = "http://" + videoSevr + ":" + videoPort + "/bmc/upload/uploadFile";
    var uploadPath = $.cookie("uploadPath1");
    var pars = {uploadPath: uploadPath};
    initMyUpload(uploadServerRootUrl, uploadUrl, pars);

    dealFormSubmit();
});
