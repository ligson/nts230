global = new globalVars();
var bShowPx = false;//是否已显示了排序提示
var gDateId = 0;//排序日期元素ID

var SHOW_OPT_SIMPLE = 0;	//globalVars.showOpt=0;//编目项显示" 0 简单 1缺省 2所有
var SHOW_OPT_DEFAULT = 1;
var SHOW_OPT_ALL = 2;

var UPLOAD_TYPE_SUBTITLE = 1000;	//globalVars.uploadType=-1;
var UPLOAD_TYPE_FCK = 2000;
var UPLOAD_TYPE_SERIAL_PHOTO = 3000;

var imgDialog = null;//富文本图片对话框对象
var metaList = new Array();//当前类


function init() {
    //UPLoginDirect(global.usename,global.pwd);
}

function globalVars() {
    this.programId = 0;
    this.classId = 1;
    this.metaList = new Array();
    this.tdNum = 3;
    this.disciplineId = 0;
    this.firstTitleId = 0;//名称元素的第一个显示修饰词ID，用作路径
    this.title = "";//资源名称的值
    this.titleId = 0;//名称元素ID
    this.metaCreatorId = 0;//创建者元素ID
    this.videoSevr = "";//视频服务器
    this.videoPort = "";//视频端口
    this.uploadPath = "";//上传路径
    this.transcodingIp = "";//转码服务器IP
    this.transcodingPort = "";//转码端口
    this.transcodingPort = "";//转码端口
    this.transcodingPath = "";//转码路径
    this.curUploadPath = "";//当前上传路径
    this.tagName = "标签";//标签名称
    this.resDescription = "描述";//资源描述名称
    this.showOpt = 0;//编目项显示" 0 简单 1缺省 2所有
    this.usename = "test";//显示所有编目项
    this.pwd = "testpwd";//显示所有编目项
    this.uploadType = -1;//字幕上传1000,富文本上传2000,子目上传3000
    //urlType记得与 truevod.js中的同步
    this.urlType = {
        "VIDEO": 0,
        "COURSE": 1,
        "IMAGE": 2,
        "POSTER": 3,
        "DOCUMENT": 4,
        "MIDDLE_CONTROL": 5,
        "ONLINE_COURSE": 6,
        "TRURAN_COURSE": 7,
        "LINK": 8,
        "MOBILE": 9,
        "TABLET": 10,
        "TEXT_LIBRARY": 11,
        "EMBED_PC": 12
    };
    //显示类型:详细，2摘要，4浏览类别(目录树中有显示),8编目缺省显示，16可导出，32唯一性
    this.showType = {
        "DETAIL": 1,
        "ABSTRACT": 2,
        "TREE": 4,
        "DEFAULT": 8,
        "EXPORT": 16,
        "UNIQUE": 32
    };
}

function playLink(theForm) {
    var strServer = global.videoSevr + ':' + global.videoPort;
    var strUrl = theForm.selFilePath.value;
    var strProgName = theForm.name.value;
    var webHost = window.location.hostname + ':' + global.videoPort;

    //BMTPPlayEx(strServer,strUrl,strProgName,'','',theForm.startTime.value,theForm.endTime.value);
    var url = "BMSP://ADDR=" + strServer + ";UID=" + global.usename + ";PWD=" + global.pwd + ";FILE=" + theForm.selFilePath.value + ";SUB1=;SUB2=;STM=" + theForm.startTime.value + ";ETM=" + theForm.endTime.value + ";PFG=2;"
    var playUrl = "bfp://" + webHost + "/pfg=p&enc=b&url=" + Base64.encode(url);

    var iframeObj = document.getElementById("playFrame");
    if (!iframeObj) iframeObj = createIframe("playFrame");
    iframeObj.src = playUrl;

    return true;
}

function checkSerial(theForm) {
    form1.serialId.value = theForm.selSerialId.value;
    document.getElementById("filePath").value = theForm.selFilePath.value;
    document.getElementById("url").value = theForm.selFilePath.value;

    return true;
}

