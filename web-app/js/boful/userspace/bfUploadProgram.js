var bfUploadObject;
var fileMap = [];
var n = 0;
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

        n++;
        var fileName = file.name;
        var fileHashInput = "<input type='hidden' id='fileHash_" + file.id + "' name='fileHash_" + file.index + "' value=''>";
        var fileNameInput = "<input type='text' class='upload_suc_title_text' name='fileName_" + file.index + "' value='" + file.name + "'>";
        var fileDescTextArea = "<textarea  class='upload_suc_title_describe' value='' name='fileDesc_" + file.index + "'></textarea>";
        var fileSavePathInput = "<input type='hidden' id='fileSavePath_" + file.id + "' name='fileSavePath_" + file.index + "' value=''>";

        var uploadListsDiv = $(".resources_upload_lists");

        var appendDiv =
            "<div class='resources_upload_list'>" +
                fileHashInput + fileSavePathInput +
                "   <h1>" +
                "       <span title=" + file.name + ">" + fileName + "</span>" +
                "       <span class='upload_suc_icon'></span>" +
                "   </h1>" +

                "   <div class=\"boful_ui_processbar\">" +
                "       <div class=\"boful_ui_processbar_label\" id='file_upload_process_" + file.id + "'></div>" +
                "   </div>" +
                "   <div class=\"boful_ui_processbar_text\">" +
                "       已上传：<span id='file_upload_size_" + file.id + "'>0</span>&nbsp;" +
                "       总大小:<span>" + convertHumanUnit(file.size) + "</span>&nbsp;" +
                "       平均上传速度：<span id='file_upload_speed_" + file.id + "'>未知</span>" +
                "   </div>" +
                "</div>" +
                "<div class='resources_upload_list1'>" +
                "   <div class='resources_upload_list1_title'>" +
                "       <h1>" +
                "           <span title=" + file.name + ">" + fileName + "</span>" +
                "           <span class='upload_suc_icon'></span>" +
                "           <span class='upload_suc_icon1'></span>" +
                "       </h1>" +
                '       <p>' +
                '           <span class="upload_suc_icon2"></span>' +
                '       </p>' +
                "   </div>" +
                "   <div class='upload_suc_title'>" +
                "       <h2>标题</h2>" +
                "       <label>" + fileNameInput + "</label>" +
                "   </div>" +
                '   <div class="upload_suc_describe">' +
                '       <h2>简介</h2>' +
                '       <label>' + fileDescTextArea + "</label>" +
                "   </div>" +
                "</div>";
        uploadListsDiv.append(appendDiv);


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
        //判断文件类型



        bfUploadObject.startUpload();
        $("#formPro").find("input[name=fileCount]").val(numFilesQueued);
    } catch (ex) {
        this.debug(ex);
        alert("Error:" + ex);
    }
}

function uploadStart(file) {
    try {
        /*var progressbar = $("#fileprogress_"+file.id);
         progressbar.progressbar( "value",0);*/
        //$("#startUploadBtn").attr("disabled", "disabled");
    }
    catch (ex) {
    }

    return true;
}

function uploadProgress(file, bytesLoaded, bytesTotal) {
    try {
        //$("#spd_" + file.id).empty().append(SWFUpload.speed.formatPercent(file.percentUploaded));
        var fileProcess = parseInt(file.percentUploaded) + "%";
        var fileUploaded = convertHumanUnit(bytesLoaded);
        var fileSpeed = SWFUpload.speed.formatBytes(file.currentSpeed / 8) + "(" + SWFUpload.speed.formatBytes(file.averageSpeed / 8) + ")";
        $("#file_upload_size_" + file.id).empty().append(fileUploaded);
        $("#file_upload_speed_" + file.id).empty().append(fileSpeed);
        $("#file_upload_process_" + file.id).css("width", fileProcess);
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
    $("#fileHash_" + file.id).val(fileHash);
    $("#fileSavePath_" + file.id).val(filePath);

}

// This event comes from the Queue Plugin
function queueComplete(numFilesUploaded) {
    $("#isFlag").val(1);
    myAlert("上传完成!");
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
        file_types: FILE_TYPES,
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
        button_image_url: baseUrl+"skin/blue/pc/common/images/button_bg.png",
        button_width: "65",
        button_height: "28",
        button_placeholder_id: "bfSelectFileBtn",
        button_text: '<span class="theFont">选择文件</span>',
        button_text_style: ".theFont{font-size:12px;color:#ffffff;text-align:center;font-weight:bold;}",
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

$(function(){
    //var uploadPath= $.cookie("uploadPath2");
    var videoSevr= $.cookie("uploadServerAddress");
    var videoPort= $.cookie("uploadServerPort");
    var uploadServerRootUrl = "http://" + videoSevr + ":" + videoPort + "/bmc";
    var uploadUrl = "http://" + videoSevr + ":" + videoPort + "/bmc/upload/uploadFile";
    var uId=$("#uId").val();
    var uName=$("#uName").val();
    var jId=$("#jId").val();
    var dirId=$("#dirId").val();
    var params = {uId: uId, uName: uName, jId: jId, dirId: dirId};
    initBfUpload(uploadServerRootUrl, uploadUrl, params, null, null);

    $("#formPro").submit(function () {
        //验证资源名称
        var name = $("#name").val();
        if (name.length <= 0) {
            alert("资源名称不能为空!");
            return false;
        }
        var isFlag = $("#isFlag").val();
        if (isFlag==0) {
            alert("资源未上传完成不能保存!");
            return false;
        }
        return true;

    });

    $("#programTagInput").keyup(function(){
        var tags = $(this).val();

        var tagArr= tags.split(" ");
        var tagCount;
        for(var j = 0;j<tagArr.length;j++){
            var tag2 = tagArr[j].trim();
            if(!tag2.isEmpty()){
                tagCount++;
            }
        }
        var appendHtml = "";
        var splitValue = "";
        if(tagCount>5){
            alert("标签数量不能超过五个!")
        }else{
            for(var i=0;i<tagArr.length;i++){
                var tag = tagArr[i].trim();
                if(!tag.isEmpty()){
                    appendHtml+=("<span class='resources_keywors'>"+tag+"</span>");
                    splitValue+=(tag+";")
                }

            }
            $("#tagShow").empty().append(appendHtml);
            $("input[name='programTag']").val(splitValue);
        }


    });
});