var FILE_TYPES = "*.swf;*.asf;*.avi;*.mp4;*.3gp;*.rmvb;*.wmv;*.flv;*.mpeg;*.mkv;*.rm;*.dat;*.vob;*.mov;*.tp;*.ts;*.f4v;*.mts;"+
    "*.doc;*.docx;*.pdf;*.ppt;*.pptx;*.xls;*.xlsx;*.txt;"+
    "*.mp3;*.wma;*.wav;*.mod;*.cd;*.mid;*.mpg;" +
    "*.jpg;*.png;*.gif;*.bmp;*.jpeg";

var file_video=['asf','avi','mp4','3gp','rmvb','wmv','flv','mpeg','mpg','mkv','rm','dat','vob','mov','tp', 'ts', 'f4v', 'mts'];
var file_doc=['doc','docx','pdf','ppt','pptx','xls','xlsx','txt'];
var file_image=['jpg','png','gif','bmp','jpeg'];
var file_audio=['mp3','wma','wav','mod','cd','mid'];
var file_flash=['swf'];
function returnAllTypes(){
    var types = "";
    for(var i=0;i<file_video.length;i++){
        types+="*."+file_video[i]+";";
    }
    for(var i=0;i<file_image.length;i++){
        types+="*."+file_image[i]+";";
    }
    for(var i=0;i<file_doc.length;i++){
        types+="*."+file_doc[i]+";";
    }
    for(var i=0;i<file_audio.length;i++){
        types+="*."+file_audio[i]+";";
    }
    for(var i=0;i<file_flash.length;i++){
        types+="*."+file_flash[i]+";";
    }
    return types;
}
function returnTypes(){
    var types = "";
    for(var i=0;i<file_video.length;i++){
        types+="*."+file_video[i]+";";
    }
    for(var i=0;i<file_image.length;i++){
        types+="*."+file_image[i]+";";
    }
    return types;
}
function returnImagesType(){
    var types = "";
    for(var i=0;i<file_image.length;i++){
        types+="*."+file_image[i]+";";
    }
    return types;
}
/**
 * 判断文件类型
 * @param fileType
 * @returns {number}
 */
function checkFileType(filePath) {
    var index= filePath.lastIndexOf(".");
    var fileType = filePath.substr(index+1,filePath.length).toLowerCase();
    for (var i = 0; i < file_video.length; i++) {
        if (file_video[i] == fileType) {
            return 1;
            break;
        }
    }
    for (var i = 0; i < file_doc.length; i++) {
        if (file_doc[i] == fileType) {
            return 2;
            break;
        }
    }
    for (var i = 0; i < file_image.length; i++) {
        if (file_image[i] == fileType) {
            return 3;
            break;
        }
    }
    for (var i = 0; i < file_audio.length; i++) {
        if (file_audio[i] == fileType) {
            return 4;
            break;
        }
    }
    for (var i = 0; i < file_flash.length; i++) {
        if (file_flash[i] == fileType) {
            return 5;
            break;
        }
    }
}