//字符串左边补0，字符串位数charNum不大于10;
function padLeftZero(str, charNum) {
    if (str == null || str == "") return "00";

    var s = "0000000000" + str;
    s = s.substring(s.length - charNum);
    return s;
}

//素材数据模板生成后，显示模板，并给表单元素赋值	孙长贵	2012/9/28
function editMaterial(id, bEdit) {
    try {
        var serialsTR = document.getElementById("serialsTR");
        serialsTR.style.display = "block";

        var editDiv = document.getElementById("editMaterial");
        editDiv.style.display = "block";
        document.getElementById('qfbxtb').style.display = 'block';
        //document.body.style.overflow = 'hidden';

        setDivCenter(editDiv);
        if (global.programId > 0) {
            editMaterialForm.operation.value = "edit";
            editMaterialForm.programId.value = global.programId;
        }
        else {
            editMaterialForm.operation.value = "add";
        }

        onSelectSerial(editMaterialForm.selectSerial);
    }
    catch (e) {
        document.getElementById('qfbxtb').style.display = 'none';
        //document.body.style.overflow = 'scroll';
        alert(e.name + ": " + e.message);
    }
}

function onSelectSerial(theObj) {
    var theForm = theObj.form;
    var info = theObj.value;
    var info1 = theForm.selectSerial1.value
    if (info != null && info != "") {
        var arrInfo = info.split("*");
        if (arrInfo.length > 3) {
            theForm.name.value = theObj.options[theObj.selectedIndex].text;
            theForm.urlType.value = arrInfo[0];
            theForm.progType.value = arrInfo[1];
            theForm.svrAddress.value = arrInfo[2];
            theForm.selFilePath.value = arrInfo[3];
            theForm.selSerialId.value = arrInfo[4];//选中的serialId
        }
        else {
            alert("该子目信息不完整");
        }
    }
    else if (info1 != null && info1 != "") {
        var theObj1 = theForm.selectSerial1
        var arrInfo = info1.split("*");
        if (arrInfo.length > 3) {
            theForm.name.value = theObj1.options[theObj1.selectedIndex].text;
            theForm.urlType.value = arrInfo[0];
            theForm.progType.value = arrInfo[1];
            theForm.svrAddress.value = arrInfo[2];
            theForm.selFilePath.value = arrInfo[3];
            theForm.selSerialId.value = arrInfo[4];//选中的serialId
        }
        else {
            alert("该子目信息不完整");
        }
    }
    else {
        alert("该资源格式不能被提取，请关闭本窗口，另选其它资源。");
    }
}

function closeMaterial(divName1, divName2) {
    document.getElementById(divName1).style.display = 'none';
    document.getElementById(divName2).style.display = 'none';
    //document.body.style.overflow = 'scroll';
}

//上传文件
function openSigle() {
    form1.UpLoad1.SaveType = 800;
    form1.UpLoad1.IsMultiFile = 100;
    form1.UpLoad1.AutoUpload = 0;
    form1.UpLoad1.OpenFile();
    document.getElementById("url").value = "";
}
function UploadSigle() {
    form1.UpLoad1.SaveType = 800;
    form1.UpLoad1.IsMultiFile = 100;
    form1.UpLoad1.AutoUpload = 0;
    form1.UpLoad1.UploadFiles2();
    alert(form1.UpLoad1.DstFileName);
    form1.url.value = form1.UpLoad1.DstFileName;
    return true;
}

//验证图片格式
function checkImg(url) {
    var AllImgExt = ".jpg|.jpeg|.gif|.bmp|.png|"; //全部图片格式类型
    var fileExt = url.substr(url.lastIndexOf(".")).toLowerCase();
    if (AllImgExt.indexOf(fileExt + "|") == -1) {
        return "该文件类型不允许上传!请上传" + AllImgExt + "类型的文件.";
    }
    return '';
}

