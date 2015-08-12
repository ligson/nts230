function GlobalVars() {
    this.programId = 0;
    this.classId = 1;
    this.metaList = [];
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
    this.showOpt = 1;//编目项显示" 0 简单 1缺省 2所有
    this.usename = "test";//显示所有编目项
    this.pwd = "testpwd";//显示所有编目项
    this.uploadType = -1;//字幕上传1000,富文本上传2000,子目上传3000

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

global = new GlobalVars();
var bShowPx = false;//是否已显示了排序提示
var gDateId = 0;//排序日期元素ID

var SHOW_OPT_SIMPLE = 0;	//globalVars.showOpt=0;//编目项显示" 0 简单 1缺省 2所有
var SHOW_OPT_DEFAULT = 1;
var SHOW_OPT_ALL = 2;

var UPLOAD_TYPE_SUBTITLE = 1000;	//globalVars.uploadType=-1;
var UPLOAD_TYPE_FCK = 2000;
var UPLOAD_TYPE_SERIAL_PHOTO = 3000;

var imgDialog = null;//富文本图片对话框对象
var metaList = [];//当前类
var Serial = {NO_NEED_STATE: 0, NO_CODE_STATE: 1, CODING_STATE: 2, CODED_STATE: 3, CODED_FAILED_STATE: 4};

function init() {

    setCurMetaList(global.classId, -1, -1);//显示当前类下所有元数据
    showAllTr();
    //alert(wtab.innerHTML);
}


/////////元数据开始
//修饰词变化时
function onDecoChange(theSelObj)//theSelObj是修饰词下拉框//vInd是metaList数组的下标
{
    var vStr, vValue, vField;
    var vId = theSelObj.value;
    var isFirstTitle = false;
    var useMetaobj = getMetaFromId(vId);
    var metaObj = null;
    var vBlur = "";

    if (useMetaobj != null) {
        metaObj = getMetaFromId(useMetaobj.parentId);
        vField = theSelObj.parentElement.nextSibling.firstChild;
        vValue = vField.value;
        if (vValue == null || vValue == "")
            vValue = useMetaobj.defaultValue;

        /*if(useMetaobj.parentId==global.titleId && isFirstTitle)
         {
         isFirstTitle=(vField.onblur) != null;
         if(isFirstTitle)
         {
         global.firstTitleId=vId;
         //vBlur='onBlur="setUpSubPath();"';
         }
         }*/

        if (useMetaobj.dataType == "enumeration") {
            vStr = '<select name="id_' + useMetaobj.selfId + '">\n';
            vStr += '<option value="-1">-请选择-</option>\n';
            for (ij = 0; ij < useMetaobj.arrEnum.length; ij++) {
                vStr += '<option value="' + useMetaobj.arrEnum[ij].id + '" ' + (useMetaobj.defaultValue == useMetaobj.arrEnum[ij].id ? 'selected' : '') + '>' + useMetaobj.arrEnum[ij].name + '</option>\n';
            }
            vStr += '</select>\n';
        }
        else if (useMetaobj.dataType == "textarea") {
            vStr = '<TEXTAREA class="text-input datepicker" name="id_' + useMetaobj.selfId + '">' + vValue + '</TEXTAREA>';
        }
        else if (useMetaobj.dataType == "number") {
            vStr = '<input class="text-input datepicker" name="id_' + useMetaobj.selfId + '" type="text" maxlength="18" value="' + vValue + '">';
        }
        else if (useMetaobj.dataType == "link") {
            vStr = '<input class="text-input datepicker" name="id_' + useMetaobj.selfId + '" type="hidden" value="' + useMetaobj.defaultValue + '">';
            vStr += '链接地址<input type="text" style="width:180;" name="lkaddr_' + useMetaobj.selfId + '" onBlur="setLink(this,' + useMetaobj.selfId + ')">';
            vStr += '链接显示<input type="text" style="width:130;" name="lkshow_' + useMetaobj.selfId + '" value="" onBlur="setLink(this,' + useMetaobj.selfId + ')">';
        }
        else if (useMetaobj.dataType == "date") {
            if (vField.id && vField.id == "px")
                vStr = '<input id="px" style="width:120px;" name="id_' + useMetaobj.selfId + '" type="text" maxlength="' + Math.floor(useMetaobj.maxLen / 2) + '" value="' + useMetaobj.defaultValue + '" onClick="return Calendar(\'px\');">(日期格式:2005-01-01)';
            else
                vStr = '<input style="width:120px;" id="id_' + useMetaobj.selfId + '" name="id_' + useMetaobj.selfId + '" type="text" maxlength="' + Math.floor(useMetaobj.maxLen / 2) + '" value="' + useMetaobj.defaultValue + '" onClick="return Calendar(\'id_' + useMetaobj.selfId + '\');"><img src="images/space.gif" width="2">(日期格式:2005-01-01)';
        }
        else {
            vStr = '<input class="text-input datepicker" name="id_' + useMetaobj.selfId + '" type="text" maxlength="' + Math.floor(useMetaobj.maxLen / 2) + '" value="' + vValue + '" ' + vBlur + '>';
        }

        if (metaObj.repeatNum == 0)
            vStr += '&nbsp;&nbsp;<input type="button" class="button" style="width:40px;" value="增加" onclick="addTr(' + metaObj.index + ')">';
        else {
            if (theSelObj == eval("form1.id_" + useMetaobj.parentId + "[0]"))
                vStr += '&nbsp;&nbsp;<input type="button" class="button" style="width:40px;" value="增加" onclick="addTr(' + metaObj.index + ')">';
            else
                vStr += '&nbsp;&nbsp;<input type="button" class="button" style="width:40px;" value="删除" onclick="delTr(this)">';
        }

        theSelObj.parentElement.nextSibling.innerHTML = vStr;

        //修饰词中是否有必选项，如果有，须显示此行且第一列加*号
        //alert(theSelObj.parentNode.parentNode.firstChild.innerHTML);
        theSelObj.parentNode.parentNode.firstChild.innerHTML = "<label>" + ((useMetaobj.isNecessary == 1 || useMetaobj.dataType == "enumeration") ? "<font color=red>*</font>" : "") + metaObj.cnName + ':</label>';
    }
}

function setLink(theSelObj, vMID) {
    var vLinkField = theSelObj.parentElement.childNodes[0];
    var sLkAddr = theSelObj.parentElement.childNodes[2].value;
    var sLkShow = theSelObj.parentElement.childNodes[4].value;

    if (sLkAddr != null && sLkAddr != "" && sLkShow != null && sLkShow != "") {
        if (sLkAddr.indexOf("://") < 1) sLkAddr = "http://" + sLkAddr;
        vLinkField.value = '<a href="' + sLkAddr + '" target="_blank">' + sLkShow + '</a>';
    }
    //alert(vLinkField.value);
}

function addTr(vInd) {
    var iRow;
    if (vInd >= 0) {
        iRow = getDecoLastRow(vInd) + 1;
    }
    else {
        alert("行参数错误！");
    }

    metaList[vInd].repeatNum++;
    showTr(iRow, vInd);
}

//得到修饰词最后一行的索行引
function getDecoLastRow(vInd) {
    var i, iRow;
    var rowsLen = wtab.rows.length;
    for (i = 0; i < rowsLen; i++) {
        if (wtab.rows[i].id == ("ind_" + vInd))
            iRow = i;
    }
    return iRow;
}

function delTr(theDelbtn) {
    var i, iRow;

    var theDelTr = theDelbtn.parentElement.parentElement;
    for (i = 0; i < wtab.rows.length; i++) {
        if (wtab.rows[i] == theDelTr) {
            iRow = i;
            break;
        }
    }


    var vTrID = wtab.rows[iRow].id;//形如：ind_2
    var vInd = vTrID.substring(4, vTrID.length);

    metaList[vInd].repeatNum--;
    wtab.deleteRow(iRow);
}

//获取元素是否显示
function getMetaDisplay(metaObj) {
    var bDisplay = false;

    if (global.showOpt == SHOW_OPT_SIMPLE) {
        if (metaObj.selfId == global.titleId || metaObj.selfId == global.metaCreatorId) bDisplay = true;
    }
    else if (global.showOpt == SHOW_OPT_DEFAULT) {
        if (metaObj.isNecessary == 1 || metaObj.dataType == "enumeration" || ((metaObj.showType & global.showType.DEFAULT) == global.showType.DEFAULT)) bDisplay = true;
    }
    else {
        bDisplay = true;
    }

    //修饰词中是否有必选项或者有枚举类型，如果有，须显示
    if (!bDisplay && global.showOpt != SHOW_OPT_SIMPLE) {
        if (metaObj.dataType == "decorate") {
            for (var k = 0; k < metaList.length; k++) {
                if (metaList[k].parentId == metaObj.selfId) {
                    if (global.showOpt == SHOW_OPT_DEFAULT && (metaList[k].isNecessary == 1 || metaList[k].dataType == "enumeration")) {
                        bDisplay = true;
                        break;
                    }
                }
            }
        }
    }

    return bDisplay;
}

// iRow是在第几行显示 vInd是metaList数组的下标 
function showTr(iRow, vInd) {
    var vStr, metaObj, vStar, vClassid, firstDecoObj, creatorObj, vBlur;
    vClassid = global.classId;
    metaObj = metaList[vInd];
    wtab.insertRow(iRow);
    wtab.rows[iRow].id = "ind_" + vInd;
    var bDisplay = getMetaDisplay(metaObj);

    wtab.rows[iRow].style.display = bDisplay ? "block" : "none";

    var j, k, m, ij;
    for (j = 0; j < global.tdNum; j++) {
        wtab.rows[iRow].insertCell(j);
        if (j == 0) {
            wtab.rows[iRow].cells[j].width = "140px";
            wtab.rows[iRow].cells[j].className = "nobor_d";
            vStr = '<label>';
            vStr += (metaObj.isNecessary == 1 ? "<font color=red>*</font>" : "") + metaObj.cnName + ':</label>';
            wtab.rows[iRow].cells[j].innerHTML = vStr;
        }
        else if (j == 1) {
            //wtab.rows[iRow].cells[j].width = "160";
            //wtab.rows[iRow].cells[j].align="center";
            vStr = "";
            firstDecoObj = null;

            if (metaObj.dataType == "decorate") {
                vStr = '<select style="margin-left: 15px" class="admin_default_inp" name="id_' + metaObj.selfId + '" onchange="onDecoChange(this);">\n';
                for (k = 0; k < metaList.length; k++) {

                    if (metaList[k].parentId == metaObj.selfId) {
                        vStr += '<option value="' + metaList[k].selfId + '">' + metaList[k].cnName + '</option>\n';

                        if (firstDecoObj == null) {
                            firstDecoObj = metaList[k];//用于设置后面一列是文本框，大文本框或是下拉框

                        }

                        //修饰词中是否有必选项，如果有，须显示此行且第一列加*号
                        if (global.showOpt != SHOW_OPT_SIMPLE && metaList[k].isNecessary == 1) {
                            wtab.rows[iRow].style.display = "block";
                            if (firstDecoObj.isNecessary == 1 || firstDecoObj.dataType == "enumeration") wtab.rows[iRow].cells[0].innerHTML = "<label><font color=red>*</font>" + metaObj.cnName + ':</label>';
                        }
                    }
                }

                if (firstDecoObj == null) {

                    wtab.deleteRow(iRow);
                    return false;
                }
                wtab.rows[iRow].cells[j].className = "nobor";
                vStr += '</select>\n';

            }
            wtab.rows[iRow].cells[j].innerHTML = vStr;
        }
        else if (j == 2) {
            vStr = "";
            //如果是修饰词，第四列表单元素的类型是第一个修饰词的类型，否则由第二列元素的类型
            var useMetaobj = metaObj.dataType == "decorate" ? firstDecoObj : metaObj;

            if (useMetaobj == null)
                return;

            //修改时不用缺省值，主要是导入数据时有的没值
            defaultValue = global.programId < 1 ? useMetaobj.defaultValue : "";

            if (useMetaobj.dataType == "enumeration") {
                vStr = '<select class="admin_default_inp" style="float: left" name="id_' + useMetaobj.selfId + '">\n';
                vStr += '<option value="-1">-请选择-</option>\n';
                for (ij = 0; ij < useMetaobj.arrEnum.length; ij++) {
                    vStr += '<option value="' + useMetaobj.arrEnum[ij].id + '" ' + (defaultValue == useMetaobj.arrEnum[ij].id ? 'selected' : '') + '>' + useMetaobj.arrEnum[ij].name + '</option>\n';
                }
                vStr += '</select>\n';

                //如果是枚举类型，须显示此行
                if (global.showOpt != SHOW_OPT_SIMPLE) {
                    wtab.rows[iRow].style.display = "block";
                    wtab.rows[iRow].cells[0].innerHTML = "<label><font color=red>*</font>" + metaObj.cnName + ':<label>';
                }

            }
            else if (useMetaobj.dataType == "textarea") {
                vStr = '<TEXTAREA class="text-input datepicker" name="id_' + useMetaobj.selfId + '" rows="3">' + defaultValue + '</TEXTAREA>';
            }
            else if (useMetaobj.dataType == "number") {
                vStr = '<input class="text-input datepicker" name="id_' + useMetaobj.selfId + '" type="text" maxlength="16" value="' + defaultValue + '">';
            }
            else if (useMetaobj.dataType == "link") {
                vStr = '<input class="text-input datepicker" name="id_' + useMetaobj.selfId + '" type="hidden" value="' + defaultValue + '">';
                vStr += '链接地址<input style="width:200px;" name="lkaddr_' + useMetaobj.selfId + '" type="text" onBlur="setLink(this,' + useMetaobj.selfId + ')">';
                vStr += '&nbsp;链接显示<input type="text" style="width:130px;" name="lkshow_' + useMetaobj.selfId + '" value="" onBlur="setLink(this,' + useMetaobj.selfId + ')">';
            }
            else if (useMetaobj.dataType == "date") {
                vStr = '<input class="text-input datepicker" id="' + (bShowPx ? useMetaobj.selfId : 'px') + '" style="width:120px;" name="id_' + useMetaobj.selfId + '" type="text" maxlength="' + Math.floor(useMetaobj.maxLen / 2) + '" value="' + defaultValue + '" onClick="return Calendar(\'' + (bShowPx ? ('id_' + useMetaobj.selfId) : 'px') + '\');">(日期格式:2005-01-01)';
                if (useMetaobj.parentId == gDateId && bShowPx == false)
                    bShowPx = true;
            }
            else {
                vBlur = "";
                /*if(global.firstTitleId<1 && useMetaobj.parentId==global.titleId)
                 {
                 global.firstTitleId=useMetaobj.selfId;
                 //vBlur='onBlur="setUpSubPath();"';
                 }*/
                vStr = '<input class="admin_default_inp" style="float: left" name="id_' + useMetaobj.selfId + '" type="text" maxlength="' + Math.floor(useMetaobj.maxLen / 2) + '" value="' + defaultValue + '" ' + vBlur + '>';
            }

            if (metaObj.dataType == "decorate" || useMetaobj.selfId == global.disciplineId || metaObj.dataType == "link" || metaObj.dataType == "enumeration") {
                if (metaObj.repeatNum == 0)
                    vStr += '&nbsp;&nbsp;<input type="button" class="btn btn-success"  value="增加" onclick="addTr(' + vInd + ')">';
                else
                    vStr += '&nbsp;&nbsp;<input type="button" class="btn btn-success"  value="删除" onclick="delTr(this)">';
            }

            wtab.rows[iRow].cells[j].className = "nobor_x";

            wtab.rows[iRow].cells[j].innerHTML = vStr;
        }
    }

    return true;
}

//验证输入
function check() {
    var i, j, repeatNum, theSelObj, theInput, curDecoObj;
    var formName = "form1";
    var objTr = null;

    try {
        for (i = 0; i < metaList.length; i++) {
            objTr = document.getElementById("ind_" + i);
            if (objTr == null)
                continue;

            repeatNum = metaList[i].repeatNum;

            for (j = 0; j <= repeatNum; j++) {
                if (metaList[i].dataType == "decorate") {
                    if (j == 0 && repeatNum == 0)
                        theSelObj = eval(formName + ".id_" + metaList[i].selfId);
                    else
                        theSelObj = eval(formName + ".id_" + metaList[i].selfId + "[" + j + "]");

                    if (theSelObj == null)
                        continue;
                    theInput = theSelObj.parentElement.nextSibling.firstChild;
                    curDecoObj = getMetaFromId(theSelObj.value);
                }
                else if (metaList[i].parentId == 0 && metaList[i].dataType != "decorate") {
                    //alert(metaList[i].cnName);
                    if (j == 0 && repeatNum == 0)
                        theInput = eval(formName + ".id_" + metaList[i].selfId);
                    else
                        theInput = eval(formName + ".id_" + metaList[i].selfId + "[" + j + "]");

                    curDecoObj = metaList[i];
                }
                else {
                    continue;
                }

                if (curDecoObj == null || theInput == null)
                    continue;

                if (objTr.style.display != "none") {
                    if (curDecoObj.isNecessary == 1) {
                        if (Jtrim(theInput.value) == "") {
                            alert("请在" + curDecoObj.cnName + "中输入值。");
                            theInput.value = Jtrim(theInput.value);
                            if (theInput.type != "hidden") inputFocus(theInput);
                            return false;
                        }
                    }

                    //枚举类型必须选择一个值,不管是否必须
                    if (curDecoObj.dataType == "enumeration") {
                        if (theInput.value == -1) {
                            alert("请选择" + curDecoObj.cnName + "。");
                            inputFocus(theInput);
                            return false;
                        }
                    }

                    if (curDecoObj.dataType == "number") {
                        if (isNaN(theInput.value)) {
                            alert("请在" + curDecoObj.cnName + "中输入数字值。");
                            inputFocus(theInput);
                            return false;
                        }
                    }

                    if (curDecoObj.dataType == "date") {
                        if (Jtrim(theInput.value).length > 0 && !isValidDate(Jtrim(theInput.value))) {
                            alert("请在" + curDecoObj.cnName + "中按格式:2005-01-01输入或选择日期。");
                            inputFocus(theInput);
                            return false;
                        }
                    }

                    if (curDecoObj.dataType == "time") {
                        if (Jtrim(theInput.value).length > 0 && !isValidTime(Jtrim(theInput.value))) {
                            alert("请在" + curDecoObj.cnName + "中按格式:01:01正确输入时间。");
                            inputFocus(theInput);
                            return false;
                        }
                    }

                    var isUniqueExist = false;
                    if ((curDecoObj.showType & global.showType.UNIQUE) == global.showType.UNIQUE) {
                        if (Jtrim(theInput.value) != "") {
                            var checkUrl = baseUrl + 'program/checkMetaUnique?programId=' + global.programId + '&metaId=' + curDecoObj.selfId + '&value=' + encodeURIComponent(Jtrim(theInput.value));

                            try {
                                new Ajax.Request(checkUrl, {
                                        asynchronous: false,
                                        onComplete: function (transport) {
                                            //alert(transport.responseText);
                                            if (transport.responseText != "ok") {
                                                if (transport.responseText == "exist")
                                                    alert(curDecoObj.cnName + "不允许重复，请重新输入值。");
                                                else
                                                    alert(curDecoObj.cnName + "检查重复性时出错，请重新提交。");

                                                try {
                                                    inputFocus(theInput);
                                                }
                                                catch (err) {
                                                    //ddd
                                                }

                                                isUniqueExist = true;

                                            }
                                        }
                                    }
                                );
                            } catch (e) {
                                $.post(checkUrl, {}, function (data) {
                                    if (data != "ok") {
                                        if (data == "exist")
                                            alert(curDecoObj.cnName + "不允许重复，请重新输入值。");
                                        else
                                            alert(curDecoObj.cnName + "检查重复性时出错，请重新提交。");

                                        try {
                                            inputFocus(theInput);
                                        }
                                        catch (err) {
                                            //ddd
                                        }

                                        isUniqueExist = true;

                                    }
                                });
                            }


                            if (isUniqueExist) return false;
                        }
                    }

                    if (curDecoObj.dataType == "textarea") {
                        if ((theInput.value).length > Math.floor(curDecoObj.MaxLen / 2)) {
                            alert("在" + curDecoObj.cnName + "中最多能输入" + Math.floor(curDecoObj.MaxLen / 2) + "个字。");
                            inputFocus(theInput);
                            return false;
                        }
                    }
                }

            }
        }

        /*if(!isInputTag())
         {
         alert("请至少输入一个"+global.tagName+"。");
         form1.programTag[0].focus();
         return false;
         }

         if(Jtrim(document.form1.description.value) == "" || document.form1.description.value == '有关资源内容的自由文本描述 ，包括文摘、目次')
         {
         alert("请在"+global.resDescription+"中输入值。");
         form1.description.focus();
         return false;
         }*/

        /*if(!document.form1.idList)
         {
         alert("请上传或提取资源。");
         form1.showPath.focus();
         return false;
         }*/
    }
    catch (e) {
        alert('错误号:' + i + " " + metaList[i].name + e.message);
        return false;
    }

    return true;
}
/////////元数据结束


//将复选框中的所有值转换成1,2,3,5的字符串值
function getListStr(checkBoxName) {
    var listStr = "";
    var checkBoxs = document.getElementsByName(checkBoxName);
    for (var i = 0; i < checkBoxs.length; i++) {
        if (checkBoxs[i].checked) {
            listStr += "," + checkBoxs[i].value;
        }
    }
    if (listStr != "") listStr = listStr.substring(1);
    return listStr;
}


//字符串左边补0，字符串位数charNum不大于10;
function padLeftZero(str, charNum) {
    if (str == null || str == "") return "00";

    var s = "0000000000" + str;
    s = s.substring(s.length - charNum);
    return s;
}


//yyyy-mm-dd格式
function isValidDate(vDate) {
    if (vDate == null || vDate == "")
        return false;
    var arrDate = vDate.split("-");
    if (arrDate.length != 3)
        return false;
    if (arrDate[0].length != 4 || !isNum2(arrDate[0], 1000))
        return false;
    if (arrDate[1].length != 2 || !isNum2(arrDate[1], 1, 12))
        return false;
    if (arrDate[2].length != 2 || !isNum2(arrDate[2], 1, 31))
        return false;
    if ((arrDate[1] == 4 || arrDate[1] == 6 || arrDate[1] == 9 || arrDate[1] == 11) && (arrDate[2] == 31))
        return false;
    if (arrDate[1] == 2) {
        var leap = (arrDate[0] % 4 == 0 && (arrDate[0] % 100 != 0 || arrDate[0] % 400 == 0));
        if (arrDate[2] > 29 || (arrDate[2] == 29 && !leap)) {
            return false;
        }
    }

    return true;
}


//设置显示缺省还是所有
function setShowType(n) {
    global.showOpt = n;


    for (var i = 1; i < 3; i++) {
        curTabObj = document.getElementById("tab" + i);
        curTabObj.className = i == n ? "cur" : "";
    }

    $(".gblue").remove();
    reShowAllTr();
    //setTimeout("parent.parent.setFrameHeight(parent.myMainFrame)", 10);
}

//设置行的显示或隐藏，用于显示缺省还是所有
function reShowAllTr() {

    var metaObj = null;
    var vInd = 0;
    var bDisplay = true;

    for (var i = 0; i < wtab.rows.length; i++) {
        var objTr = wtab.rows[i];
        if (objTr.id.indexOf('ind_') != -1) {
            vInd = parseInt(objTr.id.substring(4));
            metaObj = metaList[vInd];
            bDisplay = getMetaDisplay(metaObj);
            objTr.style.display = bDisplay ? "block" : "none";
        }

    }
}

//焦点移到输入框,因为输入框不可见时会出错
function inputFocus(theInput) {
    try {
        theInput.focus();
    }
    catch (e) {
        $("#showOpt_1").click();
        theInput.focus();
    }
}


//替换掉题名作为文件夹中特殊字符
function dirNameReplace(dirName) {
    if (dirName == null || dirName == "") return "";
    dirName = dirName.replace(/[\ |\~|\`|\!|\@|\#|\$|\%|\^|\&|\*|\(|\)|\-|\_|\+|\=|\||\\|\[|\]|\{|\}|\;|\:|\"|\'|\,|\<|\.|\>|\/|\?]/g, "");
    return dirName;
}


function getArrCont(vMetaId, bDeco) {
    var vArr = new Array();
    var i, j, id;
    j = 0;
    if (bDeco) {
        for (i = 0; i < contentList.length; i++) {
            if (contentList[i].metaParentId == vMetaId) {
                vArr[j] = contentList[i];
                j++;
            }
        }
    }
    else {
        for (i = 0; i < contentList.length; i++) {
            if (contentList[i].metaId == vMetaId) {
                vArr[j] = contentList[i];
                j++;
            }
        }
    }

    return vArr;
}


//初始化时显示所有元素列表，重复条目下拉框，设置行数下拉框
function showAllTr() {
    if (global.programId > 0) showAllTrEdit();
    else showAllTrAdd();
}

//初始化时显示所有元素列表，重复条目下拉框，设置行数下拉框
function showAllTrAdd() {
    var i, iRow, iRow2;
    var curClassid = global.classId;
    iRow = 0;
    iRow2 = 0;

    for (i = 0; i < metaList.length; i++) {
        if (metaList[i].parentId == 0) {
            if (showTr(iRow, i) == false)
                continue;
            iRow++;
        }
    }

}

function showAllTrEdit() {
    var i, j, k, ii, iRow, iRow2;
    var theMetaOjb, theTrObj;
    var vArr, bDeco;
    var vCell3;//列3
    var iRow = 0;

    for (i = 0; i < metaList.length; i++) {

        theMetaOjb = metaList[i];
        if (theMetaOjb.parentId == 0) {

            bDeco = theMetaOjb.dataType == "decorate";
            vArr = getArrCont(theMetaOjb.selfId, bDeco);

            if (vArr != null && vArr.length > 0) {
                for (ii = 0; ii < vArr.length; ii++) {

                    if (showTr(iRow, theMetaOjb.index) == false) continue;
                    if (bDeco) {
                        wtab.rows[iRow].cells[1].firstChild.value = vArr[ii].metaId;
                        onDecoChange(wtab.rows[iRow].cells[1].firstChild);
                        wtab.rows[iRow].cells[2].firstChild.value = vArr[ii].dataType == 1 ? vArr[ii].numContent : Jtrim(vArr[ii].strContent);
                    }
                    else {
                        wtab.rows[iRow].cells[2].firstChild.value = vArr[ii].dataType == 1 ? vArr[ii].numContent : Jtrim(vArr[ii].strContent);
                        if (theMetaOjb.dataType == "img" && Jtrim(vArr[ii].strContent) != "") {
                            var showImg = wtab.rows[iRow].cells[2].childNodes[10];
                            showImg.style.display = "inline";
                        }
                        else if (theMetaOjb.dataType == "link" && Jtrim(vArr[ii].strContent) != "") {
                            var arrLink = getArrLink(vArr[ii].strContent);
                            wtab.rows[iRow].cells[2].childNodes[2].value = arrLink[0];
                            wtab.rows[iRow].cells[2].childNodes[4].value = arrLink[1];
                        }
                    }
                    //theMetaOjb.repeatNum++;
                    iRow++;
                }
                theMetaOjb.repeatNum = vArr.length - 1;
            }
            else {
                if (showTr(iRow, theMetaOjb.index) == false) continue;
                iRow++;

            }
        }
    }

}


//修改时更改类库
function onClassChangeEdit(theObj) {
    if (theObj.value < 1) {
        alert("请选择类库");
        document.getElementById("mainDiv").style.display = "none";
        return;
    }
    else if (theObj.value != theObj.form.oldClassLibId.value) {
        self.location.href = baseUrl + "program/changeLib?programId=" + global.programId + "&newClassLibId=" + theObj.value + "&oldClassLibId=" + theObj.form.oldClassLibId.value;
    }

}

//获得global.firstTitleId
function getFirstTitleId() {
    var id = 0;
    var obj = document.form1.id_1;

    //考虑有多个题名
    id = typeof(obj.options) == "undefined" ? obj[0].value : obj.value;

    return id;
}

$(function () {
    $("#closeBtn").click(function () {
        self.location.href = baseUrl + "my/myManageProgram";
    });
});