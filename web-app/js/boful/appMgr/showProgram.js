var playTime = 0;
var timeOut = 0;
var fromPlayWeb = 0;//0资播放页面 1作品播放页面 2手机播放
var hasShowLine = false;
var curPlayObj = {index: 0, postion: 0};	//当前播放对象，保存playlist索引,位置
var Serial = {NO_NEED_STATE: 0, NO_CODE_STATE: 1, CODING_STATE: 2, CODED_STATE: 3, CODED_FAILED_STATE: 4};
//serial类
function CSerialObj(id, programId, serialNo, name, playUrl, startTime, endTime, transcodeState, photo, state, fileHash, fileType) {
    //Enum Property
    this.id = id;
    this.programId = programId;
    this.serialNo = serialNo;
    this.name = name;
    this.playUrl = playUrl;
    this.startTime = startTime;
    this.endTime = endTime;
    this.transcodeState = transcodeState;
    this.photo = photo;
    this.state = state;
    this.fileHash = fileHash;
    this.fileType = fileType;
    this.subtitles = new Array();
}

//nts.program.domain.Subtitle 字幕类
function CSubtitleObj(id, serialId, serialNo, filePath, type) {
    //Enum Property
    this.id = id;
    this.serialId = serialId;
    this.serialNo = serialNo;
    this.name = name;
    this.playUrl = playUrl;
    this.startTime = startTime;
    this.endTime = endTime;
    this.subtitles = null;
}

//设置播放行，下载行是否显示,有的资源只有图片，没有可点播下载的资源
function setPlayTrShow() {
    var playTrObj = document.getElementById("playTr");
    var playTdObj = document.getElementById("playTd");
    var downTrObj = document.getElementById("downTr");
    var downTdObj = document.getElementById("downTd");
    var imgDivObj = document.getElementById("imgDiv");


    if (playTdObj) {
        if (playTdObj.innerHTML.length < 10) playTrObj.style.display = "none";
    }
    if (downTdObj) {
        if (downTdObj.innerHTML.length < 10) downTrObj.style.display = "none";
    }
    if (imgDivObj) {
        if (imgDivObj.innerHTML.length < 100) imgDivObj.style.display = "none";
    }
}

function showTr(arrCell, iRow) {
    if (iRow == -1) iRow = wtab.rows.length;//-1表从最末行显示
    wtab.insertRow(iRow);
    wtab.rows[iRow].insertCell(0);
    wtab.rows[iRow].cells[0].className = "key";
    wtab.rows[iRow].cells[0].innerHTML = arrCell[0];
    wtab.rows[iRow].insertCell(1);
    wtab.rows[iRow].cells[1].innerHTML = arrCell[1];
}

function showAllTr() {
    var arrCell = new Array("", "");
    var i, iRow, j, elementObj, theProgObj, vContent;
    iRow = 0;//从第几行开始
    for (i = 0; i < metaList.length; i++) {

        if (metaList[i].parentId == 0) {
            //theProgObj=progList[0];
            elementObj = metaList[i];
            vContent = getContent(elementObj);
            if (vContent == null || vContent == "")
                continue;

            arrCell[0] = elementObj.cnName;
            arrCell[1] = vContent;
            showTr(arrCell, iRow);

            iRow++;
        }
    }

}

function getENameFromId(vId, vArrEnum) {
    if (vArrEnum == null)
        return "";
    var i;
    for (i = 0; i < vArrEnum.length; i++) {
        if (vArrEnum[i].id == vId)
            return vArrEnum[i].name;
    }

    return "";
}

//参数是元素
function getContent(elementObj) {
    if (elementObj == null)
        return null;
    var i, j, vStr, arrEnum, bAddBr, theContent, elementId, useMetaobj;
    var eleName = "", decoName = "";//元素名，修饰词名
    var eMenuId, eMenuName;
    var bDeco = elementObj.dataType == "decorate";//是否是复合元素
    vStr = "";

    for (j = 0; j < contentList.length; j++) {
        theContent = contentList[j];
        elementId = bDeco ? theContent.metaParentId : theContent.metaId;//是修饰词，则content元数据的parentId是元素ID

        if (elementId == elementObj.selfId) {

            useMetaobj = bDeco ? getMetaFromId(theContent.metaId) : elementObj;
            if (useMetaobj == null) continue;
            eleName = elementObj.cnName;
            decoName = useMetaobj.cnName;
            decoName = eleName == decoName ? "" : (decoName + "：");

            var strContent = theContent.strContent;

            if (useMetaobj.dataType == "number") {
                if (theContent.numContent > 0)
                    vStr += decoName + theContent.numContent + "<br>";
            }
            else if (useMetaobj.dataType == "enumeration") {
                arrEnum = useMetaobj.arrEnum;
                if (arrEnum != null) {
                    eMenuId = theContent.numContent;
                    eMenuName = getENameFromId(eMenuId, arrEnum)
                    if (eMenuId > 0 && eMenuName != "") {
                        vStr += decoName + eMenuName + "<br>";
                    }
                    else {
                        if (gDisciplineId == elementObj.selfId)//没有二级学科的显示一级学科名
                            vStr += useMetaobj.cnName + "<br>";
                    }
                }
            }
            else if (useMetaobj.dataType == "link") {
                if (strContent != "") {
                    var str = decoName + HTMLDeCode(strContent);
                    if (str.length > 25) {
                        str = strContent.substring(0, 25) + "...";
                    }
                    vStr += str + "<br>";
                }
            }
            else {
                if (strContent != "") {
                    var str = decoName + HTMLDeCode(strContent);
                    if (str.length > 25) {
                        str = strContent.substring(0, 25) + "...";
                    }
                    vStr += str + "<br>";
                }
            }
        }
    }//for

    if (vStr.substring(vStr.length - 1) == "；")
        vStr = vStr.substring(0, vStr.length - 1);

    return vStr;
}