function saveUserActivity() {
    //清空所有提示
    $("#namePrompt").html('');
    $("#shortNamePrompt").html('');
    $("#startTimePrompt").html('');
    $("#endTimePrompt").html('');
    $("#ategory2Prompt").html("");
    $("#descriptionPrompt").html('');
    $("#imagePrompt").html('');

    if ($("#name").val().length == 0) {
        $("#namePrompt").html('<span  class="p_sent_w">标题不能为空值!</span>');
        $("#name").focus();
        $("#name").select();
        return false;
    }
    else if ($("#name").val().length > 50) {
        var manyLength = (parseInt($("#name").val().length) - 50);
        $("#namePrompt").html('<span class="p_sent_w">标题超出了' + manyLength + '个字符!</span>');
        $("#name").focus();
        $("#name").select();
        return false;
    }
    else if ($("#name").val() == "标题必填，不得多于50个字。") {
        $("#namePrompt").html('<span class="p_sent_w">你还未输入标题!</span>');
        $("#name").focus();
        $("#name").select();
        return false;
    }
    else if ($("#shortName").val().length == 0) {
        $("#shortNamePrompt").html('<span class="p_sent_w">简称不能为空值!</span>');
        $("#shortName").focus();
        $("#shortName").select();
        return false;
    }
    else if ($("#shortName").val().length > 50) {
        var manyLength = (parseInt($("#shortName").val().length) - 50);
        $("#shortNamePrompt").html('<span class="p_sent_w">简称超出了' + manyLength + '个字符!</span>');
        $("#shortName").focus();
        $("#shortName").select();
        return false;
    }
    else if ($("#shortName").val() == "简称必填，不得多于50个字。") {
        $("#shortNamePrompt").html('<span class="p_sent_w">你还未输入简称!</span>');
        $("#shortName").focus();
        $("#shortName").select();
        return false;
    } else if($("#image").val() == "" && $("#photo").val() == "") {
        $("#imagePrompt").html('<span class="p_sent_w">你还未上传缩略图!</span>');
        return false;
    } else if (checkImg($("#image").val()) != "") {
        $("#imagePrompt").html("&nbsp;&nbsp;<font style='color:red;'>"+checkImg($("#image").val())+"</font>");
        return;
    } else if ($("#category1").val() == null) {
        $("#ategory1Prompt").html('<span class="p_sent_w">一级分类不能为空</span>');
        $("#shortName").focus();
        $("#shortName").select();
        return false;
    }
    else if ($("#startTime").val().length == 0) {
        $("#startTimePrompt").html('<span class="p_sent_w">开始时间不能为空!</span>');
        $("#startTime").focus();
        $("#startTime").select();
        return false;
    }
    else if (new Date(Date.parse($("#startTime").val().replace(/-/g, "/"))) - new Date() < -24 * 60 * 60 * 1000) {
        $("#startTimePrompt").html('<span class="p_sent_w">开始时间不能小于当天!</span>');
        $("#startTime").focus();
        $("#startTime").select();
        return false;
    }
    else if ($("#endTime").val().length == 0) {
        $("#endTimePrompt").html('<span class="p_sent_w">结束时间不能为空!</span>');
        $("#endTime").focus();
        $("#endTime").select();
        return false;
    }
    else if (new Date(Date.parse($("#startTime").val().replace(/-/g, "/"))) > new Date(Date.parse($("#endTime").val().replace(/-/g, "/")))) {
        $("#endTimePrompt").html('<span class="p_sent_w">开始时间不能大于结束时间!</span>');
        $("#endTime").focus();
        $("#endTime").select();
        return false;
    }
    else if ($("#description").val().length == 0) {
        $("#descriptionPrompt").html('<span class="p_sent_w">内容不能为空值!</span>');
        $("#description").focus();
        $("#description").select();
        return false;
    } else {
        if($("#category2").val()!=null && $("#category2").val()!="") {
            $("#categoryId").val($("#category2").val());
        } else {
            $("#categoryId").val($("#category1").val());
        }
    }
    $("#saveUserActivityForm").submit();
}

