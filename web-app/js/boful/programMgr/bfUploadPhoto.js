/**
 * Created with IntelliJ IDEA.
 * User: ligson
 * Date: 13-11-21
 * Time: 下午6:22
 * To change this template use File | Settings | File Templates.
 */
var bfPhotoUploadObject;
function photoUploadSuccess(file, serverData) {
    try {
        this.debug("connect success");
        if (eval("(" + serverData + ")").success) {
            var filePath = eval("(" + serverData + ")").filePath;
            $("#photo").val(filePath);
        } else {
            //alert(serverData.msg);
        }
    } catch (ex) {
        this.debug(ex);
    }
}
function photoUploadComplete(file) {

}

function photoFileDialogComplete(numFilesSelected, numFilesQueued) {
    try {
        /*if (numFilesSelected > 0) {
         document.getElementById(this.customSettings.cancelButtonId).disabled = false;
         }*/
        /* var serialId = $("#editSerialForm").find("input[name=id]").val();
         var params = {serialId: serialId};
         bfPhotoUploadObject.setPostParams(params);*/
        /* I want auto start the upload and I can do that here */
        bfPhotoUploadObject.startUpload();
    } catch (ex) {
        this.debug(ex);
    }
}

function photoFileQueueError(file, errorCode, message) {
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

function initPhotoUpload(uploadServerRootUrl, uploadUrl, params) {
    var settings = {
        flash_url: uploadServerRootUrl + "/js/swfupload/swfupload.swf",
        flash9_url: uploadServerRootUrl + "/js/swfupload/swfupload_fp9.swf",
        upload_url: uploadUrl,
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
        button_placeholder_id: "bfSelectPhotoBtn",
        button_text: '<span class="theFont">选择文件</span>',
        button_text_style: ".theFont{font-size:12px;color:#000;text-align:center;font-weight:bold;}",
        //button_text_left_padding: 12,
        button_text_top_padding: 3,
        upload_complete_handler: photoUploadComplete,
        upload_success_handler: photoUploadSuccess,
        file_dialog_complete_handler: photoFileDialogComplete,
        file_queue_error_handler: photoFileQueueError
    };

    bfPhotoUploadObject = new SWFUpload(settings);
    return true;
}
