/**
 * Created with IntelliJ IDEA.
 * User: ligson
 * Date: 13-11-21
 * Time: 下午6:22
 * To change this template use File | Settings | File Templates.
 */
var bfSubtitleUploadObject;
function subtitleUploadSuccess(file, serverData) {
    try {
        this.debug("connect success");
        if (eval("(" + serverData + ")").success) {
            var filePath = eval("(" + serverData + ")").filePath;
            $("#editSubtitleForm").find("input[name='filePath']").val(filePath);
        } else {
            alert(serverData.msg);
        }
    } catch (ex) {
        this.debug(ex);
    }
}
function subtitleUploadComplete(file) {

}

function subtitleFileDialogComplete(numFilesSelected, numFilesQueued) {
    try {
        /*if (numFilesSelected > 0) {
         document.getElementById(this.customSettings.cancelButtonId).disabled = false;
         }*/
        var subtitleForm = $("#editSubtitleForm");
        var subtitleId = subtitleForm.find("input[name=id]").val();
        var serialId = subtitleForm.find("input[name=serialId]").val();
        var params = {serialId: serialId, subtitleId: subtitleId};
        bfSubtitleUploadObject.setPostParams(params);
        /* I want auto start the upload and I can do that here */
        bfSubtitleUploadObject.startUpload();
    } catch (ex) {
        this.debug(ex);
    }
}

function subtitleFileQueueError(file, errorCode, message) {
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

function initSubtitleUpload(params) {
    var settings = {
        flash_url: baseUrl + "js/swfupload/swfupload.swf",
        flash9_url: baseUrl + "js/swfupload/swfupload_fp9.swf",
        upload_url: baseUrl + "program/uploadSerialSubtitle",
        file_size_limit: "2048 MB",
        file_types: "*.*",
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
        button_image_url: baseUrl + "images/button_bg.png",
        button_width: "65",
        button_height: "28",
        button_placeholder_id: "bfSubtitleUploadBtn",
        button_text: '<span class="theFont">选择文件</span>',
        button_text_style: ".theFont{font-size:12px;color:#000;text-align:center;font-weight:bold;}",
        //button_text_left_padding: 12,
        button_text_top_padding: 3,
        upload_complete_handler: subtitleUploadComplete,
        upload_success_handler: subtitleUploadSuccess,
        file_dialog_complete_handler: subtitleFileDialogComplete,
        file_queue_error_handler: subtitleFileQueueError
    };

    bfSubtitleUploadObject = new SWFUpload(settings);
    return true;
}