function saveUserWork() {
    $('#filePathPrompt').html('上传文件(不能上传可执行文件和web程序文件)');
    $('#namePrompt').html('');
    $('#descriptionPrompt').html('');

    if ($('#name').val().length == 0) {
        $('#namePrompt').html('<span class="p_sent_w">标题不能为空值!</span>');
        $('#name').focus();
        $('#name').select();
        return false;
    }
    else if ($('#name').val().length > 50) {
        var manyLength = (parseInt($('#name').val().length) - 50);
        $('#namePrompt').html('<span class="p_sent_w">标题超出了' + manyLength + '个字符!</span>');
        $('#name').focus();
        $('#name').select();
        return false;
    }
    else if ($('#name').val() == "标题必填，不得多于50个字。") {
        $('#namePrompt').html('<span class="p_sent_w">你还未输入标题</span>');
        $('#name').focus();
        $('#name').select();
        return false;
    }
    else if ($('#urlType').val() == "") {
        $('#urlTypePrompt').html('<span class="p_sent_w">请选择文件类型!</span>');
        $('#urlType').focus();
        $('#urlType').select();
        return false;
    }
    else if ($("#filePath").val().length == 0) {
        $("#filePathPrompt").html('<span class="p_sent_w">你还未上传文件</span>');
        $("#filePathPrompt").focus();
        $("#filePathPrompt").select();
        return false;
    }
    else if ($('#url').val().length == 0) {
        $('#filePathPrompt').html('<span class="p_sent_w">你还未上传文件!</span>');
        $('#filePath').focus();
        $('#filePath').select();
        return false;
    }
    else if ($('#description').val().length == 0) {
        $('#descriptionPrompt').html('<span class="p_sent_w">内容不能为空值!</span>');
        $('#description').focus();
        $('#description').select();
        return false;
    }

    form1.submit();
}

function editUserWork() {
    $('#filePathPrompt').html('上传文件(不能上传可执行文件和web程序文件)');
    $('#namePrompt').html('');
    $('#descriptionPrompt').html('');

    if ($('#name').val().length == 0) {
        $('#namePrompt').html($('#namePrompt').html() + '<span class="p_sent_w">标题不能为空值!</span>');
        $('#name').focus();
        $('#name').select();
        return false;
    }
    else if ($('#name').val().length > 50) {
        var manyLength = (parseInt($('#name').val().length) - 50);
        $('#namePrompt').html($('#namePrompt').html() + '<span class="p_sent_w">标题超出了' + manyLength + '个字符!</span>');
        $('#name').focus();
        $('#name').select();
        return false;
    }
    else if ($('#name').val() == "标题必填，不得多于50个字。") {
        $('#namePrompt').html($('#namePrompt').html() + '<span class="p_sent_w">你还未输入标题!</span>');
        $('#name').focus();
        $('#name').select();
        return false;
    }
    else if ($('#urlType').val() == "") {
        $('#urlTypePrompt').html($('#urlTypePrompt').html() + '<span class="p_sent_w">请选择文件类型!</span>');
        $('#urlType').focus();
        $('#urlType').select();
        return false;
    }
    else if ($('#filePath').val().length != 0) {
        if ($('#url').val().length == 0) {
            $('#filePathPrompt').html($('#filePathPrompt').html() + '<span class="p_sent_w">你还未上传文件!</span>');
            $('#filePath').focus();
            $('#filePath').select();
            return false;
        }
    }
    else if ($('#description').val().length == 0) {
        $('#descriptionPrompt').html($('#descriptionPrompt').html() + '<span class="p_sent_w">内容不能为空值!</span>');
        $('#description').focus();
        $('#description').select();
        return false;
    }
    form1.action = "/appMgr/updateUserWork";
    form1.submit();
}