function HTMLDeCode(str) {
    var s = "";
    if (str.length == 0) return "";
    s = str.replace(/&amp;/g, "&");
    s = s.replace(/&lt;/g, "<");
    s = s.replace(/&gt;/g, ">");
    s = s.replace(/&nbsp;/g, " ");
    s = s.replace(/<br>/g, "\n");
    s = s.replace(/&#39;/g, "\'");
    s = s.replace(/&quot;/g, "\"");
    return s;
}

function HTMLEnCode(str) {
    var s = "";
    if (str.length == 0) return "";
    s = str.replace(/[\r\n]/g, "<br>");
    s = s.replace(/[\n]/g, "<br>");

    return s;
}

function checkRemark() {
    var theForm = document.getElementById("remarkForm");

    if (theForm.topic.value == "") {
        alert("请输入主题。");
        theForm.topic.focus();
        return false;
    }

    if (theForm.content.value == "") {
        alert("请输入内容。");
        theForm.content.focus();
        return false;
    }

    return true;
    //theForm.submit();
}

function submitRemark() {
    var theForm = document.getElementById("remarkForm");
    if (checkRemark()) {
        theForm.submit()
    }
    return false;
}
function remarkFormSubmit(programId) {
    jQuery.ajax({type: 'POST', data: jQuery(this).serialize(), url: baseUrl + 'program/saveRemark?program.id=' + programId, success: function (data, textStatus) {
        jQuery('#remarkList').html(data);
    }, error: function (XMLHttpRequest, textStatus, errorThrown) {
    }, complete: function (XMLHttpRequest, textStatus) {
    }});
    return false
}
function showRemarkPost() {

    if (!gCanComment) {
        if (isAnony)
            alert("对不起，匿名用户没有评论权限，请登录后试试。");
        else
            alert("对不起，您没有评论权限，请联系管理员。");
        return false;
    }

    var remarkPost = document.getElementById('remarkPost');
    var isShowRemark = document.getElementById('isShowRemark').value;
    if (isShowRemark == "show") {
        remarkPost.style.display = "none";
        document.getElementById('isShowRemark').value = "hide";
    }
    else {
        remarkPost.style.display = "block";
        document.getElementById('isShowRemark').value = "show";
    }
}

function hideRemarkPost() {
    var remarkPost = document.getElementById('remarkPost');//可用$()
    try {
        document.remarkForm.reset();
        remarkPost.style.display = "none";
        document.getElementById('isShowRemark').value = "hide";
    }
    catch (e) {
        alert(e);
    }
}

function resetRemarkPost() {
    try {
        document.remarkForm.reset();
        return false;
    }
    catch (e) {
        alert(e);
    }
}

//id是层ID
function showDiv(id) {
    eval("document." + id + "Form.reset();");//清空先前的内容
    var editDiv = document.getElementById(id);
    editDiv.style.display = "block";
    setDivCenter(editDiv);
}

function checkError(theForm) {
    if (theForm.errorTitle.value == "") {
        alert("请输入错误标题。");
        theForm.errorTitle.focus();
        return false;
    }

    if (theForm.errorContent.value == "") {
        alert("请输入错误内容。");
        theForm.errorContent.focus();
        return false;
    }
}

function checkCollect(theForm) {
    if (theForm.tag.value == "") {
        alert("请输个性标签。");
        theForm.tag.focus();
        return false;
    }
}

function showFileInfo(theObj, sHtml) {
    if (sHtml == null || sHtml == "") return;

    var divObj = document.getElementById("fileInfo");
    var subDivObj = document.getElementById("fileInfoBC");

    //防止右边div看不见
    var centerPos = document.body.clientWidth / 2;//水平
    var theObjLeft = getAbsoluteLeft(theObj);

    if (theObjLeft < centerPos + divObj.clientWidth - 35)
        divObj.style.left = theObjLeft + 'px';
    else
        divObj.style.left = (theObjLeft - divObj.clientWidth) + 'px';

    divObj.style.top = (getAbsoluteTop(theObj) + 25) + 'px';
    divObj.style.zIndex = 10;
    subDivObj.innerHTML = HTMLEnCode(sHtml);
    divObj.style.display = "block";
}

function hideFileInfo() {
    var fileDiv = document.getElementById("fileInfo");
    fileDiv.style.display = "none";
}

///////////////////////////////////////////////////////////////图片开始

var gImgNum = 0;
var gCurImgIndex = 0;
var gCurAbbrImgObj = null;

function openImg(index, url) {
    var curImgDivObj = document.getElementById("curImgDiv");
    var curImgObj = document.getElementById("curImg");

    if (gCurAbbrImgObj) gCurAbbrImgObj.className = "";
    curImgObj.style.zoom = "100%";
    curImgObj.src = url;

    gCurAbbrImgObj = document.getElementById("abbrImg_" + index);
    gCurAbbrImgObj.className = "curAbbrImg";

    curImgDivObj.style.display = "block";
    gCurImgIndex = index;
}

function resizeImg(ImgD, iwidth, iheight) {
    var image = new Image();
    image.src = ImgD.src;

    if (image.width > 0 && image.height > 0) {
        if (image.width / image.height >= iwidth / iheight) {
            if (image.width > iwidth) {
                ImgD.width = iwidth;
                ImgD.height = (image.height * iwidth) / image.width;
            } else {
                ImgD.width = image.width;
                ImgD.height = image.height;
            }
            ImgD.alt = image.width + "×" + image.height;
        }
        else {
            if (image.height > iheight) {
                ImgD.height = iheight;
                ImgD.width = (image.width * iheight) / image.height;
            } else {
                ImgD.width = image.width;
                ImgD.height = image.height;
            }
            ImgD.alt = image.width + "×" + image.height;
        }
        //ImgD.style.cursor= "pointer"; //改变鼠标指针
        //ImgD.onclick = function() { window.open(this.src);} //点击打开大图片

        //////////////////滚轮缩放开始
        /*
         if(navigator.userAgent.toLowerCase().indexOf("ie") > -1)
         {
         　　　　　　ImgD.onmousewheel = function img_zoom() //滚轮缩放
         {
         　　　　　　　　var zoom = parseInt(this.style.zoom, 10) || 100;
         　　　　　　　　zoom += event.wheelDelta / 12;
         　　　　　　　　if (zoom> 0 && ImgD.width*zoom/100 < iwidth)　this.style.zoom = zoom + "%";
         　　　　　　　　return false;
         　　　　　 }
         }
         //如果不是IE
         else {
         　　　　　　　      //ImgD.title = "点击图片可在新窗口打开";
         }
         */
        //////////////////滚轮缩放开始
    }
}

function toImg(n)//n=-1 pri,n=1 next
{
    if (gCurImgIndex < 1 && n < 0) {
        alert("已是第一张图片了！");
        return;
    }

    if (gCurImgIndex > gImgNum - 2 && n > 0) {
        alert("已是最后一张图片了！");
        return;
    }

    gCurImgIndex = gCurImgIndex + n;
    var curImgObj = document.getElementById("curImg");
    var gCurAbbrImgObj = document.getElementById("abbrImg_" + gCurImgIndex);
    gCurAbbrImgObj.click();

    //setNodeInfo("imgCur.jsp?sid="+gArrSID[gCurImgIndex],"curImg");

    //document.getElementById("imgpos").innerHTML="("+(gCurImgIndex+1)+"/"+gImgNum+")";
    //document.getElementById("imgpos2").innerHTML="("+(gCurImgIndex+1)+"/"+gImgNum+")";
    //setNodeInfo("imgCur.jsp?sid="+gArrSID[gCurImgIndex],"curImgDesc");
}

function onImg(obj, n)//n=0 click ,1 onmouseover,2 onmouseout
{
    //obj=document.getElementById("curImg").firstChild;
    if (n == 2) {
        obj.className = "";
        return;
    }
    var vCenterPos = getCenterPos(obj);

    if (event.clientX < vCenterPos) {
        if (n == 0) {
            //obj.alt="";
            toImg(-1);
            return;
        }

        obj.className = "precur";
        //obj.alt="可使用鼠标滚轮缩放图片,点击图片左边跳到上一张";
    }
    else {
        if (n == 0) {
            //obj.alt="";
            toImg(1);
            return;
        }

        obj.className = "nextcur";
        //obj.alt="可使用鼠标滚轮缩放图片,点击图片右边跳到下一张";
    }
}

function getCenterPos(obj) {
    var w = document.body.clientWidth / 2;
    return w;
}

function hideImgWnd() {
    hideWnd('curImgDiv');
    if (gCurAbbrImgObj) gCurAbbrImgObj.className = "";
}

function setImgNum() {
    var imgNumObj = document.getElementById("abbrImgNum");
    if (imgNumObj) gImgNum = imgNumObj.value;
}

//////////////////////////////////////////////////图片结束

//////批量播放开始
//选择子目(集),urlType是资源类型，serialNum是该资源类型的子目数,dealType是处理类型（0下载,1批量播放，2复制链接）
function selectProgram(urlType, serialNum, dealType) {
    showDiv("batchPlay");//batchPlay层，为批量播放，复制链接共用，因为以前是只批量播放，故命名不恰当，
}

//选择集数后，点击播放
function batchPlay(theForm, isPlay) {
    var urlType = -1;//-1表示批量
    var playUrl = "";//此处实际上是serialId列表，形如：234,235,236
    var state = 0;//允许
    var programId = gProgramId;
    var isAll = batchPlayForm.selall.checked;//是否全选

    //如果是全选，就不用传大量的serialID列表了
    playUrl = isAll ? "0" : getCheckBoxListStr("idList");

    if (!isAll && playUrl == "") {
        alert("请至少选择一个资源！");
    }
    else {
        playProgram(playUrl, programId, urlType, isPlay, state);

    }
}

//////批量播放结束


//复制播放链接,播放链接中href必须是按规约的：url作为第一个参数且紧跟逗号（,）
function copyToClipBoard(id) {
    var url = "";
    var obj = document.getElementById(id);

    if (obj && window.clipboardData) {
        url = obj.value;

        if (url.length < 10) {
            alert("对不起，可能不是可内嵌播放的视频，不能复制。");
            return;
        }

        window.clipboardData.clearData();
        window.clipboardData.setData("Text", url);
        alert("复制成功。现在您可以粘贴（Ctrl+v）到Blog 或BBS中了。");
    }
    else {
        alert("您使用的浏览器不支持此复制功能，请使用Ctrl+C或鼠标右键。");
    }
}

//从javascript:playProgram('bfp://localhost:8080/pfg=p&enc=b&url=Qk1UUDovLTI7Rkc9Mjs=',7906,0,1,0)中获取bfp://localhost:8080/pfg=p&enc=b&url=Qk1UUDovLTI7Rkc9Mjs=
function getCopyUrl(str) {
    var url = "";
    var nPos = 0;
    var nPos2 = 0;

    nPos = str.indexOf("('");
    if (nPos > 0) {
        nPos2 = str.indexOf("',", nPos);
        if (nPos2 > 0) url = str.substring(nPos + 2, nPos2);
    }

    return url;
}

function toCopyToClipboard(txt) {
    if (window.clipboardData) {
        window.clipboardData.clearData();
        window.clipboardData.setData("Text", txt);
    } else if (navigator.userAgent.indexOf("Opera") != -1) {
        window.location = txt;
    } else if (window.netscape) {
        try {
            netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
        } catch (e) {
            alert("被浏览器拒绝！\n请在浏览器地址栏输入'about:config'并回车\n然后将'signed.applets.codebase_principal_support'设置为'true'");
        }
        var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
        if (!clip)
            return;
        var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
        if (!trans)
            return;
        trans.addDataFlavor('text/unicode');
        var str = new Object();
        var len = new Object();
        var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
        var copytext = txt;
        str.data = copytext;
        trans.setTransferData("text/unicode", str, copytext.length * 2);
        var clipid = Components.interfaces.nsIClipboard;
        if (!clip)
            return false;

        clip.setData(trans, null, clipid.kGlobalClipboard);


    }
}

/////复制链接结束

//------------------嵌入式播放开始-----------------------
function getBitrateList(transcodeState, serial, params) {
    var bitrateList = [];
    var bitrateIndex = 0;
    var playUrl = lineReplace(serial.playUrl);

    bitrateList[bitrateIndex++] = {file: playUrl, label: "原始"};
    //alert(bitrateList[0].file);
    /*if (transcodeState == 0) bitrateList[bitrateIndex++] = {file: playUrl + params, width: 640, height: 360};
     if (parseInt(transcodeState & 8) == 8) bitrateList[bitrateIndex++] = {file: playUrl + "_bq.mp4" + params, label: "标清"};
     if (parseInt(transcodeState & 16) == 16) bitrateList[bitrateIndex++] = {file: playUrl + "_gq.mp4" + params, label: "高清"};
     if (parseInt(transcodeState & 32) == 32) bitrateList[bitrateIndex++] = {file: playUrl + "_cq.mp4" + params, label: "超清"};
     */

    return bitrateList
}

function getParams(serial0) {
    var startSecond = getSecondNum(serial0.startTime);
    var endSecond = getSecondNum(serial0.endTime);

    var transcodeState = serial0.transcodeState;
    var playUrl0 = serial0.playUrl;

    var end = endSecond != 0 ? "&vend=" + endSecond : "";
    var params = "?vbegin=" + startSecond + end;

    return params;
}

//00h:00mi:00ss	  根据时间字符串来获得时间的秒数
function getSecondNum(str) {
    var num = 0;
    if (str == null || str == "") return nun;

    var arrTime = str.split(":");
    if (arrTime.length > 2) num = parseInt(arrTime[0]) * 60 * 60 + parseInt(arrTime[1]) * 60 + parseInt(arrTime[2]);

    return num;
}


function timeAdd() {
    if (fromPlayWeb == 0) {
        if (playTime != -1) {
            playTime = playTime + 1;
            if (playTime <= gAutoPlayTime) {
                timeOut = setTimeout("timeAdd()", 1000);
            }
            else {
                playTime = -1;
                addPlayedProgram();
            }

        }
    }
}

function addPlayedProgram() {
    var url = baseUrl + 'program/playProgram';
    var params = 'isPlay=1&programId=' + gProgramId + '&urlType=0&serialIdList=&isOutHost=0&timestamp=' + new Date().getTime();
    jQuery.ajax({
        type: "GET",
        url: url,
        data: params,
        error: function (data) {
            alert("添加节目播放日志有误，请与管理员联系！");
        }
    });
}

//替换url中&并encodeURI
function encodeURI2(url) {
    if (url == null) return "";

    url = replaceAndChar(url)
    url = encodeURI(url);
}

function replaceAndChar(url) {
    url = url.replace(/\&/g, "%26");
    return url;
}

//线路替换(ip替换)
function lineReplace(url) {
    var ipAddr = getLineAddr();

    if (ipAddr != "") {
        url = url.replace(/http:\/\/(.*?):/g, "http://" + ipAddr + ":");
    }

    return url;
}

function getLineAddr() {
    var temp = document.getElementsByName("lineRadio");
    if (!temp || temp.length < 2) return "";

    for (i = 0; i < temp.length; i++) {
        if (temp[i].checked) return temp[i].value;
    }
}

function getPlayList() {
    var playList = [];
    var startSecond = 0;
    var endSecond = 0;
    var captionsFiles = "";		//字幕路径
    var captionsLabels = "";	//字幕语种


    for (var i = 0; i < serialList.length; i++) {
        //var playUrl = getPlayUrl(serialList[i]);
        var transcodeState = serialList[i].transcodeState;

        var captions = new Array();

        for (var j = 0; j < serialList[i].subtitles.length; j++) {
            captions[j] = {file: lineReplace(serialList[i].subtitles[j].url), label: serialList[i].subtitles[j].lang.zhName, kind: "captions", "default": j == 0};
        }

        var bitrateList = getBitrateList(transcodeState, serialList[i], getParams(serialList[i]));
        ////现共享暂不支持标清，高清切换，字幕只支持单字幕 共享代码开始
        //var mediaid = 'sid=' + serialList[i].id;
        var capFile0 = '';
        var capLabel0 = '';
        if (captions.length > 0) {
            capFile0 = lineReplace(captions[0].file);
            capLabel0 = captions[0].label;
        }
        var mediaid = "";
        //if(bitrateList.length > 0) mediaid = 'sid=' + serialList[i].id + '&title=' + serialList[i].name + '&file=' + replaceAndChar(bitrateList[0].file) + '&capFile0=' + (capFile0) + '&capLabel0='+encodeURI(capLabel0)+'&image=' + encodePhoto(serialList[i].photo);
        if (bitrateList.length > 0) mediaid = 'serialId=' + serialList[i].id + '&programId=' + gProgramId + '&startTime=' + serialList[i].startTime + '&endTime=' + serialList[i].endTime;

        /////共享代码结束

        playList[i] = { 'sources': bitrateList, 'title': ' ' + serialList[i].name + ' ', 'tracks': captions, 'image': encodeURI(serialList[i].photo), mediaid: mediaid};

    }
    return playList;
}

//给共享中的图片中文名encode
function encodePhoto(url) {
    var nPos = 0;
    var nPos2 = 0;

    url = replaceAndChar(url);

    nPos = url.indexOf("@/");
    if (nPos > 0) {
        nPos2 = url.indexOf("?", nPos);
        if (nPos2 > 0) {
            var s1 = url.substring(0, nPos + 2);
            var s2 = encodeURIComponent(url.substring(nPos + 2, nPos2));//encodeURIComponent
            var s3 = url.substring(nPos2);

            url = s1 + s2 + s3;
        }
    }

    return url;
}

function initJWPlay() {
    var width = 740;
    var height = 360;
    var listbar = null;
    var playDivObj = document.getElementById("player");
    var lineStr = "";

    ///设置分享中的视频链接
    var shareUrlObj = document.getElementById("shareUrl");
    if (shareUrlObj) {
        shareUrlObj.value = document.location.href;
    }

    if (serialList == null || serialList.length == 0) {
        //height=340;
        playDivObj.innerHTML = "<img src='" + gPosterImg + "' width=" + width + " height=" + height + " />";
        return;
    }

    setLineRadios();//设置线路单选按钮

    playList = getPlayList();
    //连续剧设置相关属性，如height=340;
    if (playList.length > 1) {
        //height = 420;
        //listbar = { position: 'bottom',size: 75};
    }

    //作品
    if (fromPlayWeb == 1) {
        height = 360;
        width = 700;
    }

    //playDivObj.innerHTML = "<img width="+width+" height="+height+" />";

    jwplayer("player").setup({
        width: width,
        height: height,
        autostart: false,
        skin: baseUrl + "js/jwplayer/skins/beelden.xml",
        captions: {
            back: false
        },
        playlist: playList,
        //listbar:listbar,
        analytics: {
            enabled: false
        },
        events: {
            onPlaylistItem: function (curItemObj) {
                onJWPlay(curItemObj);
            },
            onPause: function () {
                if (fromPlayWeb == 0) clearTimeout(timeOut);
            }
        }

    });


}

//jwplay 播放事件
function onJWPlay(curItemObj) {
    //来源资源点播页面
    //alert("start play");
    if (fromPlayWeb == 0) {
        setShare(curItemObj);
        timeAdd();

        var index = jwplayer("player").getPlaylistItem().index;
        var indAll = getPlayListAllIndexById(serialList[index].id);
        setCurPhotoStyle(indAll);
    }
}

function setShare(curItemObj) {
    try {
        var playList = jwplayer("player").getPlaylist();
        var mediaid = playList[curItemObj.index].mediaid
        var shareEmbedObj = document.getElementById("shareEmbed");
        var flashUrlObj = document.getElementById("flashUrl");
        if (shareEmbedObj && flashUrlObj) {
            shareEmbedObj.value = "<iframe width=700 height=400 id='embedPlayFrame' src='http://" + document.location.host + "/program/embedPlay?" + mediaid + "' />";
            //flashUrlObj.value = playList[curItemObj.index].file;
            flashUrlObj.value = "http://" + document.location.host + "/program/embedPlay?" + mediaid + "";
        }
    }
    catch (e) {
        alert(e);
    }
}

function changePlayLine() {
    setCurPlayObj();
    jwplayer("player").stop();//没有判定状态，强行stop

    var playList = getPlayList();

    jwplayer().load(playList);

    jwplayer().playlistItem(curPlayObj.index);
    //alert(curPlayObj.position);
    //jwplayer().onPlaylistItem(jwplayer().seek(curPlayObj.position));
    //jwplayer().seek(125);

    //initJWPlay();
}

function workPlay() {
    fromPlayWeb = 1;//来源作品点播
    initJWPlay();
}

//设置当前播放对象
function setCurPlayObj() {
    curPlayObj.index = 0;
    //curPlayObj.position = 0;
    try {
        curPlayObj.index = jwplayer("player").getPlaylistItem().index;
        //curPlayObj.position = jwplayer("player").getPosition();
        //alert(+"="+jwplayer("player").getDuration());
    } catch (e) {
        curPlayObj.index = 0;
    }
}

function setLineRadios() {
    var lineDivObj = document.getElementById("lineListDiv");
    if (lineDivObj && !hasShowLine) {
        lineStr = '<b>线路切换：</b><input name="lineRadio" type="radio" value="" onclick="changePlayLine();" checked>默认&nbsp;';
        var arrLine = gLineList.split(";");
        for (var i = 0; i < arrLine.length; i++) {
            var arrSubLine = arrLine[i].split(",");
            if (arrSubLine.length > 1) lineStr += '<input name="lineRadio" type="radio" value="' + arrSubLine[0] + '" onclick="changePlayLine();">' + arrSubLine[1] + '&nbsp;';
        }

        lineStr += '&nbsp;&nbsp;&nbsp;&nbsp;如果播放不够流畅，您可以切换线路。';

        lineDivObj.innerHTML = lineStr;
        hasShowLine = true;
    }
}

//设置能用flash播放的列表
function setSerialList() {
    var ind = 0;
    var ulHtm = "";
    var hash = [];

    for (var i = 0; i < serialListAll.length; i++) {
        var serial = serialListAll[i];

        var isMp4 = false;//是否是mp4文件
        var urlLen = serial.playUrl.length;
        if (urlLen > 4) isMp4 = serial.playUrl.substring(urlLen - 4).toUpperCase() == '.MP4';

        //设置flash playlist 判定标准 serial.state == Serial.CODED_STATE 或url是.mp4
        if (serial.state == Serial.CODED_STATE || isMp4) {
            serialList[ind] = serial;
            hash[ind] = serial.fileHash;
            ind++;

        }

        //设置slider photo
        var photo = serial.photo;//以后可能要作处理,调用合适大小的缩略图

        ulHtm += '<li><a href="javascript:startPlay(' + i + ',' + (isMp4 ? 'true' : 'false') + ')" title="点击播放:' + serial.name + '">';
        ulHtm += ' <div class="sliderimg">';
        ulHtm += '  <img src="' + photo + '">';
        ulHtm += ' </div>';
        ulHtm += ' <div class="slidertext">' + serial.name;
        ulHtm += ' </div>';
        ulHtm += '</a></li>';
    }

    if (hash.length > 0) {
        /*jQuery.post(serialList[0].playUrl,{hash:hash},function(data){
         if(data.success){
         setSerialListPlayUrl(data);
         }
         else{alert("ajax get play url error.");};
         });*/
        $.post(baseUrl + "webMethod/proxy2", {url: serialList[0].playUrl, data: "hash=" + hash}, function (data) {
            if (data.success) {
                setSerialListPlayUrl(data);
            }
        }, "json");
    }


    var ulObj = document.getElementById("serialPhotosUl");
    ///如果多于一集，或者一集但未转码，显示小海报列表
    if (serialListAll.length > 1 || (serialListAll.length == 1 && serialList.length == 0)) {
        ulObj.innerHTML = ulHtm;
        document.getElementById("serialPhotosDiv").style.display = "block";
    }

    //如果没有其它的资源，则该div不显示
    var playClassObj = document.getElementById("playClassList");

    //href=判定标志要注意，如果页面作了改动，此标志要做相应改动！！！！
    if (!playClassObj || playClassObj.innerHTML.indexOf("href=") < 1) {
        document.getElementById("playClassDiv").style.display = "none";
    }

    //如果没有下载，则该div不显示
    var downClassObj = document.getElementById("downClassList");
    if (!downClassObj || downClassObj.innerHTML.length < 10) {
        var downClassDivObj = document.getElementById("downClassDiv");
        if (downClassDivObj) document.getElementById("downClassDiv").style.display = "none";
    }

    //tab页
    $(".webwidget_scroller_tab").webwidget_scroller_tab({
        scroller_time_interval: '3000',
        scroller_window_padding: '10',
        scroller_window_width: '1000',
        scroller_window_height: '490',
        scroller_head_text_color: '#0099FF',
        scroller_head_current_text_color: '#666',
        directory: 'images'
    });

}

//重新给serail.playUrl赋值
function setSerialListPlayUrl(data) {
    //{"success":true,"playList":[{"hash":"FBF18956DFBDAF048CE57BC28956D198","url":"http://server/media/video/FBF18956DFBDAF048CE57BC28956D198.mp4"},{"hash":"3C8E2CBF78C92EA7207CE8A97A93A664","url":"http://server/media/swf/3C8E2CBF78C92EA7207CE8A97A93A664.swf"}]}

    for (var i = 0; i < serialList.length; i++) {
        serialList[i].playUrl = data.playList[i].url;
        //alert(serialList[i].playUrl);
    }

    initJWPlay();
}

//参数serialListAll中索引
function startPlay(ind, isMp4) {
    try {
        jwplayer("player").stop();//没有判定状态，强行stop
    } catch (e) {
    }

    var serial = serialListAll[ind];
    if (serial) {
        //已转码的用jwplayer播放
        if (serial.state == Serial.CODED_STATE || isMp4) {
            var jwInd = getPlayListIndexById(serial.id);//播放列表中的serialList中的索引
            jwplayer().playlistItem(jwInd);

        } else {
            playProgram(serial.playUrl, serial.programId, serial.urlType, 1, 0, 0, serial.id, serial.transcodeState);

        }

        setCurPhotoStyle(ind);
    }
}

//设置正在播放的图片样式，serialListAll中的索引
function setCurPhotoStyle(ind) {

    var obj = document.getElementById("serialPhotosUl");
    if (obj) {
        for (var i = 0; i < obj.children.length; i++) {
            var liObj = obj.children[i];
            if (i == ind) {
                if (fromPlayWeb = 2)
                    liObj.className = "select";
                else
                    liObj.className = "curPlayPhoto";
            }
            else {
                liObj.className = "";
            }
        }
    }
}

//获得播放列表中的serialList中的索引
function getPlayListIndexById(id) {
    var ind = 0;
    for (var i = 0; i < serialList.length; i++) {
        if (serialList[i].id == id) return i;
    }

    return ind;
}

//获得播放列表中的serialListAll中的索引
function getPlayListAllIndexById(id) {
    var ind = 0;
    for (var i = 0; i < serialListAll.length; i++) {
        if (serialListAll[i].id == id) return i;
    }

    return ind;
}

//多集图片列表及滚动条 length*144-14:container2 ul li中:length*(width+margin-right)-(margin-right)
function showSerialSlide() {
    try {
        jQuery(".container2").hScrollPane({
            mover: "ul",
            moverW: function () {
                return jQuery(".container2 li").length * 144 - 14;
            }(),
            showArrow: true,
            handleCssAlter: "draghandlealter",
            mousewheel: {moveLength: 207}
        });

        //设置ul长度;
        var ulObj = document.getElementById("serialPhotosUl");
        if (ulObj) ulObj.style.width = (serialListAll.length * 144 - 14 + 50) + "px";
        //alert(ulObj.style.width);
    } catch (e) {
        alert(e)
    }
}

//------------------嵌入式播放结束-----------------------


//tab页,为了避免请求过多，对应webwidget_scroller_tab.js
(function (a) {
    a.fn.webwidget_scroller_tab = function (p) {
        var p = p || {};

        var s_t_i = p && p.scroller_time_interval ? p.scroller_time_interval : "3000";
        var s_w_p = p && p.scroller_window_padding ? p.scroller_window_padding : "5";
        var s_w_w = p && p.scroller_window_width ? p.scroller_window_width : "350";
        var s_w_h = p && p.scroller_window_height ? p.scroller_window_height : "270";
        var s_h_t_c = p && p.scroller_head_text_color ? p.scroller_head_text_color : "blue";
        var s_h_c_t_c = p && p.scroller_head_current_text_color ? p.scroller_head_current_text_color : "black";
        var d = p && p.directory ? p.directory : "images";
        var dom = a(this);
        var s_length = dom.children(".tabBody").children("ul").children("li").length;
        var timer;
        var current = 0;
        var li_width;
        s_w_p += "px";
        s_w_w += "px";
        s_w_h += "px";

        if (dom.find("ul").length == 0 || dom.find("li").length == 0) {
            dom.append("Require content");
            return null;
        }
        begin();
        play();
        function begin() {
            dom.width(s_w_w);
            dom.height(s_w_h);
            li_width = parseInt(s_w_w) - 2;
            dom.children(".tabBody").width(parseInt(s_w_w) - 2);
            dom.children(".tabBody").height(parseInt(s_w_h) - 28 - 4);
            dom.children(".tabBody").children("ul").width((parseInt(s_w_w) - 2) * s_length);
            dom.children(".tabBody").children("ul").height(parseInt(s_w_h) - 28 - 4);
            dom.children(".tabBody").children("ul").children("li").width(parseInt(s_w_w) - 2);
            dom.children(".tabBody").children("ul").children("li").height(parseInt(s_w_h) - 28 - 4);
            dom.children(".tabBody").children("ul").children("li").children("p").css("padding", s_w_p);
            dom.children(".tabContainer").children(".tabHead").children("li").children("a").css("color", s_h_t_c);
            dom.children(".tabContainer").children(".tabHead").children("li").children("a").click(function () {
                current = dom.children(".tabContainer").children(".tabHead").children("li").index($(this).parent());
                play();
                stop()
            });
            dom.hover(
                function () {
                    stop();
                },
                function () {
                    //timer = setTimeout(play,s_t_i);
                }
            );
        }

        function stop() {
            clearTimeout(timer);
        }

        function play() {
            clearTimeout(timer);
            var to_location = -(current * li_width) + "px";
            dom.children(".tabBody").children("ul").animate({
                left: to_location
            }, 500);
            dom.children(".tabContainer").children(".tabHead").children("li").children("a").css("color", s_h_t_c);
            dom.children(".tabContainer").children(".tabHead").children("li").removeClass("currentBtn")
            dom.children(".tabContainer").children(".tabHead").children("li").eq(current).children("a").css("color", s_h_c_t_c);
            dom.children(".tabContainer").children(".tabHead").children("li").eq(current).addClass("currentBtn");
            if (current >= s_length - 1) {
                current = 0;
            } else {
                current++;
            }
            //timer = setTimeout(play,s_t_i);
        }
    }
})(jQuery);

////////////////////////手机 start
function phonePlay() {
    var width = 300; //"98%";
    var height = 400;
    var listbar = null;
    var playDivObj = document.getElementById("player");

    if (fromPlayWeb == 3 || fromPlayWeb == 4) {
        width = "98%";
        height = "98%";
    }
    else {
        width = "98%";
        height = "98%";
    }

    if (serialList == null || serialList.length == 0) {
        //height=340;
        playDivObj.innerHTML = "<img src='" + gPosterImg + "' width=" + width + "  />";
        return;
    }

    playList = getPlayList();

    jwplayer("player").setup({
        width: width,
        //height: 234,
        autostart: false,
        //skin: baseUrl + "jwplayer/skins/beelden.xml",
        captions: {
            back: false
        },
        playlist: playList,
        //listbar:listbar,
        analytics: {
            enabled: false
        },
        events: {
            onPlaylistItem: function (curItemObj) {
                curPlayObj.index = curItemObj.index;
            },
            onPlay: function (obj) {
                var video = playList[curPlayObj.index].sources[0].file;
                //alert(video);
                //onJWPlay(curItemObj);
                playVideo(video);
                jwplayer("player").stop();
            }
        }
    });

}


function setPhoneSerialList() {
    var ulHtm = "";
    var ulObj = document.getElementById("serialPhotosUl");
    ///如果多于一集，或者一集但未转码，显示小海报列表
    //<li class="select"><a href="./test.html" title="第2集">第2集</a></li>

    if (serialListAll.length > 1) {
        var className = "";
        for (var i = 0; i < serialListAll.length; i++) {
            className = (i == 0 ? "select" : "");
            var serial = serialListAll[i];
            if (fromPlayWeb == 2)
                ulHtm += '<li><a href="javascript:startPlay(' + i + ',true);" class="' + className + '">' + serial.name + '</a></li>';
            else if (fromPlayWeb == 3)
                ulHtm += '<a href="javascript:startPlay(' + i + ',true);" class="' + className + '">' + serial.name + '</a>';
        }

        ulObj.innerHTML = ulHtm;
        var serialPhotosDivObj = document.getElementById("serialPhotosDiv");
        if (serialPhotosDivObj) serialPhotosDivObj.style.display = "block";
    }

}

function playVideo(video) {
    window.JSInterface.startVideo(video);
    //alert(video);

}

function popBox(id) {
    var newdiv = document.createElement("div");
    newdiv.style.position = "absolute";
    newdiv.style.top = "150px";
    newdiv.style.left = "100px";
    newdiv.style.height = "50px";
    newdiv.style.width = "550px";
    //newdiv.style.backgroundColor="#fff000"
    newdiv.innerHTML = "您好！对不起，权限不够，不能点播，请联系管理员。";
    newdiv.className = "alertDiv"
    id.appendChild(newdiv);//将生成的div层插入到指定的节点内,成为其最后一个子节点；
}

////////////////////////手机 end