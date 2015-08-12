var bfUploadObject;
var fileMap = [];
var n = 0;
var params = {};
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

var cancelRemoveFlag = true;

function fileQueued(file) {
    try {

        n++;
        var fileName = file.name;
        var fileHashInput = "<input type='hidden' id='fileHash_" + file.id + "' name='fileHash_" + file.index + "' value=''>";
        var fileNameInput = "<input type='text' class='upload_suc_title_text' name='fileName_" + file.index + "' value='" + file.name + "'>";
        var fileDescTextArea = "<textarea  class='upload_suc_title_describe' value='' name='fileDesc_" + file.index + "'></textarea>";
        var fileSavePathInput = "<input type='hidden' id='fileSavePath_" + file.id + "' name='fileSavePath_" + file.index + "' value=''>";
        var fileSizeInput = "<input type='hidden' id='fileSize_" + file.id + "' name='fileSize_" + file.index + "' value='"+file.size+"'>";

        var uploadListsDiv = $(".resources_upload_lists");
        var saveBtn = $("#saveBtn");

        var appendDiv = "";

        var useSize = parseInt($("#useSpaceSize").val(), 10) + file.size;
        var maxSize = parseInt($("#maxSpaceSize").val(), 10);

        // 已经使用的空间+文件大小 > 最大容量时，取消上传该文件
        if(useSize > maxSize && $("#role").val() != "0") {
            cancelRemoveFlag = false;
            bfUploadObject.cancelUpload(file.id);

            appendDiv =
                "<div id='upload_list_" + file.id + "'>" +
                "<div class='resources_upload_list'>"
                "   <h1>" +
                "       <span title=" + file.name + ">" + fileName + "</span>" +
                "       <span class='upload_suc_icon'></span>" +
                "   </h1>" +
                "   <div class=\"boful_ui_processbar_text\">该文件大小为："+convertHumanUnit(file.size)+"，空间容量不足，无法上传!</div>" +
                "<input type=\"button\" name=\"cancel\" class=\"resource_upload_cancel\" onclick=\"cancelUpload(this, \'" + file.id + "\', false, 0)\"value=\"取消\" />" +
                "   </div>" +
                "</div>";

        } else {
            $("#useSpaceSize").val(useSize);

            if($("#role").val() != "0" ) {
                $("#useSizeTd").empty().append(convertHumanUnit($("#useSpaceSize").val()));
            }

            appendDiv =
                "<div id='upload_list_" + file.id + "'>" +
                "<div class='resources_upload_list'>" +
                fileHashInput + fileSavePathInput + fileSizeInput +
                "   <h1>" +
                "       <span title=" + file.name + ">" + fileName + "</span>" +
                "       <span class='upload_suc_icon'></span>" +
                "   </h1>" +
                "   <div class=\"boful_ui_processbar\">" +
                "       <div class=\"boful_ui_processbar_label\" id='file_upload_process_" + file.id + "'></div>" +
                "   </div>" +
                "<input type=\"button\" name=\"cancel\" class=\"resource_upload_cancel\" onclick=\"cancelUpload(this, \'" + file.id + "\', true, "+file.size+")\"value=\"取消\" />" +
                "   <div class=\"boful_ui_processbar_text\">" +
                "       已上传：<span id='file_upload_size_" + file.id + "'>0</span>&nbsp;" +
                "       总大小:<span>" + convertHumanUnit(file.size) + "</span>&nbsp;" +
                "       平均上传速度：<span id='file_upload_speed_" + file.id + "'>未知</span>" +
                "       </div>" +
                "   </div>" +
                "   <div class='resources_upload_list1'>" +
                "    <div class='resources_upload_list1_title'>" +
                "           <h1>" +
                "               <span title=" + file.name + ">" + fileName + "</span>" +
                "               <span class='upload_suc_icon'></span>" +
                "               <span class='upload_suc_icon1'></span>" +
                "           </h1>" +
                '           <p>' +
                '               <span class="upload_suc_icon2"></span>' +
                '           </p>' +
                "       </div>" +
                "       <div class='upload_suc_title'>" +
                "           <h2>标题</h2>" +
                "           <label>" + fileNameInput + "</label>" +
                "       </div>" +
                '       <div class="upload_suc_describe">' +
                '        <h2>简介</h2>' +
                '           <label>' + fileDescTextArea + "</label>" +
                "       </div>" +
                "   </div>" +
                "</div>";
        }

        if(saveBtn.size()==1){
            saveBtn.before(appendDiv);
        } else{
            uploadListsDiv.append(appendDiv);
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

function fileDialogComplete(numFilesSelected, numFilesQueued) {
    try {
        //判断文件类型


        bfUploadObject.startUpload();
        var fileCount = $("#formPro").find("input[name=fileCount]");
        if (fileCount.val() == "") {
            fileCount.val(numFilesQueued);
        } else {
            fileCount.val(parseInt(fileCount.val()) + numFilesQueued);
        }
    } catch (ex) {
        this.debug(ex);
        alert("Error:" + ex);
    }
}

function uploadStart(file) {
    try {
        $("#isFlag").val(0);
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
        if(bytesLoaded == bytesTotal) {
            $("#file_upload_process_" + file.id).css("width","100%");
        }
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
        var fileListEl = $("#upload_list_" + file.id);
        if (fileListEl && cancelRemoveFlag) {
            fileListEl.remove();
        }
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
                if(cancelRemoveFlag) {
                    alert("Cancelled");
                }
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
    cancelRemoveFlag = true;
}

// This event comes from the Queue Plugin
function queueComplete(numFilesUploaded) {
    $("#isFlag").val(1);
    if (navigator.userAgent.indexOf("MSIE") > 0 || navigator.userAgent.indexOf("Trident")>0) {
        alert("上传完成!");
    } else {
        myAlert("上传完成!");
    }

}
/**
 * 停止上传
 */
function cancelUpload(obj, fileId, cancelFlag, fileSize) {
    if(cancelFlag) {
        bfUploadObject.cancelUpload(fileId, false);
        var useSize = parseInt($("#useSpaceSize").val(), 10) - fileSize;
        $("#useSpaceSize").val(useSize);
        if($("#role").val() != "0" ) {
            $("#useSizeTd").empty().append(convertHumanUnit($("#useSpaceSize").val()));
        }
    }
    $(obj.parentNode.parentNode).remove();
}
function initBfUpload(uploadServerRootUrl, uploadUrl, fileSizeLimit, params, limit, finishHandler) {
    if (!limit) {
        limit = 100;
    }
    var settings = {
        flash_url: uploadServerRootUrl + "/js/swfupload/swfupload.swf",
        flash9_url: uploadServerRootUrl + "/js/swfupload/swfupload_fp9.swf",
        upload_url: uploadUrl,
        file_size_limit: fileSizeLimit,
        file_types: returnAllTypes(),
        file_post_name: "fileEntity",
        post_params: params,
        file_types_description: "All Files",
        file_upload_limit: limit,
        file_queue_limit: limit,
        prevent_swf_caching: false,
        /*custom_settings: {
         progressTarget: "fsUploadProgress",
         cancelButtonId: "btnCancel"
         },*/
        debug: false,

        // Button settings
        button_image_url: baseUrl + "skin/blue/pc/common/images/button_bg.png",
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
function queryuploadPath() {
    var dirId = $(".resources_upload_chose option:selected").val();
    var uploadPath = $("#uploadPath").val();
    var filePath = "";
    var uId = $("#uId").val();
    if ("" != uploadPath) {
        if (uploadPath.substr(uploadPath.length - 1) == "/") {
            filePath = uploadPath + uId;
        } else {
            filePath = uploadPath + "/" + uId;
        }
        bfUploadObject.setPostParams({filePath: filePath});
    }

    /*$.post(baseUrl+"programMgr/queryDirectoryById",{dirId:dirId},function(data){
     var direcotry = data.direcotry;
     $("#uploadPath").val(direcotry.uploadPath);
     var uId = $("#uId").val();
     var uploadPath = $("#uploadPath").val();
     var filePath = "";
     if(uploadPath.substr(uploadPath.length-1)=="/"){
     filePath = uploadPath+uId;
     }else{
     filePath = uploadPath+"/"+uId;
     }
     bfUploadObject.setPostParams({filePath:filePath});

     })*/
}
function queryMediaType(){
    var otherOption = $("select[name=otherOption]").val();
    if(otherOption=='6'){
        var mediaType = 6;
        bfUploadObject.setPostParams({mediaType: mediaType});
    }

}
function initUpload() {
    var videoSevr = $.cookie("uploadServerAddress");
    var videoPort = $.cookie("uploadServerPort");
    var fileSizeLimit = $.cookie("fileSizeLimit") * 1024;
    var uploadServerRootUrl = "http://" + videoSevr + ":" + videoPort + "/bmc2";
    var uploadUrl = "http://" + videoSevr + ":" + videoPort + "/bmc2/api/upload";
    var filePath = $("#uploadPath").val();
    var otherOption = $("select[name=otherOption]").val();
    if(otherOption=='6'){
        var mediaType = 6;
        params = {filePath: filePath, mediaType: mediaType};
    } else {
        params = {filePath: filePath};
    }

    initBfUpload(uploadServerRootUrl, uploadUrl, fileSizeLimit, params, null, null);
}
$(function () {

    //var uploadPath= $.cookie("uploadPath2");
    initUpload();
    queryuploadPath();
    $("#formPro").submit(function () {
        var name = $("#name").val();
        if (name.length <= 0) {
            alert("资源名称不能为空!");
            return false;
        }
        var isFlag = $("#isFlag").val();
        if (isFlag == 0) {
            alert("资源未上传完成不能保存!");
            return false;
        }
        //判断是否有上传文件
        //验证资源名称
        var hasFile = $(".resources_upload_lists").children().size();
        var hasSaveBtn = $(".resources_upload_lists").has("#saveBtn").size();
        if (hasFile == 1 && hasSaveBtn==1) {
            alert("没有上传资源！！！");
            return false;
        }
        if (hasFile == 0 && hasSaveBtn==0) {
            alert("没有上传资源！！！");
            return false;
        }
        return true;

    });

    $("#programTagInput").keyup(function () {
        var tags = $(this).val();
        // 全角逗号转换成半角逗号
        tags = tags.replace(/，/ig,",");
        var tagArr = tags.split(",");
        var tagCount=0;
        for (var j = 0; j < tagArr.length; j++) {
            var tag2 = tagArr[j].trim();
            if (!tag2.isEmpty()) {
                tagCount++;
            }
        }
        var appendHtml = "";
        var splitValue = "";
        if (tagCount > 5) {
            alert("标签数量不能超过五个!")
        } else {
            for (var i = 0; i < tagArr.length; i++) {
                var tag = tagArr[i].trim();
                if (!tag.isEmpty()) {
                    appendHtml += ("<span class='resources_keywors'>" + tag + "</span>");
                    splitValue += (tag + ";")
                }

            }
            $("#tagShow").empty().append(appendHtml);
            $("input[name='programTag']").val(splitValue);
        }


    });

});